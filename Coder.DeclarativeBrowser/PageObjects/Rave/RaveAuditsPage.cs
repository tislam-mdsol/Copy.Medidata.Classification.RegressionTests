using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.DeclarativeBrowser.Models;
using Coypu.Timing;
using OpenQA.Selenium;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveAuditsPage
    {
        private const int _AuditTextIndex = 0;
        private const int _UserIndex      = 1;
        private const int _TimeStampIndex = 2;

        private const string _TermSentAuditText          = "Data point term sent to Coder";
        private const string _TermCodedAuditTextPrefix   = "User coded data point as Term Coded data point by User";
        private const string _CodedPathAuditTextPrefix   = "User coded data point as ";
        private const string _QueryOpenedAuditTextPrefix = "User opened query";

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

        private SessionElementScope GetChildsRecordsLink()
        {
            var childsRecordsLink = _Session.FindSessionElementById("_ctl0_Content_AuditSelector_Child");

            return childsRecordsLink;
        }

        private SessionElementScope GetCommentTextBox()
        {
            var commentTextBox = _Session.FindSessionElementById("_ctl0_Content_CommentText");

            return commentTextBox;
        }

        private SessionElementScope GetSubmitButton()
        {
            var submitButton = _Session.FindSessionElementById("_ctl0_Content_SubmitBut");

            return submitButton;
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
                    AuditText = auditDetailsColumns[_AuditTextIndex].Text,
                    User      = auditDetailsColumns[_UserIndex].Text,
                    Timestamp = auditDetailsColumns[_TimeStampIndex].Text.ToDate()
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

        internal void DisplayChildsAuditRecords(string child)
        {
            if (String.IsNullOrWhiteSpace(child)) throw new ArgumentNullException("child");

            bool childsRecordsSelectListExists = GetChildsRecordsSelectList().Exists(Config.ExistsOptions);
            bool childsRecordsLinkExists       = GetChildsRecordsLink()      .Exists(Config.ExistsOptions);

            if (!childsRecordsSelectListExists && !childsRecordsLinkExists)
            {
                throw new InvalidOperationException("No child audit records available");
            }

            if (childsRecordsSelectListExists)
            {
                var childsRecordsSelectList = GetChildsRecordsSelectList();

                childsRecordsSelectList.SelectOptionAlphanumericOnly(child);

                _Session.WaitUntilElementExists(GetAuditRecordsGrid);
            }
            else
            {
                var childsRecordsLink = GetChildsRecordsLink();

                childsRecordsLink.Click();
            } 
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

        private void WaitUntilCodedPathReceived(string fieldName)
        {
            if (String.IsNullOrWhiteSpace(fieldName)) throw new ArgumentNullException("fieldName");

            WaitUntilLatestChildRecordContains(fieldName, _CodedPathAuditTextPrefix);

            DisplayParentsAuditRecords();

            RetryPolicy.RaveCoderTransmission.Execute(() =>
            {
                var latestMatchingChildAuditRecord = GetChildAuditRecordsContaining(fieldName, _CodedPathAuditTextPrefix).FirstOrDefault();

                if (ReferenceEquals(latestMatchingChildAuditRecord, null) 
                || latestMatchingChildAuditRecord.AuditText.Contains(_TermCodedAuditTextPrefix, StringComparison.OrdinalIgnoreCase))
                {
                    DisplayParentsAuditRecords();
                    throw new MissingHtmlException(
                        String.Format("No coded path audit record for '{0}' in child '{1}'.", _CodedPathAuditTextPrefix, fieldName));
                }
            });
        }
        
        internal void WaitUntilTermSent(string fieldName)
        {
            if (String.IsNullOrWhiteSpace(fieldName)) throw new ArgumentNullException("fieldName");

            WaitUntilLatestChildRecordContains(fieldName, _TermSentAuditText);
        }

        internal string GetCodedPathFromAuditRecord(string fieldName)
        {
            if (String.IsNullOrWhiteSpace(fieldName)) throw new ArgumentNullException("fieldName");

            WaitUntilCodedPathReceived(fieldName);

            var codedPathAuditRecord = GetAuditRecordsContaining(_CodedPathAuditTextPrefix).First();

            string codedPath = codedPathAuditRecord.AuditText.Replace(_CodedPathAuditTextPrefix, "");

            return codedPath;
        }

        internal string GetQueryCommentFromAuditRecord(string fieldName)
        {
            if (String.IsNullOrWhiteSpace(fieldName)) throw new ArgumentNullException("fieldName");
            
            WaitUntilLatestChildRecordContains(fieldName, _QueryOpenedAuditTextPrefix);
            
            var queryOpenedAuditRecord = GetAuditRecordsContaining(_QueryOpenedAuditTextPrefix).First();

            var splitAuditRecordText = queryOpenedAuditRecord.AuditText.Split(new string[] {"'"}, StringSplitOptions.RemoveEmptyEntries);

            var queryComment = splitAuditRecordText.ElementAtOrDefault(1);

            if (String.IsNullOrWhiteSpace(queryComment))
            {
                throw new MissingHtmlException(String.Format("Query comment for {0} not found in audit record.", fieldName));
            }

            return queryComment;
        }

        internal IEnumerable<TermPathRow> GetCodingDecisionFromAuditRecord(string fieldName)
        {
            if (String.IsNullOrWhiteSpace(fieldName)) throw new ArgumentNullException("fieldName");
         
            string codedPath              = GetCodedPathFromAuditRecord(fieldName);
            
            var splitAuditRecordText      = codedPath.Split(new string[] { " - version " }, StringSplitOptions.RemoveEmptyEntries);

            var auditRecord               = splitAuditRecordText.ElementAtOrDefault(0);

            if (String.IsNullOrWhiteSpace(auditRecord))
            {
                throw new MissingHtmlException(String.Format("Coding Decision for {0} not found in audit record.", fieldName));
            }

            var codingLevel = auditRecord.Split(new string[] { ", " }, StringSplitOptions.RemoveEmptyEntries);

            var termPath    = new List<TermPathRow>();

            foreach (var level in codingLevel)
            {
                var terms         = level.Split(new string[] { ": " }, StringSplitOptions.RemoveEmptyEntries);
                var termPathLevel = new TermPathRow
                {
                    Level    = terms[0],
                    TermPath = terms[1]
                };

                termPath.Add(termPathLevel);
            }

            return termPath;
        }

        internal void AddEntry(string entry)
        {
            if (String.IsNullOrWhiteSpace(entry)) throw new ArgumentNullException("entry");

            var commentTextBox = GetCommentTextBox();

            commentTextBox.FillInWith(entry).SendKeys(Keys.Return);
        }
    }
}
