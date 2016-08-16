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

        private SessionElementScope GetUserNameInput(string userName)
        {
            if (String.IsNullOrWhiteSpace(userName)) throw new ArgumentNullException("userName");

            var loginInput = _Browser.FindSessionElementByXPath($"//input[@type='radio' and @value='{userName}']");

            if (!loginInput.Exists())
            {
                _Browser.Refresh();
                throw new MissingHtmlException(String.Format("No login option found for {0}", userName));
            }

            return loginInput;
        }

        private SessionElementScope GetLoginButton()
        {
            var loginButton = _Browser.FindSessionElementByXPath("//input[@type='submit']");

            return loginButton;
        }

        internal void LoginAs(string userName)
        {
            if (String.IsNullOrWhiteSpace(userName)) throw new ArgumentNullException("userName");

            var loginSelect = RetryPolicy.FindElementShort.Execute(() => GetUserNameInput(userName));

            loginSelect.Click();

            GetLoginButton().Click();
        }
    }
}
