using System;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.DeclarativeBrowser.Models;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    public static class TableExtensionMethods
    {
        public static IList<AssignmentDetail> GetAssignmentDetailTableValues(
            this CoderDeclarativeBrowser browser)
        {
            if (ReferenceEquals(browser, null))  throw new ArgumentNullException("browser"); 

            var result = browser
                .Session
                .GetTaskPageAssigmentsTab()
                .GetAssignmentDetailTableValues();

            return result;
        }

        public static IList<AssignmentDetailPath> GetAssignmentsPathTableValues(
            this CoderDeclarativeBrowser browser)
        {
            if (ReferenceEquals(browser, null))  throw new ArgumentNullException("browser"); 

            var result = browser
                .Session
                .GetTaskPageAssigmentsTab()
                .GetAssignmentsPathTableValues();

            return result;
        }

        public static IList<CodingHistoryDetail> GetCodingHistoryTableValues(
            this CoderDeclarativeBrowser browser)
        {
            if (ReferenceEquals(browser, null))  throw new ArgumentNullException("browser"); 

            var result = browser
                .Session
                .GetTaskPageCodingHistoryTab()
                .GetCodingHistoryDetailValues();

            return result;
        }

        public static List<string> GetCodingHistoryTableAdditionalInformationValues(this CoderDeclarativeBrowser browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            var result = browser
                .Session
                .GetTaskPageCodingHistoryTab()
                .GetCodingHistoryDetailAdditionalInformationValues();

            return result;
        }

        public static IList<QueryHistoryDetail> GetQueryHistoryTableValues(this CoderDeclarativeBrowser browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            var result = browser
                .Session
                .GetTaskPageQueryHistoryTab()
                .GetQueryHistoryDetailValues();

            return result;
        }

        public static List<string> GetQueryHistoryTableAdditionalInformationValues(this CoderDeclarativeBrowser browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            var result = browser
                .Session
                .GetTaskPageQueryHistoryTab()
                .GetQueryHistoryDetailAdditionalInformationValues();

            return result;
        }

        public static SourceTerm GetSourceTermTableValues(
            this CoderDeclarativeBrowser browser)
        {
            if (ReferenceEquals(browser, null))  throw new ArgumentNullException("browser"); 

            var result = browser
                .Session
                .GetTaskPageSourceTermTab()
                .GetSourceTermTableValues();

            return result;
        }

        public static PropertyMedicalDictionary GetPropertyMedicalDictionaryTableValues(
            this CoderDeclarativeBrowser browser)
        {
            if (ReferenceEquals(browser, null))  throw new ArgumentNullException("browser"); 

            var taskPagePropertiesTab = browser.Session.GetTaskPagePropertiesTab();

            taskPagePropertiesTab.ExpandMedicalDictionaryGrid();

            var result = taskPagePropertiesTab.GetPropertyMedicalDictionaryTableValues();

            return result;
        }

        public static PropertySourceSystem GetPropertySourceSystemTableValues(
            this CoderDeclarativeBrowser browser)
        {
            if (ReferenceEquals(browser, null))  throw new ArgumentNullException("browser"); 

            var taskPagePropertiesTab = browser.Session.GetTaskPagePropertiesTab();

            taskPagePropertiesTab.ExpandSourceSystemGrid();

            var result = taskPagePropertiesTab.GetPropertySourceSystemTableValues();

            return result;
        }

        public static PropertyCodingStatus GetPropertyCodingStatusTableValues(
            this CoderDeclarativeBrowser browser)
        {
            if (ReferenceEquals(browser, null))  throw new ArgumentNullException("browser"); 

            var taskPagePropertiesTab = browser.Session.GetTaskPagePropertiesTab();

            taskPagePropertiesTab.ExpandCodingStatusGrid();

            var result = taskPagePropertiesTab.GetPropertyCodingStatusTableValues();

            return result;
        }

        public static SourceTermEdcReference GetSourceTermEdcReferenceTableValues(
            this CoderDeclarativeBrowser browser)
        {
            if (ReferenceEquals(browser, null))  throw new ArgumentNullException("browser"); 

            var result = browser
                .Session
                .GetTaskPageSourceTermTab()
                .GetSourceTermEdcReferenceTableValues();

            return result;
        }

        public static IList<SupplementalTerm> GetSupplementalTableValues(
            this CoderDeclarativeBrowser browser)
        {
            if (ReferenceEquals(browser, null))  throw new ArgumentNullException("browser"); 

            var result = browser
                .Session
                .GetTaskPageSourceTermTab()
                .GetSupplementalTableValues();

            return result;
        }

        public static AdminConfigurationManagement GetAdminConfigurationManagementValues(
            this CoderDeclarativeBrowser browser,
            string medicalDictionaryName)
        {
            if (ReferenceEquals(browser, null))                   throw new ArgumentNullException("browser");
            if (String.IsNullOrWhiteSpace(medicalDictionaryName)) throw new ArgumentNullException("medicalDictionaryName"); 

            var result = browser
                .Session
                .GetAdminConfigurationManagementPage()
                .GetAdminConfigurationManagementPageValues(medicalDictionaryName);

            return result;
        }

        public static DictionarySearchResult GetDictionarySearchResults(
            this CoderDeclarativeBrowser browser,
            IList<TermPathRow> rowsToExpand)
        {
            if (ReferenceEquals(browser, null))     throw new ArgumentNullException("browser");
            if (ReferenceEquals(rowsToExpand,null)) throw new ArgumentNullException("rowsToExpand");

            var dictionarySearchPanel = browser.Session.GetDictionarySearchPanel();

            foreach (var rowToExpand in rowsToExpand)
            {
                dictionarySearchPanel.ExpandSearchResult(rowToExpand);
            }

            var searchResult = new DictionarySearchResult()
            {
                HumanReadableQuery = dictionarySearchPanel.GetHumanReadableQuery(),
                SearchResults      = dictionarySearchPanel.GetAllSearchResultTerms()
            };

            return searchResult;
        }

        public static DictionarySelectedSearchResult GetDictionarySelectedSearchResultInformation(
            this CoderDeclarativeBrowser browser, 
            TermPathRow termPathRow)
        {
            if (ReferenceEquals(browser, null))     throw new ArgumentNullException("browser");
            if (ReferenceEquals(termPathRow, null)) throw new ArgumentNullException("termPathRow");

            var dictionarySearchPanel = browser.Session.GetDictionarySearchPanel();
            dictionarySearchPanel.SelectDictionarySearchResult(termPathRow);

            var selectionPanel = browser.Session.GetDictionarySearchSelection();

            var selectedSearchResult = selectionPanel.GetSelectedSearchResultData();

            return selectedSearchResult;
        }
    }
}
