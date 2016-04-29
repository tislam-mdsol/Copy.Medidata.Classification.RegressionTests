using System;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using Coder.DeclarativeBrowser.Helpers;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class AdminStudyMigrationSteps
    {
        private readonly CoderDeclarativeBrowser    _Browser;
        private readonly StepContext                _StepContext;

        public AdminStudyMigrationSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext    = stepContext;
            _Browser        = _StepContext.Browser;
        }

        [When(@"coding the tasks")]
        public void WhenCodingTheTasks(Table tasks)
        {
            if (ReferenceEquals(tasks, null)) throw new ArgumentNullException("tasks");

            foreach (var row in tasks.Rows)
            {
                var searchCriteria = new DictionarySearchCriteria
                {
                    SearchText     = row["Search Text"],
                    Levels         = new[] { row["Search Level"] },
                    ExactMatchOnly = true
                };

                var targetResult = new TermPathRow
                {
                    TermPath = row["Search Text"],
                    Code     = row["Synonym Code"],
                    Level    = row["Dictionary Level"]
                };

                _Browser.CompleteBrowseAndCode(
                    verbatimTerm  : row["Verbatim"], 
                    searchCriteria: searchCriteria, 
                    targetResult  : targetResult, 
                    createSynonym : row["Add Synonym"].ToBoolean());
            }
        }

        [When(@"re-coding the tasks")]
        public void WhenRe_CodingTheTasks(Table tasks)
        {
            if (ReferenceEquals(tasks, null)) throw new ArgumentNullException("tasks");

            foreach (var row in tasks.Rows)
            {
                var searchCriteria = new DictionarySearchCriteria
                {
                    SearchText     = row["Search Text"],
                    Levels         = new[] { row["Search Level"] },
                    ExactMatchOnly = true
                };

                var targetResult = new TermPathRow
                {
                    TermPath = row["Search Text"],
                    Code     = row["Synonym Code"],
                    Level    = row["Dictionary Level"]
                };

                _Browser.ReCodeTaskToNewTerm(
                    verbatimTerm  : row["Verbatim"], 
                    searchCriteria: searchCriteria, 
                    targetResult  : targetResult, 
                    createSynonym : row["Add Synonym"].ToBoolean(),
                    comment       : row["Comment"]);
            }
        }

        [When(@"performing Study Impact Analysis")]
        public void WhenPerformingStudyImpactAnalysis()
        {
            _Browser.PerformStudyImpactAnalysis(
                study            : _StepContext.Project,
                dictionary       : CreateDictionaryLocaleValue(_StepContext.Dictionary, _StepContext.Locale),
                sourceSynonymList: _StepContext.SourceSynonymList,
                targetSynonymList: _StepContext.TargetSynonymList);
        }

        [When(@"starting study migration")]
        [When(@"performing study migration")]
        public void WhenPerformingStudyMigration()
        {
             _Browser.MigrateStudy(
                study            : _StepContext.Project,
                dictionary       : CreateDictionaryLocaleValue(_StepContext.Dictionary, _StepContext.Locale),
                sourceSynonymList: _StepContext.SourceSynonymList,
                targetSynonymList: _StepContext.TargetSynonymList);

            _StepContext.Version = _StepContext.TargetSynonymList.Version;
        }

        [When(@"performing study migration without waiting")]
        public void WhenPerformingStudyMigrationWithoutWaiting()
        {
            _Browser.MigrateStudy(
               study                     : _StepContext.Project,
               dictionary                : CreateDictionaryLocaleValue(_StepContext.Dictionary, _StepContext.Locale),
               sourceSynonymList         : _StepContext.SourceSynonymList,
               targetSynonymList         : _StepContext.TargetSynonymList,
               waitForMigrationToComplete: false);

            _StepContext.Version = _StepContext.TargetSynonymList.Version;
        }

        [When(@"performing limited study migration")]
        public void WhenPerformingLimitedStudyMigration()
        {
             _Browser.FakeStudyMigration(
                loginName        : Config.Login, 
                segment          : _StepContext.Segment, 
                studyName        : _StepContext.Project, 
                sourceSynonymList: _StepContext.SourceSynonymList, 
                targetSynonymList: _StepContext.TargetSynonymList);
        }
        
        [Then(@"the verbatim term ""(.*)"" exists under Path Changed")]
        public void ThenTheVerbatimTermExistsUnderPathChanged(string verbatimTerm)
        {
            if (String.IsNullOrEmpty(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            _Browser.AssertThatVerbatimTermExistsUnderPathChanged(
                verbatimTerm     : verbatimTerm,
                study            : _StepContext.Project,
                dictionary       : CreateDictionaryLocaleValue(_StepContext.Dictionary, _StepContext.Locale),
                sourceSynonymList: _StepContext.SourceSynonymList,
                targetSynonymList: _StepContext.TargetSynonymList);
        }

        [Then(@"the verbatim term ""(.*)"" exists under Term Not Found")]
        public void ThenTheVerbatimTermExistsUnderTermNotFound(string verbatimTerm)
        {
            if (String.IsNullOrEmpty(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            _Browser.AssertThatVerbatimTermExistsUnderTermNotFound(
                verbatimTerm     : verbatimTerm,
                study            : _StepContext.Project,
                dictionary       : CreateDictionaryLocaleValue(_StepContext.Dictionary, _StepContext.Locale),
                sourceSynonymList: _StepContext.SourceSynonymList,
                targetSynonymList: _StepContext.TargetSynonymList);
        }

        [Then(@"the verbatim term ""(.*)"" exists under Casing Changed")]
        public void ThenTheVerbatimTermExistsUnderCasingChanged(string verbatimTerm)
        {
            if (String.IsNullOrEmpty(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            _Browser.AssertThatVerbatimTermExistsUnderCasingChanged(
                verbatimTerm     : verbatimTerm,
                study            : _StepContext.Project,
                dictionary       : CreateDictionaryLocaleValue(_StepContext.Dictionary, _StepContext.Locale),
                sourceSynonymList: _StepContext.SourceSynonymList,
                targetSynonymList: _StepContext.TargetSynonymList);
        }

        [Then(@"the following study report information exists")]
        public void ThenTheFollowingStudyReportInformationExists(Table studyReport)
        {
            if (ReferenceEquals(studyReport, null)) throw new ArgumentNullException("studyReport");

            foreach (var row in studyReport.Rows)
            {
                _Browser.AssertThatVerbatimTermExistsWithCorrectCategoryAndStatus(
                    study        : _StepContext.Project,
                    verbatimTerm : row["Verbatim"],
                    categoryName : row["Category"],
                    dictionary   : CreateDictionaryLocaleValue(_StepContext.Dictionary, _StepContext.Locale),
                    targetVersion: _StepContext.TargetSynonymList.Version,
                    status       : row["Workflow Status"]);
            }
        }

        [Then(@"I verify the following Coding Tasks are displayed")]
        public void ThenIVerifyTheFollowingCodingTasksAreDisplayed(Table tasks)
        {
            foreach (var row in tasks.Rows)
            {
                _Browser.AssertThatCodingTasksAreInTheCorrectStatus(
                    verbatimTerm: row["Verbatim"], 
                    status      : row["Status"]);
            }
        }

        [Then(@"study migration is complete for the latest version")]
        public void ThenStudyMigrationIsCompleteForTheLatestVersion()
        {
            _Browser.AssertThatStudyMigrationIsCompleteForTheLatestVersion( 
                study            : _StepContext.Project,
                dictionary       : CreateDictionaryLocaleValue(_StepContext.Dictionary, _StepContext.Locale),
                sourceVersion    : _StepContext.SourceSynonymList.Version,
                targetVersion    : _StepContext.TargetSynonymList.Version);
        }

        [Then(@"the study has ""(.*)"" task\(s\) that is not affected")]
        public void ThenTheStudyHasTaskSThatIsNotEffected(int numberOfTasks)
        {
            _Browser.AssertThatTheNotAffectedCountIsEqualToNumberOfTasks(
                numberOfTasks    : numberOfTasks,
                study            : _StepContext.Project,
                dictionary       : CreateDictionaryLocaleValue(_StepContext.Dictionary, _StepContext.Locale),
                sourceSynonymList: _StepContext.SourceSynonymList,
                targetSynonymList: _StepContext.TargetSynonymList);
        }

        [Then(@"the term has the following coding history comments")]
        public void ThenTheTermHasTheFollowingCodingHistory(Table codingHistoryValues)
        {
            if (ReferenceEquals(codingHistoryValues, null)) throw new ArgumentNullException("codingHistoryValues");

            foreach (var row in codingHistoryValues.Rows)
            {
                _Browser.AssertThatTheTermHasCodingHistoryComment(
                    verbatimTerm        : row["Verbatim"],
                    codingHistoryComment: row["Comment"]);
            }
        }

        [Then(@"the following study impact analyis actions will be available")]
        public void ThenTheFollowingStudyImpactAnalyisActionsWillBeAvailable(Table featureData)
        {
            if (ReferenceEquals(featureData, null)) throw new ArgumentNullException("featureData");

            var expectedActions = featureData.CreateInstance<StudyImpactAnalysisActions>();
            var actualActions = _Browser.GetAvailableStudyImpactActions(_StepContext);

            actualActions.ShouldBeEquivalentTo(expectedActions);
        }
        
        [Then(@"new coding task ""(.*)"" is not be accepted until the study migration completes")]
        public void ThenNewCodingTaskIsNotBeAcceptedUntilTheStudyMigrationCompletes(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            bool uploadCompletedSuccesfully = BrowserUtility.CreateNewTask(_StepContext, verbatim, haltOnFailure: false);
            uploadCompletedSuccesfully.Should().BeFalse();

            ThenStudyMigrationIsCompleteForTheLatestVersion();

            uploadCompletedSuccesfully = BrowserUtility.CreateNewTask(_StepContext, verbatim, haltOnFailure: true);
            uploadCompletedSuccesfully.Should().BeTrue();

            _Browser.AssertTaskLoaded(verbatim);
        }

        private static string CreateDictionaryLocaleValue(string dictionary, string locale)
        {
            if (String.IsNullOrEmpty(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrEmpty(locale))     throw new ArgumentNullException("locale");

            var result = String.Format("{0} ({1})", dictionary, locale);

            return result;
        }
    }
}
