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

        internal void OpenSiteAdministrationPage()
        {
            OpenRaveHomePage();
            var leftNavInstalledModuleLinks = _Session.FindAllSessionElementsByXPath("//table[@class='module-list text']//td/a");

            var siteAdministrationLink = leftNavInstalledModuleLinks.FirstOrDefault(x => x.InnerHTML.Contains("Site Administration"));//This sucks not reusable
            siteAdministrationLink.Click();
        }

        internal void OpenRaveHomePage()
        {
            var raveHomePageLink = _Session.FindSessionElementById("_ctl0_PgHeader_TabTextHyperlink0");
            raveHomePageLink.Click();
        }

    }
}
