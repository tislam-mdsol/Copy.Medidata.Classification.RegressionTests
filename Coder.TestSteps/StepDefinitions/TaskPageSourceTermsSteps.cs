﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Helpers;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class TaskPageSourceTermsSteps
    {
        private readonly CoderDeclarativeBrowser    _Browser;
        private readonly StepContext                _StepContext;

        public TaskPageSourceTermsSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))     throw new NullReferenceException("Browser");

            _StepContext        = stepContext;
            _Browser            = _StepContext.Browser;
        }

        [Given(@"coding task ""(.*)"" for dictionary level ""(.*)"" with a component value of ""(.*)"" defined")]
        public void GivenCodingTaskForDictionaryLevelWithComponent(string verbatim, string dictionaryLevel, string featureComponents)
        {
            if (String.IsNullOrEmpty(verbatim))                 throw new ArgumentNullException("verbatim");          
            if (String.IsNullOrEmpty(dictionaryLevel))          throw new ArgumentNullException("dictionaryLevel");   
            if (String.IsNullOrEmpty(featureComponents))        throw new ArgumentNullException("featureComponents"); 

            BrowserUtility.CreateNewTask(_StepContext, verbatim, dictionaryLevel, components: featureComponents);
        }

        [Given(@"coding task ""(.*)"" for dictionary level ""(.*)"" with a supplemental value of ""(.*)"" defined")]
        public void GivenCodingTaskForDictionaryLevelWithASupplementalValueOfDefined(string verbatim, string dictionaryLevel, string featureSupplements)
        {
            if (String.IsNullOrEmpty(verbatim))                     throw new ArgumentNullException("verbatim");          
            if (String.IsNullOrEmpty(dictionaryLevel))              throw new ArgumentNullException("dictionaryLevel");   
            if (String.IsNullOrEmpty(featureSupplements))           throw new ArgumentNullException("featureSupplements");

            BrowserUtility.CreateNewTask(_StepContext, verbatim, dictionaryLevel, supplements: featureSupplements);
        }

        [Then(@"I verify the following Source Term information is displayed")]
        public void ThenIVerifyTheFollowingSourceTermInformationIsDisplayed(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("featureData");

            _StepContext.SetCurrentCodingElementContext();

            _Browser.SelectSourceTermTab();

            var expectedResult = table.TransformFeatureTableStrings(_StepContext).CreateInstance<SourceTerm>();
            var expectedResultStudy = expectedResult.Study + expectedResult.Study.ToString().RemoveNonAlphanumeric();
            var actualResult = _Browser.GetSourceTermTableValues();

            actualResult.SourceSystem.Should().BeEquivalentTo(expectedResult.SourceSystem);
            actualResult.Study.Should()       .BeEquivalentTo(expectedResultStudy);
            actualResult.Dictionary.Should()  .BeEquivalentTo(expectedResult.Dictionary);
            actualResult.Locale.Should()      .BeEquivalentTo(expectedResult.Locale);
            actualResult.Term.Should()        .BeEquivalentTo(expectedResult.Term);
            actualResult.Level.Should()       .BeEquivalentTo(expectedResult.Level);
            actualResult.Priority.Should()    .BeEquivalentTo(expectedResult.Priority);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify the following EDC information is displayed")]
        public void ThenIVerifyTheFollowingEDCInformationIsDisplayed(List<dynamic> featureData)
        {
            if (ReferenceEquals(featureData, null))                 throw new ArgumentNullException("featureData"); 

            _Browser.SelectSourceTermTab();

            var actualResult = _Browser.GetSourceTermEdcReferenceTableValues();
            
            featureData.Count.ShouldBeEquivalentTo(1);

            var featureDataProperty = featureData[0];

            actualResult.Field.Should()  .BeEquivalentTo(featureDataProperty.Field);
            actualResult.Line.Should()   .BeEquivalentTo(featureDataProperty.Line.ToString());
            actualResult.Form.Should()   .BeEquivalentTo(featureDataProperty.Form);
            actualResult.Event.Should()  .BeEquivalentTo(featureDataProperty.Event);
            actualResult.Subject.Should().BeEquivalentTo(featureDataProperty.Subject);
            actualResult.Site.Should()   .BeEquivalentTo(featureDataProperty.Site);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify when no component or supplemental data is present and Coder displays ""(.*)""")]
        public void ThenIVerifyWhenNoComponentOrSupplementalDataIsPresentAndCoderDisplays(string featureData)
        {
            if (ReferenceEquals(featureData, null))                 throw new ArgumentNullException("featureData"); 

            _Browser.SelectSourceTermTab();

            var htmlData = _Browser.GetSupplementalTableValues();

            if (featureData.Equals("No data"))
            {
                htmlData.Should().BeNull();
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify that the default view contains Source Term information")]
        public void ThenIVerifyThatTheDefaultViewContainsSourceTermInformation()
        {
            var selectedTab = _Browser.GetSelectedCodingTaskTab();

            selectedTab.Should().BeEquivalentTo("Source Terms");

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify the following Component information is displayed")]
        public void ThenIVerifyTheFollowingComponentInformationIsDisplayed(List<dynamic> featureData)
        {
            if (ReferenceEquals(featureData, null))                 throw new ArgumentNullException("featureData"); 

            _Browser.SelectSourceTermTab();

            var actualResult = _Browser.GetSupplementalTableValues();

            for (var i = 0; i < actualResult.Count; i++)
            {
                actualResult[i].Term.Should().BeEquivalentTo(featureData[i].SupplementalTerm);
                actualResult[i].Value.Should().BeEquivalentTo(featureData[i].SupplementalValue);
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify the following Supplemental information is displayed")]
        public void ThenIVerifyTheFollowingSupplementalInformationIsDisplayed(List<dynamic> featureData)
        {
            if (ReferenceEquals(featureData, null))                 throw new ArgumentNullException("featureData"); 

            _Browser.SelectSourceTermTab();

            var actualResult = _Browser.GetSupplementalTableValues();

            for (var i = 0; i < actualResult.Count; i++)
            {
                actualResult[i].Term.Should().BeEquivalentTo(featureData[i].SupplementalTerm);
                actualResult[i].Value.Should().BeEquivalentTo(featureData[i].SupplementalValue);
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
    }
}
