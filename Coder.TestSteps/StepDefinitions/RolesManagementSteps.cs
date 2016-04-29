using System;
using System.Reflection;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.Models;
using FluentAssertions;
using TechTalk.SpecFlow;

namespace Coder.RegressionTests.StepDefinitions
{
    [Binding]
    public class RolesManagementSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext             _StepContext;

        public RolesManagementSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser     = _StepContext.Browser;
        }

        [Given(@"an admin user")]
        public void GivenAnAdminUser()
        {
            _StepContext.SetSourceSystemApplicationContext();
        }

        [When(@"creating and activating a new workflow role called ""(.*)""")]
        public void WhenCreatingAndActivatingANewWorkflowRoleCalled(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName"); 

            _Browser.CreateAndActivateWorkFlowRole(roleName);
        }

        [When(@"assigning workflow role ""(.*)"" for ""(.*)"" study")]
        public void WhenAssigningWorkflowRoleForStudy(string roleName, string study)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study))    throw new ArgumentNullException("study"); 

            _Browser.AssignWorkflowRole(
                roleName: roleName, 
                study   : study,
                loginId : _StepContext.User);
        }

        [When(@"assigning ""(.*)"" General Role ""(.*)"" for ""(.*)"" type")]
        public void WhenAssigningGeneralRoleForType(string securityModule, string roleName, string type)
        {
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule");
            if (String.IsNullOrWhiteSpace(roleName))       throw new ArgumentNullException("roleName");

            _Browser.AssignGeneralRole(
                roleName      : roleName,
                securityModule: securityModule,
                type          : type,
                loginId       : _StepContext.User);
        }

        [When(@"assign all worflow role actions to ""(.*)""")]
        public void WhenAssignAllWorflowRoleActionsTo(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName"); 

            _Browser.AssignAllWorkflowRoleActions(roleName);
        }

        [When(@"removing the assigned action ""(.*)"" from Workflow Role ""(.*)""")]
        public void WhenRemovingTheAssignedActionFromWorkflowRole(string actionName, string roleName)
        {
            if (String.IsNullOrWhiteSpace(actionName)) throw new ArgumentNullException("actionName");
            if (String.IsNullOrWhiteSpace(roleName))   throw new ArgumentNullException("roleName"); 

            _Browser.RemoveWorkflowAction(
                actionName: actionName, 
                roleName  : roleName);
        }

        [When(@"deactivating Workflow Role ""(.*)""")]
        public void WhenDeactivatingWorkflowRole(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName"); 

            _Browser.DeactivateWorkflowRole(roleName);
        }

        [When(@"removing the assigned Actions from workflow role ""(.*)""")]
        public void WhenRemovingTheAssignedActionsFromWorkflowRole(string roleName, Table table)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (ReferenceEquals(table, null))        throw new ArgumentNullException("table");

            for (var i = 0; i < table.RowCount; i++)
        {
                var actionName = table.Rows[i]["Actions"];

                _Browser.RemoveWorkflowAction(
                    actionName: actionName,
                    roleName  : roleName);
        }
        }

        [When(@"denying access to Workflow Role ""(.*)"" for ""(.*)"" study")]
        public void WhenDenyingAccessToWorkflowRoleForSegments(string roleName, string study)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study))    throw new ArgumentNullException("study"); 

            _Browser.DenyAccessToWorkFlowRole(
                roleName: roleName, 
                study   : study, 
                loginId : _StepContext.User);
        }

        [When(@"removing Workflow Role ""(.*)"" for ""(.*)"" study")]
        public void WhenRemovingWorkflowRoleForStudy(string roleName, string study)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study))    throw new ArgumentNullException("study"); 

            _Browser.DeleteWorkFlowRole(
                roleName: roleName, 
                study   : study, 
                loginId : _StepContext.User);
        }

        [When(@"creating and activating a ""(.*)"" role called ""(.*)""")]
        public void WhenCreatingAndActivatingARoleCalled(string securityModule, string roleName)
        {
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule");
            if (String.IsNullOrWhiteSpace(roleName))       throw new ArgumentNullException("roleName");

            _Browser.CreateAndActivateGeneralRole(
                roleName      : roleName,
                securityModule: securityModule);
        }

        [When(@"removing the assigned Actions from ""(.*)"" Role ""(.*)""")]
        public void WhenRemovingTheAssignedActionsFromRole(string securityModule, string roleName, Table actions)
        {
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule");
            if (String.IsNullOrWhiteSpace(roleName))       throw new ArgumentNullException("roleName"); 
            if (ReferenceEquals(actions, null))            throw new ArgumentNullException("actions");

            _Browser.AssignAllGeneralRoleActions(securityModule, roleName);

            for (var i = 0; i < actions.RowCount; i++)
            {
                var actionName = actions.Rows[i]["Actions"];

                _Browser.RemoveGeneralRoleAction(
                    roleName      : roleName,
                    securityModule: securityModule,
                    actionName    : actionName);
            }
        }

        [Then(@"the workflow role ""(.*)"" is active")]
        public void ThenTheWorkflowRoleIsActive(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName"); 

            _Browser.AssertTheWorkflowRoleIsActive(roleName);
        }

        [Then(@"the ""(.*)"" role ""(.*)"" is active")]
        public void ThenTheRoleIsActive(string securityModule, string roleName)
        {
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule");
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");

            _Browser.AssertTheGeneralRoleIsActive(
                roleName      : roleName,
                securityModule: securityModule);
        }

        [Then(@"the workflow role ""(.*)"" for study ""(.*)"" is assigned")]
        public void ThenTheWorkflowRoleForStudyIsAssigned(string roleName, string study)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study))    throw new ArgumentNullException("study");

            var assignedWorkflowRole = GetAssignedWorkflowRole(
                roleName  : roleName,
                study     : study,
                denyAccess: false);

            _Browser.AssertTheWorkflowRoleIsAssigned(assignedWorkflowRole);
        }

        [Then(@"the ""(.*)"" General Role ""(.*)"" for type ""(.*)"" is assigned")]
        public void ThenTheGeneralRoleForTypeIsAssigned(string securityModule, string roleName, string roleType)
        {
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule"); 
            if (String.IsNullOrWhiteSpace(roleName))       throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(roleType))       throw new ArgumentNullException("roleType");

            var assignedGeneralRole = GetAssignedGeneralRole(
                roleName  : roleName,
                roleType  : roleType,
                denyAccess: false);

            _Browser.AssertTheGeneralRoleIsAssigned(assignedGeneralRole);
        }

        [Then(@"the following ""(.*)"" are not assigned to ""(.*)""")]
        public void ThenTheFollowingAreNotAssignedTo(string actionName, string roleName)
        {
            if (String.IsNullOrWhiteSpace(actionName)) throw new ArgumentNullException("actionName");
            if (String.IsNullOrWhiteSpace(roleName))   throw new ArgumentNullException("roleName");

            _Browser.AssertTheWorkflowRoleActionIsNotAssigned(
                roleName  : roleName,
                actionName: actionName);
        }

        [Then(@"the user is unable to perform the following Task Actions for the task ""(.*)""")]
        public void ThenTheUserIsUnableToPerformTheFollowingTaskActionsForTheTask(string verbatim, Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            for (var i = 0; i < table.RowCount; i++)
            {
                var actionName = table.Rows[i]["Actions"];

                _Browser.AssertThatTheActionButtonDoNotExist(
                    verbatim  : verbatim,
                    actionName: actionName);
            }
        }

        [Then(@"the user will not have access to the following reports")]
        public void ThenTheUserWillNotHaveAccessToTheFollowingReports(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            for (var i = 0; i < table.RowCount; i++)
            {
                var reportName = table.Rows[i]["Reports"];

                _Browser.AssertTheUserDoesntHaveAccessToReport(reportName);
        }
        }

        [Then(@"the user will not have access to the following functions")]
        public void ThenTheUserWillNotHaveAccessToTheFollowingFunctions(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            for (var i = 0; i < table.RowCount; i++)
            {
                var functionName = table.Rows[i]["Functions"];

                _Browser.AssertTheUserDoesntHaveAccessToFunction(functionName);
            }
            }


        private AssignedWorkflowRole GetAssignedWorkflowRole(string roleName, string study, bool denyAccess)
        {
            var assignedWorkflowRole = new AssignedWorkflowRole
            {
                LoginId    = _StepContext.User,
                Study      = study,
                Name       = roleName,
                DenyAccess = denyAccess
            };

            return assignedWorkflowRole;
        }

        private AssignedGeneralRole GetAssignedGeneralRole(string roleName, string roleType, bool denyAccess)
        {
            var assignedGeneralRole = new AssignedGeneralRole
        {
                LoginId    = _StepContext.User,
                RoleType   = roleType,
                Name       = roleName,
                DenyAccess = denyAccess
            };

            return assignedGeneralRole;
        }
    }
}