using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.FileHelpers;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using Newtonsoft.Json;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class MevSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext             _StepContext;
        private readonly string                  _DownloadFileName = "coding-jobs.csv";
        private readonly string                  _CoderMevDownloadFilePath;
        private readonly Dictionary<int, string> _MevFileCollection;
        private string                           _UploadedMevFile;
        private const string                     DefaultFileName = "MevFile";
        private readonly SegmentSetupData       _SegmentSetupData;


        public MevSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))     throw new NullReferenceException("Browser");

            _StepContext      = stepContext;
            _Browser          = _StepContext.Browser;

            _MevFileCollection = new Dictionary<int, string>();
            _CoderMevDownloadFilePath = Path.Combine(_StepContext.DownloadDirectory, "coding-jobs.csv");
        }

        [When(@"uploading MEV content and AutoCoding is complete")]
        public void GivenUploadedMEVContentAndAutoCodingIsComplete(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            WhenUploadingMevContent(table);
            
            _Browser.WaitForAutoCodingToComplete();
        }

        [When(@"uploading MEV content")]
        public void WhenUploadingMevContent(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var externalVerbatimRows = table.TransformFeatureTableStrings(_StepContext).CreateSet<ExternalVerbatim>().ToArray();

            externalVerbatimRows.SetNonRequiredMevColumnsToDefaultValues(_StepContext);

            _UploadedMevFile = Path.Combine(_StepContext.DumpDirectory, DefaultFileName.AppendRandomString() + ".csv");

            GenericCsvHelper.WriteDelimitedFile(externalVerbatimRows, _UploadedMevFile, true);

            RegisterMevFile(_UploadedMevFile);

            _Browser.UploadMevFileAndWaitForCompletion(_UploadedMevFile);
        }

        [When(@"uploading MEV content ""(.*)""")]
        public void WhenUploadingMevContent(string file)
        {
            if (ReferenceEquals(file, null)) throw new ArgumentNullException("file");

            _UploadedMevFile  = file;

            var filePath = Config.StaticContentFolder.AppendFileNameToDirectoryPath(_UploadedMevFile);

            _Browser.UploadMevFileAndWaitForCompletion(filePath);
        }

        [When(@"uploading ""(.*)"" WhoDrug tasks")]
        public void WhenUploadingWhoDrugTasks(int numberOfTermsToUpload)
        {
            if(numberOfTermsToUpload <= 0) throw new ArgumentOutOfRangeException("numberOfTermsToUpload");

            var mevUploadFile = SetupMevUpload(numberOfTermsToUpload, Config.WhoDrugTermsFileName);

            _Browser.UploadMevFileAndWaitForCompletion(mevUploadFile);
        }
        
        [When(@"uploading ""(.*)"" MedDRA direct dictionary matches")]
        public void WhenUploadingMedDRADirectDictionaryMatches(int numberOfTermsToUpload)
        {
            if(numberOfTermsToUpload <= 0) throw new ArgumentOutOfRangeException("numberOfTermsToUpload");

            var mevUploadFile = SetupMevUpload(numberOfTermsToUpload, Config.MedDra15DdmFileName);

            _Browser.UploadMevFileAndWaitForCompletion(mevUploadFile);
        }

        [When(@"uploading incorrect MEV content")]
        public void WhenUploadingIncorrectMEVContent()
        {
            var externalVerbatims = GetMevContentByFileName(Config.MevDownloadFailuresFileName);

            externalVerbatims.SetContextStudyId(_StepContext);

            _UploadedMevFile = Path.Combine(_StepContext.DumpDirectory, "IncorrectMEVContent.csv");

            GenericCsvHelper.WriteDelimitedFile(externalVerbatims, _UploadedMevFile, true);

            RegisterMevFile(_UploadedMevFile);

            _Browser.UploadMevFileAndWaitForCompletion(_UploadedMevFile);
        }

        [When(@"downloading MEV file")]
        public void WhenDownloadingMEVFile()
        {
            MevDownloadCriteria downloadCriteria = new MevDownloadCriteria
            {
                Study = _StepContext.SegmentUnderTest.ProdStudy.StudyName
            };

            _Browser.DownloadMevFile(downloadCriteria, _DownloadFileName);
        }

        [Then(@"the coding task has the following information")]
        public void ThenTheCodingTaskHasTheFollowingInformation(Table table)
        {
            if (ReferenceEquals(table, null)) { throw new ArgumentNullException("table"); }

            var codingTasks = table.TransformFeatureTableStrings(_StepContext).CreateSet<CodingTask>().ToArray();

            _Browser.AssertCodingTasksExist(codingTasks);
        }

        [Then(@"the user should be notified with the following message ""(.*)""")]
        public void ThenTheUserShouldBeNotifiedWithTheFollowingMessage(string validationMessage)
        {
            if (ReferenceEquals(validationMessage, null)) throw new ArgumentNullException("validationMessage");

            var fileName        = Path.GetFileName(_UploadedMevFile);
            var expectedMessage = validationMessage.Replace("<MevFileName>", fileName);

            _Browser.AssertThatValidCsvFormatMessageIsCorrect(expectedMessage);
        }

        [Then(@"the uploaded coding tasks has the following information")]
        public void ThenTheFollowingUploadedCodingTasksInformationIsDisplayed(Table table)
        {
            if (ReferenceEquals(table, null))
            {
                throw new ArgumentNullException("table");
            }

            var uploadedCodingTasks = table.TransformFeatureTableStrings(_StepContext).CreateSet<UploadedCodingTask>().ToArray();

            foreach (var uploadedCodingTask in uploadedCodingTasks)
            {
                Debug.Assert(uploadedCodingTask.FileName.IsNumeric(), "Feature file should contain a number for file name in order for us to swap with runtime generated file name");

                var fileNumber = uploadedCodingTask.FileName.ToInteger();
                
                uploadedCodingTask.FileName = _MevFileCollection
                    .Where(x => x.Key.Equals(fileNumber))
                    .Select(x => Path.GetFileName(x.Value)).FirstOrDefault();
            }
            
            _Browser.AssertDataMatchesUploadedCodingTasks(uploadedCodingTasks, Config.TimeStampHoursDiff);
        }

        [Then(@"the ""(.*)"" task has the following supplemental information")]
        public void ThenTheTaskHasTheFollowingSupplementalInformation(string task,Table table)
        {
            if (ReferenceEquals(task, null)) throw new ArgumentNullException("task");
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");
            
            var supplementalInfoList = table.TransformFeatureTableStrings(_StepContext).CreateSet<SupplementalTerm>().ToArray();
            
            _Browser.AssertThatTheTaskHasSupplementalInfo(task, supplementalInfoList);
        }

        [Then(@"the downloaded MEV file should contain the following external verbatims")]
        public void ThenTheDownloadedMEVFileShouldContainTheFollowingExternalVerbatims(Table table)
        {
            if (ReferenceEquals(table,null)) throw new ArgumentNullException("table");

            var downloadedFilePath = Path.Combine(_StepContext.DownloadDirectory, _DownloadFileName);

            var expectedResults = table.TransformFeatureTableStrings(_StepContext).CreateSet<ExternalVerbatim>().ToArray();
            var actualResults   = GenericCsvHelper.GetReportRows<ExternalVerbatim>(downloadedFilePath).ToArray();

            foreach (var expectedResult in expectedResults)
            {
                var anyMatch = actualResults.Any(x => x.Equals(expectedResult));

                anyMatch.Should().BeTrue(String.Format("MEV download should contain: {0}", expectedResult.ToString()));
            }
        }


        [Given(@"a ""(.*)"" Coder setup with no tasks and no synonyms and dictionaries")]
        public void GivenACoderSetupWithNoTasksAndNoSynonymsAndDictionaries(string setupType, Table table)
        {
            if (String.IsNullOrEmpty(setupType)) throw new ArgumentNullException("setupType");
            if (ReferenceEquals(table, null))
            {
                throw new ArgumentNullException("table");
            }

            var synonymLists = table.TransformFeatureTableStrings(_StepContext).CreateSet<SynonymList>().ToArray();

            foreach (SynonymList synonymList in synonymLists)
            {
                var dictionaryLocaleVersion = synonymList.Dictionary + " " + synonymList.Locale + " " +
                                              synonymList.Version;

                _StepContext.SetProjectRegistrationContext(dictionaryLocaleVersion);
                _StepContext.SourceSynonymList = synonymList;
                _StepContext.SetSourceSystemApplicationContext();
                _Browser.SetupCoderConfiguration(_StepContext, setupType);
            }
            
            _StepContext.CleanUpAndRegisterProject(synonymLists);
        }

        [Then(@"""(.*)"" tasks are processed by the workflow")]
        public void ThenTasksAreProcessedByTheWorkflow(int processedCount)
        {
            _Browser.AssertTasksAreProcessedByTheWorkflow(processedCount);
        }
        
        [When(@"downloading MEV failure content")]
        public void WhenDownloadingMevFailureContent()
        {
            _Browser.DownloadMevFailureContent(Path.GetFileName(_UploadedMevFile));
        }

        [Then(@"the downloaded Mev error file should contain following")]
        public void ThenTheDownloadedMevErrorFileShouldContainFollowing(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var expectedResults    = table.TransformFeatureTableStrings(_StepContext, '"').CreateSet<ExternalVerbatim>().ToArray();
            
            var downloadedFilePath =
                Path.Combine(_StepContext.DownloadDirectory, Path.GetFileName(_UploadedMevFile))
                    .AppendErrorFileNameToDirectoryPath();

            var actualResults = GenericCsvHelper.GetReportRows<ExternalVerbatim>(downloadedFilePath).ToArray();

            foreach (var expectedResult in expectedResults)
            {
                var anyMatch = actualResults.Any(x => x.Equals(expectedResult));

                anyMatch.Should().BeTrue(String.Format("MEV Failures should contain: {0}", expectedResult.ToString()));
            }
        }

        [Then(@"only ""(.*)"" rows are present in the csv file")]
        public void ThenOnlyRowsArePresentInTheCsvFile(int expectedCount)
        {
            if (expectedCount < 0) throw new ArgumentNullException("expectedCount");

            var downloadedFile = Path.Combine(_StepContext.DownloadDirectory, _DownloadFileName);

            var actualCount = GenericFileHelper.GetFileRowCount(downloadedFile);

            actualCount.ShouldBeEquivalentTo(expectedCount);
        }

        [Then(@"task ""(.*)"" is available within reclassification")]
        public void ThenTaskIsAvailableWithinReclassification(string term)
        {
            if (String.IsNullOrEmpty(term)) throw new ArgumentNullException("term");

            _Browser.AssertTaskAvailableWithinReclassification(term, _StepContext.Dictionary, _StepContext.Locale, _StepContext.Version, "true");

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"task ""(.*)"" is available within reclassification for dictionary ""(.*)"" version ""(.*)"" locale ""(.*)""")]
        public void ThenTaskIsAvailableWithinReclassificationForDictionaryVersionLocale(string term, string dictionary, string version, string locale)
        {
            if (String.IsNullOrEmpty(term))       throw new ArgumentNullException("term");
            if (String.IsNullOrEmpty(dictionary)) throw new ArgumentNullException("dictionary");
            if (String.IsNullOrEmpty(version))    throw new ArgumentNullException("version");
            if (String.IsNullOrEmpty(locale))     throw new ArgumentNullException("locale");

            _Browser.AssertTaskAvailableWithinReclassification(term, dictionary, locale, version, "true");

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"the MEV upload capability is available")]
        public void ThenTheMEVUploadCapabilityIsAvailable()
        {
            _Browser.IsMevUploadCapabilityAvailable().Should().BeTrue();

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        private static IList<DirectDictionaryMatch> GetDirectDictionaryMatchTermsByFileName(string fileName)
        {
            if (String.IsNullOrWhiteSpace(fileName)) throw new ArgumentNullException("fileName");

            var filePath     = Config.StaticContentFolder.AppendFileNameToDirectoryPath(fileName);
            var fileContents = File.ReadAllText(filePath);
            var terms        = JsonConvert.DeserializeObject<List<DirectDictionaryMatch>>(fileContents);

            return terms;
        }

        private static IList<ExternalVerbatim> GetMevContentByFileName(string fileName)
        {
            if (String.IsNullOrWhiteSpace(fileName)) throw new ArgumentNullException("fileName");

            var filePath          = Config.StaticContentFolder.AppendFileNameToDirectoryPath(fileName);
            var fileContents      = File.ReadAllText(filePath);
            var externalVerbatims = JsonConvert.DeserializeObject<List<ExternalVerbatim>>(fileContents);

            return externalVerbatims;
        }

        private IEnumerable<ExternalVerbatim> BuildExternalVerbatimsFromTerms(int numberOfTermsToUpload, IList<DirectDictionaryMatch> terms)
        {
            if (numberOfTermsToUpload <= 0)   throw new ArgumentOutOfRangeException("numberOfTermsToUpload");
            if (ReferenceEquals(terms, null)) throw new ArgumentNullException("terms");

            var externalVerbatims = new List<ExternalVerbatim>();

            for (var i = 0; i < numberOfTermsToUpload; i++)
            {
                var mev                = new ExternalVerbatim
                {
                    VerbatimTerm       = terms[i].Term,
                    Dictionary         = _StepContext.Dictionary,
                    DictionaryLevel    = terms[i].Level,
                    IsApprovalRequired = _StepContext.IsApprovalRequired,
                    IsAutoApproval     = _StepContext.IsAutoApproval
                };

                externalVerbatims.Add(mev);
            }

            externalVerbatims.SetNonRequiredMevColumnsToDefaultValues(_StepContext);

            return externalVerbatims;
        }

        private string SetupMevUpload(int numberOfTermsToUpload, string fileName)
        {
            if (numberOfTermsToUpload <= 0)          throw new ArgumentOutOfRangeException("numberOfTermsToUpload");
            if (String.IsNullOrWhiteSpace(fileName)) throw new ArgumentNullException("fileName"); 

            var terms             = GetDirectDictionaryMatchTermsByFileName(fileName);
            var externalVerbatims = BuildExternalVerbatimsFromTerms(numberOfTermsToUpload, terms);

            _UploadedMevFile = DefaultFileName.AppendRandomString().AppendFileType("csv");

            var filePath = Path.Combine(_StepContext.DumpDirectory, _UploadedMevFile);

            GenericCsvHelper.WriteDelimitedFile(externalVerbatims, filePath, true);

            RegisterMevFile(filePath);

            return filePath;
        }

        private void RegisterMevFile(string filePath)
        {
            if(String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException("filePath");

            var fileKey = _MevFileCollection.Count + 1;

            _MevFileCollection.Add(fileKey, filePath);
        }
    }
}
