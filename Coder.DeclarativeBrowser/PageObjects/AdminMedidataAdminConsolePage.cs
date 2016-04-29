//@author:smalik
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class AdminMedidataAdminConsolePage
    {
        private readonly BrowserSession _Browser;

        private const int _LicenseCode = 0;
        private const int _LicenseStartDate = 1;
        private const int _LicenseEndDate = 2;
        private const int _LoggedBy = 3;

        public AdminMedidataAdminConsolePage(BrowserSession browser) {

            if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }

            _Browser = browser;
        }

        private const string PageName = "Medidata Admin Console";

        internal bool OnMedidataAdminConsolePage()
        {
            var title = _Browser.Title;

            return title.Equals(PageName);
        }

        internal void GoTo()
        {
            if (!OnMedidataAdminConsolePage())
            {
                _Browser.GoToAdminPage(PageName);
            }
        }

        internal void RolloutDictionary(String segment, String dictionary)
        {
            if (String.IsNullOrEmpty(segment)) throw new ArgumentNullException("segment");
            if (String.IsNullOrEmpty(dictionary)) throw new ArgumentNullException("dictionary");

            GoTo();

            GetDictionaryDDL().SelectOption(dictionary);
            GetSegmentsDDL().Text.Contains(segment);
            GetNewDictionaryLicensePlusButton().Click();
            GetLicenseCodeTextBox().FillInWith(Config.LicenseCode);
            GetLicenseStartDDL().FillInWith(DateTime.Today.Date.ToShortDateString());
            GetLicenseEndDDL().FillInWith(DateTime.Today.Date.AddYears(10).ToShortDateString());
            GetEdittingRowCheckMarkButton().Click();
        }

        private SessionElementScope GetSegmentsDDL()
        {
            var segmentDDL = _Browser.FindSessionElementById("ctl00_Content_ddlSegments");

            return segmentDDL;
        }

        private SessionElementScope GetDictionaryDDL()
        {
            var dictionaryDDL = _Browser.FindSessionElementById("ctl00_Content_ddlDictionaryLocale");

            return dictionaryDDL;
        }

        private SessionElementScope GetNewDictionaryLicensePlusButton()
        {
            var plusButton = _Browser.FindSessionElementById("ctl00_Content_gridLicences_FooterRow_LnkAddNewgridLicences");

            return plusButton;
        }

        private SessionElementScope GetLicenseCodeTextBox()
        {
            var licenseCodeTextBox = _Browser.FindSessionElementById("ctl00_Content_gridLicences_DXEditor0_I");

            return licenseCodeTextBox;
        }

        private SessionElementScope GetLicenseStartDDL()
        {
            var startDateDDL = _Browser.FindSessionElementById("ctl00_Content_gridLicences_DXEditor1_I");

            return startDateDDL;
        }

        private SessionElementScope GetLicenseEndDDL()
        {
            var endDate = _Browser.FindSessionElementById("ctl00_Content_gridLicences_DXEditor2_I");

            return endDate;
        }

        private SessionElementScope GetEdittingRowCheckMarkButton()
        {
            var checkMarkButton = _Browser.FindSessionElementByXPath("//tr[@id='ctl00_Content_gridLicences_DXEditingRow']/td[5]/img[1]");

            return checkMarkButton;
        }

        private IList<SessionElementScope> GetDictionaryLicensesRows()
        {
            var dictionaryLicensesRows =
                GetDictionaryLicensesGrid().FindAllSessionElementsByXPath("tbody/tr[not(contains(@id,'ctl00_Content_gridLicences_DXFooterRow')) and not(contains(@id,'ctl00_Content_gridLicences_DXHeadersRow')) ]");

            return dictionaryLicensesRows;
        }

        private SessionElementScope GetDictionaryLicensesGrid()
        {
            var dictionaryLicensesGrid = _Browser.FindSessionElementById("ctl00_Content_gridLicences_DXMainTable");

            return dictionaryLicensesGrid;
        }

        private SessionElementScope GetDictionaryWithGivenLicenseCode(String licenseCodeEntered)
        {
            var dictionaryRows        = GetDictionaryLicensesRows();
            var dictionaryLicensesRow = dictionaryRows.FirstOrDefault(
                x => x.FindAllSessionElementsByXPath("td")[0].Text.Equals(licenseCodeEntered));

            return dictionaryLicensesRow;
        }

        internal IList<LicensedDictionaryDetail> GetLicensedDictionaryDetailValues()
        {

            if (!GetDictionaryLicensesRows().Any())
            {
                throw new MissingHtmlException(String.Format("No Licensed Dictionaries present"));
            }

            var licensedDictionaryValues = (
                from licenseRow in GetDictionaryLicensesRows()
                select licenseRow.FindAllSessionElementsByXPath("td")
                    into licenseColumns
                select new LicensedDictionaryDetail
                {
                    LicenseCode = licenseColumns[_LicenseCode].Text,
                    LicenseStartDate = licenseColumns[_LicenseStartDate].Text,
                    LicenseEndDate = licenseColumns[_LicenseEndDate].Text,
                    LoggedBy = licenseColumns[_LoggedBy].Text,             
                })
                .ToList();
            return licensedDictionaryValues;
        }
    }
}
