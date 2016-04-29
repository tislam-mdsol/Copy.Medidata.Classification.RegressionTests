using System;
using System.Collections.Generic;
using System.Reflection;
using Coder.DeclarativeBrowser.Models.GridModels;
using FluentAssertions;
using Coder.DeclarativeBrowser.Models;

namespace Coder.DeclarativeBrowser.ExtensionMethods.Assertions
{
    public static class ReclassificationAssertionExtensionMethods
    {
        public static void AssertReclassificationSearchResultsMatchesExpectedData(
            this CoderDeclarativeBrowser browser, 
            IList<ReclassificationSearch> reclassificationSearchResults)
        {
            if (ReferenceEquals(browser, null))                       throw new ArgumentNullException("browser");
            if (ReferenceEquals(reclassificationSearchResults, null)) throw new ArgumentNullException("reclassificationSearchResults");

            var session = browser.Session;

            var codingReclassificationPage = session.GetCodingReclassificationPage();
            codingReclassificationPage.GoTo();

            var results = RetryPolicy.FindElement
                .Execute(() => codingReclassificationPage.ExecuteSearchAndReturnExpectedResults());

            reclassificationSearchResults.Count.ShouldBeEquivalentTo(results.Count);
            reclassificationSearchResults.ShouldAllBeEquivalentTo(results);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertTaskAvailableWithinReclassification(
            this CoderDeclarativeBrowser browser,
            string term, 
            string dictionary, 
            string locale,
            string version, 
            string autocoding)
        {
            if (ReferenceEquals(browser, null))   throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(term))       throw new ArgumentNullException("term");
            if (String.IsNullOrEmpty(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrEmpty(locale))     throw new ArgumentNullException("locale");
            if (String.IsNullOrEmpty(version))    throw new ArgumentNullException("version");
            if (String.IsNullOrEmpty(autocoding)) throw new ArgumentNullException("autocoding");

            var codingReclassificationPage = browser.Session.GetCodingReclassificationPage();
            codingReclassificationPage.GoTo();

            codingReclassificationPage.AssertThatTaskAvailable(
                term                 : term, 
                dictionary           : dictionary, 
                locale               : locale, 
                version              : version,
                includeAutoCodedItems: autocoding);
        }

        public static void AssertThatReclassificationPagingLabelsEqualsExpectedValue(
            this CoderDeclarativeBrowser browser,
            string expectedPagingLabel,
            string expectedResultsLabel)
        {
            if (ReferenceEquals(browser, null))                  throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(expectedPagingLabel))  throw new ArgumentNullException("expectedPagingLabel");
            if (String.IsNullOrWhiteSpace(expectedResultsLabel)) throw new ArgumentNullException("expectedResultsLabel"); 

            var session                    = browser.Session;
            var codingReclassificationPage = browser.Session.GetCodingReclassificationPage();

            codingReclassificationPage.GoTo();

            codingReclassificationPage.AssertThatAllTasksAreFinishedProcessing(expectedResultsLabel);

            var pagingLabel  = codingReclassificationPage.GetPagingLabel();
            var resultsLabel = codingReclassificationPage.GetResultsLabel();

            pagingLabel.ShouldBeEquivalentTo(expectedPagingLabel);
            resultsLabel.ShouldBeEquivalentTo(expectedResultsLabel);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertReclassificationSearchResults(
            this CoderDeclarativeBrowser browser,
            IList<ReclassificationSearch> featureData)
        {
            if (ReferenceEquals(browser, null))     throw new ArgumentNullException("browser");
            if (ReferenceEquals(featureData, null)) throw new ArgumentNullException("featureData");

            var session                    = browser.Session;
            var codingReclassificationPage = session.GetCodingReclassificationPage();
            var reclassifyTableValues      = codingReclassificationPage.GetReclassifyTableValues();

            reclassifyTableValues.Count.ShouldBeEquivalentTo(featureData.Count);

            for (var termIndex = 0; termIndex < featureData.Count; termIndex++)
            {
                var term           = featureData[termIndex];
                var termProperties = term.GetType().GetProperties();

                foreach (var termProperty in termProperties)
                {
                    var termValue = term.GetProperty(termProperty.Name);

                    if (String.IsNullOrEmpty(termValue)) continue;

                    var tableValue = reclassifyTableValues[termIndex].GetProperty(termProperty.Name);

                    tableValue.Should().BeEquivalentTo(termValue);
                }
            }

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertCannotReclassifyDuringStudyMigration(
            this CoderDeclarativeBrowser browser,
            ReclassificationSearchCriteria searchCriteria,
            string targetDictionaryVersion)
        {
            if (ReferenceEquals(browser, null))                     throw new ArgumentNullException("browser");
            if (ReferenceEquals(browser.Session, null))             throw new ArgumentNullException("browser.Session");
            if (ReferenceEquals(searchCriteria, null))              throw new ArgumentNullException("searchCriteria");
            if (String.IsNullOrWhiteSpace(searchCriteria.Verbatim)) throw new ArgumentNullException("searchCriteria.Verbatim");
            if (String.IsNullOrWhiteSpace(targetDictionaryVersion)) throw new ArgumentNullException("targetDictionaryVersion");

            var session = browser.Session;

            // Verify the warning message is displayed
            var codingReclassificationPage = session.GetCodingReclassificationPage();
            codingReclassificationPage.GoTo();

            RetryPolicy.CompletionAssertion.Execute(
                () =>
                {
                    var indicatorShowing =
                            codingReclassificationPage.GetStudyMigrationWarningIndicator().Exists(Config.ExistsOptions);

                    indicatorShowing.Should().BeTrue();
                });
            
            // Verify the new dictionary version cannot be selected
            codingReclassificationPage.GetVersionDropDownList().Text.Should().NotContain(targetDictionaryVersion);

            // Verify we can't find any terms in the old dictionary
            codingReclassificationPage.AssertThatTaskAvailable(searchCriteria);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
    }
}
