using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class IngredientReportPage
    {
        private readonly BrowserSession _Browser;
        private const string _PageName = "Ingredient Report";

        internal IngredientReportPage(BrowserSession browser) 
        { 
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser"); 
            _Browser = browser; 
        }

        private bool BrowserOnPage()
        {
            var title  = _Browser.Title;
            var onPage = title.Equals(_PageName, StringComparison.OrdinalIgnoreCase);

            return onPage;
        }

        internal void GoTo()
        {
            var onPage = BrowserOnPage();

            if (!onPage)
            {
                _Browser.GoToReportPage(_PageName);
            }
        }

        private SessionElementScope GetExportButton()
        {
            var exportButton = _Browser.FindSessionElementById("ctl00_Content_btnExportReport");

            return exportButton;
        }

        private SessionElementScope GetStudySelectList()
        {
            var studyDropdown = _Browser.FindSessionElementById("ctl00_Content_controlACG_DdlStudies");

            return studyDropdown;
        }

        private SessionElementScope GetDictionarySelectList()
        {
            var dictionaryDropdown = _Browser.FindSessionElementById("ctl00_Content_controlACG_DdlDictionaries");

            return dictionaryDropdown;
        }

        internal void SetReportParameters(string study, string dictionary)
        {
            if (String.IsNullOrWhiteSpace(study))      throw new ArgumentNullException("study");
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");

            GoTo();

            GetStudySelectList()     .SelectOptionAlphanumericOnly(study);
            GetDictionarySelectList().SelectOptionAlphanumericOnly(dictionary);
        }

        internal void ExportReport()
        {
            var exportButton = GetExportButton();

            exportButton.Click();
        }
    }
}
