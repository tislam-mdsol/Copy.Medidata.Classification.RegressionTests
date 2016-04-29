using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class CodingCleanupPage
    {
        private readonly BrowserSession _Browser;

        public CodingCleanupPage(BrowserSession browser) { if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }  _Browser = browser; }

        public SessionElementScope GetCleanupButton()
        {
            var cleanupButton = _Browser.FindSessionElementByXPath("//a[@id = 'ctl00_Content_btnCleanup']");

            return cleanupButton;
        }

        public SessionElementScope GetUploadButton()
        {
            var uploadButton = _Browser.FindSessionElementByXPath("//a[@id = 'ctl00_Content_btnPopulate']");

            return uploadButton;
        }

        public SessionElementScope GetUploadField()
        {
            var uploadField = _Browser.FindSessionElementByXPath("//input[@id = 'ctl00_Content_fileUpload']");

            return uploadField;
        }

        public SessionElementScope GetResetSynonymStateCheckBox()
        {
            var resetSynonymStateCheckBox =
                _Browser.FindSessionElementByXPath("//input[@id = 'ctl00_Content_chkResetSynonymState']");

            return resetSynonymStateCheckBox;
        }

        internal SessionElementScope GetUploadSuccessIndicator()
        {
            var uploadSuccessIndicator =_Browser.
                FindSessionElementById("ctl00_StatusPaneACG_SuccessPane");

            return uploadSuccessIndicator;
        }

        internal SessionElementScope GetUploadFailureIndicator()
        {
            var uploadSuccessIndicator = _Browser.
                FindSessionElementById("ctl00_StatusPaneACG_ErrorPane");

            return uploadSuccessIndicator;
        }

        internal void WaitUntilUploadCompletes()
        {
            var options = Config.GetDefaultCoypuOptions();

            _Browser.TryUntil(
                () => GetUploadSuccessIndicator(),
                () => GetUploadSuccessIndicator().Exists(Config.ExistsOptions) || GetUploadFailureIndicator().Exists(Config.ExistsOptions),
                options.RetryInterval,
                options);
        }

        internal void CleanUpTasksAndSynonyms()
        {
            GetResetSynonymStateCheckBox().SetCheckBoxState(true);
            GetCleanupButton().Click();

            WaitUntilUploadCompletes();
        }
    }
}
