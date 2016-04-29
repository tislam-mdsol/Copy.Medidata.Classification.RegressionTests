using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using Coypu.Timing;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveAddSubjectPage
    {
        private readonly BrowserSession _Session;

        private const string SubjectInititalsLabelText = "Subject Initials";
        private const string SubjectIdLabelText        = "Subject ID:";
        private const string SubjectNumberLabelText    = "Subject Number";
        
        internal RaveAddSubjectPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }
        
        private IList<SessionElementScope> GetFormRows()
        {
            var formRows = _Session.FindAllSessionElementsByXPath("//tr");

            return formRows;
        }

        private SessionElementScope GetFormRowByLabel(string label)
        {
            if (String.IsNullOrWhiteSpace(label)) throw new ArgumentNullException("label");

            var formRows = GetFormRows();

            var formRow = formRows.FirstOrDefault(x => x.Text.Contains(label, StringComparison.OrdinalIgnoreCase));

            if (ReferenceEquals(formRow, null))
            {
                throw new MissingHtmlException(String.Format("Could not find input for label '{0}'", label));
            }

            return formRow;
        }

        private IList<SessionElementScope> GetFormRowTextInputsByLabel(string label)
        {
            if (String.IsNullOrWhiteSpace(label)) throw new ArgumentNullException("label");

            var formRow = GetFormRowByLabel(label);
            
            var textInput = formRow.FindAllSessionElementsByXPath(".//input");

            return textInput;
        }

        private IList<SessionElementScope> GetFormRowSelectsByLabel(string label)
        {
            if (String.IsNullOrWhiteSpace(label)) throw new ArgumentNullException("label");

            var formRow = GetFormRowByLabel(label);

            var input = formRow.FindAllSessionElementsByXPath(".//select");

            return input;
        }

        private SessionElementScope GetFirstFormRowTextInputByLabel(string label)
        {
            if (String.IsNullOrWhiteSpace(label)) throw new ArgumentNullException("label");

            var inputs = GetFormRowTextInputsByLabel(label);

            return inputs.First();
        }

        private SessionElementScope GetSubjectInitialsTextBox()
        {
            var subjectInitialsTextBox = GetFirstFormRowTextInputByLabel(SubjectInititalsLabelText);

            return subjectInitialsTextBox;
        }

        private SessionElementScope GetSubjectNumberTextBox()
        {
            var subjectNumberTextBox = GetFirstFormRowTextInputByLabel(SubjectNumberLabelText);

            return subjectNumberTextBox;
        }

        private SessionElementScope GetSubjectIdTextBox()
        {
            var subjectIdTextBox = GetFirstFormRowTextInputByLabel(SubjectIdLabelText);

            return subjectIdTextBox;
        }

        private SessionElementScope GetSaveButton()
        {
            var saveButton = _Session.FindSessionElementByXPath("//input[contains(@id, '_footer_SB')]");

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

        internal void CreateNewSubjectWithNumber(string subjectInitials, string subjectNumber)
        {
            if (String.IsNullOrWhiteSpace(subjectInitials)) throw new ArgumentNullException("subjectInitials");
            if (String.IsNullOrWhiteSpace(subjectNumber))   throw new ArgumentNullException("subjectNumber");

            _Session.WaitUntilElementExists(GetSubjectInitialsTextBox);
            _Session.WaitUntilElementExists(GetSubjectNumberTextBox);
            _Session.WaitUntilElementExists(GetSaveButton);

            var subjectInitialsTextBox = GetSubjectInitialsTextBox();
            subjectInitialsTextBox.FillInWith(subjectInitials);

            var subjectIdTextBox = GetSubjectNumberTextBox();
            subjectIdTextBox.FillInWith(subjectNumber);

            var saveButton = GetSaveButton();
            saveButton.Click();
        }
    }
}
