using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.Models;
using Coder.TestSteps.Transformations;
using System;
using System.IO;
using System.Linq;
using Coder.DeclarativeBrowser.Helpers;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using Coder.DeclarativeBrowser.Models.ETEModels;
using FluentAssertions;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class RaveArchitectSteps
    {

        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext _StepContext;

        public RaveArchitectSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser     = _StepContext.Browser;
        }


        [When(@"adding a rave architect draft ""(.*)"" to study ""(.*)""")]
        public void WhenAddingARaveArchitectDraftToStudy(string draftName, string studyFeature)
        {
            if (String.IsNullOrWhiteSpace(draftName))       throw new ArgumentNullException("draftName");
            if (String.IsNullOrWhiteSpace(studyFeature))    throw new ArgumentNullException("studyFeature");

            var study = StepArgumentTransformations.TransformFeatureString(studyFeature, _StepContext);

            _Browser.LoadiMedidataRaveModulesAppSegment(_StepContext.GetSegment());

            _Browser.AddRaveArchitectDraft(study, draftName);
        }
        
        [When(@"deleting a rave architect draft ""(.*)"" from study ""(.*)""")]
        public void WhenDeletingARaveArchitectDraftFromStudy(string draftName, string studyFeature)
        {
            if (String.IsNullOrWhiteSpace(draftName))     throw new ArgumentNullException("draftName");
            if (String.IsNullOrWhiteSpace(studyFeature))  throw new ArgumentNullException("studyFeature");

            var study = StepArgumentTransformations.TransformFeatureString(studyFeature, _StepContext);

            _Browser.LoadiMedidataRaveModulesAppSegment(_StepContext.GetSegment());

            _Browser.DeleteRaveArchitectDraft(study, draftName);
        }
        
        [When(@"uploading a rave architect draft error template")]
        public void WhenUploadingARaveArchitectDraftTemplate()
        {     
            var draftTemplateFilePath = Path.Combine(Config.StaticContentFolder, "ErrorGeneratingCRFDraft.xls");
            
            _Browser.UploadRaveArchitectErrorDraft(draftTemplateFilePath);
        }

        [Then(@"CRF was published and pushed with the following message ""(.*)""")]
        public void ThenCRFWasPublishedAndPushedWithTheFollowingExpectedMessage(string expectedPushMessage)
        {
            if (String.IsNullOrWhiteSpace(expectedPushMessage)) throw new ArgumentNullException("expectedPushMessage");

            var actualPushMessage = _Browser.GetCRFPushExpectedSuccessMessage();
            
            actualPushMessage.Should().Contain(expectedPushMessage);
        }

        [Given(@"a Rave Coder setup with the following options")]
        [When(@"a Rave Coder setup is configured with the following options")]
        public void GivenARaveCoderSetupWithTheFollowingOptions(Table coderConfigurationTable)
        {
            if (ReferenceEquals(coderConfigurationTable, null)) throw new NullReferenceException("coderConfigurationTable");

            var coderConfigurations = coderConfigurationTable.TransformFeatureTableStrings(_StepContext).CreateSet<RaveCoderFieldConfiguration>().ToList();
            
            var target = _StepContext.GetRaveArchitectRecordTarget();
            
            _Browser.SetCoderConfigurationForRaveFields(target, coderConfigurations);
        }

        [Then(@"the Rave Coder setup for draft ""(.*)"" has the following options configured")]
        public void ThenTheRaveCoderSetupForDraftHasTheFollowingOptionsConfigured(string draftName, Table coderConfigurationTable)
        {
            if (String.IsNullOrWhiteSpace(draftName)) throw new ArgumentNullException("draftName");
            if (ReferenceEquals(coderConfigurationTable, null)) throw new NullReferenceException("coderConfigurationTable");

            var expectedCoderConfigurations = coderConfigurationTable.TransformFeatureTableStrings(_StepContext).CreateSet<RaveCoderFieldConfiguration>().ToList();

            var target = new RaveArchitectRecordTarget
            {
                StudyName = _StepContext.GetStudyName(),
                DraftName = draftName
            };

            var actualCoderConfiguration = _Browser.GetCoderConfigurationForRaveFields(target, expectedCoderConfigurations);
            
            actualCoderConfiguration.Should().Equal(expectedCoderConfigurations, (actual, expected) => actual.Equals(expected));
        }
        

        [Then(@"the project ""(.*)"" draft ""(.*)"" form ""(.*)"" field ""(.*)"" has no Rave Coder setup options configured")]
        public void ThenTheProjectDraftFormFieldHasNoRaveCoderSetupOptionsConfigured(string studyName, string draftName, string formName, string fieldName)
        {
            if (String.IsNullOrWhiteSpace(studyName)) throw new ArgumentNullException("studyName");
            if (String.IsNullOrWhiteSpace(draftName)) throw new ArgumentNullException("draftName");
            if (String.IsNullOrWhiteSpace(formName))  throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(fieldName)) throw new ArgumentNullException("fieldName");

            var expectedCoderConfigurations = new RaveCoderFieldConfiguration
            {
                Form               = formName,
                Field              = fieldName,
                Dictionary         = String.Empty,
                Locale             = String.Empty,
                CodingLevel        = String.Empty,
                Priority           = String.Empty,
                IsApprovalRequired = String.Empty,
                IsAutoApproval     = String.Empty,
                SupplementalTerms  = String.Empty
            };

            var target = new RaveArchitectRecordTarget
            {
                StudyName = studyName,
                DraftName = draftName,
                FormName  = formName,
                FieldName = fieldName
            };

            var actualCoderConfiguration = _Browser.GetCoderConfigurationForRaveField(target);
            
            actualCoderConfiguration.Should().Be(expectedCoderConfigurations);
        }

        [Given(@"supplemental terms for the following fields")]
        [When(@"a Rave Coder supplemental setup is configured with the following options")]
        public void GivenSupplementalTermsForTheFollowingFields(Table supplementalTermsTable)
        {
            if (ReferenceEquals(supplementalTermsTable, null)) throw new NullReferenceException("supplementalTermsTable");

            var coderSupplementalConfigurations = supplementalTermsTable.TransformFeatureTableStrings(_StepContext).CreateSet<RaveCoderSupplementalConfiguration>().ToList();
            
            var target = _StepContext.GetRaveArchitectRecordTarget();

            _Browser.SetSupplementalTermsForRaveFields(target, coderSupplementalConfigurations);
        }

        [When(@"the supplemental term ""(.*)"" is removed from the Rave Coder setup of form ""(.*)"" field ""(.*)""")]
        public void WhenTheSupplementalTermIsRemovedFromTheRaveCoderSetupOfFormField(string supplementalTerm, string formName, string fieldName)
        {
            if (String.IsNullOrWhiteSpace(supplementalTerm)) throw new ArgumentNullException("supplementalTerm");
            if (String.IsNullOrWhiteSpace(formName))         throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(fieldName))        throw new ArgumentNullException("fieldName");

            var target       = _StepContext.GetRaveArchitectRecordTarget();
            target.FormName  = formName;
            target.FieldName = fieldName;

            _Browser.RemoveSupplementalTermFromRaveField(target, supplementalTerm);
        }
        
        [Given(@"the Coding Dictionary for the Rave Coder setup of form ""(.*)"" field ""(.*)"" is set to ""(.*)""")]
        [When(@"the Coding Dictionary for the Rave Coder setup of form ""(.*)"" field ""(.*)"" is set to ""(.*)""")]
        public void GivenTheCodingDictionaryForTheRaveCoderSetupOfFormFieldIsSetTo(string formName, string fieldName, string dictionaryName)
        {
            if (String.IsNullOrWhiteSpace(formName))       throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(fieldName))      throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(dictionaryName)) throw new ArgumentNullException("dictionaryName");

            var target       = _StepContext.GetRaveArchitectRecordTarget();
            target.FormName  = formName;
            target.FieldName = fieldName;

            _Browser.SetCodingDictionaryForRaveField(target, dictionaryName);
        }

        [When(@"the Coding Dictionary for the Rave Coder setup of form ""(.*)"" field ""(.*)"" is removed")]
        public void WhenTheCodingDictionaryForTheRaveCoderSetupOfFormFieldIsRemoved(string formName, string fieldName)
        {
            if (String.IsNullOrWhiteSpace(formName))       throw new ArgumentNullException("formName");
            if (String.IsNullOrWhiteSpace(fieldName))      throw new ArgumentNullException("fieldName");
            
            var target       = _StepContext.GetRaveArchitectRecordTarget();
            target.FormName  = formName;
            target.FieldName = fieldName;

            _Browser.SetCodingDictionaryForRaveField(target, "...");
        }
        
        [When(@"a Rave Draft is published and pushed using draft ""(.*)"" for Project ""(.*)"" to environment ""(.*)""")]
        public void WhenARaveDraftIsPublishedAndPushedUsingDraftForProjectToEnvironment(string draftNameFeature, string studyFeature, string environment)
        {
            if (String.IsNullOrWhiteSpace(draftNameFeature)) throw new ArgumentNullException("draftNameFeature");
            if (String.IsNullOrWhiteSpace(studyFeature))     throw new ArgumentNullException("studyFeature");
            if (String.IsNullOrWhiteSpace(environment))      throw new ArgumentNullException("environment");

            var draftName = StepArgumentTransformations.TransformFeatureString(draftNameFeature, _StepContext);
            var study     = StepArgumentTransformations.TransformFeatureString(studyFeature, _StepContext);

            var draftVersion = _Browser.PublishAndPushRaveArchitectDraft(study, draftName, environment);

            _StepContext.SourceDraftVersionName = draftVersion;
        }

        [When(@"a Rave Draft is published using draft ""(.*)"" for Project ""(.*)""")]
        public void WhenARaveDraftIsPublishedUsingDraftForProject(string draftNameFeature, string studyFeature)
        {
            if (String.IsNullOrWhiteSpace(draftNameFeature)) throw new ArgumentNullException("draftNameFeature");
            if (String.IsNullOrWhiteSpace(studyFeature))     throw new ArgumentNullException("studyFeature");

            var draftName = StepArgumentTransformations.TransformFeatureString(draftNameFeature, _StepContext);
            var study     = StepArgumentTransformations.TransformFeatureString(studyFeature, _StepContext);
            
            var draftVersion = _Browser.PublishRaveArchitectDraft(study, draftName);

            _StepContext.TargetDraftVersionName = draftVersion;
        }

        [When(@"an Amendment Manager migration is started for Project ""(.*)""")]
        public void WhenAnAmendmentManagerMigrationIsStartedForProject(string studyFeature)
        {
            if (String.IsNullOrWhiteSpace(studyFeature)) throw new ArgumentNullException("studyFeature");

            var study = StepArgumentTransformations.TransformFeatureString(studyFeature, _StepContext);

            _Browser.MigrateRaveArchitectDraftVersion(study, _StepContext.SourceDraftVersionName, _StepContext.TargetDraftVersionName);
        }

        [Given(@"a Rave CRF copy source is added for the project")]
        [When(@"a Rave CRF copy source is added for the project")]
        public void GivenARaveCRFCopySourceIsAddedForTheProject()
        {
            AddRaveCRFCopySourceForProject(
                sourceStudyName: _StepContext.GetStudyName(),
                sourceDraftName: _StepContext.DraftName,
                targetStudyName: _StepContext.GetStudyName());
        }

        [Given(@"a Rave CRF copy source from project ""(.*)"" draft ""(.*)"" is added for project ""(.*)""")]
        [When(@"a Rave CRF copy source from project ""(.*)"" draft ""(.*)"" is added for project ""(.*)""")]
        public void AddRaveCRFCopySourceForProject(string sourceStudyName, string sourceDraftName, string targetStudyName)
        {
            if (String.IsNullOrWhiteSpace(sourceStudyName)) throw new ArgumentNullException("sourceStudyName");
            if (String.IsNullOrWhiteSpace(sourceDraftName)) throw new ArgumentNullException("sourceDraftName");
            if (String.IsNullOrWhiteSpace(targetStudyName)) throw new ArgumentNullException("targetStudyName");

            var copySourceType = "Project - Drafts";

            _Browser.AddRaveCRFCopySource(targetStudyName, copySourceType, sourceStudyName, sourceDraftName);
        }
        
        [When(@"a new Draft ""(.*)"" is created through copy wizard")]
        public void WhenANewDraftIsCreatedThroughCopyWizard(string newDraftName)
        {
            if (String.IsNullOrWhiteSpace(newDraftName)) throw new ArgumentNullException("newDraftName");

            CreateNewCRFDraftCopyForProject(newDraftName, targetStudyName:_StepContext.GetStudyName());
        }

        [When(@"a new Draft ""(.*)"" is created through copy wizard for project ""(.*)""")]
        public void CreateNewCRFDraftCopyForProject(string newDraftName, string targetStudyName)
        {
            if (String.IsNullOrWhiteSpace(newDraftName))       throw new ArgumentNullException("newDraftName");
            if (String.IsNullOrWhiteSpace(targetStudyName))    throw new ArgumentNullException("targetStudyName");

            _Browser.CreateNewCRFDraftCopy(targetStudyName: targetStudyName, targetDraftName: newDraftName, sourceDraftName: _StepContext.DraftName);
        }

        [When(@"a Rave Draft is published and has pushed disabled using draft ""(.*)"" for Project ""(.*)"" to environment ""(.*)""")]
        public void WhenARaveDraftIsPublishedAndHasPushedDisabledUsingDraftForProjectToEnvironment(string draftNameFeature, string studyFeature, string environment)
        {
            if (String.IsNullOrWhiteSpace(draftNameFeature)) throw new ArgumentNullException("draftNameFeature");
            if (String.IsNullOrWhiteSpace(studyFeature)) throw new ArgumentNullException("studyFeature");
            if (String.IsNullOrWhiteSpace(environment)) throw new ArgumentNullException("environment");

            var draftName = StepArgumentTransformations.TransformFeatureString(draftNameFeature, _StepContext);
            var study = StepArgumentTransformations.TransformFeatureString(studyFeature, _StepContext);

            _Browser.PublishAndIncompletePushRaveArchitectDraft(study, draftName, environment);
        }

        [Then(@"pushing a CRF should be disabled with the following failed message ""(.*)""")]
        public void ThenVerifyCRFWasPublishedAndPushIsDisabled(string expectedPushMessage)
        {
            if (String.IsNullOrWhiteSpace(expectedPushMessage)) throw new ArgumentNullException("expectedPushMessage");

            var pushEnable = _Browser.IsCRFPushEnabled();
            var actualFailedMessage = _Browser.GetCRFPushErrorMessage();

            pushEnable.Should().BeFalse();
            actualFailedMessage.Should().BeEquivalentTo(expectedPushMessage);
        }

        [When(@"a Rave study environment ""(.*)"" is created for project ""(.*)""")]
        public void WhenARaveStudyEnvironmentIsCreatedForProject(string studyEnvironment, string projectName)
        {
            if (String.IsNullOrWhiteSpace(studyEnvironment)) throw new ArgumentNullException("studyEnvironment");
            if (String.IsNullOrWhiteSpace(projectName)) throw new ArgumentNullException("projectName");

            var studyName = StepArgumentTransformations.TransformFeatureString(projectName, _StepContext);

            _Browser.LoadiMedidataRaveModulesAppSegment(_StepContext.GetSegment());
            _Browser.ARaveStudyEnvironmentIsCreatedForProject(studyEnvironment, studyName);
        }

        [Then(@"Verify Rave Coder Global Configuration download located ""(.*)"" worksheet ""(.*)"" Review Marking Group ""(.*)"" Requires Response ""(.*)""")]
        public void ThenVerifyRaveCoderGlobalConfigurationDownloadLocatedWorksheetReviewMarkingGroupRequiresResponse(string downloadDirectory, string workSheetName, string reviewMarkingGroup, string isRequiresResponse)
        {
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException(downloadDirectory);
            if (String.IsNullOrWhiteSpace(workSheetName)) throw new ArgumentNullException(workSheetName);
            if (String.IsNullOrWhiteSpace(reviewMarkingGroup)) throw new ArgumentNullException(reviewMarkingGroup);
            if (String.IsNullOrWhiteSpace(isRequiresResponse)) throw new ArgumentNullException(isRequiresResponse);

            var configurationCorrect = _Browser.IsRaveCoderGlobalConfigurationXLSFileCorrect(downloadDirectory, workSheetName, reviewMarkingGroup, isRequiresResponse);

            configurationCorrect.Should().BeTrue();
        }

        [When(@"downloading Rave Architect CRF")]
        public void WhenDownloadingRaveArchitectCRF()
        {
            _Browser.DownloadRaveArchitectDraft(_StepContext.GetStudyName(), _StepContext.DraftName);            
        }

        [Then(@"verify the following Rave Architect CRF Download Coder Configuration information")]
        public void ThenVerifyFileHasTheFollowingRaveArchitectCRFCoderConfigurationInformation(Table crfCoderConfigurationTable)
        {
            if (ReferenceEquals(crfCoderConfigurationTable, null)) throw new NullReferenceException("crfCoderConfigurationTable");

            var crfCoderConfigurations = crfCoderConfigurationTable.TransformFeatureTableStrings(_StepContext).CreateSet<RaveArchitectCRFCoderFieldWorkSheet>().ToList();

            var fileName = String.Format("{0}_{1}.zip", _StepContext.GetStudyName(), _StepContext.DraftName); 

            var filePath = _StepContext.DownloadDirectory;

            var configurationCorrect = _Browser.IsRaveCRFCoderConfigurationXLSFileCorrect(fileName, filePath, crfCoderConfigurations);

            configurationCorrect.Should().BeTrue();
        }

        [Then(@"verify the following Rave Architect CRF Download Coder Supplemental Terms information")]
        public void ThenVerifyFileHasTheFollowingRaveArchitectCRFCoderSupplementalTermsInformation(Table crfCoderSupplementalTable)
        {
            if (ReferenceEquals(crfCoderSupplementalTable, null)) throw new NullReferenceException("crfCoderSupplementalTable");

            var crfCoderSups = crfCoderSupplementalTable.TransformFeatureTableStrings(_StepContext).CreateSet<RaveCoderSupplementalConfiguration>().ToList();

            var fileName = String.Format("{0}_{1}.zip", _StepContext.GetStudyName(), _StepContext.DraftName);

            var filePath = _StepContext.DownloadDirectory;

            var configurationCorrect = _Browser.IsRaveCRFCoderSupplementalTermsXLSFileCorrect(fileName, filePath, crfCoderSups);

            configurationCorrect.Should().BeTrue();
        }

        [Then(@"verify the following CRF upload error message ""(.*)""")]
        public void ThenVerifyTheFollowingCRFUploadErrorMessage(string expectedErrorMessage)
        {
            if (String.IsNullOrWhiteSpace(expectedErrorMessage)) throw new ArgumentNullException(expectedErrorMessage);

            var actualFailedMessage = _Browser.GetFieldReportErrMsg();

            actualFailedMessage.Should().BeEquivalentTo(expectedErrorMessage);
        }

    }
}
