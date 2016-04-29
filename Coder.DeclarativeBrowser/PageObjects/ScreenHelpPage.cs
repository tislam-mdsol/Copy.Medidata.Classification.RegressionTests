using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class ScreenHelpPage
    {
        private readonly BrowserWindow _BrowserWindow;

        public ScreenHelpPage(BrowserWindow browserWindow)
        {
            if (ReferenceEquals(browserWindow, null)) throw new ArgumentNullException("browserWindow");

            _BrowserWindow = browserWindow;
        }

        public SessionElementScope GetScreenHelpHeader()
        {
            var screenHelpHeader = _BrowserWindow.FindSessionElementByXPath("//h1[@id='title-text']/a");

            return screenHelpHeader;
        }
    }
}
    