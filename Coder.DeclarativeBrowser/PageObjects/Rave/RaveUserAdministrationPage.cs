//@author:smalik
using System;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using System.Linq;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveUserAdministrationPage
    {
        private readonly BrowserSession _Browser;

        private readonly String _AuthenticatorDDLValueInternal = "Internal";
      
        private readonly String _UserGroupOption               = "All Modules";

        private const int _LogIn      = 0;
        private const int _LastName   = 1;
        private const int _FirstName  = 2;
        private const int _UserGroup  = 3;
        private const int _Email      = 4;
        private const int _Activated  = 5;
        private const int _RightArrow = 6;

        internal RaveUserAdministrationPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        private void SearchforLogInUser(String userName)
        {
            if (ReferenceEquals(userName, null)) throw new ArgumentNullException("userName");

            GetUserNameTextBox().FillInWith(userName);

            GetAuthenticatorDDL().SelectOption(_AuthenticatorDDLValueInternal);

            GetUserSearchLink().Click();

            GetUserRightArrow(userName).Click();
        }

        internal void GetAccessToConfigModule(String userName)
        {
            if (ReferenceEquals(userName, null)) throw new ArgumentNullException("userName");

            SearchforLogInUser(userName);
            GetUserGroup().SelectOption(_UserGroupOption);
            GetUpdateLink().Click();
        }

        internal void AssignUserToStudy(String userName, String roleName, String study, String projectEnvironment)
        {
            if (String.IsNullOrEmpty(userName))           throw new ArgumentNullException("userName");
            if (String.IsNullOrEmpty(roleName))           throw new ArgumentNullException("roleName");
            if (String.IsNullOrEmpty(study))              throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(projectEnvironment)) throw new ArgumentNullException("projectEnvironment");

            SearchforLogInUser(userName);
            AssignStudyToUser(roleName, study, projectEnvironment);
        }

        private void AssignStudyToUser(String role, String study, String projectEnvironment)

        {
            if (String.IsNullOrWhiteSpace(study))         throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(projectEnvironment)) throw new ArgumentNullException("projectEnvironment");
            if (String.IsNullOrEmpty(role))               throw new ArgumentNullException("role");

            _Browser.MaximiseWindow();
            GetAssignToStudyLink().Click();
            GetAssignToStudyLink().Click();                     

            GetRoleDDLOption().SelectOption(role);                     
            GetProjectDDLOption().SelectOption(study);
            GetProjectEnvironmentDDL().SelectOption(projectEnvironment);

            GetAssignUserLink().Click();
            _Browser.ResizeTo(Config.ScreenWidth, Config.ScreenHeight);
        }

        private SessionElementScope GetUserNameTextBox()
        {
            var userNameTextBox = _Browser.FindSessionElementById("_ctl0_Content_LoginBox");

            return userNameTextBox;
        }

        private SessionElementScope GetAuthenticatorDDL()
        {
            var authenticatorDDL = _Browser.FindSessionElementById("_ctl0_Content_AuthenticatorDDL");

            return authenticatorDDL;
        }

        private SessionElementScope GetUserSearchLink()
        {
            var userSearchLink = _Browser.FindSessionElementById("_ctl0_Content_SearchButtonLnk");

            return userSearchLink;
        }

        private IList<SessionElementScope> GetUserDetailsGridDataRows()
        {
            var userDetailsGridRows =
                GetUserDetailsGrid().FindAllSessionElementsByXPath("tbody/tr");

            return userDetailsGridRows;
        }

        private SessionElementScope GetUserDetailsGrid()
        {
            var userDetailsGrid = _Browser.FindSessionElementById("_ctl0_Content_UserGrid");

            return userDetailsGrid;
        }


        private SessionElementScope GetUserRightArrow(String userName)
        {
            if (ReferenceEquals(userName, null)) throw new ArgumentNullException("userName");

            var userDetailsGridRows = GetUserDetailsGridDataRows();

            if (!userDetailsGridRows.Any())
            {
                throw new MissingHtmlException(String.Format("No search results for user {0}", userName));
            }

            var userRow = userDetailsGridRows.FirstOrDefault(
                x => x.FindAllSessionElementsByXPath("td")[_LogIn].Text.Equals(userName, StringComparison.OrdinalIgnoreCase));

            if (ReferenceEquals(userRow, null))
            { throw new MissingHtmlException(String.Format("Cannot find row for user {0}", userName)); }

            var userColumns = userRow.FindAllSessionElementsByXPath("td");
            var userRightArrow = userColumns[_RightArrow].FindSessionElementByXPath("a");

            return userRightArrow;
        }

        private SessionElementScope GetUserGroup()
        {
            var userGroupDDL = _Browser.FindSessionElementById("_ctl0_Content_UserGrpDDL");

            return userGroupDDL;
        }

        private SessionElementScope GetUpdateLink()
        {
            var updateLink = _Browser.FindSessionElementById("_ctl0_Content_SaveLnkBtn");

            return updateLink;
        }

        private SessionElementScope GetAssignToStudyLink()
        {
            var assignToStudyLink = _Browser.FindSessionElementById("_ctl0_Content_UserSiteWizard1_AssignStudyLnkBtn");

            return assignToStudyLink;
        }

        private SessionElementScope GetRoleDDLOption()
        {
            var roleDDL = _Browser.FindSessionElementById("_ctl0_Content_UserSiteWizard1_SelectRoleDDL");

            return roleDDL;
        }

        private SessionElementScope GetProjectDDLOption()
        {
            var projectDDL = _Browser.FindSessionElementById("_ctl0_Content_UserSiteWizard1_ProjectDDL");

            return projectDDL;
        }

        private SessionElementScope GetProjectEnvironmentDDL()
        {
            var projectEnvironmentDDL = _Browser.FindSessionElementById("_ctl0_Content_UserSiteWizard1_AuxStudiesDDL");

            return projectEnvironmentDDL;
        }

        private SessionElementScope GetAssignUserLink()
        {
            var assignUserLink = _Browser.FindSessionElementById("_ctl0_Content_UserSiteWizard1_AssignUserLnk");

            return assignUserLink;
        }
    }
}
