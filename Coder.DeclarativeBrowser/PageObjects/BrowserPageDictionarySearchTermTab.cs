using Coypu;
using System;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class BrowserPageDictionarySearchTermTab
    {
        private readonly BrowserSession _Browser;

        public BrowserPageDictionarySearchTermTab(BrowserSession browser) { if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }  _Browser = browser; }

        public SessionElementScope GetDictionaryDropDownList()
        {
            var dictionaryDropDownList = _Browser.FindSessionElementById("ctl00_Content_DdlDictionary");

            return dictionaryDropDownList;
        }

        public SessionElementScope GetVersionDropDownList()
        {
            var versionDropDownList = _Browser.FindSessionElementById("ctl00_Content_DdlVersion");

            return versionDropDownList;
        }

        public SessionElementScope GetSynonymDropDownList()
        {
            var synonymDropDownList = _Browser.FindSessionElementById("ctl00_Content_DdlSynonymList");

            return synonymDropDownList;
        }

        public SessionElementScope GetTemplateDropDownList()
        {
            var templateDropDownList = _Browser.FindSessionElementById("ctl00_Content_DdlTemplate");

            return templateDropDownList;
        }

        public SessionElementScope GetDictionaryLevelDropDownList()
        {
            var dictionaryLevelDropDownList = _Browser.FindSessionElementById("ctl00_Content_DdlDictionaryLevel");

            return dictionaryLevelDropDownList;
        }

        public SessionElementScope GetTermDropDownList()
        {
            var termDropDownList = _Browser.FindSessionElementById("ctl00_Content_DdlTermCode");

            return termDropDownList;
        }

        public SessionElementScope GetDictionaryTermSearchTextBox()
        {
            var dictionaryTermSearchTextBox = _Browser.FindSessionElementById("ctl00_Content_TxtSearchForText");

            return dictionaryTermSearchTextBox;
        }

        public SessionElementScope GetTreeListFrame()
        {
            var treeListFrame = _Browser.FindSessionElementById("ctl00_Content_FrmCodingBrowser");

            return treeListFrame;
        }

        public SessionElementScope GetTreeListTable()
        {
            var treeListTable = GetTreeListFrame().FindSessionElementByXPath("treeList");

            return treeListTable;
        }

        public SessionElementScope GetSearchButton()
        {
            var searchButton = _Browser.FindSessionElementById("ctl00_Content_ImgSearch");

            return searchButton;
        }

        public SessionElementScope GetTreeListTableFirstRow()
        {
            var treeListTableFirstRow = GetTreeListTable().FindAllSessionElementsByXPath("tbody/tr/td/table/tbody/tr").First();

            return treeListTableFirstRow;
        }

        public SessionElementScope GetCreateSynonymCheckBox()
        {
            var createSynonymCheckBox = GetTreeListFrame().FindSessionElementById("chkCreateSynonym");

            return createSynonymCheckBox;
        }

        public SessionElementScope GetCodeButton()
        {
            var codeButton = GetTreeListFrame().FindSessionElementById("manualCode");

            return codeButton;
        }

        public SessionElementScope GetDictionaryTermSearchTab()
        {
            var dictionaryTermSearchTab = _Browser.FindSessionElementById("ctl00_Content_tab1");

            return dictionaryTermSearchTab;
        }

        public SessionElementScope FindTermInBrowserTree(string term)
        {
            if (String.IsNullOrEmpty(term))  throw new ArgumentNullException("term"); 

            var termElement = GetTreeListTable()
                    .FindAllSessionElementsByXPath("tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td")
                    .ToList()
                    .Find(x => x.Text.Equals(term));

            return termElement;
        }
    }
}
