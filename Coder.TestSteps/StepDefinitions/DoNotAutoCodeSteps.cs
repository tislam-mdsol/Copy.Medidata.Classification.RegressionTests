using System;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.Models;
using TechTalk.SpecFlow;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class DoNotAutoCodeSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext _StepContext;

        public DoNotAutoCodeSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser     = _StepContext.Browser;
        }

        [When(@"do not auto code ""(.*)"" for dictionary ""(.*)"" level ""(.*)""")]
        public void WhenDoNotAutoCodeForDictionaryLevel(string verbatimTerm, string dictionaryList, string dictionaryLevel)
        {
            if (String.IsNullOrWhiteSpace(verbatimTerm))    throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrWhiteSpace(dictionaryList))  throw new ArgumentNullException("dictionaryList");
            if (String.IsNullOrWhiteSpace(dictionaryLevel)) throw new ArgumentNullException("dictionaryLevel");

            _Browser.DoNotAutoCodeTerm(
                segmentName    : _StepContext.Segment,
                verbatimTerm   : verbatimTerm,
                dictionaryList : dictionaryList,
                dictionaryLevel: dictionaryLevel,
                dictionary     : _StepContext.Dictionary,
                login          : _StepContext.User);
        }

        [Then(@"the dictionary list term has the following coding history comments")]
        public void ThenTheTermHasTheFollowingCodingHistory(Table codingHistoryValues)
        {
            if (ReferenceEquals(codingHistoryValues, null)) throw new ArgumentNullException("codingHistoryValues");

            foreach (var row in codingHistoryValues.Rows)
            {
                _Browser.AssertThatTheDictionaryListTermHasCodingHistoryComment(
                    verbatimTerm        : row["Verbatim"],
                    dictionaryList      : row["Dictionary"],
                    status              : row["Status"],
                    codingHistoryComment: row["Comment"]);
            }
        }
    }
}
