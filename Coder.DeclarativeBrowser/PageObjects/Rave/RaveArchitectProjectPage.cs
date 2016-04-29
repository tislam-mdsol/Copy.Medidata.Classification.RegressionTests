using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveArchitectProjectPage
    {
        private readonly BrowserSession _Session;

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

            var drafts = GetDrafts();

            return drafts.Select(x => x.Text).Contains(draftName);
        }
    }
}
