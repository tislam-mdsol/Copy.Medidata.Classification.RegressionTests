using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class TaskPageQueryHistoryTab
    {
        private readonly BrowserSession _Browser;

        private const int _UserIndex           = 0;
        private const int _VerbatimTermIndex   = 1;
        private const int _QueryStatusIndex    = 2;
        private const int _QueryTextIndex      = 3;
        private const int _QueryResponseIndex  = 4;
        private const int _OpenToIndex         = 5;
        private const int _QueryNotesIndex     = 6;
        private const int _TimeStampIndex      = 7;

        internal TaskPageQueryHistoryTab(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }

            _Browser = browser;
        }

        private SessionElementScope GetQueryHistoryTab()
        {
            var queryHistoryTab = _Browser.FindSessionElementById("ctl00_Content_tab4");

            return queryHistoryTab;
        }

        internal SessionElementScope GetQueryHistoryFrame()
        {
            var queryHistoryFrame = _Browser.FindSessionElementByXPath("//iframe[@id = 'ctl00_Content_FrmQuery']");

            return queryHistoryFrame;
        }

        private SessionElementScope GetQueryHistoryGrid()
        {
            var queryHistoryGrid = GetQueryHistoryFrame().FindSessionElementById("gridHistory_DXMainTable");

            return queryHistoryGrid;
        }

        private IList<SessionElementScope> GetQueryHistoryGridDataRows()
        {
            var queryHistoryGridRows =
                GetQueryHistoryGrid().FindAllSessionElementsByXPath("tbody/tr[not(contains(@id,'HeadersRow'))]");

            return queryHistoryGridRows;
        }

        private void WaitUntilFinishLoading()
        {
            _Browser.WaitUntilElementExists(GetQueryHistoryGrid);
        }

        internal List<string> GetQueryHistoryDetailAdditionalInformationValues()
        {
            WaitUntilFinishLoading();

            if (GetQueryHistoryGridDataRows().Count == 0)
            {
                return null;
            }

            var queryTaskVerbatims = (
                from queryTaskGridRow in GetQueryHistoryGridDataRows()
                select queryTaskGridRow.FindAllSessionElementsByXPath("td")
                into queryTaskColumns
                select queryTaskColumns[_VerbatimTermIndex])
                .ToList();
            
            var queryTaskVerbatimShowGroups = (
                from queryTaskVerbatim in queryTaskVerbatims
                select queryTaskVerbatim.FindAllSessionElementsByXPath("img"))
                .ToList();

            foreach (var queryTaskVerbatimShowGroup in queryTaskVerbatimShowGroups)
            {
                foreach (var showGroup in queryTaskVerbatimShowGroup)
                {
                    showGroup.Click();
                }
            }

            var queryTaskVerbatimAdditionalInformations = (
                from queryTaskVerbatim in queryTaskVerbatims
                select queryTaskVerbatim.FindAllSessionElementsByXPath("div/div"))
                .ToList();

            List<string> combinedAdditionalInformations = new List<string>();
            
            foreach (var queryTaskVerbatimAdditionalInformation in queryTaskVerbatimAdditionalInformations)
            {
                string combinedAdditionalInformation = string.Empty;

                foreach (var additionalInformation in queryTaskVerbatimAdditionalInformation)
                {
                    combinedAdditionalInformation += additionalInformation.Text;
                }

                combinedAdditionalInformations.Add(combinedAdditionalInformation);
            }
            return combinedAdditionalInformations;
        }
        
        internal IList<QueryHistoryDetail> GetQueryHistoryDetailValues()
        {
            GetQueryHistoryTab().Click();

            WaitUntilFinishLoading();

            if (GetQueryHistoryGridDataRows().Count == 0)
            {
                return null;
            }

            var queryTaskValues = (
                from queryTaskGridRow in GetQueryHistoryGridDataRows()
                select queryTaskGridRow.FindAllSessionElementsByXPath("td")
                    into queryTaskColumns
                select new QueryHistoryDetail
                {
                    User          = queryTaskColumns[_UserIndex].Text,
                    VerbatimTerm  = queryTaskColumns[_VerbatimTermIndex].Text,
                    QueryStatus   = queryTaskColumns[_QueryStatusIndex].Text,
                    QueryText     = queryTaskColumns[_QueryTextIndex].Text,
                    QueryResponse = queryTaskColumns[_QueryResponseIndex].Text,
                    OpenTo        = queryTaskColumns[_OpenToIndex].Text,
                    QueryNotes    = queryTaskColumns[_QueryNotesIndex].Text,
                    TimeStamp     = queryTaskColumns[_TimeStampIndex].Text
                })
                .ToList();
            return queryTaskValues;
        }
    }
}
