//@auuthor:smalik
using Coder.DeclarativeBrowser.ExtensionMethods;
using System;
using Coypu;
using System.Collections.Generic;
using System.Linq;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveClinicalViewsPage
    {
         private readonly BrowserSession _Browser;
         private const string _RebuildViewsButtonHeaderText = "Rebuild Views";
         private const string _EditHeaderText               = "Edit";
         private const string _ModeHeaderText               = "Mode";

        internal RaveClinicalViewsPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        private SessionElementScope GetViewProjectsGrid()
        {
            var projectsGrid = _Browser.FindSessionElementById("_ctl0_Content_ViewProjectsGrid");

            return projectsGrid;
        }

        private SessionElementScope GetProjectRowRebuildViewsButton(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var projectsGrid       = GetViewProjectsGrid();

            var rebuildViewsCell   = projectsGrid    .FindTableCell(rowContents, _RebuildViewsButtonHeaderText);

            var rebuildViewsButton = rebuildViewsCell.FindSessionElementByXPath(".//input");

            return rebuildViewsButton;
        }

        private SessionElementScope GetProjectRowEditButton(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var projectsGrid   = GetViewProjectsGrid();

            var editButtonCell = projectsGrid  .FindTableCell(rowContents, _EditHeaderText);

            var editButton     = editButtonCell.FindSessionElementByXPath(".//a");

            return editButton;
        }

        private SessionElementScope GetProjectEdittedRowModeDDL(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var projectsGrid = GetViewProjectsGrid();

            var modeDDLCell  = projectsGrid.FindTableCell(rowContents, _ModeHeaderText);

            var modeDDL      = modeDDLCell .FindSessionElementByXPath(".//select");

            return modeDDL;
        }

        private SessionElementScope GetProjectEdittedRowUpdateLink(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var projectsGrid = GetViewProjectsGrid();

            var linkCell     = projectsGrid.FindTableCell(rowContents, _EditHeaderText);

            var updateLink   = linkCell    .FindSessionElementByXPath(".//a[contains(text(), 'Update')]");

            return updateLink;
        }

            internal void SetModeForProject(string project, string mode)
        {
            if (String.IsNullOrWhiteSpace(project)) throw new ArgumentNullException("project");
            if (String.IsNullOrWhiteSpace(mode))    throw new ArgumentNullException("mode");

            GetProjectRowRebuildViewsButton(project).Click();
            GetProjectRowEditButton(project)        .Click();
            GetProjectEdittedRowModeDDL(project)    .SelectOption(mode);
            GetProjectEdittedRowUpdateLink(project) .Click();
        }
    }
}
