using System;
using System.Linq;
using System.Reflection;
using Coder.DeclarativeBrowser.Models;
using FluentAssertions;
using NUnit.Framework;

namespace Coder.DeclarativeBrowser.ExtensionMethods.Assertions
{
    public static class StudyMigrationAssertionExtensionMethods
    {
        public static void AssertThatVerbatimTermExistsUnderPathChanged(
            this CoderDeclarativeBrowser browser,
            string verbatimTerm,
            string study, 
            string dictionary, 
            SynonymList sourceSynonymList, 
            SynonymList targetSynonymList)
        {
            if (ReferenceEquals(browser, null))           throw new ArgumentNullException("browser");
            if (ReferenceEquals(verbatimTerm, null))      throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrEmpty(study))              throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(dictionary))         throw new ArgumentNullException("dictionary");
            if (ReferenceEquals(sourceSynonymList, null)) throw new ArgumentNullException("sourceSynonymList");
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            var session = browser.Session;

            var studyImpactAnalysisPage = session.OpenStudyAnalysisPageWithReportForValues(
                study,
                dictionary,
                sourceSynonymList,
                targetSynonymList);

            studyImpactAnalysisPage
                .GetGenerateReportButton()
                .Click();

            studyImpactAnalysisPage
                .GetStudyReportGridPathChangedButton()
                .Click();

            var studyImpactAnalysisDetailValues = studyImpactAnalysisPage
                .GetStudyImpactAnalysisDetailValuesByVerbatim(verbatimTerm);

            studyImpactAnalysisDetailValues
                .Verbatim
                .ShouldBeEquivalentTo(verbatimTerm);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatVerbatimTermExistsUnderTermNotFound(
            this CoderDeclarativeBrowser browser,
            string verbatimTerm,
            string study, 
            string dictionary, 
            SynonymList sourceSynonymList, 
            SynonymList targetSynonymList)
        {
            if (ReferenceEquals(browser, null))           throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(verbatimTerm))       throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrEmpty(study))              throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(dictionary))         throw new ArgumentNullException("dictionary");
            if (ReferenceEquals(sourceSynonymList, null)) throw new ArgumentNullException("sourceSynonymList");
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            var session = browser.Session;

            var studyImpactAnalysisPage = session.OpenStudyAnalysisPageWithReportForValues(
                study,
                dictionary,
                sourceSynonymList,
                targetSynonymList);
            
            studyImpactAnalysisPage
                .GetStudyReportGridTermNotFoundButton()
                .Click();

            var studyImpactAnalysisDetailValues = studyImpactAnalysisPage
                .GetStudyImpactAnalysisDetailValuesByVerbatim(verbatimTerm);

            studyImpactAnalysisDetailValues
                .Verbatim
                .ShouldBeEquivalentTo(verbatimTerm);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatVerbatimTermExistsUnderCasingChanged(
            this CoderDeclarativeBrowser browser,
            string verbatimTerm,
            string study,
            string dictionary,
            SynonymList sourceSynonymList,
            SynonymList targetSynonymList)
        {
            if (ReferenceEquals(browser, null))           throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(verbatimTerm))       throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrEmpty(study))              throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(dictionary))         throw new ArgumentNullException("dictionary");
            if (ReferenceEquals(sourceSynonymList, null)) throw new ArgumentNullException("sourceSynonymList");
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            var session = browser.Session;

            var studyImpactAnalysisPage = session.OpenStudyAnalysisPageWithReportForValues(
                study,
                dictionary,
                sourceSynonymList,
                targetSynonymList);

            studyImpactAnalysisPage
                .GetStudyReportGridCasingChangedOnlyButton()
                .Click();

            var studyImpactAnalysisDetailValues = studyImpactAnalysisPage
                .GetStudyImpactAnalysisDetailValuesByVerbatim(verbatimTerm);

            studyImpactAnalysisDetailValues
                .Verbatim
                .ShouldBeEquivalentTo(verbatimTerm);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatCodingTasksAreInTheCorrectStatus(
            this CoderDeclarativeBrowser browser,
            string verbatimTerm,
            string status)
        {
            if (String.IsNullOrEmpty(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrEmpty(status))       throw new ArgumentNullException("status");
            
            var session = browser.Session;

            var codingTaskPage = session.GetCodingTaskPage();

            var codingTaskValues = codingTaskPage.GetTaskGridVerbatimElementValuesByVerbatimTerm(verbatimTerm);

            codingTaskValues.VerbatimTerm.Should().BeEquivalentTo(verbatimTerm);
            codingTaskValues.Status.ShouldBeEquivalentTo(status);
        }

        public static void AssertThatStudyMigrationIsCompleteForTheLatestVersion(
            this CoderDeclarativeBrowser browser,
            string study,
            string dictionary,
            string sourceVersion,
            string targetVersion)
        {
            if (ReferenceEquals(browser, null))      throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(study))         throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(dictionary))    throw new ArgumentNullException("dictionary");
            if (String.IsNullOrEmpty(targetVersion)) throw new ArgumentNullException("targetVersion");
            if (String.IsNullOrEmpty(sourceVersion)) throw new ArgumentNullException("sourceVersion");

            var session = browser.Session;

            var studyReportPage = session.OpenStudyReportPage();

            studyReportPage.GetDictionaryTypeDropDownList().SelectOption(dictionary);
            studyReportPage.GetStudyDropDownList().SelectOption(study);
            studyReportPage.WaitForStudyMigrationToComplete(study, targetVersion);

            var studyReportValues = studyReportPage.GetStudyReportValuesByStudy(study);

            sourceVersion.ShouldBeEquivalentTo(studyReportValues.InitialVersion);
            targetVersion.ShouldBeEquivalentTo(studyReportValues.CurrentVersion);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatVerbatimTermExistsWithCorrectCategoryAndStatus(
            this CoderDeclarativeBrowser browser,
            string study,
            string verbatimTerm,
            string categoryName,
            string dictionary,
            string targetVersion,
            string status)
        {
            if (ReferenceEquals(browser, null))      throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(study))         throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(verbatimTerm))  throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrEmpty(categoryName))  throw new ArgumentNullException("categoryName");
            if (String.IsNullOrEmpty(dictionary))    throw new ArgumentNullException("dictionary");
            if (String.IsNullOrEmpty(targetVersion)) throw new ArgumentNullException("targetVersion");
            if (String.IsNullOrEmpty(status))        throw new ArgumentNullException("status");

            var session = browser.Session;

            var studyReportPage = session.OpenStudyReportPage();

            studyReportPage.GetDictionaryTypeDropDownList().SelectOption(dictionary);
            studyReportPage.GetStudyDropDownList().SelectOption(study);
            studyReportPage.WaitForStudyMigrationToComplete(study, targetVersion);

            var policy = RetryPolicy.CompletionAssertion;

            policy.Execute( () =>
            {
                studyReportPage
                    .GetStudyReportCategoryButtonByStudyAndCategoryName(study, categoryName)
                    .Click();

                var studyReportCodingElements = studyReportPage
                    .GetStudyReportCodingElementsByVerbatimTerm(verbatimTerm);

                verbatimTerm.ShouldBeEquivalentTo(studyReportCodingElements.VerbatimTerm);

                if (!studyReportCodingElements.WorkflowStatus.Equals(status, StringComparison.OrdinalIgnoreCase))
                {
                    throw new AssertionException("Status is incorrect");
                }

                status.ShouldBeEquivalentTo(studyReportCodingElements.WorkflowStatus);
            });

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatTheNotAffectedCountIsEqualToNumberOfTasks(
            this CoderDeclarativeBrowser browser,
            int numberOfTasks,
            string study,
            string dictionary,
            SynonymList sourceSynonymList,
            SynonymList targetSynonymList)
        {
            if (ReferenceEquals(browser, null))           throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(study))              throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(dictionary))         throw new ArgumentNullException("dictionary");
            if (ReferenceEquals(sourceSynonymList, null)) throw new ArgumentNullException("sourceSynonymList");
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            var session                 = browser.Session;

            var studyImpactAnalysisPage = session.OpenStudyAnalysisPageWithReportForValues(
                study,
                dictionary,
                sourceSynonymList,
                targetSynonymList);
            
            var notAffectedLabel        = studyImpactAnalysisPage
                .GetStudyReportGridNotAffectedLabel()
                .Text;

            numberOfTasks
                .Should()
                .Be(notAffectedLabel.ToInteger());

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatTheTermHasCodingHistoryComment(
            this CoderDeclarativeBrowser browser,
            string verbatimTerm,
            string codingHistoryComment)
        {
            if (ReferenceEquals(browser, null))             throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(verbatimTerm))         throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrEmpty(codingHistoryComment)) throw new ArgumentNullException("codingHistoryComment");

            //TODO: replace this globally during refactor story should be in GoTo for Coding task page
            browser.GoToTaskPage();

            var session        = browser.Session;
            var codingTaskPage = session.GetCodingTaskPage();

            codingTaskPage.ClearFilters();
            codingTaskPage.SelectTaskGridByVerbatimName(verbatimTerm);
            codingTaskPage.GetCodingHistoryTab().Click();

            var selectedTask          = codingTaskPage.GetSelectedCodingTask();
            var codingHistoryTab      = session.GetTaskPageCodingHistoryTab();
            var codingHistoryGridRows = codingHistoryTab.GetCodingHistoryDetailValues(selectedTask);

            codingHistoryGridRows.Any(
                x => x.Comment.EqualsIgnoreCase(codingHistoryComment))
                .Should()
                .BeTrue();

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
    }
}
