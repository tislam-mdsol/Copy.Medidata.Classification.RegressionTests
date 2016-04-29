using System;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using System.Linq;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.DeclarativeBrowser.Models.UIDataModels;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class AdminSynonymDetailsPage
    {
        private readonly BrowserSession _Session;

        private const int TermLiteralIndex = 0;
        private const int LastUserIndex    = 1;
        private const int LastUpdatedIndex = 2;
        private const int TermStatusIndex  = 3;
        private const int MasterTermIndex  = 4;

        private const string CompletedCodingDecisionsCountLabel  = "Completed Coding Decisions:";
        private const string InProgressCodingDecisionsCountLabel = "In Process Coding Decisions:";

        public const string StatusFilterOptionNone        = "Filter by Status";
        public const string StatusFilterOptionAll         = "All";
        public const string StatusFilterOptionProvisional = "Provisional";
        public const string StatusFilterOptionActive      = "Active";
        
        internal AdminSynonymDetailsPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Session = session;
        }

        private SessionElementScope GetStatusFilterSelectList()
        {
            var statusFilterSelectList = _Session.FindSessionElementById("ctl00_Content_ddlStatusACG_ddlStatuses");

            return statusFilterSelectList;
        }

        private SessionElementScope GetVerbatimOrTermSelectList()
        {
            var verbatimOrTermSelectList = _Session.FindSessionElementById("ctl00_Content_ddlFilterACG_ddlFilter");

            return verbatimOrTermSelectList;
        }

        private SessionElementScope GetSearchTextBox()
        {
            var searchTextBox = _Session.FindSessionElementById("ctl00_Content_acg2_searchString");

            return searchTextBox;
        }

        private SessionElementScope GetSearchButton()
        {
            var searchButton = _Session.FindSessionElementById("ctl00_Content_acg2_SearchButtonLnk");

            return searchButton;
        }

        private SessionElementScope GetRetireSynonymsButton()
        {
            var retireSynonymsButton = _Session.FindSessionElementById("ctl00_Content_RetireSynonyms");

            return retireSynonymsButton;
        }

        private SessionElementScope GetRetireReconsiderDialog()
        {
            var retireReconsiderDialog =
                _Session.FindSessionElementById("ctl00_Content_pcRetireWarning_retireWarning");

            return retireReconsiderDialog;
        }

        private IList<SessionElementScope> GetRetireReconsiderDialogTextElements()
        {
            var retireReconsiderDialog = GetRetireReconsiderDialog();

            return retireReconsiderDialog.FindAllSessionElementsByXPath("./div");
        }

        private SessionElementScope GetRetireReconsiderButton()
        {
            var retireSynonymsButton =
                _Session.FindSessionElementById("ctl00_Content_pcRetireWarning_retireWarning_reconsiderCompletedBtn");

            return retireSynonymsButton;
        }

        private SessionElementScope GetRetireCancelButton()
        {
            var retireSynonymsButton =
                _Session.FindSessionElementById("ctl00_Content_pcRetireWarning_retireWarning_cancelBtn");

            return retireSynonymsButton;
        }

        internal int GetCompletedCodingDecisionsCount()
        {
            var retireReconsiderDialogTextElements = GetRetireReconsiderDialogTextElements();

            string completedCodingDecisionsCount = retireReconsiderDialogTextElements
                .Select(x => x.Text)
                .FirstOrDefault(x => x.Contains(CompletedCodingDecisionsCountLabel));

            if (String.IsNullOrWhiteSpace(completedCodingDecisionsCount))
            {
                throw new NullReferenceException("Completed Coding Decisions count was not available.");
            }
            
            return completedCodingDecisionsCount.Split(':')[1].ToInteger();
        }

        internal int GetInProgressCodingDecisionsCount()
        {
            var retireReconsiderDialogTextElements = GetRetireReconsiderDialogTextElements();

            string inProgressCodingDecisionsCount = retireReconsiderDialogTextElements
                .Select(x => x.Text)
                .FirstOrDefault(x => x.Contains(InProgressCodingDecisionsCountLabel));
        
            if (String.IsNullOrWhiteSpace(inProgressCodingDecisionsCount))
            {
                throw new NullReferenceException("In Progress Coding Decisions count was not available.");
            }

            return inProgressCodingDecisionsCount.Split(':')[1].ToInteger();
        }

        private SessionElementScope GetSynonymsTable()
        {
            var synonymsTable = _Session.FindSessionElementById("ctl00_Content_synDetails_DXMainTable");

            return synonymsTable;
        }

        private IList<SessionElementScope> GetSynonymDetailsRowElements()
        {
            var synonymTable = GetSynonymsTable();
            var synonymRows =
                synonymTable.FindAllSessionElementsByXPath(
                    ".//tr[starts-with(@id,'ctl00_Content_synDetails_DXDataRow')]");

            return synonymRows;
        }

        private SessionElementScope GetSynonymDetailsRowElement(string termLiteral)
        {
            if (String.IsNullOrWhiteSpace(termLiteral)) throw new ArgumentNullException("termLiteral");

            var synonymTermLiterals = GetSynonymDetailsRowElements()
                .Select(synonymRowElement => synonymRowElement.FindAllSessionElementsByXPath("td"))
                .Where(synonymRowElement => synonymRowElement[TermLiteralIndex].Text.EqualsIgnoreCase(termLiteral))
                .Select(synonymRowElement => synonymRowElement[TermLiteralIndex]).ToList();

            if (synonymTermLiterals.Count > 1)
            {
                throw new InvalidOperationException(
                    String.Format("synonymRowElements contains more than one term literal, {0}", termLiteral));
            }

            if (!synonymTermLiterals.Any())
            {
                return null;
            }

            return synonymTermLiterals[0];
        }

        private SynonymRow[] GetSynonymRows()
        {
            var synonymRowElements = GetSynonymDetailsRowElements();
            var rowCount           = synonymRowElements.Count;
            var synonymRows        = new SynonymRow[rowCount];

            for (int i = 0; i < rowCount; i++)
            {
                var synonymRowColumns = synonymRowElements[i].FindAllSessionElementsByXPath("td");
                synonymRows[i] = new SynonymRow()
                {
                    Verbatim             = synonymRowColumns[TermLiteralIndex].Text,
                    CodedBy              = synonymRowColumns[LastUserIndex].Text,
                    Status               = GetSynonymStatus(synonymRowColumns[TermStatusIndex].Text),
                    CreationDate         = synonymRowColumns[LastUpdatedIndex].Text,

                    SelectedTermPathRow  = TermPathRowDisplay
                        .GetSelectedCodingHistoryTermPathRow(synonymRowColumns[MasterTermIndex]),

                    ExpandedTermPathRows = TermPathRowDisplay
                        .GetExpandedCodingHistoryTermPathRows(synonymRowColumns[MasterTermIndex])
                };
            }

            return synonymRows;
        }

        internal IList<SynonymRow> GetSynonymsDetails(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");

            ExecuteSynonymDetailSearch(synonymSearch);

            var synonymRows = GetSynonymRows().ToList();

            return synonymRows;
        }

        internal SynonymRow GetSynonymDetails(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null)) throw new ArgumentNullException("synonymSearch");
            
            var synonymRows = GetSynonymsDetails(synonymSearch);

            var synonymRow = synonymRows.FirstOrDefault(
                x => x.Verbatim.Equals(synonymSearch.SearchText, StringComparison.OrdinalIgnoreCase));

            return synonymRow;
        }

        private SynonymStatus GetSynonymStatus(string status)
        {
            if (String.IsNullOrWhiteSpace(status)) throw new ArgumentNullException("status");

            if (status.Equals("active", StringComparison.OrdinalIgnoreCase))
            {
                return SynonymStatus.Approved;
            }
            if (status.Equals("provisional", StringComparison.OrdinalIgnoreCase))
            {
                return SynonymStatus.Provisional;
            }

            throw new ArgumentException(String.Format("Status {0} is invalid", status));
        }

        internal void FindAndRetireSynonym(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");

            FindAndBeginRetiringSynonym(verbatim);

            GetRetireReconsiderButton().Click();
        }

        internal void FindAndBeginRetiringSynonym(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim");

            ExecuteSynonymDetailSearch(verbatim);

            GetSynonymDetailsRowElement(verbatim).Click();
            GetRetireSynonymsButton().Click();
            WaitUntilFinishLoading();
        }

        private void ExecuteSynonymDetailSearch(string searchText)
        {
            if (String.IsNullOrEmpty(searchText)) throw new ArgumentNullException("SearchText");

            SynonymSearch synonymSearch = new SynonymSearch
            {
                SearchText = searchText
            };

            ExecuteSynonymDetailSearch(synonymSearch);
        }

        private void ExecuteSynonymDetailSearch(SynonymSearch synonymSearch)
        {
            if (ReferenceEquals(synonymSearch, null))           throw new ArgumentNullException("synonymSearch");
            if (String.IsNullOrEmpty(synonymSearch.SearchText)) throw new ArgumentNullException("synonymSearch.SearchText");

            if (String.IsNullOrEmpty(synonymSearch.Status))
            {
                synonymSearch.Status = "All";
            }

            if (String.IsNullOrEmpty(synonymSearch.SearchBy))
            {
                synonymSearch.SearchBy = "By Verbatim";
            }

            GetStatusFilterSelectList().SelectOptionAlphanumericOnly(synonymSearch.Status);
            WaitUntilFinishLoading();

            GetVerbatimOrTermSelectList().SelectOption(synonymSearch.SearchBy);
            WaitUntilFinishLoading();

            GetSearchTextBox().FillInWith(synonymSearch.SearchText);
            GetSearchButton().Click();
            WaitUntilFinishLoading();
        }

        private void WaitUntilFinishLoading()
        {
            _Session.WaitUntilElementDisappears(GetLoadingIndicator);
        }

        private SessionElementScope GetLoadingIndicator()
        {
            var loadingIndicator = _Session.FindSessionElementByXPath("//*[contains(@id, '_LPV')]");

            return loadingIndicator;
        }
    }
}
