using System;
using System.Reflection;
using FluentAssertions;

namespace Coder.DeclarativeBrowser.ExtensionMethods.Assertions
{
    public static class HelpContentAssertionExtensionMethods
    {
        public static void AssertThatTheHelpHeaderShouldEqual(
            this CoderDeclarativeBrowser browser, 
            string helpHeader)
        {
            if (ReferenceEquals(browser,null))     throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(helpHeader))  throw new ArgumentNullException("helpHeader");

            var session    = browser.Session;

            var helpWindow = session.SwitchToBrowserWindowByName(Config.HelpWindowName);

            var taskHeader = helpWindow
                .GetScreenHelpPage()
                .GetScreenHelpHeader()
                .InnerHTML;

            helpHeader.ShouldBeEquivalentTo(taskHeader);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatTheContextHelpHeaderEquals(
            this CoderDeclarativeBrowser browser, 
            string helpHeader)
        {
            if (ReferenceEquals(browser, null))   throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(helpHeader)) throw new ArgumentNullException("helpHeader");

            var session    = browser.Session;

            var helpWindow = session.SwitchToBrowserWindowByName(Config.HelpWindowName);

            var taskHeader = helpWindow
                .GetContextHelpPage()
                .GetContextHelpPageHeader()
                .InnerHTML;

            helpHeader.ShouldBeEquivalentTo(taskHeader);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }

        public static void AssertThatTheHelpCenterHeaderShouldEqual(
            this CoderDeclarativeBrowser browser,
            string helpHeader)
        {
            if (String.IsNullOrEmpty(helpHeader)) throw new ArgumentNullException("helpHeader");

            var session          = browser.Session;

            var helpCenterWindow = session.SwitchToBrowserWindowByName(Config.HelpCenterWindowName);

            var helpCenterHeader = helpCenterWindow
                .GetHelpCenterPage()
                .GetHelpCenterHeader()
                .InnerHTML;

            helpHeader.ShouldBeEquivalentTo(helpCenterHeader);

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
    }
}
