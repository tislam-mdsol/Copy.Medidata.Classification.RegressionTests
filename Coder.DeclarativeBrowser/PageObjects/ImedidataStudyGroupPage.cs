using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;
using NUnit.Framework;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal class ImedidataStudyGroupPage
    {
        private readonly BrowserSession _Browser;

        internal ImedidataStudyGroupPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        private enum StudyGroupTab { Attributes, Studies, Users, Depots, ELearning, CustomEmailText }

        private SessionElementScope GetNavigation()
        {
            var navigation = _Browser.FindSessionElementByXPath("//ul[@class='nav nav-tabs']");

            return navigation;
        }

        private IList<SessionElementScope> GetNavigationElements()
        {
            var navigation = GetNavigation();
            var navElements = navigation.FindAllSessionElementsByXPath(".//li");

            return navElements;
        }

        private SessionElementScope GetNavigationLink(StudyGroupTab tab)
        {
            var navElements    = GetNavigationElements();
            var navigationTab  = navElements.ElementAtOrDefault((int)tab);

            if (ReferenceEquals(navigationTab, null)) throw new ArgumentException("Tab not found");

            var navigationLink = navigationTab.FindSessionElementByXPath("a");

            return navigationLink;
        }

        private SessionElementScope GetCreateNewStudyButton()
        {
            var createNewStudyButton = _Browser.FindSessionElementById("create_new_study");

            return createNewStudyButton;
        }

        private SessionElementScope GetStudyPanel()
        {
            var managePanel = _Browser.FindSessionElementById("manage");

            return managePanel;
        }

        private SessionElementScope GetName()
        {
            var managePanel = GetStudyPanel();
            var name        = managePanel.FindSessionElementById("study_group_name");

            return name;
        }

        private SessionElementScope GetUUID()
        {
            var managePanel = GetStudyPanel();
            var UUID = managePanel.FindSessionElementByXPath(".//div[@class='form-group'][/label[contains(text(),'UUID')]");

            return UUID;
        }

        private SessionElementScope GetSummary()
        {
            var managePanel = GetStudyPanel();
            var summary     = managePanel.FindSessionElementById("study_group_summary");

            return summary;
        }

        private SessionElementScope GetFullDescription()
        {
            var managePanel      = GetStudyPanel();
            var fullDescription  = managePanel.FindSessionElementById("study_group_full_description");

            return fullDescription;
        }

        private SessionElementScope GetTypeSelectList()
        {
            var managePanel    = GetStudyPanel();
            var typeSelectList = managePanel.FindSessionElementById("study_group_study_group_type_id");

            return typeSelectList;
        }

        private IList<SessionElementScope> GetStudies()
        {
            var managePanel = GetStudyPanel();
            var studies     = managePanel.FindAllSessionElementsByXPath(
                ".//table[@id='studies_in_study_group_list']/tbody/tr/td/span");

            return studies;
        }

        internal void AddNewStudy(IMedidataStudy newMedidataStudy)
        {
            if (ReferenceEquals(newMedidataStudy,null)) throw new ArgumentNullException("newMedidataStudy");

            var navTab = GetNavigationLink(StudyGroupTab.Studies);
            navTab.Click();
            GetCreateNewStudyButton().Click();

            var studyPage = _Browser.GetImedidataStudyPage();
            studyPage.SetStudyAttributes(newMedidataStudy);
        }
    }
}
