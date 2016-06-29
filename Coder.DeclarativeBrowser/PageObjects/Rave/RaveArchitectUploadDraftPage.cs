using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using FluentAssertions;
using System.IO;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveArchitectUploadDraftPage
    {
        private readonly BrowserSession _Session;

        internal RaveArchitectUploadDraftPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private SessionElementScope GetChooseFileButton()
        {
            var chooseFileButton = _Session.FindSessionElementById("CtrlDraftFile");

            return chooseFileButton;
        }

        private SessionElementScope GetUploadButton()
        {
            var uploadButton = _Session.FindSessionElementById("Upload");

            return uploadButton;
        }

        private SessionElementScope GetCurrentStatusIndicator()
        {
            var currentStatusIndicator = _Session.FindSessionElementById("CurrentStatus");

            return currentStatusIndicator;
        }

        private SessionElementScope GetAbortButton()
        {
            var abortButton = _Session.FindSessionElementById("AbortBtn");

            return abortButton;
        }

        private SessionElementScope GetBackButton()
        {
            var backButton = _Session.FindSessionElementById("BackBtn");

            return backButton;
        }

        internal void UploadDraftFile(String draftFilePath)
        {
            if (ReferenceEquals(draftFilePath, null)) throw new ArgumentNullException("draftFilePath");
            
            AttachDraftFile(draftFilePath);

            GetUploadButton().Click();

            WaitForUploadToComplete();

            var currentStatus = GetCurrentStatusIndicator();

            currentStatus.Text.Should().BeEquivalentTo("Save successful");
        }

        internal void UploadDraftErrorFile(String draftFilePath)
        {
            if (ReferenceEquals(draftFilePath, null)) throw new ArgumentNullException("draftFilePath");

            AttachDraftFile(draftFilePath);
            GetUploadButton().Click();

            WaitForUploadErrorToComplete();
        }

        internal void WaitForUploadErrorToComplete()
        {
            var options           = Config.GetDefaultCoypuOptions();

            options.RetryInterval = TimeSpan.FromSeconds(10);
            options.Timeout       = TimeSpan.FromMinutes(3);

            _Session.TryUntil(
            () => GetCurrentStatusIndicator(),
            () => GetCurrentStatusIndicator().Text.Equals("Transaction rolled back."),
            options.RetryInterval,
            options);
        }


        private void AttachDraftFile(string draftFilePath)
        {
            if (ReferenceEquals(draftFilePath, null)) throw new ArgumentNullException("draftFilePath");

            var chooseFileButton = GetChooseFileButton();
            chooseFileButton.SendKeys(draftFilePath);
        }

        private void WaitForUploadToComplete()
        {
            _Session.WaitUntilElementIsActive  (GetAbortButton);
            _Session.WaitUntilElementIsDisabled(GetBackButton);
            
            var options = Config.GetDefaultCoypuOptions();

            options.RetryInterval = TimeSpan.FromSeconds(10);
            options.Timeout       = TimeSpan.FromMinutes(5);

            _Session.TryUntil(
            () => GetAbortButton(),
            () => GetAbortButton().Disabled,
            options.RetryInterval,
            options);
            
            _Session.WaitUntilElementIsActive  (GetBackButton);
        }

        private SessionElementScope GetFieldReportErrorMessageButton()
        {
            var errorMessageButton = _Session.FindSessionElementById("Fields_Errors");

            return errorMessageButton;
        }

        private SessionElementScope GetFieldReportTable()
        {
            var fieldReportTable = _Session.FindSessionElementById("FieldsReport");

            return fieldReportTable;
        }

        internal string GetFieldReportActualErrorMsg()
        {
            var errFieldReportButton = GetFieldReportErrorMessageButton();
            var errFieldReportTable  = GetFieldReportTable();

            errFieldReportButton.Click();

            var actualErrorMessage = errFieldReportTable.FindSessionElementByXPath(".//li");

            return actualErrorMessage.Text;
        }

    }
}
