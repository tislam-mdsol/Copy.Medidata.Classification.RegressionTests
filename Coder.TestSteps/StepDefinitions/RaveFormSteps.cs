using System;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using System.Reflection;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class RaveFormSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext _StepContext;

        public RaveFormSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser = _StepContext.Browser;
        }

        [When(@"adding a new verbatim term to form ""(.*)""")]
        public void WhenAddingANewVerbatimTermToForm(string formName, Table formInputTable)
        {
            if (String.IsNullOrWhiteSpace(formName))   throw new ArgumentNullException("formName");
            if (ReferenceEquals(formInputTable, null)) throw new NullReferenceException("formInputTable");

            var formInputData = formInputTable.TransformFeatureTableStrings(_StepContext).CreateSet<RaveFormInputData>();

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;
            
            _Browser.CreateFormSubmission(target, formInputData);
        }

        [When(@"modifying a verbatim term on form ""(.*)""")]
        public void WhenModifyingAVerbatimTermOnForm(string formName, Table formInputTable)
        {
            if (String.IsNullOrWhiteSpace(formName))   throw new ArgumentNullException("formName");
            if (ReferenceEquals(formInputTable, null)) throw new NullReferenceException("formInputTable");

            var formInputData = formInputTable.TransformFeatureTableStrings(_StepContext).CreateSet<RaveFormInputData>();

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.UpdateForm(target, formInputData);
        }

        [When(@"modifying a verbatim term of the log line containing ""(.*)"" on form ""(.*)""")]
        public void WhenModifyingAVerbatimTermOfTheLogLineContainingOnForm(string logLineContents, string formName, Table formInputTable)
        {
            if (String.IsNullOrWhiteSpace(logLineContents)) throw new ArgumentNullException("logLineContents");
            if (String.IsNullOrWhiteSpace(formName))        throw new ArgumentNullException("formName");
            if (ReferenceEquals(formInputTable, null))      throw new NullReferenceException("formInputTable");

            var formInputData = formInputTable.TransformFeatureTableStrings(_StepContext).CreateSet<RaveFormInputData>();

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.UpdateLogLine(target, logLineContents, formInputData);
        }

        [When(@"modifying a verbatim term of log line ""(.*)"" on form ""(.*)""")]
        public void WhenModifyingAVerbatimTermOfLogLineOnForm(int logLineIndex, string formName, Table formInputTable)
        {
            if (logLineIndex < 1)                      throw new ArgumentOutOfRangeException("logLineIndex cannot be less than 1");
            if (String.IsNullOrWhiteSpace(formName))   throw new ArgumentNullException("formName");
            if (ReferenceEquals(formInputTable, null)) throw new NullReferenceException("formInputTable");

            var formInputData = formInputTable.TransformFeatureTableStrings(_StepContext).CreateSet<RaveFormInputData>();

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.UpdateLogLine(target, logLineIndex, formInputData);
        }
        
        [When(@"form ""(.*)"" is frozen")]
        public void WhenFormIsFrozen(string formName)
        {
            if (String.IsNullOrWhiteSpace(formName)) throw new ArgumentNullException("formName");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.LockRaveForm(target, freezeForm: true, lockForm: false);
        }

        [When(@"form ""(.*)"" is locked")]
        public void WhenFormIsLocked(string formName)
        {
            if (String.IsNullOrWhiteSpace(formName))   throw new ArgumentNullException("formName");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.LockRaveForm(target, freezeForm: false, lockForm: true);
        }

        [When(@"form ""(.*)"" is frozen and locked")]
        public void WhenFormIsFrozenAndLocked(string formName)
        {
            if (String.IsNullOrWhiteSpace(formName))   throw new ArgumentNullException("formName");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.LockRaveForm(target, freezeForm: true, lockForm: true);
        }

        [When(@"the Rave row on form ""(.*)"" with verbatim term ""(.*)"" is frozen")]
        public void WhenTheRaveRowOnFormWithVerbatimTermIsFrozen(string formName, string verbatimTerm)
        {
            if (String.IsNullOrWhiteSpace(formName))     throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.LockRaveFormRow(target, verbatimTerm, freezeForm: true, lockForm: false);
        }

        [When(@"the Rave row on form ""(.*)"" with verbatim term ""(.*)"" is locked")]
        public void WhenTheRaveRowOnFormWithVerbatimTermIsLocked(string formName, string verbatimTerm)
        {
            if (String.IsNullOrWhiteSpace(formName))     throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.LockRaveFormRow(target, verbatimTerm, freezeForm: false, lockForm: true);
        }

        [When(@"the Rave row on form ""(.*)"" with verbatim term ""(.*)"" is frozen and locked")]
        public void WhenTheRaveRowOnFormWithVerbatimTermIsFrozenAndLocked(string formName, string verbatimTerm)
        {
            if (String.IsNullOrWhiteSpace(formName))     throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.LockRaveFormRow(target, verbatimTerm, freezeForm: true, lockForm: true);
        }

        [Then(@"the coder query ""(.*)"" is available to the Rave form ""(.*)"" field ""(.*)"" with verbatim term ""(.*)""")]
        public void ThenTheCoderQueryIsAvailableToTheRaveFormFieldWithVerbatimTerm(string queryComment, string formName, string fieldName, string verbatimTerm)
        {
            if (String.IsNullOrWhiteSpace(queryComment)) throw new ArgumentNullException("queryComment");
            if (String.IsNullOrWhiteSpace(formName))     throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(fieldName))    throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            // Verify the audit first. This will retry if the Coder query transmission has not been received by Rave yet.
            string auditQueryComment = _Browser.GetQueryCommentFromRaveAuditRecords(target, fieldName, verbatimTerm);

            auditQueryComment.Should().BeEquivalentTo(queryComment);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

            string formQueryComment = _Browser.GetRaveFormQueryComment(target, fieldName, verbatimTerm);

            formQueryComment.Should().BeEquivalentTo(queryComment);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"the coder query to the Rave form ""(.*)"" field ""(.*)"" with verbatim term ""(.*)"" can not be responded to")]
        public void ThenTheCoderQueryToTheRaveFormFieldWithVerbatimTermCanNotBeRespondedTo(string formName, string fieldName, string verbatimTerm)
        {
            if (String.IsNullOrWhiteSpace(formName))     throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(fieldName))    throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            var target = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.IsQueryResponsePossibleInRave(target, fieldName, verbatimTerm).Should().BeFalse();
            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [When(@"the coder query to the Rave form ""(.*)"" field ""(.*)"" with verbatim term ""(.*)"" is responded to with ""(.*)""")]
        [Then(@"the coder query to the Rave form ""(.*)"" field ""(.*)"" with verbatim term ""(.*)"" is responded to with ""(.*)""")]
        public void WhenTheCoderQueryToTheRaveFormFieldWithVerbatimTermIsRespondedToWith(string formName, string fieldName, string verbatimTerm, string queryResponse)
        {
            if (String.IsNullOrWhiteSpace(formName))      throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(fieldName))     throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(verbatimTerm))  throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrWhiteSpace(queryResponse)) throw new ArgumentNullException("queryResponse");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.RespondToQueryCommentInRave(target, fieldName, verbatimTerm, queryResponse);
            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }


        [When(@"the coder query to the Rave form ""(.*)"" field ""(.*)"" with verbatim term ""(.*)"" is canceled")]
        public void WhenTheCoderQueryToTheRaveFormFieldWithVerbatimTermIsCanceled(string formName, string fieldName, string verbatimTerm)
        {
            if (String.IsNullOrWhiteSpace(formName))      throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(fieldName))     throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(verbatimTerm))  throw new ArgumentNullException("verbatimTerm");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.CancelQueryCommentInRave(target, fieldName, verbatimTerm);
        }

        [When(@"the coder query to the Rave form ""(.*)"" field ""(.*)"" with verbatim term ""(.*)"" is canceled with response ""(.*)""")]
        public void WhenTheCoderQueryIsAvailableToTheRaveFormFieldWithVerbatimTermIsCanceledWithResponse(string formName, string fieldName, string verbatimTerm, string queryResponse)
        {
            if (String.IsNullOrWhiteSpace(formName))      throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(fieldName))     throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(verbatimTerm))  throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrWhiteSpace(queryResponse)) throw new ArgumentNullException("queryResponse");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.CancelQueryCommentInRave(target, fieldName, verbatimTerm, queryResponse);
        }

        [When(@"the log line on form ""(.*)"" containing ""(.*)"" is inactivated")]
        public void WhenTheLogLineOnFormContainingIsInactivated(string formName, string rowContents)
        {
            if (String.IsNullOrWhiteSpace(formName))    throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.InactivateRaveFormLogLine(target, rowContents);
        }

        [When(@"the log line on form ""(.*)"" containing ""(.*)"" is reactivated")]
        public void WhenTheLogLineOnFormContainingIsReactivated(string formName, string rowContents)
        {
            if (String.IsNullOrWhiteSpace(formName))    throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.ReactivateRaveFormLogLine(target, rowContents);
        }

        [When(@"form ""(.*)"" is inactivated")]
        public void WhenFormIsInactivated(string formName)
        {
            if (String.IsNullOrWhiteSpace(formName)) throw new ArgumentNullException("formName");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.InactivateRaveForm(target);
        }

        [When(@"form ""(.*)"" is reactivated")]
        public void WhenFormIsReactivated(string formName)
        {
            if (String.IsNullOrWhiteSpace(formName)) throw new ArgumentNullException("formName");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.ReactivateRaveForm(target);
        }

        [When(@"row on form ""(.*)"" containing ""(.*)"" is marked with a query")]
        public void WhenRowOnFormContainingIsMarkedWithAQuery(string formName, string rowContents)
        {
            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.MarkRaveFormRowWithQuery(target, rowContents);
        }

        [When(@"row on form ""(.*)"" containing ""(.*)"" is marked with a sticky")]
        public void WhenRowOnFormContainingIsMarkedWithASticky(string formName, string rowContents)
        {
            if (String.IsNullOrWhiteSpace(formName))    throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.MarkRaveFormRowWithSticky(target, rowContents);
        }

        [When(@"row on form ""(.*)"" containing ""(.*)"" is marked with a protocol deviation")]
        public void WhenRowOnFormContainingIsMarkedWithAProtocolDeviation(string formName, string rowContents)
        {
            if (String.IsNullOrWhiteSpace(formName))    throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.MarkRaveFormRowWithProtocolDeviation(target, rowContents);
        }

        [When(@"an audit log entry ""(.*)"" is manually added to field ""(.*)"" of the form ""(.*)"" row containing ""(.*)""")]
        public void WhenAnAuditLogEntryIsManuallyAddedToFieldOfTheFormRowContaining(string auditLogEntry, string fieldName, string formName, string rowContents)
        {
            if (String.IsNullOrWhiteSpace(auditLogEntry)) throw new ArgumentNullException("auditLogEntry");
            if (String.IsNullOrWhiteSpace(fieldName))     throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(formName))      throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(rowContents))   throw new ArgumentNullException("rowContents");

            var target      = _StepContext.GetRaveNavigationTarget();
            target.FormName = formName;

            _Browser.AddAuditLogEntryToRaveFormRow(target, rowContents, fieldName, auditLogEntry);
        }

        [Then(@"the coding decision for verbatim ""(.*)"" on form ""(.*)"" for field ""(.*)"" contains the following data")]
        public void ThenTheCodingDecisionForFormForFieldWithTextContainsTheFollowingData(string verbatimTerm, string formName, string fieldName, Table verifyCodingTaskTable)
        {
            if (String.IsNullOrWhiteSpace(verbatimTerm))      throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrWhiteSpace(formName))          throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(fieldName))         throw new ArgumentNullException("fieldName");
            if (ReferenceEquals(verifyCodingTaskTable, null)) throw new NullReferenceException("verifyCodingTaskTable");

            ThenTheCodingDecisionForVerbatimContainsTheFollowingData(formName, fieldName, verbatimTerm, verbatimTerm, verifyCodingTaskTable);
        }

        [Then(@"the coding decision for verbatim ""(.*)"" on form ""(.*)"" for field ""(.*)"" should not display")]
        public void ThenTheCodingDecisionForVerbatimOnFormForFieldShouldNotDisplay(string verbatimTerm, string formName, string fieldName, Table verifyCodingTaskTable)
        {
            if (String.IsNullOrWhiteSpace(verbatimTerm))      throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrWhiteSpace(formName))          throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(fieldName))         throw new ArgumentNullException("fieldName");
            if (ReferenceEquals(verifyCodingTaskTable, null)) throw new NullReferenceException("verifyCodingTaskTable");

            var expectedCodingDecisions = verifyCodingTaskTable.TransformFeatureTableStrings(_StepContext).CreateInstance<TermPathRow>();

            var target                  = _StepContext.GetRaveNavigationTarget();

            target.FormName             = formName;

            var codingDecisionVerbatim   = _Browser.GetCodingDecisionVerbatim(target, fieldName, verbatimTerm);

            expectedCodingDecisions.ShouldNotBeEquivalentTo(codingDecisionVerbatim);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"the coding decision on form ""(.*)"" for field ""(.*)"" with row text ""(.*)"" for verbatim ""(.*)"" contains the following data")]
        public void ThenTheCodingDecisionForVerbatimContainsTheFollowingData(string formName, string fieldName, string rowContents, string verbatimTerm, Table verifyCodingTaskTable)
        {
            if (String.IsNullOrWhiteSpace(formName))          throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(fieldName))         throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(rowContents))       throw new ArgumentNullException("rowContents");
            if (String.IsNullOrWhiteSpace(verbatimTerm))      throw new ArgumentNullException("verbatimTerm");
            if (ReferenceEquals(verifyCodingTaskTable, null)) throw new NullReferenceException("verifyCodingTaskTable");

            var expectedCodingDecisions = verifyCodingTaskTable.TransformFeatureTableStrings(_StepContext).CreateSet<TermPathRow>().ToList();
            var target = _StepContext.GetRaveNavigationTarget();

            target.FormName = formName;

            var auditCodingDecisions = _Browser.GetCodingDecisionFromRaveAuditRecords(target, fieldName, rowContents).ToList();

            if (auditCodingDecisions.Count == expectedCodingDecisions.Count)
            {
                for (int auditCodingDecisionIndex = 0; auditCodingDecisionIndex < auditCodingDecisions.Count; auditCodingDecisionIndex++)
                {
                    var auditCodingDecision    = auditCodingDecisions[auditCodingDecisionIndex];
                    var expectedCodingDecision = expectedCodingDecisions[auditCodingDecisionIndex];

                    auditCodingDecision.EqualsIgnoreCode(expectedCodingDecision).Should().BeTrue();
                }
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

            var codingDecisions = _Browser.GetCodingDecisionFromRaveForm(target, rowContents, verbatimTerm).ToList();

            expectedCodingDecisions.Should().BeEquivalentTo(codingDecisions);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"verify coding dictionary ""(.*)"" is an option on Rave form ""(.*)""")]
        public void ThenVerifyCodingDictionaryIsAnOptionOnRaveForm(string dictionaryName, string formName)
        {
            if (String.IsNullOrWhiteSpace(dictionaryName)) throw new ArgumentNullException(dictionaryName);
            if (String.IsNullOrWhiteSpace(formName))       throw new ArgumentNullException(formName);

            var target                      = _StepContext.GetRaveArchitectRecordTarget();
            var availableCodingDictionaries =_Browser.GetAvailableCodingDictionariesFromArchitect(target, formName);

            availableCodingDictionaries.Should().Contain(String.Format("{0}- {1}", Config.RaveDictionaryCoderPrefix, dictionaryName));

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"Rave form ""(.*)"" should display")]
        public void ThenRaveFormShouldDisplay(string p0, Table table)
        {
            ScenarioContext.Current.Pending();
        }

    }
}
