using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class ELearningLoginPage
    {
        private readonly BrowserWindow _BrowserWindow;

        public ELearningLoginPage(BrowserWindow browserWindow)
        {
            if (ReferenceEquals(browserWindow, null)) { throw new ArgumentNullException("browserWindow"); }

            _BrowserWindow = browserWindow;
        }

        public SessionElementScope GetCustomerLoginButton()
        {
            var customerLoginButton = _BrowserWindow
                .FindSessionElementByXPath("//div[@id = 'login-container']//div[@class = 'casSignInButton']/div[@class ='label']");

            return customerLoginButton;
        }

        public SessionElementScope GetUserNameTextBox()
        {
            var userNameTextBox = _BrowserWindow.FindSessionElementById("os_username");

            return userNameTextBox;
        }


        public SessionElementScope GetPasswordTextBox()
        {
            var passwordTextBox = _BrowserWindow.FindSessionElementById("os_password");

            return passwordTextBox;
        }

        public SessionElementScope GetLoginButton()
        {
            var loginButton = _BrowserWindow.FindSessionElementById("loginButton");

            return loginButton;
        }
    }
}

