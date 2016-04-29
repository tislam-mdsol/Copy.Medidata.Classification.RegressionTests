using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.Models;
using Coder.TestSteps.Transformations;
using System;
using System.Collections.Generic;
using System.IO;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Helpers;
using FluentAssertions;
using TechTalk.SpecFlow;

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

            _Browser.LoadiMedidataRaveModulesAppSegment(_StepContext.Segment);

            _Browser.AddRaveArchitectDraft(study, draftName);
        }
        
        [When(@"deleting a rave architect draft ""(.*)"" from study ""(.*)""")]
        public void WhenDeletingARaveArchitectDraftFromStudy(string draftName, string studyFeature)
        {
            if (String.IsNullOrWhiteSpace(draftName))     throw new ArgumentNullException("draftName");
            if (String.IsNullOrWhiteSpace(studyFeature))  throw new ArgumentNullException("studyFeature");

            var study = StepArgumentTransformations.TransformFeatureString(studyFeature, _StepContext);

            _Browser.LoadiMedidataRaveModulesAppSegment(_StepContext.Segment);

            _Browser.DeleteRaveArchitectDraft(study, draftName);
        }
        
        [When(@"uploading a rave architect draft template ""(.*)"" to ""(.*)"" for study ""(.*)""")]
        public void WhenUploadingARaveArchitectDraftTemplate(string draftTemplateFileName, string draftName, string studyFeature)
        {
            if (String.IsNullOrWhiteSpace(draftTemplateFileName)) throw new ArgumentNullException("draftTemplateFileName");
            if (String.IsNullOrWhiteSpace(draftName))     throw new ArgumentNullException("draftName");
            if (String.IsNullOrWhiteSpace(studyFeature))  throw new ArgumentNullException("studyFeature");

            var study = StepArgumentTransformations.TransformFeatureString(studyFeature, _StepContext);
            
            _Browser.LoadiMedidataRaveModulesAppSegment(_StepContext.Segment);
            
            var draftTemplateFilePath = Path.Combine(Config.StaticContentFolder, draftTemplateFileName);

            var draftFileName         = String.Format("{0}_{1}_{2}", draftName, study.RemoveNonAlphanumeric(), draftTemplateFileName);
            var draftFilePath         = Path.Combine(_StepContext.DumpDirectory, draftFileName);

            Dictionary<string, string> replacementPairs = new Dictionary<string, string>
            {
                {"RaveCoderDraftTemplateName"       , draftName},
                {"RaveCoderDraftTemplateProjectName", study    }
            };

            BrowserUtility.ReplaceTextInFile(draftTemplateFilePath, draftFilePath, replacementPairs);

            _Browser.UploadRaveArchitectDraft(study, draftName, draftFilePath);
        }
    }
}
