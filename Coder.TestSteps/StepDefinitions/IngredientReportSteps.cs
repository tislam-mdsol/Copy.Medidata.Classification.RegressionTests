﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using FluentAssertions;
using Newtonsoft.Json;
using TechTalk.SpecFlow;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public sealed class IngredientReportSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext             _StepContext;
        private readonly string                  _IngredientReportDescription;

        public IngredientReportSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser     = _StepContext.Browser;

            _IngredientReportDescription = "Ingredient Report Description " + DateTime.UtcNow.ToLongDateString();
        }

        [Then(@"the appropriate ingredient report is generated")]
        public void ThenTheAppropriateIngredientReportIsGenerated()
        {
            _Browser.CreateIngredientReport(_StepContext.GetStudyName(), _StepContext.Dictionary, _IngredientReportDescription);

            _Browser.IngredientExportReport(_IngredientReportDescription);

            var expectedResults = GetIngredientReportContentByFileName("Ingredient_Report.json");

            expectedResults.SetOptionalIngredientReportRowColumns(_StepContext.SegmentUnderTest.ProdStudy.StudyName);

            var actualResults = _Browser.GetIngredientReportRows();

            expectedResults.Count.ShouldBeEquivalentTo(actualResults.Count());

            foreach (var expectedResult in expectedResults)
            {
                var anyMatch = actualResults.Any(x => x.Equals(expectedResult));

                anyMatch.Should().BeTrue(String.Format("Ingredients Report should contain: {0}", expectedResult.ToString()));
            }
        }

        private IList<IngredientReportRow> GetIngredientReportContentByFileName(string fileName)
        {
            if (String.IsNullOrWhiteSpace(fileName)) throw new ArgumentNullException("fileName");

            var filePath     = Config.StaticContentFolder.AppendFileNameToDirectoryPath(fileName);
            var fileContents = File.ReadAllText(filePath);
            var reportRows   = JsonConvert.DeserializeObject<List<IngredientReportRow>>(fileContents);

            return reportRows;
        }
    }
}
