using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class IMedidataLoginPage
    {
        private const string PageName = "iMedidata | Login";

        private readonly BrowserSession          _Browser;

        public IMedidataLoginPage(BrowserSession browser) { if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }  _Browser = browser; }

        public SessionElementScope GetUserNameTextBox()
        {
            var userNameTextBox = _Browser.FindSessionElementByXPath("//input[@id = 'session_username']");

            return userNameTextBox;
        }

        public SessionElementScope GetPasswordTextBox()
        {
            var passwordTextBox = _Browser.FindSessionElementByXPath("//input[@id = 'session_password']");

            return passwordTextBox;
        }

        public SessionElementScope GetIMedidataLoginButton()
        {
            var loginButton = _Browser.FindSessionElementByXPath("//button[@id = 'create_session_link']");

            return loginButton;
        }

        public SessionElementScope GetLoginButton()
        {
            var loginButton = _Browser.FindSessionElementByXPath("//input[@value='Login']");

            return loginButton;
        }

        public SessionElementScope GetUserNameRadioButton(string userName)
        {
            if (String.IsNullOrWhiteSpace(userName)) throw new ArgumentNullException("userName");

            var userNameXPath = String.Format("//input[@value='{0}']", userName);
            var userNameRadioButton = _Browser.FindSessionElementByXPath(userNameXPath);

            return userNameRadioButton;
        }

        internal bool OnIMedidataLogInPage()
        {
            var title = _Browser.Title;

            return title.Equals(PageName);
        }

        internal void GoToPage()
        {
            if (!OnIMedidataLogInPage())
            {
                _Browser.Visit(Config.AppHost);
            }
        }

        internal void Login(string userName, string password)
        {
            if (String.IsNullOrEmpty(userName))  throw new ArgumentNullException("userName"); 
            if (String.IsNullOrEmpty(password))  throw new ArgumentNullException("password");

            GoToPage();

            GetUserNameTextBox().FillInWith(userName);
            GetPasswordTextBox().FillInWith(password);

            GetIMedidataLoginButton().Click();

            if (OnIMedidataLogInPage())
            {

                throw new MissingWindowException("Log In unsuccessful. User still on iMedidata Log In Page.");
            }
        }
    }
}
