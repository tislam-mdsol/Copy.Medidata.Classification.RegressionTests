using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using OpenQA.Selenium;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveArchitectFormsPage
    {
        private readonly BrowserSession _Session;
        
        private const string _FormNameHeaderText = "Form Name";
        private const string _FormLinkHeaderText = "Fields";

        internal RaveArchitectFormsPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Session = session;
        }

        private SessionElementScope GetFormSearchTextBox()
        {
            var formSearchTextBox = _Session.FindSessionElementById("_ctl0_Content_TextBoxFilter");

            return formSearchTextBox;
        }

        private SessionElementScope GetFormSearchButton()
        {
            var formSearchButton = _Session.FindSessionElementById("_ctl0_Content_ImgBtnSearch");

            return formSearchButton;
        }

        private SessionElementScope GetFormsGrid()
        {
            var formsGrid = _Session.FindSessionElementById("_ctl0_Content_FormGrid");

            return formsGrid;
        }

        private IList<SessionElementScope> GetFormsGridRows()
        {
            var formsGrid = GetFormsGrid();

            var formsGridRows = formsGrid.FindAllSessionElementsByXPath(".//tr");

            return formsGridRows.ToList();
        }

        private int GetFormsGridColumnIndex(string columnName)
        {
            var formsGridRows = GetFormsGridRows();

            var headerRow = formsGridRows.First();

            var headers = headerRow.FindAllSessionElementsByXPath("td").ToList();

            var header = headers.Single(x => x.Text.EqualsIgnoreCase(columnName));

            if (ReferenceEquals(header, null))
            {
                throw new MissingHtmlException(String.Format("Column {0} could not be found.", columnName));
            }

            int columnIndex = headers.IndexOf(header);

            return columnIndex;
        }

        private SessionElementScope GetFormLink(string formName)
        {
            if (String.IsNullOrWhiteSpace(formName)) throw new ArgumentNullException("formName");

            var formsGrid    = GetFormsGrid();

            var formLinkCell = formsGrid.FindTableCell(_FormNameHeaderText, formName, _FormLinkHeaderText);

            var formLink     = formLinkCell.FindSessionElementByXPath(".//a");

            return formLink;
        }
        
        internal void OpenForm(string formName)
        {
            if (String.IsNullOrWhiteSpace(formName)) throw new ArgumentNullException("formName");

            var formLink = SearchForFormLink(formName);

            if (ReferenceEquals(formLink, null))
            {
                throw new MissingHtmlException(String.Format("Form, {0}, was not found.", formName));
            }

            formLink.Click();
        }
        
        private SessionElementScope SearchForFormLink(string formName)
        {
            if (String.IsNullOrWhiteSpace(formName)) throw new ArgumentNullException("formName");

            if (ReferenceEquals(GetFormLink(formName), null))
            {
                _Session.WaitUntilElementExists(GetFormSearchTextBox);

                var formSearchTextBox = GetFormSearchTextBox();

                formSearchTextBox.FillInWith(formName).SendKeys(Keys.Return);

                _Session.WaitUntilElementExists(GetFormsGrid);
            }

            return GetFormLink(formName);
        }
    }

}
