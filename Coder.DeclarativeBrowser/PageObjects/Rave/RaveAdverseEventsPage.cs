using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveAdverseEventsPage
    {
        private const string AdverseEventTextIdPrefix = "_ctl0_Content_R_log_log_R";
        private const string LogLineAuditLinkIdSuffix = "_DataStatusHyperlink";
        private const int    LogLineIdLength          = 7;

        private readonly BrowserSession _Session;

        internal RaveAdverseEventsPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private SessionElementScope GetDetailViewIndicator()
        {
            var detailViewIndicator = _Session.FindSessionElementById("_ctl0_Content_R_log_log_Portrait");

            return detailViewIndicator;
        }

        private SessionElementScope GetNewLogLineLink()
        {
            var newLogLineLink = _Session.FindSessionElementById("_ctl0_Content_R_log_log_AddLine");

            return newLogLineLink;
        }

        private SessionElementScope GetAdverseEventsGrid()
        {
            var adverseEventsGrid = _Session.FindSessionElementById("log");

            return adverseEventsGrid;
        }

        private IList<SessionElementScope> GetAdverseEventsGridLinks()
        {
            var adverseEventsGrid = GetAdverseEventsGrid();

            var adverseEventLinks = adverseEventsGrid.FindAllSessionElementsByXPath(".//a");

            return adverseEventLinks.ToList();
        }

        private IList<string> GetAdverseEventLogLineIds(string targetAdverseEventText)
        {
            if (String.IsNullOrWhiteSpace(targetAdverseEventText)) throw new ArgumentNullException("targetAdverseEventText");
            
            _Session.WaitUntilElementExists(GetAdverseEventsGrid);

            var adverseEventLinks = GetAdverseEventsGridLinks();

            var  adverseEventTexts = adverseEventLinks
                .Select(x => x)
                .Where(x => x.Text.EqualsIgnoreCase(targetAdverseEventText) && x.Id.Contains(AdverseEventTextIdPrefix));
            
            var logLineIds = adverseEventTexts.Select(x => x.Id.Substring(AdverseEventTextIdPrefix.Length, LogLineIdLength)).ToList();

            return logLineIds;
        }

        private string GetAdverseEventLogLineId(string adverseEventText, int adverseEventOccurrence = 1)
        {
            if (String.IsNullOrWhiteSpace(adverseEventText)) throw new ArgumentNullException("adverseEventText");
            if (adverseEventOccurrence <= 0)                 throw new ArgumentException("adverseEventOccurrence must be greater than 0.");
            
            var logLineIds = GetAdverseEventLogLineIds(adverseEventText);

            if (logLineIds.Count < adverseEventOccurrence)
            {
                throw new MissingHtmlException(String.Format("No log line found for occurrence {0} of adverse event, {1}", adverseEventOccurrence, adverseEventText));
            }

            int adverseEventOccurrenceIndex = adverseEventOccurrence - 1;
            var logLineId                   = logLineIds[adverseEventOccurrenceIndex];

            return logLineId;
        }

        private SessionElementScope GetLogLineAuditLink(string logLineId)
        {
            if (String.IsNullOrWhiteSpace(logLineId)) throw new ArgumentNullException("logLineId");
            
            var adverseEventLinks = GetAdverseEventsGridLinks();

            var logLineAuditLink = adverseEventLinks
                .FirstOrDefault(x => x.Id.Contains(LogLineAuditLinkIdSuffix) && x.Id.Contains(logLineId));

            return logLineAuditLink;
        }

        internal void ViewAuditLog(string adverseEventText, int adverseEventOccurrence = 1)
        {
            if (String.IsNullOrWhiteSpace(adverseEventText)) throw new ArgumentNullException("adverseEventText");
            if (adverseEventOccurrence <= 0)                 throw new ArgumentException("adverseEventOccurrence must be greater than 0.");

            var logLineId        = GetAdverseEventLogLineId(adverseEventText, adverseEventOccurrence);

            var logLineAuditLink = GetLogLineAuditLink(logLineId);

            logLineAuditLink.Click();
        }
        
        private SessionElementScope GetCoderAdverseEventTextBox()
        {
            var coderAdverseEventTextBox =
                _Session.FindSessionElementByXPath("//textarea[contains(@id, '_CRFControl_17433_CRFControl_Text')]");
            
            return coderAdverseEventTextBox;
        }

        private SessionElementScope GetSaveButton()
        {
            var saveButton = _Session.FindSessionElementById("_ctl0_Content_R_footer_SB");

            return saveButton;
        }

        internal void CreateNewCoderAdverseEvent(string adverseEventText)
        {
            if (String.IsNullOrWhiteSpace(adverseEventText)) throw new ArgumentNullException("adverseEventText");

            if (!GetDetailViewIndicator().Exists(Config.ExistsOptions))
            {
                GetNewLogLineLink().Click();
            }

            _Session.WaitUntilElementExists(GetCoderAdverseEventTextBox);
            _Session.WaitUntilElementExists(GetSaveButton);

            var coderAdverseEventTextBox = GetCoderAdverseEventTextBox();
            coderAdverseEventTextBox.FillInWith(adverseEventText);

            var saveButton = GetSaveButton();
            saveButton.Click();
        }
    }
}