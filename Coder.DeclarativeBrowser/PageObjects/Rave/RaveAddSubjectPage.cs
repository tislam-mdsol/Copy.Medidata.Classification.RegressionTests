using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveAddSubjectPage
    {
        private readonly BrowserSession _Session;

        internal RaveAddSubjectPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private SessionElementScope GetSubjectInitialsTextBox()
        {
            var subjectInitialsTextBox = _Session.FindSessionElementById("_ctl0_Content_CRFRenderer_field17553_17553_CRFControl_17553_CRFControl_Text");

            return subjectInitialsTextBox;
        }

        private SessionElementScope GetSubjectIdTextBox()
        {
            var subjectIdTextBox = _Session.FindSessionElementById("_ctl0_Content_CRFRenderer_field17554_17554_CRFControl_17554_CRFControl_Text");

            return subjectIdTextBox;
        }

        private SessionElementScope GetSaveButton()
        {
            var saveButton = _Session.FindSessionElementById("_ctl0_Content_CRFRenderer_footer_SB");

            return saveButton;
        }

        internal void CreateNewSubject(string subjectInitials, string subjectId)
        {
            if (String.IsNullOrWhiteSpace(subjectInitials)) throw new ArgumentNullException("subjectInitials");
            if (String.IsNullOrWhiteSpace(subjectId))       throw new ArgumentNullException("subjectId");

            _Session.WaitUntilElementExists(GetSubjectInitialsTextBox);
            _Session.WaitUntilElementExists(GetSubjectIdTextBox);
            _Session.WaitUntilElementExists(GetSaveButton);

            var subjectInitialsTextBox = GetSubjectInitialsTextBox();
            subjectInitialsTextBox.FillInWith(subjectInitials);

            var subjectIdTextBox = GetSubjectIdTextBox();
            subjectIdTextBox.FillInWith(subjectId);

            var saveButton = GetSaveButton();
            saveButton.Click();
        }
    }
}
