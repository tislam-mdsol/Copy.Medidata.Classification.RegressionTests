using System;
using System.Linq;
using System.Security.Permissions;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveArchitectExecuteAmendmentMigrationPlanPage
    {
        private readonly BrowserSession _Session;

        internal RaveArchitectExecuteAmendmentMigrationPlanPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Session = session;
        }

        private SessionElementScope GetMigrationModeRadioButton()
        {
            var migrationModeRadioButton = _Session.FindSessionElementById("_ctl0_Content_MigrationStepOptions1_rblMigrationMode_1");

            return migrationModeRadioButton;
        }

        private SessionElementScope GetSelectAllSubjectsLink()
        {
            var selectAllSubjectsLink = _Session.FindSessionElementById("_ctl0_Content_MigrationStepOptions1_dgSelect__ctl1_lbUpdate");

            return selectAllSubjectsLink;
        }

        private SessionElementScope GetMigrateLink()
        {
            var migrateLink = _Session.FindSessionElementById("_ctl0_Content_MigrationStepOptions1_buttonBar_buttonMigrate_lb_buttonMigrate");

            return migrateLink;
        }

        private SessionElementScope GetMigrationSummary()
        {
            var migrationSummary = _Session.FindSessionElementById("_ctl0_Content_valSummaryAM2");

            return migrationSummary;
        }

        private SessionElementScope GetMigrationStatusLink()
        {
            var migrationSummary     = GetMigrationSummary();

            var migrationStatusLinks = migrationSummary.FindAllSessionElementsByXPath(".//a");

            var migrationStatusLink  = migrationStatusLinks.FirstOrDefault();

            return migrationStatusLink;
        }

        private string GetJobId()
        {
            var jobIdElement = _Session.FindSessionElementById("_ctl0_Content_MigrationStepOptions1_MigrationStepScheduler1_lblJobID");

            var jobId = jobIdElement.Text;

            return jobId;
        }

        private SessionElementScope GetJobIdFilterTextBox()
        {
            var jobIdFilterTextBox = _Session.FindSessionElementById("_ctl0_Content_MigrationResults1_txtJobIdFilter");

            return jobIdFilterTextBox;
        }

        private SessionElementScope GetJobStatusFilterSelectList()
        {
            var jobStatusFilterSelectList = _Session.FindSessionElementById("_ctl0_Content_MigrationResults1_ddlStatusFilter");

            return jobStatusFilterSelectList;
        }

        private SessionElementScope GetJobFilterLink()
        {
            var jobFilterLink = _Session.FindSessionElementById("_ctl0_Content_MigrationResults1_lbFilter");

            return jobFilterLink;
        }

        private void WaitForMigrationToBeScheduled()
        {
            var options = Config.GetDefaultCoypuOptions();
            
            _Session.TryUntil(
                () => GetMigrationSummaryMessage(),
                () => !String.IsNullOrWhiteSpace(GetMigrationSummaryMessage()),
                options.RetryInterval,
                options);
        }

        private void WaitForMigrationToComplete()
        {
            var jobId = GetJobId();

            var migrationStatusLink = GetMigrationStatusLink();
            migrationStatusLink.Click();

            _Session.WaitUntilElementExists(GetJobIdFilterTextBox);

            GetJobIdFilterTextBox().FillInWith(jobId);
            GetJobStatusFilterSelectList().SelectOptionAlphanumericOnly("Complete");
            GetJobFilterLink().Click();

            var options = new Options
            {
                Timeout = TimeSpan.FromSeconds(60),
                RetryInterval = TimeSpan.FromSeconds(5)
            };

            _Session.TryUntil(
                () => GetJobFilterLink().Click(),
                () => String.IsNullOrWhiteSpace(GetMigrationSummaryMessage()),
                options.RetryInterval,
                options);
        }

        internal bool ExecuteMigrationPlan()
        {
            GetMigrationModeRadioButton().SetCheckBoxState(true);

            _Session.WaitUntilElementExists(GetSelectAllSubjectsLink);

            GetSelectAllSubjectsLink().Click();

            GetMigrateLink().Click();
            
            WaitForMigrationToBeScheduled();
            
            var migrationStatusLink = GetMigrationStatusLink();
            
            var migrationStarted = !ReferenceEquals(migrationStatusLink, null);

            if (migrationStarted)
            {
                WaitForMigrationToComplete();
            }

            return migrationStarted;
        }

        internal string GetMigrationSummaryMessage()
        {
            if (!GetMigrationSummary().Exists(Config.ExistsOptions))
                return String.Empty;

            var migrationSummary = GetMigrationSummary();

            return migrationSummary.Text;
        }
    }
}
