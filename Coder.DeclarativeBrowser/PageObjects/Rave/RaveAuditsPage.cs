using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu.Timing;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveAuditsPage
    {
        private const int AuditTextIndex = 0;
        private const int UserIndex      = 1;
        private const int TimeStampIndex = 2;

        private const string TermSentAuditText         = "Data point term sent to Coder";
        private const string TermCodedAuditTextPrefix  = "User coded data point as Term Coded data point by User";
        private const string CodedPathAuditTextPrefix  = "User coded data point as ";
        private const string AdverseEventChildsName    = "Coder AE";

        private readonly BrowserSession _Session;
        
        internal RaveAuditsPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private SessionElementScope GetParentsRecordsLink()
        {
            var parentsRecordsLink = _Session.FindSessionElementById("_ctl0_Content_AuditSelector_Parent");

            return parentsRecordsLink;
        }

        private SessionElementScope GetChildsRecordsSelectList()
        {
            var childsRecordsSelectList = _Session.FindSessionElementById("_ctl0_Content_AuditSelector_Children");

            return childsRecordsSelectList;
        }

        private SessionElementScope GetAuditRecordsGrid()
        {
            var auditRecordsGrid = _Session.FindSessionElementById("_ctl0_Content_AuditsGrid");

            return auditRecordsGrid;
        }

        private IList<SessionElementScope> GetAuditRecordsGridDataRows()
        {
            var auditRecordsGrid = GetAuditRecordsGrid();

            var auditRecordsGridDataRows = auditRecordsGrid.FindAllSessionElementsByXPath("tbody/tr[not(contains(@class,'subTitle'))]");

            return auditRecordsGridDataRows;
        }

        private IList<RaveAuditRecordDetail> GetAuditRecords()
        {
            var auditRecordsGridDataRows = GetAuditRecordsGridDataRows();
            if (!auditRecordsGridDataRows.Any())
            {
                return null;
            }

            var auditRecords = (
                from auditsGridDataRow in auditRecordsGridDataRows
                select auditsGridDataRow.FindAllSessionElementsByXPath("td")
                into auditDetailsColumns
                select new RaveAuditRecordDetail()
                {
                    AuditText = auditDetailsColumns[AuditTextIndex].Text,
                    User      = auditDetailsColumns[UserIndex].Text,
                    Timestamp = auditDetailsColumns[TimeStampIndex].Text.ToDate()
                })
                .ToList();
            return auditRecords;
        }

        private IList<RaveAuditRecordDetail> GetAuditRecordsContaining( string targetAuditText)
        {
            if (String.IsNullOrWhiteSpace(targetAuditText)) throw new ArgumentNullException("targetAuditText");
            
            var auditRecords = GetAuditRecords();

            var matchingAuditRecords = auditRecords.Select(x => x).Where(x => x.AuditText.Contains(targetAuditText, StringComparison.OrdinalIgnoreCase));

            return matchingAuditRecords.ToList();
        }

        private IList<RaveAuditRecordDetail> GetChildAuditRecords(string child)
        {
            if (String.IsNullOrWhiteSpace(child)) throw new ArgumentNullException("child");

            DisplayChildsAuditRecords(child);

            var auditRecords = GetAuditRecords();

            return auditRecords.ToList();
        }

        private IList<RaveAuditRecordDetail> GetChildAuditRecordsContaining(string child, string targetAuditText)
        {
            if (String.IsNullOrWhiteSpace(child))           throw new ArgumentNullException("child");
            if (String.IsNullOrWhiteSpace(targetAuditText)) throw new ArgumentNullException("targetAuditText");

            var auditRecords = GetChildAuditRecords(child);

            var matchingAuditRecords = auditRecords.Select(x => x).Where(x => x.AuditText.Contains(targetAuditText, StringComparison.OrdinalIgnoreCase));

            return matchingAuditRecords.ToList();
        }

        private void DisplayParentsAuditRecords()
        {
            var parentsRecordsLink = GetParentsRecordsLink();

            parentsRecordsLink.Click();

            _Session.WaitUntilElementExists(GetAuditRecordsGrid);
        }

        private void DisplayChildsAuditRecords(string child)
        {
            if (String.IsNullOrWhiteSpace(child)) throw new ArgumentNullException("child");

            var childsRecordsSelectList = GetChildsRecordsSelectList();

            childsRecordsSelectList.SelectOptionAlphanumericOnly(child);

            _Session.WaitUntilElementExists(GetAuditRecordsGrid);
        }
        
        private void WaitUntilLatestChildRecordContains(string child, string targetAuditText)
        {
            if (String.IsNullOrWhiteSpace(child))           throw new ArgumentNullException("child");
            if (String.IsNullOrWhiteSpace(targetAuditText)) throw new ArgumentNullException("targetAuditText");

            RetryPolicy.RaveCoderTransmission.Execute(() =>
            {
                var latestChildAuditRecord    = GetChildAuditRecords(child).FirstOrDefault();

                if (ReferenceEquals(latestChildAuditRecord, null) || !latestChildAuditRecord.AuditText.Contains(targetAuditText, StringComparison.OrdinalIgnoreCase))
                {
                    DisplayParentsAuditRecords();
                    throw new MissingHtmlException(String.Format("No audit record for '{0}' in child '{1}'.", targetAuditText, child));
                }
            });
        }

        private void WaitUntilCodedPathReceived()
        {
            WaitUntilLatestChildRecordContains(AdverseEventChildsName, CodedPathAuditTextPrefix);

            DisplayParentsAuditRecords();

            RetryPolicy.RaveCoderTransmission.Execute(() =>
            {
                var latestMatchingChildAuditRecord = GetChildAuditRecordsContaining(AdverseEventChildsName, CodedPathAuditTextPrefix).FirstOrDefault();

                if (ReferenceEquals(latestMatchingChildAuditRecord, null) 
                || latestMatchingChildAuditRecord.AuditText.Contains(TermCodedAuditTextPrefix, StringComparison.OrdinalIgnoreCase))
                {
                    DisplayParentsAuditRecords();
                    throw new MissingHtmlException(
                        String.Format("No coded path audit record for '{0}' in child '{1}'.", CodedPathAuditTextPrefix, AdverseEventChildsName));
                }
            });
        }
        
        internal void WaitUntilTermSent()
        {
            WaitUntilLatestChildRecordContains(AdverseEventChildsName, TermSentAuditText);
        }

        internal string GetCodedPathFromAuditRecord()
        {
            WaitUntilCodedPathReceived();

            var codedPathAuditRecord = GetAuditRecordsContaining(CodedPathAuditTextPrefix).First();

            string codedPath = codedPathAuditRecord.AuditText.Replace(CodedPathAuditTextPrefix, "");

            return codedPath;
        }
    }
}
