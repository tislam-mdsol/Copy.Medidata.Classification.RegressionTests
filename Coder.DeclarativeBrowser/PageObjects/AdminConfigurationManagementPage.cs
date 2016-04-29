using System;
using System.Text;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;
using NUnit.Framework;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class AdminConfigurationManagementPage
    {
        private readonly BrowserSession _Browser;

        private const string DictionaryGridXPath    = "//table[@id='ctl00_Content_dictionaries_DXMainTable']";

        public AdminConfigurationManagementPage(BrowserSession browser) { if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }  _Browser = browser; }

        internal void GoTo()
        {
            _Browser.GoToAdminPage("Configuration");
        }

        public SessionElementScope GetCodingTaskPageSizeTextBox()
        {
            var codingTaskPageSizeTextBox = 
                _Browser.FindSessionElementByXPath("//input[@id='ctl00_Content_TxtCodingTaskPageSize']");

            return codingTaskPageSizeTextBox;
        }

        public SessionElementScope GetSearchLimitReclassificationResultsTextBox()
        {
            var searchLimitReclassificationResultsTextBox =
                _Browser.FindSessionElementByXPath("//input[@id='ctl00_Content_TxtSearchLimitReclassificationResult']");

            return searchLimitReclassificationResultsTextBox;
        }

        public SessionElementScope GetForcePrimaryPathSelectionCheckBox()
        {
            var forcePrimaryPathSelectionCheckBox =
                _Browser.FindSessionElementByXPath("//input[@id='ctl00_Content_ChkForcePrimaryPathSelection']");

            return forcePrimaryPathSelectionCheckBox;
        }

        public SessionElementScope GetBypassReconsiderUponReclassifyCheckBox()
        {
            var bypassReconsiderUponReclassifyCheckBox =
                _Browser.FindSessionElementByXPath("//input[@id='ctl00_Content_ChkBypassReconsiderUponReclassify']");

            return bypassReconsiderUponReclassifyCheckBox;
        }

        public SessionElementScope GetSynonymCreationPolicyFlagDropDownList()
        {
            var synonymCreationPolicyFlagDropDownList =
                _Browser.FindSessionElementByXPath("//select[@id='ctl00_Content_ddlSynonymCreationPolicyFlag']");

            return synonymCreationPolicyFlagDropDownList;
        }

        public SessionElementScope GetSaveButton()
        {
            var saveButton = _Browser.FindSessionElementByXPath("//a[@id='ctl00_Content_BtnSubmitCodingConfig']");

            return saveButton;
        }

        public SessionElementScope GetCancelButton()
        {
            var cancelButton = _Browser.FindSessionElementByXPath("//a[@id='ctl00_Content_BtnCancelCodingConfig']");

            return cancelButton;
        }

        public SessionElementScope GetCodingTab()
        {
            var codingTab = _Browser.FindSessionElementByXPath("//a[@id='ctl00_Content_tab0']");

            return codingTab;
        }

        public SessionElementScope GetDictionaryTab()
        {
            var dictionaryTab = _Browser.FindSessionElementByXPath("//a[@id='ctl00_Content_tab1']");

            return dictionaryTab;
        }

        public SessionElementScope GetEditingRowAutoAddSynonymsCheckbox()
        {
            var editingRowAutoAddSynonymsCheckbox =
                _Browser.FindSessionElementByXPath("//input[@id='ctl00_Content_dictionaries_DXEditor1_I']");

            return editingRowAutoAddSynonymsCheckbox;
        }

        public SessionElementScope GetEditingRowAutoApproveCheckbox()
        {
            var editingRowAutoApproveCheckbox =
                _Browser.FindSessionElementByXPath("//input[@id='ctl00_Content_dictionaries_DXEditor2_I']");

            return editingRowAutoApproveCheckbox;
        }

        public SessionElementScope GetEditingRowSaveButton()
        {
            var editingRowSaveButton =
                _Browser.FindSessionElementByXPath(
                    "//tr[@id='ctl00_Content_dictionaries_DXEditingRow']//img[contains(@title, 'Update')]");

            return editingRowSaveButton;
        }

        public SessionElementScope GetHeaderWarningMessage()
        {
            var headerWarningMessage = _Browser.FindSessionElementByXPath("//span[@class = 'HeaderSpan']");

            return headerWarningMessage;
        }

        public SessionElementScope GetCodingTaskPageSizeLimitLabel()
        {
            var codingTaskPageSizeLimitLabel =
                _Browser.FindSessionElementByXPath("//span[@id = 'ctl00_Content_VldCodingTaskPageSize']");

            return codingTaskPageSizeLimitLabel;
        }

        public SessionElementScope GetSearchLimitReclassificationResultsLimitLabel()
        {
            var searchLimitReclassificationResultsLimitLabel =
                _Browser.FindSessionElementByXPath("//span[@id = 'ctl00_Content_VldSrchLimitReclass']");

            return searchLimitReclassificationResultsLimitLabel;
        }

        public bool IsCodingTabSelected()
        {
            var isCodingTabSelected = _Browser
                .FindSessionElementByXPath("//a[@id='ctl00_Content_tab0' and contains(@class, 'selectedTabLink')]")
                .Exists();

            return isCodingTabSelected;
        }

        public bool IsDictionaryTabSelected()
        {
            var isDictionaryTabSelected = _Browser
                .FindSessionElementByXPath("//a[@id='ctl00_Content_tab1' and contains(@class, 'selectedTabLink')]")
                .Exists();

            return isDictionaryTabSelected;
        }

        public bool IsHeaderWarningMessageVisible()
        {
            var isHeaderWarningMessageVisible = _Browser
                .FindSessionElementByXPath("//table[@class = 'HeaderTable']")
                .Exists();

            return isHeaderWarningMessageVisible;
        }

        public SessionElementScope GetDictionaryRowEnableEditButtonByMedicalDictionaryName(string medicalDictionaryName)
        {
            if (String.IsNullOrEmpty(medicalDictionaryName))  throw new ArgumentNullException("medicalDictionaryName"); 

            var editButtonXPath     = BuildDictionaryEditButtonXPath(medicalDictionaryName);
            var editButton          = _Browser.FindSessionElementByXPath(editButtonXPath);

            return editButton;
        }

        public AdminConfigurationManagement GetAdminConfigurationManagementPageValues(string medicalDictionaryName)
        {
            if (String.IsNullOrEmpty(medicalDictionaryName))  throw new ArgumentNullException("medicalDictionaryName");

            GetCodingTab().Click();

            var forcePrimaryPathSelection = GetForcePrimaryPathSelectionCheckBox()
                .OuterHTML
                .Contains("CHECKED=\"CHECKED\"", StringComparison.OrdinalIgnoreCase)
                    ? "True"
                    : "False";

            var bypassReconsiderUponReclassify = GetBypassReconsiderUponReclassifyCheckBox()
                .OuterHTML
                .Contains("CHECKED=\"CHECKED\"", StringComparison.OrdinalIgnoreCase)
                    ? "True"
                    : "False";

            var synonymCreationPolicyFlag = GetSynonymCreationPolicyFlagDropDownList().SelectedOption;

            GetDictionaryTab().Click();

            var dictionaryGridRowXPath  = BuildDictionaryRowXPathByMedicalDictionaryName(medicalDictionaryName);
            var autoAddSynonymsCheckbox = _Browser.FindSessionElementByXPath(dictionaryGridRowXPath + "/td[2]/img");
            var autoApproveCheckbox     = _Browser.FindSessionElementByXPath(dictionaryGridRowXPath + "/td[3]/img");

            var autoAddSynonyms = autoAddSynonymsCheckbox
                .OuterHTML
                .Contains("UNCHECKED", StringComparison.OrdinalIgnoreCase)
                    ? "False"
                    : "True";

            var autoApprove = autoApproveCheckbox
                .OuterHTML
                .Contains("UNCHECKED", StringComparison.OrdinalIgnoreCase)
                    ? "False"
                    : "True";

            var adminConfigurationManagementValues = new AdminConfigurationManagement
            {
                ForcePrimaryPathSelection      = forcePrimaryPathSelection,
                BypassReconsiderUponReclassify = bypassReconsiderUponReclassify,
                SynonymCreationPolicyFlag      = synonymCreationPolicyFlag,
                AutoAddSynonyms                = autoAddSynonyms,
                AutoApprove                    = autoApprove
            };

            return adminConfigurationManagementValues;
        }

        public bool IsEditModeEnabledForMedicalDictionaryRow(string medicalDictionaryName)
        {
            if (String.IsNullOrEmpty(medicalDictionaryName)) throw new ArgumentNullException("medicalDictionaryName");

            var medicalDictionaryNameFilter = String.Format("and td[1]/text() ='{0}'", medicalDictionaryName);

            var isEditModeEnabled =
                _Browser.FindSessionElementByXPath(
                    String.Format("//tr[@id='ctl00_Content_dictionaries_DXEditingRow' {0}]",
                        medicalDictionaryNameFilter))
                    .Exists(Config.ExistsOptions);

            return isEditModeEnabled;
        }

        private static string BuildDictionaryEditButtonXPath(string medicalDictionaryName)
        {
            if (String.IsNullOrEmpty(medicalDictionaryName))  throw new ArgumentNullException("medicalDictionaryName"); 

            var dictionaryRowXPath = BuildDictionaryRowXPathByMedicalDictionaryName(medicalDictionaryName);

            var sb = new StringBuilder();

            sb.Append(dictionaryRowXPath);
            sb.Append("/td/a[contains(@onclick,'aspxGVStartEditRow')]");

            var editButtonXPath = sb.ToString();

            return editButtonXPath;
        }

        private static string BuildDictionaryRowXPathByMedicalDictionaryName(string medicalDictionaryName)
        {
            if (String.IsNullOrEmpty(medicalDictionaryName))  throw new ArgumentNullException("medicalDictionaryName"); 

            var sb = new StringBuilder();

            sb.Append(DictionaryGridXPath);
            sb.Append(string.Format("/tbody/tr[contains(@id,'ctl00_Content_dictionaries_DXDataRow') and td[1]/text() ='{0}']", medicalDictionaryName));

            var dictionaryRowXPath = sb.ToString();

            return dictionaryRowXPath;
        }

        public SessionElementScope GetTextboxElementByTextboxName(string textboxName)
        {
            if (String.IsNullOrEmpty(textboxName)) throw new ArgumentNullException("textboxName");

            var textBox = _Browser
                .FindSessionElementByXPath(string.Format("//span[text()='{0}']/../following-sibling::td/input", textboxName));

            return textBox;
        }

        public SessionElementScope GetTextboxLimitLabelElementByTextboxName(string textboxName)
        {
            if (String.IsNullOrEmpty(textboxName)) throw new ArgumentNullException("textboxName");

            var textBox = _Browser
                .FindSessionElementByXPath(string.Format("//span[text()='{0}']/../following-sibling::td/span", textboxName));

            return textBox;
        }
        
        internal void SetConfigurationFunctionalityForcePrimaryPathSelectionCheckbox(bool value)
        {
            GetCodingTab().ClickWhenAvailable();

            GetForcePrimaryPathSelectionCheckBox().SetCheckBoxState(value);

            GetSaveButton().ClickWhenAvailable();
        }

        internal void SetConfigurationFunctionalityBypassReconsiderUponReclassifyCheckbox(bool value)
        {
            GetCodingTab().ClickWhenAvailable();

            GetBypassReconsiderUponReclassifyCheckBox().SetCheckBoxState(value);

            GetSaveButton().ClickWhenAvailable();
        }

        internal void SetConfigurationFunctionalitySynonymCreationPolicyFlagDropDown(string value)
        {
            if (String.IsNullOrEmpty(value)) throw new ArgumentNullException("value");
            
            GetCodingTab().ClickWhenAvailable();

            GetSynonymCreationPolicyFlagDropDownList().SelectOption(value);

            GetSaveButton().ClickWhenAvailable();
        }

        internal void SetDictionaryConfigurationAutoAddSynonymsCheckbox(string medicalDictionaryName, bool value)
        {
            if (String.IsNullOrEmpty(medicalDictionaryName)) throw new ArgumentNullException("medicalDictionaryName");
            
            GetDictionaryTab().ClickWhenAvailable();

            GetDictionaryRowEnableEditButtonByMedicalDictionaryName(medicalDictionaryName).Click();

            _Browser.WaitUntilElementDisappears(GetLoadingIndicator);

            if (!IsEditModeEnabledForMedicalDictionaryRow(medicalDictionaryName))
            {
                throw new MissingHtmlException(string.Format("Unable to edit row, can't find enable edit button for dictionary: {0}", medicalDictionaryName));
            }

            GetEditingRowAutoAddSynonymsCheckbox().SetCheckBoxState(value);

            GetEditingRowSaveButton().Click();

            _Browser.WaitUntilElementDisappears(GetLoadingIndicator);

            Assert.IsFalse(IsEditModeEnabledForMedicalDictionaryRow(medicalDictionaryName), "Save failed for dictionary");
        }

        internal void SetDictionaryConfigurationAutoApproveCheckbox(string medicalDictionaryName, bool value)
        {
            if (String.IsNullOrEmpty(medicalDictionaryName)) throw new ArgumentNullException("medicalDictionaryName");
            
            GetDictionaryTab().ClickWhenAvailable();

            GetDictionaryRowEnableEditButtonByMedicalDictionaryName(medicalDictionaryName).Click();

            _Browser.WaitUntilElementDisappears(GetLoadingIndicator);

            if (!IsEditModeEnabledForMedicalDictionaryRow(medicalDictionaryName))
            {
                throw new MissingHtmlException(string.Format("Unable to edit row, can't find enable edit button for dictionary: {0}", medicalDictionaryName));
            }

            GetEditingRowAutoApproveCheckbox().SetCheckBoxState(value);

            GetEditingRowSaveButton().Click();

            _Browser.WaitUntilElementDisappears(GetLoadingIndicator);

            Assert.IsFalse(IsEditModeEnabledForMedicalDictionaryRow(medicalDictionaryName), "Save failed for dictionary");
        }

        internal void WaitUntilFinishLoading()
        {
            _Browser.WaitUntilElementDisappears(GetLoadingIndicator);
        }

        private SessionElementScope GetLoadingIndicator()
        {
            var loadingIndicator = _Browser.FindSessionElementByXPath("//*[contains(@id, '_LPV')]");

            return loadingIndicator;
        }

    }
}
