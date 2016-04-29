using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class CreateGeneralRolesPage
    {
        private readonly BrowserSession _Browser;
        private const string            PageName                     = "Create General Role";
        private const int               GeneralRoleGridNameIndex     = 0;
        private const int               GeneralRoleGridIsActiveIndex = 1;

        internal CreateGeneralRolesPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        internal bool OnCreateGeneralRolesPage()
        {
            var title = _Browser.Title;

            return title.Equals(PageName);
        }

        internal void GoTo()
        {
            if (!OnCreateGeneralRolesPage())
            {
                _Browser.GoToAdminPage(PageName);
            }
        }

        internal SessionElementScope GetGeneralRolesGrid()
        {
            var createGeneralRolesGrid = _Browser.FindSessionElementById("ctl00_Content_gridRole_DXMainTable");

            return createGeneralRolesGrid;
        }

        internal IList<SessionElementScope> GetGeneralRolesGridRows()
        {
            var createGeneralRolesGridRolesGridRows =
                GetGeneralRolesGrid().FindAllSessionElementsByXPath("tbody/tr[not(contains(@id,\"HeadersRow\")) and not(contains(@id,\"FooterRow\"))]");

            return createGeneralRolesGridRolesGridRows;
        }

        internal SessionElementScope GetGeneralRolesActionsGrid()
        {
            var generalRolesActionsGrid = _Browser.FindSessionElementById("ctl00_Content_gridModuleActions_DXMainTable");

            return generalRolesActionsGrid;
        }

        internal List<SessionElementScope> GetGeneralRolesActionsGridRows()
        {
            var generalRolesActionsGrid = GetGeneralRolesActionsGrid().FindAllSessionElementsByXPath("tbody/tr").ToList();

            return generalRolesActionsGrid;
        }

        public SessionElementScope GetGeneralRoleGridRowByRoleName(string roleName)
        {
            if (ReferenceEquals(roleName, null)) throw new ArgumentNullException("roleName");

            var generalRolesRows = GetGeneralRolesGridRows()
                .Where(row => row.FindAllSessionElementsByXPath("td")[GeneralRoleGridNameIndex].Text.Equals(roleName))
                .ToList();

            if (generalRolesRows.Count > 1)
            {
                throw new InvalidOperationException(String.Format("generalRolesRows duplicate role name: {0}.", roleName));
            }

            if (generalRolesRows.Count == 0)
            {
                return null;
            }

            return generalRolesRows[0];
        }

        internal SessionElementScope GetAddNewButton()
        {
            var addNewButton = _Browser.FindSessionElementById("ctl00_Content_gridRole_FooterRow_LnkAddNewgridRole");

            return addNewButton;
        }

        internal SessionElementScope GetRoleNameTextBox()
        {
            var roleNameTextBox = _Browser.FindSessionElementById("ctl00_Content_gridRole_DXEditor0_I");

            return roleNameTextBox;
        }

        internal SessionElementScope GetSaveRoleButton()
        {
            var saveRoleButton = _Browser.FindSessionElementByXPath("//img[@title = 'Update']");

            return saveRoleButton;
        }

        internal SessionElementScope GetSecurityModuleDropDownList()
        {
            var securityModule = _Browser.FindSessionElementById("ctl00_Content_DdlModules");

            return securityModule;
        }

        internal SessionElementScope GetIsActiveCheckBox()
        {
            var isActiveCheckBox = _Browser.FindSessionElementByXPath("//input[@id='ctl00_Content_gridRole_DXEditor1_I']");

            return isActiveCheckBox;
        }

        internal SessionElementScope GetGeneralRoleRowEditButtonByRoleName(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");

            var workflowRow = GetGeneralRoleGridRowByRoleName(roleName);
            var getSelectWorkflowEditButton = workflowRow.FindSessionElementByXPath(".//td[3]//i[contains(@style, 'i_edit')]");

            return getSelectWorkflowEditButton;
        }

        internal SessionElementScope GetSelectAllCheckBox()
        {
            var selectAllCheckBox = _Browser.FindSessionElementById("SelectionChxId");

            return selectAllCheckBox;
        }

        internal SessionElementScope GetUpdateButton()
        {
            var updateButton = _Browser.FindSessionElementById("ctl00_Content_BtnUpdateAction");

            return updateButton;
        }

        internal SessionElementScope GetCancelButton()
        {
            var cancelButton = _Browser.FindSessionElementById("ctl00_Content_BtnCancelAction");

            return cancelButton;
        }

        internal SessionElementScope GetSelectGeneralRoleAction(string actionName)
        {
            if (String.IsNullOrWhiteSpace(actionName)) throw new ArgumentNullException("actionName");

            var getSelectWorkflowAction = _Browser.FindSessionElementByXPath(string.Format("//tr/td[(text()= '{0}')]/parent::tr/td[1]/input[contains(@id, 'ctl00_Content_gridModuleActions_DXSelBtn')]", actionName));

            return getSelectWorkflowAction;
        }

        internal IList<GeneralRole> GetGeneralRoleGridValues()
        {
            if (GetGeneralRolesGridRows().Count == 0)
            {
                return null;
            }

            var generalRoles = (
                from generalGridRoles in GetGeneralRolesGridRows()
                select generalGridRoles.FindAllSessionElementsByXPath("td")
                    into generalRole
                    select new GeneralRole
                    {
                        Name = generalRole[GeneralRoleGridNameIndex].Text,
                        IsActive = generalRole[GeneralRoleGridIsActiveIndex].InnerHTML.Contains("i_checked", StringComparison.OrdinalIgnoreCase)
                    })
                .ToList();

            return generalRoles;
        }

        internal void ActivateAllRoleActions(string securityModule, string roleName)
        {
            if (ReferenceEquals(securityModule, null)) throw new ArgumentNullException("securityModule");
            if (ReferenceEquals(roleName, null)) throw new ArgumentNullException("roleName");

            GetSecurityModuleDropDownList().SelectOptionAlphanumericOnly(securityModule);
            GetGeneralRoleGridRowByRoleName(roleName).Click();
            GetSelectAllCheckBox().Check();
            GetUpdateButton().Click();
        }

        internal void CreateGeneralRole(string roleName, string securityModule)
        {
            if (String.IsNullOrWhiteSpace(roleName))       throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule"); 

            GetSecurityModuleDropDownList().SelectOptionAlphanumericOnly(securityModule);
            GetAddNewButton().Click();
            GetRoleNameTextBox().FillInWith(roleName);
            GetSaveRoleButton().Click();
        }

        internal void ActivateGeneralRole(string roleName, string securityModule)
        {
            if (String.IsNullOrWhiteSpace(roleName))       throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule"); 

            GetSecurityModuleDropDownList().SelectOptionAlphanumericOnly(securityModule);
            GetGeneralRoleRowEditButtonByRoleName(roleName).Click();
            GetIsActiveCheckBox().SetCheckBoxState(true);
            GetSaveRoleButton().Click();
        }

        internal void RemoveGeneralRoleAction(string roleName, string securityModule, string actionName)
        {
            if (String.IsNullOrWhiteSpace(roleName))       throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule");
            if (String.IsNullOrWhiteSpace(actionName))     throw new ArgumentNullException("actionName");

            GetSecurityModuleDropDownList().SelectOptionAlphanumericOnly(securityModule);
            GetGeneralRoleGridRowByRoleName(roleName).Click();
            GetSelectGeneralRoleAction(actionName).Click();
            GetUpdateButton().Click();
        }
    }
}
