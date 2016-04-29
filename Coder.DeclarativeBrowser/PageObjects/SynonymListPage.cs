using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coypu;
using NUnit.Framework;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal class SynonymListPage
    {
        private readonly BrowserSession _Browser;

        private const string _ViewButtonXPath   = "td[last()]/div/*[@class='btn']";
        private const string _MoreButtonXPath = "td[last()]/div/*[@class='btn btn-default dropdown-toggle']";
        private const string _DownloadButtonXPath = "//a[contains(@id, '-download')]";
        private const string _SynonymCountXPath = "td[@ng-bind='list.numberOfSynonyms']";

        internal SynonymListPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        private SessionElementScope GetFirstTable()
        {
            // Multiple dictionaries will create multiple tables, causing FindSessionElementByXPath to fail
            // coypu options are not set to take the first element found and overriding will not be available until the refactoring is complete.
            IList<SessionElementScope> allTables = _Browser.FindAllSessionElementsByXPath("//table[@class='table'][1]");

            Assert.Greater(allTables.Count,0,"No tables were found on the synonyms list page.");

            var firstTable = allTables[0];

            return firstTable;
        }

        private IList<SessionElementScope> GetDictionaryListPanels()
        {
            var dictionaryListPanels = _Browser.FindAllSessionElementsByXPath(
                "//div[@class='col-md-12 ng-scope']/div");

            return dictionaryListPanels;
        }

        private SessionElementScope GetDictionaryLocalePanel(string dictionary, string locale)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(locale))     throw new ArgumentNullException("locale");

            var dictionaryLocalePanels = GetDictionaryListPanels();
            var dictionaryLocalePanel  = dictionaryLocalePanels.FirstOrDefault(
                x => x.FindSessionElementByXPath("div/h4").Text.ContainsAll(dictionary, locale));

            if (ReferenceEquals(dictionaryLocalePanel, null))
                throw new MissingHtmlException(
                    String.Format("No synonym list for dictiony {0} and locale {1} found", dictionary, locale));

            return dictionaryLocalePanel;
        }

        private IList<SessionElementScope> GetDictionaryLocaleVersionPanels(string dictionary, string locale)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(locale))     throw new ArgumentNullException("locale");

            var dictionaryLocalePanel = 
                RetryPolicy.FindElement.Execute(() => GetDictionaryLocalePanel(dictionary, locale));

            var versionPanels =
                dictionaryLocalePanel.FindAllSessionElementsByXPath("div[@id='dictionaryVersionLocalePanel']");

            return versionPanels;
        }

        private SessionElementScope GetDictionaryLocaleVersionPanel(string dictionary, string locale, string version)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(locale))     throw new ArgumentNullException("locale");
            if (String.IsNullOrWhiteSpace(version))    throw new ArgumentNullException("version");

            var versionPanels = GetDictionaryLocaleVersionPanels(dictionary, locale);
            var versionPanel  = versionPanels.FirstOrDefault(
                x => x.FindSessionElementByXPath(".//h4").Text.Contains(version));

            if (ReferenceEquals(versionPanel,null))
                throw new ArgumentException(
                    String.Format("No version {0} found for dictionary {1} and locale {2}", version, dictionary, locale));

            return versionPanel;
        }

        private SessionElementScope GetCreateNewListButton(string dictionary, string locale, string version)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(locale))     throw new ArgumentNullException("locale");
            if (String.IsNullOrWhiteSpace(version))    throw new ArgumentNullException("version");

            var versionPanel = GetDictionaryLocaleVersionPanel(dictionary, locale, version);
            var createListButton = versionPanel.FindSessionElementByXPath("//a[span[contains(text(),'Create a list')]]");

            return createListButton;
        }

        private IList<SessionElementScope> GetSynonymListRows(string dictionary, string locale, string version)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(locale))     throw new ArgumentNullException("locale");
            if (String.IsNullOrWhiteSpace(version))    throw new ArgumentNullException("version");

            var dictionaryLocalePanel = GetDictionaryLocaleVersionPanel(dictionary, locale, version);
            var synonymListRows       = dictionaryLocalePanel.FindAllSessionElementsByXPath(".//table/tbody/tr");

            return synonymListRows;
        }

        private SessionElementScope GetSynonymListRow(string dictionary, string locale, string version)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(locale))     throw new ArgumentNullException("locale");
            if (String.IsNullOrWhiteSpace(version)) throw new ArgumentNullException("version");

            var synonymListRows = GetSynonymListRows(dictionary, locale, version);
            var synonymListRow  = synonymListRows.FirstOrDefault();

            return synonymListRow;
        }

        private SessionElementScope GetSynonymListRow(string dictionary, string locale, string version, string listName)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(locale))     throw new ArgumentNullException("locale");
            if (String.IsNullOrWhiteSpace(listName))   throw new ArgumentNullException("listName");

            var synonymListRows = GetSynonymListRows(dictionary, locale, version);
            var synonymListRow  = synonymListRows.FirstOrDefault(
                x => x.FindSessionElementByXPath("td[@ng-bind='list.name']").Text.Contains(listName));

            if (ReferenceEquals(synonymListRow,null))
                throw new ArgumentException(
                    String.Format("No synonym list named {0} found for dictionary {1} and locale {2} and version {3}",
                    listName, dictionary, locale, version));

            return synonymListRow;
        }

        private SessionElementScope GetSynonymListViewButton(string dictionary, string locale, string version)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(locale))     throw new ArgumentNullException("locale");
            if (String.IsNullOrWhiteSpace(version)) throw new ArgumentNullException("version");

            var synonymListRow = GetSynonymListRow(dictionary, locale, version);
            var viewButton     = synonymListRow.FindSessionElementByXPath(_ViewButtonXPath);

            return viewButton;
        }

        private SessionElementScope GetSynonymListMoreButton(string dictionary, string locale, string version)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(locale)) throw new ArgumentNullException("locale");
            if (String.IsNullOrWhiteSpace(version)) throw new ArgumentNullException("version");

            var synonymListRow = GetSynonymListRow(dictionary, locale, version);
            var moreButton = synonymListRow.FindSessionElementByXPath(_MoreButtonXPath);

            return moreButton;
        }

        private SessionElementScope GetSynonymListDownloadButton()
        {
            var downloadButton = _Browser.FindSessionElementByXPath(_DownloadButtonXPath);

            return downloadButton;
        }

        private SessionElementScope GetSynonymListDisabledDownloadListItem()
        {
            var downloadButton = _Browser.FindSessionElementByXPath("//li[contains(@class,'disabled')]" +
                _DownloadButtonXPath);

            return downloadButton;
        }

        internal int GetSynonymListCount(string dictionary, string locale, string version)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(locale)) throw new ArgumentNullException("locale");
            if (String.IsNullOrWhiteSpace(version)) throw new ArgumentNullException("version");

            LoadSynonymListPage();

            var synonymListRow = GetSynonymListRow(dictionary, locale, version);
            var countElement   = synonymListRow.FindSessionElementByXPath(_SynonymCountXPath);

            var count = 0;

            Int32.TryParse(countElement.Text, out count);

            return count;
        }

        private SessionElementScope GetSynonymListViewButton(string dictionary, string locale, string version, string listName)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(locale))     throw new ArgumentNullException("locale");
            if (String.IsNullOrWhiteSpace(listName))   throw new ArgumentNullException("listName");

            var synonymListRow = GetSynonymListRow(dictionary, locale, version, listName);
            var viewButton     = synonymListRow.FindSessionElementByXPath(_ViewButtonXPath);

            return viewButton;
        }

        internal void WaitForSynonymListToReachCount(SynonymSearch synonymSearch, int expectedSynonymCount)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");
            if (expectedSynonymCount < 0)             throw new ArgumentOutOfRangeException("expectedSynonymCount should be >= 0");

            LoadSynonymListPage();

            RetryPolicy.GetAutoUpdatingElement.Execute(
                () =>
                {
                    var synonymCount = GetSynonymListCount(
                        synonymSearch.Dictionary, 
                        synonymSearch.Locale,
                        synonymSearch.Version);

                    if (synonymCount < expectedSynonymCount)
                    {
                        throw new AssertionException(String.Format("Current Synonym Count is: {0}", synonymCount));
                    }
                });
        }

        internal bool SelectSynonymList(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            LoadSynonymListPage();

            bool viewSynonymListAvailable = IsViewSynonymListAvailable(synonymSearch);

            if (viewSynonymListAvailable)
            {
                if (String.IsNullOrWhiteSpace(synonymSearch.SynonymList))
                {
                    GetSynonymListViewButton(synonymSearch.Dictionary, synonymSearch.Locale, synonymSearch.Version).Click();
                }
                else
                {
                    GetSynonymListViewButton(synonymSearch.Dictionary, synonymSearch.Locale, synonymSearch.Version, synonymSearch.SynonymList).Click();
                }
            }

            return viewSynonymListAvailable;
        }

        /// <summary>
        /// Initiates a download of the specified synonym list and returns the number of synonyms to be downloaded
        /// </summary>
        /// <param name="synonymSearch"></param>
        internal int SelectDownloadSynonymList(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            LoadSynonymListPage();

            int synonymsCount = GetSynonymListCount(synonymSearch.Dictionary, synonymSearch.Locale, synonymSearch.Version);

            GetSynonymListMoreButton(synonymSearch.Dictionary, synonymSearch.Locale, synonymSearch.Version).Click();
            
            _Browser.WaitUntilElementExists(GetSynonymListDownloadButton);

            GetSynonymListDownloadButton().Click();

            return synonymsCount;
        }

        internal void InitiateNewListCreation(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            LoadSynonymListPage();

            var createButton = GetCreateNewListButton(synonymSearch.Dictionary, synonymSearch.Locale, synonymSearch.Version);

            createButton.Click();
        }

        private void LoadSynonymListPage()
        {
            var header = _Browser.GetPageHeader();
            header.GoToAdminPage("Synonym List");

            _Browser.WaitUntilElementExists(GetFirstTable);
        }

        internal bool IsDownloadSynonymListAvailable(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            LoadSynonymListPage();

            GetSynonymListMoreButton(synonymSearch.Dictionary, synonymSearch.Locale, synonymSearch.Version).Click();

            _Browser.WaitUntilElementExists(GetSynonymListDownloadButton);
            
            return !GetSynonymListDisabledDownloadListItem().Exists(Config.ExistsOptions);
        }

        internal bool IsViewSynonymListAvailable(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            LoadSynonymListPage();

            SessionElementScope synonymListViewButton ;

            if (String.IsNullOrWhiteSpace(synonymSearch.SynonymList))
            {
                synonymListViewButton = GetSynonymListViewButton(synonymSearch.Dictionary, synonymSearch.Locale, synonymSearch.Version);
            }
            else
            {
                synonymListViewButton = GetSynonymListViewButton(synonymSearch.Dictionary, synonymSearch.Locale, synonymSearch.Version, synonymSearch.SynonymList);
            }

            return !synonymListViewButton.OuterHTML.Contains("disabled=\"disabled\"");
        }
    }
}