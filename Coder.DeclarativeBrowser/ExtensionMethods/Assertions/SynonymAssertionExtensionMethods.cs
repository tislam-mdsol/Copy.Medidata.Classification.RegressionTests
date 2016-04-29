using System;
using System.Reflection;
using Coder.DeclarativeBrowser.Models;
using FluentAssertions;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.PageObjects;
using Coder.DeclarativeBrowser.Models.GridModels;

namespace Coder.DeclarativeBrowser.ExtensionMethods.Assertions
{
    public static class SynonymAssertionExtensionMethods
    {
        public static void AssertThatSynonymDetailIsAvailableWithASynonymCount(
            this CoderDeclarativeBrowser browser,
            SynonymList synonymList, 
            string synonymCount)
        {
            if (ReferenceEquals(browser, null))         throw new ArgumentNullException("browser");
            if (ReferenceEquals(synonymList, null))     throw new ArgumentNullException("synonymList");
            if(String.IsNullOrEmpty(synonymCount))      throw new ArgumentNullException("synonymCount");

            var session           = browser.Session;

            var synonymListValues = session
                .OpenAdminSynonymPage()
                .GetSynonymListTableValuesByListName(synonymList.SynonymListName);

            synonymListValues.NumberOfSynonyms.ShouldBeEquivalentTo(synonymCount);
            synonymListValues.HasReconciliations.ShouldBeEquivalentTo(false);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatSynonymFallsUnderCategoryWithANotMigratedSynonymCount(
            this CoderDeclarativeBrowser browser,
            SynonymList targetSynonymList,
            string synonymName,
            string categoryType,
            string notMigratedCount)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetSynonymList, null))       throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(synonymName))              throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))             throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(notMigratedCount))         throw new ArgumentNullException("notMigratedCount");

            var session                          = browser.Session;
            var adminSynonymMigrationPage        = session.OpenAdminSynonymMigrationPage(targetSynonymList);
            var synonymMigrationCategoryValues   = adminSynonymMigrationPage.GetSynonymMigrationCategoryTableValuesByCategoryType(categoryType);

            adminSynonymMigrationPage
                .GetCategoryRowNotMigratedCountButtonByCategoryType(categoryType)
                .Click();

            var synonymMigrationSuggestionValues = adminSynonymMigrationPage.GetSynonymSuggestionRowValuesBySynonymName(synonymName);

            synonymMigrationSuggestionValues
                .SynonymName
                .ToUpper()
                .ShouldBeEquivalentTo(synonymName.ToUpper());

            synonymMigrationCategoryValues
                .NotMigratedCount
                .ShouldBeEquivalentTo(notMigratedCount);

            adminSynonymMigrationPage
                .ExpandSynonymSuggestionRowBySynonymName(synonymName);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatSynonymFallsUnderCategoryWithADeclinedMigratedSynonymCount(
            this CoderDeclarativeBrowser browser,
            SynonymList targetSynonymList,
            string synonymName,
            string categoryType,
            string declinedMigratedCount)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetSynonymList, null))       throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(synonymName))              throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))             throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(declinedMigratedCount))    throw new ArgumentNullException("declinedMigratedCount");

            var session                             = browser.Session;
            var adminSynonymMigrationPage           = session.OpenAdminSynonymMigrationPage(targetSynonymList);
            var synonymMigrationCategoryValues      = adminSynonymMigrationPage.GetSynonymMigrationCategoryTableValuesByCategoryType(categoryType);

            adminSynonymMigrationPage
                .GetCategoryRowDeclinedMigratedCountButtonByCategoryType(categoryType)
                .Click();

            var synonymMigrationSuggestionValues    = adminSynonymMigrationPage.GetSynonymSuggestionRowValuesBySynonymName(synonymName);

            synonymMigrationSuggestionValues
                .SynonymName
                .ToUpper()
                .ShouldBeEquivalentTo(synonymName.ToUpper());

            synonymMigrationCategoryValues
                .DeclinedMigratedCount
                .ShouldBeEquivalentTo(declinedMigratedCount);

            adminSynonymMigrationPage
                .ExpandSynonymSuggestionRowBySynonymName(synonymName);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatSynonymFallsUnderCategoryWithAMigratedSynonymCount(
            this CoderDeclarativeBrowser browser,
            SynonymList targetSynonymList,
            string synonymName,
            string categoryType,
            string migratedCount)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetSynonymList, null))       throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(synonymName))              throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))             throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(migratedCount))            throw new ArgumentNullException("migratedCount");

            var session                             = browser.Session;
            var adminSynonymMigrationPage           = session.OpenAdminSynonymMigrationPage(targetSynonymList);
            var synonymMigrationCategoryValues      = adminSynonymMigrationPage.GetSynonymMigrationCategoryTableValuesByCategoryType(categoryType);

            adminSynonymMigrationPage.GetCategoryRowMigratedCountButtonByCategoryType(categoryType).Click();

            var synonymMigrationSuggestionValues    = adminSynonymMigrationPage.GetSynonymSuggestionRowValuesBySynonymName(synonymName);

            synonymMigrationSuggestionValues
                .SynonymName
                .ToUpper()
                .ShouldBeEquivalentTo(synonymName.ToUpper());

            synonymMigrationCategoryValues
                .MigratedCount
                .ShouldBeEquivalentTo(migratedCount);

            adminSynonymMigrationPage
                .ExpandSynonymSuggestionRowBySynonymName(synonymName);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatNoMatchSynonymHasNoSuggestedTermDataPresent(
            this CoderDeclarativeBrowser browser,
            SynonymList targetSynonymList,
            string synonymName)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetSynonymList, null))       throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(synonymName))              throw new ArgumentNullException("synonymName");

            var session                             = browser.Session;
            var adminSynonymMigrationPage           = session.OpenAdminSynonymMigrationPage(targetSynonymList);

            adminSynonymMigrationPage.GetCategoryRowDeclinedMigratedCountButtonByCategoryType("No Match").Click();

            var synonymMigrationSuggestionValues    = adminSynonymMigrationPage.GetSynonymSuggestionRowValuesBySynonymName(synonymName);

            synonymMigrationSuggestionValues
                .SynonymName
                .ToUpper()
                .ShouldBeEquivalentTo(synonymName.ToUpper());

            synonymMigrationSuggestionValues
                .UpgradedTermPath
                .Count
                .ShouldBeEquivalentTo(0);

            adminSynonymMigrationPage
                .ExpandSynonymSuggestionRowBySynonymName(synonymName);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatAllSynonymsAreAvailableForMigration(
            this CoderDeclarativeBrowser browser,
            SynonymList targetSynonymList)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetSynonymList, null))       throw new ArgumentNullException("targetSynonymList");

            var session = browser.Session;

            var areAllSynonymsReadyForMigration = session
               .OpenAdminSynonymMigrationPage(targetSynonymList)
               .AreAllSynonymsAvailableForMigration();

            areAllSynonymsReadyForMigration.ShouldBeEquivalentTo(true);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatTheSinglePathSynonymExistInMigratedCountWithOneDetailedSuggestion(
            this CoderDeclarativeBrowser browser,
            SynonymList targetSynonymList,
            string synonymName,
            string categoryType)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetSynonymList, null))       throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(synonymName))              throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))             throw new ArgumentNullException("categoryType");

            var session                         = browser.Session;
            var adminSynonymMigrationPage       = session.OpenAdminSynonymMigrationPage(targetSynonymList);
            var synonymMigrationCategoryValues  = adminSynonymMigrationPage.GetSynonymMigrationCategoryTableValuesByCategoryType(categoryType);
            var isMigratedCountNumeric          = synonymMigrationCategoryValues.MigratedCount.IsNumeric();

            isMigratedCountNumeric.ShouldBeEquivalentTo(true);

            var migratedCount                   = synonymMigrationCategoryValues.MigratedCount.ToInteger();

            migratedCount
                .Should()
                .BeGreaterThan(0);

            adminSynonymMigrationPage
                .GetCategoryRowMigratedCountButtonByCategoryType(categoryType)
                .Click();

            var synonymMigrationSuggestionValues = adminSynonymMigrationPage.GetSynonymSuggestionRowValuesBySynonymName(synonymName);

            synonymMigrationSuggestionValues
                .SynonymName
                .ToUpper()
                .ShouldBeEquivalentTo(synonymName.ToUpper());

            adminSynonymMigrationPage
                .ExpandSynonymSuggestionRowBySynonymName(synonymName);

            var synonymDetailValues             = adminSynonymMigrationPage.GetSynonymSuggestionDetailRowValues();

            synonymDetailValues
                .Count
                .Should()
                .Be(1);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatTheNonSinglePathSynonymExistInNotMigratedCountWithMultipleDetailedSuggestion(
            this CoderDeclarativeBrowser browser,
            SynonymList targetSynonymList,
            string synonymName,
            string categoryType)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetSynonymList, null))       throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(synonymName))              throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))             throw new ArgumentNullException("categoryType");

            var session                             = browser.Session;
            var adminSynonymMigrationPage           = session.OpenAdminSynonymMigrationPage(targetSynonymList);
            var synonymMigrationCategoryValues      = adminSynonymMigrationPage.GetSynonymMigrationCategoryTableValuesByCategoryType(categoryType);
            var isNotMigratedCountNumeric           = synonymMigrationCategoryValues.NotMigratedCount.IsNumeric();

            isNotMigratedCountNumeric.ShouldBeEquivalentTo(true);

            var notMigratedCount                    = synonymMigrationCategoryValues.NotMigratedCount.ToInteger();

            notMigratedCount
                .Should()
                .BeGreaterThan(0);

            adminSynonymMigrationPage
                .GetCategoryRowNotMigratedCountButtonByCategoryType(categoryType)
                .Click();

            var synonymMigrationSuggestionValues    = adminSynonymMigrationPage.GetSynonymSuggestionRowValuesBySynonymName(synonymName);

            synonymMigrationSuggestionValues
                .SynonymName
                .ToUpper()
                .ShouldBeEquivalentTo(synonymName.ToUpper());

            adminSynonymMigrationPage
                .ExpandSynonymSuggestionRowBySynonymName(synonymName);

            var synonymDetailValues                 = adminSynonymMigrationPage.GetSynonymSuggestionDetailRowValues();

            synonymDetailValues
                .Count
                .Should()
                .BeGreaterThan(1);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatTheSynonymHasALineDifferenceForEachChangedLevelInThePriorTermPathAndUpgradedTermPath(
            this CoderDeclarativeBrowser browser,
            SynonymList targetSynonymList,
            string synonymName,
            string categoryType)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetSynonymList, null))       throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(synonymName))              throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))             throw new ArgumentNullException("categoryType");

            var session                         = browser.Session;
            var adminSynonymMigrationPage       = session.OpenAdminSynonymMigrationPage(targetSynonymList);

            adminSynonymMigrationPage
                .GetCategoryRowNotMigratedCountButtonByCategoryType(categoryType)
                .Click();

            var sugestionRowValues              = adminSynonymMigrationPage.GetSynonymSuggestionRowValuesBySynonymName(synonymName);
            var atLeastOnePathChanged           = false;

            for (var i = 0; i < sugestionRowValues.PriorTermPath.Count; i++)
            {
                var priorTermPathProperty       = sugestionRowValues.PriorTermPath[i];
                var upgradeTermPathProperty     = sugestionRowValues.UpgradedTermPath[i];

                if (!priorTermPathProperty.HasChanged)
                {
                    continue;
                }

                atLeastOnePathChanged           = true;

                priorTermPathProperty
                    .Level
                    .ShouldBeEquivalentTo(upgradeTermPathProperty.Level);

                priorTermPathProperty
                    .TermCode
                    .Should()
                    .NotBeSameAs(upgradeTermPathProperty.TermCode);
            }

            atLeastOnePathChanged.ShouldBeEquivalentTo(true);

            adminSynonymMigrationPage
                .ExpandSynonymSuggestionRowBySynonymName(synonymName);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatTheSynonymHasALineDifferenceForEachChangedLevelInThePriorTermPathAndSuggestedTermPath(
            this CoderDeclarativeBrowser browser,
            SynonymList targetSynonymList,
            string synonymName,
            string categoryType)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetSynonymList, null))       throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(synonymName))              throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))             throw new ArgumentNullException("categoryType");

            var session                         = browser.Session;
            var adminSynonymMigrationPage       = session.OpenAdminSynonymMigrationPage(targetSynonymList);

            adminSynonymMigrationPage
                .GetCategoryRowNotMigratedCountButtonByCategoryType(categoryType)
                .Click();

            adminSynonymMigrationPage
                .ExpandSynonymSuggestionRowBySynonymName(synonymName);

            var suggestionDetailRowValues       = adminSynonymMigrationPage.GetSynonymSuggestionDetailRowValues();
            var atLeastOnePathChanged           = false;

            foreach (var suggestionDetail in suggestionDetailRowValues)
            {
                for (var i = 0; i < suggestionDetail.PriorTermPath.Count; i++)
                {
                    var priorTermPathProperty       = suggestionDetail.PriorTermPath[i];
                    var suggestedTermPathProperty   = suggestionDetail.SuggestedTermPath[i];

                    if (!priorTermPathProperty.HasChanged)
                    {
                        continue;
                    }

                    atLeastOnePathChanged           = true;

                    priorTermPathProperty
                        .Level
                        .ShouldBeEquivalentTo(suggestedTermPathProperty.Level);

                    priorTermPathProperty
                        .TermCode
                        .Should()
                        .NotBeSameAs(suggestedTermPathProperty.TermCode);
                }

                atLeastOnePathChanged.ShouldBeEquivalentTo(true);
            }

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatSynonymsExistsInMigratedCountForTheCategory(
            this CoderDeclarativeBrowser browser,
            SynonymList targetSynonymList,
            string categoryType,
            string migratedCount)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetSynonymList, null))       throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(categoryType))             throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(migratedCount))            throw new ArgumentNullException("migratedCount");

            var session                     = browser.Session;
            var adminSynonymMigrationPage   = session.OpenAdminSynonymMigrationPage(targetSynonymList);
            var categoryRowValues           = adminSynonymMigrationPage.GetSynonymMigrationCategoryTableValuesByCategoryType(categoryType);

            categoryRowValues
                .MigratedCount
                .ShouldBeEquivalentTo(migratedCount);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatSynonymsExistsInDeclinedMigratedCountForTheCategory(
            this CoderDeclarativeBrowser browser,
            SynonymList targetSynonymList,
            string categoryType,
            string declinedMigratedCount)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetSynonymList, null))       throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(categoryType))             throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(declinedMigratedCount))    throw new ArgumentNullException("declinedMigratedCount");

            var session                     = browser.Session;
            var adminSynonymMigrationPage   = session.OpenAdminSynonymMigrationPage(targetSynonymList);
            var categoryRowValues           = adminSynonymMigrationPage.GetSynonymMigrationCategoryTableValuesByCategoryType(categoryType);

            categoryRowValues
                .DeclinedMigratedCount
                .ShouldBeEquivalentTo(declinedMigratedCount);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertSynonymStatus(
            this CoderDeclarativeBrowser browser,
            SynonymSearch synonymSearch,
            bool synonymShouldExist)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(synonymSearch, null))           throw new ArgumentNullException("synonymSearch");
            if (String.IsNullOrEmpty(synonymSearch.SearchText)) throw new ArgumentNullException("synonymSearch.SearchText");

            var adminSynonymDetailsPage = browser.Session.OpenAdminSynonymDetailsPage(synonymSearch, haltOnEmptyList: false);

            var listIsEmpty = ReferenceEquals(adminSynonymDetailsPage, null);

            if (listIsEmpty)
            {
                synonymShouldExist.Should().BeFalse("Synonym list is empty");

                browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

                return;
            }

            var synonymRow = adminSynonymDetailsPage.GetSynonymDetails(synonymSearch);

            var synonymExists = !ReferenceEquals(synonymRow, null);
            synonymExists.ShouldBeEquivalentTo(synonymShouldExist);
            
            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertCountOfReconsiderTasksAffectedByRetiringSynonymsAre(
            this CoderDeclarativeBrowser browser, 
            SynonymSearch synonymSearch, 
            int expectedCompletedTasksCount, 
            int expectedInProgressTasksCount)
        {
            if (ReferenceEquals(browser, null))                      throw new ArgumentNullException("browser");
            if (ReferenceEquals(browser.Session, null))              throw new ArgumentNullException("browser.Session");
            if (ReferenceEquals(synonymSearch, null))                throw new ArgumentNullException("synonymSearch");
            if (String.IsNullOrEmpty(synonymSearch.SearchText))      throw new ArgumentNullException("synonymSearch.SearchText");
            if (expectedCompletedTasksCount < 0)                     throw new ArgumentOutOfRangeException("expectedCompletedTasksCount");
            if (expectedInProgressTasksCount < 0)                    throw new ArgumentOutOfRangeException("expectedInProgressTasksCount");
            
            var adminSynonymDetailsPage =  browser.Session.OpenAdminSynonymDetailsPage(synonymSearch);
            
            adminSynonymDetailsPage.FindAndBeginRetiringSynonym(synonymSearch.SearchText);

            expectedCompletedTasksCount .Should().Be(adminSynonymDetailsPage.GetCompletedCodingDecisionsCount());
            expectedInProgressTasksCount.Should().Be(adminSynonymDetailsPage.GetInProgressCodingDecisionsCount());
            
            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
        
        public static void AssertSynonymApprovalsFilteredByStudy(
          this CoderDeclarativeBrowser browser,
          IList<SynonymRow> actualSynonymsDetails,
          IList<SynonymRow> expectedSynonymsDetails)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(actualSynonymsDetails, null))   throw new ArgumentNullException("actualSynonymsDetails");
            if (ReferenceEquals(expectedSynonymsDetails, null)) throw new ArgumentNullException("expectedSynonymsDetails");
            
            actualSynonymsDetails.Count.Should().Be(expectedSynonymsDetails.Count);

            for (int synonymIndex = 0; synonymIndex < actualSynonymsDetails.Count; synonymIndex++)
            {
                var synonymDetails         = actualSynonymsDetails[synonymIndex];
                var expectedSynonymDetails = expectedSynonymsDetails[synonymIndex];

                synonymDetails.Verbatim           .Should().BeEquivalentTo(expectedSynonymDetails.Verbatim);
                synonymDetails.DictionaryAndLocale.Should().BeEquivalentTo(expectedSynonymDetails.DictionaryAndLocale);
                synonymDetails.ListName           .Should().BeEquivalentTo(expectedSynonymDetails.ListName);
            }

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
        
        public static void AssertSynonymApprovalsFilteredByDictionary(
          this CoderDeclarativeBrowser browser,
          IList<SynonymRow> actualSynonymsDetails,
          IList<SynonymRow> expectedSynonymsDetails)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(actualSynonymsDetails, null))   throw new ArgumentNullException("actualSynonymsDetails");
            if (ReferenceEquals(expectedSynonymsDetails, null)) throw new ArgumentNullException("expectedSynonymsDetails");

            actualSynonymsDetails.Count.Should().Be(expectedSynonymsDetails.Count);

            for (int synonymIndex = 0; synonymIndex < actualSynonymsDetails.Count; synonymIndex++)
            {
                var synonymDetails         = actualSynonymsDetails[synonymIndex];
                var expectedSynonymDetails = expectedSynonymsDetails[synonymIndex];

                synonymDetails.Verbatim           .Should().BeEquivalentTo(expectedSynonymDetails.Verbatim);
                synonymDetails.DictionaryAndLocale.Should().BeEquivalentTo(expectedSynonymDetails.DictionaryAndLocale);
            }

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertSynonymApprovalsFilteredBySynonymList(
          this CoderDeclarativeBrowser browser,
          IList<SynonymRow> actualSynonymsDetails,
          IList<SynonymRow> expectedSynonymsDetails)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(actualSynonymsDetails, null))   throw new ArgumentNullException("actualSynonymsDetails");
            if (ReferenceEquals(expectedSynonymsDetails, null)) throw new ArgumentNullException("expectedSynonymsDetails");

            actualSynonymsDetails.Count.Should().Be(expectedSynonymsDetails.Count);

            for (int synonymIndex = 0; synonymIndex < actualSynonymsDetails.Count; synonymIndex++)
            {
                var synonymDetails         = actualSynonymsDetails[synonymIndex];
                var expectedSynonymDetails = expectedSynonymsDetails[synonymIndex];

                synonymDetails.Verbatim.Should().BeEquivalentTo(expectedSynonymDetails.Verbatim);
                synonymDetails.ListName.Should().BeEquivalentTo(expectedSynonymDetails.ListName);
            }

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertSynonymApprovalsFilteredByDateRange(
           this CoderDeclarativeBrowser browser,
           string dateRange,
           IList<SynonymRow> actualSynonymsDetails,
           IList<string> expectedVerbatims)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(dateRange))                throw new ArgumentNullException("dateRange");
            if (ReferenceEquals(actualSynonymsDetails, null))   throw new ArgumentNullException("actualSynonymsDetails");
            if (ReferenceEquals(expectedVerbatims, null))       throw new ArgumentNullException("expectedVerbatims");
            
            var actualVerbatims = actualSynonymsDetails.Select(x => x.Verbatim).ToList();

            browser.AssertVerbatimsAreEquivalent(actualVerbatims, expectedVerbatims);
            
            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

            DateTime currentTime = DateTime.Now;
            DateTime endDate;   
            TimeSpan days;

            switch (dateRange)
            {
                case SynonymApprovalPage.DateFilterOptionToday:
                {
                    endDate = currentTime;
                    days    = currentTime - DateTime.Today;
                    break;
                }
                case SynonymApprovalPage.DateFilterOptionSeven:
                {
                    endDate = DateTime.Today;
                    days    = TimeSpan.FromDays(7);
                    break;
                }
                case SynonymApprovalPage.DateFilterOptionSevenToFourteen:
                {
                    endDate = DateTime.Today - TimeSpan.FromDays(7);
                    days    = TimeSpan.FromDays(7);
                    break;
                }
                case SynonymApprovalPage.DateFilterOptionFourteenToThirty:
                {
                    endDate = DateTime.Today - TimeSpan.FromDays(14);
                    days    = TimeSpan.FromDays(16);
                    break;
                }
                case SynonymApprovalPage.DateFilterOptionThirty:
                {
                    endDate = DateTime.Today - TimeSpan.FromDays(30);
                    days    = TimeSpan.MaxValue;
                    break;
                }
                case SynonymApprovalPage.DateFilterOptionAll:
                {
                    return;
                }
                default:
                {
                    throw new InvalidOperationException(
                        "The date range selected does not have an assertion defined to verify the synonym is within that data range.");
                }
            }

            var synonymDates = actualSynonymsDetails.Select(x => x.CreationDate).ToList();

            foreach (var synonymDate in synonymDates)
            {
                synonymDate.ToDate().Should().BeWithin(days).Before(endDate);
            }   
        }

        public static void AssertSynonymDetailsFilteredByStatus(
           this CoderDeclarativeBrowser browser,
           IList<SynonymRow> actualSynonymsDetails,
           string expectedSynonym,
           string expectedStatus)
        {
            if (ReferenceEquals(browser, null))                         throw new ArgumentNullException("browser");
            if (ReferenceEquals(actualSynonymsDetails, null))           throw new ArgumentNullException("actualSynonymsDetails");
            if (String.IsNullOrEmpty(expectedSynonym))                  throw new ArgumentNullException("expectedSynonym");
            if (String.IsNullOrEmpty(expectedStatus))                   throw new ArgumentNullException("expectedStatus");
            
            foreach (var actualSynonymDetails in actualSynonymsDetails)
            {
                actualSynonymDetails.Verbatim.Should().BeEquivalentTo(expectedSynonym);
                actualSynonymDetails.Status  .Should().Be(SynonymDisplay.GetSynonymStatus(expectedStatus));
            }

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertVerbatimsAreEquivalent(
           this CoderDeclarativeBrowser browser,
           IList<string> actualVerbatims,
           IList<string> expectedVerbatims)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (ReferenceEquals(actualVerbatims, null)) throw new ArgumentNullException("actualVerbatims");
            if (ReferenceEquals(expectedVerbatims, null)) throw new ArgumentNullException("expectedVerbatims");

            actualVerbatims.Should().BeEquivalentTo(expectedVerbatims);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }



    }
}
