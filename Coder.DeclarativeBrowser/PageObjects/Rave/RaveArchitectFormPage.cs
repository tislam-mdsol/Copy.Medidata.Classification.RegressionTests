using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveArchitectFormPage
    {
        private readonly BrowserSession _Session;

        private const int _FieldLabelIndex = 3;
        private const int _FieldNameIndex = 2;
        private const int _FieldLinkIndex = 6;

        private const string _RaveDictionaryCoderPrefix = "CODER";

        internal RaveArchitectFormPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Session = session;
        }

        private SessionElementScope GetCodingDictionarySelectList()
        {
            var codingDictionarySelectList = _Session.FindSessionElementById("VC_ddlCodingDictionary");

            return codingDictionarySelectList;
        }

        private SessionElementScope GetSaveButton()
        {
            var saveButton = _Session.FindSessionElementById("_ctl0_Content_LnkBtnSave");

            return saveButton;
        }

        private SessionElementScope GetCoderConfigurationButton()
        {
            var coderConfigurationButton = _Session.FindSessionElementById("BtnCoderAdvanced");

            return coderConfigurationButton;
        }

        private SessionElementScope GetFieldsGrid()
        {
            var fieldsGrid = _Session.FindSessionElementById("_ctl0_Content_FieldsGrid");

            return fieldsGrid;
        }

        private IList<SessionElementScope> GetFieldsGridRows()
        {
            var fieldsGrid = GetFieldsGrid();

            var fieldsGridRows = fieldsGrid.FindAllSessionElementsByXPath(".//tr");

            return fieldsGridRows.ToList();
        }

        private SessionElementScope GetFieldLink(string fieldLabelOrName)
        {
            if (String.IsNullOrWhiteSpace(fieldLabelOrName)) throw new ArgumentNullException("fieldLabel");

            var fieldsGridRows = GetFieldsGridRows();
            if (!fieldsGridRows.Any())
            {
                return null;
            }

            var fieldLinkCell =
                (
                    from fieldsGridRow in fieldsGridRows
                    select fieldsGridRow.FindAllSessionElementsByXPath("td")
                    into field
                    where (field[_FieldLabelIndex].Text.EqualsIgnoreCase(fieldLabelOrName))
                    || (field[_FieldNameIndex].Text.EqualsIgnoreCase(fieldLabelOrName))
                    select field[_FieldLinkIndex]
                ).FirstOrDefault();

            if (ReferenceEquals(fieldLinkCell, null))
            {
                return null;
            }

            var fieldLink = fieldLinkCell.FindSessionElementByXPath(".//input");

            return fieldLink;
        }

        internal SessionElementScope GetFormLabel()
        {
            var formLabel = _Session.FindSessionElementById("_ctl0_Content_DispFormName");

            return formLabel;
        }

        private void SelectField(string fieldLabelOrName)
        {
            if (String.IsNullOrWhiteSpace(fieldLabelOrName)) throw new ArgumentNullException("fieldLabelOrName");

            var fieldLink = GetFieldLink(fieldLabelOrName);

            if (ReferenceEquals(fieldLink, null))
            {
                throw new MissingHtmlException(String.Format("Field, {0}, was not found. You ma need to use truncated field label or correct field name for the given form", fieldLabelOrName));
            }

            fieldLink.Click();
        }

        internal void SetCoderCodingDictionary(string fieldLabelOrName, string coderDictionary)
        {
            if (String.IsNullOrWhiteSpace(fieldLabelOrName)) throw new ArgumentNullException("fieldLabelOrName");
            if (String.IsNullOrWhiteSpace(coderDictionary)) throw new ArgumentNullException("coderDictionary");

            string raveDictionary = _RaveDictionaryCoderPrefix + coderDictionary;

            SetCodingDictionary(fieldLabelOrName, raveDictionary);
        }

        internal void SetCodingDictionary(string fieldLabelOrName, string dictionaryName)
        {
            if (String.IsNullOrWhiteSpace(fieldLabelOrName)) throw new ArgumentNullException("fieldLabelOrName");
            if (String.IsNullOrWhiteSpace(dictionaryName)) throw new ArgumentNullException("dictionaryName");

            SelectField(fieldLabelOrName);

            var codingDictionarySelectList = GetCodingDictionarySelectList();

            codingDictionarySelectList.SelectClosestOption(dictionaryName);

            GetSaveButton().Click();
        }

        internal string GetCoderCodingDictionary(string fieldLabel)
        {
            if (String.IsNullOrWhiteSpace(fieldLabel)) throw new ArgumentNullException("fieldLabel");

            SelectField(fieldLabel);

            var codingDictionarySelectList = GetCodingDictionarySelectList();

            var raveDictionary = codingDictionarySelectList.SelectedOption;
            var coderDictionaryRaw = raveDictionary.Replace(_RaveDictionaryCoderPrefix, String.Empty);
            var coderDictionary = coderDictionaryRaw.RemoveNonAlphanumeric();

            return coderDictionary;
        }

        internal void OpenRaveCoderConfiguration(string fieldLabel)
        {
            if (String.IsNullOrWhiteSpace(fieldLabel)) throw new ArgumentNullException("fieldLabel");

            SelectField(fieldLabel);

            _Session.WaitUntilElementExists(GetCoderConfigurationButton);

            GetCoderConfigurationButton().Click();
        }

    }
}
