using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu;
using NUnit.Framework;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal class DictionarySelectionPanel
    {
        private readonly BrowserSession _Browser;

        internal DictionarySelectionPanel(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null))
            {
                throw new ArgumentNullException("browser");
            }

            _Browser = browser;
        }

        private SessionElementScope GetDictionarySelectionPanel()
        {
            var dictionarySelectionPanel = _Browser.FindSessionElementById("selected-dictionary-term");

            return dictionarySelectionPanel;
        }

        private SessionElementScope GetTermPropertiesTable()
        {
            var propertiesTable = _Browser.FindSessionElementById("propertiesData");

            return propertiesTable;
        }

        private SessionElementScope GetCodeProperty()
        {
            var dictionarySelectionPanel  = GetDictionarySelectionPanel();
            var codeProperty              = dictionarySelectionPanel.FindSessionElementById("propertiesCode");

            return codeProperty;
        }

        private SessionElementScope GetTermProperty()
        {
            var dictionarySelectionPanel  = GetDictionarySelectionPanel();
            var termProperty              = dictionarySelectionPanel.FindSessionElementById("propertiesTerm");

            return termProperty;
        }

        private SessionElementScope GetLevelProperty()
        {
            var dictionarySelectionPanel  = GetDictionarySelectionPanel();
            var levelProperty             = dictionarySelectionPanel.FindSessionElementById("propertiesLevel");

            return levelProperty;
        }

        private SessionElementScope GetViewMorePropertiesButton()
        {
            var dictionarySelectionPanel  = GetDictionarySelectionPanel();
            var viewMorePropertiesButton  = dictionarySelectionPanel.FindSessionElementById("viewMoreCodingTaskProperties");

            return viewMorePropertiesButton;
        }

        private SessionElementScope GetSynonymTable()
        {
            var dictionarySelectionPanel  = GetDictionarySelectionPanel();
            var synonymsTable             = dictionarySelectionPanel.FindSessionElementById("synonymTable");

            return synonymsTable;
        }

        private SessionElementScope GetCreateSynonymCheckbox()
        {
            var dictionarySelectionPanel  = GetDictionarySelectionPanel();
            var createSynonymCheckbox     = dictionarySelectionPanel.FindSessionElementById("createTermPathSynonym");

            return createSynonymCheckbox;
        }

        private bool CheckCreateSynonymCheckboxExists()
        {
            var dictionarySelectionPanel = GetDictionarySelectionPanel();
            return dictionarySelectionPanel.FindSessionElementById("createTermPathSynonym").Exists(Config.ExistsOptions);
        }

        private SessionElementScope GetCodeAndNextButton()
        {
            var dictionarySelectionPanel  = GetDictionarySelectionPanel();
            var codeAndNextButton         = dictionarySelectionPanel.FindSessionElementById("codeToTermPathAndNext");

            return codeAndNextButton;
        }

        private SessionElementScope GetCodeButton()
        {
            var dictionarySelectionPanel  = GetDictionarySelectionPanel();
            var codeButton                = dictionarySelectionPanel.FindSessionElementById("codeToTermPath");

            return codeButton;
        }

        private SessionElementScope GetTaskInformation()
        {
            var dictionarySelectionPanel  = GetDictionarySelectionPanel();
            var taskInformation           = dictionarySelectionPanel.FindSessionElementById("task-information");

            return taskInformation;
        }

        private SessionElementScope GetCommentHistoryTable()
        {
            var getMoreComments = GetViewMoreCommentHistoryButton();

            if (getMoreComments.Exists())
            {
                getMoreComments.Click();
            }

            var dictionarySelectionPanel = GetDictionarySelectionPanel();
            var commentHistoryTable      = dictionarySelectionPanel.FindSessionElementById("commentHistoryTable");

            return commentHistoryTable;
        }

        private SessionElementScope GetViewMoreCommentHistoryButton()
        {
            var dictionarySelectionPanel  = GetDictionarySelectionPanel();
            var viewMoreCommentsButton    = dictionarySelectionPanel.FindSessionElementById("viewMoreCodingTaskComments");

            return viewMoreCommentsButton;
        }

        private SessionElementScope GetTaskPropertiesTable()
        {
            var dictionarySelectionPanel = GetDictionarySelectionPanel();
            var taskPropertiesTable      = dictionarySelectionPanel.FindSessionElementByXPath("div[@id='task-properties']//table");

            return taskPropertiesTable;
        }

        private IList<SessionElementScope> GetTaskHistoryItems()
        {
            var dictionarySelectionPanel  = GetDictionarySelectionPanel();
            var viewMoreTaskHistoryButton = GetViewMoreTaskHistoryButton();

            if (viewMoreTaskHistoryButton.Exists())
            {
                viewMoreTaskHistoryButton.Click();
            }

            var taskHistory = 
                dictionarySelectionPanel
                .FindAllSessionElementsByXPath("div[contains(@ng-repeat,'historyRow in vm.history')]");

            return taskHistory;
        }

        private SessionElementScope GetTaskHistoryItem(int historyIndex)
        {
            if (historyIndex < 0) throw new ArgumentOutOfRangeException("historyIndex");

            var taskHistoryItems = GetTaskHistoryItems();

            if (!ReferenceEquals(taskHistoryItems.ElementAtOrDefault(historyIndex), null))
            {
                var taskHistoryItem = taskHistoryItems[historyIndex];

                return taskHistoryItem;
            }
            else
            {
                return null;
            }
        }

        private SessionElementScope GetTaskHistoryUsername(int historyIndex)
        {
            if (historyIndex < 0) throw new ArgumentOutOfRangeException("historyIndex");

            var historyItem = GetTaskHistoryItem(historyIndex);
            var username    = historyItem.FindSessionElementByXPath("h4");

            return username;
        }

        private SessionElementScope GetTaskHistoryTimeStamp(int historyIndex)
        {
            if (historyIndex < 0) throw new ArgumentOutOfRangeException("historyIndex");

            var historyItem = GetTaskHistoryItem(historyIndex);
            var timeStamp   = historyItem.FindSessionElementByXPath("h4/small");

            return timeStamp;
        }

        private SessionElementScope GetTaskHistoryComment(int historyIndex)
        {
            if (historyIndex < 0) throw new ArgumentOutOfRangeException("historyIndex");

            var historyItem = GetTaskHistoryItem(historyIndex);
            var comment     = historyItem.FindSessionElementByXPath("(div)[1]/span");

            return comment;
        }

        private SessionElementScope GetTaskHistoryWorkflowState(int historyIndex)
        {
            if (historyIndex < 0) throw new ArgumentOutOfRangeException("historyIndex");

            var historyItem   = GetTaskHistoryItem(historyIndex);
            var workflowState = historyItem.FindSessionElementByXPath("(div)[2]/span");

            return workflowState;
        }

        private SessionElementScope GetTaskHistoryVerbatim(int historyIndex)
        {
            if (historyIndex < 0) throw new ArgumentOutOfRangeException("historyIndex");

            var historyItem = GetTaskHistoryItem(historyIndex);
            var verbatim    = historyItem.FindSessionElementByXPath("(div)[3]/span");

            return verbatim;
        }

        private SessionElementScope GetTaskHistoryCodingPath(int historyIndex)
        {
            if (historyIndex < 0) throw new ArgumentOutOfRangeException("historyIndex");

            var historyItem = GetTaskHistoryItem(historyIndex);
            var codingPath  = historyItem.FindSessionElementByXPath("(div)[4]/span");

            return codingPath;
        }

        private SessionElementScope GetViewMoreTaskHistoryButton()
        {
            var dictionarySelectionPanel  = GetDictionarySelectionPanel();
            var viewMoreTaskHistoryButton = dictionarySelectionPanel.FindSessionElementById("viewMoreCodingTaskHistories");

            return viewMoreTaskHistoryButton;
        }

        internal DictionarySelectedSearchResult GetSelectedSearchResultData()
        {
            var selectedSearchResultData = new DictionarySelectedSearchResult()
            {
                Properties = GetTermProperties(),
                CanBeCoded = CanTermBeCoded()
            };

            selectedSearchResultData.Synonyms = GetSelectedTermSynonyms(selectedSearchResultData.Properties);

            return selectedSearchResultData;
        }

        private SynonymRow[] GetSelectedTermSynonyms(IDictionary<string,string> properties)
        {
            if (ReferenceEquals(properties, null)) throw new ArgumentNullException("properties");

            var synonymTuples = GetSynonymTuples();
            var count         = synonymTuples.Length;
            var synonymRows   = new SynonymRow[count];

            for(int i = 0; i < count; i++)
            {
                synonymRows[i] = new SynonymRow()
                {
                    Verbatim            = synonymTuples[i].Item1,
                    Status              = SynonymDisplay.GetSynonymStatus(synonymTuples[i].Item2),
                    SelectedTermPathRow = GetSelectedTermPathRow(properties)
                };
            }

            return synonymRows;
        }

        private TermPathRow GetSelectedTermPathRow(IDictionary<string,string> properties)
        {
            if (ReferenceEquals(properties,null)) throw new ArgumentNullException("properties");

            var term = new TermPathRow()
            {
                Code     = properties["code"],
                TermPath = properties["term"],
                Level    = properties["level"]
            };

            return term;
        }

        private bool CanTermBeCoded()
        {
            var codeButton = GetCodeButton();

            var buttonExistsAndIsNotDisabled = codeButton.Exists(Config.ExistsOptions)
                                               && !codeButton.Disabled;

            return buttonExistsAndIsNotDisabled;
        }

        private IDictionary<string, string> GetTermProperties()
        {
            if (GetViewMorePropertiesButton().Exists(Config.ExistsOptions))
            {
                GetViewMorePropertiesButton().Click();
            }

            var propertiesTable = GetTermPropertiesTable();
            var propertyRows    = propertiesTable.FindAllSessionElementsByXPath("tr");

            var propertiesDictionary = propertyRows.ToDictionary(
                property => property.FindSessionElementByXPath("td[1]").Text,
                property => property.FindInvisibleElementTextByXPath("td[2]"),
                StringComparer.OrdinalIgnoreCase);

            return propertiesDictionary;
        }

        private Tuple<string, string>[] GetSynonymTuples()
        {
            var synonymsTable   = GetSynonymTable();
            var synonymElements = synonymsTable.FindAllSessionElementsByXPath("(tbody/tr)[position()>1] ");

            var synonyms = (from e in synonymElements
                select Tuple.Create(
                    e.FindSessionElementByXPath("td[1]").Text,
                    e.FindSessionElementByXPath("td[2]").Text)).ToArray();

            return synonyms;
        }

        private Tuple<string, string>[] GetCommentHistoryItems()
        {
            var commentsTable   = GetCommentHistoryTable();
            var commentElements = commentsTable.FindAllSessionElementsByXPath("(tbody/tr)[position()>1] ");

            var comments = (from e in commentElements
                            select Tuple.Create(
                                e.FindSessionElementByXPath("td[1]").Text,
                                e.FindSessionElementByXPath("td[2]").Text)).ToArray();
            return comments;
        }

        private IDictionary<string, string> GetTaskProperties()
        {
            var taskPropertiesTable  = GetTaskPropertiesTable();
            var taskPropertyElements = taskPropertiesTable.FindAllSessionElementsByXPath("tbody/tr");

            var taskProperties = taskPropertyElements.ToDictionary(
                e => e.FindSessionElementByXPath("td[1]").Text,
                e => e.FindSessionElementByXPath("td[2]").Text);

            return taskProperties;
        }

        internal void CodeSelectedTerm(bool createSynonym)
        {
            _Browser.WaitUntilElementIsActive(GetCodeButton);

            if (CheckCreateSynonymCheckboxExists())
            {
                var createSynonymCheckbox = GetCreateSynonymCheckbox();
                createSynonymCheckbox.SetCheckBoxState(createSynonym.ToString());
            }

            GetCodeButton().Click();
        }

        internal void CodeSelectedTermAndNext(bool createSynonym)
        {
           _Browser.WaitUntilElementIsActive(GetCodeAndNextButton);

            if (CheckCreateSynonymCheckboxExists())
            {
                var createSynonymCheckbox = GetCreateSynonymCheckbox();
                createSynonymCheckbox.SetCheckBoxState(createSynonym.ToString());
            }
            GetCodeAndNextButton().Click();
            _Browser.WaitUntilElementDisappears(GetCodeAndNextButton);
        }
    }
}