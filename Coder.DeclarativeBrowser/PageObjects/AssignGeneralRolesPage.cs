using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class AssignGeneralRolesPage
    {
        private readonly BrowserSession _Browser;
        private const string            PageName                    = "Assign General Role";
        private const int               GeneralRoleGridLoginIdIndex = 0;
        private const int               GeneralRoleStudyIndex       = 1;
        private const int               GeneralRoleDenyAccessIndex  = 2;
        private const int               GeneralRoleRoleNameIndex    = 3;

        internal AssignGeneralRolesPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser"); 

            _Browser = browser;
        }

        internal bool OnAssigGeneralRolesPage()
        {
            var title = _Browser.Title;

            return title.Equals(PageName);
        }

        internal void GoTo()
        {
            if (!OnAssigGeneralRolesPage())
            {
                _Browser.GoToAdminPage(PageName);
            }
        }

        internal SessionElementScope GetAssignGeneralRoleGrid()
        {
            var assignGeneralRoleGrid = _Browser.FindSessionElementById("ctl00_Content_gridUsrObjRole_DXMainTable");

            return assignGeneralRoleGrid;
        }

        internal IList<SessionElementScope> GetAssignGeneralRoleGridRows()
        {
            var assignGeneralRoleGridRows = GetAssignGeneralRoleGrid().FindAllSessionElementsByXPath("tbody/tr[not(contains(@id,\"HeadersRow\")) and not(contains(@id,\"FooterRow\"))]");

            return assignGeneralRoleGridRows;
        }

        internal SessionElementScope GetSecurityModuleDropDownList()
        {
            var selectStudy = _Browser.FindSessionElementById("ctl00_Content_DdlModules");

            return selectStudy;
        }

        internal SessionElementScope GetSegmentDropDownList()
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
            var addnewbutton = _Browser.FindSessionElementById("ctl00_Content_gridUsrObjRole_FooterRow_LnkAddNewgridUsrObjRole"); 

            return addnewbutton;
        }

        internal SessionElementScope GetLogInTextBox()
        {
            var logInTextBox = _Browser.FindSessionElementById("ctl00_Content_gridUsrObjRole_DXEditor0_I");

            return logInTextBox;
        }

        internal SessionElementScope GetRoleNameTextBox()
        {
            var getRoleNameTextBox = _Browser.FindSessionElementById("ctl00_Content_gridUsrObjRole_DXEditor3_I");

            return getRoleNameTextBox;
        }

        internal SessionElementScope GetRoleNameTextboxTd(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName"); 

            var getSelectRoleName = GetAssignGeneralRoleGrid().FindSessionElementByXPath(string.Format("//td[contains(@id, 'ctl00_Content_gridUsrObjRole_DXEditor') and contains(@id, 'LB') and (text()= '{0}')]", roleName));

            return getSelectRoleName;
        }

        internal SessionElementScope GetAssignRoleUpdateButton()
        {
            var assignRoleUpdateButton = GetAssignGeneralRoleGrid().FindSessionElementByXPath("//tr[@id='ctl00_Content_gridUsrObjRole_DXEditingRow']/td/img[@title='Update']");

            return assignRoleUpdateButton;
        }

        internal SessionElementScope GetAssignRoleEditButton(string roleName, string segment, string loginId)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(segment))  throw new ArgumentNullException("segment");
            if (String.IsNullOrWhiteSpace(loginId))  throw new ArgumentNullException("loginId"); 
            
            var assignRoleEditButton = _Browser.FindSessionElementByXPath(String.Format("//tr[contains(@id, 'ctl00_Content_gridUsrObjWflRole_DXDataRow') and td[text()= 'TEST'] and td[text()= 'All']  and td[contains(text(), 'coder15')]]/td/a/b/i[contains(@style, 'edit')]", roleName, segment, loginId));
            
            return assignRoleEditButton;
        }

        internal SessionElementScope GetAssignRoleDeleteButton(string roleName, string segment, string loginId)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(segment))  throw new ArgumentNullException("segment");
            if (String.IsNullOrWhiteSpace(loginId))  throw new ArgumentNullException("loginId"); 

            var getAssignRoleDeleteButton = _Browser.FindSessionElementByXPath(String.Format("//tr[contains(@id, 'ctl00_Content_gridUsrObjWflRole_DXDataRow') and td[text()= '{0}'] and td[text()= '{1}']  and td[contains(text(), '{2}')]]/td/a/b/i[contains(@style, 'trash')]", roleName, segment, loginId));

            return getAssignRoleDeleteButton;
        }

        internal SessionElementScope GetDenyAccessCheckBox()
        {
            var getDenyAccessCheckBox = GetAssignGeneralRoleGrid().FindSessionElementByXPath("//tr[@id='ctl00_Content_gridUsrObjWflRole_DXEditingRow']/td[@class = 'dxgvInlineEditCell_Main_Theme dxgv']/span[@class = 'dxeBase_Main_Theme']/input[@type ='checkbox']");

            return getDenyAccessCheckBox;
        }

        internal SessionElementScope GetLoginIdTextboxTd(string loginId)
        {
            if (String.IsNullOrWhiteSpace(loginId)) throw new ArgumentNullException("loginId");

            var getSelectLoginId = _Browser.FindSessionElementByXPath(string.Format("//td[contains(@id, 'ctl00_Content_gridUsrObjRole_DXEditor') and contains(@id, 'LB') and contains(text()[contains(.,'{0}')], '{0}')]", loginId.ToLower()));

            return getSelectLoginId;
        }

        internal SessionElementScope GetTypeTextBox()
        {
            var getStudyTextBox = _Browser.FindSessionElementById("ctl00_Content_gridUsrObjRole_DXEditor1_I");

            return getStudyTextBox;
        }

        internal SessionElementScope GetTypeTextboxTd(string segment)
        {
            if (String.IsNullOrWhiteSpace(segment)) throw new ArgumentNullException("segment"); 

            var selectStudyId = _Browser.FindSessionElementByXPath(string.Format("//td[contains(@id, 'ctl00_Content_gridUsrObjRole_DXEditor') and contains(@id, 'LB') and (text()= '{0}')]", segment));

            return selectStudyId;
        }

        internal SessionElementScope GetSearchButton()
        {
            var searchButton = _Browser.FindSessionElementById("ctl00_Content_LnkBtnSearch");

            return searchButton;
        }

        private SessionElementScope GetLoadingIndicator()
        {
            var loadingIndicator = _Browser.FindSessionElementByXPath("//*[contains(@id, '_LPV')]");

            return loadingIndicator;
        }

        internal IList<AssignedGeneralRole> GetAssignGeneralRoleGridValues()
        {
            if (GetAssignGeneralRoleGridRows().Count == 0)
            {
                return null;
            }

            var assignGeneralRoleGridValues = (
                from gridRows in GetAssignGeneralRoleGridRows()
                select gridRows.FindAllSessionElementsByXPath("td")
                    into assignedRoles
                    select new AssignedGeneralRole
                    {
                        LoginId    = assignedRoles[GeneralRoleGridLoginIdIndex].Text,
                        RoleType   = assignedRoles[GeneralRoleStudyIndex].Text,
                        DenyAccess = assignedRoles[GeneralRoleDenyAccessIndex].InnerHTML.Contains("i_checked", StringComparison.OrdinalIgnoreCase),
                        Name       = assignedRoles[GeneralRoleRoleNameIndex].Text
                    })
                .ToList();

            return assignGeneralRoleGridValues;
        }

        private bool IsGeneralRoleAssigned(string roleName, string type, string loginId)
        {
            if (ReferenceEquals(roleName, null))    throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(type))    throw new ArgumentNullException("type");
            if (String.IsNullOrWhiteSpace(loginId)) throw new ArgumentNullException("loginId");

            var assignedGeneralRoles = GetAssignGeneralRoleGridValues();

            var targetGeneralRole = assignedGeneralRoles.FirstOrDefault(x => x.Name      .EqualsIgnoreCase(roleName) &&
                                                                            (x.RoleType.EqualsIgnoreCase  (type    ) || x.RoleType.EqualsIgnoreCase("all")) &&
                                                                             x.LoginId   .Contains        (loginId, StringComparison.OrdinalIgnoreCase) &&
                                                                             x.DenyAccess.Equals          (false   ) );

            return !ReferenceEquals(targetGeneralRole, null);
        }

        internal void AssignGeneralRole(string roleName, string securityModule, string type, string loginId)
        {
            GetSecurityModuleDropDownList().SelectOptionAlphanumericOnly(securityModule);

            if (IsGeneralRoleAssigned(roleName, type, loginId))
            {
                return;
            }

            GetAddNewButton().Click();

            _Browser.SelectDXOption(GetLogInTextBox,    loginId);
            _Browser.SelectDXOption(GetTypeTextBox,     type);
            _Browser.SelectDXOption(GetRoleNameTextBox, roleName);

            GetAssignRoleUpdateButton().Click();

            _Browser.WaitUntilElementDisappears(GetLoadingIndicator);
        }
    }
}
