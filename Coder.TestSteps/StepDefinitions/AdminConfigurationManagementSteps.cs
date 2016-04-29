using System;
using System.Linq;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.Models;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class AdminConfigurationManagementSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext             _StepContext;
        private string                           _DictionaryType;

        public AdminConfigurationManagementSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser     = _StepContext.Browser;
        }

        [Given(@"Coder Configurations")]
        public void GivenCoderConfigurations()
        {
            return;
        }

        [When(@"setting up a ""(.*)"" configuration for ""(.*)""")]
        public void WhenSettingUpAConfigurationFor(string setupType, string dictionaryType)
        {
            if (String.IsNullOrWhiteSpace(setupType))      throw new ArgumentNullException("setupType");
            if (String.IsNullOrWhiteSpace(dictionaryType)) throw new ArgumentNullException("dictionaryType");

            _DictionaryType = dictionaryType;

            _Browser.SetConfigurationManagementValuesWithFeatureSetupType(
                configurationType    : setupType,
                medicalDictionaryName: _DictionaryType);
        }

        [Then(@"the following Coder Configuration should exist")]
        public void ThenTheFollowingCoderConfigurationShouldExist(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var featureData = table.CreateSet<AdminConfigurationManagement>().ToArray();

            _Browser.AssertThatCoderConfigurationIsCorrect(
                featureData    : featureData, 
                dictionaryType : _DictionaryType);
        }
    }
}
