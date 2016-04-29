using System;
using Coypu;

namespace Coder.DeclarativeBrowser.Drivers
{
    internal static class CustomDriverFactory
    {
        internal static CoderDeclarativeBrowser BuildCustomBrowserDriver(
            Coypu.Drivers.Browser browserDriver,
            SessionConfiguration sessionConfiguration,
            string downloadDirectory)
        {
            if (ReferenceEquals(browserDriver, null))           throw new ArgumentNullException("browserDriver"); 
            if (ReferenceEquals(sessionConfiguration, null))    throw new ArgumentNullException("sessionConfiguration");
            if (String.IsNullOrWhiteSpace(downloadDirectory))   throw new ArgumentNullException("downloadDirectory");

            var customBrowserDriver = GetCustomBrowserDriver(browserDriver, downloadDirectory);
            
            var session = new BrowserSession(sessionConfiguration, customBrowserDriver);

            session.ResizeTo(Config.ScreenWidth, Config.ScreenHeight);

            var browser = new CoderDeclarativeBrowser(session, downloadDirectory);

            return browser;
        }

        private static Driver GetCustomBrowserDriver(Coypu.Drivers.Browser browserDriver, string downloadDirectory)
        {
            if (ReferenceEquals(browserDriver, null)) throw new ArgumentNullException("browserDriver");
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException("downloadDirectory");

            if (browserDriver == Coypu.Drivers.Browser.Firefox)
            {
                return new CustomFirefoxDriver(downloadDirectory);
            }

            return new CustomPhantomJsDriver();
        }
    }
}
