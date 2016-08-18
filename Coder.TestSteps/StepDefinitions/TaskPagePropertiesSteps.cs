using System;
using System.Collections.Generic;
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
    public class TaskPagePropertiesSteps
    {
        private readonly CoderDeclarativeBrowser    _Browser;
        private readonly StepContext                _StepContext;

        public TaskPagePropertiesSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))     throw new NullReferenceException("Browser");

            _StepContext        = stepContext;
            _Browser            = _StepContext.Browser;
        }

        [Then(@"I verify the following Medical Dictionary Property information is displayed")]
        public void ThenIVerifyTheFollowingDictionaryPropertyInformationIsDisplayed(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("featureData");

            var expectedResult = table.TransformFeatureTableStrings(_StepContext).CreateInstance<PropertyMedicalDictionary>();

            _Browser.SelectPropertiesTab();

            var actualResult = _Browser.GetPropertyMedicalDictionaryTableValues();

            var result = actualResult.Equals(expectedResult);

            result.Should().BeTrue(String.Format("Properties should be {0} but were {1}",
                expectedResult.ToString(), actualResult.ToString()));

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify the following Source System Property information is displayed")]
        public void ThenIVerifyTheFollowingSourceSystemPropertyInformationIsDisplayed(Table featureData)
        {
            if (ReferenceEquals(featureData, null)) throw new ArgumentNullException("featureData");

            var expectedResult = featureData.TransformFeatureTableStrings(_StepContext).CreateInstance<PropertySourceSystem>();

            _Browser.SelectPropertiesTab();

            var actualResult = _Browser.GetPropertySourceSystemTableValues();

            actualResult.SourceSystem.Should()  .BeEquivalentTo(expectedResult.SourceSystem);
            actualResult.Locale.Should()        .BeEquivalentTo(expectedResult.Locale);
            actualResult.StudyName.Should()     .BeEquivalentTo(expectedResult.StudyName);
            actualResult.ConnectionUri.Should() .BeEquivalentTo(expectedResult.ConnectionUri);
            actualResult.ProtocolNumber.Should().BeEquivalentTo(expectedResult.ProtocolNumber);
            //FileOid is not expected. actualResult.FileOid.Should()       .BeEquivalentTo(expectedResult.FileOid);
            //Protocol Name is not expected actualResult.ProtocolName.Should()  .BeEquivalentTo(expectedResult.ProtocolName);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"I verify the following Coding Status Property information is displayed")]
        public void ThenIVerifyTheFollowingCodingStatusPropertyInformationIsDisplayed(Table table)
        {
            if (ReferenceEquals(table, null))             throw new ArgumentNullException("featureData"); 

            _Browser.SelectPropertiesTab();

            var actualResult   = _Browser.GetPropertyCodingStatusTableValues();
            var expectedResult = table.TransformFeatureTableStrings(_StepContext).CreateInstance<PropertyCodingStatus>();

            actualResult.CodingStatus.Should().BeEquivalentTo(expectedResult.CodingStatus);
            actualResult.Workflow.Should()    .BeEquivalentTo(expectedResult.Workflow);

            var areCreationDatesEqual = AreDatesEqual(expectedResult.CreationDate, actualResult.CreationDate);
            var areAutoCodeDatesEqual = AreDatesEqual(expectedResult.AutoCodeDate, actualResult.AutoCodeDate);
            
            areAutoCodeDatesEqual.Should().BeTrue();
            areAutoCodeDatesEqual.Should().BeTrue();

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [When(@"reclassifying task ""(.*)"" with comment ""(.*)""")]
        public void WhenReclassifyingTaskWithComment(string verbatim, string comment)
        {
            if (string.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (string.IsNullOrEmpty(comment))  throw new ArgumentNullException("comment");

            ReclassificationSearchCriteria reclassificationSearchCriteria = new ReclassificationSearchCriteria
            {
                DictionaryType        = String.Format("{0} ({1})",_StepContext.Dictionary,_StepContext.Locale),
                Version               = _StepContext.Version,
                IncludeAutoCodedItems = true,
                Verbatim              = verbatim
            };
            
            _Browser.ReclassifyTask(reclassificationSearchCriteria, comment, ReclassificationTypes.Reclassify);
        }

        private static bool AreDatesEqual(string featureStringDate, string htmlStringDate)
        {
            var featureDate     = featureStringDate.ToNullableDate();
            var htmlDate        = htmlStringDate.ToNullableDate();

            return featureDate.Equals(htmlDate);
        }
    }
}
