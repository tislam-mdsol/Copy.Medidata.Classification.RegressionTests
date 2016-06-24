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
        private readonly StepContext             _StepContext;

        public GlobalSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))     throw new NullReferenceException("Browser");

            _StepContext   = stepContext;
            _Browser       = _StepContext.Browser;
        }

        [Given(@"a ""(.*)"" Coder setup with no tasks and no synonyms and dictionary ""(.*)""")]
        public void GivenACoderSetupWithNoTasksAndNoSynonymsAndDictionary(string setupType, string dictionaryLocaleVersion)
        {
            if (String.IsNullOrEmpty(setupType))                 throw new ArgumentNullException("setupType");                 
            if (String.IsNullOrEmpty(dictionaryLocaleVersion))   throw new ArgumentNullException("dictionaryLocaleVersion");

            _StepContext.SetProjectRegistrationContext(dictionaryLocaleVersion);
            _StepContext.SetSourceSystemApplicationContext();

            _Browser.SetupCoderConfiguration(_StepContext, setupType);
            
            _StepContext.CleanUpAndRegisterProject();
        }

        [Given(@"a ""(.*)"" Coder setup for a non-production study with no tasks and no synonyms and dictionary ""(.*)""")]
        public void GivenACoderSetupForANon_ProductionStudyWithNoTasksAndNoSynonymsAndDictionary(string setupType, string dictionaryLocaleVersion)
        {
            if (String.IsNullOrEmpty(setupType))                throw new ArgumentNullException("setupType");
            if (String.IsNullOrEmpty(dictionaryLocaleVersion))  throw new ArgumentNullException("dictionaryLocaleVersion");

            _StepContext.ActiveStudyType = StudyType.Dev;

            GivenACoderSetupWithNoTasksAndNoSynonymsAndDictionary(setupType, dictionaryLocaleVersion);
        }

        [When(@"coding task ""(.*)"" for dictionary level ""(.*)""")]
        [Given(@"coding task ""(.*)"" for dictionary level ""(.*)""")]
        public void GivenCodingTaskForDictionaryLevel(string verbatim, string dictionaryLevel)
        {
            if (String.IsNullOrEmpty(verbatim))          throw new ArgumentNullException("verbatim");          
            if (String.IsNullOrEmpty(dictionaryLevel))   throw new ArgumentNullException("dictionaryLevel");

            //BrowserUtility.CreateNewTask(_StepContext, verbatim, dictionaryLevel);
            BrowserUtility.CreateAutomatedCodingRequestSection(_StepContext, verbatim, dictionaryLevel);
        }

        [When(@"coding tasks ""(.*)""")]
        [Given(@"coding tasks ""(.*)""")]
        public void GivenCodingTasks(string combinedVerbatims)
        {
            if (String.IsNullOrEmpty(combinedVerbatims)) throw new ArgumentNullException("combinedVerbatims");

            var verbatims = combinedVerbatims.Split(',');

            foreach (var verbatim in verbatims)
            {
                BrowserUtility.CreateNewTask(_StepContext, verbatim.Trim(), waitForAutoCodingComplete:false);
            }

            _Browser.WaitForAutoCodingToComplete();
        }

        [Given(@"new coding task ""(.*)"" with isAutoApproval ""(.*)"" and isApprovalRequired ""(.*)""")]
        public void GivenNewCodingTaskWithIsAutoApprovalAndIsApprovalRequired(string verbatim, string isAutoApproval, string isApprovalRequired)
        {
            _StepContext.SetOdmTermApprovalContext(isAutoApproval,isApprovalRequired);
            BrowserUtility.CreateNewTask(_StepContext, verbatim);
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
            
            Tuple<string, int> odmPathAndTaskCount = BrowserUtility.BuildOdmFile(csvFilePath, _StepContext);
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

            BrowserUtility.CreateNewTask(_StepContext, verbatim, dictionaryLevel, formName);
        }

        [Given(@"""(.*)"" coding tasks of ""(.*)"" for dictionary level ""(.*)""")]
        public void GivenCodingTasksOfForDictionaryLevel(int numberOfTasks, string verbatim, string dictionaryLevel)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(dictionaryLevel)) throw new ArgumentNullException("dictionaryLevel");

            _Browser.SetupCodingTaskGroup(_StepContext, verbatim, dictionaryLevel, numberOfTasks);
        }

        [When(@"I view task ""(.*)""")]
        public void WhenISelectTask(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim))  throw new ArgumentNullException("verbatim"); 

            _Browser.SelectCodingTask(verbatim);

            _StepContext.SetCurrentCodingElementContext();
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

            var verbatim = StepArgumentTransformations.TransformFeatureString(verbatimFeature, _StepContext);

            if (_StepContext.IsAutoApproval.EqualsIgnoreCase("false") &&
                _StepContext.IsApprovalRequired.EqualsIgnoreCase("true"))
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

            _StepContext.SetProjectRegistrationContext(dictionaryLocaleVersion);

            _StepContext.SetSourceSystemApplicationContext();

            _Browser.SetupCoderConfiguration(_StepContext, setupType);
            
            _Browser.CleanUpCodingTasks();

            foreach (var expected in featureData)
            {
                CoderDatabaseAccess.RegisterProject(
                    protocolNumber   : _StepContext.GetProtocolNumber(),
                    segment          : _StepContext.GetSegment(),
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
            _Browser.LoadiMedidataRaveModulesAppSegment(_StepContext.GetSegment());
        }

        [Given(@"Coder App Segment is loaded")]
        [When(@"Coder App Segment is loaded")]
        public void CoderAppSegmentIsLoaded()
        {
            _Browser.LoadiMedidataCoderAppSegment(_StepContext.GetSegment());
        }
        
        [Given(@"a Rave project registration with dictionary ""(.*)"""), Scope(Tag = "EndToEndDynamicSegment")]
        [Given(@"a Rave project registration with dictionary ""(.*)"""), Scope(Tag = "EndToEndDynamicStudy")]
        public void GivenARaveProjectRegistrationWithDictionaryParallelExecution(string dictionaryLocaleVersion)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersion)) throw new ArgumentNullException("dictionaryLocaleVersion");

            SetProjectContext(dictionaryLocaleVersion);

            RolloutDictionary();

            LoadCoderAsTestUser(clearTasks: false);

            RegisterProjects();

            _Browser.LoadiMedidataRaveModulesAppSegment(_StepContext.GetSegment());

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

            _Browser.LoadiMedidataRaveModulesAppSegment(_StepContext.GetSegment());

            UploadTemplateRaveArchitectDraft();
        }
        
        private void SetProjectContext(string dictionaryLocaleVersion)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersion))                  throw new ArgumentNullException("dictionaryLocaleVersion");
            if (ReferenceEquals(_StepContext.SegmentUnderTest, null))                throw new ArgumentNullException("_StepContext.SegmentUnderTest");
            if (String.IsNullOrWhiteSpace(_StepContext.SegmentUnderTest.NameSuffix)) throw new ArgumentNullException("_StepContext.SegmentUnderTest.NameSuffix");

            _StepContext.SetProjectRegistrationContext(dictionaryLocaleVersion);

            var synonymListName = Config.DefaultSynonymListName + _StepContext.SegmentUnderTest.NameSuffix;

            _StepContext.SetSynonymContext(synonymListName);
        }

        private void RolloutDictionary()
        {
            var browser = _StepContext.Browser;

            browser.LoginToiMedidata(_StepContext.CoderAdminUser.Username, _StepContext.CoderAdminUser.Password);

            browser.LoadiMedidataCoderAppSegment(Config.SetupSegment);

            var dictionaryLocale = String.Format("{0} ({1})", _StepContext.Dictionary, _StepContext.Locale);

            browser.RolloutDictionary(_StepContext.GetSegment(), dictionaryLocale);

            browser.LogoutOfCoderAndImedidata();
        }

        private void LoadCoderAsTestUser(bool clearTasks = false)
        {
            var browser = _StepContext.Browser;

            browser.LoginToiMedidata(_StepContext.CoderTestUser.Username, _StepContext.CoderTestUser.Password);

            browser.LoadiMedidataCoderAppSegment(_StepContext.GetSegment());
            
            if (clearTasks)
            {
                browser.CleanUpCodingTasksOnly();
            }
        }

        private void RegisterProjects()
        {
            CoderUserGenerator.AssignCoderRolesByIMedidataId(_StepContext.SegmentUnderTest.SegmentUuid, _StepContext.CoderTestUser.MedidataId);

            CoderDatabaseAccess.CreateAndActivateSynonymList(
                segment          : _StepContext.GetSegment(),
                dictionary       : _StepContext.SourceSynonymList.Dictionary,
                dictionaryVersion: _StepContext.SourceSynonymList.Version,
                locale           : _StepContext.SourceSynonymList.Locale,
                synonymListName  : _StepContext.SourceSynonymList.SynonymListName);
            
            var productionStudies = _StepContext.SegmentUnderTest.Studies.Select(x => x).Where(x => x.IsProduction);

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
                 _Browser.RegisterProjects(study.StudyName, new List<SynonymList> { _StepContext.SourceSynonymList });
            }
        }

        private void CreateEmptyRaveArchitectDrafts()
        {
            var productionStudies = _StepContext.SegmentUnderTest.Studies.Select(x => x).Where(x => x.IsProduction);

            foreach (var study in productionStudies)
            {
                _Browser.AddRaveArchitectDraft(study.StudyName, "Empty Test Draft");
            }
        }

        private void UploadTemplateRaveArchitectDraft()
        {
            const string defaultDraftTemplateFileName = "RaveDraft_Template.xml";
            const string defaultDraftName             = "RaveCoderDraft";

            var productionStudies = _StepContext.SegmentUnderTest.Studies.Select(x => x).Where(x => x.IsProduction);

            var draftTemplateFilePath = Path.Combine(Config.StaticContentFolder, defaultDraftTemplateFileName);

            foreach (var study in productionStudies)
            {
                _Browser.UploadRaveArchitectDraftTemplate(study.StudyName, defaultDraftName, draftTemplateFilePath, _StepContext.DumpDirectory);
            }

            _StepContext.DraftName = defaultDraftName;
        }
        
        private void CreateNewProjectCoderRoles()
        {
            _StepContext.Browser.CreateAndActivateWorkFlowRole("WorkflowAdmin");

            _StepContext.Browser.AssignWorkflowRole(
                roleName: "WorkflowAdmin",
                study: _StepContext.GetStudyName(),
                loginId: _StepContext.GetUser());

            _StepContext.Browser.CreateAndActivateGeneralRole(
                roleName: "StudyAdmin",
                securityModule: "Page Study Security");

            _StepContext.Browser.AssignGeneralRole(
                 roleName: "StudyAdmin",
                 securityModule: "Page Study Security",
                 type: "All",
                 loginId: _StepContext.GetUser());

            _StepContext.Browser.CreateAndActivateGeneralRole(
                roleName: "DictAdmin",
                securityModule: "Page Dictionary Security");

            _StepContext.Browser.AssignGeneralRole(
                 roleName: "DictAdmin",
                 securityModule: "Page Dictionary Security",
                 type: "All",
                 loginId: _StepContext.GetUser());
        }
    }
}
