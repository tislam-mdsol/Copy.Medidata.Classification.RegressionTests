using System;
using System.Linq;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.TestSteps.Transformations;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class ProjectRegistrationSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext             _StepContext;

        public ProjectRegistrationSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))     throw new NullReferenceException("Browser");

            _StepContext    = stepContext;
            _Browser        = _StepContext.Browser;

        }

        [Given(@"a ""(.*)"" Coder setup with no tasks and no synonyms and dictionary ""(.*)"" unregistered")]
        public void GivenACoderSetupWithNoTasksAndNoSynonymsAndDictionaryUnregistered(string setupType, string dictionaryLocaleVersion)
        {
            if (String.IsNullOrWhiteSpace(setupType))               throw new ArgumentNullException("setupType");
            if (String.IsNullOrWhiteSpace(dictionaryLocaleVersion)) throw new ArgumentNullException("dictionaryLocaleVersion");

            _StepContext.SetProjectRegistrationContext(dictionaryLocaleVersion);
            _StepContext.SetSourceSystemApplicationContext();

            _Browser.SetupCoderConfiguration(_StepContext, setupType);

            _StepContext.SetupType = setupType;

            _Browser.CleanUpCodingTasks();

            CoderDatabaseAccess.CreateAndActivateSynonymList(
               segment:           _StepContext.Segment,
               dictionary:        _StepContext.Dictionary,
               dictionaryVersion: _StepContext.Version,
               locale:            _StepContext.Locale,
               synonymListName:   Config.DefaultSynonymListName);

        }

        [Given(@"a ""(.*)"" Coder setup with no tasks and no synonyms and unregistered dictionaries")]
        public void GivenACoderSetupWithNoTasksAndNoSynonymsAndUnregisteredDictionaries(string setupType, Table table)
        {
            if (String.IsNullOrWhiteSpace(setupType)) throw new ArgumentNullException("setupType");
            if (ReferenceEquals(table,null))          throw new ArgumentNullException("table");

            var list                    = table.TransformFeatureTableStrings(_StepContext).CreateSet<SynonymList>().ToArray();
            var defaultDic              = list.First();
            var dictionaryLocaleVersion = defaultDic.Dictionary + " " + defaultDic.Locale + " " + defaultDic.Version;

            _StepContext.SetProjectRegistrationContext(dictionaryLocaleVersion);
            _StepContext.SetSourceSystemApplicationContext();
            _Browser.SetupCoderConfiguration(_StepContext, setupType);
            _StepContext.SetupType = setupType;
            _Browser.CleanUpCodingTasks();

            foreach (var synonymList in list)
            {
                CoderDatabaseAccess.CreateAndActivateSynonymList(
                segment:           _StepContext.Segment,
                dictionary:        synonymList.Dictionary,
                dictionaryVersion: synonymList.Version,
                locale:            synonymList.Locale,
                synonymListName:   synonymList.SynonymListName
                );
            }
        }

        [When(@"registering a project with the following options")]
        public void WhenRegisteringAProjectWithTheFollowingOptions(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var list = table.TransformFeatureTableStrings(_StepContext).CreateSet<SynonymList>().ToArray();
            _Browser.RegisterProjects(_StepContext.Project,list);
        }

        [Then(@"the following content should be registered")]
        public void ThenTheFollowingContentShouldBeRegistered(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var list = table.TransformFeatureTableStrings(_StepContext).CreateSet<SynonymList>().ToArray();

            _Browser.AssertThatProjectsAreRegistered(list);
        }

        [Then(@"all studies for Project are registered and MEV content is loaded")]
        public void ThenAllStudiesForProjectAreRegisteredAndMevContentIsLoaded(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var list = table.CreateSet<SourceTerm>().ToArray();
            
            _Browser.AssertThatAllStudiesForProjectAreRegisteredAndMevContentIsLoaded(_StepContext.Project,list);
        }

        [Then(@"Registration History contains following information")]
        public void ThenRegistrationHistoryContainsFollowingInformation(Table table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var list = table.TransformFeatureTableStrings(_StepContext).CreateSet<ProjectRegistrationHistory>().ToArray();

            _Browser.AssertThatRegistrationHistoryContainsFollowingInformation(list,Config.TimeStampHoursDiff);

        }
    }
}
