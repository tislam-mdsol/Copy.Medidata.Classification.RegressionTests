using System;
using System.Data;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.Drivers;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coypu.Drivers.Selenium;
using Coypu;
using Coypu.Drivers;
using FluentAssertions;
using NUnit.Framework;
using System.Reflection;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.FileHelpers;
using Coder.DeclarativeBrowser.Helpers;
using Coder.DeclarativeBrowser.IMedidataApi;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coder.DeclarativeBrowser.PageObjects;
using Medidata;
using Medidata.Classification;
using WorkflowState = Coder.DeclarativeBrowser.PageObjects.Reports.WorkflowState;

namespace Coder.DeclarativeBrowser
{
    public enum SortStatus
    {
        NotSorted,
        SortedAscending,
        SortedDescending
    }

    public class CoderDeclarativeBrowser : IDisposable
    {
        public readonly BrowserSession Session;
        private readonly string _DownloadDirectory;
        private const string _DataListingReportsBrowserWindowTitle = "DataListingsReport";
        private const string _OldReportsBrowserWindowTitle = "Reports";

        internal CoderDeclarativeBrowser(BrowserSession session, string downloadDirectory)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException("downloadDirectory");

            Session = session;
            _DownloadDirectory = downloadDirectory;
        }

        public static void go()
        {

            CommunicationHub.Get<AutomatedCodingRequestSection>().Event += (snd, arg) =>
            {

            };
        }

        public static CoderDeclarativeBrowser StartBrowsing(string downloadDirectory)
        {
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException("downloadDirectory");

            var result = StartBrowsing(Config.BrowserDriver, downloadDirectory);

            return result;
        }

        public static CoderDeclarativeBrowser StartBrowsing(Browser browserDriver, string downloadDirectory)
        {
            if (ReferenceEquals(browserDriver, null)) throw new ArgumentNullException("browserDriver");
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException("downloadDirectory");

            var sessionConfiguration = new SessionConfiguration
            {
                AppHost = Config.AppHost ?? Config.LocalHost,
                Driver = typeof(SeleniumWebDriver),
                Browser = browserDriver
            };

            var browser = CustomDriverFactory.BuildCustomBrowserDriver(
                browserDriver,
                sessionConfiguration,
                downloadDirectory);
            
            return browser;
        }

        public void Dispose()
        {
            if (ReferenceEquals(Session, null))
            {
                return;
            }

            try
            {
                Session.Visit("/logout");
            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Format("Error while logging out: {0}", ex));
            }

            try
            {
                Session.Driver.Dispose();
            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Format("Error while disposoing Session.Driver: {0}", ex));
            }

            Session.Dispose();
        }

        public bool InitiateCodingRequests(AutomatedCodingRequestSection data)
        {                                                                                                    
            var client = new ClassificationClient.ClassificationClient();

            client.BroadcastingAutomatedCodingRequestSection(data);

            //ToDo: update broadcastingSuccesfully to actually values
            bool broadcastingSuccesfully = 5 > new Random().Next(10);

            return broadcastingSuccesfully;
        }

        public bool BuildAndUploadOdm(OdmParameters odmParameters, string dumpDirectory, bool haltOnFailure = true)
        {
            //TODO::Move to BrowserUtility and remove page objects once Use of Web Service to upload ODMs is complete (MCC-191945)
            if (ReferenceEquals(odmParameters, null)) throw new ArgumentNullException("odmParameters");
            if (String.IsNullOrWhiteSpace(dumpDirectory)) throw new ArgumentNullException("dumpDirectory");

            var filePath = BrowserUtility.BuildOdmFile(odmParameters, dumpDirectory);

            bool uploadCompletedSuccesfully = UploadOdm(filePath, haltOnFailure);

            GoToTaskPage();

            return uploadCompletedSuccesfully;
        }
        
        public bool UploadOdm(string filePath, bool haltOnFailure = true)
        {
            //TODO::Move to BrowserUtility and remove page objects once Use of Web Service to upload ODMs is complete (MCC-191945)
            if (String.IsNullOrEmpty(filePath)) throw new ArgumentNullException("filePath");

            Session.GoToAdminPage("CodingCleanup");

            var codingCleanupPage = Session.GetCodingCleanupPage();

            codingCleanupPage.GetUploadField().FillInWith(filePath);
            codingCleanupPage.GetUploadButton().ClickWhenAvailable();
            codingCleanupPage.WaitUntilUploadCompletes();
            
            var uploadCompletedSuccesfully = codingCleanupPage.GetUploadSuccessIndicator().Exists(Config.ExistsOptions);
            
            if (!haltOnFailure)
            {
                this.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
            }

            if (!uploadCompletedSuccesfully && haltOnFailure)
            {
                Console.WriteLine("\n\nError uploading ODM file.\n");
                throw new InvalidOperationException("Error uploading ODM file.");
            }

            return uploadCompletedSuccesfully;
        }
        
        //TODO: DJ Usage of this, along with a lot of pre-execution setup steps, needs to be better encapsulated
        public void CleanUpCodingTasks()
        {
            Session.GoToAdminPage("Coding Cleanup");

            var codingCleanupPage = Session.GetCodingCleanupPage();
            codingCleanupPage.CleanUpTasksAndSynonyms();
        }

        public void CleanUpCodingTasksOnly()
        {
            Session.GoToAdminPage("Coding Cleanup");

            var codingCleanupPage = Session.GetCodingCleanupPage();
            codingCleanupPage.CleanUpTasks();
        }

        public void ExportCodingHistoryReport(CodingHistoryReportCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException("searchCriteria");

            var reportPage = Session.GetCodingHistoryReportPage();
            reportPage.SetReportCriteria(searchCriteria);

            GenericFileHelper.DownloadVerifiedFile(
                _DownloadDirectory,
                Config.CodingHistoryReportFileName,
                reportPage.ExportReport);
        }

        public void ExportCodingDecisionsReport(CodingDecisionsReportCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException("searchCriteria");

            var reportPage = Session.GetCodingDecisionsReportPage();
            reportPage.SetReportCriteria(searchCriteria);

            GenericFileHelper.DownloadVerifiedFile(
                _DownloadDirectory,
                Config.CodingDecisionsReportFileName,
                reportPage.ExportReport);
        }

        public void GenerateIngredientReport(string studyName, string dictionaryName)
        {
            if (String.IsNullOrEmpty(studyName)) throw new ArgumentNullException("studyName");
            if (String.IsNullOrEmpty(dictionaryName)) throw new ArgumentNullException("dictionaryName");

            var reportPage = Session.GetIngredientReportPage();
            reportPage.SetReportParameters(studyName, dictionaryName);

            GenericFileHelper.DownloadVerifiedFile(
                _DownloadDirectory,
                Config.IngredientReportFileName,
                reportPage.ExportReport);
        }

        //TODO: move this method to BrowserSessionExtensionMethods remove once refactoring begins for the method calls
        private void FollowReportLink(string reportLink)
        {
            if (String.IsNullOrEmpty(reportLink)) throw new ArgumentNullException("reportLink");

            var header = Session.GetPageHeader();

            header.GetReportsTab().Hover();
            header.GetReportsTab().Click();
            header.GetReportsMenuItemByName(reportLink).Click();
        }

        //TODO: move this method to BrowserSessionExtensionMethods remove once refactoring begins for the method calls
        public void GoToReportPage(string pageName)
        {
            if (ReferenceEquals(pageName, null)) throw new ArgumentNullException("pageName");

            if (Session.FindWindow(pageName).Missing())
            {
                FollowReportLink(pageName);
            }
        }

        public void CreateAndActivateWorkFlowRole(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName"); 

            var createWorkflowRolesPage = Session.GetCreateWorkflowRolesPage();

            createWorkflowRolesPage.CreateWorkflowRole(roleName);
            createWorkflowRolesPage.ActivateWorkflowRole(roleName);
        }

        public void AssignAllWorkflowRoleActions(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName"); 

            var createWorkflowRolesPage = Session.GetCreateWorkflowRolesPage();

            createWorkflowRolesPage.AssignAllWorkflowActions(roleName);
        }

        public void AssignWorkflowRole(string roleName, string study, string loginId)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study)) throw new ArgumentNullException("study");
            if (String.IsNullOrWhiteSpace(loginId)) throw new ArgumentNullException("loginId");

            var assignWorkflowRolePage = Session.GetAssignWorkFlowRolesPage();

            assignWorkflowRolePage.AssignWorkFlowRole(
                roleName: roleName,
                study: study,
                loginId: loginId);
        }

        public void RemoveWorkflowAction(string actionName, string roleName)
        {
            if (String.IsNullOrWhiteSpace(actionName)) throw new ArgumentNullException("actionName");
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");

            var createWorkflowRolesPage = Session.GetCreateWorkflowRolesPage();

            createWorkflowRolesPage.RemoveWorkflowAction(
                actionName: actionName,
                roleName: roleName);
        }

        public void DeactivateWorkflowRole(string roleName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName"); 

            var createWorkflowRolesPage = Session.GetCreateWorkflowRolesPage();

            createWorkflowRolesPage.DeActivateWorkflowRole(roleName);
        }
        
        public void DenyAccessToWorkFlowRole(string roleName, string study, string loginId)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study)) throw new ArgumentNullException("study");
            if (String.IsNullOrWhiteSpace(loginId)) throw new ArgumentNullException("loginId");

            var assignWorkFlowRolesPage = Session.GetAssignWorkFlowRolesPage();

            assignWorkFlowRolesPage.DenyAccessToWorkflowRole(
                roleName: roleName,
                study: study,
                loginId: loginId);
        }

        public void DeleteWorkFlowRole(string roleName, string study, string loginId)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(study)) throw new ArgumentNullException("study");
            if (String.IsNullOrWhiteSpace(loginId)) throw new ArgumentNullException("loginId");

            var assignWorkFlowRolesPage = Session.GetAssignWorkFlowRolesPage();

            assignWorkFlowRolesPage.DeleteWorkflowRole(
                roleName: roleName,
                study: study,
                loginId: loginId);
        }

        public void CreateAndActivateGeneralRole(string roleName, string securityModule)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule"); 

            var createGeneralRolesPage = Session.GetCreateGeneralRolesPage();

            createGeneralRolesPage.CreateGeneralRole(roleName: roleName, securityModule: securityModule);
            createGeneralRolesPage.ActivateGeneralRole(roleName: roleName, securityModule: securityModule);
        }

        public void AssignGeneralRole(string roleName, string securityModule, string type, string loginId)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule");
            if (String.IsNullOrWhiteSpace(type)) throw new ArgumentNullException("type");
            if (String.IsNullOrWhiteSpace(loginId)) throw new ArgumentNullException("loginId");

            var assignGeneralRolePage = Session.GetAssignGeneralRolesPage();

            assignGeneralRolePage.AssignGeneralRole(
                roleName: roleName,
                securityModule: securityModule,
                type: type,
                loginId: loginId);
        }

        public void AssignAllGeneralRoleActions(string securityModule, string roleName)
        {
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule");
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");

            var createGeneralRolesPage = Session.GetCreateGeneralRolesPage();

            createGeneralRolesPage.ActivateAllRoleActions(securityModule, roleName);
        }

        public void RemoveGeneralRoleAction(string roleName, string securityModule, string actionName)
        {
            if (String.IsNullOrWhiteSpace(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrWhiteSpace(securityModule)) throw new ArgumentNullException("securityModule");
            if (String.IsNullOrWhiteSpace(actionName)) throw new ArgumentNullException("actionName");

            var createGeneralRolesPage = Session.GetCreateGeneralRolesPage();

            createGeneralRolesPage.RemoveGeneralRoleAction(
                roleName: roleName,
                securityModule: securityModule,
                actionName: actionName);
        }

        public void LoginToELearningPage()
        {
            var window = Session.SwitchToBrowserWindowByName(Config.ELearningLoginTitle);
            var eLearningLoginPage = window.GetELearningLoginPage();
            
            eLearningLoginPage.GetUserNameTextBox().FillInWith("testuser");
            eLearningLoginPage.GetPasswordTextBox().FillInWith("password123");          
            eLearningLoginPage.GetLoginButton().Click();
        }
        
        public void LoginToHelpCenter()
        {
            var window = Session.SwitchToBrowserWindowByName("Login");
            var loginPage = window.GetHelpCenterPage();

            loginPage.GetUserNameTextBox().FillInWith(Config.AdminLogin);
            loginPage.GetPasswordTextBox().FillInWith(Config.AdminLoginPassword);
            loginPage.GetLoginButton().Click();
        }

        //TODO: move to page objects during refactor story
        public void GoToTaskPage()
        {
            Session.ClickLink("Tasks");
        }

        public void SelectCodingTask(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            SelectTaskGridByVerbatimName(verbatim);
        }

        public void SelectCodingTask(string verbatim, string field, string value)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(field)) throw new ArgumentNullException("field");
            if (String.IsNullOrEmpty(value)) throw new ArgumentNullException("value");
            
            Session
            .GetCodingTaskPage()
             .SelectTaskGridByVerbatimNameAndAdditionalField(verbatim, field, value);
        }

        public void ApproveCodingTask(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim"); 

            var codingTaskPage = Session.GetCodingTaskPage();

            codingTaskPage.SelectTaskGridByVerbatimName(verbatim);
            codingTaskPage.GetApproveButton().Click();
        }

        public void CommentOnSelectedCodingTask(string comment)
        {
            if (string.IsNullOrEmpty(comment)) { throw new ArgumentNullException("comment"); }
            var codingTaskPage = Session.GetCodingTaskPage();

            codingTaskPage.GetAddCommentButton().ClickWhenAvailable();
            codingTaskPage.GetReasonTextArea().SendKeys(comment ?? String.Empty);
            codingTaskPage.GetReasonOkButton().ClickWhenAvailable();
        }

        public void CommentOnCodingTask(string comment, string task)
        {
            if (string.IsNullOrEmpty(comment)) { throw new ArgumentNullException("comment"); }
            if (string.IsNullOrEmpty(task)) { throw new ArgumentNullException("task"); }

            var codingTaskPage = Session.GetCodingTaskPage();
            SelectTaskGridByVerbatimName(task);
            codingTaskPage.GetAddCommentButton().ClickWhenAvailable();
            codingTaskPage.GetReasonTextArea().SendKeys(comment ?? String.Empty);
            codingTaskPage.GetReasonOkButton().Click();
        }

        public void LoginToiMedidata(string username, string password)
        {
            if (String.IsNullOrEmpty(username)) throw new ArgumentNullException("userName");
            if (String.IsNullOrEmpty(password)) throw new ArgumentNullException("password");

            Session.GetIMedidataLoginPage().Login(username, password);
        }

        public void LoadiMedidataCoderAppSegment(string segmentName)
        {
            if (String.IsNullOrEmpty(segmentName)) throw new ArgumentNullException("segmentName");
            
            GoToiMedidataHome();

            Session.GetImedidataPage().LoadSegmentForApp(Config.ApplicationName, segmentName);
        }

        public void LoadiMedidataRaveModulesAppSegment(string segmentName)
        {
            if (String.IsNullOrEmpty(segmentName)) throw new ArgumentNullException("segmentName");

            GoToiMedidataHome();

            Session.GetImedidataPage().LoadSegmentForApp(ImedidataPage.RaveModulesAppName, segmentName);
        }

        public void LoadiMedidataRaveEdcAppSegment(string segmentName)
        {
            if (String.IsNullOrEmpty(segmentName)) throw new ArgumentNullException("segmentName");

            GoToiMedidataHome();

            Session.GetImedidataPage().LoadSegmentForApp(ImedidataPage.RaveEdcAppName, segmentName);
        }

        public void GoToiMedidataHome()
        {
            var coderHeader = Session.GetPageHeader();
            var raveHeader = Session.GetRaveHeader();
            var imedidataPage = Session.GetImedidataPage();

            bool coderActive = coderHeader.IMedidataLinkExists();
            bool raveActive = raveHeader.IMedidataLinkExists();
            bool imedidataActive = imedidataPage.IMedidataLinkExists();
            
            if (!coderActive && !raveActive && !imedidataActive)
            {
                throw new InvalidOperationException("IMedidata Link could not be found.");
            }

            if (coderActive)
            {
                coderHeader.GoToIMedidata();
            }

            if (raveActive)
            {
                raveHeader.GoToIMedidata();
            }

            if (imedidataActive)
            {
                imedidataPage.GoToIMedidata();
            }
        }
        
        public void LoginToRave(MedidataUser user)
        {
            if (ReferenceEquals(user, null)) throw new ArgumentNullException("user");

            Session.GetRaveLoginPage().Login(user);
        }
        
        public void AddSubjectToRaveStudy(RaveNavigationTarget target, string subjectInitials, string subjectId)
        {
            if (ReferenceEquals(target, null))              throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(subjectInitials)) throw new ArgumentNullException("subjectInitials");
            if (String.IsNullOrWhiteSpace(subjectId)) throw new ArgumentNullException("subjectId");

            var raveSitePage = Session.OpenRaveSite(target);

            raveSitePage.OpenAddSubjectPage();

            var raveAddSubjectPage = Session.GetRaveAddSubjectPage();
            
            var subjectNumber = subjectId.Replace(subjectInitials, "");
            
            raveAddSubjectPage.CreateNewSubjectWithNumber(subjectInitials, subjectNumber);

            Session.WaitForRaveNavigationLink(subjectId);
        }

        public string AddSubjectToRaveStudyWithManualId(RaveNavigationTarget target, string subjectInitials)
        {
            if (ReferenceEquals(target, null))              throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(subjectInitials)) throw new ArgumentNullException("subjectInitials");
            if (subjectInitials.Length != 3) throw new ArgumentException("subjectInitials must be three (3) characters");

            var raveSitePage = Session.OpenRaveSite(target);

            raveSitePage.OpenAddSubjectPage();

            var raveAddSubjectPage = Session.GetRaveAddSubjectPage();

            var subjectId = subjectInitials.CreateUniqueRaveSubjectId();

            raveAddSubjectPage.CreateNewSubject(subjectInitials, subjectId);

            Session.WaitForRaveNavigationLink(subjectId);

            return subjectId;
        }

        public void AddAdverseEvent(RaveNavigationTarget target, string adverseEventText)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(adverseEventText))        throw new ArgumentNullException("adverseEventText");
            
            var raveAdverseEventPage = Session.OpenRaveAdverseEvent(target);
            
            raveAdverseEventPage.CreateNewCoderAdverseEvent(adverseEventText);
        }
        
        public void CreateFormSubmission(RaveNavigationTarget target, IEnumerable<RaveFormInputData> formInputData)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (ReferenceEquals(formInputData, null))               throw new NullReferenceException("formInputData");
            
            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.CreateFormSubmission(formInputData);
        }

        public void CreateCodingSettingsSubmission(string dictionary, IEnumerable<RaveCodingSettingsModel> settingsInputData)
        {
            if (String.IsNullOrWhiteSpace(dictionary))    throw new ArgumentNullException("dictionary");
            if (ReferenceEquals(settingsInputData, null)) throw new NullReferenceException("settingsInputData");

            var raveCodingSettingsPage = Session.OpenRaveClinicalViewsCodingSettingsPage();

            raveCodingSettingsPage.CreateCodingSettingSubmission(dictionary, settingsInputData);
        }

        public void SetClinicalViewsModeForProject(string project, string mode)
        {
            if (String.IsNullOrWhiteSpace(project)) throw new ArgumentNullException("project");
            if (String.IsNullOrWhiteSpace(mode))    throw new ArgumentNullException("mode");

            var raveClinicalViewsPage = Session.OpenRaveClinicalViewsPage();

            raveClinicalViewsPage.SetModeForProject(project, mode);
        }

        public void GenerateReportForProject(string project, string dataSource, string form, string report)
        {
            if (String.IsNullOrWhiteSpace(project))    throw new ArgumentNullException("project");
            if (String.IsNullOrWhiteSpace(dataSource)) throw new ArgumentNullException("dataSource");
            if (String.IsNullOrWhiteSpace(form))       throw new ArgumentNullException("form");
            if (String.IsNullOrWhiteSpace(report))     throw new ArgumentNullException("report");

            var raveReportTypePage = Session.OpenRaveReportTypePage(report);
            raveReportTypePage.GenerateReportForProject(project);
            
            var options = Config.GetDefaultCoypuOptions();
            BrowserWindow window = Session.SwitchToBrowserWindowByName(_DataListingReportsBrowserWindowTitle, options);

            var dataListingPage = window.GetDataListingReportPage();
            dataListingPage.SetUpDDLValuesInDataListingReport(dataSource,form);
         }

        public DataTable GetCodingDecisionFromDataListingReport()
        {       
            var dataListingReportWindow = Session.SwitchToBrowserWindowByName(_DataListingReportsBrowserWindowTitle);
            var dataListingPage         = dataListingReportWindow.GetDataListingReportPage();

            DataTable codingDecisionsDataTable = dataListingPage.GetReportResultData();

            return codingDecisionsDataTable;
        }
        
        public void LockRaveForm(RaveNavigationTarget target, bool freezeForm, bool lockForm)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(target.FormName))         throw new ArgumentNullException("target.FormName");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.LockForm(freezeForm, lockForm);
        }

        public void LockRaveFormRow(RaveNavigationTarget target, string verbatimTerm, bool freezeForm, bool lockForm)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(verbatimTerm))            throw new ArgumentNullException("verbatimTerm");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.LockRow(verbatimTerm, freezeForm, lockForm);
        }

        public void UpdateForm(RaveNavigationTarget target, IEnumerable<RaveFormInputData> formInputData)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (ReferenceEquals(formInputData, null))               throw new NullReferenceException("formInputData");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.UpdateForm(formInputData);
        }

        public void UpdateLogLine(RaveNavigationTarget target, string logLineContents, IEnumerable<RaveFormInputData> formInputData)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(logLineContents))         throw new ArgumentNullException("logLineContents");
            if (ReferenceEquals(formInputData, null))               throw new NullReferenceException("formInputData");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.UpdateLogLine(logLineContents, formInputData);
        }

        public void UpdateLogLine(RaveNavigationTarget target, int logLineIndex, IEnumerable<RaveFormInputData> formInputData)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (logLineIndex < 1)                                   throw new ArgumentOutOfRangeException("logLineIndex cannot be less than 1");
            if (ReferenceEquals(formInputData, null))               throw new NullReferenceException("formInputData");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.UpdateLogLine(logLineIndex, formInputData);
        }

        public void RespondToQueryCommentInRave(RaveNavigationTarget target, string fieldName, string verbatimTerm, string queryResponse)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(fieldName))               throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(verbatimTerm))            throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrWhiteSpace(queryResponse))           throw new ArgumentNullException("queryResponse");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.RespondToQueryComment(fieldName, verbatimTerm, queryResponse);
        }

        public void CancelQueryCommentInRave(RaveNavigationTarget target, string fieldName, string verbatimTerm, string queryResponse=null)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(fieldName))               throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(verbatimTerm))            throw new ArgumentNullException("verbatimTerm");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.CancelQueryComment(fieldName, verbatimTerm, queryResponse);
        }

        public string GetRaveFormQueryComment(RaveNavigationTarget target, string fieldName, string verbatimTerm)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(fieldName))               throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(verbatimTerm))            throw new ArgumentNullException("verbatimTerm");

            var raveFormPage = Session.OpenRaveForm(target);

            string queryComment = raveFormPage.GetQueryComment(fieldName, verbatimTerm);

            return queryComment;
        }

        public IEnumerable<TermPathRow> GetCodingDecisionFromRaveAuditRecords(RaveNavigationTarget target, string fieldName, string verbatimTerm)
        {
            if (ReferenceEquals(target, null))           throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(fieldName))    throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            var raveFormPage = Session.OpenRaveForm(target);
            var auditPage    = Session.GetRaveAuditsPage();

            raveFormPage.ViewAuditLog(verbatimTerm);

            IEnumerable<TermPathRow> codingDecisions = auditPage.GetCodingDecisionFromAuditRecord(fieldName);

            return codingDecisions;
        }

        public IEnumerable<TermPathRow> GetCodingDecisionFromRaveForm(RaveNavigationTarget target, string rowContents, string verbatimTerm)
        {
            if (ReferenceEquals(target, null))           throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(rowContents))  throw new ArgumentNullException("rowContents");
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            var raveFormPage                         = Session.OpenRaveForm(target);

            IEnumerable<TermPathRow> codingDecisions = raveFormPage.GetCodingDecision(rowContents, verbatimTerm);

            return codingDecisions;
        }

        public string GetQueryCommentFromRaveAuditRecords(RaveNavigationTarget target, string fieldName, string verbatimTerm)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(fieldName))               throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(verbatimTerm))            throw new ArgumentNullException("verbatimTerm");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.ViewAuditLog(verbatimTerm);

            var auditPage = Session.GetRaveAuditsPage();

            string queryComment = auditPage.GetQueryCommentFromAuditRecord(fieldName);

            return queryComment;
        }

        public void WaitUntilAdverseEventTransmitted(RaveNavigationTarget target, string adverseEventText, int adverseEventOccurrence = 1)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(adverseEventText))        throw new ArgumentNullException("adverseEventText");
            if (adverseEventOccurrence <= 0)                        throw new ArgumentException("adverseEventOccurrence must be greater than 0.");

            var raveAuditsPage = Session.OpenRaveAuditsPageForAdverseEvent(target, adverseEventText, adverseEventOccurrence);

            raveAuditsPage.WaitUntilTermSent("Coder AE");
        }

        public string GetAdverseEventCodedPathFromRaveAuditRecords(RaveNavigationTarget target, string adverseEventText, int adverseEventOccurrence = 1)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(adverseEventText))        throw new ArgumentNullException("adverseEventText");
            if (adverseEventOccurrence <= 0)                        throw new ArgumentException("adverseEventOccurrence must be greater than 0.");

            var raveAuditsPage = Session.OpenRaveAuditsPageForAdverseEvent(target, adverseEventText, adverseEventOccurrence);

            string codedPath = raveAuditsPage.GetCodedPathFromAuditRecord("Coder AE");

            return codedPath;
        }

        public void InactivateRaveFormLogLine(RaveNavigationTarget target, string rowContents)
        {
            if (ReferenceEquals(target, null))          throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.InactivateLogLine(rowContents);
        }

        public void ReactivateRaveFormLogLine(RaveNavigationTarget target, string rowContents)
        {
            if (ReferenceEquals(target, null))          throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.ReactivateLogLine(rowContents);
        }

        public void InactivateRaveForm(RaveNavigationTarget target)
        {
            if (ReferenceEquals(target, null))          throw new ArgumentNullException("target");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.InactivateForm();
        }

        public void ReactivateRaveForm(RaveNavigationTarget target)
        {
            if (ReferenceEquals(target, null))          throw new ArgumentNullException("target");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.ReactivateForm();
        }
        
        public void MarkRaveFormRowWithQuery(RaveNavigationTarget target, string rowContents)
        {
            if (ReferenceEquals(target, null)) throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.MarkRowWithQuery(rowContents);
        }

        public void MarkRaveFormRowWithSticky(RaveNavigationTarget target, string rowContents)
        {
            if (ReferenceEquals(target, null)) throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.MarkRowWithSticky(rowContents);
        }

        public void MarkRaveFormRowWithProtocolDeviation(RaveNavigationTarget target, string rowContents)
        {
            if (ReferenceEquals(target, null)) throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var raveFormPage = Session.OpenRaveForm(target);

            raveFormPage.MarkRowWithProtocolDeviation(rowContents);
        }

        public void AddAuditLogEntryToRaveFormRow(RaveNavigationTarget target, string rowContents, string fieldName, string auditLogEntry)
        {
            if (ReferenceEquals(target, null))            throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(rowContents))   throw new ArgumentNullException("rowContents");
            if (String.IsNullOrWhiteSpace(fieldName))     throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(auditLogEntry)) throw new ArgumentNullException("auditLogEntry");

            var raveAuditPage = Session.OpenRaveAuditsPageForFormRow(target, rowContents);

            raveAuditPage.DisplayChildsAuditRecords(fieldName);

            raveAuditPage.AddEntry(auditLogEntry);
        }

        public void GetAccessToConfigModule(String userName)
        {
            if (String.IsNullOrEmpty(userName)) throw new ArgumentNullException("userName");

            Session.OpenRaveUserAdministrationPage().GetAccessToConfigModule(userName);
        }


        public void EditGlobalRaveConfiguration(RaveCoderGlobalConfiguration configurationSetting)
        {
            if (ReferenceEquals(configurationSetting, null)) throw new ArgumentNullException("configurationSettings");

            var otherSettingsCoderPage = Session.OpenRaveConfigurationOtherSettingsCoderPage();

            otherSettingsCoderPage.SetCoderOtherSettingsCoderPageDefaults(configurationSetting);

        }
        
        public void AssignUserToStudy(String userName, String roleName, String study)
        {
            if (String.IsNullOrEmpty(userName)) throw new ArgumentNullException("userName");
            if (String.IsNullOrEmpty(roleName)) throw new ArgumentNullException("roleName");
            if (String.IsNullOrEmpty(study)) throw new ArgumentNullException("study");

            Session.OpenRaveUserAdministrationPage().AssignUserToStudy(userName, roleName, study);
        }

        public bool UploadConfigurationFileInRaveModules(string csvFileName)
        {
            if (String.IsNullOrEmpty(csvFileName)) throw new ArgumentNullException("csvFileName");

            bool uploadSuccessful = Session.OpenRaveConfigurationLoaderPage().UploadConfigFile(csvFileName);

            return uploadSuccessful;
        }

        public void AddRaveArchitectDraft(string study, string draftName)
        {
            if (String.IsNullOrEmpty(study)) throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(draftName)) throw new ArgumentNullException("draftName");

            var addNewDraftPage = Session.OpenRaveArchitectAddNewDraftPage(study);

            addNewDraftPage.CreateDraft(draftName);
        }

        public void DeleteRaveArchitectDraft(string study, string draftName)
        {
            if (String.IsNullOrEmpty(study)) throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(draftName)) throw new ArgumentNullException("draftName");
            
            var raveArchitectProjectPage = Session.OpenRaveArchitectProjectPage(study);

            if (raveArchitectProjectPage.DoesDraftExist(draftName))
            {
                raveArchitectProjectPage.DeleteDraft(draftName);
            }
        }
            
        public void UploadRaveArchitectDraftTemplate(string studyName, string draftName, string draftTemplateFilePath, string targetDirectory)
        {
            if (String.IsNullOrWhiteSpace(studyName))             throw new ArgumentNullException("studyName");
            if (String.IsNullOrWhiteSpace(draftName))             throw new ArgumentNullException("draftName");
            if (String.IsNullOrWhiteSpace(draftTemplateFilePath)) throw new ArgumentNullException("draftTemplateFilePath");
            if (String.IsNullOrWhiteSpace(targetDirectory))       throw new ArgumentNullException("targetDirectory");

            var draftFilePath = BrowserUtility.CreateDraftFile(studyName, draftName, draftTemplateFilePath, targetDirectory);

            DeleteRaveArchitectDraft(studyName, draftName);

            var raveArchitectUploadDraftPage = Session.OpenRaveArchitectUploadDraftPage();

            raveArchitectUploadDraftPage.UploadDraftFile(draftFilePath);
        }
        
        public void UploadRaveArchitectDraft(string study, string draftName, string draftFilePath)
        {
            if (String.IsNullOrEmpty(study)) throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(draftName)) throw new ArgumentNullException("draftName");
            if (String.IsNullOrEmpty(draftFilePath)) throw new ArgumentNullException("draftFilePath");
            
            DeleteRaveArchitectDraft(study, draftName);    

            var raveArchitectUploadDraftPage = Session.GetRaveArchitectUploadDraftPage();
            
            raveArchitectUploadDraftPage.UploadDraftFile(draftFilePath);
        }
        
        public string PublishAndPushRaveArchitectDraft (string study, string draftName, string environment) 
        {
            if (String.IsNullOrEmpty(study))         throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(draftName))     throw new ArgumentNullException("draftName");
            if (String.IsNullOrEmpty(environment))   throw new ArgumentNullException("environment");
            
            var draftVersion = PublishRaveArchitectDraft(study, draftName);

            var raveArchitectProjectPage = Session.OpenRaveArchitectProjectPage(study);

            raveArchitectProjectPage.OpenCRFPushDraftPage(draftVersion);

            var crfPushPage = Session.GetRaveArchitectCRFDraftPushPage();

            crfPushPage.PushDraft(environment);

            return draftVersion;
        }

        public string PublishRaveArchitectDraft(string study, string draftName)
        {
            if (String.IsNullOrEmpty(study))     throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(draftName)) throw new ArgumentNullException("draftName");

            var raveArchitectProjectPage = Session.OpenRaveArchitectProjectPage(study);

            raveArchitectProjectPage.OpenDraft(draftName);

            var draftVersion = Session.GetRaveArchitectCRFDraftPage().PublishDraft();

            return draftVersion;
        }

        internal SessionElementScope GetPushMessage()
        {
            var pushMessage = Session.FindSessionElementById("_ctl0_Content_SuccessMessageLBL");

            return pushMessage;
        }

        public string GetCRFPushExpectedSuccessMessage()
        {
            var pushMessage = GetPushMessage();

            var successMessage = pushMessage.Text;

            return successMessage;
        }
        
        public bool MigrateRaveArchitectDraftVersion(string studyName, string sourceDraftVersionName, string targetDraftVersionName)
        {
            if (String.IsNullOrWhiteSpace(studyName))              throw new ArgumentNullException("studyName");
            if (String.IsNullOrWhiteSpace(sourceDraftVersionName)) throw new ArgumentNullException("sourceDraftVersionName");
            if (String.IsNullOrWhiteSpace(targetDraftVersionName)) throw new ArgumentNullException("targetDraftVersionName");

            var migrationSuccessful = false;
            
            var raveArchitectAmendmentManagerPage = Session.OpenRaveArchitectAmendmentManagerPage(studyName);
            
            var createPlanSuccessful = raveArchitectAmendmentManagerPage.CreatePlan(sourceDraftVersionName, targetDraftVersionName);
            
            if (createPlanSuccessful)
            {
                var raveNavigation = Session.GetRaveNavigation();

                raveNavigation.OpenArchitectExecuteAmendmentMigrationPlanPage();

                var raveArchitectExecuteAmendmentMigrationPlanPage = Session.GetRaveArchitectExecuteAmendmentMigrationPlanPage();

                migrationSuccessful = raveArchitectExecuteAmendmentMigrationPlanPage.ExecuteMigrationPlan();
            }

            return migrationSuccessful;
        }

        public void AddRaveCRFCopySource(string targetStudyName, string copySourceType, string sourceStudyName, string sourceDraftName)
        {
            if (String.IsNullOrWhiteSpace(targetStudyName))      throw new ArgumentNullException("targetStudyName");
            if (String.IsNullOrWhiteSpace(copySourceType))       throw new ArgumentNullException("copySourceType");
            if (String.IsNullOrWhiteSpace(sourceStudyName))      throw new ArgumentNullException("sourceStudyName");
            if (String.IsNullOrWhiteSpace(sourceDraftName))      throw new ArgumentNullException("sourceDraftName");

            Session.OpenRaveArchitectProjectPage(targetStudyName);

            var raveNavigation = Session.GetRaveNavigation();

            raveNavigation.OpenArchitectDefineCopySourcesPage();

            var raveArchitectCopySourcesPage = Session.GetRaveArchitectCopySourcesPage();

            raveArchitectCopySourcesPage.AddCopySource(copySourceType, sourceStudyName, sourceDraftName);
        }
        
        public void CreateNewCRFDraftCopy(string targetStudyName, string targetDraftName, string sourceDraftName)
        {
            if (String.IsNullOrEmpty(targetStudyName))       throw new ArgumentNullException("targetStudyName");
            if (String.IsNullOrEmpty(targetDraftName))       throw new ArgumentNullException("targetDraftName");
            if (String.IsNullOrEmpty(sourceDraftName))       throw new ArgumentNullException("sourceDraftName");

            DeleteRaveArchitectDraft(targetStudyName, targetDraftName);
            
            AddRaveArchitectDraft(targetStudyName, targetDraftName);

            var target = new RaveArchitectRecordTarget
            {
                StudyName = targetStudyName,
                DraftName = targetDraftName
            };

            Session.OpenRaveArchitectCRFDraftPage(target);

            var raveNavigation = Session.GetRaveNavigation();

            raveNavigation.OpenArchitectCopyDraftWizardPage();

            var raveArchitectCopyDraftWizardPage = Session.GetRaveArchitectCopyDraftWizardPage();

            raveArchitectCopyDraftWizardPage.CopyDraft(sourceDraftName);
        }

        public void SetCoderConfigurationForRaveFields(RaveArchitectRecordTarget target, IList<RaveCoderFieldConfiguration> coderConfigurations)
        {
            if (ReferenceEquals(target, null))                 throw new ArgumentNullException("target");
            if (ReferenceEquals(coderConfigurations,null))     throw new ArgumentNullException("coderConfigurations");

            foreach (var coderConfiguration in coderConfigurations)
            {
                target.FormName = coderConfiguration.Form;

                var raveFormPage = Session.OpenRaveArchitectFormPage(target);

                raveFormPage.SetCoderCodingDictionary(coderConfiguration.Field, coderConfiguration.Dictionary);
                
                raveFormPage.OpenRaveCoderConfiguration(coderConfiguration.Field);

                var raveCoderConfigurationPage = Session.GetRaveCoderConfigurationPage();

                raveCoderConfigurationPage.SetCoderConfiguration(coderConfiguration);
            }
        }
        
        public IList<RaveCoderFieldConfiguration> GetCoderConfigurationForRaveFields(RaveArchitectRecordTarget target, IList<RaveCoderFieldConfiguration> expectedCoderConfigurations)
        {
            if (ReferenceEquals(target, null))                      throw new ArgumentNullException("target");
            if (ReferenceEquals(expectedCoderConfigurations, null)) throw new ArgumentNullException("expectedCoderConfigurations");

            var actualCoderConfigurations = new List<RaveCoderFieldConfiguration>();

            foreach (var expectedCoderConfiguration in expectedCoderConfigurations)
            {
                target.FormName  = expectedCoderConfiguration.Form;
                target.FieldName = expectedCoderConfiguration.Field;
                
                var actualCoderConfiguration = GetCoderConfigurationForRaveField(target);
                
                actualCoderConfigurations.Add(actualCoderConfiguration);
            }

            return actualCoderConfigurations;
        }

        public RaveCoderFieldConfiguration GetCoderConfigurationForRaveField(RaveArchitectRecordTarget target)
        {
            if (ReferenceEquals(target, null))               throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(target.FormName))  throw new ArgumentNullException("target.FormName");
            if (String.IsNullOrWhiteSpace(target.FieldName)) throw new ArgumentNullException("target.FieldName");

            string formName  = target.FormName;
            string fieldName = target.FieldName;
            
            var raveFormPage = Session.OpenRaveArchitectFormPage(target);

            var dictionary = raveFormPage.GetCoderCodingDictionary(fieldName);

            RaveCoderFieldConfiguration actualCoderConfiguration = new RaveCoderFieldConfiguration();

            if (!String.IsNullOrWhiteSpace(dictionary))
            {
                raveFormPage.OpenRaveCoderConfiguration(fieldName);

                var raveCoderConfigurationPage = Session.GetRaveCoderConfigurationPage();

                actualCoderConfiguration = raveCoderConfigurationPage.GetCoderConfiguration();

                actualCoderConfiguration.Dictionary = dictionary;
            }
            
            actualCoderConfiguration.Form       = formName;
            actualCoderConfiguration.Field      = fieldName;

            return actualCoderConfiguration;
        }

        public void SetCodingDictionaryForRaveField(RaveArchitectRecordTarget target, string dictionaryName)
        {
            if (ReferenceEquals(target, null))               throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(target.FieldName)) throw new ArgumentNullException("target.FieldName");
            if (String.IsNullOrWhiteSpace(dictionaryName))   throw new ArgumentNullException("dictionaryName");

            var raveFormPage = Session.OpenRaveArchitectFormPage(target);

            raveFormPage.SetCodingDictionary(target.FieldName, dictionaryName);
        }
        
        public void SetSupplementalTermsForRaveFields(RaveArchitectRecordTarget target, IList<RaveCoderSupplementalConfiguration> coderSupplementalConfigurations)
        {
            if (ReferenceEquals(target, null)) throw new ArgumentNullException("target");
            if (ReferenceEquals(coderSupplementalConfigurations, null)) throw new ArgumentNullException("coderSupplementalConfigurations");

            Session.OpenRaveArchitectCRFDraftPage(target);
            
            var formFieldGroups =
                    from coderSupplementalConfiguration in coderSupplementalConfigurations
                    group coderSupplementalConfiguration.SupplementalTerm by new { coderSupplementalConfiguration.Form, coderSupplementalConfiguration.Field } into fields
                    select fields;
            
            foreach (var formFieldGroup in formFieldGroups)
            {
                target.FormName = formFieldGroup.Key.Form;
                var raveFormPage = Session.OpenRaveArchitectFormPage(target);

                raveFormPage.OpenRaveCoderConfiguration(formFieldGroup.Key.Field);
                var raveCoderConfigurationPage = Session.GetRaveCoderConfigurationPage();
                
                foreach (var supplementalTerm in formFieldGroup)
                {
                    raveCoderConfigurationPage.AddSupplementalTerm(supplementalTerm);
                }
            }
        }

        public void RemoveSupplementalTermFromRaveField(RaveArchitectRecordTarget target, string supplementalTerm)
        {
            if (ReferenceEquals(target, null))               throw new ArgumentNullException("target");
            if (String.IsNullOrWhiteSpace(supplementalTerm)) throw new ArgumentNullException("supplementalTerm");

            var raveFormPage = Session.OpenRaveArchitectFormPage(target);

            raveFormPage.OpenRaveCoderConfiguration(target.FieldName);
            var raveCoderConfigurationPage = Session.GetRaveCoderConfigurationPage();

            raveCoderConfigurationPage.RemoveSupplementalTerm(supplementalTerm);
        }
    
        public void VerifyConfigUploadResult(String message)
        {
            if (String.IsNullOrEmpty(message)) throw new ArgumentNullException("message");

            if (Session.OpenRaveConfigurationLoaderPage().VerifyConfigUploadHasCompleted(message))
                Assert.Pass();
            else
                Assert.Fail();
        }

        public void EnrollSegment(string setupSegment, string newGeneratedSegment)
        {
            if (String.IsNullOrEmpty(setupSegment))        throw new ArgumentNullException("setupSegment");
            if (String.IsNullOrEmpty(newGeneratedSegment)) throw new ArgumentNullException("newGeneratedSegment");

            LoadiMedidataCoderAppSegment(setupSegment);
            
            Session.GetAdminSegmentManagementPage().EnrollSegment(newGeneratedSegment);
        }

        public void RolloutDictionary(String newGeneratedSegment, String dictionaryName)
        {
            if (String.IsNullOrEmpty(newGeneratedSegment)) throw new ArgumentNullException("newGeneratedSegment");
            if (String.IsNullOrEmpty(dictionaryName)) throw new ArgumentNullException("dictionaryName");

            Session.GetAdminMedidataAdminConsolePage().RolloutDictionary(newGeneratedSegment, dictionaryName);
        }

        public void CoderCoreLogin(string userName)
        {
            if (String.IsNullOrEmpty(userName)) throw new ArgumentNullException("userName");

            Session.Visit(Config.AppHost);

            var loginPage = Session.GetCoderLoginPage();
            loginPage.LoginAs(userName);
        }

        public void Logout()
        {
            GoToiMedidataHome();

            bool successfulLogout = Session.GetImedidataPage().Logout();

            if (!successfulLogout)
            {
            Session.Visit("/logout");
        }

            RetryPolicy.FindElement.Execute(
                () =>
                {
                    if (!Session.Text.Contains("logged out", StringComparison.OrdinalIgnoreCase))
                    {
                        throw new MissingHtmlException("Logout still in progress");
                    }
                });
        }

        public void LogoutOfCoderAndImedidata()
        {
            GoToTaskPage();
            
            var pageHeader = Session.GetPageHeader();

            pageHeader.LogoutFromCoder();

            Logout();
        }

        //TODO: moved to page object for coding task page, remove this method during refactor story since its still being used
        public void SelectSourceTermTab()
        {
            Session
                .GetCodingTaskPage()
                .GetSourceTermsTab()
                .Click();
        }

        //TODO: moved to page object for coding task page, remove this method during refactor story since its still being used
        internal void SelectTaskGridByVerbatimName(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim"); 

            Session
                .GetCodingTaskPage()
                .SelectTaskGridByVerbatimName(verbatim);
        }

        //TODO: moved to page object for coding task page, remove this method during refactor story since its still being used
        public void SelectAssignmentTab()
        {
            Session
                .GetCodingTaskPage()
                .GetAssignmentsTab()
                .ClickWhenAvailable();
        }

        //TODO: moved to page object for coding task page, remove this method during refactor story since its still being used
        public void SelectPropertiesTab()
        {
            Session
                .GetCodingTaskPage()
                .GetPropertiesTab()
                .ClickWhenAvailable();
        }

        public void ReCodeTask(string verbatimTerm, string comment)
        {
            if (String.IsNullOrEmpty(verbatimTerm)) throw new ArgumentNullException("verbatimTerm"); 
            if (String.IsNullOrEmpty(comment)) throw new ArgumentNullException("comment");

            var codingTaskPage = Session.GetCodingTaskPage();

            codingTaskPage.InitiateReCode(verbatimTerm);

            codingTaskPage.GetReasonTextArea().FillInWith(comment);
            codingTaskPage.GetReasonOkButton().Click();

            SelectTaskGridByVerbatimName(verbatimTerm);
        }

        public void ReclassifyTask(string verbatim, string comment, string includeAutoCodedItems, ReclassificationTypes reclassificationType)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(comment)) throw new ArgumentNullException("comment");
            if (String.IsNullOrEmpty(includeAutoCodedItems)) throw new ArgumentNullException("includeAutoCodedItems");
            
            var reclassificationPage = Session.GetCodingReclassificationPage();
            reclassificationPage.GoTo();

            reclassificationPage
                .GetIncludeAutoCodedItemsCheckBox()
                .SetCheckBoxState(includeAutoCodedItems);

            reclassificationPage.GetVerbatimTextBox().FillInWith(verbatim);

            RetryPolicy.FindElement.Execute(() =>
                reclassificationPage.SearchAndSelectVerbatimRow(verbatim));

            reclassificationPage.GetReclassifyButtonByType(reclassificationType).Click();
            reclassificationPage.GetReasonTextArea().FillInWith(comment);
            reclassificationPage.GetReasonOkButton().Click();
        }

        public void ReclassifyTask(ReclassificationSearchCriteria reclassificationSearchCriteria, string comment, ReclassificationTypes reclassificationType)
        {
            if (ReferenceEquals(reclassificationSearchCriteria, null)) throw new ArgumentNullException("reclassificationSearchCriteria");
            if (String.IsNullOrEmpty(reclassificationSearchCriteria.Verbatim)) throw new ArgumentNullException("reclassificationSearchCriteria.Verbatim");
            if (String.IsNullOrEmpty(comment)) throw new ArgumentNullException("comment");

            PerformReclassificationSearch(reclassificationSearchCriteria);

            var reclassificationPage = Session.GetCodingReclassificationPage();

            RetryPolicy.FindElement.Execute(() =>
                reclassificationPage.SearchAndSelectVerbatimRow(reclassificationSearchCriteria.Verbatim));

            reclassificationPage.GetReclassifyButtonByType(reclassificationType).Click();
            reclassificationPage.GetReasonTextArea().FillInWith(comment);
            reclassificationPage.GetReasonOkButton().Click();
        }

        public void PerformReclassificationSearch(ReclassificationSearchCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException("searchCriteria");

            var codingReclassificationPage = Session.GetCodingReclassificationPage();
            codingReclassificationPage.GoTo();

            codingReclassificationPage.SetSearchCritera(searchCriteria);
            codingReclassificationPage.GetSearchButton().Click();
        }

        public void RejectCodingDecision(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim"); 

            var codingTaskPage = Session.GetCodingTaskPage();

            codingTaskPage.SelectTaskGridByVerbatimName(verbatim);
            codingTaskPage.GetRejectCodingDecisionButton().Click();
            codingTaskPage.ClearFilters();
        }

        public string GetSelectedCodingTaskTab()
        {
            var selectedTabName = Session.GetCodingTaskPage().GetSelectedTabName();

            return selectedTabName;
        }

        public void SetConfigurationManagementValuesWithFeatureSetupType(
            string configurationType,
            string medicalDictionaryName)
        {
            if (String.IsNullOrWhiteSpace(configurationType)) throw new ArgumentNullException("configurationType");
            if (String.IsNullOrWhiteSpace(medicalDictionaryName)) throw new ArgumentNullException("medicalDictionaryName");

            var coderTestContext = Session.GetCoderTestContext();
            var coderConfiguration = coderTestContext.GetCoderConfiguration(configurationType);
            var configurationManagementPage = Session.GetAdminConfigurationManagementPage();

            configurationManagementPage.GoTo();
            configurationManagementPage.GetCodingTab().Click();

            configurationManagementPage
                .GetForcePrimaryPathSelectionCheckBox()
                .SetCheckBoxState(coderConfiguration.ForcePrimaryPathSelection);

            configurationManagementPage
                .GetSynonymCreationPolicyFlagDropDownList()
                .SelectOption(coderConfiguration.SynonymCreationPolicyFlag);

            configurationManagementPage
                .GetBypassReconsiderUponReclassifyCheckBox()
                .SetCheckBoxState(coderConfiguration.BypassReconsiderUponReclassifyFlag);

            configurationManagementPage.GetSaveButton().Click();

            bool isAutoAddSynonym = coderConfiguration.IsAutoAddSynonym.EqualsIgnoreCase("True");
            bool isAutoApproval = coderConfiguration.IsAutoApproval.EqualsIgnoreCase("True");

            SetDictionaryConfigurationAutoAddSynonymsCheckbox(medicalDictionaryName, isAutoAddSynonym);
            SetDictionaryConfigurationAutoApproveCheckbox(medicalDictionaryName, isAutoApproval);
        }

        public void SetConfigurationFunctionalityTextboxByTextboxName(string textboxName, int value)
        {
            if (String.IsNullOrEmpty(textboxName)) throw new ArgumentNullException("textboxName"); 

            var adminConfigurationManagementPage = Session.GetAdminConfigurationManagementPage();

            adminConfigurationManagementPage.GetCodingTab().ClickWhenAvailable();

            var textbox = adminConfigurationManagementPage.GetTextboxElementByTextboxName(textboxName);

            textbox.FillInWith(value.ToString());

            adminConfigurationManagementPage.GetSaveButton().ClickWhenAvailable();
        }

        public void SetConfigurationFunctionalityForcePrimaryPathSelectionCheckbox(bool value)
        {
            Session.GetAdminConfigurationManagementPage().SetConfigurationFunctionalityForcePrimaryPathSelectionCheckbox(value);
        }

        public void SetConfigurationFunctionalityBypassReconsiderUponReclassifyCheckbox(bool value)
        {
            Session.GetAdminConfigurationManagementPage().SetConfigurationFunctionalityBypassReconsiderUponReclassifyCheckbox(value);
        }

        public void SetConfigurationFunctionalitySynonymCreationPolicyFlagDropDown(string value)
        {
            if (String.IsNullOrEmpty(value)) throw new ArgumentNullException("value");

            Session.GetAdminConfigurationManagementPage().SetConfigurationFunctionalitySynonymCreationPolicyFlagDropDown(value);
        }

        public void SetDictionaryConfigurationAutoAddSynonymsCheckbox(string medicalDictionaryName, bool value)
        {
            if (String.IsNullOrEmpty(medicalDictionaryName)) throw new ArgumentNullException("medicalDictionaryName");

            Session.GetAdminConfigurationManagementPage().SetDictionaryConfigurationAutoAddSynonymsCheckbox(medicalDictionaryName, value);
        }

        public void SetDictionaryConfigurationAutoApproveCheckbox(string medicalDictionaryName, bool value)
        {
            if (String.IsNullOrEmpty(medicalDictionaryName)) throw new ArgumentNullException("medicalDictionaryName");

            Session.GetAdminConfigurationManagementPage().SetDictionaryConfigurationAutoApproveCheckbox(medicalDictionaryName, value);
        }

        public string GetAdminConfigurationManagementPageWarningMessage()
        {
            var adminConfigurationManagementPage = Session.GetAdminConfigurationManagementPage();

            if (!adminConfigurationManagementPage.IsHeaderWarningMessageVisible())
            {
                return string.Empty;
            }

            var warningMessage = adminConfigurationManagementPage.GetHeaderWarningMessage().InnerHTML;

            return warningMessage;
        }

        public string GetAdminConfigurationManagementPageTextboxLimitLabelByTextboxName(string textboxName)
        {
            if (String.IsNullOrEmpty(textboxName)) throw new ArgumentNullException("textboxName"); 

            var adminConfigurationManagementPage = Session.GetAdminConfigurationManagementPage();

            var limitLabel = adminConfigurationManagementPage.GetTextboxLimitLabelElementByTextboxName(textboxName).InnerHTML;

            return limitLabel;
        }

        public void MigrateSynonymList(SynonymList sourceSynonymList, SynonymList targetSynonymList)
        {
            if (ReferenceEquals(sourceSynonymList, null)) throw new ArgumentNullException("sourceSynonymList");
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            var adminSynonymPage = Session.OpenAdminSynonymPage();

            adminSynonymPage.SelectSynonymList(targetSynonymList);
            
            UpgradeSynonymListByName(sourceSynonymList, targetSynonymList);

            adminSynonymPage.WaitForSynonymPageActivityToComplete(targetSynonymList.SynonymListName);
        }

        public void UpgradeSynonymListByName(SynonymList sourceSynonymList, SynonymList targetSynonymList)
        {
            if (ReferenceEquals(sourceSynonymList, null)) throw new ArgumentNullException("sourceSynonymList");
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            var adminSynonymPage = Session.OpenAdminSynonymPage();

            adminSynonymPage
                .GetUpgradeSynonymListLinkByListName(targetSynonymList.SynonymListName)
                .Click();

            adminSynonymPage
                .GetMigrateListFromVersionDropDownList()
                .SelectOption(sourceSynonymList.Version);

            adminSynonymPage
                .GetMigrateListFromListNameDropDownList()
                .SelectOption(sourceSynonymList.SynonymListName);

            adminSynonymPage
                .GetMigrateButton()
                .Click();
        }

        public void CreateSynonymList(SynonymList synonymList)
        {
            if (ReferenceEquals(synonymList, null)) throw new ArgumentNullException("synonymList");

            var adminSynonymPage = Session.OpenAdminSynonymPage();

            adminSynonymPage.SelectSynonymList(synonymList);
            adminSynonymPage.GetAddNewButton().ClickWhenAvailable();
            adminSynonymPage.GetEditingRowListNameTextBox().FillInWith(synonymList.SynonymListName);
            adminSynonymPage.GetEditingRowSaveButton().Click();
            adminSynonymPage.GetUpgradeSynonymListLinkByListName(synonymList.SynonymListName).Click();
            adminSynonymPage.GetStartNewSynonymListButton().Click();
        }
        
        public void AcceptSynonymSuggestion(SynonymList targetSynonymList, string categoryType, string synonymName)
        {
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            var adminSynonymMigrationPage = Session.OpenAdminSynonymMigrationPage(targetSynonymList);

            adminSynonymMigrationPage.GetCategoryRowNotMigratedCountButtonByCategoryType(categoryType).Click();
            adminSynonymMigrationPage.GetSynonymSuggestionRowBySynonymName(synonymName).Click();
            adminSynonymMigrationPage.GetAcceptSuggestionButton().Click(); 
        }

        public void AcceptNoClearMatchSynonymSuggestion(SynonymList targetSynonymList, string categoryType, string synonymName)
        {
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            var adminSynonymMigrationPage = Session.OpenAdminSynonymMigrationPage(targetSynonymList);

            adminSynonymMigrationPage.GetCategoryRowNotMigratedCountButtonByCategoryType(categoryType).Click();
            adminSynonymMigrationPage.GetSynonymSuggestionRowBySynonymName(synonymName).Click();
            adminSynonymMigrationPage.GetSynonymSuggestionRowExpanderBySynonymName(synonymName).Click();
            adminSynonymMigrationPage.GetAcceptSuggestionLinkInExpandedSynonymSuggestionRow().Click();
        }

        public void DropSynonym(SynonymList targetSynonymList, string categoryType, string synonymName)
        {
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            var adminSynonymMigrationPage = Session.OpenAdminSynonymMigrationPage(targetSynonymList);

            adminSynonymMigrationPage.GetCategoryRowNotMigratedCountButtonByCategoryType(categoryType).Click();
            adminSynonymMigrationPage.GetSynonymSuggestionRowBySynonymName(synonymName).Click();
            adminSynonymMigrationPage.GetDropSynonymButton().Click();
        }

        public void AcceptDeclinedSynonym(SynonymList targetSynonymList, string categoryType, string synonymName)
        {
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            var adminSynonymMigrationPage = Session.OpenAdminSynonymMigrationPage(targetSynonymList);

            adminSynonymMigrationPage.GetCategoryRowDeclinedMigratedCountButtonByCategoryType(categoryType).Click();
            adminSynonymMigrationPage.GetSynonymSuggestionRowBySynonymName(synonymName).Click();
            adminSynonymMigrationPage.GetAcceptSuggestionButton().Click();
        }

        public void MigrateSynonyms(SynonymList targetSynonymList)
        {
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            Session
                .OpenAdminSynonymMigrationPage(targetSynonymList)
                .GetMigrateSynonymsButton()
                .Click();

            var adminSynonymPage = Session.OpenAdminSynonymPage();

            adminSynonymPage.SelectSynonymList(targetSynonymList);
            adminSynonymPage.WaitForSynonymPageActivityToComplete(targetSynonymList.SynonymListName);
        }

        public void AcceptSynonymsByCategoryTypeAndCount(SynonymList targetSynonymList, string categoryType, int synonymsToAcceptCount)
        {
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");

            var adminSynonymMigrationPage = Session.OpenAdminSynonymMigrationPage(targetSynonymList);
            
            for (var i = 0; i < synonymsToAcceptCount; i++)
            {
                adminSynonymMigrationPage.GetCategoryRowNotMigratedCountButtonByCategoryType(categoryType).Click();
                adminSynonymMigrationPage.GetFirstSynonymSuggestionRowExpander().Click();
                adminSynonymMigrationPage.GetAcceptSuggestionLinkInExpandedSynonymSuggestionRow().Click();
            }
        }

        public void AcceptDeclinedSynonymsByCategoryTypeAndCount(SynonymList targetSynonymList, string categoryType, int synonymsToAcceptCount)
        {
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");

            var adminSynonymMigrationPage = Session.OpenAdminSynonymMigrationPage(targetSynonymList);
            
            for (var i = 0; i < synonymsToAcceptCount; i++)
            {
                adminSynonymMigrationPage.GetCategoryRowDeclinedMigratedCountButtonByCategoryType(categoryType).Click();
                adminSynonymMigrationPage.GetFirstSynonymSuggestionRowExpander().Click();
                adminSynonymMigrationPage.GetAcceptSuggestionLinkInExpandedSynonymSuggestionRow().Click();
            }
        }

        public void DropSynonymsByCategoryTypeAndCount(SynonymList targetSynonymList, string categoryType, int synonymsToDropCount)
        {
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");

            var adminSynonymMigrationPage = Session.OpenAdminSynonymMigrationPage(targetSynonymList);

            for (var i = 0; i < synonymsToDropCount; i++)
            {
                adminSynonymMigrationPage.GetCategoryRowNotMigratedCountButtonByCategoryType(categoryType).Click();
                adminSynonymMigrationPage.GetFirstSynonymSuggestionRow().Click();
                adminSynonymMigrationPage.GetDropSynonymButton().Click();
            }
        }

        public void DropMigratedSynonymsByCategoryTypeAndCount(SynonymList targetSynonymList, string categoryType, int synonymsToDropCount)
        {
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");

            var adminSynonymMigrationPage = Session.OpenAdminSynonymMigrationPage(targetSynonymList);

            for (var i = 0; i < synonymsToDropCount; i++)
            {
                adminSynonymMigrationPage.GetCategoryRowMigratedCountButtonByCategoryType(categoryType).Click();
                adminSynonymMigrationPage.GetFirstSynonymSuggestionRow().Click();
                adminSynonymMigrationPage.GetDropSynonymButton().Click();
            }
        }

        public void AcceptNewVersionForAllSynonyms(SynonymList targetSynonymList)
        {
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            var adminSynonymMigrationPage = Session.OpenAdminSynonymMigrationPage(targetSynonymList);

            var categoryTypes = adminSynonymMigrationPage.GetAllCategoryTypes();

            foreach (var type in categoryTypes)
            {
                adminSynonymMigrationPage.AcceptNewVersionForAllSynonyms(type);
            }
        }

        public TimeSpan ExecuteOpenDictionarySearch(DictionarySearchCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException("searchCriteria");
            if (String.IsNullOrWhiteSpace(searchCriteria.DictionaryName)) throw new InvalidOperationException("Search dictionary is required");
            if (String.IsNullOrWhiteSpace(searchCriteria.SearchText)) throw new InvalidOperationException("SearchText dictionary is required");

            var header = Session.GetPageHeader();
            header.GoToBrowserPage();
            
            var dictionarySearch = Session.GetDictionarySearchPanel();
            var searchTime = dictionarySearch.ExecuteDictionarySearch(searchCriteria);

            return searchTime;
        }

        public TimeSpan CompleteBrowseAndCode(string verbatimTerm, DictionarySearchCriteria searchCriteria, TermPathRow targetResult, bool createSynonym, string group = null)
        {
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException("searchCriteria");
            if (ReferenceEquals(targetResult, null)) throw new ArgumentNullException("targetResult");

            var taskPage = Session.GetCodingTaskPage();

            if (String.IsNullOrWhiteSpace(group))
            {
                taskPage.InitiateBrowseAndCode(verbatimTerm);
            }
            else
            {
                taskPage.InitiateBrowseAndCodeForFirstTaskInGroup(verbatimTerm, group);
            }

            var searchTime = RerunBrowseAndCodeSearch(searchCriteria);

            var dictionarySearchPanel = Session.GetDictionarySearchPanel();
            this.CodeTaskWithTerm(dictionarySearchPanel, targetResult, createSynonym);

            return searchTime;
        }

        public void CodeTaskWithExistingSearchResult(TermPathRow targetResult, bool createSynonym)
        {

            if (ReferenceEquals(targetResult, null)) throw new ArgumentNullException("targetResult");

            var dictionarySearchPanel = Session.GetDictionarySearchPanel();
            this.CodeTaskWithTerm(dictionarySearchPanel, targetResult, createSynonym);

        }

        public void SelectDictionarySearchResult(TermPathRow targetResult, bool primaryPath)
        {
            if (ReferenceEquals(targetResult, null)) throw new ArgumentNullException("targetResult");

            var dictionarySearchPanel = Session.GetDictionarySearchPanel();
            dictionarySearchPanel.SelectDictionarySearchResult(targetResult, primaryPath);
        }

        public TimeSpan RerunBrowseAndCodeSearch(DictionarySearchCriteria searchCriteria)
        {
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException("searchCriteria");

            var dictionarySearchPanel = Session.GetDictionarySearchPanel();
            var searchTime = dictionarySearchPanel.ExecuteDictionarySearch(searchCriteria);

            return searchTime;
        }

        public void ReCodeTaskToNewTerm(string verbatimTerm, DictionarySearchCriteria searchCriteria, TermPathRow targetResult, bool createSynonym, string comment)
        {
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");
            if (ReferenceEquals(searchCriteria, null)) throw new ArgumentNullException("searchCriteria");
            if (ReferenceEquals(targetResult, null)) throw new ArgumentNullException("targetResult");
            if (String.IsNullOrWhiteSpace(comment)) throw new ArgumentNullException("comment");

            Session.GetCodingTaskPage();

            ReCodeTask(verbatimTerm, comment);

            CompleteBrowseAndCode(
                verbatimTerm: verbatimTerm,
                searchCriteria: searchCriteria,
                targetResult: targetResult,
                createSynonym: createSynonym);
        }

        public SynonymRow[] GetAllProvisionalSynonyms(SynonymSearch synonymSearch, int expectedSynonymCount)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");
            if (expectedSynonymCount < 0) throw new ArgumentOutOfRangeException("expectedSynonymCount should be > 0");

            LoadProvisionalSynonymsWhenReady(synonymSearch, expectedSynonymCount);

            var synonymApprovalPage = Session.GetSynonymApprovalPage();
            var allSynonymSets = synonymApprovalPage.GetAllProvisionalSynonyms();

            return allSynonymSets;
        }

        public SynonymRow[] GetFilteredProvisionalSynonyms(SynonymSearch synonymSearch, int expectedSynonymCount)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");
            if (expectedSynonymCount < 0) throw new ArgumentOutOfRangeException("expectedSynonymCount should be > 0");

            LoadProvisionalSynonymsWhenReady(synonymSearch, expectedSynonymCount);

            var synonymsToApprove = GetFilteredProvisionalSynonyms(synonymSearch);

            return synonymsToApprove;
        }

        public SynonymRow[] GetFilteredProvisionalSynonyms(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");
            
            var synonymApprovalPage = Session.GetSynonymApprovalPage();
            var synonymsToApprove = synonymApprovalPage.GetFilteredProvisionalSynonyms(synonymSearch);

            return synonymsToApprove;
        }

        public IList<SynonymRow> GetSynonymsDetails(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            var adminSynonymDetailsPage = Session.OpenAdminSynonymDetailsPage(synonymSearch);
            var synonymsDetails = adminSynonymDetailsPage.GetSynonymsDetails(synonymSearch);

            return synonymsDetails;
        }

        public void AssertThatSynonymApprovalListIsEmpty()
        {
            var isPopulated = Session.GetSynonymApprovalPage().IsSynonymApprovalListPopulated();

            isPopulated.Should().BeFalse();
        }

        private void LoadProvisionalSynonymsWhenReady(SynonymSearch synonymSearch, int expectedSynonymCount)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");
            if (expectedSynonymCount < 0) throw new ArgumentOutOfRangeException("expectedSynonymCount should be > 0");

            var synonymListPage = Session.GetSynonymListPage();
            synonymListPage.WaitForSynonymListToReachCount(synonymSearch, expectedSynonymCount);

            var pageHeader = Session.GetPageHeader();
            pageHeader.GoToAdminPage("Synonym Approval");
        }

        public void OpenQuery(string verbatim, string comment)
        {
            if (string.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (string.IsNullOrEmpty(comment)) throw new ArgumentNullException("comment");
            
            SelectTaskGridByVerbatimName(verbatim);

            Session.GetCodingTaskPage().OpenQuery(comment);
        }
        
        public void CancelQuery(string verbatim)
        {
            if (string.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            SelectTaskGridByVerbatimName(verbatim);

            Session.GetCodingTaskPage().CancelQuery();
        }
        
        public void ApproveSynonym(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            var synonymApprovalPage = Session.GetSynonymApprovalPage();

            synonymApprovalPage.FindAndApproveSynonym(synonymSearch);
        }

        public void RetireSynonym(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            var synonymApprovalPage = Session.GetSynonymApprovalPage();

            synonymApprovalPage.FindAndRetireSynonym(synonymSearch);
        }

        public void RetireSynonym(SynonymSearch synonymSearch, bool useSynonymApprovalPage)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            if (useSynonymApprovalPage)
            {
                Session.GetSynonymApprovalPage().FindAndRetireSynonym(synonymSearch);
            }
            else
            {
                Session.OpenAdminSynonymDetailsPage(synonymSearch).FindAndRetireSynonym(synonymSearch.SearchText);
            }
        }

        public SynonymRow GetSynonymDetailRow(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            var synonymDetailPage = Session.OpenAdminSynonymDetailsPage(synonymSearch);

            var synonym = synonymDetailPage.GetSynonymDetails(synonymSearch);

            return synonym;
        }

        //regression test related to MEV Download
        public string AssertReclassificationTerm(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            var codingReclassificationPage = Session.GetCodingReclassificationPage();

            var verbatimElement = codingReclassificationPage.GetTaskGridVerbatimElementByVerbatimTerm(verbatim);

            return verbatimElement.InnerHTML;
        }

        public void GetMevUploadCodedTasksTabLink()
        {
            var mevPage = Session.GetMevPage();
            mevPage.GetMevUploadTasksTabLink().Click();
        }

        public void GetMevUploadTasksByTaskName(string taskName)
        {
            var mevPage = Session.GetMevPage();
            mevPage.GetUploadedCodingTaskGrid();
        }

        public void UploadMevFileAndWaitForCompletion(string filePath)
        {
            if (ReferenceEquals(filePath, null)) throw new ArgumentNullException("filePath");

            var mevPage = Session.GetMevPage();

            mevPage.GoTo();
            mevPage.GetNavUploadButton().Click();
            mevPage.GetUploadField().FillInWith(filePath);
            mevPage.GetUploadButton().Click();

            mevPage.WaitForMevUploadToComplete();
        }

        public void DownloadMevFailureContent(string fileName)
        {
            if (ReferenceEquals(fileName, null)) throw new ArgumentNullException("fileName");

            var mevPage = Session.GetMevPage();
            
            mevPage.GoTo();

            GenericFileHelper.DownloadVerifiedFile(
                _DownloadDirectory,
                fileName.AppendErrorFileNameToDirectoryPath(),
                mevPage.GetDownloadFailedButton(fileName).Click);
        }

        public void DownloadMevFile(MevDownloadCriteria downloadCriteria, string downloadedFileName)
        {
            if (ReferenceEquals(downloadCriteria, null)) throw new ArgumentNullException("downloadCriteria");
            if (String.IsNullOrEmpty(downloadedFileName)) throw new ArgumentNullException("downloadedFileName");
            
            WaitForAutoCodingToComplete();

            var mevPage = Session.GetMevPage();
            mevPage.GoTo();
            mevPage.GetMevDownloadTabLink().Click();
            mevPage.SetDownlodCriteria(downloadCriteria);

            GenericFileHelper.DownloadVerifiedFile(
                _DownloadDirectory,
                downloadedFileName,
                mevPage.DownloadFile);
        }

        public bool IsMevUploadCapabilityAvailable()
        {
            var mevPage = Session.GetMevPage();
            mevPage.GoTo();
            return mevPage.IsUploadCapabilityAvailable();
        }

        public void OpenQueryForTask(string term, string query)
        {
            if (String.IsNullOrEmpty(term)) throw new ArgumentNullException("term");
            if (String.IsNullOrEmpty(query)) throw new ArgumentNullException("query");

            var codingTaskPage = Session.GetCodingTaskPage();

            codingTaskPage.AssertTaskLoaded(term);
            codingTaskPage.OpenQuery(query);
        }

        public DictionarySearchCriteria GetDictionarySearchCriteria()
        {
            var dictionarySearchPanel = Session.GetDictionarySearchPanel();
            var searchCriteria = dictionarySearchPanel.GetCurrentSearchCriteria();

            return searchCriteria;
        }

        public void InitiateBrowseAndCode(string taskVerbatim)
        {
            if (String.IsNullOrWhiteSpace(taskVerbatim)) throw new ArgumentNullException("taskVerbatim");

            var taskPage = Session.GetCodingTaskPage();
            taskPage.InitiateBrowseAndCode(taskVerbatim);
        }

        public void RegisterProjects(string project, IList<SynonymList> synonymLists)
        {
            if (ReferenceEquals(project, null))      throw new ArgumentNullException("project");
            if (ReferenceEquals(synonymLists, null)) throw new ArgumentNullException("synonymLists");

            Session.GoToAdminPage("Project Registration");

            var projectRegisterationPage = Session.GetProjectRegistrationPage();

            projectRegisterationPage.GetProjectDropdownList().SelectOptionAlphanumericOnly(project);
            projectRegisterationPage.GetEditProjectButton().Click();

            foreach (var synonym in synonymLists)
            {
                projectRegisterationPage.GetAddNewGridSegmentButton().Click();

                projectRegisterationPage.SelectDictionaryType(synonym.Dictionary);
                projectRegisterationPage.SelectVersion(synonym.Version);
                projectRegisterationPage.SelectLocale(synonym.Locale);
                projectRegisterationPage.SelectSynonymList(synonym.SynonymListName);
                projectRegisterationPage.SelectDictionary(synonym.RegistrationName);

                projectRegisterationPage.GetUpdateButton().Click();
                projectRegisterationPage.GetSendToSourceButton().Click();
                projectRegisterationPage.GetSendOkButton().Click();
            }
        }

        public void AssertThatProjectsAreRegistered(IList<SynonymList> synonymLists)
        {
            if (ReferenceEquals(synonymLists, null)) throw new ArgumentNullException("synonymLists");

            var projectRegisterationPage = Session.GetProjectRegistrationPage();

            var htmlData = projectRegisterationPage.GetRegisteredProjectValues();

            for (var i = 0; i < htmlData.Count; i++)
            {
                Assert.AreEqual(synonymLists[i].Dictionary, htmlData[i].Dictionary);
                Assert.AreEqual(synonymLists[i].Version, htmlData[i].Version);
                Assert.AreEqual(synonymLists[i].Locale, htmlData[i].Locale);
                Assert.AreEqual(synonymLists[i].SynonymListName, htmlData[i].SynonymListName);
                Assert.AreEqual(synonymLists[i].RegistrationName, htmlData[i].RegistrationName);
            }

            this.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public void AssertCodingHistoryHasTheInformationForTask(IList<CodingHistoryDetail> featureData, int hoursDiff)
        {
            if (ReferenceEquals(featureData, null)) throw new ArgumentNullException("featureData");

            var htmlData = this.GetCodingHistoryTableValues();
            var additionalInformationValues = this.GetCodingHistoryTableAdditionalInformationValues();

            // There can be more data in the system than is being verified
            htmlData.Count.Should().BeGreaterOrEqualTo(featureData.Count);

            for (var i = 0; i < featureData.Count; i++)
            {
                Assert.That(featureData[i].User, Is.StringContaining(htmlData[i].User));
                Assert.That(featureData[i].Action, Is.EqualTo(htmlData[i].Action.Trim()));
                Assert.That(featureData[i].Status, Is.EqualTo(htmlData[i].Status));

                string displayedVerbatim = featureData[i].VerbatimTerm.RemoveAdditionalInformationFromGridDataVerbatim();
                Assert.That(displayedVerbatim, Is.EqualTo(htmlData[i].VerbatimTerm),
                    String.Format("'VerbatimTerm' does not match in row {0}", i));
                Assert.That(featureData[i].VerbatimTerm.Trim(), Is.EqualTo(htmlData[i].VerbatimTerm + additionalInformationValues[i].Trim()), 
                    String.Format("'Expanded VerbatimTerm' does not match in row {0}", i));
                
                // Comment may have transmission queue Ids we don't care to verify, so reverse the check and only look for the leading text
                Assert.That(htmlData[i].Comment, Is.StringContaining(featureData[i].Comment.Trim()));

                var expectedDateTime = DateTime.Parse(featureData[i].TimeStamp);
                var displayedTimeStamp = DateTime.Parse(htmlData[i].TimeStamp);
                var timeStampDiff = expectedDateTime.Subtract(displayedTimeStamp);

                Assert.That(Math.Abs(timeStampDiff.Hours) < hoursDiff, Is.True);
            }

            this.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public void CreateATaskWithReconsiderState(string verbatim, string reclassifyComment, string includeAutoCodedItems)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(reclassifyComment)) throw new ArgumentNullException("reclassifyComment");
            if (String.IsNullOrWhiteSpace(includeAutoCodedItems)) throw new ArgumentNullException("includeAutoCodedItems");

            SelectTaskGridByVerbatimName(verbatim);
            var codingTaskPage = Session.GetCodingTaskPage();

            codingTaskPage.GetApproveButton().Click();
            ReclassifyTask(verbatim, reclassifyComment, includeAutoCodedItems, ReclassificationTypes.Reclassify);
        }

        public void PerformStudyImpactAnalysis(
            string study, 
            string dictionary, 
            SynonymList sourceSynonymList, 
            SynonymList targetSynonymList)
        {
            if (String.IsNullOrEmpty(study)) throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(dictionary)) throw new ArgumentNullException("dictionary");
            if (ReferenceEquals(sourceSynonymList, null)) throw new ArgumentNullException("sourceSynonymList");
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            var studyImpactAnalysisPage = Session.OpenStudyAnalysisPageWithReportForValues(
                study,
                dictionary,
                sourceSynonymList,
                targetSynonymList);
        }

        public void MigrateStudy(
            string study,
            string dictionary,
            SynonymList sourceSynonymList,
            SynonymList targetSynonymList,
            bool waitForMigrationToComplete = true)
        {
            if (String.IsNullOrEmpty(study)) throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(dictionary)) throw new ArgumentNullException("dictionary");
            if (ReferenceEquals(sourceSynonymList, null)) throw new ArgumentNullException("sourceSynonymList");
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            var studyImpactAnalysisPage = Session.OpenStudyAnalysisPageWithReportForValues(
                study,
                dictionary,
                sourceSynonymList,
                targetSynonymList);

            studyImpactAnalysisPage.GetStudyReportGridActionButton().Click();
            studyImpactAnalysisPage.GetPopupMigrateStudyButton().Click();

            Session.WaitUntilElementDisappears(() => studyImpactAnalysisPage.GetStudyMigrationStartingIndicator(), Config.GetLoadingCoypuOptions());
            Session.WaitUntilElementExists(() => studyImpactAnalysisPage.GetStudyMigrationStartedIndicator());

            if (waitForMigrationToComplete)
            {
                var studyReportPage = Session.OpenStudyReportPage();

                studyReportPage.GetDictionaryTypeDropDownList().SelectOption(dictionary);
                studyReportPage.GetStudyDropDownList().SelectOption(study);
                studyReportPage.WaitForStudyMigrationToComplete(study, targetSynonymList.Version);
            }
        }

        public void UploadSynonymFile(SynonymList synonymList, string synonymFilePath)
        {
            if (ReferenceEquals(synonymList, null)) throw new ArgumentNullException("synonymList");
            if (String.IsNullOrEmpty(synonymFilePath)) throw new ArgumentNullException("synonymFilePath");

            var adminSynonymPage = Session.OpenAdminSynonymPage();

            adminSynonymPage.SelectSynonymList(synonymList);

            adminSynonymPage
                .GetUploadSynonymsLinkByListName(synonymList.SynonymListName)
                .Click();

            var adminSynonymListPage = Session.OpenAdminSynonymListPage();

            adminSynonymListPage.GetSynonymListFileUpload().FillInWith(synonymFilePath);
            adminSynonymListPage.GetUploadButton().Click();

            adminSynonymListPage.DisplaySynonymListUploadHistoryForFileName(Path.GetFileName(synonymFilePath));

            int expectedNumberOfSynonymsToUpload = SynonymUploadRow.GetSynonymsFromTxtFile(synonymFilePath).Count;
            adminSynonymListPage.WaitForSynonymUploadToComplete(new FileInfo(synonymFilePath).Length, expectedNumberOfSynonymsToUpload);
        }

        public void DownloadSynonymFileFromSynonymPage(SynonymList synonymList, string synonymFileName)
        {
            if (ReferenceEquals(synonymList, null)) throw new ArgumentNullException("synonymList");
            if (ReferenceEquals(synonymFileName, null)) throw new ArgumentNullException("synonymFileName");

            var adminSynonymPage = Session.OpenAdminSynonymPage();

            int synonymsCount = adminSynonymPage.SelectDownloadSynonymList(synonymList);
            
            RetryPolicy
                .CheckDownLoadFileComplete
                .Execute(
                    () =>
                        AssertFileDownloadComplete(
                            filename: "SynonymList_Segment_MEDIFLEX*_SynonymList*.txt",
                            expectedNumberOfSynonyms: synonymsCount,
                            secondsSinceLastModified: 5,
                            newFilename: synonymFileName)
                        );
        }

        public void DownloadSynonymFileFromSynonymListPage(SynonymSearch synonymSearch, string synonymFileName)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");
            if (ReferenceEquals(synonymFileName, null)) throw new ArgumentNullException("synonymFileName");
            
            var synonymListPage = Session.GetSynonymListPage();

            int synonymsCount = synonymListPage.SelectDownloadSynonymList(synonymSearch);

            RetryPolicy
                .CheckDownLoadFileComplete
                .Execute(
                    () =>
                        AssertFileDownloadComplete(
                            filename: "SynonymList_Segment_MEDIFLEX*_SynonymList*.txt",
                            expectedNumberOfSynonyms: synonymsCount,
                            secondsSinceLastModified: 5,
                            newFilename: synonymFileName)
                        );
        }

        public void ValidateSynonymUpload(string synonymFileName, SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymFileName, null)) throw new ArgumentNullException("synonymFileName");
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            int synonymCount = File.ReadAllLines(synonymFileName).Length - 1;

            var adminSynonymListPage = Session.OpenAdminSynonymListPage();
            adminSynonymListPage.WaitForSynonymUploadFileToComplete();
            adminSynonymListPage.GetNumberOfSynonymsInSingleSynonymListView().InnerHTML.ToInteger().Should().Be(synonymCount, "The number of synonyms being uploaded are : " + synonymCount);

            var header = Session.GetPageHeader();
            header.GoToAdminPage("Synonym List");

            var synonymListPage = Session.GetSynonymListPage();
            synonymListPage.InitiateNewListCreation(synonymSearch);

            var synonymPage = Session.GetAdminSynonymPage();
            var synonymList = synonymPage.GetSynonymListTableValuesByListName(synonymSearch.SynonymList ?? Config.DefaultSynonymListName);

            synonymList.NumberOfSynonyms.ToInteger().ShouldBeEquivalentTo(synonymCount);
        }

        public void UpdateStudyName(StudySetupData currentStudy, string newName)
        {
            if (ReferenceEquals(currentStudy, null)) throw new ArgumentNullException("currentStudy");
            if (String.IsNullOrWhiteSpace(newName)) throw new ArgumentNullException("newName");

            using (var iMedidataClient = new IMedidataClient())
            {
                iMedidataClient.UpdateStudyName(currentStudy, newName);
            }
        }

        public void AssertThatRegistrationHistoryContainsFollowingInformation(IList<ProjectRegistrationHistory> featureData, int hoursDiff)
        {
            if (ReferenceEquals(featureData, null)) throw new ArgumentNullException("featureData");

            var projectRegistrationPage = Session.GetProjectRegistrationPage();
            projectRegistrationPage.GetToggleHistoryButton().Click();
            var htmlData = projectRegistrationPage.GetRegisterationHistoryValues();

            for (var i = 0; i < featureData.Count; i++)
            {
                Assert.That(featureData[i].User, Is.StringContaining(htmlData[i].User));
                Assert.That(featureData[i].DictionaryAndVersions, Is.EqualTo(htmlData[i].DictionaryAndVersions));
                Assert.That(featureData[i].ProjectRegistrationSucceeded, Is.EqualTo(htmlData[i].ProjectRegistrationSucceeded));

                var expectedDateTime = DateTime.Parse(featureData[i].Created);
                var displayedTimeStamp = DateTime.Parse(htmlData[i].Created);
                var timeStampDiff = expectedDateTime.Subtract(displayedTimeStamp);

                Assert.That(Math.Abs(timeStampDiff.Hours) < hoursDiff, Is.True);
            }

            this.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public void AccessAdminHelpContent(string pageName, string helpLinkName)
        {
            if (String.IsNullOrEmpty(pageName)) throw new ArgumentNullException("pageName");
            if (String.IsNullOrEmpty(helpLinkName)) throw new ArgumentNullException("helpLinkName");

            Session.GoToAdminPage(pageName);
            Session.GoToHelpPage(helpLinkName);
        }

        public void AccessReportHelpContent(string pageName, string helpLinkName)
        {
            if (String.IsNullOrEmpty(pageName)) throw new ArgumentNullException("pageName");
            if (String.IsNullOrEmpty(helpLinkName)) throw new ArgumentNullException("helpLinkName");

            Session.GoToReportPage(pageName);
            Session.GoToHelpPage(helpLinkName);
        }

        public void AccessTasksHelpContent(string helpLinkName)
        {
            if (String.IsNullOrEmpty(helpLinkName)) throw new ArgumentNullException("helpLinkName");

            Session.GetCodingTaskPage();
            Session.GoToHelpPage(helpLinkName);
        }

        public void AccessHelpContentByContext(string pageName, string tabName)
        {
            if (String.IsNullOrEmpty(pageName)) throw new ArgumentNullException("pageName");
            if (String.IsNullOrEmpty(tabName)) throw new ArgumentNullException("tabName");

            var codingTaskPage = Session.GetCodingTaskPage();

            codingTaskPage.SelectTabByName(tabName);
            codingTaskPage.GetContextHelpLink().Click();
        }

        public void FilterDisplayedTasks(string sourceSystemFilterCriteria, string studiesFilterCriteria, string trackablesFilterCriteria)
        {
            var codingTaskPage = Session.GetCodingTaskPage();

            codingTaskPage.SetTaskFilters(sourceSystemFilterCriteria, studiesFilterCriteria, trackablesFilterCriteria);

            codingTaskPage.GetFilterButton().ClickWhenAvailable();
        }

        public void FilterTasksByColumn(string columnName, string filterCriteria)
        {
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");
            if (String.IsNullOrEmpty(filterCriteria)) throw new ArgumentNullException("filterCriteria");

            const int firstFilterCriteriaOffset = 1;

            var codingTaskPage = Session.GetCodingTaskPage();

            codingTaskPage.GetColumnHeaderFilterButton(columnName).ClickWhenAvailable();

            var columnHeaderFilterWindow = codingTaskPage.GetColumnHeaderFilterWindow();

            string[] columnHeaderFilterWindowValues = columnHeaderFilterWindow.Text.Split(new char[] { '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries);

            int filterCriteriaIndex = Array.IndexOf(columnHeaderFilterWindowValues, filterCriteria) + firstFilterCriteriaOffset;

            if (filterCriteriaIndex <= 0)
            {
                throw new KeyNotFoundException("filterCriteria not valid for this column");
            }

            codingTaskPage.GetColumnHeaderFilterWindowItem(filterCriteriaIndex).Click();
        }

        public void ClearAllTaskPageFilters()
        {
            var codingTaskPage = Session.GetCodingTaskPage();

            codingTaskPage.WaitForTaskPageToFinishLoading();

            codingTaskPage.ClearFilters();
        }
        
        /// <summary>Returns the count of all tasks matching the filter criteria.</summary>
        public int GetHeaderTaskCount()
        {
            const int maxDisplayableTaskCount = 500;

            int taskCount = 0;

            var codingTaskPage = Session.GetCodingTaskPage();

            string codingTasksFoundTableHeaderText = codingTaskPage.GetCodingTasksFoundTableHeader().Text;

            string[] splitHeaderText = codingTasksFoundTableHeaderText.Split(' ');

            if (splitHeaderText.Length <= 0)
            {
                throw new InvalidOperationException("Parsing of the Tasks Table Header returned unexpected results.");
            }
            
            taskCount = splitHeaderText[0].ToInteger();

            if (codingTaskPage.IsTasksSummaryTableFooterVisible() && taskCount <= maxDisplayableTaskCount)
            {
                Assert.AreEqual(taskCount, codingTaskPage.GetItemFromTasksSummaryTableFooter("Task Count"), "Task count in header don't match footer.");
            }
            return taskCount;
        }

        /// <summary>Returns the count of all tasks loaded into the Coder system for a specific trackables state.</summary>
        public int GetSystemTaskCount(string trackableState)
        {
            if (String.IsNullOrEmpty(trackableState)) throw new ArgumentNullException("trackableState");

            const int expectedSystemTaskCountPosition = 1;

            int taskCount = 0;

            GoToTaskPage();

            var codingTaskPage = Session.GetCodingTaskPage();

            codingTaskPage.GetTrackablesDropdown().SelectOption(trackableState);

            codingTaskPage.GetFilterButton().ClickWhenAvailable();

            string sourceSystemDropdownText = codingTaskPage.GetSourceSystemDropdown().Text;

            if (!sourceSystemDropdownText.Equals("All Source Systems"))
            {
                string[] splitDropdownText = sourceSystemDropdownText.Split(new char[] { '(', ')' },
                    StringSplitOptions.RemoveEmptyEntries);

                if (splitDropdownText.Length <= expectedSystemTaskCountPosition)
                {
                    throw new InvalidOperationException(
                        "Parsing of the Source System Dropdown for task count returned unexpected results.");
                }

                taskCount = splitDropdownText[expectedSystemTaskCountPosition].ToInteger();
            }

            return taskCount;
        }

        /// <summary>Returns the count of all tasks loaded into the Coder system.</summary>
        public int GetStudyReportTaskCount()
        {
            return GetStudyReportTaskCount(WorkflowState.AllWorkflowStates);
        }

        /// <summary>Returns the count of all tasks loaded into the Coder system for a specific workflow state.</summary>
        public int GetStudyReportTaskCount(WorkflowState workflowState)
        {
            int taskCount = 0;
            int firstDictionaryPosition = 0;

            var studyReportPage = Session.OpenStudyReportPage();

            // GetStudyReportTaskCount will get all tasks for all dictionaries. There is no way to display all dictionaries at once,
            // so select each dictionary in the dropdown to get the complete count.
            string dictionaryTypeDropdownText = studyReportPage.GetDictionaryTypeDropDownList().Text;

            string[] splitDropdownText = dictionaryTypeDropdownText.Split(new char[] { '\n', '\r' },
                StringSplitOptions.RemoveEmptyEntries);

            if (splitDropdownText.Length > 0)
            {
                if (splitDropdownText[firstDictionaryPosition].Equals("Select Dictionary Type"))
                {
                    firstDictionaryPosition++;
                }

                for (int dictionaryIndex = firstDictionaryPosition;
                    dictionaryIndex < splitDropdownText.Length;
                    dictionaryIndex++)
                {
                    studyReportPage.GetDictionaryTypeDropDownList().SelectOption(splitDropdownText[dictionaryIndex]);
                    studyReportPage.GetGenerateReportButton().ClickWhenAvailable();

                    if (!studyReportPage.IsStudyReportGridEmpty())
                    {
                        taskCount += studyReportPage.TotalTaskCounts(workflowState);
                    }
                }
            }
            return taskCount;
        }

        public void WaitForTaskLoadComplete(int expectedTaskCount)
        {
            RetryPolicy.CompletionAssertion.Execute(
                () => Assert.AreEqual(expectedTaskCount, GetStudyReportTaskCount(), "Could not confirm that all tasks were loaded."));
        }

        public void WaitForAutoCodingToComplete()
        {
            var codingTaskPage = Session.GetCodingTaskPage();

            codingTaskPage.ClearFilters();

            RetryPolicy.CompletionAssertion.Execute(
                () => this.AssertTaskCountForWorkflowState("Not In Workflow", 0));

            RetryPolicy.CompletionAssertion.Execute(
                () => this.AssertTaskCountForWorkflowState("In Workflow", 0));

            codingTaskPage.ClearFilters();
        }

        public void WaitUntilSystemTaskCountAtOrAboveThreshold(string taskableState, int percentThreshold)
        {
            if (String.IsNullOrEmpty(taskableState)) throw new ArgumentNullException("taskableState");

            int systemTaskCountMinimum = GetStudyReportTaskCount() * percentThreshold / 100;

            RetryPolicy.CompletionAssertion.Execute(
                () =>
                {
                    Assert.GreaterOrEqual(GetSystemTaskCount(taskableState),
                        systemTaskCountMinimum,
                        string.Format("Not enough tasks were in the {0} state.", taskableState));
                });
        }

        public void WaitUntilSystemTaskCountAtOrBelowThreshold(string taskableState, int percentThreshold)
        {
            if (String.IsNullOrEmpty(taskableState)) throw new ArgumentNullException("taskableState");

            int systemTaskCountMaximum = GetStudyReportTaskCount() * percentThreshold / 100;
            
            RetryPolicy.CompletionAssertion.Execute(
                () =>
                {
                    Assert.LessOrEqual(GetSystemTaskCount(taskableState),
                        systemTaskCountMaximum,
                        string.Format("Too many tasks were in the {0} state.", taskableState));
                });
        }

        public void SortTasks(string columnName, SortStatus desiredSortDirection)
        {
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");

            var codingTaskPage = Session.GetCodingTaskPage();

            int sortAttempts = 0;
            const int maxSortAttempts = 2;

            do
            {
                codingTaskPage.GetColumnHeader(columnName).ClickWhenAvailable();
                sortAttempts++;
            }
            while (GetTasksSortedByStatus(columnName) != desiredSortDirection && sortAttempts < maxSortAttempts);
        }

        public SortStatus GetTasksSortedByStatus(string columnName)
        {
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName"); 

            SortStatus tasksSortedByStatus = SortStatus.NotSorted;

            var codingTaskPage = Session.GetCodingTaskPage();

            var columnHeaderSortIndicator = codingTaskPage.GetColumnHeaderSortIndicator(columnName);

            if (ReferenceEquals(columnHeaderSortIndicator, null))
            {
                throw new NullReferenceException("columnHeaderSortIndicator");
            }

            string sortOrder = columnHeaderSortIndicator.GetAttribute("alt");
            switch (sortOrder)
            {
                case "(Ascending)":
                    {
                        tasksSortedByStatus = SortStatus.SortedAscending;
                        break;
                    }
                case "(Descending)":
                    {
                        tasksSortedByStatus = SortStatus.SortedDescending;
                        break;
                    }
                default:
                    {
                        throw new InvalidOperationException("The sort indicator returned an unexpected direction: " + sortOrder);
                    }
            }

            return tasksSortedByStatus;
        }

        public int GetNumberOfTaskPages()
        {
            int NumberOfTaskPages = 1;

            var codingTaskPage = Session.GetCodingTaskPage();

            if (codingTaskPage.IsTasksSummaryTableFooterVisible())
        {
                NumberOfTaskPages = codingTaskPage.GetItemFromTasksSummaryTableFooter("Page Count");
        }

            return NumberOfTaskPages;
        }

        public void GoToSpecificTaskPage(string destinationPage)
        {
            if (String.IsNullOrEmpty(destinationPage)) throw new ArgumentNullException("destinationPage");

            var codingTaskPage = Session.GetCodingTaskPage();

            if (codingTaskPage.IsTasksSummaryTableFooterVisible())
        {
                codingTaskPage.GoToSpecificTaskPage(destinationPage);
            }
        }

        public void DoNotAutoCodeTerm(string segmentName, string verbatimTerm, string dictionaryList, string dictionaryLevel, string dictionary, string login)
        {
            if (String.IsNullOrWhiteSpace(segmentName)) throw new ArgumentNullException("segmentName");
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrWhiteSpace(dictionaryList)) throw new ArgumentNullException("dictionaryList");
            if (String.IsNullOrWhiteSpace(dictionaryLevel)) throw new ArgumentNullException("dictionaryLevel");
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(login)) throw new ArgumentNullException("login");

            var doNotAutoCodePage = Session.OpenDoNotAutoCodePage();
         
            doNotAutoCodePage.CleanUpTermsBySegmentAndList(
                segmentName: segmentName,
                dictionaryList: dictionaryList);

            doNotAutoCodePage.CreateDoNotAutoCodeTerm(
                segmentName: segmentName,
                dictionaryList: dictionaryList,
                verbatimTerm: verbatimTerm,
                dictionary: dictionary,
                dictionaryLevel: dictionaryLevel,
                login: login);
        }

        public StudyImpactAnalysisActions GetAvailableStudyImpactActions(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");

            PerformStudyImpactAnalysis(
                study: stepContext.GetStudyName(),
                dictionary: String.Format("{0} ({1})", stepContext.Dictionary, stepContext.Locale),
                sourceSynonymList: stepContext.SourceSynonymList,
                targetSynonymList: stepContext.TargetSynonymList);

            var studyImpactAnalysisPage = Session.GetStudyImpactAnalysisPage();
            var availableActions = studyImpactAnalysisPage.GetAvailableActions();

            return availableActions;
        }

        public IList<DictionarySearchResult> ExecuteMultipleOpenDictionarySearches(IList<DictionarySearchCriteria> searchCriteriaList)
        {
            if (ReferenceEquals(searchCriteriaList, null)) throw new ArgumentNullException("searchCriteriaList");

            var searchResultList = new List<DictionarySearchResult>();

            foreach (var searchCriteria in searchCriteriaList)
            {
                var searchTime = ExecuteOpenDictionarySearch(searchCriteria);
                var searchResult = this.GetDictionarySearchResults(new TermPathRow[0]);
                searchResult.ExecutionTime = searchTime;
                searchResultList.Add(searchResult);
            }

            return searchResultList;
        }

        private void AssertFileDownloadComplete(string filename, int expectedNumberOfSynonyms, int secondsSinceLastModified = -1, string newFilename = "")
        {
            if (String.IsNullOrWhiteSpace(filename)) throw new ArgumentNullException("filename");
            if (ReferenceEquals(expectedNumberOfSynonyms, null)) throw new ArgumentNullException("expectedNumberOfSynonyms");
            if (ReferenceEquals(secondsSinceLastModified, null)) throw new ArgumentNullException("secondsSinceLastModified");

            DateTime latestFileModifiedTime = DateTime.Now.AddSeconds(-1 * secondsSinceLastModified);

            string downloadedFilePath = "";
            
            string[] possibleFiles = Directory.GetFiles(_DownloadDirectory, filename);

            Assert.AreNotEqual(0, possibleFiles.Count(), "Downloaded file not found.");

            // Find the latest file
            foreach (string possibleFile in possibleFiles)
            {
                DateTime possibleFileModifiedTime = File.GetLastWriteTime(possibleFile);

                if (secondsSinceLastModified == -1 || possibleFileModifiedTime > latestFileModifiedTime)
                {
                    downloadedFilePath = possibleFile;
                    latestFileModifiedTime = possibleFileModifiedTime;
                }
            }

            StringAssert.AreNotEqualIgnoringCase("", downloadedFilePath, "Recently downloaded file not found.");
            
            int actualNumberOfSynonyms = File.ReadAllLines(downloadedFilePath).Length - 1;

            Assert.AreEqual(expectedNumberOfSynonyms, actualNumberOfSynonyms, "Downloaded file does not have the right number of synonyms.");

            if (!String.IsNullOrWhiteSpace(newFilename))
            {
                string newFilePath = _DownloadDirectory + "\\" + newFilename;
                File.Copy(downloadedFilePath, newFilePath, overwrite: true);
                File.Delete(downloadedFilePath);
                Assert.IsTrue(File.Exists(newFilePath), "Renamed file does not exist.");
            }

        }

        public void AssertSynonymListFilesMatch(string uploadedFilePath, string downloadedFilePath)
        {
            SortedList<string, SynonymUploadRow> uploadedSynonyms = SynonymUploadRow.GetSynonymsFromTxtFile(uploadedFilePath);
            SortedList<string, SynonymUploadRow> downloadedSynonyms = SynonymUploadRow.GetSynonymsFromTxtFile(downloadedFilePath);

            Assert.AreEqual(uploadedSynonyms.Count, downloadedSynonyms.Count);

            for (int synonymIndex = 0; synonymIndex < uploadedSynonyms.Count; synonymIndex++)
            {
                Assert.IsTrue(uploadedSynonyms.Values[synonymIndex].Equals(downloadedSynonyms.Values[synonymIndex]),
                    string.Format("The synonyms in position {0} do not match: \n Expected Verbatim: \"{1}\"\n Actual Verbatim: \"{2}\"" +
                    "\nNote: The verbatim terms are for reference only and may match. Other fields likely caused the comparison failure.",
                    synonymIndex,
                    uploadedSynonyms.Keys[synonymIndex], 
                    downloadedSynonyms.Keys[synonymIndex]));
            }
        }

        public void AssertExpectedTaskPageIsCurrent(int expectedPageNumber)
        {
            var codingTaskPage = Session.GetCodingTaskPage();

            if (codingTaskPage.IsTasksSummaryTableFooterVisible())
            {
            int currentPageNumber = codingTaskPage.GetItemFromTasksSummaryTableFooter("Current Page");

                Assert.AreEqual(expectedPageNumber, currentPageNumber, "The task page footer indicates a different page.");

                var pageLink = codingTaskPage.GetCurrentPageFromPageLinks();

                Assert.AreEqual(expectedPageNumber, pageLink, "The task page footer page link indicates a different page.");
            }
            else
            {
                Assert.AreEqual(expectedPageNumber, 1);
            }

            this.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public void AssertNumberOfSynonymsForListIs(SynonymList synonymList, int expectedNumberOfSynonyms)
        {
            if (ReferenceEquals(synonymList, null)) throw new ArgumentNullException("synonymList");
            if (ReferenceEquals(expectedNumberOfSynonyms, null)) throw new ArgumentNullException("expectedNumberOfSynonyms");

            var adminSynonymPage = Session.OpenAdminSynonymPage();
            int actualSynonymsCount = adminSynonymPage.GetNumberOfSynonymsByListName(synonymList);

            Assert.AreEqual(expectedNumberOfSynonyms, actualSynonymsCount);

            this.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

            var synonymListPage = Session.GetSynonymListPage();
            actualSynonymsCount = synonymListPage.GetSynonymListCount(synonymList.Dictionary, synonymList.Locale, synonymList.Version);

            Assert.AreEqual(expectedNumberOfSynonyms, actualSynonymsCount);

            this.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public void AssertSynonymListCanBeDownloaded(SynonymList synonymList)
        {
            if (ReferenceEquals(synonymList, null)) throw new ArgumentNullException("synonymList");

            var adminSynonymPage = Session.OpenAdminSynonymPage();

            Assert.IsTrue(adminSynonymPage.IsDownloadSynonymListAvailable(synonymList), "The download button was not visible on the Synonym Page.");

            this.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

            var synonymListPage = Session.GetSynonymListPage();

            //TODO:: decide if synonymList or synonymSearch should be used for the synonym pages
            SynonymSearch synonymSearch = new SynonymSearch()
            {
                Dictionary = synonymList.Dictionary,
                Locale = synonymList.Locale,
                Version = synonymList.Version
            };
            
            Assert.IsTrue(synonymListPage.IsDownloadSynonymListAvailable(synonymSearch), "The download button was disabled on the Synonym Lists Page.");

            this.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public void AssertSynonymListCannotBeDownloaded(SynonymList synonymList)
        {
            if (ReferenceEquals(synonymList, null)) throw new ArgumentNullException("synonymList");

            var adminSynonymPage = Session.OpenAdminSynonymPage();

            Assert.IsFalse(adminSynonymPage.IsDownloadSynonymListAvailable(synonymList), "The download button was visible on the Synonym Page.");

            this.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

            var synonymListPage = Session.GetSynonymListPage();

            //TODO:: decide if synonymList or synonymSearch should be used for the synonym pages
            SynonymSearch synonymSearch = new SynonymSearch()
            {
                Dictionary = synonymList.Dictionary,
                Locale = synonymList.Locale,
                Version = synonymList.Version
            };

            Assert.IsFalse(synonymListPage.IsDownloadSynonymListAvailable(synonymSearch), "The download button was enabled on the Synonym Lists Page.");

            this.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public TimeSpan CodeAndNext(string verbatimTerm, DictionarySearchCriteria searchCriteria, TermPathRow targetResult, bool createSynonym)
        {
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");
            if (ReferenceEquals(searchCriteria, null))   throw new ArgumentNullException("searchCriteria");
            if (ReferenceEquals(targetResult, null))     throw new ArgumentNullException("targetResult");


            var dictionarySearchPanel = Session.GetDictionarySearchPanel();

            var searchTime = dictionarySearchPanel.ExecuteDictionarySearch(searchCriteria);

            this.CodeTaskWithTermAndNext(dictionarySearchPanel, targetResult, createSynonym);

            return searchTime;
        }

        public void FakeStudyMigration(
            string loginName, 
            string segment, 
            string studyName, 
            SynonymList sourceSynonymList, 
            SynonymList targetSynonymList)
        {
            if (String.IsNullOrWhiteSpace(loginName))     throw new ArgumentNullException("loginName");
            if (String.IsNullOrWhiteSpace(segment))       throw new ArgumentNullException("segment");
            if (String.IsNullOrWhiteSpace(studyName))     throw new ArgumentNullException("studyName");
            if (ReferenceEquals(sourceSynonymList, null)) throw new ArgumentNullException("sourceSynonymList");
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            CoderDatabaseAccess.FakeStudyMigration(
                loginName: loginName,
                segment: segment,
                studyName: studyName,
                sourceSynonymList: sourceSynonymList,
                targetSynonymList: targetSynonymList);
        }

        public void GoToAdminPage(string adminPage)
        {
            if (String.IsNullOrWhiteSpace(adminPage)) throw new ArgumentNullException("adminPage");

            Session.GoToAdminPage(adminPage);
        }

        public CodingDecisionsReportRow[] GetCodingDecisionReportRows()
        {
            var filePath = Path.Combine(_DownloadDirectory, Config.CodingDecisionsReportFileName);
            var reportRows = GenericCsvHelper.GetReportRows<CodingDecisionsReportRow>(filePath).ToArray();

            return reportRows;
        }

        public CodingHistoryReportRow[] GetCodingHistoryReportRows()
        {
            var filePath = Path.Combine(_DownloadDirectory, Config.CodingHistoryReportFileName);
            var reportRows = GenericCsvHelper.GetReportRows<CodingHistoryReportRow>(filePath).ToArray();

            return reportRows;
        }

        public IngredientReportRow[] GetIngredientReportRows()
        {
            var filePath = Path.Combine(_DownloadDirectory, Config.IngredientReportFileName);
            var reportRows = GenericCsvHelper.GetReportRows<IngredientReportRow>(filePath).ToArray();

            return reportRows;
        }

        public MedidataUser CreateTestUserContext(SegmentSetupData newStudyGroup, string userName, bool createNewSegment = false)
        {
            if (ReferenceEquals(newStudyGroup, null)) throw new ArgumentNullException("newStudyGroup");
            if (String.IsNullOrWhiteSpace(userName))  throw new ArgumentNullException("userName");

            if (createNewSegment)
            {
                Session.GetImedidataPage().OpenStudyGroupPage();

                Session.GetImedidataStudyGroupPage().CreateStudyGroup(newStudyGroup);
            }

            CreateNewStudyWithSite(newStudyGroup);

            MedidataUser newUser = CreateNewStudyUser(newStudyGroup, userName);
            
            return newUser;
        }

        public void CreateNewStudyWithSite(SegmentSetupData studyGroup)
        {
            if (ReferenceEquals(studyGroup, null)) throw new ArgumentNullException("studyGroup");

            using (var iMedidataClient = new IMedidataClient())
            {
                iMedidataClient.AddStudiesToIMedidata(studyGroup);
                iMedidataClient.CreateStudySite(studyGroup);
            }
        }

        public MedidataUser CreateNewStudyUser(SegmentSetupData studyGroup, string userName, bool inviteNewUserWhenCreated = true)
        {
            if (ReferenceEquals(studyGroup, null))   throw new ArgumentNullException("studyGroup");
            if (String.IsNullOrWhiteSpace(userName)) throw new ArgumentNullException("userName");

            MedidataUser newUser;

            using (var iMedidataClient = new IMedidataClient())
            {
                newUser = iMedidataClient.CreateStudyOwner(studyGroup, userName, inviteNewUserWhenCreated);
            }

            InviteUserToStudyGroup(studyGroup, newUser);

            return newUser;
        }

        public void InviteUserToStudyGroup(SegmentSetupData studyGroup, MedidataUser user)
        {
            if (ReferenceEquals(studyGroup, null)) throw new ArgumentNullException("studyGroup");
            if (ReferenceEquals(user, null))       throw new ArgumentNullException("user");

            Session.GetImedidataPage().OpenStudyGroupPage();

            Session.GetImedidataStudyGroupPage().InviteUser(studyGroup.SegmentName, Config.ApplicationName, user);
        }

        public string GetStudyGroupUUID(string segmentName)
        {
            if (ReferenceEquals(segmentName, null)) throw new ArgumentNullException("segmentName");

            Session.GetImedidataPage().OpenStudyGroupPage();

            var uuid = Session.GetImedidataStudyGroupPage().GetUUID(segmentName);

            return uuid;
        }

        public void AcceptStudyInvitation()
        {
            Session.GetImedidataPage().AcceptAllStudyGroupInvitations();
        }
        
        public void PublishAndIncompletePushRaveArchitectDraft(string study, string draftName, string studyEnvironment)
        {
            if (String.IsNullOrEmpty(study))            throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(draftName))        throw new ArgumentNullException("draftName");
            if (String.IsNullOrEmpty(studyEnvironment)) throw new ArgumentNullException("study environment");

            var draftVersion = PublishRaveArchitectDraft(study, draftName);

            var raveArchitectProjectPage = Session.OpenRaveArchitectProjectPage(study);

            raveArchitectProjectPage.OpenCRFPushDraftPage(draftVersion);

            var crfPushPage = Session.GetRaveArchitectCRFDraftPushPage();

            crfPushPage.IncompletePushDraft(studyEnvironment);
        }
        
        public bool IsCRFPushEnabled()
        {
            var crfPushPage = Session.GetRaveArchitectCRFDraftPushPage();

            var pushEnabled = crfPushPage.IsPushButtonEnabled();

            return pushEnabled;
        }

        public string GetCRFPushErrorMessage()
        {
            var crfPushPage = Session.GetRaveArchitectCRFDraftPushPage();

            var failedMessage = crfPushPage.GetErrorMessageForPushIsDisabled();

            return failedMessage;
        }
        
        public void ARaveStudyEnvironmentIsCreatedForProject(string studyEnvironment, string studyProject)
        {
            if (String.IsNullOrEmpty(studyEnvironment)) throw new ArgumentNullException("studyEnvironment");
            if (String.IsNullOrEmpty(studyProject))     throw new ArgumentNullException("studyProject");

            var raveArchitectEnvironmentSetupPage = Session.OpenRaveArchitectEnvironmentSetupPage(studyProject);

            raveArchitectEnvironmentSetupPage.SetNewEnvironmentProperties(studyEnvironment);
        }

        public bool IsRaveCoderGlobalConfigurationXLSFileCorrect(string downloadDirectory, string workSheetName, string reviewMarkingGroup, string isRequiresResponse)
        {
            if (String.IsNullOrEmpty(downloadDirectory))  throw new ArgumentNullException("downloadDirectory");
            if (String.IsNullOrEmpty(workSheetName))      throw new ArgumentNullException("workSheetName");
            if (String.IsNullOrEmpty(reviewMarkingGroup)) throw new ArgumentNullException("reviewMarkingGroup");
            if (String.IsNullOrEmpty(isRequiresResponse)) throw new ArgumentNullException("isRequiresResponse");

            var raveRaveConfigurationLoaderPage    = Session.GetRaveConfigurationLoaderPage();

            var verifyRaveCoderGlobalConfiguration = raveRaveConfigurationLoaderPage.IsRaveCoderGlobalConfigurationDownloadXLSFileCorrect(downloadDirectory, workSheetName, reviewMarkingGroup, isRequiresResponse);

            return verifyRaveCoderGlobalConfiguration;
        }

        public bool IsRaveCRFCoderConfigurationXLSFileCorrect(string zippedFileName, string zipDownloadDirectory, List<RaveCoderFieldConfiguration> expectedSheetDataValues)
        {
            if (String.IsNullOrEmpty(zipDownloadDirectory))     throw new ArgumentNullException("zipDownloadDirectory");
            if (String.IsNullOrEmpty(zippedFileName))           throw new ArgumentNullException("zippedFileName");
            if (ReferenceEquals(expectedSheetDataValues, null)) throw new NullReferenceException("expectedSheetDataValues");

            List<String> convertedExpectedSheetDataValues = new List<string>();
            foreach (var dataRow in expectedSheetDataValues)
            {
                convertedExpectedSheetDataValues.Add(dataRow.Form);
                convertedExpectedSheetDataValues.Add(dataRow.Field);
                convertedExpectedSheetDataValues.Add(dataRow.Dictionary);
                convertedExpectedSheetDataValues.Add(dataRow.Locale);
                convertedExpectedSheetDataValues.Add(dataRow.CodingLevel);
                convertedExpectedSheetDataValues.Add(dataRow.Priority);
                convertedExpectedSheetDataValues.Add(dataRow.IsApprovalRequired);
                convertedExpectedSheetDataValues.Add(dataRow.IsAutoApproval);
            }

            var actualUnzippedPath = GenericFileHelper.UnzipFile(zipDownloadDirectory, zippedFileName, zipDownloadDirectory);

            bool correctCRFCoderConfigComparison = GenericFileHelper.IsRaveXLSWorkSheetRowDataComparison(actualUnzippedPath, RaveArchitectCRFCoderWorkSheets.CoderConfigurationWorkSheetName, RaveArchitectCRFCoderWorkSheets.StartCoderConfigurationIndex, convertedExpectedSheetDataValues);

            return correctCRFCoderConfigComparison;
        }
        
        public void WaitUntilAdminLinkExists(string adminPage)
        {
            if (String.IsNullOrWhiteSpace(adminPage)) throw new ArgumentNullException("adminPage");

            var headerPage = Session.GetPageHeader();

            var options = Config.GetDefaultCoypuOptions();

            Session.TryUntil(
                        () => Session.Refresh(),
                        () => headerPage.AdminLinkAvailable(adminPage),
                        options.RetryInterval,
                        options);
        }
        
        public void WaitForIMedidataSync()
        {
            var header = Session.GetPageHeader();
            header.WaitForSync();
        }

        public bool IsRaveCRFCoderSupplementalTermsXLSFileCorrect(string zippedFileName, string zipDownloadDirectory, List<RaveCoderSupplementalConfiguration> expectedSheetDataValues)
        {
            if (String.IsNullOrEmpty(zipDownloadDirectory))     throw new ArgumentNullException("zipDownloadDirectory");
            if (String.IsNullOrEmpty(zippedFileName))           throw new ArgumentNullException("zippedFileName");
            if (ReferenceEquals(expectedSheetDataValues, null)) throw new NullReferenceException("expectedSheetDataValues");

            List<String> convertedExpectedSheetDataValues = new List<string>();
            foreach (var dataRow in expectedSheetDataValues)
            {
                convertedExpectedSheetDataValues.Add(dataRow.Form);
                convertedExpectedSheetDataValues.Add(dataRow.Field);
                convertedExpectedSheetDataValues.Add(dataRow.SupplementalTerm);
            }

            var actualUnzippedPath = GenericFileHelper.UnzipFile(zipDownloadDirectory, zippedFileName, zipDownloadDirectory);

            bool correctCRFCoderSupComparison = GenericFileHelper.IsRaveXLSWorkSheetRowDataComparison(actualUnzippedPath, RaveArchitectCRFCoderWorkSheets.CoderSupplementalTermsWorkSheetName, RaveArchitectCRFCoderWorkSheets.StartCoderSupplementIndex, convertedExpectedSheetDataValues);

            return correctCRFCoderSupComparison;
        }

        public void DownloadRaveArchitectDraft(string studyName, string draftName, string fileName, string filePath)
        {
            if (String.IsNullOrWhiteSpace(studyName)) throw new ArgumentNullException(studyName);
            if (String.IsNullOrWhiteSpace(draftName)) throw new ArgumentNullException(draftName);
            if (String.IsNullOrWhiteSpace(fileName))  throw new ArgumentNullException(fileName);
            if (String.IsNullOrWhiteSpace(filePath))  throw new ArgumentNullException(filePath);

            var raveArchitectProjectPage = Session.OpenRaveArchitectProjectPage(studyName);

            raveArchitectProjectPage.OpenDraft(draftName);

            GenericFileHelper.DownloadVerifiedFile(filePath, fileName, raveArchitectProjectPage.DownloadDraft);
        }

        public string GetFieldReportErrMsg(string filePath)
        {
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException(filePath);

            var raveArchitectUploadDraftPage = Session.OpenRaveArchitectUploadDraftPage();

            raveArchitectUploadDraftPage.UploadDraftFile(filePath);

            var actualErrorMessage = raveArchitectUploadDraftPage.GetFieldReportActualErrorMsg();

            return actualErrorMessage;
        }

    }
}
