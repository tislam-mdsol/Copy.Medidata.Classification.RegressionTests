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
    internal sealed class RaveConfigurationOtherSettingsPage
    {
        /* 
           The main Coder focus on this page is to restore global configuration values for Rave-Coder audit
           sticky scenarios.  
        */

        private readonly BrowserSession _Session;
        
        internal RaveConfigurationOtherSettingsPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Session = session;
        }

        private SessionElementScope GetCoderConfigurationLink()
        {
            var coderConfigurationLink = _Session.FindSessionElementById("_ctl0_Content_CoderConfigurationLnk");

            return coderConfigurationLink;
        }

        
        private SessionElementScope GetAuditStickyInUseCheckBox()
        {
            var auditStickyInUseCheckBox = _Session.FindSessionElementById("_ctl0_Content_AuditStickyChkInUse");

            return auditStickyInUseCheckBox;
        }

        private SessionElementScope GetAuditStickyCheckBox()
        {
            var auditStickyCheckBox = _Session.FindSessionElementById("_ctl0_Content_AuditStickyChk");

            return auditStickyCheckBox;
        }

        internal void SetCoderOtherSettingsDefaultValues()
        {
            GetAuditStickyCheckBox().Check();
            GetAuditStickyInUseCheckBox().Check();
        }

        internal void OpenCoderConfiguration()
        {
            GetCoderConfigurationLink().Click();
        }

    }
}
