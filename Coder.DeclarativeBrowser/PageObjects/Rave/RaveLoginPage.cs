//@author:smalik
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using System;
using Coder.DeclarativeBrowser.Models.ETEModels;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveLoginPage
    {
        private readonly BrowserSession _Browser;
        private const string PageName = "Medidata Rave";

        public RaveLoginPage(BrowserSession browser) { if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); } _Browser = browser; }

        public SessionElementScope GetUserNameTextBox()
        {
            var userNameTextBox = _Browser.FindSessionElementById("UserLoginBox");

            return userNameTextBox;
        }

        public SessionElementScope GetPasswordTextBox()
        {
            var passwordTextBox = _Browser.FindSessionElementById("UserPasswordBox");

            return passwordTextBox;
        }

        public SessionElementScope GetLoginButton()
        {
            var loginButton = _Browser.FindSessionElementById("LoginButton");

            return loginButton;
        }

        internal bool OnRaveLogInPage()
        {
            var title = _Browser.Title;

            return title.Equals(PageName);
        }

        internal void GoTo()
        {
            if (!OnRaveLogInPage())
            {
                _Browser.Visit(Config.RaveHost);
            }
        }

        internal void Login(MedidataUser user)
        {
            if (ReferenceEquals(user, null))         throw new ArgumentNullException("user");
            if (String.IsNullOrEmpty(user.Username)) throw new ArgumentNullException("user.Username");
            if (String.IsNullOrEmpty(user.Password)) throw new ArgumentNullException("user.Password");

            GoTo();

            GetUserNameTextBox().FillInWith(user.Username);
            GetPasswordTextBox().FillInWith(user.Password);

            GetLoginButton().Click();
        }

    }
}
