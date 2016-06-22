//@author:smalik
using System;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.Models;
using TechTalk.SpecFlow;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.DeclarativeBrowser.Models.ETEModels;
using System.Linq;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public sealed class CoderSetupSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext _StepContext;

        public CoderSetupSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser     = _StepContext.Browser;
        }

        [Given("a new segment to be enrolled in Coder")]
        public void aNewSegmentToBeEnrolledInCoder()
        {
            _Browser.EnrollSegment(Config.SetupSegment, _StepContext.GetSegment());
        }

        [When(@"a dictionary ""(.*)"" is rolled out")]
        public void aDictionaryIsRolledOut(String dictionaryName)
        {
            if (ReferenceEquals(dictionaryName, null)) throw new ArgumentNullException("dictionaryName");

            _Browser.RolloutDictionary(_StepContext.GetSegment(), dictionaryName);
        }

        [Given(@"a new Coder User")]
        public void GivenANewCoderUser()
        {
            _Browser.LoadiMedidataCoderAppSegment(_StepContext.GetSegment());
        }


        [Given(@"a coder study is created named ""(.*)"" for environment ""(.*)"" with site ""(.*)""")]
        public void GivenACoderStudyIsCreatedNamedForEnvironmentWithSite(string studyName, string environmentName, string siteName)
        {
            var generatedSuffix = Guid.NewGuid().GetFirstSectionAppendedWithRandomNumbers();

            var newStudyGroup = CreateSegmentSetupData(studyName, siteName, true);

            //newStudyGroup.SegmentName = String.Concat(studyName, Config.ETESetupSuffix);
            //newStudyGroup.SegmentUuid = _Browser.GetStudyGroupUUID(newStudyGroup.SegmentName);

            SetSegmentContext(newStudyGroup);

            CreateTestUserContext(generatedSuffix, newStudyGroup, createNewSegment: false);

            _Browser.LogoutOfiMedidata();

            CompleteUserRegistration(_StepContext.CoderTestUser, newStudyGroup);

            //WriteSetupDetails(_StepContext.CoderTestUser, newStudyGroup);
        }

        private SegmentSetupData CreateSegmentSetupData(string studyName, string siteName, bool allProduction)
        {
            const string userAcceptanceStudySuffix = "(UAT)";
            const string developmentStudySuffix = "(Dev)";

            if (String.IsNullOrWhiteSpace(studyName)) throw new ArgumentNullException("studyName");
            if (String.IsNullOrWhiteSpace(siteName)) throw new ArgumentNullException("siteName");

            var studyExternalOid = studyName.RemoveNonAlphanumeric();

            var siteNumber = String.Concat(siteName, "_Site").RemoveNonAlphanumeric();

            bool isProductionValue = false;
            if (allProduction)
            {
                isProductionValue = true;
            }

            var newStudyGroup = new SegmentSetupData
            {
                SegmentName = studyName,
                Studies = new StudySetupData[]
                {
                    new StudySetupData()
                    {
                        StudyName    = studyName,
                        ExternalOid  = studyExternalOid,
                        IsProduction = true,
                        Sites        = new SiteSetupData[]
                        {
                            new SiteSetupData
                            {
                                SiteName   = siteName,
                                SiteNumber = siteNumber
                            }
                        },
                        ProtocolNumber = studyName.Replace("_", "")
                    },
                    new StudySetupData()
                    {
                        StudyName    = String.Concat(studyName, " ",userAcceptanceStudySuffix),
                        ExternalOid  = String.Concat(studyExternalOid, userAcceptanceStudySuffix).RemoveNonAlphanumeric(),
                        IsProduction = isProductionValue,
                        Sites        = new SiteSetupData[]
                        {
                            new SiteSetupData
                            {
                                SiteName   = String.Concat(siteName, " ", userAcceptanceStudySuffix),
                                SiteNumber = String.Concat(siteNumber, userAcceptanceStudySuffix).RemoveNonAlphanumeric()
                            }
                        },
                        ProtocolNumber = studyName.Replace("_", "")
                    },
                    new StudySetupData()
                    {
                        StudyName    = String.Concat(studyName, " ", developmentStudySuffix),
                        ExternalOid  = String.Concat(studyExternalOid, developmentStudySuffix).RemoveNonAlphanumeric(),
                        IsProduction = isProductionValue,
                        Sites        = new SiteSetupData[]
                        {
                            new SiteSetupData
                            {
                                SiteName   = String.Concat(siteName, " ", developmentStudySuffix),
                                SiteNumber = String.Concat(siteNumber, developmentStudySuffix).RemoveNonAlphanumeric()
                            }
                        },
                        ProtocolNumber = studyName.Replace("_", "")
                    }
                }
            };

            return newStudyGroup;
        }

        private void SetSegmentContext(SegmentSetupData newStudyGroup)
        {
            if (ReferenceEquals(newStudyGroup, null)) throw new ArgumentNullException("newStudyGroup");

            _StepContext.SegmentUnderTest2 = newStudyGroup;

            _StepContext.SetStudyGroupSetupData(newStudyGroup);
        }

        private void CreateTestUserContext(string nameSuffix, SegmentSetupData newStudyGroup, bool createNewSegment)
        {
            if (String.IsNullOrWhiteSpace(nameSuffix)) throw new ArgumentNullException("nameSuffix");
            if (ReferenceEquals(newStudyGroup, null)) throw new ArgumentNullException("newStudyGroup");

            var userName = String.Concat(Config.StudyNamePrefix, nameSuffix);

            var newUser = _StepContext.Browser.CreateTestUserContext(newStudyGroup, userName, createNewSegment);

            _StepContext.CoderTestUser2 = newUser;
        }

        private void CompleteUserRegistration(MedidataUser user, SegmentSetupData studyGroup)
        {
            if (ReferenceEquals(user, null)) throw new ArgumentNullException("user");
            if (ReferenceEquals(studyGroup, null)) throw new ArgumentNullException("studyGroup");

            var browser = _StepContext.Browser;

            browser.LoginToiMedidata(user.Username, user.Password);

            browser.AcceptStudyInvitation();

            browser.LoadiMedidataRaveModulesAppSegment(_StepContext.GetSegment());

            var productionStudies = studyGroup.Studies.Select(x => x).Where(x => x.IsProduction);

            foreach (var study in productionStudies)
            {
                browser.AssignUserToStudy("coderimport", "Coder Import Role", study: study.StudyName);
            }

            browser.LogoutOfiMedidata();
        }

    }
}
