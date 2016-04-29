using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu;
using Polly;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class CoderLoginPage
    {
        private readonly BrowserSession _Browser;

        internal CoderLoginPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Browser = session;
        }

        private IEnumerable<SessionElementScope> GetUserNameList()
        {
            var logins = _Browser.FindAllSessionElementsByXPath("//div[@class='master-content']/input[@type='radio']");

            return logins.Reverse();
        }

        private SessionElementScope GetUserNameInput(string userName)
        {
            if (String.IsNullOrWhiteSpace(userName)) throw new ArgumentNullException("userName");

            var logins = GetUserNameList();
            var login = logins.FirstOrDefault(x => x.GetAttribute("value").Equals(userName));

            if (ReferenceEquals(login, null))
            {
                _Browser.Refresh();
                throw new MissingHtmlException(String.Format("No login option found for {0}", userName));
            }

            return login;
        }

        private SessionElementScope GetLoginButton()
        {
            var loginButton = _Browser.FindSessionElementByXPath("//input[@type='submit']");

            return loginButton;
        }

        internal void LoginAs(string userName)
        {
            if (String.IsNullOrWhiteSpace(userName)) throw new ArgumentNullException("userName");


            var loginSelect = RetryPolicy.FindElementShort.Execute(
                () => GetUserNameInput(userName));
            loginSelect.Click();

            var loginButton = GetLoginButton();
            loginButton.Click();
        }
    }
}
