using System;
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
    public class CodingDecisionsReportSteps
    {
        private readonly CoderDeclarativeBrowser             _Browser;
        private readonly StepContext                         _StepContext;
        private readonly CodingDecisionsReportCriteria _SearchCriteria;
        private const string                                 DefaultFileName = "CodingDecisionsReport";

        public CodingDecisionsReportSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext    = stepContext;
            _Browser        = _StepContext.Browser;
            _SearchCriteria = new CodingDecisionsReportCriteria();
        }

        [When(@"searching for the verbatim ""(.*)"" in Coding Decisions Report")]
        public void WhenSearchingForTheVerbatimInReport(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");

            _SearchCriteria.Verbatim = verbatim;
        }

        [When(@"searching for the status ""(.*)"" in Coding Decisions Report")]
        public void WhenSearchingForTheStatus(string status)
        {
            if (String.IsNullOrWhiteSpace(status)) throw new ArgumentNullException("status");

            _SearchCriteria.CurrentStatus = status;
        }

        [When(@"searching for start date of ""(.*)"" and end date of ""(.*)"" in Coding Decisions Report")]
        public void WhenSearchingForStartDateOfAndEndDateOfInReport(string startDate, string endDate)
        {
            if (String.IsNullOrWhiteSpace(startDate)) throw new ArgumentNullException("startDate");
            if (String.IsNullOrWhiteSpace(endDate))   throw new ArgumentNullException("endDate");

            _SearchCriteria.StartDate = startDate;
            _SearchCriteria.EndDate   = endDate;
        }

        [When(@"searching for auto coded items in Coding Decisions Report")]
        public void WhenSearchingForAutoCodedItemsInReport()
        {
            _SearchCriteria.IncludeAutoCodedItems = true;
        }

        [When(@"exporting all columns in the Coding Decisions Report")]
        public void WhenExportingAllColumnsInTheReport()
        {
            _SearchCriteria.Study      = _StepContext.GetStudyName();
            _SearchCriteria.AllColumns = true;

            _Browser.ExportCodingDecisionsReport(_SearchCriteria);
        }

        [Then(@"the Coding Decisions Report should contain the following")]
        public void ThenTheCodingDecisionsReportShouldContainTheFollowing(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var expectedResults = table
                .TransformFeatureTableStrings(_StepContext)
                .CreateSet<CodingDecisionsReportRow>()
                .ToArray()
                .ValidateCodingDecisionsReportRequiredColumns()
                .SetNonRequiredCodingDecisionsReportColumnsToDefaultValues(
                    study     : _StepContext.GetStudyName(),
                    dictionary: _StepContext.Dictionary,
                    version   : _StepContext.Version,
                    locale    : _StepContext.Locale,
                    userName  : _StepContext.GetUser());

            var actualResults = _Browser.GetCodingDecisionReportRows();

            foreach (var expectedResult in expectedResults)
            {
                var anyMatch = actualResults.Any(x => x.Equals(expectedResult));

                anyMatch.Should().BeTrue(String.Format("Coding Decision should contain {0}", expectedResult.ToString()));
            }
        }
    }
}
