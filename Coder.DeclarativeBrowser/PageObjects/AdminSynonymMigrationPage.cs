using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;
using NUnit.Framework;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class AdminSynonymMigrationPage
    {
        private readonly BrowserSession _Session;

        private const string CategoryRowByNameXPath     = "//tr[contains(@id, 'ctl00_Content_dsynCategories_DXDataRow') and td[text()='{0}']]{1}";
        private const string CategoryRowXPath           = "//tr[contains(@id, 'ctl00_Content_dsynCategories_DXDataRow')]{0}";
        private const string FirstSuggestionRowXPath    = "//tr[contains(@id, 'ctl00_Content_dsynReconcs_DXDataRow0')]{0}";
        private const string SuggestionDetailRowXPath   = "//tr[contains(@id, 'ctl00_Content_dsynReconcs_dxdt') and contains(@id, 'DXDataRow{0}')]{1}";
        private const string SuggestionRowByNameXPath   = "//tr[contains(@id, 'ctl00_Content_dsynReconcs_DXDataRow') and td[2]/span[text()=\"{0}\"]]{1}";
        private const string SuggestionRowExpanderXPath = "//img[contains(@alt, '[Expand]') or contains(@alt, '[Collapse]')]";

        internal AdminSynonymMigrationPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))  throw new ArgumentNullException("session"); 
            
            _Session = session;
        }

        internal void GoTo(SynonymList synonymList)
        {
            var adminSynonymPage = _Session.OpenAdminSynonymPage();

            adminSynonymPage.SelectSynonymList(synonymList);

            adminSynonymPage
                .GetReconcileSynonymMigrationLinkByListName(synonymList.SynonymListName)
                .Click();
        }

        internal SessionElementScope GetDropSynonymButton()
        {
            var dropSynonymButton = _Session
                .FindSessionElementByXPath("//a[@id='ctl00_Content_dropSynonym']");

            return dropSynonymButton;
        }

        internal SessionElementScope GetAcceptSuggestionButton()
        {
            var acceptSuggestionButton = _Session
                .FindSessionElementByXPath("//a[@id='ctl00_Content_acceptSuggestion']");

            return acceptSuggestionButton;
        }

        internal SessionElementScope GetMigrateSynonymsButton()
        {
            var migrateSynonymsButton = _Session
                .FindSessionElementByXPath("//a[@id='ctl00_Content_progressACG_executeMigration']");

            return migrateSynonymsButton;
        }

        internal SessionElementScope GetCategoryRowNotMigratedCountButtonByCategoryType(string categoryType)
        {
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");

            var categoryRowSynonymCountButtonXPath = string.Format(CategoryRowByNameXPath, categoryType, "//i[contains(@style, 'alerthigh.gif')]/parent::b/parent::a");

            var categoryRowSynonymCountButton = _Session
                    .FindSessionElementByXPath(categoryRowSynonymCountButtonXPath);

            return categoryRowSynonymCountButton;
        }

        internal SessionElementScope GetCategoryRowMigratedCountButtonByCategoryType(string categoryType)
        {
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");

            var categoryRowMigratedCountButtonXPath = string.Format(CategoryRowByNameXPath, categoryType, "/td[3]/a");

            var categoryRowMigratedCountButton = _Session
                    .FindSessionElementByXPath(categoryRowMigratedCountButtonXPath);

            return categoryRowMigratedCountButton;
        }

        internal SessionElementScope GetCategoryRowDeclinedMigratedCountButtonByCategoryType(string categoryType)
        {
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");

            var categoryRowDeclinedMigratedCountButtonXPath = string.Format(CategoryRowByNameXPath, categoryType, "/td[4]/a");

            var categoryRowDeclinedMigratedCountButton = _Session
                    .FindSessionElementByXPath(categoryRowDeclinedMigratedCountButtonXPath);

            return categoryRowDeclinedMigratedCountButton;
        }

        internal SessionElementScope GetSynonymSuggestionRowBySynonymName(string synonymName)
        {
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            var suggestionRowXPath = string.Format(SuggestionRowByNameXPath, synonymName.ToUpper(), string.Empty);

            var synonymSuggestionRow = _Session
                    .FindSessionElementByXPath(suggestionRowXPath);

            return synonymSuggestionRow;
        }

        internal SessionElementScope GetSynonymSuggestionRowExpanderBySynonymName(string synonymName)
        {
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            var synonymSuggestionRowExpanderXPath = string.Format(SuggestionRowByNameXPath, synonymName.ToUpper(), SuggestionRowExpanderXPath);

            var synonymSuggestionRowExpander = _Session
                .FindSessionElementByXPath(synonymSuggestionRowExpanderXPath);

            return synonymSuggestionRowExpander;
        }

        /// <summary>
        /// Gets the Accept Suggestion link for the first suggestion row on the Synonym Migration Reconciliation page.
        /// </summary>
        internal SessionElementScope GetAcceptSuggestionLinkInExpandedSynonymSuggestionRow()
        {
            WaitUntilFinishLoading();
            var acceptSuggestionLinks = _Session.FindAllSessionElementsByXPath(string.Format(SuggestionDetailRowXPath, String.Empty, "//a[contains(text(),'Accept Suggestion')]"));

            if (ReferenceEquals(acceptSuggestionLinks, null) || acceptSuggestionLinks.Count == 0)
            {
                throw new NullReferenceException("acceptSuggestionLinks");
            }

            var acceptSuggestionLink = acceptSuggestionLinks[0];

            return acceptSuggestionLink;
        }

        internal IList<string> GetAllCategoryTypes()
        {
            var categoryTypes = RetryPolicy.FindElement.Execute(
                () =>
                    CheckForAllCategoryTypes()
                );

            return categoryTypes;
        }

        private IList<string> CheckForAllCategoryTypes()
        {
            var allCategoryRowsCategoryTypes = _Session
                    .FindAllSessionElementsByXPath(string.Format(CategoryRowXPath, "/td[1]"));

            var categoryTypes = allCategoryRowsCategoryTypes
                .Select(x => x.Text)
                .ToList();

            if (!categoryTypes.Any())
            {
                throw new MissingHtmlException("No categories displayed on Synonym Migration page");
            }

            return categoryTypes;
        }

        internal SessionElementScope GetAcceptNewVersionForAllButtonByCategoryType(string categoryType)
        {
            var acceptNewVersionForAllButton = _Session
                .FindSessionElementByXPath(string.Format(CategoryRowByNameXPath, categoryType, "//u[contains(text(),'Accept New Version For All')]/ancestor::a"));

            return acceptNewVersionForAllButton;
        }

        internal SessionElementScope GetFirstSynonymSuggestionRow()
        {
            var synonymSuggestionRow = _Session
                    .FindSessionElementByXPath(string.Format(FirstSuggestionRowXPath, String.Empty));

            return synonymSuggestionRow;
        }

        internal SessionElementScope GetFirstSynonymSuggestionRowExpander()
        {
            var synonymSuggestionRow = _Session
                    .FindSessionElementByXPath(string.Format(FirstSuggestionRowXPath, SuggestionRowExpanderXPath));

            return synonymSuggestionRow;
        }

        internal AdminSynonymMigrationCategory GetSynonymMigrationCategoryTableValuesByCategoryType(string categoryType)
        {
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");
            
            var rowXPath = string.Format(CategoryRowByNameXPath, categoryType, "/td");

            var synonymMigrationCategoryTypeXPath    = rowXPath + "[1]";
            var notMigratedCountXPath                = GetNotMigratedCountValueXPathByCategoryType(rowXPath);
            var migratedCountXPath                   = GetMigratedCountValueXPathByCategoryType(rowXPath);
            var declinedMigratedCountXPath           = GetDeclinedMigratedCountValueByCategoryType(rowXPath);

            var synonymMigrationCategory = new AdminSynonymMigrationCategory
            {
                CategoryType            = _Session.FindSessionElementByXPath(synonymMigrationCategoryTypeXPath).Text.Trim(),
                NotMigratedCount        = _Session.FindSessionElementByXPath(notMigratedCountXPath).Text.Trim(),
                MigratedCount           = _Session.FindSessionElementByXPath(migratedCountXPath).Text.Trim(),
                DeclinedMigratedCount   = _Session.FindSessionElementByXPath(declinedMigratedCountXPath).Text.Trim()
            };

            return synonymMigrationCategory;
        }

        internal AdminSynonymSuggestion GetSynonymSuggestionRowValuesBySynonymName(string synonymName)
        {
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            var suggestionRowXPath      = string.Format(SuggestionRowByNameXPath, synonymName.ToUpper(), string.Empty);

            var priorTermPathXPath      = suggestionRowXPath + "/td[3]";
            var suggestedTermPathXPath  = suggestionRowXPath + "/td[4]";

            var synonymSuggestion = new AdminSynonymSuggestion
            {
                SynonymName         = _Session.FindSessionElementByXPath(suggestionRowXPath + "/td[2]").Text,
                PriorTermPath       = GetTermPathByRowXPath(priorTermPathXPath),
                UpgradedTermPath    = GetTermPathByRowXPath(suggestedTermPathXPath)
            };
            
            return synonymSuggestion;
        }

        internal IList<AdminSynonymSuggestionDetails> GetSynonymSuggestionDetailRowValues()
        {
            var suggestionDetailRowCount = _Session.FindAllSessionElementsByXPath(string.Format(SuggestionDetailRowXPath, String.Empty, String.Empty)).Count;

            var synonymSuggestionDetails = new List<AdminSynonymSuggestionDetails>();

            for (var i = 0; i < suggestionDetailRowCount; i++)
            {
                var priorTermPathXPath      = string.Format(SuggestionDetailRowXPath, i, "//td[1]");
                var suggestedTermPathXPath  = string.Format(SuggestionDetailRowXPath, i, "//td[2]");
                var detailsXPath            = string.Format(SuggestionDetailRowXPath, i, "//td[3]");

                var synonymSuggestionDetail = new AdminSynonymSuggestionDetails
                {
                    PriorTermPath       = GetTermPathByRowXPath(priorTermPathXPath),
                    SuggestedTermPath   = GetTermPathByRowXPath(suggestedTermPathXPath),
                    Details             = _Session.FindSessionElementByXPath(detailsXPath).Text
                };

                synonymSuggestionDetails.Add(synonymSuggestionDetail);
            }

            return synonymSuggestionDetails;
        }

        internal IList<string> GetAllCategoryRowsCategoryType()
        {
            var categoryRowTypes = _Session
                    .FindAllSessionElementsByXPath(string.Format(CategoryRowXPath, "/td[1]"));

            var categoryTypes = categoryRowTypes.Select(row => row.Text).ToList();

            return categoryTypes;
        }

        internal bool AreAllSynonymsAvailableForMigration()
        {
            var categoryTypes = GetAllCategoryRowsCategoryType();

            foreach (var type in categoryTypes)
            {
                var values = GetSynonymMigrationCategoryTableValuesByCategoryType(type);

                if (values.NotMigratedCount.ToInteger() > 0)
                {
                    return false;
                }

                if (values.DeclinedMigratedCount.ToInteger() > 0)
                {
                    return false;
                }

                if (values.MigratedCount.ToInteger() <= 0)
                {
                    return false;
                }
            }

            return true;
        }

        internal bool IsSuggestionDetailTableVisible()
        {
            var isSuggestionDetailRowVisible = _Session
                .FindSessionElementByXPath("//table[contains(@id, 'ctl00_Content_dsynReconcs_dxdt') and contains(@id, 'DXMainTable')]")
                .Exists();

            return isSuggestionDetailRowVisible;
        }

        internal void WaitForSynonymSuggestionRowToExpand()
        {
            var options         = new Options
            {
                RetryInterval   = TimeSpan.FromSeconds(1),
                Timeout         = TimeSpan.FromSeconds(240)
            };

            _Session.TryUntil(
                GetFirstSynonymSuggestionRow().Click,
                IsSuggestionDetailTableVisible,
                options.WaitBeforeClick,
                options);
        }

        internal void AcceptNewVersionForAllSynonyms(string categoryType)
        {
            if (String.IsNullOrWhiteSpace(categoryType)) throw new ArgumentNullException("categoryType");
            
            RetryPolicy.CompletionAssertion.Execute(
                ()=> 
                    TryClickingAcceptingNewVersionForAll(categoryType)
                );
        }

        internal void ClickAcceptNewButtonByCategoryType(string categoryType)
        {
            if (String.IsNullOrWhiteSpace(categoryType)) throw new ArgumentNullException("categoryType");

            GetAcceptNewVersionForAllButtonByCategoryType(categoryType)
                .Click();
        }

        internal void ExpandSynonymSuggestionRowBySynonymName(string synonymName)
        {
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            var synonymSuggestionRowExpander = GetSynonymSuggestionRowExpanderBySynonymName(synonymName);

            if (synonymSuggestionRowExpander
                .GetAttribute("alt")
                .Contains("Collapse", StringComparison.OrdinalIgnoreCase))
            {
                return;
            }

            synonymSuggestionRowExpander.Click();

            WaitForSynonymSuggestionRowToExpand();
        }

        private void TryClickingAcceptingNewVersionForAll(string categoryType)
        {
            if (String.IsNullOrWhiteSpace(categoryType)) throw new ArgumentNullException("categoryType");

            ClickAcceptNewButtonByCategoryType(categoryType);

            var isSynonymSuggestionTableVisible = IsFinalizeSynonymSuggestionLabelVisible(categoryType);

            if (!isSynonymSuggestionTableVisible)
            {
                throw new AssertionException("Accept New Version For All button wasn't clicked");
            }
        }

        private string GetNotMigratedCountValueXPathByCategoryType(string rowXPath)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");

            if (_Session.FindSessionElementByXPath(rowXPath + "[2]//i[contains(@style, 'alerthigh.gif')]//following-sibling::span/u").Exists(Config.LongExistsOptions))
            {
                return rowXPath + "[2]//i[contains(@style, 'alerthigh.gif')]//following-sibling::span/u";
            }

            return rowXPath + "[2]/span";
        }

        private string GetMigratedCountValueXPathByCategoryType(string rowXPath)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");

            if (_Session.FindSessionElementByXPath(rowXPath + "[3]/a").Exists(Config.LongExistsOptions))
            {
                return rowXPath + "[3]//a";
            }

            return rowXPath + "[3]";
        }

        private string GetDeclinedMigratedCountValueByCategoryType(string rowXPath)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");

            if (_Session.FindSessionElementByXPath(rowXPath + "[4]/a").Exists(Config.LongExistsOptions))
            {
                return rowXPath + "[4]//a";
            }

            return rowXPath + "[4]";
        }

        private static string GetLevel(string outerHtml)
        {
            if (String.IsNullOrEmpty(outerHtml)) throw new ArgumentNullException("outerHtml");

            var imgIndex        = outerHtml.IndexOf("Img/", 0, StringComparison.Ordinal);
            var imgPathIndex    = outerHtml.IndexOf(".gif", 0, StringComparison.Ordinal);

            var level = outerHtml
                .Substring(imgIndex + 4, imgPathIndex - imgIndex - 4)
                .Replace("p", String.Empty);

            return level;
        }

        private IList<TermPath> GetTermPathByRowXPath(string rowXPath)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");

            var rows = _Session.FindAllSessionElementsByXPath(rowXPath + "//li");

            var termPaths = rows.Select(row => new TermPath
            {
                Level           = GetLevel(row.OuterHTML), 
                TermCode        = row.Text.Trim(), 
                HasChanged      = row.Class.Contains("changedTerm")
            })
            .ToList();

            return termPaths;
        }

        private bool IsFinalizeSynonymSuggestionLabelVisible(string categoryType)
        {
            if (String.IsNullOrWhiteSpace(categoryType)) throw new ArgumentNullException("categoryType");

            var options                                 = Config.GetDefaultCoypuOptions();

            var finalizeSynonymSuggestionLabel          = _Session
                .FindSessionElementById("ctl00_Content_CategoryTypeACG_categoryTypeName");

            if (!finalizeSynonymSuggestionLabel.Exists(options))
            {
                return false;
            }

            var isFinalizeSynonymSuggestionLabelVisible = finalizeSynonymSuggestionLabel
                .Text
                .Trim()
                .Equals(categoryType, StringComparison.OrdinalIgnoreCase);

            return isFinalizeSynonymSuggestionLabelVisible;
        }
        
        internal void WaitUntilFinishLoading()
        {
            _Session.WaitUntilElementDisappears(GetLoadingIndicator);
        }

        private SessionElementScope GetLoadingIndicator()
        {
            var loadingIndicator = _Session.FindSessionElementByXPath("//*[contains(@id, '_LPV')]");

            return loadingIndicator;
        }
    }
}
 