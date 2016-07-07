﻿//@author:smalik
using System;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.Models;
using TechTalk.SpecFlow;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coder.DeclarativeBrowser.IMedidataApi;
using System.Linq;
using System.Collections.Generic;

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
            if (ReferenceEquals(studyName, null)) throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(environmentName, null)) throw new ArgumentNullException("segmentSetupData");
            if (String.IsNullOrWhiteSpace(siteName)) throw new ArgumentNullException("segmentSetupData.SegmentName");

            _StepContext.SecondStudyName = studyName;

            var studyExternalOid = studyName.RemoveNonAlphanumeric();

            var siteNumber = String.Concat(siteName, "_Site").RemoveNonAlphanumeric();

            var singleStudyToAddToSegmentUnderTest = new SegmentSetupData
            {
                SegmentName = _StepContext.SegmentUnderTest.SegmentName, //newStudyName
                SegmentUuid = _StepContext.SegmentUnderTest.SegmentUuid,
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
                    }
                },
                StudyGroupApps = _Browser.GetStudyGroupAppsList()
            };

            Dictionary<string, string> appsAndRoles = new Dictionary<string, string>() ;
            appsAndRoles.Add("Coder EU Sandbox", "None");
            appsAndRoles.Add("Rave EDC", "Power User");
            appsAndRoles.Add("Rave Modules", "All Modules");
            appsAndRoles.Add("Rave Architect Roles", "Project Admin Default");

            _Browser.CreateNewStudyWithSite(singleStudyToAddToSegmentUnderTest);

            _Browser.LogoutOfiMedidata();
            _Browser.LoginToiMedidata(Config.AdminLogin, Config.AdminPassword);

            _Browser.UpdateUserAppPermissionForStudyGroup(_StepContext.SegmentUnderTest, appsAndRoles, _StepContext.CoderTestUser); 

        }       
    }
}
