using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coypu;
using OpenQA.Selenium;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal class ImedidataStudyGroupPage
    {
        private readonly BrowserSession _Browser;

        internal ImedidataStudyGroupPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        private enum StudyGroupTab { Attributes, Studies, Users, Depots, ELearning, CustomEmailText }

        private SessionElementScope GetNavigation()
        {
            var navigation = _Browser.FindSessionElementByXPath("//ul[@class='nav nav-tabs']");

            return navigation;
        }

        private IList<SessionElementScope> GetNavigationElements()
        {
            var navigation = GetNavigation();
            var navElements = navigation.FindAllSessionElementsByXPath(".//li");

            return navElements;
        }

        private SessionElementScope GetNavigationLink(StudyGroupTab tab)
        {
            var navElements    = GetNavigationElements();
            var navigationTab  = navElements.ElementAtOrDefault((int)tab);

            if (ReferenceEquals(navigationTab, null)) throw new ArgumentException("Tab not found");

            var navigationLink = navigationTab.FindSessionElementByXPath("a");

            return navigationLink;
        }

        private SessionElementScope GetCreateNewStudyButton()
        {
            var createNewStudyButton = _Browser.FindSessionElementById("create_new_study");

            return createNewStudyButton;
        }

        private SessionElementScope GetStudyPanel()
        {
            var managePanel = _Browser.FindSessionElementById("manage");

            return managePanel;
        }

        private SessionElementScope GetName()
        {
            var managePanel = GetStudyPanel();
            var name        = managePanel.FindSessionElementById("study_group_name");

            return name;
        }

        private SessionElementScope GetSummary()
        {
            var managePanel = GetStudyPanel();
            var summary     = managePanel.FindSessionElementById("study_group_summary");

            return summary;
        }

        private SessionElementScope GetFullDescription()
        {
            var managePanel      = GetStudyPanel();
            var fullDescription  = managePanel.FindSessionElementById("study_group_full_description");

            return fullDescription;
        }

        private SessionElementScope GetTypeSelectList()
        {
            var managePanel    = GetStudyPanel();
            var typeSelectList = managePanel.FindSessionElementById("study_group_study_group_type_id");

            return typeSelectList;
        }

        private IList<SessionElementScope> GetStudies()
        {
            var managePanel = GetStudyPanel();
            var studies     = managePanel.FindAllSessionElementsByXPath(
                ".//table[@id='studies_in_study_group_list']/tbody/tr/td/span");

            return studies;
        }

        private SessionElementScope GetStudyGroupSearchInput()
        {
            var studyGroupSearchInput = _Browser.FindSessionElementById("search_field_search_terms");

            return studyGroupSearchInput;
        }

        private SessionElementScope GetSearchButton()
        {
            var searchButton = _Browser.FindSessionElementById("search");

            return searchButton;
        }

        private SessionElementScope GetCreateStudyGroupButton()
        {
            var pageLinks = _Browser.FindAllSessionElementsByXPath(".//a");

            if (ReferenceEquals(pageLinks, null) || !pageLinks.Any())
            {
                throw new MissingHtmlException("Create New Study Group button not found.");
            }

            var createStudyGroupButton = pageLinks.Single(x => x.Class.Contains("btn btn-primary btn-sm btn-admin pull-right"));
            
            return createStudyGroupButton;
        }

        private IList<SessionElementScope> GetStudyGroupSearchResultRows()
        {
            var resultsDiv     = _Browser.FindSessionElementById("study-groups-data");
            var studyGroupRows = resultsDiv.FindAllSessionElementsByXPath(".//tbody/tr");

            return studyGroupRows;
        }

        private SessionElementScope GetStudyGroupNameInput()
        {
            var studyGroupNameInput = _Browser.FindSessionElementById("study_group_name");

            return studyGroupNameInput;
        }

        private SessionElementScope GetStudyGroupOidInput()
        {
            var studyGroupOidInput = _Browser.FindSessionElementById("study_group_oid");

            return studyGroupOidInput;
        }

        private SessionElementScope GetStudyGroupCustomerSelectList()
        {
            var customerSelectList = _Browser.FindSessionElementById("study_group_customer_id");

            return customerSelectList;
        }

        private SessionElementScope GetIMedidataAccessInput()
        {
            var iMedidataAccessInput = _Browser.FindSessionElementById("study_group_mcc_enabled_false");

            return iMedidataAccessInput;
        }

        private SessionElementScope GetMccAdminAccessInput()
        {
            var mccAdminAccessInput = _Browser.FindSessionElementById("study_group_mcc_enabled_true");

            return mccAdminAccessInput;
        }

        private SessionElementScope GetAppInputPanel()
        {
            var appInputPanel = _Browser.FindSessionElementById("apps_access");

            return appInputPanel;
        }

        private SessionElementScope GetAddAppLink()
        {
            var appInputPanel = _Browser.FindSessionElementById("add_another_app_link");

            return appInputPanel;
        }

        private IList<SessionElementScope> GetAppOptions()
        {
            var appInputPanel = GetAppInputPanel();
            var appInputs     = appInputPanel.FindAllSessionElementsByXPath(".//div[@class='app checkbox']");

            return appInputs;
        }

        private SessionElementScope GetAppInputByName(string appName)
        {
            if (String.IsNullOrWhiteSpace(appName)) throw new ArgumentNullException("appName");

            var appInputPanel = GetAppInputPanel();
            var appInputXpath = String.Format(".//div[@class='app checkbox']/label[contains(.,'{0}')]/input", appName);
            var appInput      = _Browser.FindSessionElementByXPath(appInputXpath);

            return appInput;
        }

        private SessionElementScope GetStudyGroupUuidElement()
        {
            var uuidElement =
                _Browser.FindSessionElementByXPath("//div[@class='container-fluid']/div/div/h3[@class='panel-title']");

            return uuidElement;
        }

        internal string GetStudyGroupUuid()
        {
            var uuidElement = GetStudyGroupUuidElement();
            var prefixIndex = uuidElement.Text.IndexOf(':');
            var uuIdValue   = uuidElement.Text.Substring(prefixIndex + 1).TrimEnd(')').Trim();

            return uuIdValue;
        }

        private SessionElementScope GetNewStudyGroupSaveButton()
        {
            var button = _Browser.FindSessionElementById("new_study_group_button_submit");

            if (!button.Exists())
            {
                button = _Browser.FindSessionElementById("new_study_group_button");
            }

            return button;
        }

        private SessionElementScope GetStudyGroupSaveNotice()
        {
            var notice = _Browser.FindSessionElementById("flash-notice");

            return notice;
        }

        private SessionElementScope GetStudyGroupSaveError()
        {
            var notice = _Browser.FindSessionElementById("error_messages");

            return notice;
        }

        internal void AddNewStudy(IMedidataStudy newMedidataStudy)
        {
            if (ReferenceEquals(newMedidataStudy,null)) throw new ArgumentNullException("newMedidataStudy");

            var navTab = GetNavigationLink(StudyGroupTab.Studies);
            navTab.Click();
            GetCreateNewStudyButton().Click();

            var studyPage = _Browser.GetImedidataStudyPage();
            studyPage.SetStudyAttributes(newMedidataStudy);
        }

        internal void CreateStudyGroup(SegmentSetupData newStudyGroup)
        {
            if (ReferenceEquals(newStudyGroup, null)) throw new ArgumentNullException("newStudyGroup");

            var newStudyGroupName   = newStudyGroup.SegmentName;
            var matchingStudyGroups = SearchForStudyGroups(newStudyGroupName);

            if (matchingStudyGroups.Any())
            {
                throw new ArgumentException(String.Format("Study Group {0} already exists", newStudyGroupName));
            }

            GetCreateStudyGroupButton().Click();
            SaveNewStudyGroupForm(newStudyGroup);
            
            _Browser.GoToHomePage();
        }
     
        private void SaveNewStudyGroupForm(SegmentSetupData newStudyGroup)
        {
            if (ReferenceEquals(newStudyGroup, null)) throw new ArgumentNullException("newStudyGroup");

            GetStudyGroupNameInput().FillInWith(newStudyGroup.SegmentName);
            GetStudyGroupOidInput() .FillInWith(newStudyGroup.ProdStudy.ExternalOid);
            GetStudyGroupCustomerSelectList().SelectOption(newStudyGroup.Customer);

            if (newStudyGroup.UseRaveX)
            {
                GetMccAdminAccessInput().Click();
            }
            
            var appsToSelect = newStudyGroup.StudyGroupApps.Where(x => !String.IsNullOrWhiteSpace(x.Name)).ToArray();

            foreach (var app in appsToSelect)
            {
                var appInput = GetAppInputByName(app.Name);
                appInput.SetCheckBoxState(true);
            }

            SaveStudyGroupInput();

            newStudyGroup.SegmentUuid = GetStudyGroupUuid();
        }

        private void SaveStudyGroupInput()
        {
            GetNewStudyGroupSaveButton().Click();

            RetryPolicy.GetAutoUpdatingElement.Execute(
                () =>
                {
                    var saveNotice   = GetStudyGroupSaveNotice();
                    var errorMessage = GetStudyGroupSaveError();

                    if (errorMessage.Exists())
                    {
                        throw new ApplicationException(String.Format("Error saving Study Group: {0}", errorMessage.Text));
                    }

                    if (!saveNotice.Exists() && !errorMessage.Exists())
                    {
                        throw new MissingHtmlException("Study Group Save not completed");
                    }
                });
        }

        internal IList<SessionElementScope> SearchForStudyGroups(string studyGroupName)
        {
            if (String.IsNullOrWhiteSpace(studyGroupName)) throw new ArgumentNullException("studyGroupName");

            GetStudyGroupSearchInput().FillInWith(studyGroupName).SendKeys(Keys.Return);

            var results = GetStudyGroupSearchResultRows();

            return results;
        }

        private void OpenStudyGroup(string studyGroupName)
        {
            if (String.IsNullOrWhiteSpace(studyGroupName)) throw new ArgumentNullException("studyGroupName");

            var matchingStudyGroups = SearchForStudyGroups(studyGroupName);

            if (matchingStudyGroups.Count != 1)
            {
                throw new ArgumentException(String.Format("Study Group {0} does not exist", studyGroupName));
            }

            var studyGroupLinks = matchingStudyGroups.First().FindAllSessionElementsByXPath(".//a");

            var studyGroupLink = studyGroupLinks.FirstOrDefault();

            if (ReferenceEquals(studyGroupLink, null))
            {
                throw new ArgumentException(String.Format("Could not find link for Study Group {0}", studyGroupName));
            }

            studyGroupLink.Click();
        }
        
        private SessionElementScope GetInviteApplicationsSelectList()
        {
            var applicationsSelectList = _Browser.FindSessionElementById("invitation_detail_invitation_app_details_attributes_0_app_id");

            return applicationsSelectList;

        }

        private SessionElementScope GetRoleSelectList()
        {
            var applicationsSelectList = _Browser.FindSessionElementById("invitation_detail_invitation_app_details_attributes_0_role_ids_");

            return applicationsSelectList;

        }

        private SessionElementScope GetInviteEmailTextbox()
        {
            var inviteEmailTextbox = _Browser.FindSessionElementById("invitation_detail_invitees");

            return inviteEmailTextbox;

        }

        private SessionElementScope GetInviteOwnerCheckBox()
        {
            var inviteOwnerCheckBox = _Browser.FindSessionElementById("invitation_detail_owner");

            return inviteOwnerCheckBox;

        }

        private SessionElementScope GetInviteButton()
        {
            var inviteButton = _Browser.FindSessionElementByXPath("//*[(@id='submit' and contains(text(),'Invite'))]");

            return inviteButton;

        }

        private IEnumerable<SessionElementScope> GetInvitationNotifications()
        {
            var flashNotifications =
                _Browser.FindAllSessionElementsByXPath("//div[(contains(@id, 'flash-notice'))]").ToList();
            
            var invitationNotifications =
                _Browser.FindAllSessionElementsByXPath("//div[(contains(@id, 'invitation_notification_'))]").ToList();

            invitationNotifications.AddRange(flashNotifications);

            return invitationNotifications;
        }

        private void WaitForUserToReceiveInvite(string userEmail)
        {
            if (String.IsNullOrWhiteSpace(userEmail)) throw new ArgumentNullException("userEmail");

            RetryPolicy.FindElement.Execute(() =>
            {
                var invitationNotifications = GetInvitationNotifications();

                var inviteNotification = invitationNotifications.FirstOrDefault(
                    x => x.Text.Contains(userEmail, StringComparison.OrdinalIgnoreCase));

                if (ReferenceEquals(inviteNotification, null))
                {
                    throw new MissingHtmlException(String.Format("User '{0}' has not yet received the invitation.", userEmail));
                }
            });
        }

        private void CLoseAllInvitationNotifications()
        {
            var invitationNotifications = GetInvitationNotifications();

            foreach (var invitationNotification in invitationNotifications)
            {
                if (invitationNotification.FindSessionElementByXPath(".//a").Exists(Config.ExistsOptions))
                {
                    var closeLink = invitationNotification.FindSessionElementByXPath(".//a");
                    closeLink.Click();
                }
            }
        }

        internal void InviteUser(string studyGroupName, string application, MedidataUser user)
        {
            if (String.IsNullOrWhiteSpace(studyGroupName)) throw new ArgumentNullException("studyGroupName");
            if (String.IsNullOrWhiteSpace(application))    throw new ArgumentNullException("application");
            if (ReferenceEquals(user, null))               throw new ArgumentNullException("user");
            if (String.IsNullOrWhiteSpace(user.Email))     throw new ArgumentNullException("user.Email");

            OpenStudyGroup(studyGroupName);

            GetInviteApplicationsSelectList().SelectOption(application);
            SendEmailToStudyGroupOwner(user.Email);
        }

        internal void SendEmailToStudyGroupOwner(string Email)
        {
            GetInviteEmailTextbox().FillInWith(Email);
            GetInviteOwnerCheckBox().SetCheckBoxState(true);
            GetInviteButton().Click();

            WaitForUserToReceiveInvite(Email);

            CLoseAllInvitationNotifications();
        }
        
        internal string GetUUID(string studyGroupName)
        {
            if (String.IsNullOrWhiteSpace(studyGroupName)) throw new ArgumentNullException("studyGroupName");

            OpenStudyGroup(studyGroupName);

            var header = _Browser.FindSessionElementByXPath("//*[@class='panel-title']");

            if (!header.Exists(Config.ExistsOptions))
            {
                throw new MissingHtmlException(String.Format("Could not find the header for study group {0}", studyGroupName));
            }

            string[] splitHeaderText = header.Text.Split(new string[] { studyGroupName, "(uuid: ", ")" }, StringSplitOptions.RemoveEmptyEntries);
            
            var uuid = splitHeaderText.FirstOrDefault(x=>!String.IsNullOrWhiteSpace(x)).Trim();

            Guid guuid;

            if(!Guid.TryParse(uuid, out guuid))
            {
                throw new MissingHtmlException(String.Format("Could not find the UUID for study group {0}", studyGroupName));
            }

            return uuid;
        }

        internal void UpdateUserAppPermission(string segmentName, Dictionary<string, string> appsAndRoles, MedidataUser user)
        {
            if (ReferenceEquals(segmentName, null)) throw new ArgumentNullException("segmentName");
            if (ReferenceEquals(appsAndRoles, null)) throw new ArgumentNullException("appsAndRoles");
            if (ReferenceEquals(user, null)) throw new ArgumentNullException("user");

            OpenStudyGroup(segmentName);

            foreach (KeyValuePair<string, string> pair in appsAndRoles)
            {
                GetInviteApplicationsSelectList().SelectOption(pair.Key);
                GetRoleSelectList().SelectOption(pair.Value);
                GetAddAppLink().Click();
            }

            SendEmailToStudyGroupOwner(user.Email);                       
        }
    }
}
