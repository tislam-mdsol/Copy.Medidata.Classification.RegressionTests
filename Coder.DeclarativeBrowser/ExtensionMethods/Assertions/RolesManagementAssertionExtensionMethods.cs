using System;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using Coder.DeclarativeBrowser.Models;
using FluentAssertions;

namespace Coder.DeclarativeBrowser.ExtensionMethods.Assertions
{
    public static class RolesManagementAssertionExtensionMethods
    {
        public static void AssertTheWorkflowRoleIsActive(
            this CoderDeclarativeBrowser browser,
            string roleName)
        {
            if (ReferenceEquals(browser, null))      throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");

            var session                 = browser.Session;
            var createWorkflowRolesPage = session.GetCreateWorkflowRolesPage();

            var workflowRole            = createWorkflowRolesPage
                .GetWorkflowRoleGridValues()
                .FirstOrDefault(row => row.Name.EqualsIgnoreCase(roleName));

            Debug.Assert(workflowRole != null, "should not be null");

            workflowRole.IsActive.Should().BeTrue();

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertTheGeneralRoleIsActive(
            this CoderDeclarativeBrowser browser,
            string roleName,
            string securityModule)
        {
            if (ReferenceEquals(browser, null))            throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(roleName))       throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule"); 

            var session                = browser.Session;
            var createGeneralRolesPage = session.GetCreateGeneralRolesPage();

            var generalRole            = createGeneralRolesPage
                .GetGeneralRoleGridValues()
                .FirstOrDefault(row => row.Name.EqualsIgnoreCase(roleName));

            Debug.Assert(generalRole != null, "should not be null");

            generalRole.IsActive.Should().BeTrue();

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertTheWorkflowRoleIsAssigned(
            this CoderDeclarativeBrowser browser, 
            AssignedWorkflowRole targetAssignedWorkflowRole)
        {
            if (ReferenceEquals(browser, null))                    throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetAssignedWorkflowRole, null)) throw new ArgumentNullException("targetAssignedWorkflowRole");

            var session                      = browser.Session;
            var assignWorkflowPage           = session.GetAssignWorkFlowRolesPage();

            var assignWorkflowRoleGridValues = RetryPolicy.SyncStaleElement.Execute(
                () => assignWorkflowPage.GetAssignWorkflowRoleGridValues());
            
            var sourceAssignedWorkflowRow    = assignWorkflowRoleGridValues
                .FirstOrDefault(row => row.LoginId.Contains(targetAssignedWorkflowRole.LoginId) &&
                              row.Study.EqualsIgnoreCase(targetAssignedWorkflowRole.Study) &&
                              row.Name.EqualsIgnoreCase(targetAssignedWorkflowRole.Name));

            Debug.Assert(sourceAssignedWorkflowRow != null, "should not be null");

            sourceAssignedWorkflowRow.LoginId.Should().Contain(targetAssignedWorkflowRole.LoginId);
            sourceAssignedWorkflowRow.Study.ShouldBeEquivalentTo(targetAssignedWorkflowRole.Study);
            sourceAssignedWorkflowRow.DenyAccess.ShouldBeEquivalentTo(targetAssignedWorkflowRole.DenyAccess);
            sourceAssignedWorkflowRow.Name.ShouldBeEquivalentTo(targetAssignedWorkflowRole.Name);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertTheGeneralRoleIsAssigned(
            this CoderDeclarativeBrowser browser, 
            AssignedGeneralRole targetAssignedGeneralRole)
        {
            if (ReferenceEquals(browser, null))                   throw new ArgumentNullException("browser");
            if (ReferenceEquals(targetAssignedGeneralRole, null)) throw new ArgumentNullException("targetAssignedGeneralRole");

            var session                = browser.Session;
            var assignGeneralRolesPage = session.GetAssignGeneralRolesPage();

            var assignGeneralRoleGridValues = assignGeneralRolesPage.GetAssignGeneralRoleGridValues();
            var sourceAssignedGeneralRow    = assignGeneralRoleGridValues
                .FirstOrDefault(row => row.LoginId.Contains(targetAssignedGeneralRole.LoginId) &&
                              row.RoleType.EqualsIgnoreCase(targetAssignedGeneralRole.RoleType) &&
                              row.Name.EqualsIgnoreCase(targetAssignedGeneralRole.Name));

            Debug.Assert(sourceAssignedGeneralRow != null, "should not be null");

            sourceAssignedGeneralRow.LoginId.Should().Contain(targetAssignedGeneralRole.LoginId);
            sourceAssignedGeneralRow.RoleType.ShouldBeEquivalentTo(targetAssignedGeneralRole.RoleType);
            sourceAssignedGeneralRow.DenyAccess.ShouldBeEquivalentTo(targetAssignedGeneralRole.DenyAccess);
            sourceAssignedGeneralRow.Name.ShouldBeEquivalentTo(targetAssignedGeneralRole.Name);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertTheWorkflowRoleActionIsNotAssigned(
            this CoderDeclarativeBrowser browser, 
            string roleName, 
            string actionName)
        {
            if (ReferenceEquals(browser, null))        throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(roleName))   throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(actionName)) throw new ArgumentNullException("actionName");

            var session = browser.Session;
            var createWorkflowRolesPage = session.GetCreateWorkflowRolesPage();
            
            var actionStatus = createWorkflowRolesPage.GetWorkflowRoleActionStatus(
                roleName  : roleName,
                actionName: actionName);

            actionStatus.Should().BeNullOrWhiteSpace();

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }


        public static void AssertThatTheActionButtonDoNotExist(
            this CoderDeclarativeBrowser browser,
            string verbatim, 
            string actionName)
        {
            if (ReferenceEquals(browser, null))        throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(verbatim))   throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(actionName)) throw new ArgumentNullException("actionName");

            var session = browser.Session;

            var codingTaskPage = session.GetCodingTaskPage();

            codingTaskPage.SelectTaskGridByVerbatimName(verbatim);
            var isActionButtonMissing = codingTaskPage.GetActionButtons(actionName).Missing();

            isActionButtonMissing.Should().BeTrue();

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertTheUserDoesntHaveAccessToReport(
            this CoderDeclarativeBrowser browser,
            string reportName)
        {
            if (ReferenceEquals(browser, null))        throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(reportName)) throw new ArgumentNullException("reportName");

            var session = browser.Session;

            var codingTaskPage = session.GetCodingTaskPage();
            codingTaskPage.GoTo();

            var headerPage = session.GetPageHeader();

            var reportsTab = headerPage.GetReportsTab();
            reportsTab.Hover();
            reportsTab.Click();
            var isReportAvailable = !headerPage.GetReportsMenuItemByName(reportName).Missing();

            isReportAvailable.Should().BeFalse();

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertTheUserDoesntHaveAccessToFunction(
            this CoderDeclarativeBrowser browser,
            string functionName)
        {
            if (ReferenceEquals(browser, null))          throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(functionName)) throw new ArgumentNullException("functionName");

            var session = browser.Session;

            var codingTaskPage = session.GetCodingTaskPage();
            codingTaskPage.GoTo();

            var headerPage = session.GetPageHeader();

            var isAdminLinkAvailable = headerPage.AdminLinkAvailable(functionName);

            isAdminLinkAvailable.Should().BeFalse();

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
    }
}
