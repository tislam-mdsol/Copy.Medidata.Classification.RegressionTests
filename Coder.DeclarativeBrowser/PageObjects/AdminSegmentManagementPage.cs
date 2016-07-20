//@author:smalik
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using System;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class AdminSegmentManagementPage
    {
        private readonly BrowserSession _Browser;
        private const string PageName = "Segment Management";

        internal AdminSegmentManagementPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

        internal bool OnSegmentManagementPage()
        {
            var title = _Browser.Title;

            return title.Equals(PageName);
        }

        internal void GoTo()
        {
            if (!OnSegmentManagementPage())
            {
                _Browser.GoToAdminPage(PageName);
            }
        }

        internal void EnrollSegment(String newGeneratedSegment)
        {
            if (String.IsNullOrEmpty(newGeneratedSegment)) throw new ArgumentNullException("newGeneratedSegment");

            GoTo();

            GetNewSegmentPlusButton().Click();
            GetNewSegmentNameTextBox().FillInWith(newGeneratedSegment);
            GetEditingRowCheckMarkButton().Click();

            WaitUntilFinishLoading();

            var resultIndicator = GetStatusPaneIndicator();

            if(resultIndicator.Exists(Config.ExistsOptions) && !String.IsNullOrWhiteSpace(resultIndicator.Text))
            {
                throw new MissingHtmlException(String.Format("Error enrolling segment {0}: {1}", newGeneratedSegment, resultIndicator.Text));
            }
        }

        private SessionElementScope GetNewSegmentPlusButton()
        {
            var plusButton = _Browser.FindSessionElementById("ctl00_Content_gridSegments_FooterRow_LnkAddNewgridSegments");

            return plusButton;
        }

        private SessionElementScope GetNewSegmentNameTextBox()
        {
            var segmentNameTextBox = _Browser.FindSessionElementById("ctl00_Content_gridSegments_DXEditor1_I");

            return segmentNameTextBox;
        }

        private SessionElementScope GetEditingRowCheckMarkButton()
        {
            var checkMarkButton = _Browser.FindSessionElementByXPath("//tr[@id='ctl00_Content_gridSegments_DXEditingRow']/td[6]/img[1]");

            return checkMarkButton;
        }

        private SessionElementScope GetStatusPaneIndicator()
        {
            var statusPane = _Browser.FindSessionElementById("ctl00_StatusPaneACG");

            return statusPane;
        }
        
        internal void WaitUntilFinishLoading()
        {
            _Browser.RefreshUntilElementDisappears(GetLoadingIndicator);
        }

        private SessionElementScope GetLoadingIndicator()
        {
            var loadingIndicator = _Browser.FindSessionElementByXPath("//*[contains(@id, '_LPV')]");

            return loadingIndicator;
        }
    }
}
