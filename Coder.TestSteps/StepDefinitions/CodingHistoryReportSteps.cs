﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.FileHelpers;
using Coder.DeclarativeBrowser.Models;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class CodingHistoryReportSteps
    {
        private readonly CoderDeclarativeBrowser     _Browser;
        private readonly StepContext                 _StepContext;
        private readonly CodingHistoryReportCriteria _SearchCriteria;
        private string                               _CodingHistoryReportDescription;
        private const string                         DefaultFileName = "CodingHistoryReport";

        public CodingHistoryReportSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException(nameof(stepContext));
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext    = stepContext;
            _Browser        = _StepContext.Browser;
            _SearchCriteria = new CodingHistoryReportCriteria();
            _CodingHistoryReportDescription = "Coding History Report Description " + DateTime.UtcNow.ToLongDateString();
        }

        [When(@"searching for the verbatim ""(.*)"" in Coding History Report")]
        public void WhenSearchingForTheVerbatimInCodingHistoryReport(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException(nameof(verbatim));

            _SearchCriteria.Verbatim = verbatim;
        }

        [When(@"searching for the term ""(.*)"" in Coding History Report")]
        public void WhenSearchingForTheTermInCodingHistoryReport(string term)
        {
            if (String.IsNullOrWhiteSpace(term)) throw new ArgumentNullException(nameof(term));

            _SearchCriteria.Term = term;
        }

        [When(@"searching for the code ""(.*)"" in Coding History Report")]
        public void WhenSearchingForTheCodeInCodingHistoryReport(string code)
        {
            if (String.IsNullOrWhiteSpace(code)) throw new ArgumentNullException(nameof(code));

            _SearchCriteria.Code = code;
        }

        [When(@"searching for the status ""(.*)""")]
        public void WhenSearchingForTheStatus(string status)
        {
            if (String.IsNullOrWhiteSpace(status)) throw new ArgumentNullException(nameof(status));

                _SearchCriteria.StatusOptions = status.Split(',').ToList();
        }

        [When(@"searching for start date of ""(.*)"" and end date of ""(.*)"" in Coding History Report")]
        public void WhenSearchingForStartDateOfAndEndDateOfInCodingHistoryReport(string startDate, string endDate)
        {
            if (String.IsNullOrWhiteSpace(startDate)) throw new ArgumentNullException(nameof(startDate));
            if (String.IsNullOrWhiteSpace(endDate))   throw new ArgumentNullException(nameof(endDate)); 

            _SearchCriteria.StartDate = startDate;
            _SearchCriteria.EndDate   = endDate;
        }

        [When(@"searching for auto coded items in Coding History Report")]
        public void WhenSearchingForAutoCodedItemsInCodingHistoryReport()
        {
            _SearchCriteria.IncludeAutoCodedItems = true;
        }

        [When(@"exporting all columns in the Coding History Report")]
        public void WhenExportingAllColumnsInTheCodingHistoryReport()
        {
            _SearchCriteria.Study      = _StepContext.GetStudyName();

            _Browser.CreateCodingHistoryReport(_SearchCriteria, _CodingHistoryReportDescription);
        }

        [When(@"exporting the Coding History Report with export columns ""(.*)""")]
        public void WhenExportingTheCodingHistoryReportWithExportColumns(string exportColumnsValues)
        {
            if (String.IsNullOrWhiteSpace(exportColumnsValues)) throw new ArgumentNullException(nameof(exportColumnsValues));

            _SearchCriteria.IncludeAutoCodedItems = true;
            _SearchCriteria.ExportColumns         = exportColumnsValues.Split(',').ToList();
            _SearchCriteria.Study                 = _StepContext.GetStudyName();

            _Browser.CreateCodingHistoryReport(_SearchCriteria, _CodingHistoryReportDescription);
        }
        
        [When(@"exporting the Coding History Report for term ""(.*)"" with export columns ""(.*)""")]
        public void WhenExportingTheCodingHistoryReportForTermWithExportColumns(string term, string exportColumnsValues)
        {
            if (String.IsNullOrWhiteSpace(term))                throw new ArgumentNullException(nameof(term));
            if (String.IsNullOrWhiteSpace(exportColumnsValues)) throw new ArgumentNullException(nameof(exportColumnsValues));

            WhenSearchingForTheTermInCodingHistoryReport(term);

            _SearchCriteria.IncludeAutoCodedItems = true;
            _SearchCriteria.ExportColumns         = exportColumnsValues.Split(',').ToList();
            _SearchCriteria.Study                 = _StepContext.GetStudyName();

            _Browser.CreateCodingHistoryReport(_SearchCriteria, _CodingHistoryReportDescription);
        }

        [When(@"exporting the Coding History Report for verbatim ""(.*)"" with export columns ""(.*)""")]
        public void WhenExportingTheCodingHistoryReportForVerbatimWithExportColumns(string verbatim, string exportColumnsValues)
        {
            if (String.IsNullOrWhiteSpace(verbatim))            throw new ArgumentNullException(nameof(verbatim));
            if (String.IsNullOrWhiteSpace(exportColumnsValues)) throw new ArgumentNullException(nameof(exportColumnsValues));

            WhenSearchingForTheTermInCodingHistoryReport(verbatim);

            _SearchCriteria.IncludeAutoCodedItems = true;
            _SearchCriteria.ExportColumns         = exportColumnsValues.Split(',').ToList();
            _SearchCriteria.Study                 = _StepContext.GetStudyName();

            _Browser.CreateCodingHistoryReport(_SearchCriteria, _CodingHistoryReportDescription);
        }

        [Then(@"the Coding History Report should contain the following")]
        public void ThenTheCodingHistoryReportShouldContainTheFollowing(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException(nameof(table));

            var expectedResults = table
                .TransformFeatureTableStrings(_StepContext)
                .CreateSet<CodingHistoryReportRow>()
                .ToArray()
                .SetNonRequiredCodingHistoryReportColumnsToDefaultValues(
                    dictionary: _StepContext.Dictionary,
                    version   : _StepContext.Version,
                    locale    : _StepContext.Locale,
                    study     : _StepContext.GetStudyName());

            var actualResults = _Browser.GetCodingHistoryReportRows();
            
            for (int i = 0; i < expectedResults.Length; i++)
            {
                var expectedResult = expectedResults[i];
                var rowMatches     = actualResults[i].Equals(expectedResult);

                rowMatches.Should().BeTrue(String.Format("Row {0} should equal {1}", i, expectedResult.ToString()));
            }
        }

        [Then(@"the Coding History Report includes no query history information")]
        public void ThenTheCodingHistoryReportIncludesNoQueryHistoryInformation()
        {
            var actualResults = _Browser.GetCodingHistoryReportRows();

            foreach (var result in actualResults)
            {
                result.QueryNotes  .Should().BeNull();
                result.QueryReponse.Should().BeNull();
                result.QueryStatus .Should().BeNull();
                result.QueryText   .Should().BeNull();
            }
        }
    }
}
