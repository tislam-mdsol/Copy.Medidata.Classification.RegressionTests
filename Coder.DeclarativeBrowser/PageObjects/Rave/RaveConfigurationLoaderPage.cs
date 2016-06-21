using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using System;
using System.IO;
using System.IO.Compression;
using Coder.DeclarativeBrowser.FileHelpers;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Linq;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.Models.ETEModels;
using System.Windows.Forms;
using System.Threading;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveConfigurationLoaderPage
    {
        private readonly BrowserSession _Browser;
        private readonly String _SuccessMessage                 = "Save Successful";
        private const string _PageName                          = "Configuration Loader";
        private const int _GlobalConfigReviewMGRowIndex         = 1;
        private const int _GlobalConfigRequiresResponseRowIndex = 2;
        private const int _GlobalConfigValueColumnIndex         = 1;

        internal RaveConfigurationLoaderPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }
        
        private SessionElementScope GetAbortButton()
        {
            var abortButton = _Browser.FindSessionElementById("AbortBtn");

            return abortButton;
        }

        private SessionElementScope GetBackButton()
        {
            var backButton = _Browser.FindSessionElementById("_ctl0_Content_BackBtn");

            return backButton;
        }

        internal bool OnConfigurationLoaderPage()
        {
            var title = _Browser.Title;

            return title.Equals(_PageName);
        }
       
        internal bool UploadConfigFile(String ConfigFilePath)
        {
            if (ReferenceEquals(ConfigFilePath, null)) throw new ArgumentNullException("ConfigFilePath");

            AttachConfigFile(ConfigFilePath);
            GetUploadButton().Click();

            WaitForConfigUploadToComplete();
            
            var uploadStatusIndicator = GetUploadStatusIndicator();
            
            return uploadStatusIndicator.Text.Equals(_SuccessMessage, StringComparison.OrdinalIgnoreCase);
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
            _Browser.WaitUntilElementIsActive(GetAbortButton);
            _Browser.WaitUntilElementIsDisabled(GetBackButton);

            var options = Config.GetDefaultCoypuOptions();

            options.RetryInterval = TimeSpan.FromSeconds(10);
            options.Timeout       = TimeSpan.FromMinutes(5);

            _Browser.TryUntil(
            () => GetAbortButton(),
            () => GetAbortButton().Disabled,
            options.RetryInterval,
            options);

            _Browser.WaitUntilElementIsActive(GetBackButton);
        }

        private SessionElementScope GetUploadStatusIndicator()
        {
            var uploadStatusIndicator = _Browser.FindSessionElementById("_ctl0_Content_CurrentStatus");

            return uploadStatusIndicator;
        }

        internal bool VerifyConfigUploadHasCompleted(String message)
        {
            if (ReferenceEquals(message, null)) throw new ArgumentNullException("message");

            var uploadStatusIndicator = GetUploadStatusIndicator();
            var messageMatches        = uploadStatusIndicator.Text.Equals(message, StringComparison.OrdinalIgnoreCase);

            return messageMatches;
        }

        internal void GetConfigDownloadFile()
        {
            var getFileButton = _Browser.FindSessionElementById("_ctl0_Content_GetFile");

            getFileButton.Click();
        }

        private SessionElementScope GetLabelWaitForDownload()
        {
            var labelWaitingMessage = _Browser.FindSessionElementById("_ctl0_Content_LabelWaitForDownload");

            return labelWaitingMessage;
        }

        private string GetConfigurationDownloadFile(string downloadDirectory)
        {
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException("downloadDirectory");

            GetConfigDownloadFile();

            //ToDO Find better way for windows download modal
            SendKeys.SendWait(@"{DOWN}");
            Thread  .Sleep(5000);
            SendKeys.SendWait(@"{Enter}");
            Thread  .Sleep(5000);

            string[] filePaths     = Directory.GetFiles(@downloadDirectory, "RaveCoreConfig_eng_*.zip");

            if (filePaths.Length > 1)
            {
                throw new Exception("More than one zip global configuration file exists!");
            }

            var zippedFileName     = filePaths[0].Substring(filePaths[0].IndexOf('/') + 1); ;

            var actualUnzippedPath = GenericFileHelper.UnzipFile(downloadDirectory, zippedFileName, downloadDirectory);

            return actualUnzippedPath;
        }

        internal static RaveCoderGlobalConfiguration GetRaveCoderGlobalConfigXmltoModel(string filePath)
        {
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException(filePath);

            var newConfigurationModel = new RaveCoderGlobalConfiguration();

            newConfigurationModel.ReviewMarkingGroup = GenericFileHelper
               .GetValueinSpreadSheetByRowAndColumnIndex(
                                                          filePath,
                                                          newConfigurationModel.GlobalConfigWorksheetName, 
                                                          _GlobalConfigReviewMGRowIndex,
                                                          _GlobalConfigValueColumnIndex
                                                        );

            newConfigurationModel.IsRequiresResponse = GenericFileHelper
               .GetValueinSpreadSheetByRowAndColumnIndex(
                                                          filePath,
                                                          newConfigurationModel.GlobalConfigWorksheetName,
                                                          _GlobalConfigRequiresResponseRowIndex,
                                                          _GlobalConfigValueColumnIndex
                                                        ).ToBoolean();
            return newConfigurationModel;
        }

        internal bool IsRaveCoderGlobalConfigurationDownloadXLSFileCorrect(string downloadDirectory, string reviewMarkingGroup, bool requiresResponse)
        {
            if (string.IsNullOrEmpty(downloadDirectory))  throw new ArgumentNullException("downloadDirectory");
            if (string.IsNullOrEmpty(reviewMarkingGroup)) throw new ArgumentNullException("reviewMarkingGroup");
         
            var filePath                          = GetConfigurationDownloadFile(downloadDirectory);
            
            var raveCoderGlobalConfigurationModel = GetRaveCoderGlobalConfigXmltoModel(filePath);

            var doConfigurationMatch =  raveCoderGlobalConfigurationModel
                                        .ReviewMarkingGroup.EqualsIgnoreCase(reviewMarkingGroup)
                                        &&
                                        raveCoderGlobalConfigurationModel
                                        .IsRequiresResponse.Equals(requiresResponse);
            
            return doConfigurationMatch;
        }

    }
}
