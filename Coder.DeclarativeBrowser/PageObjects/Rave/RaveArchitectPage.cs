using System;
using Coypu;
using Coder.DeclarativeBrowser.ExtensionMethods;
using System.Collections.Generic;
using System.Linq;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveArchitectPage
    {
        private readonly BrowserSession _Session;

        internal RaveArchitectPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }
        
        private SessionElementScope GetProjectsGrid()
        {
            var projectsGrid = _Session.FindSessionElementById("_ctl0_Content_ProjectGrid");

            return projectsGrid;
        }

        private IList<SessionElementScope> GetProjects()
        {
            var projectsGrid = GetProjectsGrid();

            var projects = projectsGrid.FindAllSessionElementsByXPath(".//a");

            return projects.ToList();
        }

        internal void OpenProject(string projectName)
        {
            if (String.IsNullOrWhiteSpace(projectName)) throw new ArgumentNullException("projectName");

            _Session.WaitUntilElementExists(GetProjectsGrid);

            var projects    = GetProjects();

            var projectLink = projects.FirstOrDefault(x => x.Text.EqualsIgnoreCase(projectName));

            if (ReferenceEquals(projectLink, null))
            {
                throw new MissingHtmlException(String.Format("No project was found for '{0}'", projectName));
            }

            projectLink.Click();
        }

    }
}
