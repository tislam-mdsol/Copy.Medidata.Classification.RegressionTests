using System;
using System.IO;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Helpers;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.OdmBuilder;
using NUnit.Framework;
using TechTalk.SpecFlow;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class StepHooks
    {
        private readonly StepContext _StepContext;

        public StepHooks(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");

            _StepContext = stepContext;
        }

        [BeforeTestRun]
        public static void BeforeTestRun()
        {
            CreateScreenshotDirectory();
        }

        [BeforeScenario("CoderCore")]
        public void BeforeCoreScenario()
        {
            var generatedUser = CoderUserGenerator.GenerateUser(Config.StudyNamePrefix);

            _StepContext.CoderTestUser    = generatedUser.User;
            _StepContext.SegmentUnderTest = generatedUser.Segment;
            _StepContext.SetContextFromGeneratedUser(true);

            CommonBeforeScenario(_StepContext);
            
            _StepContext.Browser.CoderCoreLogin(_StepContext.User);
        }

        [BeforeScenario("EndToEnd")]
        public void BeforeEndToEndScenario()
        {
            _StepContext.User                  = Config.Login;
            _StepContext.Segment               = Config.Segment;
            _StepContext.SourceSystemStudyName = Config.StudyName;

            _StepContext.DownloadDirectory     = CreateUserDirectory(Config.ParentDownloadDirectory, _StepContext.User);
            _StepContext.DumpDirectory         = CreateUserDirectory(Config.ParentDumpDirectory, _StepContext.User);

            _StepContext.Browser               = CoderDeclarativeBrowser.StartBrowsing(_StepContext.DownloadDirectory);

            _StepContext.Browser.LoginToiMedidata(_StepContext.User, Config.Password);
        }

        [BeforeScenario("ApplicationMonitoring")]
        public void BeforeApplicationMonitoringScenario()
        {
            _StepContext.User                  = Config.Login;
            _StepContext.Segment               = Config.Segment;
            _StepContext.SourceSystemStudyName = Config.StudyName;

            _StepContext.DownloadDirectory     = CreateUserDirectory(Config.ParentDownloadDirectory, _StepContext.User);
            _StepContext.DumpDirectory         = CreateUserDirectory(Config.ParentDumpDirectory, _StepContext.User);

            _StepContext.Browser               = CoderDeclarativeBrowser.StartBrowsing(_StepContext.DownloadDirectory);

            _StepContext.Browser.LoginToiMedidata(_StepContext.User, Config.Password);
        }

        [BeforeScenario("Deployment")]
        public void BeforeRaveDeploymentScenario()
        {
            _StepContext.User = Config.Login;

            _StepContext.DownloadDirectory = CreateUserDirectory(Config.ParentDownloadDirectory, _StepContext.User);
            _StepContext.DumpDirectory = CreateUserDirectory(Config.ParentDumpDirectory, _StepContext.User);
            _StepContext.Browser = CoderDeclarativeBrowser.StartBrowsing(_StepContext.DownloadDirectory);

            _StepContext.Segment = Config.Segment;

            _StepContext.Browser.LoginToRave(_StepContext.User, Config.Password);
        }

        private void CommonBeforeScenario(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext,null))  throw new ArgumentNullException("stepContext");
            if (String.IsNullOrWhiteSpace(stepContext.User)) throw new ArgumentNullException("loginId");

            stepContext.DownloadDirectory = CreateUserDirectory(Config.ParentDownloadDirectory, stepContext.User);
            stepContext.DumpDirectory     = CreateUserDirectory(Config.ParentDumpDirectory, stepContext.User);
            stepContext.UserDisplayName   = CoderDatabaseAccess.GetUserNameByLogin(stepContext.User);
            stepContext.SystemUser        = CoderDatabaseAccess.GetUserNameByLogin("System User");
            stepContext.OdmManager        = new OdmManager();

            stepContext.Browser           = CoderDeclarativeBrowser.StartBrowsing(_StepContext.DownloadDirectory);
        }

        [AfterScenario("CoderCore")]
        public void AfterCoreScenario()
        {
            if (!ReferenceEquals(_StepContext.Browser, null))
            {
                var testPassed = ReferenceEquals(ScenarioContext.Current.TestError, null);

                if (testPassed)
                {
                    try
                    {
                        TaskAttempt.TryAction(_StepContext.Browser.CleanUpCodingTasks, TimeSpan.FromSeconds(10));
                    }
                    catch(Exception ex)
                    {
                        Console.WriteLine(String.Format("Error cleaning up tasks after test pass: {0}", ex));
                    }
                }

                CommonAfterScenario();

                if (testPassed)
                {
                    CoderUserGenerator.DeleteGeneratedUser(_StepContext.CoderTestUser, _StepContext.SegmentUnderTest);
                }
            }

        }

        [AfterScenario("ApplicationMonitoring")]
        public void AfterApplicationMonitoringScenario()
        {
            CommonAfterScenario();

            AssertTestWasConclusive(_StepContext);
        }

        [AfterScenario("EndToEnd")]
        [AfterScenario("Deployment")]
        private void CommonAfterScenario()
        {
            var browser = _StepContext.Browser;

            if (!ReferenceEquals(browser, null))
            {

                Console.WriteLine("Test run with user: {0}", _StepContext.User);

                var error = ScenarioContext.Current.TestError;

                if (!ReferenceEquals(error, null))
                {
                    var fileName = "ScenarioError_" + error.TargetSite;

                    browser.SaveScreenshot(fileName);

                    Console.WriteLine("An error occurred with user: " + _StepContext.User);
                    Console.WriteLine("Error: "+ error.Message);
                }

                browser.Dispose();
            }

            ScenarioContext.Current.Clear();

            #if !DEBUG
                RemoveTempDirectoryByName(_StepContext.DownloadDirectory);
                RemoveTempDirectoryByName(_StepContext.DumpDirectory);
            #endif
        }

        [AfterTestRun]
        public static void AfterTestRun()
        {

        }

        private static void AssertTestWasConclusive(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");

            if (stepContext.IsAutoApproval.EqualsIgnoreCase("false") &&
                stepContext.IsApprovalRequired.EqualsIgnoreCase("true"))
            {
                Assert.Inconclusive("Coding decision for task required manual approval. The autoworkflow service may not be functional.");
            }
        }

        private static void CreateScreenshotDirectory()
        {
            var screenshotDirectory = BrowserUtility.GetScreenshotDirectory();

            CreateTempDirectoryByName(screenshotDirectory);
        }

        private static string CreateUserDirectory(string parentDirectory, string loginId)
        {
            if (String.IsNullOrWhiteSpace(parentDirectory)) throw new ArgumentNullException("loginId");
            if (String.IsNullOrWhiteSpace(loginId)) throw new ArgumentNullException("loginId");

            var directoryName = Path.Combine(parentDirectory, loginId);

            CreateTempDirectoryByName(directoryName);

            return directoryName;
        }

        private static void CreateTempDirectoryByName(string directoryName)
        {
            if (String.IsNullOrEmpty(directoryName)) throw new ArgumentNullException("directoryName");

            if (!Directory.Exists(directoryName))
            {
                Directory.CreateDirectory(directoryName);
            }
        }

        private static void RemoveTempDirectoryByName(string directoryName)
        {
            if (String.IsNullOrEmpty(directoryName)) throw new ArgumentNullException("directoryName");

            if (Directory.Exists(directoryName))
            {
                Directory.Delete(directoryName, true);
            }
        }
    }
}