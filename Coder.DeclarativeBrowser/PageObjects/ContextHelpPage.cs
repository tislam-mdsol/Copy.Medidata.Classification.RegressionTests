using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class ContextHelpPage
    {
        private readonly BrowserWindow _BrowserWindow;

        public ContextHelpPage(BrowserWindow window) { if (ReferenceEquals(window, null)) throw new ArgumentNullException("window");  _BrowserWindow = window; }

        public SessionElementScope GetContextHelpPageHeader()
        {
            var contextHelpPageHeader = _BrowserWindow.FindSessionElementByXPath("//h1[@id='title-text']/a");

            return contextHelpPageHeader;
        }
    }
}
