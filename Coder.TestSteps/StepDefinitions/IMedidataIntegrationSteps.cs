using System;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class IMedidataIntegrationSteps
    {
        private readonly CoderDeclarativeBrowser    _Browser;
        private readonly StepContext                _StepContext;
        private IMedidataStudy _MedidataStudy;

        public IMedidataIntegrationSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))     throw new NullReferenceException("Browser");

            _StepContext    = stepContext;
            _Browser        = _StepContext.Browser;
            _MedidataStudy  = new IMedidataStudy
            {
                StudyGroup     = _StepContext.Segment,
                Environment    = StudyEnvironment.Other,
                Name           = String.Concat(_StepContext.Segment, DateTime.Now.ToShortDateString(), DateTime.Now.ToShortTimeString()),
                ProtocolNumber = _StepContext.ProtocolNumber
            };
        }

        [Given(@"a new study is created in the current study group")]
        public void GivenANewStudyIsCreatedInTheCurrentStudyGroup()
        {
            _Browser.LoadiMedidataCoderAppSegment(_StepContext.Segment);
            _Browser.CreateNewStudy(_MedidataStudy, _StepContext);
        }

        [When(@"the study name is changed")]
        public void WhenTheStudyNameIsChanged()
        {
            var newName  = String.Concat(_StepContext.Segment, DateTime.Now.ToShortDateString(), DateTime.Now.ToLongTimeString());
            var newStudy = new IMedidataStudy { Name = newName };

            _StepContext.Project = newName;

            _Browser.UpdateStudy(_MedidataStudy, newStudy, _StepContext);
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
