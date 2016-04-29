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

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveConfigurationLoaderPage
    {
        private readonly BrowserSession _Browser;
        private readonly String _SuccessMessage = "Save Successful";
        private const string _PageName          = "Configuration Loader";
        private const int _ReviewMarkingGroupIndex   = 6;
        private const int _IsRequiresResponseIndex   = 11; 

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

            var zippedFileName   = "RaveGlobalConfiguration" + DateTime.Today.ToString() + ".zip";

            var unZippedFileName = zippedFileName.Replace(".zip", ".xls");

            GenericFileHelper.DownloadVerifiedFile(downloadDirectory, zippedFileName, GetConfigDownloadFile);

            var actualUnzippedPath = GenericFileHelper.UnzipFile(downloadDirectory, zippedFileName, downloadDirectory);

            return actualUnzippedPath;
        }

        internal static RaveCoderGlobalConfiguration GetRaveCoderGlobalConfigXmltoModel(string filePath, string sheetName)
        {
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException(filePath);
            if (String.IsNullOrWhiteSpace(sheetName)) throw new ArgumentNullException(sheetName);

            string reviewMarkingGroup = null;
            bool isRequiresResponse   = false;

            XElement xelement = XElement.Load(filePath);
            var xmlItemWorkSheet = from xmlTag in xelement.Elements("Worksheet")
                                   where (string)xmlTag.Element("Worksheet").Value == sheetName
                                   select xmlTag;

            var reviewDataValues = xmlItemWorkSheet.Descendants("Data").ToList();
             
            reviewMarkingGroup = reviewDataValues[_ReviewMarkingGroupIndex].Value;
            isRequiresResponse = reviewDataValues[_IsRequiresResponseIndex].Value.ToBoolean();

            var newConfigurationModel = new RaveCoderGlobalConfiguration
            {
                ReviewMarkingGroup = reviewMarkingGroup,
                IsRequiresResponse = isRequiresResponse
            };

            return newConfigurationModel;
        }

        internal bool IsRaveCoderGlobalConfigurationDownloadXLSFileCorrect(string downloadDirectory, string workSheetName, string reviewMarkingGroup, string isRequiresResponse)
        {
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException(downloadDirectory);
            if (String.IsNullOrWhiteSpace(workSheetName)) throw new ArgumentNullException(workSheetName);
            if (String.IsNullOrWhiteSpace(reviewMarkingGroup)) throw new ArgumentNullException(reviewMarkingGroup);
            if (String.IsNullOrWhiteSpace(isRequiresResponse)) throw new ArgumentNullException(isRequiresResponse);

            string filePath                       = GetConfigurationDownloadFile(downloadDirectory);
            var raveCoderGlobalConfigurationModel = GetRaveCoderGlobalConfigXmltoModel(filePath,workSheetName);

            bool doConfigurationMatch = raveCoderGlobalConfigurationModel.ReviewMarkingGroup.EqualsIgnoreCase(reviewMarkingGroup)
                                        &&
                                        raveCoderGlobalConfigurationModel.IsRequiresResponse.Equals(isRequiresResponse.ToBoolean());
            
            return doConfigurationMatch;
        }

    }
}
