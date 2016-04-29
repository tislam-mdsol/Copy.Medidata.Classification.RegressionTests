using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class TaskPageCodingHistoryTab
    {
        private readonly BrowserSession _Browser;

        private const int UserIndex         = 0;
        private const int ActionIndex       = 1;
        private const int StatusIndex       = 2;
        private const int VerbatimTermIndex = 3;
        private const int CommentIndex      = 4;
        private const int TermPathIndex     = 5;
        private const int TimeStampIndex    = 6;

        internal TaskPageCodingHistoryTab(BrowserSession browser) 
        { 
            if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }

            _Browser = browser; 
        }

        private SessionElementScope GetCodingHistoryTab()
        {
            var codingHistoryTab = _Browser.FindSessionElementById("ctl00_Content_tab3");

            return codingHistoryTab;
        }

        internal SessionElementScope GetCodingHistoryFrame()
        {
            var codingHistoryFrame = _Browser.FindSessionElementByXPath("//iframe[@id = 'ctl00_Content_FrmHistory']");

            return codingHistoryFrame;
        }

        private SessionElementScope GetCodingHistoryGrid()
        {
            var codingHistoryGrid = GetCodingHistoryFrame().FindSessionElementById("gridHistory_DXMainTable");

            return codingHistoryGrid;
        }

        private IList<SessionElementScope> GetCodingHistoryGridDataRows()
        {
            var codingHistoryGridRows =
                GetCodingHistoryGrid().FindAllSessionElementsByXPath("tbody/tr[not(contains(@id,'HeadersRow'))]");

            return codingHistoryGridRows;
        }

        internal CodingHistoryDetail[] GetCodingHistoryDetailValues(CodingTask selectedTask = null)
        {
            GetCodingHistoryTab().Click();

            if (!ReferenceEquals(selectedTask, null))
            {
                WaitForCodingHistoryGridPopulation(selectedTask);
            }

            var codingHistoryGridRows = GetCodingHistoryGridDataRows();

            if (codingHistoryGridRows.Count == 0)
            {
                return null;
            }

            var codingHistoryCount = codingHistoryGridRows.Count;
            var codingHistoryDetailValues = new CodingHistoryDetail[codingHistoryCount];

            for (var i = 0; i < codingHistoryCount; i++)
            {
                var detailColumns = codingHistoryGridRows[i].FindAllSessionElementsByXPath("td");

                codingHistoryDetailValues[i] = new CodingHistoryDetail
                {
                    User                 = detailColumns[UserIndex        ].Text,
                    Action               = detailColumns[ActionIndex      ].Text,
                    Status               = detailColumns[StatusIndex      ].Text,
                    VerbatimTerm         = detailColumns[VerbatimTermIndex].Text,
                    Comment              = detailColumns[CommentIndex     ].Text,
                    TimeStamp            = detailColumns[TimeStampIndex   ].Text,

                    SelectedTermPathRow  = TermPathRowDisplay
                    .GetSelectedCodingHistoryTermPathRow(
                        detailColumns[TermPathIndex]),

                    ExpandedTermPathRows = TermPathRowDisplay
                    .GetExpandedCodingHistoryTermPathRows(
                        detailColumns[TermPathIndex])
                };
            }

            return codingHistoryDetailValues;
        }

        internal List<string> GetCodingHistoryDetailAdditionalInformationValues()
        {
            var codingTaskVerbatims = (
                from codingTaskGridRow in GetCodingHistoryGridDataRows()
                select codingTaskGridRow.FindAllSessionElementsByXPath("td")
                into codingTaskColumns
                select codingTaskColumns[VerbatimTermIndex])
                .ToList();

            var codingTaskVerbatimShowGroups = (
                from codingTaskVerbatim in codingTaskVerbatims
                select codingTaskVerbatim.FindAllSessionElementsByXPath("img"))
                .ToList();

            foreach (var codingTaskVerbatimShowGroup in codingTaskVerbatimShowGroups)
            {
                foreach (var showGroup in codingTaskVerbatimShowGroup)
                {
                    showGroup.Click();
                }
            }

            var codingTaskVerbatimAdditionalInformations = (
                from codingTaskVerbatim in codingTaskVerbatims
                select codingTaskVerbatim.FindAllSessionElementsByXPath("div/div"))
                .ToList();

            List<string> combinedAdditionalInformations = new List<string>();

            foreach (var codingTaskVerbatimAdditionalInformation in codingTaskVerbatimAdditionalInformations)
            {
                string combinedAdditionalInformation = string.Empty;

                foreach (var additionalInformation in codingTaskVerbatimAdditionalInformation)
                {
                    combinedAdditionalInformation += additionalInformation.Text;
                }

                combinedAdditionalInformations.Add(combinedAdditionalInformation);
            }
            return combinedAdditionalInformations;
        }

        private void WaitForCodingHistoryGridPopulation(CodingTask selectedTask)
        {
            if (ReferenceEquals(selectedTask, null)) throw new ArgumentNullException("selectedTask");

            var codingHistoryDetails = GetCodingHistoryDetailValues();
            var newestRow            = codingHistoryDetails.ElementAtOrDefault(0);

            if (ReferenceEquals(newestRow, null))
            {
                throw new MissingHtmlException("no coding history rows found");
            }

            var matchedRow = codingHistoryDetails.FirstOrDefault(
                x => x.VerbatimTerm.Equals(selectedTask.VerbatimTerm, StringComparison.OrdinalIgnoreCase)
                && x.Status.Equals(selectedTask.Status, StringComparison.OrdinalIgnoreCase)
                && ReferenceEquals(x.SelectedTermPathRow, null) 
                    ? String.IsNullOrWhiteSpace(selectedTask.AssignedTerm)
                    : ExtractTermFromTermPath(x.SelectedTermPathRow.TermPath).Equals(selectedTask.AssignedTerm, StringComparison.OrdinalIgnoreCase));

            if (ReferenceEquals(matchedRow, null))
            {
                throw new MissingHtmlException(String.Format("Coding history row for verbatim {0} with status {1} and term {2} not found",
                    selectedTask.VerbatimTerm,
                    selectedTask.Status,
                    selectedTask.AssignedTerm));
            }

            CollapseAllExpandedTermPaths();
        }

        internal string GetNewestStatusOfTask()
        {
            var codingHistoryDetails = GetCodingHistoryDetailValues();
            var newestRow = codingHistoryDetails.ElementAtOrDefault(0);

            if (ReferenceEquals(newestRow, null)) throw new InvalidOperationException("No task history has been recorded");

            return newestRow.Status;
        }

        private static string ExtractTermFromTermPath(string termPath)
        {
            if (String.IsNullOrWhiteSpace(termPath)) throw new ArgumentNullException("termPath");

            var result = termPath.Substring(0, termPath.IndexOf(':'));

            return result;
        }

        private void CollapseAllExpandedTermPaths()
        {
            var codingHistoryDetailRows = GetCodingHistoryGridDataRows();

            if (ReferenceEquals(codingHistoryDetailRows, null))
            {
                throw new MissingHtmlException("no coding history rows found");
            }

            foreach (var row in codingHistoryDetailRows.Where(row => row.FindAllSessionElementsByXPath(".//ul[contains(@class, 'on')]/li").Count() > 1))
            {
                row.FindSessionElementByXPath(".//td[6]").Click();
            }
        }
    }
}
