//@author:smalik
using System;
using System.Data;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.Models.ETEModels;
using System.Linq;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class DataListingReportPage
    {
        private readonly BrowserWindow _BrowserWindow;

        internal DataListingReportPage(BrowserWindow browserWindow)
        {
            if (ReferenceEquals(browserWindow, null)) throw new ArgumentNullException("browserWindow");

            _BrowserWindow = browserWindow;
        }

        private SessionElementScope GetDataSourceDDL()
        {
            var dataSourceDDL = _BrowserWindow.FindSessionElementById("ddlSource");

            return dataSourceDDL;
        }

        private SessionElementScope GetFormDDL()
        {
            var formDDL = _BrowserWindow.FindSessionElementById("ddlDomain");

            return formDDL;
        }

        private SessionElementScope GetRunButtonOnReport()
        {
            var runButton = _BrowserWindow.FindSessionElementById("btnRun");

            return runButton;
        }

        private SessionElementScope GetReportResultGrid()
        {
            var reportResultGrid = _BrowserWindow.FindSessionElementById("dgResult");

            return reportResultGrid;
        }

        internal DataTable GetReportResultData()
        {
            var reportData = new DataTable();

            var codingOnReportTable = GetReportResultGrid();
            var codingDecisionRows = codingOnReportTable.GetTableRows().ToList();

            var columnNames = codingDecisionRows[0].FindAllSessionElementsByXPath(".//td");

            reportData.Columns.AddRange(columnNames.Select(x => new DataColumn(x.Text)).ToArray());

            for (int rowIndex = 1; rowIndex < codingDecisionRows.Count; rowIndex++)
            {
                var rowValues = codingDecisionRows[rowIndex].FindAllSessionElementsByXPath(".//td");

                var row = reportData.NewRow();
                row.ItemArray = rowValues.Select(x => x.Text).ToArray();

                reportData.Rows.Add(row);
            }

            return reportData;
        }

        internal void SetUpDDLValuesInDataListingReport(string dataSource, string formName)
        {
            if (String.IsNullOrWhiteSpace(dataSource)) throw new ArgumentNullException("dataSource");
            if (String.IsNullOrWhiteSpace(formName))   throw new ArgumentNullException("formName");
     
            var form = formName + " (" + formName + ")";

            GetDataSourceDDL()    .SelectOption(dataSource);
            GetFormDDL()          .SelectOption(form);
            GetRunButtonOnReport().Click();
        }

    }
}
