using System;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.Models.ETEModels;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class ReportMainCreationCoderPage
    {
        private readonly BrowserSession _Browser;
        private const string PageName = "Main Report Page";

        private const int _ReportTypeIndex                  = 1;
        private const int _DescriptionIndex                 = 2;                
        private const int _InformationStudyTextIndex        = 0; //hidden embedded object
        private const int _InformationDictionaryTextIndex   = 2; //hidden embedded object
        private const int _LastRunIndex                     = 5;
        private const int _ReportStatusIndex                = 6;

        internal ReportMainCreationCoderPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        private SessionElementScope GetCreateNewFilterButton()
        {
            var createNewButton = _Browser.FindSessionElementById("gotoFilter");

            return createNewButton;
        }

        private SessionElementScope GetMainReportTable()
        {
            var mainReportTable = _Browser.FindSessionElementById("tableAllReports");

            return mainReportTable;
        }

        private SessionElementScope GetDescriptionLink(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);

            var descriptionLink = _Browser.FindSessionElementByLink(descriptionText);

            return descriptionLink;
        }

        private SessionElementScope GetReportInformationButton(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);

            var reportTable = GetMainReportTable();
            var reportRow = reportTable.FindTableRow(descriptionText);
            var informationIcon = reportRow.FindAllSessionElementsByXPath(".//a");
            var informationReportLink = informationIcon.FirstOrDefault(x => x.Class.Contains("lnk btn-link plain-tooltip", StringComparison.OrdinalIgnoreCase));

            if (ReferenceEquals(informationReportLink, null))
            {
                throw new MissingHtmlException(String.Format("No Information Icon for description: {0}", descriptionText));
            }

            return informationReportLink;
        }

        private List<string> GetInformationStudyAndDictionaryText(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);
            List<string> hiddenInformation = null;

            var reportTable = GetMainReportTable();
            var reportRow = reportTable.FindTableRow(descriptionText);

            GetReportInformationButton(descriptionText).Hover();
            var hiddenTable = reportRow.FindSessionElementById("tooltipContent");
            var hiddenTableTDs = hiddenTable.FindAllSessionElementsByXPath(".//tbody/tr/td");

            hiddenInformation.Add(hiddenTableTDs[_InformationStudyTextIndex].Text);
            hiddenInformation.Add(hiddenTableTDs[_InformationDictionaryTextIndex].Text);

            return hiddenInformation;
        }


        private SessionElementScope GetViewLink(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);

            var reportTable = GetMainReportTable();
            var reportRow   = reportTable.FindTableRow(descriptionText);
            var viewLink    = reportRow.FindSessionElementByLink("View");
            
            return viewLink;
        }

        private SessionElementScope SelectMainReportRadioOption(string reportRadioOption)
        {
            if (String.IsNullOrWhiteSpace(reportRadioOption)) throw new ArgumentNullException(reportRadioOption);

            switch (reportRadioOption)
            {
                case "Coding History":   { SessionElementScope selectedRadioOption = _Browser.FindSessionElementById("codingHistoryFilter");   return selectedRadioOption; }
                case "Coding Decisions": { SessionElementScope selectedRadioOption = _Browser.FindSessionElementById("codingDecisionsFilter"); return selectedRadioOption; }
                case "Ingredients":      { SessionElementScope selectedRadioOption = _Browser.FindSessionElementById("ingredientsFilter");     return selectedRadioOption; }
                case "Study":            { SessionElementScope selectedRadioOption = _Browser.FindSessionElementById("studyFilter");           return selectedRadioOption; }
                default:                 { throw new ArgumentNullException("Invalid Report Select Option: " + reportRadioOption);                                          }
            }
        }

        private SessionElementScope GetExportLink(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);

            var reportTable = GetMainReportTable();
            var reportRow = reportTable.FindTableRow(descriptionText);
            var reportRowExportLink = reportRow.FindSessionElementByLink("Export");

            return reportRowExportLink;
        }

        internal MainReportTableModel GetMainReportPageTableRowText(string descriptionText)
        {
            var mainReportTable = GetMainReportTable();
            var mainReportRow = mainReportTable.FindTableRow(descriptionText);
            var mainReportTableRowTds = mainReportRow.FindAllSessionElementsByXPath(".//td");
            var hiddenInformation = GetInformationStudyAndDictionaryText(descriptionText);

            var mainReportTableRowsValues = new MainReportTableModel
            {
                ReportType                = mainReportTableRowTds[_ReportTypeIndex].Text,
                Description               = mainReportTableRowTds[_DescriptionIndex].Text,
                InformationDictionaryText = hiddenInformation[0],
                InformationStudyText      = hiddenInformation[1],
                LastRun                   = mainReportTableRowTds[_LastRunIndex].Text,
                ReportStatus              = mainReportTableRowTds[_ReportStatusIndex].Text
            };

            return mainReportTableRowsValues;
        }


        internal void CreateNewReport(string reportType)
        {
            if (String.IsNullOrWhiteSpace(reportType)) throw new ArgumentNullException(reportType);

            var selectRadioOption  = SelectMainReportRadioOption(reportType);
            var createReportButton = GetCreateNewFilterButton();

            selectRadioOption.Click();
            createReportButton.Click();
        }

        internal void SelectExportReport(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);

            var exportLink = GetExportLink(descriptionText);

            _Browser.WaitUntilElementExists(() => exportLink);

            exportLink.Click();
        }

        internal void SelectStudyReportViewLink(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);
            
            var viewLink = GetViewLink(descriptionText);

            _Browser.WaitUntilElementExists(() => viewLink);

            viewLink.Click();
        }

        internal void DeleteReport(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);

            var reportTable  = GetMainReportTable();
            var reportRow    = reportTable.FindTableRow(descriptionText); 
            var deleteIcon   = reportRow.FindAllSessionElementsByXPath(".//a");
            var deleteReportLink = deleteIcon.FirstOrDefault(x => x.Class.Contains("lnk btn-link", StringComparison.OrdinalIgnoreCase));

            if (ReferenceEquals(deleteReportLink, null))
            {
                throw new MissingHtmlException(String.Format("No Trash Icon for description: {0}", descriptionText));
            }

            deleteReportLink.Click();
        }

        internal void UpdateReport(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);

            GetDescriptionLink(descriptionText).Click();
        }


    }
}
