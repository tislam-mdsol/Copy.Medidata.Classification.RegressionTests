using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;
using NUnit.Framework;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class AdminSynonymPage
    {
        private const string PageName   = "Synonym";
        private readonly BrowserSession _Session;

        internal AdminSynonymPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))  throw new ArgumentNullException("session");  
            
            _Session = session;
        }

        internal void GoTo()
        {
            if (!OnSynonymPage())
            {
                _Session.GoToAdminPage(PageName);
            }
        }

        internal bool OnSynonymPage()
        {
            var title = _Session.Title;

            return title.Equals("Synonym");
        }

        internal SessionElementScope GetDictionaryDropDownList()
        {
            var dictionaryDropDownList = _Session
                .FindSessionElementByXPath("//select[@id='ctl00_Content_ddlDictionaries']");

            return dictionaryDropDownList;
        }

        internal SessionElementScope GetLocaleDropDownList()
        {
            var localeDropDownList =_Session
                .FindSessionElementByXPath("//select[@id='ctl00_Content_ddlLocaleACG_ddlLocales']");

            return localeDropDownList;
        }

        internal SessionElementScope GetVersionDropDownList()
        {
            var versionDropDownList = _Session
                .FindSessionElementByXPath("//select[@id='ctl00_Content_ddlVersionACG_ddlVersions']");

            return versionDropDownList;
        }

        internal SessionElementScope GetDisplayActivatedListsCheckBox()
        {
            var displayActivatedListsCheckBox = _Session
                .FindSessionElementByXPath("//input[@id='ctl00_Content_ChkDisplayActivatedListOnly']");

            return displayActivatedListsCheckBox;
        }

        internal SessionElementScope GetStartNewSynonymListButton()
        {
            var startNewSynonymListButton = _Session
                .FindSessionElementByXPath("//a[@id='ctl00_Content_upSynACG_dontUpBtn']");

            return startNewSynonymListButton;
        }

        internal SessionElementScope GetMigrateListFromVersionDropDownList()
        {
            var migrateListFromVersionDropDownList = _Session
                .FindSessionElementByXPath("//select[@id='ctl00_Content_upSynACG_ddlDictionaryVersions']");

            return migrateListFromVersionDropDownList;
        }

        internal SessionElementScope GetMigrateListFromListNameDropDownList()
        {
            var migrateListFromListNameDropDownList = _Session
                .FindSessionElementByXPath("//select[@id='ctl00_Content_upSynACG_ddlSynonymLists']");

            return migrateListFromListNameDropDownList;
        }

        internal SessionElementScope GetMigrateButton()
        {
            var migrateButton = _Session
                .FindSessionElementByXPath("//a[@id='ctl00_Content_upSynACG_upgradeBtn']");

            return migrateButton;
        }

        internal SessionElementScope GetAddNewButton()
        {
            var addNewButton = _Session
                .FindSessionElementByXPath("//a[@id='ctl00_Content_dversions_FooterRow_LnkAddNewdversions']");

            return addNewButton;
        }

        internal SessionElementScope GetEditingRowListNameTextBox()
        {
            var editingRowListNameTextBox = _Session
                .FindSessionElementByXPath("//input[@id='ctl00_Content_dversions_DXEditor0_I']");

            return editingRowListNameTextBox;
        }

        internal SessionElementScope GetEditingRowSaveButton()
        {
            var editingRowSaveButton = _Session
                .FindSessionElementByXPath("//img[@title='Update' and contains(@src, 'check.gif')]");

            return editingRowSaveButton;
        }

        internal SessionElementScope GetEditingRowCancelButton()
        {
            var editingRowCancelButton = _Session
                .FindSessionElementByXPath("//img[@title='Cancel' and contains(@src, 'cancel.gif')]");

            return editingRowCancelButton;
        }

        internal SessionElementScope GetUpgradeSynonymListLinkByListName(string synonymListName)
        {
            if (String.IsNullOrEmpty(synonymListName)) throw new ArgumentNullException("synonymListName");
            
            var upgradeSynonymListLink = _Session
                .FindSessionElementByXPath(string.Format("//tr[contains(@id, 'ctl00_Content_dversions_DXDataRow') and td[text()='{0}']]//a[contains(text(),'Upgrade Synonym List')]", synonymListName));

            return upgradeSynonymListLink;
        }

        internal SessionElementScope GetUploadSynonymsLinkByListName(string synonymListName)
        {
            if (String.IsNullOrEmpty(synonymListName)) throw new ArgumentNullException("synonymListName");

            var uploadSynonymListLink = _Session
                .FindSessionElementByXPath(string.Format("//tr[contains(@id, 'ctl00_Content_dversions_DXDataRow') and td[text()='{0}']]//a[contains(text(),'Upload Synonyms')]", synonymListName));

            return uploadSynonymListLink;
        }

        internal SessionElementScope GetDownloadSynonymsButtonByListName(string synonymListName)
        {
            if (String.IsNullOrEmpty(synonymListName)) throw new ArgumentNullException("synonymListName");

            var downloadSynonymListButton = _Session
                .FindSessionElementByXPath(string.Format("//tr[contains(@id, 'ctl00_Content_dversions_DXDataRow') and td[text()='{0}']]//a[contains(@title,'Download')]", synonymListName));

            return downloadSynonymListButton;
        }

        internal SessionElementScope GetSynonymDetailsLink(string synonymListName)
        {
            if (String.IsNullOrEmpty(synonymListName)) throw new ArgumentNullException("synonymListName");

            var synonymDetailsLink = _Session
                .FindSessionElementByXPath(string.Format("//tr[contains(@id, 'ctl00_Content_dversions_DXDataRow') and td[text()='{0}']]//a[contains(text(),'Synonym Details')]", synonymListName));

            return synonymDetailsLink;
        }

        internal SessionElementScope GetDeleteSynonymListButtonByListName(string synonymListName)
        {
            if (String.IsNullOrEmpty(synonymListName)) throw new ArgumentNullException("synonymListName");

            var deleteSynonymListButton = _Session
                .FindSessionElementByXPath(string.Format("//tr[contains(@id, 'ctl00_Content_dversions_DXDataRow') and td[text()='{0}']]//a[contains(@onclick, 'DeleteRow')]", synonymListName));

            return deleteSynonymListButton;
        }

        internal SessionElementScope GetSynonymListRowByListName(string synonymListName)
        {
            if (String.IsNullOrEmpty(synonymListName)) throw new ArgumentNullException("synonymListName");

            var upgradeSynonymListLink = _Session
                .FindSessionElementByXPath(string.Format("//tr[contains(@id, 'ctl00_Content_dversions_DXDataRow') and td[text()='{0}']]", synonymListName));

            return upgradeSynonymListLink;
        }

        internal SessionElementScope GetSynonymListStatusByListName(string synonymListName, string sourceDictionaryVersion)
        {
            if (String.IsNullOrEmpty(synonymListName))          throw new ArgumentNullException("synonymListName");
            if (String.IsNullOrEmpty(sourceDictionaryVersion))  throw new ArgumentNullException("sourceDictionaryVersion");
            
            var upgradeSynonymListLink = _Session
                .FindSessionElementByXPath(string.Format("//tr[contains(@id, 'ctl00_Content_dversions_DXDataRow') and td[text()='{0}']]/td[contains(text(), 'List setup complete for synonyms from version {1}')]", synonymListName, sourceDictionaryVersion));

            return upgradeSynonymListLink;
        }

        internal SessionElementScope GetSynonymListLoaderByListName(string synonymListName)
        {
            if (String.IsNullOrEmpty(synonymListName)) throw new ArgumentNullException("synonymListName");

            var upgradeSynonymListLink = _Session
                .FindSessionElementByXPath(string.Format("//tr[contains(@id, 'ctl00_Content_dversions_DXDataRow') and td[text()='{0}']]//td/img[contains(@src, 'ajax-loader')]", synonymListName));

            return upgradeSynonymListLink;
        }

        internal AdminSynonymList GetSynonymListTableValuesByListName(string synonymListName)
        {
            if (String.IsNullOrEmpty(synonymListName)) throw new ArgumentNullException("synonymListName");

            var rowXPath = string.Format("//tr[contains(@id, 'ctl00_Content_dversions_DXDataRow') and td[text()='{0}']]/td", synonymListName);

            var synonymList = new AdminSynonymList
            {
                ListName            = _Session.FindAllSessionElementsByXPath(rowXPath)[0].InnerHTML,
                NumberOfSynonyms    = _Session.FindSessionElementByXPath(rowXPath + "[2]/span").InnerHTML,
                Status              = _Session.FindAllSessionElementsByXPath(rowXPath)[2].InnerHTML,
                HasReconciliations  = _Session.FindSessionElementByXPath(rowXPath + "[4]/a[contains(text(), 'Reconcile Synonym Migration')]").Exists(Config.ExistsOptions)
            };

            return synonymList;
        }

        internal int GetNumberOfSynonymsByListName(SynonymList synonymList)
        {
            if (ReferenceEquals(synonymList, null)) throw new ArgumentNullException("synonymList");
            if (String.IsNullOrWhiteSpace(synonymList.SynonymListName)) throw new ArgumentNullException("synonymList.SynonymListName");

            SelectSynonymList(synonymList);

            var rowXPath = string.Format("//tr[contains(@id, 'ctl00_Content_dversions_DXDataRow') and td[text()='{0}']]/td", synonymList.SynonymListName);

            int NumberOfSynonyms = _Session.FindSessionElementByXPath(rowXPath + "[2]/span").InnerHTML.ToInteger();

            return NumberOfSynonyms;
        }

        internal SessionElementScope GetReconcileSynonymMigrationLinkByListName(string synonymListName)
        {
            if (String.IsNullOrEmpty(synonymListName)) throw new ArgumentNullException("synonymListName");

            var reconcileSynonymMigrationLink = _Session
                .FindSessionElementByXPath(string.Format("//tr[contains(@id, 'ctl00_Content_dversions_DXDataRow') and td[text()='{0}']]//a[contains(text(),'Reconcile Synonym Migration')]", synonymListName));

            return reconcileSynonymMigrationLink;
        }

        internal void SelectSynonymList(SynonymList synonymList)
        {
            if (ReferenceEquals(synonymList, null)) throw new ArgumentNullException("synonymList");

            GetDictionaryDropDownList().SelectOptionAlphanumericOnly(synonymList.Dictionary);
            WaitUntilFinishLoading();

            GetLocaleDropDownList().SelectOption(synonymList.Locale);
            WaitUntilFinishLoading();

            GetVersionDropDownList().SelectOption(synonymList.Version);
            WaitUntilFinishLoading();
        }

        /// <summary>
        /// Initiates a download of the specified synonym list and returns the number of synonyms to be downloaded
        /// </summary>
        internal int SelectDownloadSynonymList(SynonymList synonymList)
        {
            if (ReferenceEquals(synonymList, null)) throw new ArgumentNullException("synonymList");

            int synonymsCount = GetNumberOfSynonymsByListName(synonymList);

            GetDownloadSynonymsButtonByListName(synonymList.SynonymListName).Click();

            return synonymsCount;
        }

        internal void WaitForSynonymPageActivityToComplete(string synonymName)
        {
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            var options         = new Options
            {
                RetryInterval   = TimeSpan.FromSeconds(1),
                Timeout         = TimeSpan.FromSeconds(240)
            };

            _Session.TryUntil(
                GetSynonymListRowByListName(synonymName).Click,
                GetSynonymListLoaderByListName(synonymName).Missing,
                options.WaitBeforeClick,
                options);
        }

        internal bool IsDownloadSynonymListAvailable(SynonymList synonymList)
        {
            if (ReferenceEquals(synonymList, null)) throw new ArgumentNullException("synonymList");
            if (String.IsNullOrWhiteSpace(synonymList.SynonymListName)) throw new ArgumentNullException("synonymList.SynonymListName");

            SelectSynonymList(synonymList);

            return GetDownloadSynonymsButtonByListName(synonymList.SynonymListName).Exists(Config.ExistsOptions);
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
