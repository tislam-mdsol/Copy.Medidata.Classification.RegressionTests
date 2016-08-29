using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.CoderConfiguration;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coder.DeclarativeBrowser.PageObjects;
using Coder.DeclarativeBrowser.PageObjects.Administration;
using Coder.DeclarativeBrowser.PageObjects.Reports;
using Coypu;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.DeclarativeBrowser.PageObjects.Rave;


namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    internal static class BrowserSessionExtensionMethods
    {
        internal static TaskPageAssigmentsTab GetTaskPageAssigmentsTab(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var taskPageAssigmentsTab = new TaskPageAssigmentsTab(session);

            return taskPageAssigmentsTab;
        }

        internal static TaskPageCodingHistoryTab GetTaskPageCodingHistoryTab(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var taskPageCodingHistoryTab = new TaskPageCodingHistoryTab(session);

            return taskPageCodingHistoryTab;
        }

        internal static TaskPageQueryHistoryTab GetTaskPageQueryHistoryTab(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var taskPageQueryHistoryTab = new TaskPageQueryHistoryTab(session);

            return taskPageQueryHistoryTab;
        }

        internal static TaskPageSourceTermTab GetTaskPageSourceTermTab(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var taskPageSourceTermTab = new TaskPageSourceTermTab(session);

            return taskPageSourceTermTab;
        }

        internal static TaskPagePropertiesTab GetTaskPagePropertiesTab(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var taskPagePropertiesTab = new TaskPagePropertiesTab(session);

            return taskPagePropertiesTab;
        }

        internal static AdminConfigurationManagementPage GetAdminConfigurationManagementPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var adminConfigurationManagementPage = new AdminConfigurationManagementPage(session);

            return adminConfigurationManagementPage;
        }

        internal static CodingCleanupPage GetCodingCleanupPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var codingCleanupPage = new CodingCleanupPage(session);

            return codingCleanupPage;
        }

        internal static CodingHistoryReportPage GetCodingHistoryReportPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var codingHistoryReportPage = new CodingHistoryReportPage(session);

            codingHistoryReportPage.GoTo();

            return codingHistoryReportPage;
        }

        internal static CodingDecisionsReportPage GetCodingDecisionsReportPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var codingDecisionsReportPage = new CodingDecisionsReportPage(session);

            codingDecisionsReportPage.GoTo();

            return codingDecisionsReportPage;
        }

        internal static IngredientReportPage GetIngredientReportPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var ingredientReportPage = new IngredientReportPage(session);

            return ingredientReportPage;
        }

        internal static StudyReportPage GetStudyReportPage(this BrowserSession Session, string descriptionText)
        {
            if (ReferenceEquals(Session, null))         throw new ArgumentNullException(nameof(Session));
            if (ReferenceEquals(descriptionText, null)) throw new ArgumentNullException(nameof(descriptionText));

            var mainReportPage  = Session.GetMainReportCoderPage();
            mainReportPage.SelectStudyReportViewLink(descriptionText);
           
            var studyReportPage = new StudyReportPage(Session);

            return studyReportPage;
        }

        internal static CreateWorkflowRolesPage GetCreateWorkflowRolesPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var createWorkflowRolesPage = new CreateWorkflowRolesPage(session);

            createWorkflowRolesPage.GoTo();

            return createWorkflowRolesPage;
        }

        internal static CreateGeneralRolesPage GetCreateGeneralRolesPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var createGeneralRolesPage = new CreateGeneralRolesPage(session);

            createGeneralRolesPage.GoTo();

            return createGeneralRolesPage;
        }

        //TODO: Find all references and remove the GoToTaskPage() method that called before this one and rename to OpenCodingTaskPage, to big of a change to handle in this pull
        internal static CodingTaskPage GetCodingTaskPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var codingTaskPage = new CodingTaskPage(session);
            codingTaskPage.LoadPage();

            return codingTaskPage;
        }

        internal static AssignWorkFlowRolesPage GetAssignWorkFlowRolesPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var assignWorkFlowRolesPage = new AssignWorkFlowRolesPage(session);

            assignWorkFlowRolesPage.GoTo();

            return assignWorkFlowRolesPage;
        }

        internal static AssignGeneralRolesPage GetAssignGeneralRolesPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var assignGeneralRolesPage = new AssignGeneralRolesPage(session);

            assignGeneralRolesPage.GoTo();

            return assignGeneralRolesPage;
        }

        internal static BrowserPage GetBrowserPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var browserPage = new BrowserPage(session);

            return browserPage;
        }

        internal static IMedidataLoginPage GetIMedidataLoginPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var loginPage = new IMedidataLoginPage(session);

            return loginPage;
        }

        internal static RaveLoginPage GetRaveLoginPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var loginPage = new RaveLoginPage(session);

            return loginPage;
        }

        internal static CoderLoginPage GetCoderLoginPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var loginPage = new CoderLoginPage(session);

            return loginPage;
        }

        internal static ProjectRegistrationPage GetProjectRegistrationPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var projectRegistrationPage = new ProjectRegistrationPage(session);

            return projectRegistrationPage;
        }

        internal static ImedidataPage GetImedidataPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var iMedidataPage = new ImedidataPage(session);

            return iMedidataPage;
        }

        internal static RaveUserAdministrationPage GetRaveUserAdministrationPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveUserAdministrationPage = new RaveUserAdministrationPage(session);

            return raveUserAdministrationPage;
        }

        internal static RaveConfigurationLoaderPage GetRaveConfigurationLoaderPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveConfigPage = new RaveConfigurationLoaderPage(session);

            return raveConfigPage;
        }

        internal static RaveClinicalViewsPage GetRaveClinicalViewsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveClinicalViewsPage = new RaveClinicalViewsPage(session);

            return raveClinicalViewsPage;
        }

        internal static RaveReportsPage GetRaveReportsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveReportsPage = new RaveReportsPage(session);

            return raveReportsPage;
        }

        internal static RaveReportTypePage GetRaveReportTypePage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveReportsPage = new RaveReportTypePage(session);

            return raveReportsPage;
        }

        internal static RaveClinicalViewSettingsCodingSettingsPage GetRaveClinicalViewSettingsCodingSettingsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveClinicalViewSettingsCodingSettingsPage = new RaveClinicalViewSettingsCodingSettingsPage(session);

            return raveClinicalViewSettingsCodingSettingsPage;
        }

        internal static RaveClinicalViewSettingsPage GetRaveClinicalViewSettingsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveClinicalViewsSettingsPage = new RaveClinicalViewSettingsPage(session);

            return raveClinicalViewsSettingsPage;
        }

        internal static RaveConfigurationOtherSettingsPage GetRaveCoderConfigurationOtherSettingsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveOtherSettingsPage = new RaveConfigurationOtherSettingsPage(session);

            return raveOtherSettingsPage;
        }

        internal static RaveConfigurationOtherSettingsCoderPage GetRaveConfigurationOtherSettingsCoderPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveOtherSettingsPage = new RaveConfigurationOtherSettingsCoderPage(session);

            return raveOtherSettingsPage;
        }

        internal static AdminSegmentManagementPage GetAdminSegmentManagementPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var adminSegmentMangementPage = new AdminSegmentManagementPage(session);

            adminSegmentMangementPage.GoTo();

            return adminSegmentMangementPage;
        }

        internal static AdminMedidataAdminConsolePage GetAdminMedidataAdminConsolePage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var adminMedidataAdminConsolePage = new AdminMedidataAdminConsolePage(session);

            adminMedidataAdminConsolePage.GoTo();

            return adminMedidataAdminConsolePage;
        }

        internal static BrowserPageDictionarySearchTermTab GetBrowserPageDictionarySearchTermTab(
            this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var browserPageDictionarySearchTermTab = new BrowserPageDictionarySearchTermTab(session);

            return browserPageDictionarySearchTermTab;
        }

        internal static CodingReclassificationPage GetCodingReclassificationPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var codingReclassificationPage = new CodingReclassificationPage(session);

            return codingReclassificationPage;
        }

        internal static AdminSynonymPage OpenAdminSynonymPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var adminSynonymPage = new AdminSynonymPage(session);

            adminSynonymPage.GoTo();

            return adminSynonymPage;
        }

        internal static AdminSynonymPage GetAdminSynonymPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var adminSynonymPage = new AdminSynonymPage(session);

            return adminSynonymPage;
        }

        internal static AdminSynonymListPage OpenAdminSynonymListPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var adminSynonymListPage = new AdminSynonymListPage(session);

            return adminSynonymListPage;
        }

        internal static AdminSynonymMigrationPage OpenAdminSynonymMigrationPage(
            this BrowserSession session,
            SynonymList synonymList)
        {
            if (ReferenceEquals(session, null))     throw new ArgumentNullException("session");
            if (ReferenceEquals(synonymList, null)) throw new ArgumentNullException("synonymList");

            var adminSynonymMigrationPage = new AdminSynonymMigrationPage(session);

            adminSynonymMigrationPage.GoTo(synonymList);

            return adminSynonymMigrationPage;
        }

        internal static AdminSynonymDetailsPage OpenAdminSynonymDetailsPage(this BrowserSession session,
            SynonymSearch synonymSearch, bool haltOnEmptyList = true)
        {
            if (ReferenceEquals(session, null))       throw new ArgumentNullException("session");
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            var synonymListPage = session.GetSynonymListPage();

            AdminSynonymDetailsPage adminSynonymDetailsPage = null;

            bool synonymDetailsPageOpened = synonymListPage.SelectSynonymList(synonymSearch);

            if (synonymDetailsPageOpened)
            {
                adminSynonymDetailsPage = new AdminSynonymDetailsPage(session);
            }
            else if (haltOnEmptyList)
            {
                throw new InvalidOperationException("The synonym list is empty.");
            }

            return adminSynonymDetailsPage;
        }

        internal static DictionarySearchPanel GetDictionarySearchPanel(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var dictionarySearchPanel = new DictionarySearchPanel(session);

            return dictionarySearchPanel;
        }

        internal static DictionarySelectionPanel GetDictionarySearchSelection(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var browserPageSelection = new DictionarySelectionPanel(session);

            return browserPageSelection;
        }

        internal static Header GetPageHeader(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var pageHeader = new Header(session);

            return pageHeader;
        }

        internal static RaveHeader GetRaveHeader(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveHeader = new RaveHeader(session);

            return raveHeader;
        }

        internal static RaveNavigation GetRaveNavigation(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveNavigation = new RaveNavigation(session);

            return raveNavigation;
        }

        internal static RaveHomePage GetRaveHomePage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveHomePage = new RaveHomePage(session);

            return raveHomePage;
        }

        internal static RaveStudyPage GetRaveStudyPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveStudyPage = new RaveStudyPage(session);

            return raveStudyPage;
        }

        internal static RaveSitePage GetRaveSitePage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveSitePage = new RaveSitePage(session);

            return raveSitePage;
        }

        internal static RaveAddSubjectPage GetRaveAddSubjectPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveAddSubjectPage = new RaveAddSubjectPage(session);

            return raveAddSubjectPage;
        }

        internal static RaveAdverseEventsPage GetRaveAdverseEventsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveAdverseEventsPage = new RaveAdverseEventsPage(session);

            return raveAdverseEventsPage;
        }

        internal static RaveFormPage GetRaveFormPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveFormPage = new RaveFormPage(session);

            return raveFormPage;
        }

        internal static RaveAuditsPage GetRaveAuditsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveAuditsPage = new RaveAuditsPage(session);

            return raveAuditsPage;
        }
        
        internal static RaveArchitectPage GetRaveArchitectPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectPage = new RaveArchitectPage(session);

            return raveArchitectPage;
        }

        internal static RaveActiveSubjectAdministrationPage GetRaveActiveSubjectAdministrationPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveActiveSubjectAdministrationPageectPage = new RaveActiveSubjectAdministrationPage(session);

            return raveActiveSubjectAdministrationPageectPage;
        }

        internal static RaveArchitectProjectPage GetRaveArchitectProjectPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectProjectPage = new RaveArchitectProjectPage(session);

            return raveArchitectProjectPage;
        }

        internal static RaveArchitectCRFDraftPage GetRaveArchitectCRFDraftPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectCRFDraftPage = new RaveArchitectCRFDraftPage(session);

            return raveArchitectCRFDraftPage;
        }

        internal static RaveArchitectCRFDraftPushPage GetRaveArchitectCRFDraftPushPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var crfPushPage = new RaveArchitectCRFDraftPushPage(session);

            return crfPushPage;
        }

        internal static RaveArchitectAddNewDraftPage GetRaveArchitectAddNewDraftPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectAddNewDraftPage = new RaveArchitectAddNewDraftPage(session);

            return raveArchitectAddNewDraftPage;
        }

        internal static RaveArchitectUploadDraftPage GetRaveArchitectUploadDraftPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectUploadDraftPage = new RaveArchitectUploadDraftPage(session);

            return raveArchitectUploadDraftPage;
        }

        internal static RaveArchitectFormsPage GetRaveArchitectFormsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectFormsPage = new RaveArchitectFormsPage(session);

            return raveArchitectFormsPage;
        }

        internal static RaveArchitectFormPage GetRaveArchitectFormPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectFormPage = new RaveArchitectFormPage(session);

            return raveArchitectFormPage;
        }

        internal static RaveArchitectAmendmentManagerPage GetRaveArchitectAmendmentManagerPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectAmendmentManagerPage = new RaveArchitectAmendmentManagerPage(session);

            return raveArchitectAmendmentManagerPage;
        }

        internal static RaveArchitectExecuteAmendmentMigrationPlanPage GetRaveArchitectExecuteAmendmentMigrationPlanPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectExecuteAmendmentMigrationPlanPage = new RaveArchitectExecuteAmendmentMigrationPlanPage(session);

            return raveArchitectExecuteAmendmentMigrationPlanPage;
        }

        internal static RaveArchitectCopySourcesPage GetRaveArchitectCopySourcesPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectCopySourcesPage = new RaveArchitectCopySourcesPage(session);

            return raveArchitectCopySourcesPage;
        }

        internal static RaveArchitectCopyDraftWizardPage GetRaveArchitectCopyDraftWizardPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectCopyDraftWizardPage = new RaveArchitectCopyDraftWizardPage(session);

            return raveArchitectCopyDraftWizardPage;
        }
        
        internal static RaveCoderConfigurationPage GetRaveCoderConfigurationPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveCoderConfigurationPage = new RaveCoderConfigurationPage(session);

            return raveCoderConfigurationPage;
        }

        internal static RaveSiteAdministrationPage GetRaveSiteAdministrationPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveSiteAdministrationPage = new RaveSiteAdministrationPage(session);

            return raveSiteAdministrationPage;
        }

        internal static void OpenRaveStudy(this BrowserSession session, RaveNavigationTarget target)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (ReferenceEquals(target, null))               throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(target.StudyName)) throw new ArgumentNullException("target.StudyName");

            string studyName = target.StudyName;

            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.GoToEDCTab(studyName))
            {
                raveNavigation.OpenHomePage();

                var raveHomePage = session.GetRaveHomePage();
                raveHomePage.SearchForStudy(studyName);

                if(!raveNavigation.IsTabAvailable(studyName))
                {
                    raveHomePage.OpenStudy(studyName);
                }
            }
        }

        internal static RaveSitePage OpenRaveSite(this BrowserSession session, RaveNavigationTarget target)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (ReferenceEquals(target, null))               throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(target.StudyName)) throw new ArgumentNullException("target.StudyName");
            if (String.IsNullOrWhiteSpace(target.SiteName))  throw new ArgumentNullException("target.SiteName");

            string studyName = target.StudyName;
            string siteName  = target.SiteName;

            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.GoToEDCTab(siteName))
            {
                session.OpenRaveStudy(target);

                if (raveNavigation.OnTab(studyName))
                {
                    var raveStudyPage = session.GetRaveStudyPage();

                    raveStudyPage.SearchForSite(siteName);
                
                if (!raveNavigation.OnTab(siteName))
                {
                    raveStudyPage.OpenSite(siteName);
                }
            }
            }

            var raveSitePage = session.GetRaveSitePage();

            return raveSitePage;
        }
        
        internal static void OpenRaveSubject(this BrowserSession session, RaveNavigationTarget target)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (ReferenceEquals(target, null))               throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(target.SubjectId)) throw new ArgumentNullException("target.SubjectId");

            string subjectId = target.SubjectId;

            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.GoToEDCTab(subjectId))
            {
                var raveSitePage = session.OpenRaveSite(target);

                raveSitePage.SearchForSubject(subjectId);
                
                if (!raveNavigation.OnTab(subjectId))
                {
                    raveSitePage.OpenSubject(subjectId);
                }
            }
        }

        internal static RaveFormPage OpenRaveForm(this BrowserSession session, RaveNavigationTarget target)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (ReferenceEquals(target, null))               throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(target.FormName))  throw new ArgumentNullException("target.FormName");

            string formName = target.FormName;

            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.GoToEDCTab(formName))
            {
                session.OpenRaveSubject(target);
                
                raveNavigation.OpenFormPage(formName);
            }

            var raveFormPage = session.GetRaveFormPage();

            session.MaximiseWindow();
            raveFormPage.CancelCurrentEdit();
            session.ResizeTo(Config.ScreenWidth, Config.ScreenHeight);

            return raveFormPage;
        }

        internal static RaveClinicalViewsPage OpenRaveClinicalViewsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.OpenClinicalViewsPage())
            {
                session.OpenRaveConfigurationPage();

                raveNavigation.OpenClinicalViewsPage();
            }

            var raveClinicalViewsPage = session.GetRaveClinicalViewsPage();

            return raveClinicalViewsPage;
        }

        internal static RaveClinicalViewSettingsPage OpenRaveClinicalViewSettingsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveNavigation = session.GetRaveNavigation();
            
            if (!raveNavigation.OpenClinicalViewSettingsPage())
            {
                session.OpenRaveConfigurationPage();

                raveNavigation.OpenClinicalViewSettingsPage();
            }

            var raveClinicalViewSettingsPage = session.GetRaveClinicalViewSettingsPage();

            return raveClinicalViewSettingsPage;
            }

        internal static RaveClinicalViewSettingsCodingSettingsPage OpenRaveClinicalViewsCodingSettingsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var clinicalViewSettingsPage = session.OpenRaveClinicalViewSettingsPage();

            clinicalViewSettingsPage.OpenCodingSettings();

            var codingSettingsPage = session.GetRaveClinicalViewSettingsCodingSettingsPage();

            return codingSettingsPage;
        }

        internal static RaveReportsPage OpenRaveReportsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");
            
            var raveNavigation = session.GetRaveNavigation();
                
            if (!raveNavigation.OpenReportsPage())
            {
                raveNavigation.OpenHomePage(); ;

                raveNavigation.OpenReportsPage();
            }
            
            var raveReportsPage = session.GetRaveReportsPage();

            return raveReportsPage;
            }
        
        internal static RaveReportTypePage OpenRaveReportTypePage(this BrowserSession session, string reportType)
            {
            if (ReferenceEquals(session, null))        throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(reportType)) throw new ArgumentNullException("reportType");

            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.GoToEDCTab(reportType))
            {
                var raveReportsPage = session.OpenRaveReportsPage();
                
                raveReportsPage.ChooseReport(reportType);
            }

            var raveReportTypePage = session.GetRaveReportTypePage();

            return raveReportTypePage;
        }

        internal static RaveAdverseEventsPage OpenRaveAdverseEvent(this BrowserSession session, RaveNavigationTarget target)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (ReferenceEquals(target, null))               throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(target.SubjectId)) throw new ArgumentNullException("target.SubjectId");

            string subjectId = target.SubjectId;

            session.OpenRaveSubject(target);

            session.WaitForRaveNavigationLink(subjectId);

            var raveNavigation = session.GetRaveNavigation();

            raveNavigation.OpenAdverseEventsPage();

            var raveAdverseEventPage = session.GetRaveAdverseEventsPage();

            return raveAdverseEventPage;
        }

        internal static RaveAuditsPage OpenRaveAuditsPageForAdverseEvent(this BrowserSession session, RaveNavigationTarget target, string adverseEventText, int adverseEventOccurrence = 1)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (ReferenceEquals(target, null))               throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(adverseEventText)) throw new ArgumentNullException("adverseEventText");
            if (adverseEventOccurrence <= 0)                 throw new ArgumentException("adverseEventOccurrence must be greater than 0.");

            var raveAdverseEventPage = session.OpenRaveAdverseEvent(target);

            raveAdverseEventPage.ViewAuditLog(adverseEventText, adverseEventOccurrence);

            var raveAuditsPage = session.GetRaveAuditsPage();

            return raveAuditsPage;
        }

        internal static RaveAuditsPage OpenRaveAuditsPageForFormRow(this BrowserSession session, RaveNavigationTarget target, string rowContents)
        {
            if (ReferenceEquals(session, null))         throw new ArgumentNullException("session");
            if (ReferenceEquals(target, null))          throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var raveFormPage = session.OpenRaveForm(target);

            raveFormPage.ViewAuditLog(rowContents);

            var raveAuditsPage = session.GetRaveAuditsPage();

            return raveAuditsPage;
        }

        internal static RaveUserAdministrationPage OpenRaveUserAdministrationPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.OpenUserAdministrationPage())
            {
                raveNavigation.OpenHomePage();

                raveNavigation.OpenUserAdministrationPage();
            }

            var raveUserAdministrationPage = session.GetRaveUserAdministrationPage();

            return raveUserAdministrationPage;
        }

        internal static void OpenRaveConfigurationPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");
            
            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.OpenConfigurationPage())
            {
                raveNavigation.OpenHomePage();

                raveNavigation.OpenConfigurationPage();
            }
        }

        internal static RaveConfigurationLoaderPage OpenRaveConfigurationLoaderPage(this BrowserSession session)
            {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.OpenConfigurationLoaderPage())
            {
                session.OpenRaveConfigurationPage();

                raveNavigation.OpenConfigurationLoaderPage();
            }

            var raveConfigPage = session.GetRaveConfigurationLoaderPage();

            return raveConfigPage;
        }

        internal static RaveConfigurationOtherSettingsPage OpenRaveConfigurationOtherSettingsPage(this BrowserSession session)
        {
            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.GoToEDCTab("Settings"))
            {
                session.OpenRaveConfigurationPage();

                raveNavigation.OpenConfigurationOtherSettingsPage();
            }

            var otherSettingsPage = session.GetRaveCoderConfigurationOtherSettingsPage();

            return otherSettingsPage;
        }

        internal static RaveConfigurationOtherSettingsCoderPage OpenRaveConfigurationOtherSettingsCoderPage(this BrowserSession session)
        {
            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.GoToEDCTab("Coder Configuration"))
            {
                var otherSettingsPage = session.OpenRaveConfigurationOtherSettingsPage();

                otherSettingsPage.OpenCoderConfiguration();
            }

            var otherSettingsCoderPage = session.GetRaveConfigurationOtherSettingsCoderPage();

            return otherSettingsCoderPage;
        }

        internal static RaveArchitectPage OpenRaveArchitectPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.OpenArchitectPage())
            {
                raveNavigation.OpenHomePage();

                raveNavigation.OpenArchitectPage();
            }

                var raveArchitectPage = session.GetRaveArchitectPage();

            return raveArchitectPage;
        }

        internal static RaveArchitectProjectPage OpenRaveArchitectProjectPage(this BrowserSession session, string projectName)
        {
            if (ReferenceEquals(session, null))         throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(projectName)) throw new ArgumentNullException("projectName");
            
            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.GoToArchitectTab(projectName))
            {
                var raveArchitectPage = session.OpenRaveArchitectPage();

                raveArchitectPage.OpenProject(projectName);
            }

            var raveArchitectProjectPage = session.GetRaveArchitectProjectPage();

            return raveArchitectProjectPage;
        }

        internal static RaveArchitectUploadDraftPage OpenRaveArchitectUploadDraftPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null))         throw new ArgumentNullException("session");

            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.OpenArchitectUploadDraftPage())
            {
                session.OpenRaveArchitectPage();

                raveNavigation.OpenArchitectUploadDraftPage();
            }
            
            var raveArchitectUploadDraftPage = session.GetRaveArchitectUploadDraftPage();

            return raveArchitectUploadDraftPage;
        }

        internal static RaveArchitectAddNewDraftPage OpenRaveArchitectAddNewDraftPage(this BrowserSession session, string projectName)
        {
            if (ReferenceEquals(session, null))         throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(projectName)) throw new ArgumentNullException("projectName");
            
            var raveArchitectProjectPage = session.OpenRaveArchitectProjectPage(projectName);

            raveArchitectProjectPage.OpenAddNewDraftPage();

            var raveArchitectAddNewDraftPage = session.GetRaveArchitectAddNewDraftPage();

            return raveArchitectAddNewDraftPage;
        }
        
        internal static RaveArchitectCRFDraftPage OpenRaveArchitectCRFDraftPage(this BrowserSession session, RaveArchitectRecordTarget target)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (ReferenceEquals(target, null))               throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(target.StudyName)) throw new ArgumentNullException("target.StudyName");
            if (String.IsNullOrWhiteSpace(target.DraftName)) throw new ArgumentNullException("target.DraftName");

            string studyName = target.StudyName;
            string draftName = target.DraftName;
            
            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.GoToArchitectTab(draftName))
            {
            var raveArchitectProjectPage = session.OpenRaveArchitectProjectPage(studyName);

            raveArchitectProjectPage.OpenDraft(draftName);
            }

            var raveArchitectCRFDraftPage = session.GetRaveArchitectCRFDraftPage();

            return raveArchitectCRFDraftPage;
        }

        internal static RaveArchitectFormsPage OpenRaveArchitectFormsPage(this BrowserSession session, RaveArchitectRecordTarget target)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (ReferenceEquals(target, null))               throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(target.StudyName)) throw new ArgumentNullException("target.StudyName");
            if (String.IsNullOrWhiteSpace(target.DraftName)) throw new ArgumentNullException("target.DraftName");
            if (String.IsNullOrWhiteSpace(target.FormName))  throw new ArgumentNullException("target.FormName");
            
            string studyName = target.StudyName;
            string draftName = target.DraftName;
            string formName  = target.FormName;
            
            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.OpenArchitectFormsPage())
            {
                session.OpenRaveArchitectCRFDraftPage(target);

                raveNavigation.OpenArchitectFormsPage();
            }

                var raveFormsPage = session.GetRaveArchitectFormsPage();

            return raveFormsPage;
            }

        internal static RaveArchitectFormPage OpenRaveArchitectFormPage(this BrowserSession session, RaveArchitectRecordTarget target)
        {
            if (ReferenceEquals(session, null))             throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(target.FormName)) throw new ArgumentNullException("target.FormName");

            string formName = target.FormName;

            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.GoToArchitectTab(formName))
            {
                var raveFormsPage = session.OpenRaveArchitectFormsPage(target);

                raveFormsPage.OpenForm(formName);
            }

            var raveFormPage = session.GetRaveArchitectFormPage();

            return raveFormPage;
        }

        internal static RaveArchitectEnvironmentSetupPage OpenRaveArchitectEnvironmentSetupPage(this BrowserSession session, string projectName)
        {
            if (ReferenceEquals(session, null))         throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(projectName)) throw new ArgumentNullException("projectName");
           
            var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.OpenArchitectEnvironmentSetupPage())
            {
                session.OpenRaveArchitectProjectPage(projectName);

                raveNavigation.OpenArchitectEnvironmentSetupPage();
                }

            var raveArchitectEnvironmentSetupPage = session.GetRaveArchitectEnvironmentSetupPage();

            return raveArchitectEnvironmentSetupPage;
        }

        internal static RaveArchitectAmendmentManagerPage OpenRaveArchitectAmendmentManagerPage(this BrowserSession session, string projectName)
        {
            if (ReferenceEquals(session, null))         throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(projectName)) throw new ArgumentNullException("projectName");

                var raveNavigation = session.GetRaveNavigation();

            if (!raveNavigation.OpenArchitectAmendmentManagerPage())
                {
                session.OpenRaveArchitectProjectPage(projectName);

                raveNavigation.OpenArchitectAmendmentManagerPage();
                }

            var raveArchitectAmendmentManagerPage = session.GetRaveArchitectAmendmentManagerPage();

            return raveArchitectAmendmentManagerPage;
        }

        internal static SynonymApprovalPage GetSynonymApprovalPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var synonymApprovalPage = new SynonymApprovalPage(session);

            synonymApprovalPage.GoTo();

            return synonymApprovalPage;
        }

        internal static SynonymApprovalPage OpenSynonymApprovalPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            session.GetPageHeader().GoToAdminPage("Synonym Approval");
            var synonymApprovalPage = session.GetSynonymApprovalPage();
            synonymApprovalPage.WaitUntilFinishLoading();

            return synonymApprovalPage;
        }

        internal static SynonymListPage GetSynonymListPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var synonymList = new SynonymListPage(session);

            return synonymList;
        }

        internal static StudyImpactAnalysisPage GetStudyImpactAnalysisPage(
            this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var studyImpactAnalysisPage = new StudyImpactAnalysisPage(session);

            return studyImpactAnalysisPage;
        }

        internal static StudyImpactAnalysisPage OpenStudyImpactAnalysisPage(
            this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var studyImpactAnalysisPage = new StudyImpactAnalysisPage(session);

            studyImpactAnalysisPage.GoTo();

            return studyImpactAnalysisPage;
        }

        internal static StudyImpactAnalysisPage OpenStudyAnalysisPageWithReportForValues(
            this BrowserSession session,
            string study,
            string dictionary,
            SynonymList sourceSynonymList,
            SynonymList targetSynonymList)
        {
            if (ReferenceEquals(session, null))           throw new ArgumentNullException("session");
            if (String.IsNullOrEmpty(study))              throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(dictionary))         throw new ArgumentNullException("dictionary");
            if (ReferenceEquals(sourceSynonymList, null)) throw new ArgumentNullException("sourceSynonymList");
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");



            var studyImpactAnalysisPage = new StudyImpactAnalysisPage(session);

            studyImpactAnalysisPage.CreateNewStudyImpactAnalysisReport();

            studyImpactAnalysisPage.GoToWithValues(
                study,
                dictionary,
                sourceSynonymList,
                targetSynonymList);

            studyImpactAnalysisPage.GenerateReport();

            studyImpactAnalysisPage.ViewReport();

            return studyImpactAnalysisPage;
        }

        internal static StudyReportPage OpenStudyReportPage(
            this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var studyReportPage = new StudyReportPage(session);

            studyReportPage.GoTo();

            return studyReportPage;
        }

        internal static DoNotAutoCodePage OpenDoNotAutoCodePage(
            this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var doNotAutoCodePage = new DoNotAutoCodePage(session);

            doNotAutoCodePage.GoTo();

            return doNotAutoCodePage;
        }

        public static void GoToReportPage(
            this BrowserSession session,
            string pageName)
        {
            if (ReferenceEquals(session, null))  throw new ArgumentNullException("session");
            if (ReferenceEquals(pageName, null)) throw new ArgumentNullException("pageName");

            if (session.FindWindow(pageName).Missing())
            {
                session.FollowReportLink(pageName);
            }

        }

        internal static void GoToHelpPage(
            this BrowserSession session,
            string linkName)
        {
            if (ReferenceEquals(session, null))  throw new ArgumentNullException("session");
            if (ReferenceEquals(linkName, null)) throw new ArgumentNullException("linkName");

            var header = session.GetPageHeader();

            header.GetHelpLink().Hover();
            header.GetHelpLink().Click();
            header.GetHelpMenuItemByName(linkName).Click();
        }

        internal static void GoToAdminPage(
            this BrowserSession session,
            string adminLink)
        {
            if (ReferenceEquals(session, null))  throw new ArgumentNullException("session");
            if (String.IsNullOrEmpty(adminLink)) throw new ArgumentNullException("adminLink");

            var header = session.GetPageHeader();
            if (!header.IsBrowserOnAdminPage(adminLink))
            {
                header.GoToAdminPage(adminLink);
            }
        }

        internal static void FollowReportLink(
            this BrowserSession session,
            string reportLink)
        {
            if (String.IsNullOrEmpty(reportLink)) throw new ArgumentNullException("reportLink");

            var header = session.GetPageHeader();
            header.GetReportsTab().Hover();
            header.GetReportsTab().Click();

            var reportsPage = session.GetMainReportCoderPage();

            switch (reportLink.ToLower())
            {
                case "coding decisions report":
                    reportsPage.SelectCodingDecisionReportOption();
                    break;
                case "study report":
                    reportsPage.SelectStudyReportOption();
                    break;
                case "coding history report":
                    reportsPage.SelectCodingHistoryReportOption();
                    break;
                case "ingredient report":
                    reportsPage.SelectIngredientReportOption();
                    break;
                default:
                    throw new ArgumentException("Invalid reportLink argument");
            }
            reportsPage.SelectCreateNewButton();
        }

        internal static BrowserWindow SwitchToBrowserWindowByName(
            this BrowserSession session,
            string windowName,
            Options options = null)
        {
            if (ReferenceEquals(session, null))    throw new ArgumentNullException("session");
            if (ReferenceEquals(windowName, null)) throw new ArgumentNullException("windowName");

            var window = session.FindWindow(windowName, options);

            return window;
        }

        //mev download related ...
        internal static MevPage GetMevPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var mevPage = new MevPage(session);

            return mevPage;
        }

        internal static ImedidataStudyGroupPage GetImedidataStudyGroupPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var studyGroupPage = new ImedidataStudyGroupPage(session);

            return studyGroupPage;
        }

        internal static ImedidataStudyPage GetImedidataStudyPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var studyPage = new ImedidataStudyPage(session);

            return studyPage;
        }

        internal static CoderTestContext GetCoderTestContext(this BrowserSession session)
        {
            var coderTestContext = new CoderTestContext();

            return coderTestContext;
        }

        internal static void WaitUntilElementIsActive(this BrowserSession session, Func<SessionElementScope> getElement)
        {
            if (ReferenceEquals(session, null))    throw new ArgumentNullException("session");
            if (ReferenceEquals(getElement, null)) throw new ArgumentNullException("getElement");

            var options = Config.GetDefaultCoypuOptions();

            RetryPolicy.FindElement.Execute(
                () =>
                {
                    session.WaitUntilElementExists(getElement);
                });

            session.TryUntil(
                () => getElement(),
                () => !getElement().Disabled,
                options.RetryInterval,
                options);
        }

        internal static void WaitUntilElementIsDisabled(this BrowserSession session, Func<SessionElementScope> getElement)
        {
            if (ReferenceEquals(session, null))    throw new ArgumentNullException("session");
            if (ReferenceEquals(getElement, null)) throw new ArgumentNullException("getElement");

            var options = Config.GetDefaultCoypuOptions();

            RetryPolicy.FindElement.Execute(
                () =>
                {
                    session.WaitUntilElementExists(getElement);
                });

            session.TryUntil(
                () => getElement(),
                () => getElement().Disabled,
                options.RetryInterval,
                options);
        }

        internal static void WaitUntilElementExists(this BrowserSession session, Func<SessionElementScope> getElement)
        {
            if (ReferenceEquals(session, null))    throw new ArgumentNullException("session");
            if (ReferenceEquals(getElement, null)) throw new ArgumentNullException("getElement");

            var options = Config.GetDefaultCoypuOptions();

            session.TryUntil(
                () => getElement(),
                () => getElement().Exists(),
                options.RetryInterval,
                options);
        }

        internal static void WaitUntilElementDisappears(this BrowserSession session,
            Func<SessionElementScope> getElement, Options options = null)
        {
            if (ReferenceEquals(session, null))    throw new ArgumentNullException("session");
            if (ReferenceEquals(getElement, null)) throw new ArgumentNullException("getElement");

            if (ReferenceEquals(options, null))
            {
                options = Config.GetDefaultCoypuOptions();
            }

            session.TryUntil(
                () => getElement(),
                () => !getElement().Exists(),
                options.RetryInterval,
                options);
        }

        internal static void RefreshUntilElementDisappears(this BrowserSession session,
            Func<SessionElementScope> getElement, Options options = null)
        {
            if (ReferenceEquals(session, null))    throw new ArgumentNullException("session");
            if (ReferenceEquals(getElement, null)) throw new ArgumentNullException("getElement");

            if (ReferenceEquals(options, null))
            {
                options = Config.GetDefaultCoypuOptions();
            }

            session.TryUntil(
                () => session.Refresh(),
                () => !getElement().Exists(),
                options.RetryInterval,
                options);
        }
        
        internal static void WaitForRaveNavigationLink(this BrowserSession session, string linkText)
        {
            if (ReferenceEquals(session, null))      throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(linkText)) throw new ArgumentNullException("linkText");

            var raveNavigation = session.GetRaveNavigation();

            raveNavigation.WaitForNavigationLink(linkText);
        }

        private static IList<SessionElementScope> GetDXSelectListOptions(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var selectListOptions = session.FindAllSessionElementsByXPath("//*[contains(@id,'DDD_L_LBI')]");

            return selectListOptions;
        }

        private static SessionElementScope GetDXSelectListOption(this BrowserSession session, SessionElementScope selectList, string targetOptionText)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (ReferenceEquals(selectList, null))           throw new ArgumentNullException("selectList");
            if (String.IsNullOrWhiteSpace(targetOptionText)) throw new ArgumentNullException("targetOptionText");

            session.TryUntil(
                () => selectList.Click(),
                () => session.GetDXSelectListOptions().Any(),
                Config.LongExistsOptions.RetryInterval,
                Config.LongExistsOptions);

            var selectListOptions = session.GetDXSelectListOptions();

            var selectListOption = selectListOptions.FirstOrDefault(x => x.Text.Equals(targetOptionText, StringComparison.OrdinalIgnoreCase));

            if (ReferenceEquals(selectListOption, null))
            {
                var nonAlphaNumericOption =targetOptionText.RemoveNonAlphanumeric();
                selectListOption = selectListOptions.FirstOrDefault(x => x.Text.Contains(nonAlphaNumericOption, StringComparison.OrdinalIgnoreCase));
            }

            if (ReferenceEquals(selectListOption, null))
            {
                throw new NullReferenceException(String.Format("No option {0} was found.", targetOptionText));
            }

            return selectListOption;
        }

        internal static void SelectDXOption(this BrowserSession session, Func<SessionElementScope> getSelectList, string targetOptionText)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (ReferenceEquals(getSelectList, null))        throw new ArgumentNullException("getSelectList");
            if (String.IsNullOrWhiteSpace(targetOptionText)) throw new ArgumentNullException("targetOptionText");

            var selectList = getSelectList();

            var selectListOption = RetryPolicy.FindElement.Execute(
                () => session.GetDXSelectListOption(selectList, targetOptionText));

            selectListOption.Click();
        }

        internal static void GoToHomePage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            //The resize call will remove the firefox download confirmation window, which can block navigation menu access
            //This is less than ideal, but numerous FireFoxProfile settings were attempted without success
            session.ResizeTo(100, 100);
            session.ResizeTo(Config.ScreenWidth, Config.ScreenHeight);

            var currentLocation      = session.Location;
            var currentSchemeAndHost = currentLocation.Scheme + Uri.SchemeDelimiter + currentLocation.Host;

            session.Visit(currentSchemeAndHost);
        }

        internal static void AcceptConfirmationDialog(this BrowserSession session, string partialDialogText)
        {
            if (ReferenceEquals(session, null))               throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(partialDialogText)) throw new ArgumentNullException("partialDialogText");

            session.WaitForConfirmationDialog(partialDialogText);

            session.AcceptModalDialog();
        }

        internal static void CancelConfirmationDialog(this BrowserSession session, string partialDialogText)
        {
            if (ReferenceEquals(session, null))               throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(partialDialogText)) throw new ArgumentNullException("partialDialogText");

            session.WaitForConfirmationDialog(partialDialogText);

            session.CancelModalDialog();
        }

        private static void WaitForConfirmationDialog(this BrowserSession session, string partialDialogText)
        {
            if (ReferenceEquals(session, null))               throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(partialDialogText)) throw new ArgumentNullException("partialDialogText");

            RetryPolicy.FindElement.Execute(
                () =>
                {
                    if (session.HasNoDialog(partialDialogText, Options.Substring))
                    {
                        throw new MissingHtmlException("Confirmation dialog does not exist.");
                    }
                });
        }

        internal static RaveArchitectEnvironmentSetupPage GetRaveArchitectEnvironmentSetupPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectEnvironmentSetupPage = new RaveArchitectEnvironmentSetupPage(session);

            return raveArchitectEnvironmentSetupPage;
        }

        internal static ReportMainCreationCoderPage GetMainReportCoderPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var mainReportCoderPage = new ReportMainCreationCoderPage(session);

            return mainReportCoderPage;
        }
    }
}