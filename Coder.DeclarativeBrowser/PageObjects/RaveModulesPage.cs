//@author:smalik
using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveModulesPage
    {
        private readonly BrowserSession _Browser;
        private const string PageName = "Home - Medidata Rave";

        internal RaveModulesPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        internal bool OnRaveHomePage()
        {
            var title = _Browser.Title;

            return title.Equals(PageName);
        }

        internal void GoTo()
        {
            if (!OnRaveHomePage())
            {
                var homeLink = GetHomeLink();

                if (!homeLink.Exists(Config.ExistsOptions))
                {
                    throw new MissingHtmlException("homeLink");
                }

                homeLink.Click();
            }
        }

        internal void GoToUserAdminUserPage()
        {
            GoTo();

            GetUserAdministrationLink().Click();

        }

        internal void GoToConfigPage()
        {
            GoTo();

            GetConfigurationLink().Click();

            GetConfigurationLoaderLink().Click();
        }

        private SessionElementScope GetUserAdministrationLink()
        {
            var userAdminLink = _Browser.FindSessionElementByLink("User Administration");
            return userAdminLink;
        }

        private SessionElementScope GetConfigurationLink()
        {
            var ConfigurationLink = _Browser.FindSessionElementByLink("Configuration");

            return ConfigurationLink;
        }

        private SessionElementScope GetConfigurationLoaderLink()
        {
            var ConfigurationLoaderLink = _Browser.FindSessionElementByLink("Configuration Loader");

            return ConfigurationLoaderLink;
        }

        private SessionElementScope GetHomeLink()
        {
            var homeLink = _Browser.FindSessionElementById("_ctl0_PgHeader_TabHyperlink0");
            return homeLink;
        }

    }
}
