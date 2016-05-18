using System;
using System.Linq;
using System.Reflection;
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


        [Then(@"the study report task detail information for a study with task category ""(.*)"" should have the following")]
        public void ThenTheStudyReportTaskDetailInformationForAStudyWithTaskCategoryShouldHaveTheFollowing(string status, Table featureTable)
        {
            if (ReferenceEquals(featureTable, null)) throw new ArgumentNullException(nameof(featureTable));

            _Browser.CreateStudyReport(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);

            var actualStudyReportDataSet = _Browser.GetStudyReportDataSet(_StudyReportDescription);

            var actualStudyReportData    = actualStudyReportDataSet.StudyStats;

            var actualStudyReportStats   =
                actualStudyReportData.FirstOrDefault(
                    x => x.StudyStatName .Equals(_StepContext.GetStudyName(), StringComparison.OrdinalIgnoreCase)
                      && x.DictionaryName.Equals(_StepContext.Dictionary,     StringComparison.OrdinalIgnoreCase));

            if (ReferenceEquals(actualStudyReportStats, null))
            {
                throw new ArgumentException($"Could not find study report stats with study name of {_StepContext.GetStudyName()} and dictionary of {_StepContext.Dictionary}");
            }

            var expectedStudyStatData     = featureTable.CreateInstance<StudyReportStats>();

            var areActualMatchingExpected = _Browser.GetComparisonStudyReportInformation(actualStudyReportStats, expectedStudyStatData, status);

            if (!(areActualMatchingExpected))
            {
                throw new Exception("Could not find matching expected and actual content");
            }
        }


    }
}

