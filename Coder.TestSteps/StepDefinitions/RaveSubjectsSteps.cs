using System;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.ETEModels;
using TechTalk.SpecFlow;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class RaveSubjectsSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext _StepContext;

        private readonly GlobalSteps _GlobalSteps;

        public RaveSubjectsSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser = _StepContext.Browser;

            _GlobalSteps = new GlobalSteps(_StepContext);
        }

        [When(@"adding a new subject ""(.*)""")]
        public void WhenAddingANewSubject(string subjectInitials)
        {
            if (String.IsNullOrWhiteSpace(subjectInitials)) throw new ArgumentNullException("subjectInitials");
            
            var subjectId = subjectInitials.CreateUniqueRaveSubjectId();

            _GlobalSteps.RaveModulesAppSegmentIsLoaded();

            var target = new RaveNavigationTarget
            {
                StudyName = _StepContext.GetStudyName(),
                SiteName  = _StepContext.GetSite()
            };

            _Browser.AddSubjectToRaveStudy(target, subjectInitials, subjectId);

            var site = _StepContext.GetFirstSite();

            site.AddSubject(initials: subjectInitials, id: subjectId);
        }
        
        [When(@"adding a new manual ID subject ""(.*)""")]
        public void WhenAddingANewSubjectWithManualId(string subjectInitials)
        {
            if (String.IsNullOrWhiteSpace(subjectInitials)) throw new ArgumentNullException("subjectInitials");

            _GlobalSteps.RaveModulesAppSegmentIsLoaded();

            var target = new RaveNavigationTarget
            {
                StudyName = _StepContext.GetStudyName(),
                SiteName  = _StepContext.GetSite()
            };

            var subjectId = _Browser.AddSubjectToRaveStudyWithManualId(target, subjectInitials);
            
            var site = _StepContext.GetFirstSite();

            site.AddSubject(initials: subjectInitials, id: subjectId);
        }
    }
}
