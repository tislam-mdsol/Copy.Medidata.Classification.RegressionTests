using System;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
using Coder.DeclarativeBrowser.Models;
using TechTalk.SpecFlow;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class HelpLinkSteps
    {
        private readonly CoderDeclarativeBrowser    _Browser;
        private readonly StepContext                _StepContext;

        public HelpLinkSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser     = _StepContext.Browser;
        }

        [When(@"accessing help center content ""(.*)"" for Tasks")]
        public void WhenAccessingHelpCenterContentForTasks(string helpLink)
        {
            if (String.IsNullOrEmpty(helpLink)) throw new ArgumentNullException("helpLink");

            _Browser.AccessTasksHelpContent(
                helpLinkName: helpLink);

            _Browser.LoginToHelpCenter();
        }

        [When(@"accessing help center content ""(.*)"" for ""(.*)""")]
        public void WhenAccessingHelpCenterContentFor(string helpLink, string pageName)
        {
            if (String.IsNullOrEmpty(helpLink)) throw new ArgumentNullException("helpLink");
            if (String.IsNullOrEmpty(pageName)) throw new ArgumentNullException("pageName");

            _Browser.AccessAdminHelpContent(
                pageName    : pageName,
                helpLinkName: helpLink);

            _Browser.LoginToHelpCenter();
        }

        [When(@"accessing help center content ""(.*)"" for ""(.*)"" report")]
        public void WhenAccessingHelpCenterContentForReport(string helpLink, string pageName)
        {
            if (String.IsNullOrEmpty(helpLink)) throw new ArgumentNullException("helpLink");
            if (String.IsNullOrEmpty(pageName)) throw new ArgumentNullException("pageName");

             _Browser.AccessReportHelpContent(
                pageName    : pageName,
                helpLinkName: helpLink);

            _Browser.LoginToHelpCenter();
        }

        [When(@"acessing help content ""(.*)"" for Tasks")]
        public void WhenISelectTasksPageLink(string helpLink)
        {
            if (String.IsNullOrEmpty(helpLink)) throw new ArgumentNullException("helpLink");

            _Browser.AccessTasksHelpContent(
                helpLinkName: helpLink);

            //TODO: verify E Learning login isn't required anymore
            //_Browser.LoginToELearningPage();
        }

        [When(@"accessing help content ""(.*)"" for ""(.*)""")]
        public void WhenISelectToViewFor(string helpLink, string pageName)
        {
            if (String.IsNullOrEmpty(helpLink)) throw new ArgumentNullException("helpLink");
            if (String.IsNullOrEmpty(pageName)) throw new ArgumentNullException("pageName");

            _Browser.AccessAdminHelpContent(
                pageName    : pageName,
                helpLinkName: helpLink);

            //TODO: verify E Learning login isn't required anymore
            //_Browser.LoginToELearningPage();
        }

        [When(@"accessing help content ""(.*)"" for ""(.*)"" report")]
        public void WhenAccessingHelpContentForReport(string helpLink, string pageName)
        {
            if (String.IsNullOrEmpty(helpLink)) throw new ArgumentNullException("helpLink");
            if (String.IsNullOrEmpty(pageName)) throw new ArgumentNullException("pageName");

            _Browser.AccessReportHelpContent(
                pageName    : pageName,
                helpLinkName: helpLink);

            //TODO: verify E Learning login isn't required anymore
            //_Browser.LoginToELearningPage();
        }

         [When(@"accessing ""(.*)"" help information")]
        public void WhenAccessingHelpInformation(string tabName)
        {
            if (String.IsNullOrEmpty(tabName)) throw new ArgumentNullException("tabName");

            _Browser.AccessHelpContentByContext(
                pageName: "Tasks",
                tabName : tabName);
        }

        [Then(@"the context help header should be ""(.*)""")]
        public void ThenTheContextHelpHeaderShouldBe(string helpHeader)
        {
            if (String.IsNullOrEmpty(helpHeader)) throw new ArgumentNullException("helpHeader");

            _Browser.AssertThatTheContextHelpHeaderEquals(helpHeader);
        }

        [Then(@"the help header should be ""(.*)""")]
        public void ThenTheHelpHeaderShouldBe(string helpHeader)
        {
            if (String.IsNullOrEmpty(helpHeader)) throw new ArgumentNullException("helpHeader");

            _Browser.AssertThatTheHelpHeaderShouldEqual(helpHeader);
        }

        [Then(@"the help center header should be ""(.*)""")]
        public void ThenTheHelpCenterHeaderShouldBe(string helpHeader)
        {
            if (String.IsNullOrEmpty(helpHeader)) throw new ArgumentNullException("helpHeader");

            _Browser.AssertThatTheHelpCenterHeaderShouldEqual(helpHeader);
        }
    }
}
