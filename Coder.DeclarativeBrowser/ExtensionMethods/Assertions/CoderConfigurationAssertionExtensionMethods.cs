using System;
using System.Linq;
using System.Reflection;
using Coder.DeclarativeBrowser.Models;
using FluentAssertions;

namespace Coder.DeclarativeBrowser.ExtensionMethods.Assertions
{
    public static class CoderConfigurationAssertionExtensionMethods
    {
        public static void AssertThatCoderConfigurationIsCorrect(
            this CoderDeclarativeBrowser browser,
            AdminConfigurationManagement[] featureData,
            string dictionaryType)
        {
            if (ReferenceEquals(featureData, null))        throw new ArgumentNullException("featureData");
            if (String.IsNullOrWhiteSpace(dictionaryType)) throw new ArgumentNullException("dictionaryType");

            featureData.Count().Should().Be(1);

            var session                          = browser.Session;
            var sourceData                       = featureData[0];
            var htmlData                         = browser.GetAdminConfigurationManagementValues(dictionaryType);
            var adminConfigurationManagementPage = session.GetAdminConfigurationManagementPage();

            sourceData.ShouldBeEquivalentTo(htmlData);

            adminConfigurationManagementPage.GetCodingTab().Click();
            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name + "_CodingTab");

            adminConfigurationManagementPage.GetDictionaryTab().Click();
            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name + "_DictionaryTab");
        }
    }
}
