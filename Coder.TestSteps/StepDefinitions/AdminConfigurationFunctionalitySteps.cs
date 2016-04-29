using System;
using System.Reflection;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using FluentAssertions;
using TechTalk.SpecFlow;
using Coder.TestSteps.Transformations;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class AdminConfigurationFunctionalitySteps
    {
        private readonly CoderDeclarativeBrowser    _Browser;
        private readonly StepContext                _StepContext;

        public AdminConfigurationFunctionalitySteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))     throw new NullReferenceException("Browser");

            _StepContext    = stepContext;
            _Browser        = _StepContext.Browser;
        }

        [When(@"entering value ""(.*)"" for Configuration ""(.*)"" and save")]
        public void WhenEnteringValueForConfigurationAndSave(int entryValue, string textboxName)
        {
            if (String.IsNullOrEmpty(textboxName)) throw new ArgumentNullException("textboxName");

            _Browser.GoToAdminPage("Configuration");

            _Browser.SetConfigurationFunctionalityTextboxByTextboxName(
                textboxName:    textboxName, 
                value:          entryValue);
        }
        
        [When(@"I configure ""(.*)"" to ""(.*)""")]
        public void ConfigureCodingProperty(string configurationProperty, bool value)
        {
            if (String.IsNullOrEmpty(configurationProperty)) throw new ArgumentNullException("configurationProperty");

            _Browser.GoToAdminPage("Configuration");

            switch (configurationProperty)
            {
                case "Force Primary Path Selection":
                {
                    _Browser.SetConfigurationFunctionalityForcePrimaryPathSelectionCheckbox(value);
                    break;
                }
                case "Bypass Reconsider Upon Reclassify":
                {
                    _Browser.SetConfigurationFunctionalityBypassReconsiderUponReclassifyCheckbox(value);
                    break;
                }
                default:
                {
                    throw new ArgumentException(
                        "The configurationProperty is not valid or has not yet been mapped to a page object." +
                        "\nExpected \"Force Primary Path Selection\", or \"Bypass Reconsider Upon Reclassify\"");
                }
            }
        }

        [When(@"I configure the Synonym Creation Policy Flag to ""(.*)""")]
        public void ConfigureSynonymCreationPolicyFlag(string value)
        {
            if (String.IsNullOrEmpty(value)) throw new ArgumentNullException("value");

            _Browser.GoToAdminPage("Configuration");

            _Browser.SetConfigurationFunctionalitySynonymCreationPolicyFlagDropDown(value);
        }

        [When(@"I configure dictionary ""(.*)"" with ""(.*)"" set to ""(.*)""")]
        public void ConfigureDictionaryProperty(string dictionaryFeature, string configurationProperty, bool value)
        {
            if (String.IsNullOrEmpty(dictionaryFeature))     throw new ArgumentNullException("dictionaryFeature");
            if (String.IsNullOrEmpty(configurationProperty)) throw new ArgumentNullException("configurationProperty");
            
            var dictionary = StepArgumentTransformations.TransformFeatureString(dictionaryFeature, _StepContext);

            _Browser.GoToAdminPage("Configuration");

            switch (configurationProperty)
            {
                case "Auto Add Synonyms":
                {
                    _Browser.SetDictionaryConfigurationAutoAddSynonymsCheckbox(dictionary, value);
                    break;
                }
                case "Auto Approve":
                {
                    _Browser.SetDictionaryConfigurationAutoApproveCheckbox(dictionary, value);
                    break;
                }
                default:
                {
                    throw new ArgumentException(
                        "The configurationProperty is not valid or has not yet been mapped to a page object." +
                        "\nExpected \"Auto Add Synonyms\", or \"Auto Approve\"");
                }
            }
        }

        [Then(@"I should see a warning message of ""(.*)""")]
        public void ThenIShouldSeeAHeaderMessageOf(string expectedMessage)
        {
            if (String.IsNullOrEmpty(expectedMessage)) throw new ArgumentNullException("expectedMessage");

            var actualMessage = _Browser.GetAdminConfigurationManagementPageWarningMessage();

            actualMessage.Should().BeEquivalentTo(expectedMessage);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name + "_CodingTab"); 
        }

        [Then(@"I should see a limit value of ""(.*)"" for ""(.*)""")]
        public void ThenIShouldSeeALimitValueOfFor(string expectedLimit, string textboxName)
        {
            if (String.IsNullOrEmpty(expectedLimit))    throw new ArgumentNullException("expectedLimit");
            if (String.IsNullOrEmpty(textboxName))          throw new ArgumentNullException("textboxName");

            var actualLimit = _Browser.GetAdminConfigurationManagementPageTextboxLimitLabelByTextboxName(textboxName);

            actualLimit.Should().BeEquivalentTo(expectedLimit);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name + "_CodingTab"); 
        }
    }
}
