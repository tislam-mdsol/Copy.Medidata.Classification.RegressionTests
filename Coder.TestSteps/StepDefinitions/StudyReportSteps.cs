using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using Castle.Core.Internal;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.PageObjects.Reports;
using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class StudyReportSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext             _StepContext;
        private readonly string                  _StudyReportDescription;

        public StudyReportSteps(StepContext stepContext)
        {
    
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException(nameof(stepContext));
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException(nameof(stepContext.Browser));

            _StepContext            = stepContext;
            _Browser                = _StepContext.Browser;
            _StudyReportDescription = "Study Report Description " + DateTime.UtcNow.ToLongDateString();
        }

        [Then(@"Study Report data should have ""(.*)"" tasks")]
        public void ThenStudyReportDataShouldHaveTasks(int count)
        {
            _Browser.WaitForAutoCodingToComplete();
            _Browser.CreateStudyReport(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);
  
            var studyReportTaskCount = _Browser.GetStudyReportTotalTaskCount(_StudyReportDescription);
            studyReportTaskCount.ShouldBeEquivalentTo(count);
            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"the study report information for study ""(.*)"" and dictionary ""(.*)"" should have the following")]
        public void ThenTheStudyReportInformationForStudyAndDictionaryShouldHaveTheFollowing(string studyName, string dictionary, Table featureTable)
        {
            if (ReferenceEquals(featureTable, null))   throw new ArgumentNullException(nameof(featureTable));
            if (String.IsNullOrWhiteSpace(studyName))  throw new ArgumentNullException(nameof(studyName));
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException(nameof(dictionary));

            _Browser.CreateStudyReport(studyName, dictionary, _StudyReportDescription);
 
            var actualStudyReportDataSet = _Browser.GetStudyReportDataSet(_StudyReportDescription);
            var actualStudyReportData    = actualStudyReportDataSet.StudyStats;
            var expectedStudyStatData    = featureTable.CreateInstance<StudyReportStats>();

            var actualStudyReportStats   =
                actualStudyReportData.FirstOrDefault(
                    x => x.StudyStatName .Equals(studyName,  StringComparison.OrdinalIgnoreCase) 
                      && x.DictionaryName.Equals(dictionary, StringComparison.OrdinalIgnoreCase));

            if (ReferenceEquals(actualStudyReportStats, null))
            {
                throw new ArgumentException($"Could not find study report stats with study name of {studyName} and dictionary of {dictionary}");
            }

            expectedStudyStatData.NotCodedCount         .ShouldBeEquivalentTo(actualStudyReportStats.NotCodedCount);
            expectedStudyStatData.CompletedCount        .ShouldBeEquivalentTo(actualStudyReportStats.CompletedCount);
            expectedStudyStatData.CodedNotCompletedCount.ShouldBeEquivalentTo(actualStudyReportStats.CodedNotCompletedCount);
            expectedStudyStatData.WithOpenQueryCount    .ShouldBeEquivalentTo(actualStudyReportStats.WithOpenQueryCount);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"the study report task status count information should have the following")]
        public void ThenTheStudyReportInformationShouldHaveTheFollowing(Table featureTable)
        {
            if (ReferenceEquals(featureTable, null))   throw new ArgumentNullException(nameof(featureTable));
 
            _Browser.CreateStudyReport(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);

            var actualStudyReportDataSet = _Browser.GetStudyReportDataSet(_StudyReportDescription);

            var actualStudyReportData    = actualStudyReportDataSet.StudyStats;

            var expectedStudyStatData    = featureTable.CreateInstance<StudyReportStats>();

            var actualStudyReportStats   =
                actualStudyReportData.FirstOrDefault(
                    x => x.StudyStatName .Equals(_StepContext.GetStudyName(), StringComparison.OrdinalIgnoreCase)
                      && x.DictionaryName.Equals(_StepContext.Dictionary,     StringComparison.OrdinalIgnoreCase));

            if (ReferenceEquals(actualStudyReportStats, null))
            {
                throw new ArgumentException($"Could not find study report stats with study name of {_StepContext.GetStudyName()} and dictionary of {_StepContext.Dictionary}");
            }

            expectedStudyStatData.NotCodedCount         .ShouldBeEquivalentTo(actualStudyReportStats.NotCodedCount);
            expectedStudyStatData.CompletedCount        .ShouldBeEquivalentTo(actualStudyReportStats.CompletedCount);
            expectedStudyStatData.CodedNotCompletedCount.ShouldBeEquivalentTo(actualStudyReportStats.CodedNotCompletedCount);
            expectedStudyStatData.WithOpenQueryCount    .ShouldBeEquivalentTo(actualStudyReportStats.WithOpenQueryCount);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }


        [Then(@"the study report task detail information for a study with task category Not Coded should have the following")]
        public void ThenTheStudyReportTaskDetailInformationForAStudyWithTaskCategoryNotCodedShouldHaveTheFollowing(Table featureTable)
        {
            if (ReferenceEquals(featureTable, null)) throw new ArgumentNullException(nameof(featureTable));

            var actualStudyStatData       = _Browser.GetNewStudyReportStats(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);

            var expectedStudyStatData     = featureTable.CreateInstance<StudyReportStatsDetails>();

            var actualDataStatsNotCoded   = actualStudyStatData.NotCodedTasks;

            var expectedDataStatsNotCoded = expectedStudyStatData;

            var areActualMatchingExpected = actualDataStatsNotCoded.Equals(expectedDataStatsNotCoded);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

            if (!(areActualMatchingExpected))
            {
                throw new Exception("Could not find matching expected and actual content");
            }

        }

        [Then(@"the study report task detail information for a study with task category Coded Not Completed should have the following")]
        public void ThenTheStudyReportTaskDetailInformationForAStudyWithTaskCategoryCodedNotCompletedShouldHaveTheFollowing(Table featureTable)
        {
            if (ReferenceEquals(featureTable, null)) throw new ArgumentNullException(nameof(featureTable));

            var actualStudyStatData       = _Browser.GetNewStudyReportStats(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);

            var expectedStudyStatData     = featureTable.CreateInstance<StudyReportStatsDetails>();

            var actualDataStatsNotCoded   = actualStudyStatData.CodedNotCompletedTasks;

            var expectedDataStatsNotCoded = expectedStudyStatData;

            var areActualMatchingExpected = actualDataStatsNotCoded.Equals(expectedDataStatsNotCoded);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

            if (!(areActualMatchingExpected))
            {
                throw new Exception("Could not find matching expected and actual content");
            }

        }

        [Then(@"the study report task detail information for a study with task category Completed should have the following")]
        public void ThenTheStudyReportTaskDetailInformationForAStudyWithTaskCategoryCompletedShouldHaveTheFollowing(Table featureTable)
        {
            if (ReferenceEquals(featureTable, null)) throw new ArgumentNullException(nameof(featureTable));

            var actualStudyStatData       = _Browser.GetNewStudyReportStats(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);

            var expectedStudyStatData     = featureTable.CreateInstance<StudyReportStatsDetails>();

            var actualDataStatsNotCoded   = actualStudyStatData.CompletedTasks;

            var expectedDataStatsNotCoded = expectedStudyStatData;

            var areActualMatchingExpected = actualDataStatsNotCoded.Equals(expectedDataStatsNotCoded);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

            if (!(areActualMatchingExpected))
            {
                throw new Exception("Could not find matching expected and actual content");
            }
        }

        [Then(@"the study report task detail information for a study with task category With Open Query should have the following")]
        public void ThenTheStudyReportTaskDetailInformationForAStudyWithTaskCategoryWithOpenQueryShouldHaveTheFollowing(Table featureTable)
        {
            if (ReferenceEquals(featureTable, null)) throw new ArgumentNullException(nameof(featureTable));

            var actualStudyStatData       = _Browser.GetNewStudyReportStats(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);

            var expectedStudyStatData     = featureTable.CreateInstance<StudyReportStatsDetails>();

            var actualDataStatsNotCoded   = actualStudyStatData.WithOpenQueryTasks;

            var expectedDataStatsNotCoded = expectedStudyStatData;

            var areActualMatchingExpected = actualDataStatsNotCoded.Equals(expectedDataStatsNotCoded);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

            if (!(areActualMatchingExpected))
            {
                throw new Exception("Could not find matching expected and actual content");
            }
        }

        [Then(@"the study coding path for a task within category Not Coded should be empty")]
        public void ThenTheStudyCodingPathForATaskWithinCategoryNotCodedShouldHaveTheFollowing(Table featureTable)
        {
            if (ReferenceEquals(featureTable, null)) throw new ArgumentNullException(nameof(featureTable));

            var actualStats                = _Browser.GetNewStudyReportStats(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);

            actualStats.NotCodedTasks.FirstOrDefault().SelectedTermpath.Should().BeNull();

        }

        [Then(@"the study coding path for a task within category Completed should have the following")]
        public void ThenTheStudyCodingPathForATaskWithinCategoryCompletedShouldHaveTheFollowing(Table featureTable)
        {
            if (ReferenceEquals(featureTable, null)) throw new ArgumentNullException(nameof(featureTable));

            var actualStats                = _Browser.GetNewStudyReportStats(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);

            var actualSelectedTermPath     = actualStats.CompletedTasks.FirstOrDefault().SelectedTermpath;

            if (ReferenceEquals(actualSelectedTermPath, null))
            {
                throw new ArgumentNullException(nameof(actualSelectedTermPath));
            }

            VerifySelectedTermPaths(_StepContext.GetStudyName(), _StepContext.Dictionary, actualSelectedTermPath, featureTable);
        }

        [Then(@"the study coding path for a task within category Coded Not Completed should have the following")]
        public void ThenTheStudyCodingPathForATaskWithinCategoryCodedNotCompletedShouldHaveTheFollowing(Table featureTable)
        {
            if (ReferenceEquals(featureTable, null)) throw new ArgumentNullException(nameof(featureTable));

            var actualStats            = _Browser.GetNewStudyReportStats(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);

            var actualSelectedTermPath = actualStats.CodedNotCompletedTasks.FirstOrDefault().SelectedTermpath;

            if (ReferenceEquals(actualSelectedTermPath, null))
            {
                throw new ArgumentNullException(nameof(actualSelectedTermPath));
            }

            VerifySelectedTermPaths(_StepContext.GetStudyName(), _StepContext.Dictionary, actualSelectedTermPath, featureTable);
        }

        [Then(@"the study coding path for a task within category With Open Query should be empty")]
        public void ThenTheStudyCodingPathForATaskWithinCategoryFWithOpenQueryShouldHaveTheFollowing(Table featureTable)
        {
            if (ReferenceEquals(featureTable, null)) throw new ArgumentNullException(nameof(featureTable));

            var actualStats           = _Browser.GetNewStudyReportStats(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);

            actualStats.WithOpenQueryTasks.FirstOrDefault().SelectedTermpath.Should().BeNull();
        }


        public void VerifySelectedTermPaths(string study, string Dictionary, IEnumerable<TermPathRow> actualSelectedTermPath, Table featureTable)
        {          
            if (ReferenceEquals(actualSelectedTermPath, null))
            {
                throw new ArgumentException($"Could not find study report stats with study name of {_StepContext.GetStudyName()} and dictionary of {_StepContext.Dictionary}");
            }

            var expectedTermPaths          = featureTable.Rows.Select(row => featureTable.CreateInstance<TermPathRow>()).ToArray();

            var resultOfTermPathComparison = actualSelectedTermPath.Equals(expectedTermPaths);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

            if (!resultOfTermPathComparison)
            {
                throw new Exception("Could not find matching expected and actual content");
            }
        }
    }
}

