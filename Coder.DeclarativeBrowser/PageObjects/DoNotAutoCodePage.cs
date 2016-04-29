using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class DoNotAutoCodePage
    {
        private const string PageName = "Do Not Auto Code";
        private readonly BrowserSession _Browser;

        internal DoNotAutoCodePage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            
            _Browser = browser;
        }

        internal void GoTo()
        {
            _Browser.GoToAdminPage(PageName);
        }

        internal SessionElementScope GetDictionaryTypeDropDown()
        {
            var dictionaryTypeDropdown = _Browser.FindSessionElementById("ctl00_Content_DdlDictionaryLocale");

            return dictionaryTypeDropdown;
        }

        internal SessionElementScope GetAddNewButton()
        {
            var addNewButton = _Browser
                .FindSessionElementById("ctl00_Content_doNotAutoCodeTerms_FooterRow_LnkAddNewdoNotAutoCodeTerms");

            return addNewButton;
        }

        internal SessionElementScope GetUpdateButton()
        {
            var updateButton = _Browser.FindSessionElementByXPath("//img[@title = 'Update']");

            return updateButton;
        }

        internal SessionElementScope GetCancelButton()
        {
            var cancelButton = _Browser.FindSessionElementById("//img[@title = 'Cancel']");

            return cancelButton;
        }

        internal SessionElementScope GetDictionaryVersionDropDown()
        {
            var dictionaryVersionDropdown = _Browser.FindSessionElementById("ctl00_Content_DdlDictionaryVersions");

            return dictionaryVersionDropdown;
        }

        internal SessionElementScope GetDictionaryNameDropDown()
        {
            var dictionaryNameDropdown = _Browser.FindSessionElementById("ctl00_Content_DdlLists");

            return dictionaryNameDropdown;
        }

        internal SessionElementScope GetVerbatimTermTextBox()
        {
            var verbatimTermTextBox = _Browser.FindSessionElementById("ctl00_Content_doNotAutoCodeTerms_DXEditor0_I");

            return verbatimTermTextBox;
        }

        internal void TrySelectValue(int index, string selectedValue)
        {
            if (String.IsNullOrWhiteSpace(selectedValue)) throw new ArgumentNullException("selectedValue"); 

            var options       = new Options
            {
                RetryInterval = TimeSpan.FromSeconds(2),
                Timeout       = TimeSpan.FromSeconds(90)
            };

            var option = _Browser.FindSessionElementByXPath(String.Format("//td[contains(@id, 'ctl00_Content_doNotAutoCodeTerms_DXEditor{0}') and contains(@id, 'LB') and (text()= '{1}')]", index, selectedValue));
            var table  = _Browser.FindSessionElementByXPath(String.Format("//div[@id ='ctl00_Content_doNotAutoCodeTerms_DXEditor{0}_DDD_L_D' and not(contains(@style,'visibility: hidden'))]", index));
            var input  = _Browser.FindSessionElementByXPath(String.Format("//input[@id = 'ctl00_Content_doNotAutoCodeTerms_DXEditor{0}_I']", index));

            _Browser.TryUntil(
                () => input.Click(),
                () => option.Exists(),
                options.RetryInterval,
                options);

            _Browser.TryUntil(
                () => input.Click(),
                () => table.Exists(),
                options.RetryInterval,
                options);

            _Browser.TryUntil(
                () => option.Hover(),
                () => option.Class.Contains("Hover"),
                options.RetryInterval,
                options);

            _Browser.TryUntil(
                () => option.Click(),
                () => input.Value == selectedValue,
                options.RetryInterval,
                options);
        }

        internal void SelectDictionary(string selectedValue)
        {
            if (String.IsNullOrWhiteSpace(selectedValue)) throw new ArgumentNullException("selectedValue"); 

            TrySelectValue(1, selectedValue);
        }

        internal void CleanUpTermsBySegmentAndList(string segmentName, string dictionaryList)
        {
            if (String.IsNullOrWhiteSpace(segmentName))    throw new ArgumentNullException("segmentName");
            if (String.IsNullOrWhiteSpace(dictionaryList)) throw new ArgumentNullException("dictionaryList"); 

            CoderDatabaseAccess.CleanupDoNotAutoCodeTermsBySegment(
                segmentName   : segmentName,
                dictionaryList: dictionaryList);
        }

        public void CreateDoNotAutoCodeTerm(
            string segmentName, 
            string dictionaryList, 
            string verbatimTerm, 
            string dictionary, 
            string dictionaryLevel, 
            string login)
        {
            if (String.IsNullOrWhiteSpace(segmentName))     throw new ArgumentNullException("segmentName"); 
            if (String.IsNullOrWhiteSpace(verbatimTerm))    throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrWhiteSpace(dictionaryList))  throw new ArgumentNullException("dictionaryList");
            if (String.IsNullOrWhiteSpace(dictionaryLevel)) throw new ArgumentNullException("dictionaryLevel");
            if (String.IsNullOrWhiteSpace(dictionary))      throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(login))           throw new ArgumentNullException("login"); 

            CoderDatabaseAccess.InsertDoNotAutoCode(
                segmentName   : segmentName,
                dictionaryList: dictionaryList,
                verbatimTerm  : verbatimTerm,
                dictionary    : dictionary,
                level         : dictionaryLevel,
                login         : login);
        }
    }
}
