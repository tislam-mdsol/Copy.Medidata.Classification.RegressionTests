//@author:smalik
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using System;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveConfigrationLoaderPage
    {
        private readonly BrowserSession _Browser;
        private readonly String _SuccessMessage = "Save Successful";
        private const string PageName = "Configuration Loader";

        internal RaveConfigrationLoaderPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        internal bool OnConfigurationLoaderPage()
        {
            var title = _Browser.Title;

            return title.Equals(PageName);
        }

        internal void GoTo()
        {
            if (!OnConfigurationLoaderPage())
            {
                var raveModulesPage = _Browser.GetRaveModulesPage();

                raveModulesPage.GoToConfigPage();
            }
        }

       
        internal void UploadConfigFile(String ConfigFilePath)
        {
            if (ReferenceEquals(ConfigFilePath, null)) throw new ArgumentNullException("ConfigFilePath");

            GoTo();

            AttachConfigFile(ConfigFilePath);
            GetUploadButton().Click();

            WaitForConfigUploadToComplete();
        }

        private void AttachConfigFile(string ConfigFilePath)
        {
            if (ReferenceEquals(ConfigFilePath, null)) throw new ArgumentNullException("ConfigFilePath");

            var browseButton = _Browser.FindSessionElementById("_ctl0_Content_CtrlDraftFile");
            browseButton.SendKeys(ConfigFilePath);
        }

        private SessionElementScope GetUploadButton()
        {
            var uploadButton = _Browser.FindSessionElementById("_ctl0_Content_Upload");

            return uploadButton;
        }

        private void WaitForConfigUploadToComplete()
        {
           var options = Config.ConfigFileCopyuOptions();

            _Browser.TryUntil(
                ()            => GetUploadSuccessIndicator(),
                ()            => VerifyConfigUploadHasCompleted(_SuccessMessage),
                options.RetryInterval,
                options);
        }

        private SessionElementScope GetUploadSuccessIndicator()
        {
            var uploadSuccessIndicator = _Browser.FindSessionElementById("_ctl0_Content_CurrentStatus");

            return uploadSuccessIndicator;
        }

        internal bool VerifyConfigUploadHasCompleted(String message)
        {
            if (ReferenceEquals(message, null)) throw new ArgumentNullException("message");

            var uploadSuccessIndicator = GetUploadSuccessIndicator();
            var messageMatches         = uploadSuccessIndicator.Text.Equals(message, StringComparison.OrdinalIgnoreCase);

            return messageMatches;
        }

    }
}
