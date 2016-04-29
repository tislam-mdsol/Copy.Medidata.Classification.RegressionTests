using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class KnowledgeSpacePage
    {
        private readonly BrowserWindow _BrowserWindow;

        public KnowledgeSpacePage(BrowserWindow browserWindow)
        {
            if (ReferenceEquals(browserWindow, null)) throw new ArgumentNullException("browserWindow");

            _BrowserWindow = browserWindow;
        }

        public SessionElementScope GetKnowledgeSpaceHeader()
        {
            var knowledgeSpaceHeader = _BrowserWindow.FindSessionElementByXPath("//h1[@id='title-text']/a");

            return knowledgeSpaceHeader;
        }
    }
}
