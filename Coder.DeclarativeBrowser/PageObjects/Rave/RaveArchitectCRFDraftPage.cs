//@author: smalik
using Coypu;
using System;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Helpers;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveArchitectCRFDraftPage
    {
        private readonly BrowserSession _Session;

        internal RaveArchitectCRFDraftPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

         internal string PublishDraft()
         {
             var rand = BrowserUtility.RandomString();

             string draftVersion = "Rave_Coder_Draft_v" + rand;

             GetCRFVersionTextBox().FillInWith(draftVersion);

             GetPublishButton().Click();

             VerifyCRFPublishHasCompleted(draftVersion);

             return draftVersion;
         }

         private SessionElementScope GetDraftVersionsGrid()
         {
             var versionsGrid = _Session.FindSessionElementById("_ctl0_Content_VersionGrid");

             return versionsGrid;
         }

         private IList<SessionElementScope> GetDraftVersionRows()
         {
             var versionsGrid = GetDraftVersionsGrid();

             var versionRows = versionsGrid.FindAllSessionElementsByXPath(".//tr");

             return versionRows;
         }

         private void VerifyCRFPublishHasCompleted(String dictionaryVersion)
         {
             if (ReferenceEquals(dictionaryVersion, null)) throw new ArgumentNullException("dictionaryVersion");

             var versionRows = GetDraftVersionRows();

             if (!versionRows.Any())
             {
                 throw new MissingHtmlException(String.Format("No CRF versions have been published"));
             }

             var versionRow = versionRows.FirstOrDefault(
                 x => x.FindAllSessionElementsByXPath("td")[0].Text.Contains(dictionaryVersion));

             if (ReferenceEquals(versionRow, null))
             { throw new MissingHtmlException(String.Format("Cannot find row for version {0}", dictionaryVersion)); }
         
         }

         private SessionElementScope GetCRFVersionTextBox()
         {
             var crfVersionTextBox = _Session.FindSessionElementById("_ctl0_Content_TxtCRFVersion");

             return crfVersionTextBox;
         }

         private SessionElementScope GetPublishButton()
         {
             var publishButton = _Session.FindSessionElementById("_ctl0_Content_BtnPublish");

             return publishButton;
         }
        
    }
}
