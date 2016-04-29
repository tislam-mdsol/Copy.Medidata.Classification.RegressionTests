using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class TaskPageAssigmentsTab
    {
        private readonly BrowserSession _Browser;

        public TaskPageAssigmentsTab(BrowserSession browser) { if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }  _Browser = browser; }

        public SessionElementScope GetAssignmentFrame()
        {
            var assignmentFrame = _Browser.FindSessionElementById("ctl00_Content_FrmAssignment");

            return assignmentFrame;
        }

        public SessionElementScope GetAssignmentDetailGrid()
        {
            var assignmentDetailGrid = GetAssignmentFrame().FindSessionElementById("gridAssignment_DXMainTable");

            return assignmentDetailGrid;
        }

        public SessionElementScope GetAssignmentsPathGrid()
        {
            var assignmentsPathGrid = GetAssignmentFrame().FindSessionElementById("gridAssignmentDetail_DXMainTable");

            return assignmentsPathGrid;
        }

        public IList<SessionElementScope> GetAssignmentDetailGridRows()
        {
            var assignmentDetailGridRows = GetAssignmentDetailGrid().FindAllSessionElementsByXPath("tbody/tr");

            return assignmentDetailGridRows;
        }

        public IList<SessionElementScope> GetAssignmentsPathGridRows()
        {
            var assignmentsPathGridRows = GetAssignmentsPathGrid().FindAllSessionElementsByXPath("tbody/tr");

            return assignmentsPathGridRows;
        }

        public IList<AssignmentDetail> GetAssignmentDetailTableValues()
        {
            if (GetAssignmentDetailGridRows()[1].FindAllSessionElementsByXPath("td/div").ToList().Count == 1)
            {
                return null;
            }

            var assignmentDetailValues = (
                from assignmentDetailGridRow in GetAssignmentDetailGridRows()
                where !assignmentDetailGridRow.Id.Contains("HeadersRow")
                select assignmentDetailGridRow.FindAllSessionElementsByXPath("td")
                into assignmentDetailColumns
                select new AssignmentDetail
                {
                    Dictionary      = assignmentDetailColumns[0].Text,
                    User            = assignmentDetailColumns[1].Text,
                    Term            = assignmentDetailColumns[2].Text,
                    IsAutoCoded     = assignmentDetailColumns[3].InnerHTML.Contains("unchecked") ? "Unchecked" : "Checked",
                    IsActive        = assignmentDetailColumns[4].InnerHTML.Contains("unchecked") ? "Unchecked" : "Checked",
                })
                .ToList();

            return assignmentDetailValues;
        }

        public IList<AssignmentDetailPath> GetAssignmentsPathTableValues()
        {
            if (GetAssignmentsPathGridRows()[1].FindAllSessionElementsByXPath("td/div").ToList().Count == 1)
            {
                return null;
            }

            var assignmentPathValues = (
                from assignmentsPathRow in GetAssignmentsPathGridRows()
                where !assignmentsPathRow.Id.Contains("HeadersRow")
                select assignmentsPathRow.FindAllSessionElementsByXPath("td")
                into assignmentsPathColumns
                select new AssignmentDetailPath
                {
                    Level   = assignmentsPathColumns[0].Text,
                    Code    = assignmentsPathColumns[1].Text,
                    Term    = assignmentsPathColumns[2].Text
                })
                .ToList();

            return assignmentPathValues;
        }
    }
}
