using System;
using Coder.DeclarativeBrowser.PageObjects;
using Coypu;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    internal static class BrowserWindowExtensionMethods
    {
        internal static ELearningLoginPage GetELearningLoginPage(this BrowserWindow browserWindow)
        {
            if (ReferenceEquals(browserWindow, null)) throw new ArgumentNullException("browserWindow");

            var eLearningLoginPage = new ELearningLoginPage(browserWindow);

            return eLearningLoginPage;
        }

        internal static HelpCenterPage GetHelpCenterPage(this BrowserWindow browserWindow)
        {
            if (ReferenceEquals(browserWindow, null)) throw new ArgumentNullException("browserWindow");

            var helpCenterPage = new HelpCenterPage(browserWindow);

            return helpCenterPage;
        }

        internal static ScreenHelpPage GetScreenHelpPage(this BrowserWindow browserWindow)
        {
            if (ReferenceEquals(browserWindow, null)) throw new ArgumentNullException("browserWindow");

            var screenHelpPage = new ScreenHelpPage(browserWindow);

            return screenHelpPage;
        }

        internal static KnowledgeSpacePage GetKnowledgeSpacePage(this BrowserWindow browserWindow)
        {
            if (ReferenceEquals(browserWindow, null)) throw new ArgumentNullException("browserWindow");

            var knowledgeSpacePage = new KnowledgeSpacePage(browserWindow);

            return knowledgeSpacePage;
        }

        internal static ContextHelpPage GetContextHelpPage(this BrowserWindow browserWindow)
        {
            if (ReferenceEquals(browserWindow, null)) throw new ArgumentNullException("browserWindow");

            var contextHelpPage = new ContextHelpPage(browserWindow);

            return contextHelpPage;
        }
    }
}
