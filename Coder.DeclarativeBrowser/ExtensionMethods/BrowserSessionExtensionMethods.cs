using System;
using Coder.DeclarativeBrowser.CoderConfiguration;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.PageObjects;
using Coder.DeclarativeBrowser.PageObjects.Administration;
using Coder.DeclarativeBrowser.PageObjects.Reports;
using Coypu;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.DeclarativeBrowser.PageObjects.Rave;
using Coypu.Timing;


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

        internal static RaveModulesPage GetRaveModulesPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveModulesPage = new RaveModulesPage(session);

            raveModulesPage.GoTo();

            return raveModulesPage;
        }

        internal static RaveUserAdministrationPage GetRaveUserAdministrationPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveUserAdministrationPage = new RaveUserAdministrationPage(session);

            raveUserAdministrationPage.GoTo();

            return raveUserAdministrationPage;
        }

        internal static RaveConfigrationLoaderPage GetRaveConfigrationLoaderPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveConfigPage = new RaveConfigrationLoaderPage(session);

            raveConfigPage.GoTo();

            return raveConfigPage;
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

        internal static RaveAuditsPage GetRaveAuditsPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveAuditsPage = new RaveAuditsPage(session);

            return raveAuditsPage;
        }

        internal static RaveStudyPage GetRaveStudyPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveStudyPage = new RaveStudyPage(session);

            return raveStudyPage;
        }

        internal static RaveArchitectPage GetRaveArchitectPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectPage = new RaveArchitectPage(session);

            return raveArchitectPage;
        }

        internal static RaveArchitectProjectPage GetRaveArchitectProjectPage(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var raveArchitectProjectPage = new RaveArchitectProjectPage(session);

            return raveArchitectProjectPage;
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

        internal static RaveStudyPage OpenRaveStudy(this BrowserSession session, string studyName)
        {
            if (ReferenceEquals(session, null))       throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(studyName)) throw new ArgumentNullException("studyName");

            var raveNavigation = session.GetRaveNavigation();
            raveNavigation.OpenHomePage();

            var raveHomePage = session.GetRaveHomePage();
            raveHomePage.OpenStudy(studyName);

            var raveStudyPage = session.GetRaveStudyPage();
            return raveStudyPage;
        }

        internal static void OpenRaveSubject(this BrowserSession session, string studyName, string subjectId)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(studyName))        throw new ArgumentNullException("studyName");
            if (String.IsNullOrWhiteSpace(subjectId))        throw new ArgumentNullException("subjectId");

            var raveStudyPage = session.OpenRaveStudy(studyName);

            raveStudyPage.SearchForSubject(subjectId);

            session.WaitForRaveSubjectSearchToComplete();

            if (raveStudyPage.IsSubjectsGridLoaded())
            {
                raveStudyPage.OpenSubject(subjectId);
            }
        }

        internal static RaveAdverseEventsPage OpenRaveAdverseEvent(this BrowserSession session, string studyName,
            string subjectId)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(studyName))        throw new ArgumentNullException("studyName");
            if (String.IsNullOrWhiteSpace(subjectId))        throw new ArgumentNullException("subjectId");

            session.OpenRaveSubject(studyName, subjectId);

            var raveNavigation = session.GetRaveNavigation();

            raveNavigation.WaitForNavigationLink(subjectId);

            raveNavigation.OpenAdverseEventsPage();

            var raveAdverseEventPage = session.GetRaveAdverseEventsPage();

            return raveAdverseEventPage;
        }

        internal static RaveAuditsPage OpenRaveAuditsPageForAdverseEvent(
            this BrowserSession session,
            string studyName,
            string subjectId,
            string adverseEventText,
            int adverseEventOccurrence = 1)
        {
            if (ReferenceEquals(session, null))              throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(studyName))        throw new ArgumentNullException("studyName");
            if (String.IsNullOrWhiteSpace(subjectId))        throw new ArgumentNullException("subjectId");
            if (String.IsNullOrWhiteSpace(adverseEventText)) throw new ArgumentNullException("adverseEventText");
            if (adverseEventOccurrence <= 0)                 throw new ArgumentException("adverseEventOccurrence must be greater than 0.");

            var raveAdverseEventPage = session.OpenRaveAdverseEvent(studyName, subjectId);

            raveAdverseEventPage.ViewAuditLog(adverseEventText, adverseEventOccurrence);

            var raveAuditsPage = session.GetRaveAuditsPage();

            return raveAuditsPage;
        }

        internal static RaveArchitectProjectPage OpenRaveArchitectProjectPage(this BrowserSession session,
            string projectName)
        {
            if (ReferenceEquals(session, null))         throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(projectName)) throw new ArgumentNullException("projectName");

            var raveNavigation = session.GetRaveNavigation();

            raveNavigation.OpenArchitectPage();

            var raveArchitectPage = session.GetRaveArchitectPage();

            raveArchitectPage.OpenProject(projectName);

            var raveArchitectProjectPage = session.GetRaveArchitectProjectPage();

            return raveArchitectProjectPage;
        }

        internal static RaveArchitectAddNewDraftPage OpenRaveArchitectAddNewDraftPage(this BrowserSession session,
            string projectName)
        {
            if (ReferenceEquals(session, null))         throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(projectName)) throw new ArgumentNullException("projectName");

            var raveArchitectProjectPage = session.OpenRaveArchitectProjectPage(projectName);

            raveArchitectProjectPage.OpenAddNewDraftPage();

            var raveArchitectAddNewDraftPage = session.GetRaveArchitectAddNewDraftPage();

            return raveArchitectAddNewDraftPage;
        }

        private static void WaitForRaveSubjectSearchToComplete(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            RetryPolicy.FindElement.Execute(() =>
            {
                var raveStudyPage = session.GetRaveStudyPage();
                var raveNavigation = session.GetRaveNavigation();

                if (!raveStudyPage.IsSubjectsGridLoaded() && !raveNavigation.IsNavigationLinksGridLoaded())
                {
                    throw new MissingHtmlException("Rave subject search is not complete.");
                }
            });
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

            studyImpactAnalysisPage.GoToWithValues(
                study,
                dictionary,
                sourceSynonymList,
                targetSynonymList);

            studyImpactAnalysisPage.GenerateReport();

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

            header.GoToAdminPage(adminLink);
        }

        internal static void FollowReportLink(
            this BrowserSession session,
            string reportLink)
        {
            if (String.IsNullOrEmpty(reportLink)) throw new ArgumentNullException("reportLink");

            var header = session.GetPageHeader();

            header.GetReportsTab().Hover();
            header.GetReportsTab().Click();
            header.GetReportsMenuItemByName(reportLink).Click();
        }

        internal static BrowserWindow SwitchToBrowserWindowByName(
            this BrowserSession session,
            string windowName)
        {
            if (ReferenceEquals(session, null))    throw new ArgumentNullException("session");
            if (ReferenceEquals(windowName, null)) throw new ArgumentNullException("windowName");

            var window = session.FindWindow(windowName);

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

        internal static void WaitForIMedidataSync(this BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            var header = session.GetPageHeader();
            header.WaitForSync();
        }

        internal static void TryToSelectValue(this BrowserSession session, string id, string selectedValue,
            bool useContains = false)
        {
            if (ReferenceEquals(session, null))       throw new ArgumentNullException("session");
            if (ReferenceEquals(id, null))            throw new ArgumentNullException("id");
            if (ReferenceEquals(selectedValue, null)) throw new ArgumentNullException("selectedValue");

            var option  = session.FindSessionElementByXPath(GetDxEditorSelectOptionXPath(id, selectedValue, useContains));
            var table   = session.FindSessionElementByXPath(String.Format("//div[@id ='{0}_DDD_PW-1' and not(contains(@style,'visibility: hidden'))]", id));
            var input   = session.FindSessionElementByXPath(String.Format("//input[@id = '{0}_I']", id));
            var options = Config.GetDefaultCoypuOptions();

            session.TryUntil(input.Click,   () => option.Exists(), options.RetryInterval, options);
            session.TryUntil(input.Click,   () => table.Exists(), options.RetryInterval, options);
            session.TryUntil(option.Hover,  () => option.Class.Contains("Hover"), options.RetryInterval, options);
            session.TryUntil(option.Click,  () => useContains ? input.Value.Contains(selectedValue) : input.Value == selectedValue,options.RetryInterval, options);
        }

        internal static void TrySelectDxOptionEditor(
            this BrowserSession session,
            Func<SessionElementScope> getTextBox,
            Func<string, SessionElementScope> getOption,
            string optionSelect)
        {
            if (ReferenceEquals(session, null))          throw new ArgumentNullException("session");
            if (ReferenceEquals(getTextBox, null))       throw new ArgumentNullException("getTextBox");
            if (ReferenceEquals(getOption, null))        throw new ArgumentNullException("getOption");
            if (String.IsNullOrWhiteSpace(optionSelect)) throw new ArgumentNullException("optionSelect");

            getTextBox().Click();
            var selection = getOption(optionSelect);

            if (!selection.Exists())
            {
                throw new MissingHtmlException(String.Format("{0} doesn't exist", optionSelect));
            }

            selection.HoverAndClick();

            var textBox = getTextBox();

            if (String.IsNullOrWhiteSpace(textBox.Value))
            {
                throw new MissingHtmlException(String.Format("{0} not selected", optionSelect));
            }

            if (!textBox.Value.Contains(optionSelect, StringComparison.OrdinalIgnoreCase))
            {
                throw new MissingHtmlException(String.Format("{0} not selected", optionSelect));
            }
        }

        private static string GetDxEditorSelectOptionXPath(string id, string selectedValue, bool useContains = false)
        {
            if (ReferenceEquals(id, null))            throw new ArgumentNullException("id");
            if (ReferenceEquals(selectedValue, null)) throw new ArgumentNullException("selectedValue");

            if (useContains == false)
            {
                return String.Format("//td[contains(@id, '{0}') and contains(@id, 'LB') and (text()='{1}')]", id,
                    selectedValue);
            }

            return String.Format("//td[contains(@id, '{0}') and contains(@id, 'LB') and contains(text(), '{1}')]", id,
                selectedValue);
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
    }
}