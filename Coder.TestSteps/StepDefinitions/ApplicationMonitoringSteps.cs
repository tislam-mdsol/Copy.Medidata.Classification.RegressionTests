using System;
using System.Linq;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using TechTalk.SpecFlow;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.Models.GridModels;
using System.Reflection;
using FluentAssertions;
using Coder.TestSteps.Transformations;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class ApplicationMonitoringSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext             _StepContext;

        private readonly GlobalSteps             _GlobalSteps;

        private int _AdverseEventOccurrences;

        public ApplicationMonitoringSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext      = stepContext;
            _Browser          = _StepContext.Browser;
            
            _GlobalSteps      = new GlobalSteps(_StepContext);

            _AdverseEventOccurrences = 0;
        }

        [Given(@"Rave Modules App Segment ""(.*)"" is loaded")]
        [When(@"Rave Modules App Segment ""(.*)"" is loaded")]
        public void RaveModulesAppSegmentIsLoaded(String segmentFeature)
        {
            if (String.IsNullOrWhiteSpace(segmentFeature)) throw new ArgumentNullException("segmentFeature");

            var segment = StepArgumentTransformations.TransformFeatureString(segmentFeature, _StepContext);

            _Browser.LoadiMedidataRaveModulesAppSegment(segment);
        }

        [Given(@"Coder App Segment ""(.*)"" is loaded")]
        [When(@"Coder App Segment ""(.*)"" is loaded")]
        public void CoderAppSegmentIsLoaded(string segmentFeature)
        {
            if (String.IsNullOrWhiteSpace(segmentFeature)) throw new ArgumentNullException("segmentFeature");

            var segment = StepArgumentTransformations.TransformFeatureString(segmentFeature, _StepContext);

            _Browser.LoadiMedidataCoderAppSegment(segment);
        }

        [Given(@"a unique adverse event ""(.*)""")]
        public void CreateUniqueAdverseEventText(string adverseEventText)
        {
            if (String.IsNullOrWhiteSpace(adverseEventText)) throw new ArgumentNullException("adverseEventText");
            
            _StepContext.AdverseEventText = adverseEventText.CreateUniqueRaveAdverseEventText();
        }

        [Given(@"the Rave settings used for task ""(.*)""")]
        public void GivenTheRaveSettingsUsedForTask(string taskFeature)
        {
            if (String.IsNullOrWhiteSpace(taskFeature)) throw new ArgumentNullException("taskFeature");

            var task = StepArgumentTransformations.TransformFeatureString(taskFeature, _StepContext);

            _StepContext.SetDictionaryAndSynonymContext(task);
            _StepContext.SetWorkflowVariablesContext(task);
        }
        
        [When(@"adding a new subject ""(.*)"" to study ""(.*)""")]
        public void WhenAddingANewSubjectToStudy(string subjectInitials, string studyFeature)
        {
            if (String.IsNullOrWhiteSpace(subjectInitials))        throw new ArgumentNullException("subjectInitials");
            if (String.IsNullOrWhiteSpace(studyFeature))           throw new ArgumentNullException("studyFeature");
            
            var study           = StepArgumentTransformations.TransformFeatureString(studyFeature          , _StepContext);

            RaveModulesAppSegmentIsLoaded(_StepContext.Segment);

            _StepContext.SubjectId = _Browser.AddSubjectToRaveStudy(study, subjectInitials);
        }

        [When(@"adding a new adverse event ""(.*)"" to subject ""(.*)"" of study ""(.*)""")]
        public void WhenAddingANewAdverseEventToSubjectOfStudy(string adverseEventTextFeature, string subjectIdFeature, string studyFeature)
        {
            if (String.IsNullOrWhiteSpace(adverseEventTextFeature)) throw new ArgumentNullException("adverseEventText");
            if (String.IsNullOrWhiteSpace(subjectIdFeature))        throw new ArgumentNullException("subjectId");
            if (String.IsNullOrWhiteSpace(studyFeature))            throw new ArgumentNullException("study");
            
            var adverseEventText = StepArgumentTransformations.TransformFeatureString(adverseEventTextFeature, _StepContext);
            var subjectId        = StepArgumentTransformations.TransformFeatureString(subjectIdFeature       , _StepContext);
            var study            = StepArgumentTransformations.TransformFeatureString(studyFeature           , _StepContext);

            RaveModulesAppSegmentIsLoaded(_StepContext.Segment);

            _Browser.AddAdverseEvent(study, subjectId, adverseEventText);
        }

        [When(@"adding a new adverse event ""(.*)"" to subject ""(.*)"" of study ""(.*)"" and the coding decision approved")]
        public void WhenAddingANewAdverseEventToSubjectOfStudyAndTheCodingDecisionApproved(string adverseEventTextFeature, string subjectIdFeature, string studyFeature)
        {
            if (String.IsNullOrWhiteSpace(adverseEventTextFeature)) throw new ArgumentNullException("adverseEventText");
            if (String.IsNullOrWhiteSpace(subjectIdFeature))        throw new ArgumentNullException("subjectId");
            if (String.IsNullOrWhiteSpace(studyFeature))            throw new ArgumentNullException("study");

            var adverseEventText = StepArgumentTransformations.TransformFeatureString(adverseEventTextFeature, _StepContext);
            var subjectId        = StepArgumentTransformations.TransformFeatureString(subjectIdFeature       , _StepContext);
            var study            = StepArgumentTransformations.TransformFeatureString(studyFeature           , _StepContext);

            WhenAddingANewAdverseEventToSubjectOfStudy(adverseEventText, subjectId, study);
            
            if (adverseEventText.Equals(_StepContext.AdverseEventText))
            {
                _AdverseEventOccurrences++;
            }
            else
            {
                _AdverseEventOccurrences = 1;
            }

            if (_StepContext.IsAutoApproval.EqualsIgnoreCase("false") &&
                _StepContext.IsApprovalRequired.EqualsIgnoreCase("true"))
            {
                ThenTheAuditLogForOccurrenceOfTheAdverseEventIsUpdatedWhenTheTermIsSentToCoder(_AdverseEventOccurrences, adverseEventText);

                CoderAppSegmentIsLoaded(_StepContext.Segment);

                _GlobalSteps.WhenApprovingTaskIfRequired(adverseEventText);
            }
        }

        [Then(@"the coding decision for the task ""(.*)"" is approved for term ""(.*)""")]
        public void ThenTheCodingDecisionForTheTaskIsApprovedForTerm(string taskFeature, string term)
        {
            if (String.IsNullOrWhiteSpace(taskFeature)) throw new ArgumentNullException("taskFeature");
            if (String.IsNullOrWhiteSpace(term))        throw new ArgumentNullException("term");

            var task = StepArgumentTransformations.TransformFeatureString(taskFeature, _StepContext);

            ReclassificationSearchCriteria reclassificationSearchCriteria = new ReclassificationSearchCriteria
            {
                DictionaryType        = String.Format("{0} ({1})", _StepContext.Dictionary, _StepContext.Locale),
                Version               = _StepContext.Version,
                IncludeAutoCodedItems = true,
                Verbatim              = task
            };

            _Browser.PerformReclassificationSearch(reclassificationSearchCriteria);

            ReclassificationSearch reclassificationSearchResult = new ReclassificationSearch
            {
                Study    = _StepContext.SourceSystemStudyName,
                Subject  = _StepContext.SubjectId,
                Verbatim = task,
                Term     = term
            };

            var reclassificationSearchResults = new[] { reclassificationSearchResult }.ToList();

            _Browser.AssertReclassificationSearchResults(reclassificationSearchResults);
        }

        [Then(@"the audit log for occurrence ""(.*)"" of the adverse event ""(.*)"" is updated when the term is sent to coder")]
        public void ThenTheAuditLogForOccurrenceOfTheAdverseEventIsUpdatedWhenTheTermIsSentToCoder(int adverseEventOccurrence, string adverseEventTextFeature)
        {
            if (adverseEventOccurrence <= 0)                        throw new ArgumentException("adverseEventOccurrence must be greater than 0.");
            if (String.IsNullOrWhiteSpace(adverseEventTextFeature)) throw new ArgumentNullException("adverseEventTextFeature");

            var adverseEventText = StepArgumentTransformations.TransformFeatureString(adverseEventTextFeature, _StepContext);

            RaveModulesAppSegmentIsLoaded(_StepContext.Segment);

            _Browser.WaitUntilAdverseEventTransmitted(
                _StepContext.SourceSystemStudyName,
                _StepContext.SubjectId,
                adverseEventText,
               adverseEventOccurrence);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
        
        [Then(@"the audit log for occurrence ""(.*)"" of the adverse event ""(.*)"" is updated with the term path ""(.*)""")]
        public void ThenTheAuditLogForOccurrenceOfTheAdverseEventIsUpdatedWithTheTermPath(int adverseEventOccurrence, string adverseEventTextFeature, string termPath)
        {
            if (adverseEventOccurrence <= 0)                        throw new ArgumentException("adverseEventOccurrence must be greater than 0.");
            if (String.IsNullOrWhiteSpace(adverseEventTextFeature)) throw new ArgumentNullException("adverseEventTextFeature");
            if (String.IsNullOrWhiteSpace(termPath))                throw new ArgumentNullException("termPath");
            
            var adverseEventText = StepArgumentTransformations.TransformFeatureString(adverseEventTextFeature, _StepContext);

            RaveModulesAppSegmentIsLoaded(_StepContext.Segment);

            string codedPath = _Browser.GetAdverseEventCodedPathFromRaveAuditRecords(
                _StepContext.SourceSystemStudyName,
                _StepContext.SubjectId,
                adverseEventText,
                adverseEventOccurrence);

            codedPath.Should().ContainEquivalentOf(termPath);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
    }
}
