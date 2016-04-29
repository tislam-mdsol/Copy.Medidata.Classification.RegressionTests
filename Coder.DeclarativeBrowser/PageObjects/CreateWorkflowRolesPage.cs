using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class CreateWorkflowRolesPage
    {
        private readonly BrowserSession _Browser;
        private const string            PageName                  = "Create Workflow Role";
        private const int               WorkflowGridNameIndex     = 0;
        private const int               WorkflowGridIsActiveIndex = 1;

        internal CreateWorkflowRolesPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser"); 

            _Browser = browser;
        }

        internal bool OnCreateWorkflowRolesPage()
        {
            var title = _Browser.Title;

            return title.Equals(PageName);
        }

        internal void GoTo()
        {
            if (!OnCreateWorkflowRolesPage())
            {
                _Browser.GoToAdminPage(PageName);
            }
        }

        internal SessionElementScope GetWorkflowRolesGrid()
        {
            var workflowRolesGrid = _Browser.FindSessionElementById("ctl00_Content_gridWorkflowRole_DXMainTable");

            return workflowRolesGrid;
        }

        internal IList<SessionElementScope> GetWorkflowRolesGridRows()
        {
            var workflowRolesGridRows = GetWorkflowRolesGrid().FindAllSessionElementsByXPath("tbody/tr[not(contains(@id,\"HeadersRow\")) and not(contains(@id,\"FooterRow\"))]");

            return workflowRolesGridRows;
        }

        internal SessionElementScope GetWorkflowActionsGrid()
        {
            var workflowActionsGrid = _Browser.FindSessionElementById("ctl00_Content_gridWorkflowRole_DXMainTable");

            return workflowActionsGrid;
        }

        internal List<SessionElementScope> GetWorkflowActionsGridRows()
        {
            var workflowActionsGridRows = GetWorkflowActionsGrid().FindAllSessionElementsByXPath("tbody/tr").ToList();

            return workflowActionsGridRows;
        }

        public SessionElementScope GetWorkflowRoleGridRowByRoleName(string roleName)
        {
            if (ReferenceEquals(roleName, null)) throw new ArgumentNullException("roleName");

            var workflowGridRows = GetWorkflowRolesGridRows()
                .Where(row => row.FindAllSessionElementsByXPath("td")[WorkflowGridNameIndex].Text.Equals(roleName))
                .ToList();

            if (workflowGridRows.Count > 1)
            {
                throw new InvalidOperationException(String.Format("workflowGridRows duplicate role name: {0}.", roleName));
            }

            if (workflowGridRows.Count == 0)
            {
                return null;
            }

            return workflowGridRows[0];
        }

        internal SessionElementScope GetAddNewButton()
        {
            var addNewButton =
                _Browser.FindSessionElementById("ctl00_Content_gridWorkflowRole_FooterRow_LnkAddNewgridWorkflowRole");

            return addNewButton;
        }

        internal SessionElementScope GetSaveRoleButton()
        {
            var saveRoleButton = _Browser.FindSessionElementByXPath("//img[@title = 'Update']");

            return saveRoleButton;
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

        internal SessionElementScope GetRoleNameTextBox()
        {
            var roleNameTextBox = _Browser.FindSessionElementById("ctl00_Content_gridWorkflowRole_DXEditor0_I");

            return roleNameTextBox;
        }

        internal SessionElementScope GetSelectAllCheckBox()
        {
            var selectAllCheckBox = _Browser.FindSessionElementById("SelectionChxId");

            return selectAllCheckBox;
        }

        internal SessionElementScope GetAddCommentCheckBox()
        {
            var addCommentCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridWorkflowActions_DXSelBtn0");

            return addCommentCheckBox;
        }

        internal SessionElementScope GetApproveCheckBox()
        {
            var approveCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridWorkflowActions_DXSelBtn1");

            return approveCheckBox;
        }

        internal SessionElementScope GetCancelQueryCheckBox()
        {
            var cancelQueryCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridWorkflowActions_DXSelBtn2");

            return cancelQueryCheckBox;
        }

        internal SessionElementScope GetCodeCheckBox()
        {
            var codeCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridWorkflowActions_DXSelBtn3");

            return codeCheckBox;
        }

        internal SessionElementScope GetLeaveAsIsCheckBox()
        {
            var leaveAsIsCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridWorkflowActions_DXSelBtn4");

            return leaveAsIsCheckBox;
        }

        internal SessionElementScope GetOpenQueryCheckBox()
        {
            var openQueryCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridWorkflowActions_DXSelBtn5");

            return openQueryCheckBox;
        }

        internal SessionElementScope GetReCodeCheckBox()
        {
            var reCodeCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridWorkflowActions_DXSelBtn6");

            return reCodeCheckBox;
        }

        internal SessionElementScope GetReConsiderCheckBox()
        {
            var reConsiderCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridWorkflowActions_DXSelBtn7");

            return reConsiderCheckBox;
        }

        internal SessionElementScope GetRejectCodingCheckBox()
        {
            var rejectCodingCheckBox = _Browser.FindSessionElementById("ctl00_Content_gridWorkflowActions_DXSelBtn8");

            return rejectCodingCheckBox;
        }

        internal SessionElementScope GetIsActiveCheckBox()
        {
            var isActiveCheckBox = _Browser.FindSessionElementByXPath("//input[@id='ctl00_Content_gridWorkflowRole_DXEditor1_I']");

            return isActiveCheckBox;
        }

        internal SessionElementScope GetSelectWorkflowAction(string actionName)
        {
            if (ReferenceEquals(actionName, null)) throw new ArgumentNullException("actionName");

            var getSelectWorkflowAction = _Browser.FindSessionElementByXPath(string.Format("//tr/td[(text()= '{0}')]/parent::tr/td[1]/input[contains(@id, 'ctl00_Content_gridWorkflowActions_DXSelBtn')]", actionName));

            return getSelectWorkflowAction;
        }

        internal SessionElementScope GetWorkflowRowEditButtonByRoleName(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");

            var workflowRow = GetWorkflowRoleGridRowByRoleName(roleName);
            var getSelectWorkflowEditButton = workflowRow.FindSessionElementByXPath(".//td[3]/a");

            return getSelectWorkflowEditButton;
        }

        internal IList<WorkflowRole> GetWorkflowRoleGridValues()
        {
            if (GetWorkflowRolesGridRows().Count == 0)
            {
                return null;
            }

            var workflowRoles = (
                from worflowGridRoles in GetWorkflowRolesGridRows()
                select worflowGridRoles.FindAllSessionElementsByXPath("td")
                    into workflowRole
                    select new WorkflowRole
                    {
                        Name = workflowRole[WorkflowGridNameIndex].Text,
                        IsActive = workflowRole[WorkflowGridIsActiveIndex].InnerHTML.Contains("i_checked", StringComparison.OrdinalIgnoreCase)
                    })
                .ToList();

            return workflowRoles;
        }

        internal void CreateWorkflowRole(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");

            GetAddNewButton().Click();
            GetRoleNameTextBox().FillInWith(roleName);
            GetSaveRoleButton().Click();
        }

        internal void ActivateWorkflowRole(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");

            GetWorkflowRowEditButtonByRoleName(roleName).Click();
            GetIsActiveCheckBox().SetCheckBoxState(true);
            GetSaveRoleButton().Click();
        }

        internal void AssignAllWorkflowActions(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName"); 

            GetWorkflowRoleGridRowByRoleName(roleName).Click();
            GetSelectAllCheckBox().Click();
            GetUpdateButton().Click();
        }

        internal void RemoveWorkflowAction(string actionName, string roleName)
        {
            if (String.IsNullOrWhiteSpace(actionName)) throw new ArgumentNullException("actionName");
            if (String.IsNullOrWhiteSpace(roleName))   throw new ArgumentNullException("roleName"); 

            GetWorkflowRoleGridRowByRoleName(roleName).Click();
            GetSelectWorkflowAction(actionName).Click();
            GetUpdateButton().Click();
        }

        internal string GetWorkflowRoleActionStatus(string roleName, string actionName)
        {
            if (String.IsNullOrWhiteSpace(roleName))   throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(actionName)) throw new ArgumentNullException("actionName"); 

            var actionStatus = GetSelectWorkflowAction(actionName).GetAttribute("checked");
            
            return actionStatus;
        }

        public void DeActivateWorkflowRole(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");

            GetWorkflowRowEditButtonByRoleName(roleName).Click();
            GetIsActiveCheckBox().SetCheckBoxState(false);
            GetSaveRoleButton().Click();
        }
    }
}

