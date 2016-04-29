using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class HelpCenterPage
    {
        private readonly BrowserWindow _BrowserWindow;

        public HelpCenterPage(BrowserWindow browserWindow)
        {
            if (ReferenceEquals(browserWindow, null)) throw new ArgumentNullException("browserWindow");

            _BrowserWindow = browserWindow;
        }

        public SessionElementScope GetUserNameTextBox()
        {
            var userNameTextBox = _BrowserWindow.FindSessionElementByXPath("//input[@id = 'session_username']");

            return userNameTextBox;
        }

        public SessionElementScope GetPasswordTextBox()
        {
            var passwordTextBox = _BrowserWindow.FindSessionElementByXPath("//input[@id = 'session_password']");

            return passwordTextBox;
        }

        public SessionElementScope GetLoginButton()
        {
            var loginButton = _BrowserWindow.FindSessionElementByXPath("//button[@id = 'create_session_link']");

            return loginButton;
        }

        public SessionElementScope GetHelpCenterHeader()
        {
            var helpCenterHeader = _BrowserWindow.FindSessionElementByXPath("/html/body/main/section[2]/div[1]/div[2]/a/h2");

            return helpCenterHeader;
        }
    }
}
