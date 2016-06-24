//@author:smalik
using System;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.Models;
using TechTalk.SpecFlow;
using System.IO;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using TechTalk.SpecFlow.Assist;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.Helpers;
using NUnit.Framework;
using System.Reflection;
using System.Data;


namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class RaveModulesIntegrationSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext _StepContext;
        private readonly GlobalSteps _GlobalSteps;

        public RaveModulesIntegrationSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext     =  stepContext;
            _Browser         =  _StepContext.Browser;

            _GlobalSteps = new GlobalSteps(_StepContext);
        }

        [Given(@"a Rave Coder environment configured with template ""(.*)""")]
        public void GivenARaveCoderEnvironmentConfiguredWithTemplate(string csvFileName)
        {
            if (ReferenceEquals(csvFileName, null)) throw new ArgumentNullException("csvFileName");

            var raveAdminUser = _StepContext.RaveAdminUser;

            _Browser.GetAccessToConfigModule(raveAdminUser.Username);

            var csvFilePath = Path.Combine(Config.StaticContentFolder, csvFileName);

            bool uploadSuccessful = _Browser.UploadConfigurationFileInRaveModules(csvFilePath);

            uploadSuccessful.Should().BeTrue();
        }


        [Given("a configuration file to be uploaded in Rave Modules")]
        public void GivenAConfigurationFileToBeUploadedInRaveModules()
        {
            var raveAdminUser = _StepContext.RaveAdminUser;
            
            _Browser.GetAccessToConfigModule(raveAdminUser.Username);    
        }

        [Given(@"a new user ""(.*)"" that needs to be assigned a role ""(.*)""")]
        public void GivenANewUserThatNeedsToBeAssignedARole(String userName, String roleName)
        {
            if (ReferenceEquals(userName, null)) throw new ArgumentNullException("userName");

            var studyGroup          = _StepContext.SegmentUnderTest;
            var productionStudyName = studyGroup.Studies.FirstOrDefault(x => x.IsProduction).StudyName;
            var environmentPrefix   = "Live: ";
            var studies             = studyGroup.Studies;

            foreach (var study in studies)
            {
                environmentPrefix = "Aux: ";

                if (study.IsProduction)
                {
                    productionStudyName = study.StudyName;
                    environmentPrefix   = "Live: ";
                }

                var projectEnvironment = String.Concat(environmentPrefix, study.StudyType.ToString());

                _Browser.AssignUserToStudy(userName, roleName, study: productionStudyName, projectEnvironment: projectEnvironment);
            }

        }

        [When(@"the configuration file ""(.*)"" is uploaded in Rave Modules")]
        public void WhenTheConfigurationFileIsUploadedInRaveModules(String csvFileName)
        {
            if (ReferenceEquals(csvFileName, null)) throw new ArgumentNullException("csvFileName");

            var csvFilePath = Path.Combine(Config.StaticContentFolder, csvFileName);

            _Browser.UploadConfigurationFileInRaveModules(csvFilePath);    
        }

        [Then(@"a verification message ""(.*)"" is displayed")]
        public void ThenTheResultShouldBe(String result)
        {
            if (ReferenceEquals(result, null)) throw new ArgumentNullException("result");

            _Browser.VerifyConfigUploadResult(result);           
        }

        //SMTODO::  Delete this method once automatic coding decisions start working in UI.Hard coded subject initials and number in here. 
        //Created and deleted OpenRaveSubject() method and RaveSubjectPage Object since we would not use existing subjects in ETE test. Always create new subjects.
        [Given(@"an existing subject ""(.*)""")]
        public void GivenAnExistingSubject(string subjectID)
        {
            if (String.IsNullOrWhiteSpace(subjectID)) throw new ArgumentNullException("subjectInitials");

            _GlobalSteps.RaveModulesAppSegmentIsLoaded();

            var site = _StepContext.GetFirstSite();

            site.AddSubject(initials: "ztst", number: "06232014_001", id: subjectID);

        }

        [Given(@"global Rave-Coder Configuration settings with Review Marking Group set to ""(.*)"" and Requires Response set to ""(.*)""")] 
        [When(@"global Rave-Coder Configuration settings with Review Marking Group are set to ""(.*)"" and Requires Response are set to ""(.*)""")]
        public void SetRaveCoderGlobalConfigurationForReviewMarkingGroupAndRequiresResponse(string reviewMarkingGroupValue, bool requiresResponseValue)
        {
            if (String.IsNullOrWhiteSpace(reviewMarkingGroupValue)) throw new ArgumentNullException("reviewMarkingGroupValue");
            if (ReferenceEquals(requiresResponseValue,null))        throw new ArgumentNullException("requiresResponseValue");

            var configurationSetting = new RaveCoderGlobalConfiguration
            {
                ReviewMarkingGroup = reviewMarkingGroupValue,
                IsRequiresResponse = requiresResponseValue
            };
            _Browser.EditGlobalRaveConfiguration(configurationSetting);

        }

        [Given(@"setting the clinical view settings for dictionary ""(.*)"" with the following data")]
        public void GivenSettingTheClinicalViewSettingsForDictionaryWithTheFollowingData(string dictionary, Table codingSettingsTable)
        {
            if (String.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");
            if (ReferenceEquals(codingSettingsTable, null)) throw new NullReferenceException("codingSettingsTable");

            var dictionaryName = StepArgumentTransformations.TransformFeatureString(dictionary, _StepContext);

            var clinicalViewSetting = codingSettingsTable.TransformFeatureTableStrings(_StepContext).CreateSet<RaveCodingSettingsModel>();

            _Browser.CreateCodingSettingsSubmission(dictionaryName, clinicalViewSetting);

        }

        [Given(@"configure Clinical Views for Project ""(.*)"" with mode ""(.*)""")]
        public void GivenConfigureClinicalViewsForProjectWithMode(string project, string mode)
        {
            if (String.IsNullOrWhiteSpace(project)) throw new ArgumentNullException("project");
            if (String.IsNullOrWhiteSpace(mode)) throw new ArgumentNullException("mode");

            var projectName = StepArgumentTransformations.TransformFeatureString(project, _StepContext);

            _Browser.SetClinicalViewsModeForProject(projectName, mode);

        }

        [Given(@"generate report ""(.*)"" for Project ""(.*)"", Data Source ""(.*)"" and Form ""(.*)""")]
        public void GivenGenerateReportForProjectDataSourceAndForm(string reportType, string projectName, string dataSourceName, string formName)
        {
            if (String.IsNullOrWhiteSpace(projectName)) throw new ArgumentNullException("projectName");
            if (String.IsNullOrWhiteSpace(reportType)) throw new ArgumentNullException("reportType");
            if (String.IsNullOrWhiteSpace(dataSourceName)) throw new ArgumentNullException("dataSourceName");
            if (String.IsNullOrWhiteSpace(formName)) throw new ArgumentNullException("formName");

            var project = StepArgumentTransformations.TransformFeatureString(projectName, _StepContext);
            var dataSource = StepArgumentTransformations.TransformFeatureString(dataSourceName, _StepContext);
            var form = StepArgumentTransformations.TransformFeatureString(formName, _StepContext);

            _Browser.GenerateReportForProject(project, dataSource, form, reportType);

        }

        [Then(@"In report generated, I should see the data below")]
        public void ThenInReportGeneratedIShouldSeeTheDataBelow(Table codingOnReportTable)
        {
            if (ReferenceEquals(codingOnReportTable, null)) throw new NullReferenceException("codingOnReportTable");

            var expectedCodingOnReportTable = codingOnReportTable.TransformFeatureTableStrings(_StepContext);
            var actualCodingOnReportTable = _Browser.GetCodingDecisionFromDataListingReport();

            foreach (var row in expectedCodingOnReportTable.Rows)
            {
                var actualCodingOnReportTableRows = actualCodingOnReportTable.AsEnumerable();

                foreach (var col in expectedCodingOnReportTable.Header)
                {
                    actualCodingOnReportTableRows = actualCodingOnReportTableRows.Select(x => x).Where(x => x[col].ToString().EqualsIgnoreCase(row[col].ToString()));

                }
                actualCodingOnReportTableRows.Count().Should().Be(1);
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
    }
}
