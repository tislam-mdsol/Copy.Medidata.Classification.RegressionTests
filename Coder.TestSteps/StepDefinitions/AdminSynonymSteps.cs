using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.FileHelpers;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.TestSteps.Transformations;
using FluentAssertions;
using FluentAssertions.Execution;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class AdminSynonymSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext             _StepContext;
        private SynonymRow[]                     _ProvisionalSynonyms;
        
        public AdminSynonymSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))                 throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser , null))        throw new NullReferenceException("Browser");

            _StepContext    = stepContext;
            _Browser        = _StepContext.Browser;
        }

        [Given(@"a ""(.*)"" Coder setup with an empty registered synonym list ""(.*)""")]
        public void GivenACoderSetupWithRegisteredSynonymList(
            string setupType, 
            string dictionaryLocaleVersionSynonymListName)
        {
            if (String.IsNullOrEmpty(setupType))                                throw new ArgumentNullException("setupType");
            if (String.IsNullOrEmpty(dictionaryLocaleVersionSynonymListName))   throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            var synonymList                 = GetSynonymList(dictionaryLocaleVersionSynonymListName);
            _StepContext.SourceSynonymList  = synonymList;

            _Browser.SetupStudyWithEmptySynonymList(
                stepContext:    _StepContext, 
                setupType:      setupType, 
                synonymList:    synonymList);
        }

        [Given(@"a ""(.*)"" Coder setup with registered synonym list ""(.*)"" containing entry ""(.*)""")]
        public void GivenACoderSetupWithRegisteredSynonymListContainingEntry(
            string setupType, 
            string dictionaryLocaleVersionSynonymListName, 
            string delimitedSynonym)
        {
            if (String.IsNullOrEmpty(setupType))                                throw new ArgumentNullException("setupType");
            if (String.IsNullOrEmpty(dictionaryLocaleVersionSynonymListName))   throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            var synonymList                 = GetSynonymList(dictionaryLocaleVersionSynonymListName);
            _StepContext.SourceSynonymList  = synonymList;

            _Browser.SetupStudyWithRegisteredSynonymList(
                stepContext:        _StepContext, 
                setupType:          setupType, 
                synonymList:        synonymList,
                delimitedSynonym:   delimitedSynonym);
        }

        [Given(@"an unactivated synonym list ""(.*)""")]
        public void GivenAnUnactivatedSynonymList(string dictionaryLocaleVersionSynonymListName)
        {
            if (String.IsNullOrEmpty(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            var targetSynonymList           = GetSynonymList(dictionaryLocaleVersionSynonymListName);
            _StepContext.TargetSynonymList  = targetSynonymList;

            _Browser.CreateUnactivatedSynonymList(
                stepContext:    _StepContext, 
                synonymList:    targetSynonymList);
        }

        [Given(@"an activated synonym list ""(.*)""")]
        public void GivenAnActivatedSynonymList(string dictionaryLocaleVersionSynonymListName)
        {
            if (String.IsNullOrEmpty(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            var synonymList                = GetSynonymList(dictionaryLocaleVersionSynonymListName);
            _StepContext.TargetSynonymList = synonymList;
            
            _Browser.CreateActivatedSynonymList(
                stepContext: _StepContext,
                synonymList: synonymList);
        }

        [Given(@"a populated activated synonym list ""(.*)"" containing entry ""(.*)""")]
        public void GivenAPopulatedActivatedSynonymListContainingEntry(
            string dictionaryLocaleVersionSynonymListName,
            string delimitedSynonym)
        {
            if (String.IsNullOrEmpty(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            var synonymList = GetSynonymList(dictionaryLocaleVersionSynonymListName);
            _StepContext.TargetSynonymList = synonymList;

            _Browser.CreateActivatedSynonymListWithSynonyms(
                stepContext: _StepContext,
                synonymList: synonymList,
                delimitedSynonym: delimitedSynonym);
        }


        [Given(@"a synonym list file named ""(.*)"" is uploaded")]
        public void GivenASynonymListFileNamedIsUploaded(string fileName)
        {
            if (String.IsNullOrWhiteSpace(fileName)) throw new ArgumentNullException("fileName");

            var synonymFilePath = Config.StaticContentFolder.AppendFileNameToDirectoryPath(fileName);
            var synonymList     = GetSynonymListFromContext();

            _Browser.UploadSynonymFile(synonymList, synonymFilePath);
        }

        [Given(@"a synonym list upload with the following synonyms")]
        public void GivenASynonymListUploadWithTheFollowingSynonyms(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var featureData = table.TransformFeatureTableStrings(_StepContext).CreateSet<SynonymUploadRow>();

            if (!featureData.Any())
            {
                throw new ArgumentException("Synonym list upload table is empty");
            }

            var filePath = Path.Combine(_StepContext.DumpDirectory, "SynonymUpload.txt");

            GenericCsvHelper.WriteDelimitedFile(featureData, filePath, true);

            var synonymList = GetSynonymListFromContext();
            _Browser.UploadSynonymFile(synonymList, filePath);
        }


        [When(@"uploading synonym list file ""(.*)"" to ""(.*)""")]
        public void WhenUploadingSynonymListFileTo(string synonymFileName, string dictionaryLocaleVersionSynonymListName)
        {
            if (String.IsNullOrWhiteSpace(synonymFileName))                        throw new ArgumentNullException("synonymFileName");
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            var synonymList                = GetSynonymList(dictionaryLocaleVersionSynonymListName);
            var synonymFilePath            = Config.StaticContentFolder.AppendFileNameToDirectoryPath(synonymFileName);
            _StepContext.SourceSynonymList = synonymList;
            _Browser.UploadSynonymFile(synonymList, synonymFilePath);
        }
        
        [When(@"downloading a synonym list file from ""(.*)"" on the Synonym page to ""(.*)""")]
        public void WhenDownloadingASynonymListFileFromOnTheSynonymPageTo(string dictionaryLocaleVersionSynonymListName, string synonymFileName)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");
            if (String.IsNullOrWhiteSpace(synonymFileName))                        throw new ArgumentNullException("synonymFileName");

            var synonymList                = GetSynonymList(dictionaryLocaleVersionSynonymListName);
            _StepContext.SourceSynonymList = synonymList;

            _Browser.DownloadSynonymFileFromSynonymPage(synonymList, synonymFileName);
        }

        [When(@"downloading a synonym list file from ""(.*)"" on the Synonym List page to ""(.*)""")]
        public void WhenDownloadingASynonymListFileFromOnTheSynonymListPageTo(string dictionaryLocaleVersionSynonymListName, string synonymFileName)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");
            if (String.IsNullOrWhiteSpace(synonymFileName))                        throw new ArgumentNullException("synonymFileName");

            var synonymList                = GetSynonymList(dictionaryLocaleVersionSynonymListName);
            _StepContext.SourceSynonymList = synonymList;

            var synonymSearch              = GetCurrentContextSynonymSearch();

            _Browser.DownloadSynonymFileFromSynonymListPage(synonymSearch, synonymFileName);
        }
        
        [When(@"starting synonym list migration")]
        public void WhenStartingSynonymListMigration()
        {
            _Browser.MigrateSynonymList(
                sourceSynonymList:  _StepContext.SourceSynonymList, 
                targetSynonymList:  _StepContext.TargetSynonymList);
        }

        [When(@"accepting the reconciliation suggestion for the synonym ""(.*)"" under the category ""(.*)""")]
        public void WhenAcceptingTheReconciliationSuggestionForTheSynonymForTheCategory(
            string synonymName, 
            string categoryType)
        {
            if (String.IsNullOrEmpty(synonymName))      throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))     throw new ArgumentNullException("categoryType");
            
            if (categoryType.Equals("No Clear Match", StringComparison.OrdinalIgnoreCase))
            {
                _Browser.AcceptNoClearMatchSynonymSuggestion(
                    targetSynonymList:  _StepContext.TargetSynonymList, 
                    categoryType:       categoryType, 
                    synonymName:        synonymName);
            }
            else
            {
                _Browser.AcceptSynonymSuggestion(
                    targetSynonymList:  _StepContext.TargetSynonymList,
                    categoryType:       categoryType,
                    synonymName:        synonymName);
            }
        }

        [When(@"completing synonym migration")]
        public void WhenCompletingSynonymMigration()
        {
            _Browser.MigrateSynonyms(_StepContext.TargetSynonymList);
        }

        [When(@"I perform a synonym migration accepting the reconciliation suggestion for the synonym ""(.*)"" under the category ""(.*)""")]
        public void WhenIPerformASynonymMigrationAcceptingTheReconciliationSuggestionForTheSynonymUnderTheCategory(
            string synonymName,
            string categoryType)
        {
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");

            WhenStartingSynonymListMigration();
            WhenAcceptingTheReconciliationSuggestionForTheSynonymForTheCategory(synonymName, categoryType);
            WhenCompletingSynonymMigration();
        }


        [When(@"dropping the reconciliation suggestion for the synonym ""(.*)"" under the category ""(.*)""")]
        public void WhenDroppingTheReconciliationSuggestionForTheSynonymUnderTheCategory(
            string synonymName, 
            string categoryType)
        {
            if (String.IsNullOrEmpty(synonymName))      throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))     throw new ArgumentNullException("categoryType");

            _Browser.DropSynonym(
                targetSynonymList:  _StepContext.TargetSynonymList, 
                categoryType:       categoryType, 
                synonymName:        synonymName);
        }

        [When(@"accepting the declined synonym ""(.*)"" under the category ""(.*)""")]
        public void WhenIAcceptTheDeclinedSynonymForTheCategory(
            string synonymName, 
            string categoryType)
        {
            if (String.IsNullOrEmpty(synonymName))      throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))     throw new ArgumentNullException("categoryType");

            _Browser.AcceptDeclinedSynonym(
                targetSynonymList:  _StepContext.TargetSynonymList, 
                categoryType:       categoryType, 
                synonymName:        synonymName);
        }

        [When(@"accepting the reconciliation suggestion for ""(.*)"" synonyms under the category ""(.*)""")]
        public void WhenIAcceptSynonyms(
            int synonymsToAcceptCount, 
            string categoryType)
        {
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");

            _Browser.AcceptSynonymsByCategoryTypeAndCount(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                categoryType:           categoryType, 
                synonymsToAcceptCount:  synonymsToAcceptCount);
        }

        [When(@"accepting ""(.*)"" declined synonyms under the category ""(.*)""")]
        public void WhenAcceptingDeclinedSynonymsUnderTheCategory(int synonymsToAcceptCount, string categoryType)
        {
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");

            _Browser.AcceptDeclinedSynonymsByCategoryTypeAndCount(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                categoryType:           categoryType, 
                synonymsToAcceptCount:  synonymsToAcceptCount);
        }

        [When(@"dropping the reconciliation suggestion for ""(.*)"" synonyms under the category ""(.*)""")]
        public void WhenIDropSynonyms(
            int synonymsToDropCount, 
            string categoryType)
        {
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");

            _Browser.DropSynonymsByCategoryTypeAndCount(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                categoryType:           categoryType, 
                synonymsToDropCount:    synonymsToDropCount);
        }

        [When(@"dropping ""(.*)"" migrated synonyms under the category ""(.*)""")]
        public void WhenDroppingMigratedSynonymsUnderTheCategory(int synonymsToDropCount, string categoryType)
        {
            if (String.IsNullOrEmpty(categoryType)) throw new ArgumentNullException("categoryType");

            _Browser.DropMigratedSynonymsByCategoryTypeAndCount(
                targetSynonymList:      _StepContext.TargetSynonymList,
                categoryType:           categoryType,
                synonymsToDropCount:    synonymsToDropCount);
        }

        [When(@"accepting the reconciliation suggestions for all the new synonym versions")]
        public void WhenAcceptingTheReconciliationSuggestionForAllTheNewSynonymVersions()
        {
            _Browser.AcceptNewVersionForAllSynonyms(_StepContext.TargetSynonymList);
        }
        
        [Then(@"the loading of synonym list file ""(.*)"" is completed without errors")]
        public void ThenTheLoadingOfSynonymListFileIsCompletedWithoutErrors(string synonymFileName)
        {
            if (String.IsNullOrWhiteSpace(synonymFileName)) throw new ArgumentNullException("synonymFileName");

            var synonymFilePath = Config.StaticContentFolder.AppendFileNameToDirectoryPath(synonymFileName);
            var synonymSearch   = GetCurrentContextSynonymSearch();

            _Browser.ValidateSynonymUpload(synonymFilePath, synonymSearch);
        }

        [Then(@"the contents of the uploaded ""(.*)"" and the downloaded ""(.*)"" synonym list files match")]
        public void ThenTheContentsOfTheUploadedAndTheDownloadedSynonymListFilesMatch(string uploadedFileName, string downloadedFileName)
        {
            if (String.IsNullOrWhiteSpace(uploadedFileName))   throw new ArgumentNullException("uploadedFileName");
            if (String.IsNullOrWhiteSpace(downloadedFileName)) throw new ArgumentNullException("downloadedFileName");

            var archiveSuffix             = string.Format("_Archived_{0}.txt",DateTime.Now.ToString("yyyyMMdd_HHmmss"));
            var uploadedFilePath          = Config.StaticContentFolder.AppendFileNameToDirectoryPath(uploadedFileName);
            var uploadedArchiveFilePath   = _StepContext.DownloadDirectory.AppendFileNameToDirectoryPath(uploadedFileName.Replace(".txt", archiveSuffix));

            var downloadedFilePath        = _StepContext.DownloadDirectory.AppendFileNameToDirectoryPath(downloadedFileName);
            var downloadedArchiveFilePath = downloadedFilePath.Replace(".txt", archiveSuffix);

            // Copy the uploaded file and rename the downloaded file to archive the objective evidence of the test
            File.Copy(uploadedFilePath  , uploadedArchiveFilePath  , overwrite: true);
            File.Copy(downloadedFilePath, downloadedArchiveFilePath, overwrite: true);
            File.Delete(downloadedFilePath);

            _Browser.AssertSynonymListFilesMatch(uploadedArchiveFilePath, downloadedArchiveFilePath);
        }

        [Then(@"the number of synonyms for list ""(.*)"" is ""(.*)""")]
        public void ThenTheNumberOfSynonymsForListIs(string dictionaryLocaleVersionSynonymListName, int expectedNumberOfSynonyms)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");
            if (expectedNumberOfSynonyms < 0)                                      throw new ArgumentOutOfRangeException("expectedNumberOfSynonyms");

            var synonymList                = GetSynonymList(dictionaryLocaleVersionSynonymListName);
            _StepContext.SourceSynonymList = synonymList;

            _Browser.AssertNumberOfSynonymsForListIs(synonymList, expectedNumberOfSynonyms);
        }

        [Then(@"the number of synonyms created for list ""(.*)"" is ""(.*)""")]
        public void ThenTheNumberOfSynonymsCreatedForListIs(string dictionaryLocaleVersionSynonymListName, int expectedNumberOfSynonyms)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            var synonymList = GetSynonymList(dictionaryLocaleVersionSynonymListName);

            new AdminConfigurationFunctionalitySteps(_StepContext).ConfigureDictionaryProperty(
                        dictionaryFeature: synonymList.Dictionary,
                        configurationProperty: "Auto Approve",
                        value: false);

            ThenTheNumberOfSynonymsForListIs(dictionaryLocaleVersionSynonymListName, expectedNumberOfSynonyms);
        }

        [Then(@"the synonym list ""(.*)"" can be downloaded")]
        public void ThenTheSynonymListCanBeDownloaded(string dictionaryLocaleVersionSynonymListName)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            var synonymList                = GetSynonymList(dictionaryLocaleVersionSynonymListName);
            _StepContext.SourceSynonymList = synonymList;

            _Browser.AssertSynonymListCanBeDownloaded(synonymList);
        }

        [Then(@"the synonym list ""(.*)"" cannot be downloaded")]
        public void ThenTheSynonymListCannotBeDownloaded(string dictionaryLocaleVersionSynonymListName)
        {
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            var synonymList                = GetSynonymList(dictionaryLocaleVersionSynonymListName);
            _StepContext.SourceSynonymList = synonymList;

            _Browser.AssertSynonymListCannotBeDownloaded(synonymList);
        }

        [Then(@"synonym list migration is completed with ""(.*)"" synonym and no reconciliation is needed")]
        public void ThenSynonymListMigrationIsCompletedWithSynonymAndNoReconciliationIsNeeded(string synonymCount)
        {
            if (String.IsNullOrEmpty(synonymCount))     throw new ArgumentNullException("synonymCount");

            _Browser.AssertThatSynonymDetailIsAvailableWithASynonymCount(
                synonymList:    _StepContext.TargetSynonymList, 
                synonymCount:   synonymCount); 
        }

        [Then(@"the synonym ""(.*)"" falls under the category ""(.*)"" with ""(.*)"" synonym\(s\) not migrated")]
        [Then(@"reconciliation is needed for the synonym ""(.*)"" under the category ""(.*)"" with ""(.*)"" synonym\(s\) not migrated")]
        public void ThenReconciliationIsNeededForTheSynonymForTheCategoryWithANotMigratedCountOf(
            string synonymName,
            string categoryType,
            string notMigratedCount)
        {
            if (String.IsNullOrEmpty(synonymName))      throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))     throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(notMigratedCount)) throw new ArgumentNullException("notMigratedCount");

            _Browser.AssertThatSynonymFallsUnderCategoryWithANotMigratedSynonymCount(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                synonymName:            synonymName, 
                categoryType:           categoryType, 
                notMigratedCount:       notMigratedCount);
        }

        [Then(@"the synonym ""(.*)"" falls under the category ""(.*)"" with ""(.*)"" synonym\(s\) declined")]
        [Then(@"reconciliation is needed for the synonym ""(.*)"" under the category ""(.*)"" with ""(.*)"" synonym\(s\) declined")]
        public void ThenReconciliationIsNeededForTheSynonymForTheCategoryWithADeclinedMigratedCountOf(
            string synonymName, 
            string categoryType, 
            string declinedMigratedCount)
        {
            if (String.IsNullOrEmpty(synonymName))              throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))             throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(declinedMigratedCount))    throw new ArgumentNullException("declinedMigratedCount");

            _Browser.AssertThatSynonymFallsUnderCategoryWithADeclinedMigratedSynonymCount(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                synonymName:            synonymName, 
                categoryType:           categoryType, 
                declinedMigratedCount:  declinedMigratedCount);
        }

        [Then(@"the synonym ""(.*)"" falls under the category ""(.*)"" with ""(.*)"" synonym\(s\) migrated")]
        public void ThenIVerifyTheSynonymFallsUnderWithAMigratedCountOf(
            string synonymName,
            string categoryType,
            string migratedCount)
        {
            if (String.IsNullOrEmpty(synonymName))              throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))             throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(migratedCount))            throw new ArgumentNullException("migratedCount");

            _Browser.AssertThatSynonymFallsUnderCategoryWithAMigratedSynonymCount(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                synonymName:            synonymName, 
                categoryType:           categoryType, 
                migratedCount:          migratedCount);
        }

        [Then(@"the synonym ""(.*)"" with code ""(.*)"" exists after synonym migration is completed")]
        public void ThenTheSynonymExistsAfterSynonymMigrationIsCompleted(string synonymName, string code)
        {
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(code))        throw new ArgumentNullException("code");

            var synonymList   = _StepContext.TargetSynonymList;
            var synonymSearch = new SynonymSearch
            {
                Dictionary = synonymList.Dictionary,
                Locale     = synonymList.Locale,
                Version    = synonymList.Version,
                SearchText = synonymName,
                Code       = code
            };

            _Browser.AssertSynonymStatus(synonymSearch, synonymShouldExist:true);
        }

        [Then(@"the synonym ""(.*)"" does not exist after synonym migration is completed")]
        public void ThenTheSynonymDoesNotExistAfterSynonymMigrationIsCompleted(string synonymName)
        {
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            var synonymList   = _StepContext.TargetSynonymList;
            var synonymSearch = new SynonymSearch
            {
                Dictionary = synonymList.Dictionary,
                Locale     = synonymList.Locale,
                Version    = synonymList.Version,
                SearchText = synonymName
            };

            _Browser.AssertSynonymStatus(synonymSearch, synonymShouldExist: false);
        }

        [Then(@"all synonyms are ready for migration")]
        public void ThenAllSynonymsExistInMigratedCount()
        {
            _Browser.AssertThatAllSynonymsAreAvailableForMigration(_StepContext.TargetSynonymList);
        }

        [Then(@"the No Match synonym ""(.*)"" has no suggested term data present")]
        public void ThenIVerifyTheNoMatchSynonymHasNoSuggestedTermDataPresent(string synonymName)
        {
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            _Browser.AssertThatNoMatchSynonymHasNoSuggestedTermDataPresent(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                synonymName:            synonymName);
        }

        [Then(@"the synonym ""(.*)"" under the category ""(.*)"" has a line difference for each changed level in the Prior Term and Upgraded Term Path")]
        public void ThenTheSynonymUnderTheCategoryHasALineDifferenceForEachChangedLevelInThePriorTermAndUpgradedTermPath(
            string synonymName, 
            string categoryType)
        {
            if (String.IsNullOrEmpty(synonymName))      throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))     throw new ArgumentNullException("categoryType");

            _Browser.AssertThatTheSynonymHasALineDifferenceForEachChangedLevelInThePriorTermPathAndUpgradedTermPath(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                synonymName:            synonymName, 
                categoryType:           categoryType);
        }

        [Then(@"the synonym ""(.*)"" under the category ""(.*)"" has a line difference for each changed level in the Prior Term and Suggested Term Path")]
        public void ThenTheSynonymUnderTheCategoryHasALineDifferenceForEachChangedLevelInThePriorTermAndSuggestedTermPath(
            string synonymName, 
            string categoryType)
        {
            if (String.IsNullOrEmpty(synonymName))      throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))     throw new ArgumentNullException("categoryType");

            _Browser.AssertThatTheSynonymHasALineDifferenceForEachChangedLevelInThePriorTermPathAndSuggestedTermPath(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                synonymName:            synonymName, 
                categoryType:           categoryType);
        }

        [Then(@"the single path synonym ""(.*)"" under the category ""(.*)"" is ready for migration")]
        public void ThenTheSinglePathSynonymExistsInMigratedCountUnderTheCategory(
            string synonymName, 
            string categoryType)
        {
            if (String.IsNullOrEmpty(synonymName))      throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))     throw new ArgumentNullException("categoryType");

            _Browser.AssertThatTheSinglePathSynonymExistInMigratedCountWithOneDetailedSuggestion(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                synonymName:            synonymName, 
                categoryType:           categoryType);
        }

        [Then(@"the non-single path synonym ""(.*)"" under the category ""(.*)"" is not ready for migration")]
        public void ThenTheNon_SinglePathSynonymExistsInNotMigratedCountUnderTheCategory(
            string synonymName, 
            string categoryType)
        {
            if (String.IsNullOrEmpty(synonymName))      throw new ArgumentNullException("synonymName");
            if (String.IsNullOrEmpty(categoryType))     throw new ArgumentNullException("categoryType");

            _Browser.AssertThatTheNonSinglePathSynonymExistInNotMigratedCountWithMultipleDetailedSuggestion(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                synonymName:            synonymName, 
                categoryType:           categoryType);
        }

        [Then(@"the synonyms fall under the category ""(.*)"" with ""(.*)"" synonym\(s\) migrated")]
        public void ThenIVerifyTheSynonymsFallsUnderWithAMigratedCountOf(
            string categoryType, 
            string migratedCount)
        {
            if (String.IsNullOrEmpty(categoryType))     throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(migratedCount))    throw new ArgumentNullException("migratedCount");

            _Browser.AssertThatSynonymsExistsInMigratedCountForTheCategory(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                categoryType:           categoryType, 
                migratedCount:          migratedCount);
        }

        [Then(@"the synonyms fall under the category ""(.*)"" with ""(.*)"" synonym\(s\) declined")]
        public void ThenIVerifyTheSynonymsFallsUnderWithADeclinedMigratedCountOf(
            string categoryType, 
            string declinedMigratedCount)
        {
            if (String.IsNullOrEmpty(categoryType))             throw new ArgumentNullException("categoryType");
            if (String.IsNullOrEmpty(declinedMigratedCount))    throw new ArgumentNullException("declinedMigratedCount");

            _Browser.AssertThatSynonymsExistsInDeclinedMigratedCountForTheCategory(
                targetSynonymList:      _StepContext.TargetSynonymList, 
                categoryType:           categoryType, 
                declinedMigratedCount:  declinedMigratedCount);
        }

        [When(@"the synonym for verbatim ""(.*)"" and code ""(.*)"" is approved")]
        public void WhenTheSynonymForVerbatimAndCodeIsApproved(string verbatim, string code)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(code))     throw new ArgumentNullException("code");

            var synonymSearch        = GetCurrentContextSynonymSearch();
            synonymSearch.SearchText = verbatim;
            synonymSearch.Code       = code;

            _Browser.ApproveSynonym(synonymSearch);
        }

        [When(@"the synonym for verbatim ""(.*)"" and code ""(.*)"" is retired")]
        public void WhenTheSynonymForVerbatimAndCodeIsRetired(string verbatim, string code)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(code))     throw new ArgumentNullException("code");

            var synonymSearch        = GetCurrentContextSynonymSearch();
            synonymSearch.SearchText = verbatim;
            synonymSearch.Code       = code;

            _Browser.RetireSynonym(synonymSearch);
        }
        
        [When(@"the provisional synonym for verbatim term ""(.*)"" is retired from the Synonym Approval page")]
        public void WhenTheProvisionalSynonymForVerbatimTermIsRetiredFromTheSynonymApprovalPage(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");

            var synonymSearch = GetCurrentContextSynonymSearch();
            synonymSearch.SearchText = verbatim;

            _Browser.RetireSynonym(synonymSearch, useSynonymApprovalPage: true);
        }

        [When(@"the provisional synonym for verbatim term ""(.*)"" is retired from the Synonym Details page")]
        public void WhenTheProvisionalSynonymForVerbatimTermIsRetiredFromTheSynonymDetailsPage(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");

            var synonymSearch = GetCurrentContextSynonymSearch();
            synonymSearch.SearchText = verbatim;

            _Browser.RetireSynonym(synonymSearch, useSynonymApprovalPage: false);
        }
        
        [Then(@"the synonym for verbatim ""(.*)"" and code ""(.*)"" should be active")]
        public void ThenTheSynonymForVerbatimAndCodeShouldBeActive(string verbatimFeature, string code)
        {
            if (String.IsNullOrWhiteSpace(verbatimFeature)) throw new ArgumentNullException("verbatimFeature");
            if (String.IsNullOrWhiteSpace(code))            throw new ArgumentNullException("code");

            var verbatim = StepArgumentTransformations.TransformFeatureString(verbatimFeature, _StepContext);

            var synonymSearch              = GetCurrentContextSynonymSearch();
            synonymSearch.SearchText       = verbatim;
            synonymSearch.Code             = code;

            var synonym = _Browser.GetSynonymDetailRow(synonymSearch);

            if (ReferenceEquals(synonym, null))
            {
                throw new AssertionFailedException(String.Format("Synonym with verbatim {0} and code {1} not found", verbatim, code));
            }

            synonym.Status.ShouldBeEquivalentTo(SynonymStatus.Approved);
            
            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"the synonym for verbatim ""(.*)"" and code ""(.*)"" should not exist")]
        public void ThenTheSynonymForVerbatimAndCodeShouldNotExist(string verbatim, string code)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(code)) throw new ArgumentNullException("code");

            var synonymSearch        = GetCurrentContextSynonymSearch();
            synonymSearch.SearchText = verbatim;
            synonymSearch.Code       = code;

            _Browser.AssertSynonymStatus(synonymSearch, synonymShouldExist: false);
        }

        [Then(@"the synonym for verbatim ""(.*)"" and code ""(.*)"" should be active for list ""(.*)""")]
        public void ThenTheSynonymForVerbatimAndCodeShouldBeActiveForList(string verbatim, string code,
            string dictionaryLocaleVersionSynonymListName)
        {
            if (String.IsNullOrWhiteSpace(verbatim))                               throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(code))                                   throw new ArgumentNullException("code");
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            var synonymList = GetSynonymList(dictionaryLocaleVersionSynonymListName);

            _StepContext.SourceSynonymList = synonymList;

            ThenTheSynonymForVerbatimAndCodeShouldBeActive(verbatim, code);
        }

        // This verification step should be used when verifying multiple synonyms. The assertions can potentially modify
        // the test configuration. Multiple single line verification steps may be invalid after the first step executes.       

        [Then(@"synonyms for verbatim terms should be created and exist in lists")]
        public void ThenSynonymsForVerbatimTermsShouldBeCreatedAndExistInLists(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var synonymExistsDetails = table.TransformFeatureTableStrings(_StepContext).CreateSet<SynonymExistsDetail>().ToArray();

            AssertSynonymCreatedAndExists(synonymExistsDetails);
        }
        
        [Then(@"a synonym for verbatim term ""(.*)"" should be created and exist in list ""(.*)""")]
        public void ThenASynonymForVerbatimTermShouldBeCreatedAndExistInList(string verbatim, string dictionaryLocaleVersionSynonymListName)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            AssertSynonymCreatedAndExists( verbatim,  dictionaryLocaleVersionSynonymListName, exists: true);
        }

        [Then(@"a synonym for verbatim term ""(.*)"" should be created and not exist in list ""(.*)""")]
        public void ThenASynonymForVerbatimTermShouldBeCreatedAndNotExistInList(string verbatim, string dictionaryLocaleVersionSynonymListName)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            AssertSynonymCreatedAndExists( verbatim,  dictionaryLocaleVersionSynonymListName, exists: false);
        }

        [Then(@"the reconsider dialog displays ""(.*)"" completed and ""(.*)"" in progress coding decisions when retiring the provisional synonym for verbatim term ""(.*)""")]
        public void ThenTheReconsiderDialogDisplaysCompletedAndInProgressCodingDecisionsWhenRetiringTheProvisionalSynonymForVerbatimTerm(
            int expectedCompletedTasksCount, 
            int expectedInProgressTasksCount, 
            string verbatim)
        {
            if (expectedCompletedTasksCount < 0)    throw new ArgumentOutOfRangeException("expectedCompletedTasksCount");
            if (expectedInProgressTasksCount < 0)   throw new ArgumentOutOfRangeException("expectedInProgressTasksCount");
            if (String.IsNullOrEmpty(verbatim))     throw new ArgumentNullException("verbatim");

            var synonymSearch = GetCurrentContextSynonymSearch();
            synonymSearch.SearchText = verbatim;

            _Browser.AssertCountOfReconsiderTasksAffectedByRetiringSynonymsAre(synonymSearch, expectedCompletedTasksCount, expectedInProgressTasksCount);
        }

        private void AssertSynonymCreatedAndExists(string verbatim, string dictionaryLocaleVersionSynonymListName, bool exists)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            var synonymExistsDetail = new SynonymExistsDetail()
            {
                DictionaryLocaleVersionSynonymListName = dictionaryLocaleVersionSynonymListName,
                Verbatim = verbatim,
                Exists   = exists
            };

            AssertSynonymCreatedAndExists(new SynonymExistsDetail[] { synonymExistsDetail });
        }

        private void AssertSynonymCreatedAndExists(SynonymExistsDetail[] synonymExistsDetails)
        {
            // Verify the existence of the synonyms first, keeping the tests configuration settings.
            foreach (SynonymExistsDetail synonymExistsDetail in synonymExistsDetails)
            {
                var synonymList = GetSynonymList(synonymExistsDetail.DictionaryLocaleVersionSynonymListName);

                var synonymSearch = new SynonymSearch
                {
                    Dictionary = synonymList.Dictionary,
                    Locale     = synonymList.Locale,
                    Version    = synonymList.Version,
                    SearchText = synonymExistsDetail.Verbatim
                };

                _Browser.AssertSynonymStatus(synonymSearch, synonymShouldExist: synonymExistsDetail.Exists);
            }

            // Disabling the auto approve setting for the dictionaries will cause the synonyms to exist in the list, allowing for verification that the synonyms were created.
            // This is only necessary if the synonyms were hidden and will be skipped if they existed during the existence check
            foreach (SynonymExistsDetail synonymExistsDetail in synonymExistsDetails)
            {
                if (synonymExistsDetail.Exists == false)
                {
                    var synonymList = GetSynonymList(synonymExistsDetail.DictionaryLocaleVersionSynonymListName);

                    var synonymSearch = new SynonymSearch
                    {
                        Dictionary = synonymList.Dictionary,
                        Locale     = synonymList.Locale,
                        Version    = synonymList.Version,
                        SearchText = synonymExistsDetail.Verbatim
                    };

                    new AdminConfigurationFunctionalitySteps(_StepContext).ConfigureDictionaryProperty(
                        synonymSearch.Dictionary,
                        "Auto Approve",
                        false);

                    _Browser.AssertSynonymStatus(synonymSearch, synonymShouldExist:true);
                }
            }
        }

        [When(@"the ""(.*)"" provisional synonyms are filtered by term ""(.*)""")]
        public void WhenTheProvisionalSynonymsAreFilteredByTerm(int expectedSynonymCount, string term)
        {
            if (expectedSynonymCount < 0)        throw new ArgumentOutOfRangeException("expectedSynonymCount");
            if (String.IsNullOrWhiteSpace(term)) throw new ArgumentNullException("term");

            var synonymSearch        = GetCurrentContextSynonymSearch();
            synonymSearch.SearchText = term;
            _ProvisionalSynonyms     = _Browser.GetFilteredProvisionalSynonyms(synonymSearch, expectedSynonymCount);
        }

        [When(@"the ""(.*)"" provisional synonyms are requested")]
        public void WhenTheProvisionalSynonymsAreRequested(int expectedSynonymCount)
        {
            if (expectedSynonymCount < 0) throw new ArgumentOutOfRangeException("expectedSynonymCount");

            var synonymSearch = GetCurrentContextSynonymSearch();

            _ProvisionalSynonyms = _Browser.GetAllProvisionalSynonyms(synonymSearch, expectedSynonymCount);
        }
        
        [When(@"the time elapsed since synonym ""(.*)"" was created is ""(.*)"" days")]
        public void WhenTheTimeElapsedSinceSynonymWasCreatedIsDays(string verbatim, int days)
        {
            if (String.IsNullOrEmpty(verbatim))             throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(_StepContext.Segment)) throw new ArgumentNullException("_StepContext.Segment");

            int hoursToAge = (days * 24);

            CoderDatabaseAccess.AgeSynonym(_StepContext.Segment, verbatim, hoursToAge, ageCreatedOnly:true);
        }

        [When(@"the time elapsed since synonym ""(.*)"" was updated is ""(.*)"" days")]
        public void WhenTheTimeElapsedSinceSynonymWasUpdatedIsDays(string verbatim, int days)
        {
            if (String.IsNullOrEmpty(verbatim))             throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(_StepContext.Segment)) throw new ArgumentNullException("_StepContext.Segment");

            int hoursToAge = (days * 24);

            CoderDatabaseAccess.AgeSynonym(_StepContext.Segment, verbatim, hoursToAge, ageCreatedOnly: false);
        }

        [Then(@"all provisional synonyms should be for a verbatim that contains ""(.*)""")]
        public void ThenAllProvisionalSynonymsShouldBeForAVerbatimThatContains(string term)
        {
            if (String.IsNullOrEmpty(term)) throw new ArgumentNullException("term");

            _ProvisionalSynonyms.Should().NotBeNull();

            foreach (var synonym in _ProvisionalSynonyms)
            {
                synonym.Verbatim.Contains(term, StringComparison.OrdinalIgnoreCase).Should().BeTrue();
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"each provisional synonym should be unique across all sets")]
        public void ThenEachProvisionalSynonymShouldBeUniqueAcrossAllSets()
        {
            _ProvisionalSynonyms.Should().NotBeNull();

            foreach (var synonymRow in _ProvisionalSynonyms)
            {
                _ProvisionalSynonyms.Should().ContainSingle(
                        x => x.Equals(synonymRow),
                        String.Format("Verbatim {0} and code {1} should be unique", 
                            synonymRow.Verbatim, 
                            synonymRow.SelectedTermPathRow.Code));
            }
        }

        [Then(@"the following synonym terms require approval")]
        public void ThenTheFollowingSynonymTermsRequireApproval(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var expectedSynonymTerms =
                table.TransformFeatureTableStrings(_StepContext).CreateSet<SynonymRow>().ToArray();
            var expectedSynonymTermsCount = expectedSynonymTerms.Count();
            var synonymSearch = GetCurrentContextSynonymSearch();
            var provisionalSynonyms = _Browser.GetAllProvisionalSynonyms(synonymSearch,
                expectedSynonymCount: expectedSynonymTermsCount);

            expectedSynonymTermsCount.ShouldBeEquivalentTo(provisionalSynonyms.Length);

            for (int synonymIndex = 0; synonymIndex < expectedSynonymTermsCount; synonymIndex++)
            {
                expectedSynonymTerms[synonymIndex].Verbatim.Should()
                    .BeEquivalentTo(provisionalSynonyms[synonymIndex].Verbatim);
            }

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);

        }

        [Then(@"the synonym ""(.*)"" requires approval after synonym migration is completed")]
        public void ThenTheSynonymRequiresApprovalAfterSynonymMigrationIsCompleted(string synonymName)
        {
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            var synonymSearch = GetSynonymSearchAfterSynonymMigration(synonymName);

            var provisionalSynonyms   = _Browser.GetFilteredProvisionalSynonyms(synonymSearch, 1);

            provisionalSynonyms.Length.Should().Be(1);
            provisionalSynonyms[0].Verbatim.Should().Be(synonymName);
            provisionalSynonyms[0].ListName.Should().Contain(synonymSearch.SynonymList);
            provisionalSynonyms[0].ListName.Should().Contain(synonymSearch.Version);
            
            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        [Then(@"no synonym terms require approval")]
        public void ThenNoSynonymTermsRequireApproval()
        {
            _Browser.AssertThatSynonymApprovalListIsEmpty();
        }

        [Then(@"the master path for synonym ""(.*)"" after synonym migration is completed is")]
        public void ThenTheMasterPathForSynonymAfterSynonymMigrationIsCompletedIs(string synonymName, Table table)
        {
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");
            if (ReferenceEquals(table, null))      throw new ArgumentNullException("table"); 

            var expectedMasterPath   = table.TransformFeatureTableStrings(_StepContext).CreateSet<TermPathRow>().ToList();

            var synonymSearch        = GetSynonymSearchAfterSynonymMigration(synonymName);

            var provisionalSynonyms  = _Browser.GetFilteredProvisionalSynonyms(synonymSearch, 1);

            provisionalSynonyms.Length.Should().Be(1);

            var expandedTermPathRows = provisionalSynonyms[0].ExpandedTermPathRows.ToList();

            expectedMasterPath.Should().BeEquivalentTo(expandedTermPathRows);

            _Browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
        
        [Then(@"the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by study ""(.*)""")]
        public void ThenTheSynonymsForApprovalAreLimitedToThoseSynonymsThatMeetTheFilterCriteriaWhenFilteredByStudy(string study, Table table)
        {
            if (String.IsNullOrEmpty(study))  throw new ArgumentNullException("study");
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var synonymSearch = new SynonymSearch
            {
                Study = study
            };

            var expectedSynonymsDetails = table.TransformFeatureTableStrings(_StepContext).CreateSet<SynonymRow>().ToList();

            var actualSynonymsDetails   = _Browser.GetFilteredProvisionalSynonyms(synonymSearch).ToList();

            _Browser.AssertSynonymApprovalsFilteredByStudy(actualSynonymsDetails, expectedSynonymsDetails);
        }
        
        [Then(@"the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by dictionary ""(.*)""")]
        public void ThenTheSynonymsForApprovalAreLimitedToThoseSynonymsThatMeetTheFilterCriteriaWhenFilteredByDictionary(string dictionaryAndLocale, Table table)
        {
            if (String.IsNullOrEmpty(dictionaryAndLocale)) throw new ArgumentNullException("dictionaryAndLocale");
            if (ReferenceEquals(table, null))              throw new ArgumentNullException("table");

            var synonymSearch = new SynonymSearch
            {
                Dictionary = dictionaryAndLocale
            };

            var actualSynonymsDetails = _Browser.GetFilteredProvisionalSynonyms(synonymSearch).ToList();

            var expectedSynonymsDetails = table.TransformFeatureTableStrings(_StepContext).CreateSet<SynonymRow>().ToList();
            
            _Browser.AssertSynonymApprovalsFilteredByDictionary(actualSynonymsDetails, expectedSynonymsDetails);
        }
        
        [Then(@"the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by synonym list ""(.*)""")]
        public void ThenTheSynonymsForApprovalAreLimitedToThoseSynonymsThatMeetTheFilterCriteriaWhenFilteredBySynonymList(string synonymList, Table table)
        {
            if (String.IsNullOrEmpty(synonymList)) throw new ArgumentNullException("synonymList");
            if (ReferenceEquals(table, null))      throw new ArgumentNullException("table");

            var synonymSearch = new SynonymSearch
            {
                SynonymList = synonymList
            };

            var expectedSynonymsDetails = table.TransformFeatureTableStrings(_StepContext).CreateSet<SynonymRow>().ToList();

            var actualSynonymsDetails   = _Browser.GetFilteredProvisionalSynonyms(synonymSearch).ToList();

            _Browser.AssertSynonymApprovalsFilteredBySynonymList(actualSynonymsDetails, expectedSynonymsDetails);
        }
        
        [Then(@"the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by date range")]
        public void ThenTheSynonymsForApprovalAreLimitedToThoseSynonymsThatMeetTheFilterCriteriaWhenFilteredByDateRange(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");
            if (!table.ContainsColumn("DateRange") || !table.ContainsColumn("ExpectedVerbatims"))
            {
                throw new ArgumentException(
                    "Task additional information table requires two columns named 'DateRange' and 'ExpectedVerbatims'.");
            }

            foreach (TableRow tableRow in table.Rows)
            {
                var synonymSearch = new SynonymSearch
                {
                    DateRange = tableRow["DateRange"]
                };

                var expectedVerbatims      = SplitExpectedVerbatims(tableRow["ExpectedVerbatims"]);

                var actualSynonymsDetails  = _Browser.GetFilteredProvisionalSynonyms(synonymSearch).ToList();
                
                _Browser.AssertSynonymApprovalsFilteredByDateRange(synonymSearch.DateRange, actualSynonymsDetails, expectedVerbatims);
            }
        }

        [Then(@"the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by search text")]
        public void ThenTheSynonymsForApprovalAreLimitedToThoseSynonymsThatMeetTheFilterCriteriaWhenFilteredBySearchText(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");
            if (!table.ContainsColumn("SearchText") || !table.ContainsColumn("ExpectedVerbatims"))
            {
                throw new ArgumentException(
                    "Task additional information table requires two columns named 'SearchText' and 'ExpectedVerbatims'.");
            }

            foreach (TableRow tableRow in table.Rows)
            {
                var synonymSearch = new SynonymSearch
                {
                    SearchText        = tableRow["SearchText"],
                    AllowOrTextSearch = true
                };

                var expectedVerbatims     = SplitExpectedVerbatims(tableRow["ExpectedVerbatims"]);

                var actualSynonymsDetails = _Browser.GetFilteredProvisionalSynonyms(synonymSearch).ToList();
                
                var actualVerbatims       = actualSynonymsDetails.Select(x => x.Verbatim).ToList();

                _Browser.AssertVerbatimsAreEquivalent(actualVerbatims, expectedVerbatims);
            }
        }

        [Then(@"the synonym details are limited to those synonyms that meet the filter criteria when filtered by status")]
        public void ThenTheSynonymDetailsAreLimitedToThoseSynonymsThatMeetTheFilterCriteriaWhenFilteredByStatus(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");
            if (!table.ContainsColumn("Status") || 
                !table.ContainsColumn("SearchText") || 
                !table.ContainsColumn("ExpectedVerbatim") ||
                !table.ContainsColumn("ExpectedStatus"))
            {
                throw new ArgumentException(
                    "Task additional information table requires four columns named 'Status', 'SearchText', 'ExpectedVerbatim', and 'ExpectedStatus'.");
            }

            foreach (TableRow tableRow in table.Rows)
            {
                var synonymSearch               = GetCurrentContextSynonymSearch();
                synonymSearch.Status            = tableRow["Status"];
                synonymSearch.SearchText        = tableRow["SearchText"];
                synonymSearch.AllowOrTextSearch = true;

                var actualSynonymsDetails = _Browser.GetSynonymsDetails(synonymSearch);

                _Browser.AssertSynonymDetailsFilteredByStatus(actualSynonymsDetails, tableRow["ExpectedVerbatim"], tableRow["ExpectedStatus"]);
            }
        }

        [Then(@"the synonym details are limited to those synonyms that meet the filter criteria when filtered by search text")]
        public void ThenTheSynonymDetailsAreLimitedToThoseSynonymsThatMeetTheFilterCriteriaWhenFilteredBySearchText(Table table)
        {

            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");
            if (!table.ContainsColumn("SearchBy") ||
                !table.ContainsColumn("SearchText") ||
                !table.ContainsColumn("ExpectedVerbatims"))
            {
                throw new ArgumentException(
                    "Task additional information table requires three columns named 'SearchBy', 'SearchText', and 'ExpectedVerbatims'.");
            }

            foreach (TableRow tableRow in table.Rows)
            {
                var synonymSearch               = GetCurrentContextSynonymSearch();
                synonymSearch.SearchBy          = tableRow["SearchBy"];
                synonymSearch.SearchText        = tableRow["SearchText"];
                synonymSearch.AllowOrTextSearch = true;

                var actualSynonymsDetails = _Browser.GetSynonymsDetails(synonymSearch);

                var actualVerbatims       = actualSynonymsDetails.Select(x => x.Verbatim).ToList();

                var expectedVerbatims     = SplitExpectedVerbatims(tableRow["ExpectedVerbatims"]);

                _Browser.AssertVerbatimsAreEquivalent(actualVerbatims, expectedVerbatims);
            }
        }

        private IList<string> SplitExpectedVerbatims(string expectedVerbatims)
        {
            var splitExpectedVerbatims   =  expectedVerbatims.Split(',').ToList();
            var trimmedExpectedVerbatims = splitExpectedVerbatims.Select(x => x.Trim()).ToList();
            return trimmedExpectedVerbatims;
        }

        private SynonymList GetSynonymList(string dictionaryLocaleVersionSynonymListName)
        {
            if (String.IsNullOrEmpty(dictionaryLocaleVersionSynonymListName)) throw new ArgumentNullException("dictionaryLocaleVersionSynonymListName");

            var synonymListValues   = dictionaryLocaleVersionSynonymListName.Split(' ');

            var synonymList         = new SynonymList
            {
                Dictionary          = synonymListValues[0].Trim(),
                Locale              = synonymListValues[1].Trim(),
                Version             = synonymListValues[2].Trim(),
                SynonymListName     = synonymListValues[3].Trim()
            };

            _StepContext.Dictionary = synonymList.Dictionary;
            _StepContext.Locale     = synonymList.Locale;
            _StepContext.Version    = synonymList.Version;

            return synonymList;
        }

        private SynonymList GetSynonymListFromContext()
        {
            var synonymList = new SynonymList
            {
                Dictionary = _StepContext.Dictionary,
                Locale = _StepContext.Locale,
                Version = _StepContext.Version,
                SynonymListName = Config.DefaultSynonymListName
            };

            return synonymList;
        }
        
        private SynonymSearch GetCurrentContextSynonymSearch()
        {
            var synonymSearch = new SynonymSearch
            {
                Study       = _StepContext.Project,
                Dictionary  = _StepContext.Dictionary,
                Locale      = _StepContext.Locale,
                Version     = _StepContext.Version
            };

            if (!ReferenceEquals(_StepContext.SourceSynonymList, null))
            {
                synonymSearch.SynonymList = _StepContext.SourceSynonymList.SynonymListName;
            }

            return synonymSearch;
        }

        private SynonymSearch GetSynonymSearchAfterSynonymMigration(string synonymName)
        {
            if (String.IsNullOrEmpty(synonymName)) throw new ArgumentNullException("synonymName");

            var synonymList = _StepContext.TargetSynonymList;
            var synonymSearch = new SynonymSearch
            {
                Dictionary = synonymList.Dictionary,
                Locale = synonymList.Locale,
                Version = synonymList.Version,
                SynonymList = synonymList.SynonymListName,
                SearchText = synonymName
            };

            return synonymSearch;
        }

        private class SynonymExistsDetail
        {
            public string DictionaryLocaleVersionSynonymListName { get; set; }
            public string Verbatim                               { get; set; }
            public bool   Exists                                 { get; set; }
        }
    }
}
