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
