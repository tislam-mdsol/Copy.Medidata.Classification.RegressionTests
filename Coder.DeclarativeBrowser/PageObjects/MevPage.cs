using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu;
using NUnit.Framework;
using System.IO;
using Coder.DeclarativeBrowser.Models;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class MevPage
    {
        private readonly BrowserSession _Browser;
        private const string            _PageName = "Manage External Verbatims";

        internal MevPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null))
            {
                throw new ArgumentNullException("browser");
            }
            _Browser = browser;
        }

        internal void GoTo()
        {
            var onPage = _Browser.Title.Equals(_PageName);

            if (!onPage)
            {
                _Browser.GoToAdminPage(_PageName);
            }
        }

        internal SessionElementScope GetNavUploadButton()
        {
            var uploadButton = _Browser.FindSessionElementByXPath("//a[@id = 'navigationUploadButton']");

            return uploadButton;
        }

        internal SessionElementScope GetUploadField()
        {
            var uploadButton = _Browser.FindSessionElementByXPath("//input[@name = 'file']");

            return uploadButton;
        }

        internal SessionElementScope GetUploadButton()
        {
            var uploadButton = _Browser.FindSessionElementByXPath("//button[@id = 'FileUpload']");

            return uploadButton;
        }
        
        internal SessionElementScope GetDownloadFailedButton(string fileName)
        {
            if (ReferenceEquals(fileName, null))
            {
                throw new ArgumentNullException("fileName");
            }
            string xpath             = string.Format("//a[@id = 'FailureDownload'and contains(@href,'fileName={0}')]", fileName);
            var downloadFailedButton = _Browser.FindSessionElementByXPath(xpath);

            return downloadFailedButton;
        }

        internal string GetAlertMessage()
        {
            var alert = _Browser.FindSessionElementByXPath("//div[@id='master-alerts']//div[not(ancestor::span)]");

            return alert.Text;
        }

        internal SessionElementScope GetUploadedCodingTaskGrid()
        {
            var uploadedCodingTaskGrid = _Browser.FindSessionElementById("status-table");

            return uploadedCodingTaskGrid;
        }

        internal IList<SessionElementScope> GetUploadedCodingTaskGridDataRows()
        {
            var uploadedCodingTaskGridRows = new List<SessionElementScope>();

            RetryPolicy.SyncStaleElement.Execute(
                () =>
                {
                    uploadedCodingTaskGridRows = GetUploadedCodingTaskGrid()
                        .FindAllSessionElementsByXPath(
                            "tbody/tr[not(contains(@id,'HeadersRow')) and not(td[@colspan])]").ToList();
                });

            return uploadedCodingTaskGridRows;
        }

        internal IList<UploadedCodingTask> GetUploadedCodingTaskValues()
        {
            if (GetUploadedCodingTaskGridDataRows().Count == 0)
            {
                return null;
            }

            var uploadedCodingTaskValues = (
                from uploadedCodingTaskGridRow in GetUploadedCodingTaskGridDataRows()
                select uploadedCodingTaskGridRow.FindAllSessionElementsByXPath("td")
                    into uploadedCodingTaskColumns
                    select new UploadedCodingTask()
                    {
                        FileName       = uploadedCodingTaskColumns[0].Text,
                        Uploaded       = uploadedCodingTaskColumns[1].Text,
                        User           = uploadedCodingTaskColumns[2].Text,
                        Status         = uploadedCodingTaskColumns[3].Text,
                        Succeeded      = uploadedCodingTaskColumns[4].Text,
                        Failed         = uploadedCodingTaskColumns[5].Text,
                        DownloadFailed = uploadedCodingTaskColumns[6].Text
                    })
                .ToList();

            return uploadedCodingTaskValues;
        }

        internal SessionElementScope GetMevDownloadTabLink()
        {
            var downloadLinkTab = _Browser.FindSessionElementByXPath("//a[@href='#dowloadCodedTab']");

            return downloadLinkTab;
        }

        internal SessionElementScope GetMevDownloadButton()
        {
            var downloadButton = _Browser.FindSessionElementByXPath("//button[@id='CodedTaskDownload']");

            return downloadButton;
        }

        internal SessionElementScope GetStudyDropDownList()
        {
            var studyDropDownList = _Browser
                .FindSessionElementByXPath("//select[@name='Study']");

            return studyDropDownList;
        }

        internal SessionElementScope GetDictionaryDropDownList()
        {
            var studyDropDownList = _Browser
                .FindSessionElementByXPath("//select[@name='Dictionary']");

            return studyDropDownList;
        }

        internal SessionElementScope GetVersionDropDownList()
        {
            var studyDropDownList = _Browser
                .FindSessionElementByXPath("//select[@name='DictionaryVersion']");

            return studyDropDownList;
        }

        internal SessionElementScope GetBatchDropDownList()
        {
            var studyDropDownList = _Browser
                .FindSessionElementByXPath("//select[@name='Batch']");

            return studyDropDownList;
        }

        internal SessionElementScope GetTimeFrameStartTextbox()
        {
            var studyDropDownList = _Browser
                .FindSessionElementByXPath("//input[@name='CodingTasksSince']");

            return studyDropDownList;
        }

        internal SessionElementScope GetTimeFrameEndTextbox()
        {
            var studyDropDownList = _Browser
                .FindSessionElementByXPath("//input[@name='CodingTasksTil']");

            return studyDropDownList;
        }

        internal SessionElementScope GetMevUploadTasksTabLink()
        {
            var downloadLinkTab = _Browser.FindSessionElementByXPath("//a[@href='#uploadTab']");

            return downloadLinkTab;
        }

        internal SessionElementScope GetUploadedCodingTaskSuccessfulCountByTaskName()
        {
            var downloadLinkTab = _Browser.FindSessionElementByXPath("//a[@href='#uploadTab']");

            return downloadLinkTab;
        }

        internal void DownloadFile()
        {
            GetMevDownloadTabLink().Click();
            GetMevDownloadButton().Click();
        }

        internal void WaitForMevUploadToComplete()
        {
            var options = new Options
            {
                RetryInterval = TimeSpan.FromSeconds(1),
                Timeout       = TimeSpan.FromMinutes(30)
            };

            _Browser.TryUntil(
                GetUploadedCodingTaskGrid().Click,
                AssertMedUploadHasCompleted,
                options.RetryInterval,
                options);
        }

        internal void SetDownlodCriteria(MevDownloadCriteria downloadCriteria)
        {
            if (ReferenceEquals(downloadCriteria, null)) throw new ArgumentNullException("downloadCriteria");

            GetMevDownloadTabLink().Click();

            GetStudyDropDownList()     .SelectOptionAlphanumericOnly(downloadCriteria.Study);
            GetDictionaryDropDownList().SelectOptionAlphanumericOnly(downloadCriteria.Dictionary);
            GetVersionDropDownList()   .SelectOptionAlphanumericOnly(downloadCriteria.Version);
            GetBatchDropDownList()     .SelectOptionAlphanumericOnly(downloadCriteria.Batch);
            GetTimeFrameStartTextbox() .SetTextBoxSearchCriteria(downloadCriteria.StartDate);
            GetTimeFrameEndTextbox()   .SetTextBoxSearchCriteria(downloadCriteria.EndDate);
        }

        private bool AssertMedUploadHasCompleted()
        {
            var htmlData = GetUploadedCodingTaskValues();

            if (ReferenceEquals(htmlData, null))
            {
                return true;
            }

            foreach (var row in htmlData)
            {
                Assert.That(row.Status, Is.EqualTo("Upload Completed"));
            }

            return true;
        }

        internal bool IsUploadCapabilityAvailable()
        {
            bool isUploadCapabilityAvailable = false;

            bool navUploadButtonExists = GetNavUploadButton().Exists(Config.ExistsOptions);
            bool uploadgridExists   = GetUploadedCodingTaskGrid().Exists(Config.ExistsOptions);

            if (navUploadButtonExists && uploadgridExists && !GetNavUploadButton().Disabled)
            {
                isUploadCapabilityAvailable = true;
            }
            return isUploadCapabilityAvailable;
        }
    }
}
