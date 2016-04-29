using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveArchitectAmendmentManagerPage
    {
        private readonly BrowserSession _Session;

        internal RaveArchitectAmendmentManagerPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Session = session;
        }

        private SessionElementScope GetSourceCRFVersionSelectList()
        {
            var sourceCRFVersionSelectList = _Session.FindSessionElementById("_ctl0_Content_MigrationStepStart1_ddlSimpleSourceVersionId");

            return sourceCRFVersionSelectList;
        }

        private SessionElementScope GetTargetCRFVersionSelectList()
        {
            var targetCRFVersionSelectList = _Session.FindSessionElementById("_ctl0_Content_MigrationStepStart1_ddlSimpleTargetVersionId");

            return targetCRFVersionSelectList;
        }

        private SessionElementScope GetCreatePlanButton()
        {
            var createPlanButton = _Session.FindSessionElementById("_ctl0_Content_MigrationStepStart1_btnGo");

            return createPlanButton;
        }

        private SessionElementScope GetMigrationPlanSummary()
        {
            var migrationPlanSummary = _Session.FindSessionElementById("_ctl0_Content_valSummaryAM2");

            return migrationPlanSummary;
        }
        
        private SessionElementScope GetMigrationPlanGrid()
        {
            var migrationPlanGrid = _Session.FindSessionElementById("_ctl0_Content_MigrationStepStart1_pnlMigrationPlans");

            return migrationPlanGrid;
        }
        
        internal bool CreatePlan(string sourceDraftVersionName, string targetDraftVersionName)
        {
            if (String.IsNullOrWhiteSpace(sourceDraftVersionName)) throw new ArgumentNullException("sourceDraftVersionName");
            if (String.IsNullOrWhiteSpace(targetDraftVersionName)) throw new ArgumentNullException("targetDraftVersionName");

            _Session.WaitUntilElementExists(GetCreatePlanButton);

            var sourceCRFVersionSelectList = GetSourceCRFVersionSelectList();
            var targetCRFVersionSelectList = GetTargetCRFVersionSelectList();
            var createPlanButton           = GetCreatePlanButton();

            sourceCRFVersionSelectList.SelectOptionAlphanumericOnly(sourceDraftVersionName);
            targetCRFVersionSelectList.SelectOptionAlphanumericOnly(targetDraftVersionName);
            createPlanButton.Click();

            _Session.WaitUntilElementExists(GetMigrationPlanGrid);

            var migrationPlanSummaryMessage = GetMigrationPlanSummaryMessage();

            return String.IsNullOrWhiteSpace(migrationPlanSummaryMessage);
        }

        internal string GetMigrationPlanSummaryMessage()
        {
            if (!GetMigrationPlanSummary().Exists(Config.ExistsOptions))
                return String.Empty;

            var migrationPlanSummary = GetMigrationPlanSummary();

            return migrationPlanSummary.Text;
        }
    }
}
