using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class BrowserPage
    {
        private readonly BrowserSession _Session;

        public BrowserPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Session = session;
        }

        public SessionElementScope GetContextHelpLink()
        {
            var contextHelpLink = _Session.FindSessionElementByXPath("//a[@Class='help-link']");

            return contextHelpLink;
        }
    }
}
