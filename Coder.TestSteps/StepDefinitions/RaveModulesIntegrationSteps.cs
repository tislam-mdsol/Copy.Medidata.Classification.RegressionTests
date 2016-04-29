//@author:smalik
using System;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.Models;
using TechTalk.SpecFlow;
using System.IO;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class RaveModulesIntegrationSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext _StepContext;
        
        public RaveModulesIntegrationSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext     =  stepContext;
            _Browser         =  _StepContext.Browser;
        }

        [Given("a configuration file to be uploaded in Rave Modules")]
        public void GivenAConfigurationFileToBeUploadedInRaveModules()
        {    
            _Browser.GetAccessToConfigModule(_StepContext.User);    
        }

        [Given(@"a new user ""(.*)"" that needs to be assigned roles")]
        public void GivenANewUserThatNeedsToBeAssignedRoles(String userName)
        {
            if (ReferenceEquals(userName, null)) throw new ArgumentNullException("userName");

            _Browser.AssignUserToStudyAndStudyGroup(userName);
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
    }
}
