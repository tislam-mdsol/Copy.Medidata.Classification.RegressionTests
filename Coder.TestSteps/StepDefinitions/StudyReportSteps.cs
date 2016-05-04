using System;
using System.Reflection;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.PageObjects.Reports;
using FluentAssertions;
using TechTalk.SpecFlow;

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
            _Browser.CreateIngredientReport(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);
            _Browser.StudyViewReport(_StudyReportDescription);

            var studyReportTaskCount = _Browser.GetStudyReportTaskCount();
            studyReportTaskCount.ShouldBeEquivalentTo(count);
            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"Study Report data should have ""(.*)"" tasks  with a workflow state of ""(.*)""")]
        public void ThenStudyReportDataShouldHaveTasksWithAWorkflowStateOf(int count, string status)
        {

            if (ReferenceEquals(status, null)) throw new ArgumentNullException(nameof(status));

            _Browser.CreateIngredientReport(_StepContext.GetStudyName(), _StepContext.Dictionary, _StudyReportDescription);
            _Browser.StudyViewReport(_StudyReportDescription);

            if (status == "NotCoded")
            {
                var studyReportTaskCount = _Browser.GetStudyReportTaskCount(WorkflowState.NotCoded);
                studyReportTaskCount.ShouldBeEquivalentTo(count);
                _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
            }

            if (status == "Completed")
            {
                var studyReportTaskCount = _Browser.GetStudyReportTaskCount(WorkflowState.Completed);
                studyReportTaskCount.ShouldBeEquivalentTo(count);
                _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
            }

            if (status == "CodedButNotComplete")
            {
                var studyReportTaskCount = _Browser.GetStudyReportTaskCount(WorkflowState.CodedButNotComplete);
                studyReportTaskCount.ShouldBeEquivalentTo(count);
                _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
            }
        }

    }
}