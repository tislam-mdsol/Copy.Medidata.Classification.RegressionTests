using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu;
using Polly;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class TaskPageSourceTermTab
    {
        private readonly BrowserSession _Browser;
        private const string EmptyHtmlValue = "&nbsp;";

        public TaskPageSourceTermTab(BrowserSession browser) { if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }  _Browser = browser; }

        public SessionElementScope GetSourceTermFrame()
        {
            var sourceTermFrame = _Browser.FindSessionElementByXPath("//iframe[@id = 'ctl00_Content_FrmSourceTerm']");

            return sourceTermFrame;
        }

        public IList<SessionElementScope> GetSourceTermGridRowValues()
        {
            var sourceTermGridRows = GetSourceTermFrame()
                .FindAllSessionElementsByXPath(
                "//table[@id = 'gridSourceTerm_DXMainTable']/tbody/tr[contains(@id, 'gridSourceTerm_DXDataRow')]/td");

            return sourceTermGridRows;
        }

        public IList<SessionElementScope> GetEdcReferenceGridValues()
        {
            var edcReferenceGridRows = GetSourceTermFrame()
                .FindAllSessionElementsByXPath(
                "//table[@id = 'gridReference_DXMainTable']/tbody/tr[contains(@id, 'gridReference_DXDataRow')]/td[2]");

            return edcReferenceGridRows;
        }

        public IList<SessionElementScope> GetSupplementalGridRows()
        {
            var supplementalGridRows = GetSourceTermFrame()
                .FindAllSessionElementsByXPath(
                "//table[@id = 'gridSupplemental_DXMainTable']/tbody/tr[contains(@id, 'gridSupplemental_DXDataRow')]");

            return supplementalGridRows;
        }

        public SourceTerm GetSourceTermTableValues()
        {
            var sourceTermGridRowValues = GetSourceTermGridRowValues();

            var sourceTermValues = new SourceTerm
            {
                SourceSystem        = sourceTermGridRowValues[0].Text,
                Study               = sourceTermGridRowValues[1].Text,
                Dictionary          = sourceTermGridRowValues[2].Text,
                Locale              = sourceTermGridRowValues[3].Text,
                Term                = sourceTermGridRowValues[4].Text,
                Level               = sourceTermGridRowValues[5].Text,
                Priority            = sourceTermGridRowValues[6].Text
            };

            return sourceTermValues;
        }

        public SourceTermEdcReference GetSourceTermEdcReferenceTableValues()
        {
            var edcReferenceGridValues = GetEdcReferenceGridValues();

            var sourceTermEdcReference = new SourceTermEdcReference
            {
                Field               = edcReferenceGridValues[0].Text,
                Line                = edcReferenceGridValues[1].Text,
                Form                = edcReferenceGridValues[2].Text,
                Event               = edcReferenceGridValues[3].Text,
                Subject             = edcReferenceGridValues[4].Text,
                Site                = edcReferenceGridValues[5].Text
            };

            return sourceTermEdcReference;
        }

        public IList<SupplementalTerm> GetSupplementalTableValues()
        {
            var supplementRowsResult = RetryPolicy.FindElementShort.ExecuteAndCapture
                (() =>
                {
                    if (GetSupplementalGridRows().Count.Equals(0))
                    {
                        throw new MissingHtmlException("Supplemental table not loaded");
                    }
                });

            if (supplementRowsResult.Outcome == OutcomeType.Failure)
            {
                return null;
            }
            

            //TODO: strip the extra find all xpath into separate method in refactor user story
            var supplementalValues = (
                from supplementalGridRow in GetSupplementalGridRows()
                select supplementalGridRow.FindAllSessionElementsByXPath("td")
                into supplementalColumns
                select new SupplementalTerm
                {
                    Term    = supplementalColumns[0].InnerHTML,
                    Value   = supplementalColumns[1].InnerHTML.Equals(EmptyHtmlValue) ? string.Empty : supplementalColumns[1].InnerHTML
                })
                .ToList();

            return supplementalValues;
        }

        internal string GetSourceTermStudyNameByTerm(string term)
        {
            if (String.IsNullOrWhiteSpace(term)) throw new ArgumentNullException("term"); 

            var studyName = RetryPolicy.ValidateOperation.Execute(
                () =>
                {
                    var sourceTermValues = GetSourceTermTableValues();
                    var study            = sourceTermValues.Study;

                    if (!term.EqualsIgnoreCase(sourceTermValues.Term))
                    {
                        throw new InvalidOperationException("incorrect term");
                    }

                    if (study.Contains("-"))
                    {
                        study = study.Split('-').First().Trim();
                    }

                    return study;
                });

            return studyName;
        }
    }
}
