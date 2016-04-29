using System;
using System.Configuration;
using Coypu.Drivers;
using Coypu.Drivers.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.Remote;

namespace Coder.DeclarativeBrowser.Drivers
{
    class CustomFirefoxDriver : SeleniumWebDriver
    {
        public CustomFirefoxDriver(string downloadDirectory)
            : base(CustomProfileDriver(downloadDirectory), Browser.Firefox) { }

        private static RemoteWebDriver CustomProfileDriver(string downloadDirectory)
        {
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException("downloadDirectory");

            const string proxySetting = "NoProxy";

            var proxy = new Proxy
            {
                HttpProxy   = proxySetting,
                SslProxy    = proxySetting
            };

            var ffProfile = new FirefoxProfile();
            ffProfile.SetProxyPreferences(proxy);

            ffProfile.SetPreference("browser.cache.check_doc_frequency"                                     , 1);
            ffProfile.SetPreference("browser.download.dir"                                                  , downloadDirectory);
            ffProfile.SetPreference("browser.download.folderList"                                           , 2);
            ffProfile.SetPreference("browser.download.manager.closeWhenDone"                                , true);
            ffProfile.SetPreference("browser.download.manager.flashCount"                                   , 0);
            ffProfile.SetPreference("browser.download.manager.focusWhenStarting"                            , false);
            ffProfile.SetPreference("browser.download.manager.showAlertOnComplete"                          , false);
            ffProfile.SetPreference("browser.download.manager.useWindow"                                    , false);
            ffProfile.SetPreference("browser.download.useDownloadDir"                                       , true);
            ffProfile.SetPreference("browser.helperApps.alwaysAsk.force"                                    , false);
            ffProfile.SetPreference("browser.helperApps.neverAsk.saveToDisk"                                , Config.BrowserAutoSaveFileTypes);
            ffProfile.SetPreference("services.sync.prefs.sync.browser.download.manager.showWhenStarting"    , false);

            var timeout = TimeSpan.FromMinutes(3);

            RemoteWebDriver driver;

            if (Config.IsGridConfigured)
            {
                var capabilities = DesiredCapabilities.Firefox();
                capabilities.SetCapability(FirefoxDriver.ProfileCapabilityName, ffProfile.ToBase64String());

                driver = new RemoteWebDriver(Config.GridHubHost, capabilities, timeout);
            }
            else
            {
                var ffBinary = new FirefoxBinary(Config.FirefoxExecutablePath);

                driver = new FirefoxDriver(ffBinary, ffProfile, timeout);
            }

            return driver;
        }
    }
}
