using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Xml.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveArchitectProjectPage
    {
        private readonly BrowserSession _Session;

        private const int _Version             = 0;
        private const int _StudyConfigReport   = 1;
        private const int _PushVersion         = 2;
        private const int _DeleteVersion       = 3;

        internal RaveArchitectProjectPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private SessionElementScope GetAddNewDraftLink()
        {
            var addNewDraftLink = _Session.FindSessionElementById("_ctl0_Content_LnkBtnAddNewDraft");

            return addNewDraftLink;
        }

        private SessionElementScope GetNoDraftsLabel()
        {
            var noDraftsLabel = _Session.FindSessionElementById("_ctl0_Content_NoCrfDraftsLabel");

            return noDraftsLabel;
        }

        private SessionElementScope GetDraftsGrid()
        {
            var draftsGrid = _Session.FindSessionElementById("_ctl0_Content_DraftsGrid");

            return draftsGrid;
        }

        private IList<SessionElementScope> GetDrafts()
        {
            var draftsGrid = GetDraftsGrid();

            var drafts = draftsGrid.FindAllSessionElementsByXPath(".//a");

            return drafts.ToList();
        }

        private SessionElementScope GetDraftLink(string draftName)
        {
            if (String.IsNullOrWhiteSpace(draftName)) throw new ArgumentNullException("draftName");

            if (!DoesDraftExist(draftName))
            {
                throw new ArgumentException(String.Format("draftName '{0}' does not exist,", draftName));
            }

            var drafts = GetDrafts();

            var draft  = drafts.First(x => x.Text.EqualsIgnoreCase(draftName));

            return draft;
        }

        private SessionElementScope GetDraftVersionsGrid()
        {
            var versionsGrid = _Session.FindSessionElementById("_ctl0_Content_VersionsGrid");

            return versionsGrid;
        }

        private IList<SessionElementScope> GetDraftVersionRows()
        {
            var versionsGrid = GetDraftVersionsGrid();

            var versionRows = versionsGrid.FindAllSessionElementsByXPath(".//tr");

            return versionRows;
        }

        private SessionElementScope GetDraftVersionPushLink(String dictionaryVersion)
        {
            if (ReferenceEquals(dictionaryVersion, null)) throw new ArgumentNullException("dictionaryVersion");

            var versionRows = GetDraftVersionRows();

            if (!versionRows.Any())
            {
                throw new MissingHtmlException(String.Format("No CRF versions have been published"));
            }

            var versionRow = versionRows.FirstOrDefault(
                x => x.FindAllSessionElementsByXPath("td")[_Version].Text.Contains(dictionaryVersion));

            if (ReferenceEquals(versionRow, null))
            { throw new MissingHtmlException(String.Format("Cannot find row for version {0}", dictionaryVersion)); }

            var versionColumns = versionRow.FindAllSessionElementsByXPath("td");
            var pushLink = versionColumns[_PushVersion].FindSessionElementByXPath("a");

            return pushLink;
        }

        private IDictionary<string, SessionElementScope> GetDraftDeleteLinks()
        {
            var drafts = GetDrafts();
            var draftNames = drafts.Select(x => x.Text);

            var draftsGrid = GetDraftsGrid();

            var deleteLinks = draftsGrid.FindAllSessionElementsByXPath(".//input");

            var draftDeleteLinks = draftNames.Zip(deleteLinks, (k, v) => new {k, v}).ToDictionary(x => x.k, x => x.v);

            return draftDeleteLinks;
        }

        internal void OpenAddNewDraftPage()
        {
            GetAddNewDraftLink().Click();
        }

        internal void DeleteDraft(string draftName)
        {
            if (String.IsNullOrEmpty(draftName)) throw new ArgumentNullException("draftName");

            var draftDeleteLinks = GetDraftDeleteLinks();

            if (!draftDeleteLinks.ContainsKey(draftName))
            {
                throw new MissingHtmlException(String.Format("No deletion link found for draft, '{0}'", draftName));
            }

            var draftDeleteLink = draftDeleteLinks[draftName];

            draftDeleteLink.Click();

            _Session.AcceptConfirmationDialog("Are you sure you want to delete this Draft?");
        }

        internal bool DoesDraftExist(string draftName)
        {
            if (String.IsNullOrEmpty(draftName)) throw new ArgumentNullException("draftName");

            if (GetNoDraftsLabel().Exists(Config.ExistsOptions))
            {
                return false;
            }

            var drafts = GetDrafts();

            return drafts.Select(x => x.Text).Contains(draftName);
        }

        internal void OpenDraft(string draftName)
        {
            if (String.IsNullOrWhiteSpace(draftName)) throw new ArgumentNullException("draftName");

            var draftLink = GetDraftLink(draftName);

            draftLink.Click();
        }

        internal void OpenCRFPushDraftPage(string draftVersion)
        {
            if (String.IsNullOrWhiteSpace(draftVersion)) throw new ArgumentNullException("draftVersion");

            var draftVersionLink = GetDraftVersionPushLink(draftVersion);

            draftVersionLink.Click();

        }

        internal void DownloadDraft()
        {
            var crfDownloadLink = _Session.FindSessionElementByLink("Download");

            crfDownloadLink.Click();

            //Todo Find a way for fire fox to automatically download zip files
        }
    }
}
