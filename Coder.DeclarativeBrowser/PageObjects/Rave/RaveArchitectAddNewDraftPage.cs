using Coypu;
using System;
using Coder.DeclarativeBrowser.ExtensionMethods;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{

    internal sealed class RaveArchitectAddNewDraftPage
    {
        private readonly BrowserSession _Session;

        internal RaveArchitectAddNewDraftPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private SessionElementScope GetDraftNameTextBox()
        {
            var draftNameTextBox = _Session.FindSessionElementById("_ctl0_Content_DraftText");

            return draftNameTextBox;
        }

        private SessionElementScope GetDraftMessageTextBox()
        {
            var draftMessageTextBox = _Session.FindSessionElementById("_ctl0_Content_DraftMessageText");

            return draftMessageTextBox;
        }

        private SessionElementScope GetCreateDraftButton()
        {
            var createDraftButton = _Session.FindSessionElementById("_ctl0_Content_CreateButton");

            return createDraftButton;
        }

        internal void CreateDraft(string draftName, string draftMessage = null)
        {
            if (String.IsNullOrWhiteSpace(draftName)) throw new ArgumentNullException("draftName");

            GetDraftNameTextBox().SendKeys(draftName);

            if (!ReferenceEquals(draftMessage, null))
            {
                GetDraftMessageTextBox().SendKeys(draftName);
            }

            GetCreateDraftButton().Click();
        }
    }
}
