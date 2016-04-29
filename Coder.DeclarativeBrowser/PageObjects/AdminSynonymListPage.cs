using System;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using NUnit.Framework;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class AdminSynonymListPage
    {
        private const string PageName = "Synonym List";
        private readonly BrowserSession _Session;

        internal AdminSynonymListPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))  throw new ArgumentNullException("session");  
            
            _Session = session;
        }

        internal void GoTo()
        {
            _Session.GoToAdminPage(PageName);
        }

        internal SessionElementScope GetSynonymListFileUpload()
        {
            var syonymListFileUpload = _Session
                .FindSessionElementByXPath("//input[contains(@name,'file') and contains(@type,'file') and contains(@class,'break-word')]");

            return syonymListFileUpload;
        }

        internal SessionElementScope GetUploadButton()
        {
            var uploadButton = _Session
                .FindSessionElementByXPath("//button[@id = 'FileUpload']");

            return uploadButton;
        }

        internal SessionElementScope GetListStatusInSingleSynonymListView()
        {
            var listStatus = _Session
                .FindSessionElementByXPath("//table[@id = 'reminder-table']//td[count(//th[text()='Status']) + 2]");

            return listStatus;
        }

        internal SessionElementScope GetSynonymListRow()
        {
            var synonymsListRow = _Session
                .FindSessionElementByXPath("//table[@id = 'reminder-table']//tr[td[count(//th[text()='List Name']) + 1]]");

            return synonymsListRow;
        }

        private SessionElementScope GetLatestSynonymListUploadHistoryTableRowForFileName(string fileName)
        {
            if (String.IsNullOrWhiteSpace(fileName)) throw new ArgumentNullException("fileName");

            SessionElementScope latestSynonymListUploadHistoryTableRow = null;

            IList<SessionElementScope> uploadHistoryRows= _Session
                .FindAllSessionElementsByXPath("//table[@id = 'history-table']/*/tr");
            

            foreach (SessionElementScope uploadHistoryRow in uploadHistoryRows)
            {
                if (uploadHistoryRow.InnerHTML.Contains(fileName))
                {
                    latestSynonymListUploadHistoryTableRow = uploadHistoryRow;
                    break;
                }
            }

            return latestSynonymListUploadHistoryTableRow;
        }

        internal void DisplaySynonymListUploadHistoryForFileName(string fileName)
        {
            if (String.IsNullOrWhiteSpace(fileName)) throw new ArgumentNullException("fileName");

            _Session.WaitUntilElementExists(()=>GetLatestSynonymListUploadHistoryTableRowForFileName(fileName));
            
            GetLatestSynonymListUploadHistoryTableRowForFileName(fileName).Click();
        }

        private int GetNumberOfUploadedSynonymsSkipped()
        {
            return _Session
                .FindSessionElementByXPath("//*[@id='synonymsIgnored']").Text.ToInteger();
        }
        
        private int GetNumberOfUploadedSynonymsAdded()
        {
            return _Session
                .FindSessionElementByXPath("//*[@id='synonymsAdded']").Text.ToInteger();
        }

        private int GetNumberOfUploadedSynonymsErred()
        {
            return _Session
                .FindSessionElementByXPath("//*[@id='synonymsFailed']").Text.ToInteger();
        }

        private int GetNumberOfUploadedSynonymsTotal()
        {
            return _Session
                .FindSessionElementByXPath("//*[@id='synonymsTotal']").Text.ToInteger();
        }

        internal SessionElementScope GetNumberOfSynonymsInSingleSynonymListView()
        {
            var numberOfSynonyms = _Session
                .FindSessionElementByXPath("//table[@id = 'reminder-table']//td[count(//th[text()='Number Of Synonyms']) + 1]");

            return numberOfSynonyms;
        }

        internal void WaitForSynonymUploadToComplete(long fileSizeInBytes, int expectedNumberOfSynonymsToUpload)
        {
            if (ReferenceEquals(fileSizeInBytes, null)) throw new ArgumentNullException("fileSizeInBytes");
            if (ReferenceEquals(expectedNumberOfSynonymsToUpload, null)) throw new ArgumentNullException("expectedNumberOfSynonymsToUpload");

            var options       = new Options
            {
                RetryInterval = TimeSpan.FromSeconds(1),
                Timeout       = TimeSpan.FromSeconds(60.0 + fileSizeInBytes / 1000.0)
            };

            _Session.TryUntil(
                GetSynonymListRow().Click,
                () => GetNumberOfUploadedSynonymsTotal().Equals(expectedNumberOfSynonymsToUpload),
                options.WaitBeforeClick,
                options);

            Assert.AreEqual(0, GetNumberOfUploadedSynonymsErred(), "There were errors while uploading the synonyms list.");
        }

        internal void WaitForSynonymUploadFileToComplete()
        {
            Options options = Config.SynonymFileCopyuOptions();

            _Session.TryUntil(
                GetSynonymListRow().Click,
                () => GetListStatusInSingleSynonymListView().InnerHTML.Equals("List Setup Complete"),
                options.WaitBeforeClick,
                options);
        }

    }
}
