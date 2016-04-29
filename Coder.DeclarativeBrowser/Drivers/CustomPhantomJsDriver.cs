using System;
using System.Drawing;
using Coypu.Drivers;
using Coypu.Drivers.Selenium;
using OpenQA.Selenium.PhantomJS;
using OpenQA.Selenium.Remote;

namespace Coder.DeclarativeBrowser.Drivers
{
    internal class CustomPhantomJsDriver : SeleniumWebDriver
    {
        private static readonly string[] _DriverArgs = new string[]
        {
            "--ignore-ssl-errors=true",
            "--disk-cache=true",
            "--webdriver-selenium-grid-hub=" + Config.GridHubHost.ToString()
        };

        public CustomPhantomJsDriver() : base(CustomProfileDriver(), Browser.PhantomJS)
        {
        }

        private static RemoteWebDriver CustomProfileDriver()
        {
            var driverService = PhantomJSDriverService.CreateDefaultService();

            driverService.AddArguments(_DriverArgs);
            driverService.SuppressInitialDiagnosticInformation = true;

            RemoteWebDriver driver;

            if (Config.IsGridConfigured)
            {
                var capabilities = DesiredCapabilities.PhantomJS();
                driver = new RemoteWebDriver(capabilities);
            }
            else
            {
                driver = new PhantomJSDriver(driverService);
            }

            return driver;
        }
    }
}
