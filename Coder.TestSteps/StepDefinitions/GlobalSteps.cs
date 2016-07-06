using System;
using System.Collections.Generic;
using System.IO;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.Helpers;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using System.Linq;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class GlobalSteps
    {
        private const int MaximumODMTasks = 1500; 

        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext             StepContext;

        public GlobalSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))     throw new NullReferenceException("Browser");

            StepContext   = stepContext;
            _Browser       = StepContext.Browser;
        }

        [Given(@"iMedidata App Segment is loaded")]
        [When(@"iMedidata App Segment is loaded")]
        public void GivenIMedidataAppSegmentIsLoaded()
        {
            _Browser.GoToiMedidataHome();
        }

        [Given(@"a project with the following options is registered")]
        public void GivenAProjectWithTheFollowingOptionsIsRegistered(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var list = table.TransformFeatureTableStrings(StepContext).CreateSet<SynonymList>().ToArray();
            _Browser.LoadiMedidataCoderAppSegment(StepContext.ProjectName);
            _Browser.RegisterProjects(StepContext.ProjectName, new List<SynonymList> { StepContext.SourceSynonymList });
        }

        [Given(@"app permissions are given for the ""(.*)"" for ""(.*)""")]
        public void GivenAppPermissionsAreGivenForTheFor(string p0, string p1)
        {
            ScenarioContext.Current.Pending();
        }


        [Given(@"a ""(.*)"" Coder setup with no tasks and no synonyms and dictionary ""(.*)""")]
        public void GivenACoderSetupWithNoTasksAndNoSynonymsAndDictionary(string setupType, string dictionaryLocaleVersion)
        {
            if (String.IsNullOrEmpty(setupType))                 throw new ArgumentNullException("setupType");                 
            if (String.IsNullOrEmpty(dictionaryLocaleVersion))   throw new ArgumentNullException("dictionaryLocaleVersion");

            StepContext.SetProjectRegistrationContext(dictionaryLocaleVersion);
            StepContext.SetSourceSystemApplicationContext();

            _Browser.SetupCoderConfiguration(StepContext, setupType);
            
            StepContext.CleanUpAndRegisterProject();
        }

        [Given(@"a ""(.*)"" Coder setup for a non-production study with no tasks and no synonyms and dictionary ""(.*)""")]
        public void GivenACoderSetupForANon_ProductionStudyWithNoTasksAndNoSynonymsAndDictionary(string setupType, string dictionaryLocaleVersion)
        {
            if (String.IsNullOrEmpty(setupType))                throw new ArgumentNullException("setupType");
            if (String.IsNullOrEmpty(dictionaryLocaleVersion))  throw new ArgumentNullException("dictionaryLocaleVersion");

            StepContext.ActiveStudyType = StudyType.Development;

            GivenACoderSetupWithNoTasksAndNoSynonymsAndDictionary(setupType, dictionaryLocaleVersion);
        }

        [When(@"coding task ""(.*)"" for dictionary level ""(.*)""")]
        [Given(@"coding task ""(.*)"" for dictionary level ""(.*)""")]
        public void GivenCodingTaskForDictionaryLevel(string verbatim, string dictionaryLevel)
        {
            if (String.IsNullOrEmpty(verbatim))          throw new ArgumentNullException("verbatim");          
            if (String.IsNullOrEmpty(dictionaryLevel))   throw new ArgumentNullException("dictionaryLevel");

            //BrowserUtility.CreateNewTask(_StepContext, verbatim, dictionaryLevel);
            BrowserUtility.CreateAutomatedCodingRequestSection(StepContext, verbatim, dictionaryLevel);
        }

        [When(@"coding tasks ""(.*)""")]
        [Given(@"coding tasks ""(.*)""")]
        public void GivenCodingTasks(string combinedVerbatims)
        {
            if (String.IsNullOrEmpty(combinedVerbatims)) throw new ArgumentNullException("combinedVerbatims");

            var verbatims = combinedVerbatims.Split(',');

            foreach (var verbatim in verbatims)
            {
                BrowserUtility.CreateNewTask(StepContext, verbatim.Trim(), waitForAutoCodingComplete:false);
            }

            _Browser.WaitForAutoCodingToComplete();
        }

        [Given(@"new coding task ""(.*)"" with isAutoApproval ""(.*)"" and isApprovalRequired ""(.*)""")]
        public void GivenNewCodingTaskWithIsAutoApprovalAndIsApprovalRequired(string verbatim, string isAutoApproval, string isApprovalRequired)
        {
            StepContext.SetOdmTermApprovalContext(isAutoApproval,isApprovalRequired);
            BrowserUtility.CreateNewTask(StepContext, verbatim);
        }

       
        [When(@"coding tasks are loaded from CSV file ""(.*)""")]
        [Given(@"coding tasks from CSV file ""(.*)""")]
        public void GivenCodingTasksFromCSVFile(string csvFilename)
        {
            if (ReferenceEquals(csvFilename, null)) throw new ArgumentNullException("csvFilename");

            CreateCodingTasksFromCSVFile(csvFilename, waitForAutoCodingComplete: true);
        }

        [When(@"coding tasks are loaded from CSV file ""(.*)"" and auto-coding in progress")]
        [Given(@"coding tasks from CSV file ""(.*)"" and auto-coding in progress")]
        public void GivenCodingTasksFromCSVFileAndAutoCodingInProgress(string csvFilename)
        {
            if (ReferenceEquals(csvFilename, null)) throw new ArgumentNullException("csvFilename");

            CreateCodingTasksFromCSVFile(csvFilename, waitForAutoCodingComplete:false);
        }

        private void CreateCodingTasksFromCSVFile(string csvFilename, bool waitForAutoCodingComplete)
        {
            if (ReferenceEquals(csvFilename, null)) throw new ArgumentNullException("csvFilename");

            string csvFilePath                     = BrowserUtility.GetDynamicCsvFilePath(csvFilename, Config.ApplicationCsvFolder);
            
            Tuple<string, int> odmPathAndTaskCount = BrowserUtility.BuildOdmFile(csvFilePath, StepContext);
            string odmFilePath                     = odmPathAndTaskCount.Item1;
            int expectedTaskCount                  = odmPathAndTaskCount.Item2;

            expectedTaskCount.Should().BeLessOrEqualTo(MaximumODMTasks, "There are too many tasks in the ODM to load. Split your CSV file into multiple files.");
            
            _Browser.GoToAdminPage("CodingCleanup");

            _Browser.UploadOdm(odmFilePath);
            
            if (waitForAutoCodingComplete)
            {
                _Browser.WaitForAutoCodingToComplete();
            }

            _Browser.GoToTaskPage();
        }


        [Given(@"a ""(.*)"" coding task ""(.*)"" dictionary level ""(.*)""")]
        public void GivenACodingTaskDictionaryLevel(string formName, string verbatim, string dictionaryLevel)
        {
            if (String.IsNullOrEmpty(verbatim))        throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(dictionaryLevel)) throw new ArgumentNullException("dictionaryLevel");
            if (String.IsNullOrEmpty(formName)) throw new ArgumentNullException("formName");

            BrowserUtility.CreateNewTask(StepContext, verbatim, dictionaryLevel, formName);
        }

        [Given(@"""(.*)"" coding tasks of ""(.*)"" for dictionary level ""(.*)""")]
        public void GivenCodingTasksOfForDictionaryLevel(int numberOfTasks, string verbatim, string dictionaryLevel)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(dictionaryLevel)) throw new ArgumentNullException("dictionaryLevel");

            _Browser.SetupCodingTaskGroup(StepContext, verbatim, dictionaryLevel, numberOfTasks);
        }

        [When(@"I view task ""(.*)""")]
        public void WhenISelectTask(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim))  throw new ArgumentNullException("verbatim"); 

            _Browser.SelectCodingTask(verbatim);

            StepContext.SetCurrentCodingElementContext();
        }

        [When(@"approving task ""(.*)""")]
        public void WhenApprovingTask(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");

            _Browser.ApproveCodingTask(verbatim);
        }

        [When(@"approving task ""(.*)"" if required")]
        public void WhenApprovingTaskIfRequired(string verbatimFeature)
        {
            if (ReferenceEquals(verbatimFeature, null)) throw new ArgumentNullException("verbatimFeature");

            var verbatim = StepArgumentTransformations.TransformFeatureString(verbatimFeature, StepContext);

            if (StepContext.IsAutoApproval.EqualsIgnoreCase("false") &&
                StepContext.IsApprovalRequired.EqualsIgnoreCase("true"))
            {
                _Browser.AssertThatTheTaskHasExpectedStatus(verbatim, "Waiting Approval");
                
                WhenApprovingTask(verbatim); 
            }
        }

        [When(@"rejecting coding decision for the task ""(.*)""")]
        public void WhenRejectingCodingDecisionForTheTask(string verbatim)
        {
            if (ReferenceEquals(verbatim, null)) throw new ArgumentNullException("verbatim");

            _Browser.RejectCodingDecision(verbatim);
        }

        [When(@"I make a comment of ""(.*)"" on the selected coding task")]
        public void WhenIMakeACommentOfOnTheSelectedCodingTask(string comment)
        {
            if (String.IsNullOrWhiteSpace(comment)) throw new ArgumentNullException("comment");

            _Browser.CommentOnSelectedCodingTask(comment);
        }

        [Given(@"a ""(.*)"" Coder setup with no tasks and no synonyms and dictionries")]
        public void GivenACoderSetupWithNoTasksAndNoSynonymsAndDictionries(string setupType, Table table)
        {
            if (String.IsNullOrEmpty(setupType)) throw new ArgumentNullException("setupType");
            if (ReferenceEquals(table, null)) { throw new ArgumentNullException("table"); }

            var featureData = table.CreateSet<SpecDictionary>().ToArray();

            var first = featureData.FirstOrDefault();
            string dictionaryLocaleVersion = first.Dictionary + first.Locale + first.Version;

            StepContext.SetProjectRegistrationContext(dictionaryLocaleVersion);

            StepContext.SetSourceSystemApplicationContext();

            _Browser.SetupCoderConfiguration(StepContext, setupType);
            
            _Browser.CleanUpCodingTasks();

            foreach (var expected in featureData)
            {
                CoderDatabaseAccess.RegisterProject(
                    protocolNumber   : StepContext.GetProtocolNumber(),
                    segment          : StepContext.GetSegment(),
                    dictionary       : expected.Dictionary.Trim(),
                    dictionaryVersion: expected.Version.Trim(),
                    locale           : expected.Locale.Trim(),
                    synonymListName  : expected.ListName.Trim(),
                    registrationName : expected.Dictionary.Trim());
            }
        }

        [Given(@"Rave Modules App Segment is loaded")]
        [When(@"Rave Modules App Segment is loaded")]
        public void RaveModulesAppSegmentIsLoaded()
        {
            _Browser.LoadiMedidataRaveModulesAppSegment(StepContext.GetSegment());
        }

        [Given(@"Coder App Segment is loaded")]
        [When(@"Coder App Segment is loaded")]
        public void CoderAppSegmentIsLoaded()
        {
            _Browser.LoadiMedidataCoderAppSegment(StepContext.GetSegment());
        }

        [Given(@"Coder App Segment is loaded and refreshed")]
        public void GivenCoderAppSegmentIsLoadedAndRefreshed()
        {
            _Browser.LoadiMedidataCoderAppSegment(StepContext.GetSegment());
            _Browser.LogoutOfCoder();
            _Browser.LoadiMedidataCoderAppSegment(StepContext.GetSegment());
        }


        [Given(@"I logout of iMedidata")]
        public void GivenILogoutOfIMedidata()
        {
            _Browser.LogoutOfiMedidata();
        }

        [Given(@"I login to iMedidata as test user")]
        public void GivenILoginToIMedidataAsTestUser()
        {
            _Browser.LoginToiMedidata(StepContext.CoderTestUser.Email, Config.AdminPassword);
        }

        [Given(@"a Rave project registration with dictionary ""(.*)"""), Scope(Tag = "EndToEndDynamicSegment")]
        [Given(@"a Rave project registration with dictionary ""(.*)"""), Scope(Tag = "EndToEndDynamicStudy")]
        [Given(@"a Rave project registration with dictionary ""(.*)"""), Scope(Tag = "EndToEndMultipleProdStudy")]
        public void GivenARaveProjectRegistrationWithDictionaryParallelExecution(string dictionaryLocaleVersion)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersion)) throw new ArgumentNullException("dictionaryLocaleVersion");

            SetProjectContext(dictionaryLocaleVersion);

            RolloutDictionary();

            LoadCoderAsTestUser(clearTasks: false);

            RegisterProjects(); 

            _Browser.LoadiMedidataRaveModulesAppSegment(StepContext.GetSegment());

            CreateEmptyRaveArchitectDrafts();

            UploadTemplateRaveArchitectDraft();
        }

        [When(@"a Rave project registration with dictionary ""(.*)"""), Scope(Tag = "EndToEndDynamicSegment")]
        public void WhenARaveProjectRegistrationWithDictionaryParallelExecution(string dictionaryLocaleVersion)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersion)) throw new ArgumentNullException("dictionaryLocaleVersion");

            _Browser.LogoutOfiMedidata();
            GivenARaveProjectRegistrationWithDictionaryParallelExecution(dictionaryLocaleVersion);
        }

        [Given(@"a Rave project registration with dictionary ""(.*)"""), Scope(Tag = "DebugEndToEndDynamicSegment")]
        public void GivenARaveProjectRegistrationWithDictionaryParallelExecutionDebug(string dictionaryLocaleVersion)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersion)) throw new ArgumentNullException("dictionaryLocaleVersion");

            SetProjectContext(dictionaryLocaleVersion);

         }

        [Given(@"a Rave project registration with dictionary ""(.*)"""), Scope(Tag = "EndToEndStaticSegment")]
        public void GivenARaveProjectRegistrationWithDictionarySerialExecution(string dictionaryLocaleVersion)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersion)) throw new ArgumentNullException("dictionaryLocaleVersion");

            SetProjectContext(dictionaryLocaleVersion);

            LoadCoderAsTestUser(clearTasks: true);

            _Browser.LoadiMedidataRaveModulesAppSegment(StepContext.GetSegment());

            UploadTemplateRaveArchitectDraft();
        }
        
        private void SetProjectContext(string dictionaryLocaleVersion)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersion))                  throw new ArgumentNullException("dictionaryLocaleVersion");
            if (ReferenceEquals(StepContext.SegmentUnderTest, null))                throw new ArgumentNullException("_StepContext.SegmentUnderTest");
            if (String.IsNullOrWhiteSpace(StepContext.SegmentUnderTest.NameSuffix)) throw new ArgumentNullException("_StepContext.SegmentUnderTest.NameSuffix");

            StepContext.SetProjectRegistrationContext(dictionaryLocaleVersion);

            var synonymListName = Config.DefaultSynonymListName + StepContext.SegmentUnderTest.NameSuffix;

            StepContext.SetSynonymContext(synonymListName);
        }

        private void RolloutDictionary()
        {
            var browser = StepContext.Browser;

            browser.LoginToiMedidata(StepContext.CoderAdminUser.Username, StepContext.CoderAdminUser.Password);

            browser.LoadiMedidataCoderAppSegment(Config.SetupSegment);

            var dictionaryLocale = String.Format("{0} ({1})", StepContext.Dictionary, StepContext.Locale);

            browser.RolloutDictionary(StepContext.GetSegment(), dictionaryLocale);

            browser.LogoutOfCoderAndImedidata();
        }

        private void LoadCoderAsTestUser(bool clearTasks = false)
        {
            var browser = StepContext.Browser;

            browser.LoginToiMedidata(StepContext.CoderTestUser.Username, StepContext.CoderTestUser.Password);

            browser.LoadiMedidataCoderAppSegment(StepContext.GetSegment());
            
            if (clearTasks)
            {
                browser.CleanUpCodingTasksOnly();
            }
        }

        private void RegisterProjects()
        {
            CoderUserGenerator.AssignCoderRolesByIMedidataId(StepContext.SegmentUnderTest.SegmentUuid, StepContext.CoderTestUser.MedidataId);

            CoderDatabaseAccess.CreateAndActivateSynonymList(
                segment          : StepContext.GetSegment(),
                dictionary       : StepContext.SourceSynonymList.Dictionary,
                dictionaryVersion: StepContext.SourceSynonymList.Version,
                locale           : StepContext.SourceSynonymList.Locale,
                synonymListName  : StepContext.SourceSynonymList.SynonymListName);
            
            var productionStudies = StepContext.SegmentUnderTest.Studies.Select(x => x).Where(x => x.IsProduction);

            //JPTODO:: The syncs are taking too long in parallel
            // The project registration may not be immidiately available to the user on the first login due to the time it takes for Coder to sync with iMedidata.
            // WaitUntilAdminLinkExists() and WaitForIMedidataSync() do not appear to improve the situation. Jose suggested refreshing the page, but I believe 
            // WaitForIMedidataSync() is doing this already.
            // Explicitly wait here, so as not to affect the CoderCore tests.

            _Browser.WaitUntilAdminLinkExists("Project Registration");
            //_Browser.WaitForIMedidataSync();

            foreach (var study in productionStudies)
            {
               // _Browser.GoToAdminPage("CodingCleanup");
                 _Browser.RegisterProjects(study.StudyName, new List<SynonymList> { StepContext.SourceSynonymList });
            }
        }

        private void CreateEmptyRaveArchitectDrafts()
        {
            var productionStudies = StepContext.SegmentUnderTest.Studies.Select(x => x).Where(x => x.IsProduction);

            foreach (var study in productionStudies)
            {
                _Browser.AddRaveArchitectDraft(study.StudyName, "Empty Test Draft");
            }
        }

        private void UploadTemplateRaveArchitectDraft()
        {
            const string defaultDraftTemplateFileName = "RaveDraft_Template.xml";
            const string defaultDraftName             = "RaveCoderDraft";

            var productionStudies = StepContext.SegmentUnderTest.Studies.Select(x => x).Where(x => x.IsProduction);

            var draftTemplateFilePath = Path.Combine(Config.StaticContentFolder, defaultDraftTemplateFileName);

            foreach (var study in productionStudies)
            {
                _Browser.UploadRaveArchitectDraftTemplate(study.StudyName, defaultDraftName, draftTemplateFilePath, StepContext.DumpDirectory);
            }

            StepContext.DraftName = defaultDraftName;
        }
        
        private void CreateNewProjectCoderRoles()
        {
            StepContext.Browser.CreateAndActivateWorkFlowRole("WorkflowAdmin");

            StepContext.Browser.AssignWorkflowRole(
                roleName: "WorkflowAdmin",
                study: StepContext.GetStudyName(),
                loginId: StepContext.GetUser());

            StepContext.Browser.CreateAndActivateGeneralRole(
                roleName: "StudyAdmin",
                securityModule: "Page Study Security");

            StepContext.Browser.AssignGeneralRole(
                 roleName: "StudyAdmin",
                 securityModule: "Page Study Security",
                 type: "All",
                 loginId: StepContext.GetUser());

            StepContext.Browser.CreateAndActivateGeneralRole(
                roleName: "DictAdmin",
                securityModule: "Page Dictionary Security");

            StepContext.Browser.AssignGeneralRole(
                 roleName: "DictAdmin",
                 securityModule: "Page Dictionary Security",
                 type: "All",
                 loginId: StepContext.GetUser());
        }
    }
}
