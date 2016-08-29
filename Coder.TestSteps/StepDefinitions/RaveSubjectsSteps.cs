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
        private string _SubjectId;
        public RaveSubjectsSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser = _StepContext.Browser;

            _GlobalSteps = new GlobalSteps(_StepContext);
        }

        [When(@"adding a new subject ""(.*)""(?: for Project environment ""(.*)""\s)?")]
        public void WhenAddingANewSubjectForProject(string subjectInitials, string projectEnvironment)
        {
            if (String.IsNullOrWhiteSpace(subjectInitials)) throw new ArgumentNullException("subjectInitials");

            _SubjectId = subjectInitials.CreateUniqueRaveSubjectId();

            _GlobalSteps.RaveModulesAppSegmentIsLoaded();

            var target = new RaveNavigationTarget();

            if (String.IsNullOrWhiteSpace(projectEnvironment) || projectEnvironment.Equals("PROD", StringComparison.OrdinalIgnoreCase))
            {
                _StepContext.ActiveStudyType = StudyType.Prod;
                target = new RaveNavigationTarget
                {
                    StudyName = _StepContext.GetStudyName(),
                    SiteName = _StepContext.GetSite(),
                    SubjectId = _SubjectId
                };
            }
            else if (projectEnvironment.Equals("UAT",StringComparison.OrdinalIgnoreCase))
            {
                _StepContext.ActiveStudyType = StudyType.UAT;

                target                       = new RaveNavigationTarget
                {
                    StudyName = _StepContext.GetUatStudyName(),
                    SiteName  = _StepContext.GetSite(),
                    SubjectId = _SubjectId
    };
            }
           else if (projectEnvironment.Equals("DEV", StringComparison.OrdinalIgnoreCase))
            {
                _StepContext.ActiveStudyType = StudyType.Dev;

                target                       = new RaveNavigationTarget
                {
                    StudyName = _StepContext.GetDevStudyName(),
                    SiteName  = _StepContext.GetSite(),
                    SubjectId = _SubjectId
                };
            }
            else 
            {
                throw new InvalidOperationException(String.Format("Invalid Project environment = {0}", projectEnvironment));
            }

            _Browser.AddSubjectToRaveStudy(target, subjectInitials, _SubjectId);

            var site = _StepContext.GetFirstSite();

            site.AddSubject(initials: subjectInitials, id: _SubjectId);
        }


        [When(@"adding a set of duplicate subject with initial ""(.*)""(?: for Project environment ""(.*)""\s)?")]
              //@"adding a new subject                           ""(.*)""(?: for Project environment ""(.*)""\s)?"
        public void WhenAddingASetOfDuplicateSubjectWithInitial(string subjectInitials, string projectEnvironment)
        {
            if (String.IsNullOrWhiteSpace(subjectInitials)) throw new ArgumentNullException("subjectInitials");

            var _SubjectId = subjectInitials.CreateUniqueRaveSubjectId();

            _GlobalSteps.RaveModulesAppSegmentIsLoaded();

            var target = new RaveNavigationTarget();

            if (String.IsNullOrWhiteSpace(projectEnvironment) || projectEnvironment.Equals("PROD", StringComparison.OrdinalIgnoreCase))
            {
                _StepContext.ActiveStudyType = StudyType.Prod;
                target = new RaveNavigationTarget
                {
                    StudyName = _StepContext.GetStudyName(),
                    SiteName = _StepContext.GetSite(),
                    SubjectId = _SubjectId
                };
            }
            else if (projectEnvironment.Equals("UAT", StringComparison.OrdinalIgnoreCase))
            {
                _StepContext.ActiveStudyType = StudyType.UAT;

                target = new RaveNavigationTarget
                {
                    StudyName = _StepContext.GetUatStudyName(),
                    SiteName = _StepContext.GetSite(),
                    SubjectId = _SubjectId
                };
            }
            else if (projectEnvironment.Equals("DEV", StringComparison.OrdinalIgnoreCase))
            {
                _StepContext.ActiveStudyType = StudyType.Dev;

                target = new RaveNavigationTarget
                {
                    StudyName = _StepContext.GetDevStudyName(),
                    SiteName = _StepContext.GetSite(),
                    SubjectId = _SubjectId
                };
            }
            else
            {
                throw new InvalidOperationException(String.Format("Invalid Project environment = {0}", projectEnvironment));
            }

            _Browser.AddSubjectToRaveStudy(target, subjectInitials, _SubjectId);
            _Browser.AddSubjectToRaveStudy(target, subjectInitials, _SubjectId);

            var site = _StepContext.GetFirstSite();

            site.AddSubject(initials: subjectInitials, id: _SubjectId);
        }

        [When(@"deactivating a duplicate subject")]
        public void WhenDeactivatingADuplicateSubject()
        {
            _Browser.DeactivateRaveSubject(_StepContext.GetActiveStudy().StudyName,_SubjectId);
            //# go to rave home
            //# go to site administration
            //# search for your study
            //# select your study
            //# go into your study
            //# click on subjects
            //# click on edit associated with your subject
            //# uncheck active
        }
    }
}
