
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveConfigurationOtherSettingsCoderPage
    {
        /* 
           The main Coder focus on this page is to restore global configuration values for Rave-Coder query scenarios.
           The main values are the marking group name and the activation of a query option to enable queries to require
           responses. 
        */

        private readonly BrowserSession _Session;
       
        internal RaveConfigurationOtherSettingsCoderPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Session = session;
        }

        private SessionElementScope GetMarkingGroupSelectList()
        {
            var markingGroupSelectList = _Session.FindSessionElementById("_ctl0_Content_coderMarkingGroup");

            return markingGroupSelectList;
        }

        private SessionElementScope GetQueryRequiresResponseCheckBox()
        {
            var queryRequiresResponseCheckBox = _Session.FindSessionElementById("_ctl0_Content_chkReqResponse");

            return queryRequiresResponseCheckBox;
        }

        private SessionElementScope GetBottomUpdateLink()
        {
            var bottomUpdateLink = _Session.FindSessionElementById("_ctl0_Content_LnkBtnBottomSave");

            return bottomUpdateLink;
        }

        private SessionElementScope GetBottomCancelLink()
        {
            var bottomCancelLink = _Session.FindSessionElementById("_ctl0_Content_LnkBtnBottomCancel");

            return bottomCancelLink;
        }

        private SessionElementScope GetTopUpdateLink()
        {
            var topUpdateLink = _Session.FindSessionElementById("_ctl0_Content_LnkBtnTopSave");

            return topUpdateLink;
        }

        private SessionElementScope GetTopCancelLink()
        {
            var topCancelLink = _Session.FindSessionElementById("_ctl0_Content_LnkBtnTopCancel");

            return topCancelLink;
        }

        internal void SetCoderOtherSettingsCoderPageDefaults(RaveCoderGlobalConfiguration configurationSetting)
        {
            if (ReferenceEquals(configurationSetting, null))                   throw new ArgumentNullException("configurationSetting");
            if (String.IsNullOrEmpty(configurationSetting.ReviewMarkingGroup)) throw new ArgumentNullException("configurationSetting.ReviewMarkingGroup");

                GetMarkingGroupSelectList().SelectOption(configurationSetting.ReviewMarkingGroup);
                GetTopUpdateLink().Click();
                GetQueryRequiresResponseCheckBox().SetCheckBoxState(configurationSetting.IsRequiresResponse);
                GetBottomUpdateLink().Click();

        }
        
    }
}
