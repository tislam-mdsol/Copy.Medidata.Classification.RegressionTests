using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
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
    public class TaskPageAssignmentsSteps
    {
        private readonly CoderDeclarativeBrowser    _Browser;
        private readonly StepContext                _StepContext;

        public TaskPageAssignmentsSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))                     throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))             throw new NullReferenceException("Browser");

            _StepContext    = stepContext;
            _Browser        = _StepContext.Browser;
        }

        [When(@"I recode task ""(.*)"" with comment ""(.*)""")]
        public void WhenIRecodeTaskWithComment(
            string verbatim, 
            string comment)
        {
            if (String.IsNullOrEmpty(verbatim))                         throw new ArgumentNullException("verbatim");  
            if (String.IsNullOrEmpty(comment))                          throw new ArgumentNullException("comment");   

            _Browser.ReCodeTask(verbatim, comment);
        }

        [Then(@"I verify Assignment Detail information displayed is No data")]
        public void ThenIVerifyAssignmentDetailInformationDisplayedIs()
        {
            _Browser.SelectAssignmentTab();

            var actualResult = _Browser.GetAssignmentDetailTableValues();

            actualResult.Should().BeNull();

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify Coding Assignments Path information displayed is No data")]
        public void ThenIVerifyCodingAssignmentsPathInformationDisplayedIs()
        {
            _Browser.SelectAssignmentTab();

            var actualResult = _Browser.GetAssignmentsPathTableValues();

            actualResult.Should().BeNull();

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify the following Assignment Detail information is displayed")]
        public void ThenIVerifyTheFollowingAssignmentDetailInformationIsDisplayed(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("featureData");

            var expectedResults = table.TransformFeatureTableStrings(_StepContext).CreateSet<AssignmentDetail>().ToArray();

            _Browser.SelectAssignmentTab();

            var actualResults = _Browser.GetAssignmentDetailTableValues();

            for (var i = 0; i < actualResults.Count; i++)
            {
                var expectedResult = expectedResults[i];
                var isEqual = actualResults[i].Equals(expectedResults[i]);
                isEqual.Should().BeTrue(String.Format("Assignment does not have " +
                                                      "Dictionary: {0}, IsActive: {1}, IsAutoCoded: {2}, Term: {3}, and User containing: {4}",
                                                      expectedResult.Dictionary, 
                                                      expectedResult.IsActive, 
                                                      expectedResult.IsAutoCoded,
                                                      expectedResult.Term,
                                                      expectedResult.User));
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify the following Coding Assignments Path information is displayed")]
        public void ThenIVerifyTheFollowingCodingAssignmentsPathInformationIsDisplayed(List<dynamic> featureData)
        {
            if (ReferenceEquals(featureData, null))                     throw new ArgumentNullException("featureData"); 

            _Browser.SelectAssignmentTab();

            var actualResults = _Browser.GetAssignmentsPathTableValues();

            for (var i = 0; i < actualResults.Count; i++)
            {
                var expectedResult = featureData[i];
                var actualResult = actualResults[i];

                actualResult.Level.Should().BeEquivalentTo(expectedResult.Level);
                actualResult.Code.Should().BeEquivalentTo(expectedResult.Code.ToString());
                actualResult.Term.Should().BeEquivalentTo(expectedResult.Term);
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [When(@"reclassifying task ""(.*)"" with comment ""(.*)"" in a ""(.*)"" coder setup")]
        public void WhenReclassifyingTaskWithCommentInACoderSetup(string codingTask, string comment, string setupType)
        {
            if (String.IsNullOrEmpty(codingTask)) throw new ArgumentNullException(codingTask);
            if (String.IsNullOrEmpty(comment))    throw new ArgumentNullException(comment);
            if (String.IsNullOrEmpty(setupType))  throw new ArgumentNullException(setupType);

            _Browser.ReclassifyTask(codingTask, comment, "Checked", ReclassificationTypes.Reclassify);
            
            if (setupType.Equals("Reconsider Bypass Off", StringComparison.OrdinalIgnoreCase))
            {
                _Browser.RejectCodingDecision(codingTask);
            }
        }
    }
}
