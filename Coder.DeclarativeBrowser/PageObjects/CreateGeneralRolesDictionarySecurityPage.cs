using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class CreateGeneralRolesDictionarySecurityPage
    {
        private readonly BrowserSession _Browser;

        public CreateGeneralRolesDictionarySecurityPage(BrowserSession browser) { if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }  _Browser = browser; }

        public SessionElementScope GetCreateGeneralRolesGrid()
        {
            var createGeneralRolesGrid = _Browser.FindSessionElementById("ctl00_Content_gridRole_DXMainTable");

            return createGeneralRolesGrid;
        }

        public List<SessionElementScope> GetCreateGeneralRolesGridRolesGridRows()
        {
            var createGeneralRolesGridRolesGridRows =
                GetCreateGeneralRolesGrid().FindAllSessionElementsByXPath("tbody/tr").ToList();

            return createGeneralRolesGridRolesGridRows;
        }

        public SessionElementScope GetGeneralRolesActionsGrid()
        {
            var generalRolesActionsGrid = _Browser.FindSessionElementById("ctl00_Content_gridModuleActions_DXMainTable");

            return generalRolesActionsGrid;
        }

        public List<SessionElementScope> GetGeneralRolesActionsGridRows()
        {
            var generalRolesActionsGrid = GetGeneralRolesActionsGrid().FindAllSessionElementsByXPath("tbody/tr").ToList();

            return generalRolesActionsGrid;
        }

        public SessionElementScope GetAddNewButton()
        {
            var addNewButton = _Browser.FindSessionElementById("ctl00_Content_gridRole_FooterRow_LnkAddNewgridRole");

            return addNewButton;
        }

        public SessionElementScope GetRoleNameTextBox()
        {
            var roleNameTextBox = _Browser.FindSessionElementById("ctl00_Content_gridRole_DXEditor0_I");

            return roleNameTextBox;
        }

        public SessionElementScope GetSecurityModule()
        {
            var securityModule = _Browser.FindSessionElementById("ctl00_Content_DdlModules");

            return securityModule;
        }

        public SessionElementScope GetIsActiveCheckBox()
        {
            var isActiveCheckBox = _Browser.FindSessionElementById(""); //TODO: ADD XPATH LOGIC

            return isActiveCheckBox;
        }

        public SessionElementScope GetSelectAllCheckBox()
        {
            var selectAllCheckBox = _Browser.FindSessionElementById("SelectionChxId");

            return selectAllCheckBox;
        }

        public SessionElementScope GetUpdateButton()
        {
            var updateButton = _Browser.FindSessionElementById("ctl00_Content_BtnUpdateAction");

            return updateButton;
        }

        public SessionElementScope GetCancelButton()
        {
            var cancelButton = _Browser.FindSessionElementById("ctl00_Content_BtnCancelAction");

            return cancelButton;
        }

        public SessionElementScope GetCodingDecisionsReportCheckBox()
        {
            var codingDecisionsReportCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridModuleActions_DXSelBtn0");

            return codingDecisionsReportCheckBox;
        }

        public SessionElementScope GetEditStudyIncludeKeepCheckBox()
        {
            var editStudyIncludeKeepCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridModuleActions_DXSelBtn1");

            return editStudyIncludeKeepCheckBox;
        }

        public SessionElementScope GetMigrateStudyCheckBox()
        {
            var migrateStudyCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridModuleActions_DXSelBtn2");

            return migrateStudyCheckBox;
        }

        public SessionElementScope GetReclassifyCheckBox()
        {
            var reclassifyCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridModuleActions_DXSelBtn3");

            return reclassifyCheckBox;
        }

        public SessionElementScope GetStudyReportCheckBox()
        {
            var studyReportCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridModuleActions_DXSelBtn4");

            return studyReportCheckBox;
        }

        public SessionElementScope GetSynonymAdminCheckBox()
        {
            var synonymAdminCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridModuleActions_DXSelBtn5");

            return synonymAdminCheckBox;
        }

        public SessionElementScope GetSynonymListAdminCheckBox()
        {
            var synonymListAdminCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridModuleActions_DXSelBtn6");

            return synonymListAdminCheckBox;
        }

        public SessionElementScope GetViewImpactAnalysisCheckBox()
        {
            var viewImpactAnalysisCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridModuleActions_DXSelBtn7");

            return viewImpactAnalysisCheckBox;
        }
    }
}
