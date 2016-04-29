//@author: smalik
using Coypu;
using System;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.ExtensionMethods;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveArchitectCRFDraftPushPage
    {
        private readonly BrowserSession _Session;

         internal RaveArchitectCRFDraftPushPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        internal void PushDraft(string studyEnvironment)
         {
            if (String.IsNullOrWhiteSpace(studyEnvironment)) throw new ArgumentNullException("studyEnvironment");

            GetStudyDDL().SelectClosestOption(studyEnvironment);

             GetPushButton().Click();
         }

         internal bool VerifyCRFPushHasCompleted(String message)
         {
             if (ReferenceEquals(message, null)) throw new ArgumentNullException("message");

             var uploadSuccessIndicator = GetUploadSuccessIndicator();
             var messageMatches = uploadSuccessIndicator.Text.Contains(message, StringComparison.OrdinalIgnoreCase);

             return messageMatches;
         }

         private SessionElementScope GetStudyDDL()
         {
             var studyDDL = _Session.FindSessionElementById("_ctl0_Content_StudyDDL");

             return studyDDL;
         }

         private SessionElementScope GetPushButton()
         {
             var pushButton = _Session.FindSessionElementById("_ctl0_Content_PushBTN");

             return pushButton;
         }

         private SessionElementScope GetUploadSuccessIndicator()
         {
             var uploadSuccessIndicator = _Session.FindSessionElementById("_ctl0_Content_SuccessMessageLBL");

             return uploadSuccessIndicator;
         }

        internal void IncompletePushDraft(string studyEnvironment)
        {
            if (String.IsNullOrEmpty(studyEnvironment)) throw new ArgumentNullException("study environment");

            var studyDDLSelectList = GetStudyDDL();

            studyDDLSelectList.SelectOptionAlphanumericOnly(studyEnvironment);
        }

        private SessionElementScope GetPushDisabledIndicator()
        {
            var pushDisabledIndicator = _Session.FindSessionElementById("_ctl0_Content_LblErrMsg");

            return pushDisabledIndicator;
        }

        internal bool IsPushButtonEnabled()
        {
            var pushButton = GetPushButton();
            var isEnabled  = !pushButton.Disabled;

            return isEnabled;
        }

        internal string GetErrorMessageForPushIsDisabled()
        {
            var pushDisabledIndicator = GetPushDisabledIndicator();
            var pushIndicatorMessage = pushDisabledIndicator.Text;

            return pushIndicatorMessage;
        }


    }
}
