using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class AssignWorkFlowRolesPage
    {
        private readonly BrowserSession _Browser;
        private const string            PageName                    = "Assign Workflow Role";
        private const int               WorkflowGridLoginIdIndex    = 0;
        private const int               WorkflowGridStudyIndex      = 1;
        private const int               WorkflowGridDenyAccessIndex = 2;
        private const int               WorkflowGridRoleNameIndex   = 3;

        public AssignWorkFlowRolesPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser"); 

            _Browser = browser;
        }

        internal bool OnAssignWorkflowRolesPage()
        {
            var title = _Browser.Title;

            return title.Equals(PageName);
        }

        internal void GoTo()
        {
            if (!OnAssignWorkflowRolesPage())
            {
                _Browser.GoToAdminPage(PageName);
            }
        }

        internal SessionElementScope GetAssignWorkflowRolesGrid()
        {
            var assignWorkflowRolesGrid = _Browser.FindSessionElementById("ctl00_Content_gridUsrObjWflRole_DXMainTable");

            return assignWorkflowRolesGrid;
        }

        internal IList<SessionElementScope> GetAssignWorkflowRolesGridRows()
        {
            var assignWorkflowGridRows = GetAssignWorkflowRolesGrid().FindAllSessionElementsByXPath("tbody/tr[not(contains(@id,\"HeadersRow\")) and not(contains(@id,\"FooterRow\"))]");

            return assignWorkflowGridRows;
        }

        internal SessionElementScope GetStudyDropDownList()
        {
            var selectStudy = _Browser.FindSessionElementById("ctl00_Content_DdlGrantAccessOn");

            return selectStudy;
        }

        internal SessionElementScope GetLoginDropDownList()
        {
            var selectLogin = _Browser.FindSessionElementById("ctl00_Content_DdlGrantAccessTo");

            return selectLogin;
        }

        internal SessionElementScope GetAddNewButton()
        {
            var addnewbutton = _Browser.FindSessionElementById("ctl00_Content_gridUsrObjWflRole_FooterRow_LnkAddNewgridUsrObjWflRole");

            return addnewbutton;
        }

        internal SessionElementScope GetLogInTextBox()
        {
            var logInTextBox = _Browser.FindSessionElementById("ctl00_Content_gridUsrObjWflRole_DXEditor0_I");

            return logInTextBox;
        }

        internal SessionElementScope GetWorkRoleNameTextBox()
        {
            var getWorkRoleNameTextBox = _Browser.FindSessionElementById("ctl00_Content_gridUsrObjWflRole_DXEditor3_I");

            return getWorkRoleNameTextBox;
        }

        internal SessionElementScope GetWorkRoleNameTextboxTd(string roleName)
        {
            if (ReferenceEquals(roleName, null)) throw new ArgumentNullException("roleName");

            var getSelectWorkRoleName = GetAssignWorkflowRolesGrid().FindSessionElementByXPath(string.Format("//td[contains(@id, 'ctl00_Content_gridUsrObjWflRole_DXEditor') and contains(@id, 'LB') and (text()= '{0}')]", roleName));

            return getSelectWorkRoleName;
        }

        internal SessionElementScope GetAssignRoleUpdateButton()
        {
            var getAssignRoleUpDate = GetAssignWorkflowRolesGrid().FindSessionElementByXPath("//tr[@id='ctl00_Content_gridUsrObjWflRole_DXEditingRow']/td/img[@title='Update']");

            return getAssignRoleUpDate;
        }

        internal SessionElementScope GetAssignRoleEditButton(string roleName, string study, string loginId)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study))    throw new ArgumentNullException("study");
            if (String.IsNullOrWhiteSpace(loginId))  throw new ArgumentNullException("loginId"); 

            var getAssignRoleEditButton = _Browser.FindSessionElementByXPath(String.Format("//tr[contains(@id, 'ctl00_Content_gridUsrObjWflRole_DXDataRow') and td[text()= '{0}'] and td[text()= '{1}']  and td[contains(text(), '{2}')]]/td/a/b/i[contains(@style, 'edit')]", roleName, study, loginId));
            
            return getAssignRoleEditButton;
        }

        internal SessionElementScope GetAssignRoleDeleteButton(string roleName, string study, string loginId)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study))    throw new ArgumentNullException("study");
            if (String.IsNullOrWhiteSpace(loginId))  throw new ArgumentNullException("loginId");

            var getAssignRoleDeleteButton = _Browser.FindSessionElementByXPath(String.Format("//tr[contains(@id, 'ctl00_Content_gridUsrObjWflRole_DXDataRow') and td[text()= '{0}'] and td[text()= '{1}']  and td[contains(text(), '{2}')]]/td/a/b/i[contains(@style, 'trash')]", roleName, study, loginId));

            return getAssignRoleDeleteButton;
        }

        internal SessionElementScope GetDenyAccessCheckBox()
        {
            var getDenyAccessCheckBox = GetAssignWorkflowRolesGrid().FindSessionElementByXPath("//tr[@id='ctl00_Content_gridUsrObjWflRole_DXEditingRow']/td[@class = 'dxgvInlineEditCell_Main_Theme dxgv']/span[@class = 'dxeBase_Main_Theme']/input[@type ='checkbox']");

            return getDenyAccessCheckBox;
        }

        internal SessionElementScope GetLoginIdTextBoxTd(string loginId)
        {
            if (String.IsNullOrWhiteSpace(loginId)) throw new ArgumentNullException("loginId");

            var getSelectLoginId = _Browser.FindSessionElementByXPath(string.Format("//td[contains(@id, 'ctl00_Content_gridUsrObjWflRole_DXEditor') and contains(@id, 'LB') and contains(text(), '{0}')]", loginId));

            return getSelectLoginId;
        }

        internal SessionElementScope GetStudyTextBox()
        {
            var getStudyTextBox = _Browser.FindSessionElementById("ctl00_Content_gridUsrObjWflRole_DXEditor1_I");

            return getStudyTextBox;
        }

        internal SessionElementScope GetStudyTextboxTd(string segment)
        {
            if (String.IsNullOrWhiteSpace(segment)) throw new ArgumentNullException("segment"); 

            var selectStudyId = _Browser.FindSessionElementByXPath(string.Format("//td[contains(@id, 'ctl00_Content_gridUsrObjWflRole_DXEditor1') and contains(@id, 'LB') and (text()= '{0}')]", segment));
           
            return selectStudyId;
        }

        internal IList<AssignedWorkflowRole> GetAssignWorkflowRoleGridValues()
        {
            var assignedWorkflowRoles = GetAssignWorkflowRolesGridRows().ToArray();

            if (assignedWorkflowRoles.Length == 0)
            {
                return null;
            }

            var assignWorkflowRoleGridValues = (
                from gridRows in assignedWorkflowRoles
                select gridRows.FindAllSessionElementsByXPath("td")
                    into assignedRoles
                    select new AssignedWorkflowRole
                    {
                        LoginId          = assignedRoles[WorkflowGridLoginIdIndex].Text,
                        Study            = assignedRoles[WorkflowGridStudyIndex].Text,
                        DenyAccess       = assignedRoles[WorkflowGridDenyAccessIndex].InnerHTML.Contains("i_checked", StringComparison.OrdinalIgnoreCase),
                        Name = assignedRoles[WorkflowGridRoleNameIndex].Text
                    })
                .ToList();

            return assignWorkflowRoleGridValues;
        }
        
        private bool IsWorkflowRoleAssigned(string roleName, string study, string loginId)
        {
            if (ReferenceEquals(roleName, null))    throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study))   throw new ArgumentNullException("study");
            if (String.IsNullOrWhiteSpace(loginId)) throw new ArgumentNullException("loginId");

            var assignedWorkflowRoles = GetAssignWorkflowRoleGridValues();

            var targetWorkflowRole = assignedWorkflowRoles.FirstOrDefault(x => x.Name      .EqualsIgnoreCase(roleName) &&
                                                                              (x.Study     .EqualsIgnoreCase(study   ) || x.Study.EqualsIgnoreCase("all")) &&
                                                                               x.LoginId   .Contains        (loginId, StringComparison.OrdinalIgnoreCase ) &&
                                                                               x.DenyAccess.Equals          (false   ) );

            return !ReferenceEquals(targetWorkflowRole, null);
        }

        internal SessionElementScope GetSearchButton()
        {
            var searchButton = _Browser.FindSessionElementById("ctl00_Content_LnkBtnSearch");

            return searchButton;
        }

        internal void AssignWorkFlowRole(string roleName, string study, string loginId)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study))    throw new ArgumentNullException("study");
            if (String.IsNullOrWhiteSpace(loginId))  throw new ArgumentNullException("loginId");

            if (IsWorkflowRoleAssigned(roleName, study, loginId))
            {
                return;
            }

            GetAddNewButton().Click();
            
            _Browser.SelectDXOption(GetLogInTextBox,        loginId);
            _Browser.SelectDXOption(GetStudyTextBox,        study);
            _Browser.SelectDXOption(GetWorkRoleNameTextBox, roleName);

            GetAssignRoleUpdateButton().Click();
        }

        public void DenyAccessToWorkflowRole(string roleName, string study, string loginId)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study))    throw new ArgumentNullException("study");
            if (String.IsNullOrWhiteSpace(loginId))  throw new ArgumentNullException("loginId"); 

            GetAssignRoleEditButton(
                roleName: roleName, 
                study   : study, 
                loginId : loginId)
                .Click();

            GetDenyAccessCheckBox().Click();
            GetAssignRoleUpdateButton().Click();
        }

        public void DeleteWorkflowRole(string roleName, string study, string loginId)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study))    throw new ArgumentNullException("study");
            if (String.IsNullOrWhiteSpace(loginId))  throw new ArgumentNullException("loginId"); 

            GetAssignRoleDeleteButton(
                roleName: roleName, 
                study   : study, 
                loginId : loginId)
                .Click();

            _Browser.AcceptModalDialog();
        }
    }
}
