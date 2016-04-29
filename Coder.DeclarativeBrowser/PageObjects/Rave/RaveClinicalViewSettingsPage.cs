//@author:smalik
using Coder.DeclarativeBrowser.ExtensionMethods;
using System;
using Coypu;
using System.Collections.Generic;
using System.Linq;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveClinicalViewSettingsPage
    {
        private readonly BrowserSession _Browser;

        internal RaveClinicalViewSettingsPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        private SessionElementScope GetCodingSettingsLink()
        {
            var codingSettingsLink = _Browser.FindSessionElementById("_ctl0_Content_LnkColumnSetting");

            return codingSettingsLink;
        }

        internal void OpenCodingSettings()
        {
            var codingSettingsLink = GetCodingSettingsLink();
      
            codingSettingsLink.Click();
        }
    }
}
