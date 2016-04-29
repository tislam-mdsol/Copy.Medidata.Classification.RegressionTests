using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using FluentAssertions;

namespace Coder.DeclarativeBrowser.ExtensionMethods.Assertions
{
    public static class MevAssertionExtensionMethods
    {
        public static void AssertCodingTasksExist(
            this CoderDeclarativeBrowser browser,
            IList<CodingTask> codingTasks)
        {
            if (ReferenceEquals(browser, null))     throw new ArgumentNullException("browser");
            if (ReferenceEquals(codingTasks, null)) throw new ArgumentNullException("codingTasks");

            var session        = browser.Session;
            var codingTaskPage = session.GetCodingTaskPage();

            codingTaskPage.GoTo();

            foreach (var task in codingTasks)
            {
                codingTaskPage.SelectTaskGridByVerbatimName(task.VerbatimTerm);

                var htmlData              = codingTaskPage.GetCodingTaskValues();
                var htmlDataVerbatimTerms = htmlData.Select(t => t.VerbatimTerm).ToArray();

                htmlDataVerbatimTerms.Should().Contain(task.VerbatimTerm);
            }

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }


        public static void AssertThatValidCsvFormatMessageIsCorrect(
            this CoderDeclarativeBrowser browser, 
            string validationMessage)
        {
            if (ReferenceEquals(browser, null))               throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(validationMessage)) throw new ArgumentNullException("validationMessage");

            var session     = browser.Session;
            var mevPage     = session.GetMevPage();
            var htmlMessage = mevPage.GetAlertMessage();

            validationMessage.ShouldBeEquivalentTo(htmlMessage);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertDataMatchesUploadedCodingTasks(
            this CoderDeclarativeBrowser browser, 
            IList<UploadedCodingTask> uploadedCodingTasks, 
            int hoursDiff)
        {
            if (ReferenceEquals(browser, null))             throw new ArgumentNullException("browser");
            if (ReferenceEquals(uploadedCodingTasks, null)) throw new ArgumentNullException("uploadedCodingTasks");

            var session = browser.Session;
            var mevPage = session.GetMevPage();

            var htmlData = mevPage.GetUploadedCodingTaskValues();

            for (var i = 0; i < uploadedCodingTasks.Count; i++)
            {
                uploadedCodingTasks[i].FileName.ShouldBeEquivalentTo(htmlData[i].FileName);
                uploadedCodingTasks[i].User.ShouldBeEquivalentTo(htmlData[i].User);
                uploadedCodingTasks[i].Status.ShouldBeEquivalentTo(htmlData[i].Status);
                uploadedCodingTasks[i].Succeeded.ShouldBeEquivalentTo(htmlData[i].Succeeded);
                uploadedCodingTasks[i].Failed.ShouldBeEquivalentTo(htmlData[i].Failed);

                htmlData[i].DownloadFailed.ShouldBeEquivalentTo(htmlData[i].Failed.ToInteger() > 0
                    ? "Download Failed"
                    : String.Empty);

                var expectedDateTime                  = uploadedCodingTasks[i].Uploaded.ToDate();
                var displayedTimeStamp                = htmlData[i].Uploaded.ToDate();
                var timeStampDiff                     = expectedDateTime.Subtract(displayedTimeStamp);
                var areDatesEqualWithinAcceptableTime = Math.Abs(timeStampDiff.Hours) < hoursDiff;

                areDatesEqualWithinAcceptableTime.Should().BeTrue();
            }

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertTasksAreProcessedByTheWorkflow(
            this CoderDeclarativeBrowser browser,
            int expectedProcessedCount)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            var session  = browser.Session;
            var mevPage  = session.GetMevPage();
            var actualResults = mevPage.GetUploadedCodingTaskValues();

            if (!actualResults.Any())
            {
                throw new InvalidOperationException("No MEV Files have been processed");
            }

            var latestFile = actualResults.First();
            var successCount = 0;
            Int32.TryParse(latestFile.Succeeded, out successCount);

            var failedCount = 0;
            Int32.TryParse(latestFile.Failed, out failedCount);

            var actualProcessedCount = successCount + failedCount;

            actualProcessedCount.ShouldBeEquivalentTo(expectedProcessedCount);
            
            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatTheTaskHasSupplementalInfo(
            this CoderDeclarativeBrowser browser,
            string verbatim, 
            IList<SupplementalTerm> supplementalInfoList)
        {
            if (ReferenceEquals(browser, null))              throw new ArgumentNullException("browser");
            if (ReferenceEquals(verbatim, null))             throw new ArgumentNullException("verbatim");
            if (ReferenceEquals(supplementalInfoList, null)) throw new ArgumentNullException("supplementalInfoList");

            var session        = browser.Session;
            var codingTaskPage = session.GetCodingTaskPage();

            codingTaskPage.SelectTaskGridByVerbatimName(verbatim);

            codingTaskPage.SelectSourceTermTab();

            var sourceTermTab = session.GetTaskPageSourceTermTab();
            var htmlData      = sourceTermTab.GetSupplementalTableValues();

            for (var i = 0; i < supplementalInfoList.Count; i++)
            {
                supplementalInfoList[i].Term.ShouldBeEquivalentTo(htmlData[i].Term);
                supplementalInfoList[i].Value.ShouldBeEquivalentTo(htmlData[i].Value);
            }

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
    }
}
