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
    internal class ImedidataStudyPage
    {
        private readonly BrowserSession _Browser;

        internal ImedidataStudyPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        private enum StudyTab { Attributes, Users, Sites, Depots, ELearning, CustomEmailText }

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

        private SessionElementScope GetNavigationLink(StudyTab tab)
        {
            var navElements = GetNavigationElements();
            var navigationTab = navElements.ElementAtOrDefault((int)tab);

            if (ReferenceEquals(navigationTab, null)) throw new ArgumentException("Tab not found");

            var navLink = navigationTab.FindSessionElementByXPath("a");

            return navLink;
        }

        private SessionElementScope GetStudyName()
        {
            var studyName   = _Browser.FindSessionElementById("study_name");

            return studyName;
        }

        private SessionElementScope GetProductionCheckbox()
        {
            var productionCheckbox = _Browser.FindSessionElementById("study_is_production");

            return productionCheckbox;
        }

        private SessionElementScope GetProtocolNumber()
        {
            var protocolNumber = _Browser.FindSessionElementById("study_oid");

            return protocolNumber;
        }

        private SessionElementScope GetEnvironmentSelectList()
        {
            var environmentSelectList = _Browser.FindSessionElementById("study_environment_id");

            return environmentSelectList;
        }

        private SessionElementScope GetUUID()
        {
            var uuid = _Browser.FindSessionElementByXPath("//div[label[@for='study_uuid']]/div");

            return uuid;
        }

        private SessionElementScope GetStatusSelectList()
        {
            var statusSelectList = _Browser.FindSessionElementById("study_status");

            return statusSelectList;
        }

        private SessionElementScope GetSaveNewStudyButton()
        {
            var saveButton = _Browser.FindSessionElementByXPath("//button[@type='submit']");

            return saveButton;
        }

        internal void UpdateStudyAttributes(IMedidataStudy medidataStudy)
        {
            if (ReferenceEquals(medidataStudy, null)) throw new ArgumentNullException("medidataStudy");

            GetNavigationLink(StudyTab.Attributes).Click();
            SetStudyAttributes(medidataStudy);
        }

        internal void SetStudyAttributes(IMedidataStudy medidataStudy)
        {
            if (ReferenceEquals(medidataStudy, null)) throw new ArgumentNullException("medidataStudy");

            GetStudyName().FillInWith(medidataStudy.Name);
            GetProtocolNumber().FillInWith(medidataStudy.ProtocolNumber);
            
            if (!medidataStudy.Environment.Equals(StudyEnvironment.None))
            {
                SelectStudyEnvironment(medidataStudy.Environment);
            }

            GetSaveNewStudyButton().Click();
        }

        private void SelectStudyEnvironment(StudyEnvironment environment)
        {
            var selectOption = Enum.GetName(typeof (StudyEnvironment), environment);

            var environmentSelectList = GetEnvironmentSelectList();

            environmentSelectList.SelectOptionAlphanumericOnly(selectOption);
        }

        internal IMedidataStudy GetStudyAttributes()
        {
            GetNavigationLink(StudyTab.Attributes).Click();

            var study = new IMedidataStudy()
            {
                Name           = GetStudyName().Text,
                ProtocolNumber = GetProtocolNumber().Text,
                ObjectID       = GetUUID().Text,
                Environment = GetStudyEnvironment()
            };

            return study;
        }

        private StudyEnvironment GetStudyEnvironment()
        {
            var environmentSelectList = GetEnvironmentSelectList();
            var selectedEnvironment   = environmentSelectList.SelectedOption.RemoveNonAlphanumeric();

            StudyEnvironment environment;

            Enum.TryParse(selectedEnvironment, true, out environment);

            return environment;
        }
    }
}
