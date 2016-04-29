using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class ProjectRegistrationPage
    {
        private readonly BrowserSession _Browser;
        private Options                 _Options;

        private const int dictionaryTypeIndex                     = 0;
        private const int versionIndex                            = 1;
        private const int localeIndex                             = 2;
        private const int synonymListIndex                        = 3;
        private const int registrationNameIndex                   = 4;
        private const int projectHistoryUserIndex                 = 0;
        private const int projectHistoryTransmissionResponseIndex = 1;
        private const int projectHistoryIsSucceededIndex          = 2;
        private const int projectHistoryDictionaryVersionIndex    = 3;
        private const int projectHistoryCreatedIndex              = 4;

        public ProjectRegistrationPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null))
            {
                throw new ArgumentNullException("browser");
            }
            _Browser = browser;
            _Options = new Options
            {
                RetryInterval = TimeSpan.FromSeconds(2),
                Timeout       = TimeSpan.FromSeconds(60)
            };
        }

        public SessionElementScope GetProjectRegistrationGrid()
        {
            var projectRegistrationGrid = _Browser.FindSessionElementById("ctl00_Content_workGrid_DXMainTable");

            return projectRegistrationGrid;
        }

        public SessionElementScope GetRegistrationEditRow()
        {
            var projectRegistrationGrid = GetProjectRegistrationGrid().FindSessionElementById("ctl00_Content_workGrid_DXEditingRow");

            return projectRegistrationGrid;
        }
        
        public SessionElementScope GetProjectDropdownList()
        {
            var projectDropdown = _Browser.FindSessionElementByXPath("//select[@name = 'ctl00$Content$ddlProject']");

            return projectDropdown;
        }

        public SessionElementScope GetEditProjectButton()
        {
            var editProjectButton = _Browser.FindSessionElementByXPath("//a[@id = 'ctl00_Content_btnEditProject']");

            return editProjectButton;
        }

        public SessionElementScope GetAddNewGridSegmentButton()
        {
            var addNewGridSegmentButton = GetProjectRegistrationGrid().FindSessionElementByXPath("//a[@id = 'ctl00_Content_workGrid_FooterRow_LnkAddNewgridSegments']");

            return addNewGridSegmentButton;
        }

        public SessionElementScope GetGridDictionaryTypeInput()
        {
            var dictionaryType = _Browser.FindSessionElementByXPath("//input[@id = 'ctl00_Content_workGrid_DXEditor0_I']");

            return dictionaryType;
        }

        private SessionElementScope GetDictionaryTypeSelectList()
        {
            var dictionaryTypeSelectList = _Browser.FindSessionElementById("ctl00_Content_workGrid_DXEditor0");

            return dictionaryTypeSelectList;
        }

        private SessionElementScope GetVersionSelectList()
        {
            var versionSelectList = _Browser.FindSessionElementById("ctl00_Content_workGrid_DXEditor1");

            return versionSelectList;
        }

        private SessionElementScope GetLocalesSelectList()
        {
            var localesSelectList = _Browser.FindSessionElementById("ctl00_Content_workGrid_DXEditor2");

            return localesSelectList;
        }

        private SessionElementScope GetSynonymListsSelectList()
        {
            var synonymListsSelectList = _Browser.FindSessionElementById("ctl00_Content_workGrid_DXEditor3");

            return synonymListsSelectList;
        }

        private SessionElementScope GetDictionarySelectList()
        {
            var dictionarySelectList = _Browser.FindSessionElementById("ctl00_Content_workGrid_DXEditor4");

            return dictionarySelectList;
        }

        private IList<SessionElementScope> GetSelectListOptions()
        {
            var selectListOptions = _Browser.FindAllSessionElementsByXPath("//*[contains(@id,'DDD_L_LBI')]");

            return selectListOptions;
        }

        private SessionElementScope GetSelectListOption(SessionElementScope selectList, string targetOptionText)
        {
            if (ReferenceEquals(selectList, null))           throw new ArgumentNullException("selectList");
            if (String.IsNullOrWhiteSpace(targetOptionText)) throw new ArgumentNullException("targetOptionText");

            _Browser.TryUntil(
                () => selectList.Click(),
                () => GetSelectListOptions().Any(),
                _Options.RetryInterval,
                _Options);

            var selectListOptions = GetSelectListOptions();

            var selectListOption = selectListOptions.FirstOrDefault(x => x.Text.Equals(targetOptionText));

            if (ReferenceEquals(selectListOption, null))
            {
                throw new NullReferenceException(String.Format("No option {0} was found.", targetOptionText));
            }

            return selectListOption;
        }

        private void SelectOption(Func<SessionElementScope> getSelectList, string targetOptionText)
        {
            if (ReferenceEquals(getSelectList, null)) throw new ArgumentNullException("getSelectList");
            if (String.IsNullOrWhiteSpace(targetOptionText)) throw new ArgumentNullException("targetOptionText");

            var selectList = getSelectList();

            var selectListOption = RetryPolicy.FindElement.Execute(
                () => GetSelectListOption(selectList, targetOptionText));

            selectListOption.Click();
        }

        public void SelectDictionaryType(string selectedValue)
        {
            if (ReferenceEquals(selectedValue, null)) throw new ArgumentNullException("selectedValue");

            SelectOption(GetDictionaryTypeSelectList, selectedValue);
        }
        
        public void SelectVersion(string selectedValue)
        {
            if (ReferenceEquals(selectedValue, null)) throw new ArgumentNullException("selectedValue");

            SelectOption(GetVersionSelectList, selectedValue);
        }

        public void SelectLocale(string selectedValue)
        {
            if (ReferenceEquals(selectedValue, null)) throw new ArgumentNullException("selectedValue");

            SelectOption(GetLocalesSelectList, selectedValue);
        }

        public void SelectSynonymList(string selectedValue)
        {
            if (ReferenceEquals(selectedValue, null)) throw new ArgumentNullException("selectedValue");

            SelectOption(GetSynonymListsSelectList, selectedValue);
        }

        public void SelectDictionary(string selectedValue)
        {
            if (ReferenceEquals(selectedValue, null)) throw new ArgumentNullException("selectedValue");

            SelectOption(GetDictionarySelectList, selectedValue);
        }

        public SessionElementScope GetUpdateButton()
        {
            var updateButton = _Browser.FindSessionElementByXPath("//img[@title='Update']");

            return updateButton;
        }

        public SessionElementScope GetSendToSourceButton()
        {
            var saveButton = _Browser.FindSessionElementById("ctl00_Content_btnSaveSend");

            return saveButton;
        }

        public SessionElementScope GetToggleHistoryButton()
        {
            var toggleHistoryButton = _Browser.FindSessionElementById("ctl00_Content_btnToggleHistory");

            return toggleHistoryButton;
        }
        
        public SessionElementScope GetSendOkButton()
        {
            var sendOkButton = _Browser.FindSessionElementById("ctl00_Content_pcSendWarning_btnSendOK");

            return sendOkButton;
        }

        public SessionElementScope GetRegisteredProjectGrid()
        {
            var registeredProjectGrid = _Browser.FindSessionElementById("ctl00_Content_gridProjectRegistration_DXMainTable");

            return registeredProjectGrid;
        }

        public IList<SessionElementScope> GetRegisteredProjectGridDataRows()
        {
            var registeredProjectGridRows =
                GetRegisteredProjectGrid().FindAllSessionElementsByXPath("tbody/tr[not(contains(@id,'HeadersRow'))]");

            return registeredProjectGridRows;
        }

        internal IList<SynonymList> GetRegisteredProjectValues()
        {
            if (GetRegisteredProjectGridDataRows().Count == 0)
            {
                return null;
            }

            var registeredProjectValues = (
                from registeredProjectkGridRow in GetRegisteredProjectGridDataRows()
                select registeredProjectkGridRow.FindAllSessionElementsByXPath("td")
                    into registeredProjectColumns
                    select new SynonymList
                    {
                        Dictionary       = registeredProjectColumns[dictionaryTypeIndex].Text,
                        Version          = registeredProjectColumns[versionIndex].Text,
                        Locale           = registeredProjectColumns[localeIndex].Text,
                        SynonymListName  = registeredProjectColumns[synonymListIndex].Text,
                        RegistrationName = registeredProjectColumns[registrationNameIndex].Text
                    })
                .ToList();

            return registeredProjectValues;
        }

        public SessionElementScope GetRegisterationHistoryGrid()
        {
            var registeredProjectGrid = _Browser.FindSessionElementById("ctl00_Content_gridHistory_DXMainTable");

            return registeredProjectGrid;
        }

        public IList<SessionElementScope> GetRegisterationHistoryGridDataRows()
        {
            var registeredProjectGridRows =
                GetRegisterationHistoryGrid().FindAllSessionElementsByXPath("tbody/tr[not(contains(@id,'HeadersRow'))]");

            return registeredProjectGridRows;
        }

        internal IList<ProjectRegistrationHistory> GetRegisterationHistoryValues()
        {
            if (GetRegisteredProjectGridDataRows().Count == 0)
            {
                return null;
            }

            var projectHistoryValues = (
                from projectHistorykGridRow in GetRegisterationHistoryGridDataRows()
                select projectHistorykGridRow.FindAllSessionElementsByXPath("td")
                    into projectHistoryColumns
                    select new ProjectRegistrationHistory
                    {
                        User                         = projectHistoryColumns[projectHistoryUserIndex].Text,
                        TransmissionResponse         = projectHistoryColumns[projectHistoryTransmissionResponseIndex].Text,
                        ProjectRegistrationSucceeded = projectHistoryColumns[projectHistoryIsSucceededIndex].InnerHTML.Contains("unchecked") ? "Unchecked" : "Checked",
                        DictionaryAndVersions        = projectHistoryColumns[projectHistoryDictionaryVersionIndex].Text,
                        Created                      = projectHistoryColumns[projectHistoryCreatedIndex].Text
                    })
                .ToList();

            return projectHistoryValues;
        }
    }
}
