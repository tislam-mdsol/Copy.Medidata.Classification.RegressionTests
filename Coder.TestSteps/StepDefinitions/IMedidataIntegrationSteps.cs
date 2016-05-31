using System;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.IMedidataApi.Models;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class IMedidataIntegrationSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext             _StepContext;
        private StudySetupData                   _MedidataStudy;
        private const string                     NewStudySuffix = "12345";

        public IMedidataIntegrationSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))     throw new NullReferenceException("Browser");

            _StepContext    = stepContext;
            _Browser        = _StepContext.Browser;
        }

        [Given(@"a new study is created in the current study group")]
        public void GivenANewStudyIsCreatedInTheCurrentStudyGroup()
        {
            ScenarioContext.Current.Pending();
        }

        [When(@"the study name is changed")]
        public void WhenTheStudyNameIsChanged()
        {
            var newName = String.Concat(_StepContext.GetSegment(), NewStudySuffix);

            var currentStudy = _StepContext.SegmentUnderTest.ProdStudy;

            _Browser.UpdateStudyName(currentStudy, newName);
            _Browser.LogoutOfCoder();
            _StepContext.SegmentUnderTest.ProdStudy.StudyName = newName;
        }

        [Then(@"task ""(.*)"" should contain the following source term information")]
        public void ThenTaskShouldContainTheFollowingSourceTermInformation(string verbatim, Table table)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (ReferenceEquals(table,null))         throw new ArgumentNullException("table");

            _Browser.SelectCodingTask(verbatim);
            _StepContext.SetCurrentCodingElementContext();
            _Browser.SelectSourceTermTab();

            var featureData = table.TransformFeatureTableStrings(_StepContext).CreateInstance<SourceTerm>();
            var actualData  = _Browser.GetSourceTermTableValues();

            actualData.ShouldBeEquivalentTo(featureData);
        }
    }
}
