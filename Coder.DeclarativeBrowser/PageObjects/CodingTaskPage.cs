using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using OpenQA.Selenium;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.Models;
using FluentAssertions;
using System.Text.RegularExpressions;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class CodingTaskPage
    {
        private readonly BrowserSession _Session;

        private const string _PageName = "Tasks";

        private const int VerbatimTermIndex = 0;
        private const int GroupIndex        = 1;
        private const int PriorityIndex     = 2;
        private const int StatusIndex       = 3;
        private const int AssignedTermIndex = 4;
        private const int DictionaryIndex   = 5;
        private const int QueriesIndex      = 6;
        private const int TimeElapsIndex    = 7;

        private readonly static Dictionary<string,int> HeaderToIndexMap = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase)
        {
            {"Verbatim Term", VerbatimTermIndex},
            {"Group"        , GroupIndex       },
            {"Priority"     , PriorityIndex    },
            {"Status"       , StatusIndex      },
            {"Assigned Term", AssignedTermIndex},
            {"Dictionary"   , DictionaryIndex  },
            {"Queries"      , QueriesIndex     },
            {"Time Elapsed" , TimeElapsIndex   }
        };

        internal CodingTaskPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        internal bool OnThisPage()
        {
            var browserTitle = _Session.Title;
            var onThisPage   = browserTitle.Equals(_PageName, StringComparison.OrdinalIgnoreCase);

            return onThisPage;
        }

        internal void GoTo()
        {
            var onThisPage = OnThisPage();
            if (!onThisPage)
            {
                _Session.ClickLink("Tasks");
            }
        }

        internal void LoadPage()
        {
            var tasksLink = _Session.FindSessionElementByLink("Tasks");
            if (tasksLink.Exists(Config.ExistsOptions))
            {
                var attempt = RetryPolicy.FindElementShort.ExecuteAndCapture(
                    () =>
                    tasksLink.Click()
                );
            }
        }

        internal SessionElementScope GetContextHelpLink()
        {
            var contextHelpButton = _Session.FindSessionElementByXPath("//a[@id='LnkHelpImage']");

            return contextHelpButton;
        }

        internal SessionElementScope GetTasksTab()
        {
            var tasksTab = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_taskLink']");

            return tasksTab;
        }

        internal SessionElementScope GetBrowserTab()
        {
            var browserTab = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_browserLink']");

            return browserTab;
        }

        internal SessionElementScope GetReportsTab()
        {
            var reportsTab = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_reportLink']");

            return reportsTab;
        }

        internal SessionElementScope GetAdministrationTab()
        {
            var administrationTab = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_navMenuLink']");

            return administrationTab;
        }

        internal SessionElementScope GetSearchTaskTextBox()
        {
            var searchTaskTextBox = _Session.FindSessionElementByXPath("//input[@id = 'ctl00_Content_TxtSearch']");

            return searchTaskTextBox;
        }

        private SessionElementScope GetClearFilterLink()
        {
            var clearFilterLink = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_clearFilters']");

            return clearFilterLink;
        }

        internal SessionElementScope GetTaskGrid()
        {
            var taskGrid = _Session.FindSessionElementByXPath("//table[@id = 'ctl00_Content_gridElements_DXMainTable']");

            return taskGrid;
        }

        internal bool TabContentFormExists()
        {
            // The form1 object only exists on the visible tab, so check each tab.
            bool sourceTermTabContentFormExists          = SpecificTabContentFormExists(_Session.GetTaskPageSourceTermTab()   .GetSourceTermFrame);
            bool sourcePropertiesTabContentFormExists    = SpecificTabContentFormExists(_Session.GetTaskPagePropertiesTab()   .GetPropertiesFrame);
            bool sourceAssignmentsTabContentFormExists   = SpecificTabContentFormExists(_Session.GetTaskPageAssigmentsTab()   .GetAssignmentFrame);
            bool sourceCodingHistoryTabContentFormExists = SpecificTabContentFormExists(_Session.GetTaskPageCodingHistoryTab().GetCodingHistoryFrame);
            bool sourceQueryHistoryTabContentFormExists  = SpecificTabContentFormExists(_Session.GetTaskPageQueryHistoryTab() .GetQueryHistoryFrame);
            
            return sourceTermTabContentFormExists          ||
                   sourcePropertiesTabContentFormExists    ||
                   sourceAssignmentsTabContentFormExists   ||
                   sourceCodingHistoryTabContentFormExists ||
                   sourceQueryHistoryTabContentFormExists;
        }

        private bool SpecificTabContentFormExists(Func<SessionElementScope> getTabContentFrame)
        {
            // The form1 object only exists on the visible tab. Check if the tab exists before the form check to prevent waiting a minute for the timeout.
            return getTabContentFrame()
                .Exists(Config.ExistsOptions)
                &&
                getTabContentFrame()
                .FindSessionElementByXPath("//*[@id='form1']")
                .Exists(Config.ExistsOptions);
        }

        internal SessionElementScope GetSourceTermsTab()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var sourceTermsTab = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_tab0']");

            return sourceTermsTab;
        }

        internal SessionElementScope GetPropertiesTab()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var propertiesTab = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_tab1']");

            return propertiesTab;
        }

        internal SessionElementScope GetAssignmentsTab()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var assignmentsTab = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_tab2']");

            return assignmentsTab;
        }

        internal SessionElementScope GetCodingHistoryTab()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var codingHistoryTab = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_tab3']");

            return codingHistoryTab;
        }

        internal SessionElementScope GetQueryHistoryTab()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var queryHistoryTab = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_tab4']");

            return queryHistoryTab;
        }

        internal SessionElementScope GetActionButtonsFrame()
        {

            var actionButtonsFrame = _Session.FindSessionElementById("ctl00_Content_UpActions_TblActionButtons");

            return actionButtonsFrame;
        }

        internal SessionElementScope GetBrowseCodeButton()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var browseCodeButton = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_UpActions__LnkBtnBrowse_2']");

            return browseCodeButton;
        }

        internal SessionElementScope GetReCodeButton()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var reCodeButton = _Session.FindSessionElementByXPath("//a[@id ='ctl00_Content_UpActions__Btn_5']");

            return reCodeButton;
        }

        internal SessionElementScope GetApproveButton()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var approveButton = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_UpActions__Btn_6']");

            return approveButton;
        }

        internal SessionElementScope GetOpenQueryButton()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var openQueryButton = _Session.FindSessionElementByXPath("//a[@id ='ctl00_Content_UpActions__Btn_3']");

            return openQueryButton;
        }

        internal bool DoesOpenQueryButtonExist()
        {
            return GetOpenQueryButton().Exists(Config.ExistsOptions);
        }

        internal bool IsOpenQueryButtonEnabled()
        {
            return DoesOpenQueryButtonExist() && !GetOpenQueryButton().Disabled;
        }

        private SessionElementScope GetCancelQueryButton()
        {
            var openQueryButton = _Session.FindSessionElementByXPath("//a[@id ='ctl00_Content_UpActions__Btn_15']");

            return openQueryButton;
        }

        internal bool DoesCancelQueryButtonExist()
        {
            return GetCancelQueryButton().Exists(Config.ExistsOptions);
        }

        internal bool IsCancelQueryButtonEnabled()
        {
            return DoesCancelQueryButtonExist() && !GetCancelQueryButton().Disabled;
        }

        internal SessionElementScope GetAddCommentButton()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var addCommentButton = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_UpActions__Btn_13']");

            return addCommentButton;
        }

        internal SessionElementScope GetViewGroupButton()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var viewGroupButton = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_UpActions_LookInsideGroup']");

            return viewGroupButton;
        }

        internal SessionElementScope GetActionButtons(string actionName)
        {
            var getActionButtons = _Session.FindSessionElementByXPath(string.Format("//a[contains(@id, 'ctl00_Content_UpActions') and b/span/u[contains(text(), '{0}')]]", actionName));

            return getActionButtons;
           
        }

        internal SessionElementScope GetReasonTextArea()
        {
            var reasonTextArea = _Session.FindSessionElementByXPath("//textarea[@id = 'txtComment']");

            return reasonTextArea;
        }

        internal SessionElementScope GetReasonOkButton()
        {
            var reasonOkButton = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_pcReason_BtnActionOk']");

            return reasonOkButton;
        }

        internal SessionElementScope GetLeaveAsIsButton()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var leaveAsIsButton = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_UpActions__Btn_11']");

            return leaveAsIsButton;
        }

        internal SessionElementScope GetRejectCodingDecisionButton()
        {
            if (!GetIsTaskGridPopulated())
            {
                return null;
            }

            var rejectCodingDecisionButton = _Session.FindSessionElementByXPath("//a[@id = 'ctl00_Content_UpActions__Btn_12']");

            return rejectCodingDecisionButton;
        }

        internal bool GetIsTaskGridPopulated()
        {
            var isTaskGridEmpty =
                _Session.FindSessionElementByXPath(
                    "//table[@id = 'ctl00_Content_gridElements_DXMainTable']/tbody/tr[contains(@id, 'ctl00_Content_gridElements_DXDataRow0')]")
                    .Exists(Config.ExistsOptions);

            return isTaskGridEmpty;
        }

        internal string GetSelectedTabName()
        {
            var selectedTabName =
                _Session.FindSessionElementByXPath(
                    "//tr[@tabcontrolid='ctl00_Content_TabContainer1']/td/a[contains(@id, 'ctl00_Content_tab') and @class = 'selectedTabLink']")
                    .Text;

            return selectedTabName;
        }

        private void ViewGroupByVerbatimName(string verbatim, string group = null)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            
            if (String.IsNullOrEmpty(group))
            {
                SelectTaskGridByVerbatimName(verbatim);
            }
            else
            {
                SelectTaskGridByVerbatimNameAndAdditionalField(verbatim, "group", group);
            }

            _Session.WaitUntilElementExists(GetViewGroupButton);

            GetViewGroupButton().Click();
        }

        private SessionElementScope GetTaskGridVerbatimElementByVerbatimTerm(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            var codingTaskGridDataRows = GetCodingTaskGridDataRows()
               .Select(codingTaskGridRow => codingTaskGridRow.FindAllSessionElementsByXPath("td"))
               .Where(codingTaskGridRow => codingTaskGridRow[VerbatimTermIndex].Text.EqualsIgnoreCase(verbatim))
               .Select(codingTaskGridRow => codingTaskGridRow[VerbatimTermIndex]).ToList();

            if (codingTaskGridDataRows.Count > 1)
            {
                throw new InvalidOperationException(String.Format("codingTaskGridDataRows contains more than one task with verbatim, {0}.", verbatim));
            }

            if (!codingTaskGridDataRows.Any())
            {
                return null;
            }

            return codingTaskGridDataRows[0];
        }

        private SessionElementScope SearchForTaskGridVerbatimElementByVerbatimTerm(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            if (ReferenceEquals(GetTaskGridVerbatimElementByVerbatimTerm(verbatim), null))
            {
                GetSearchTaskTextBox().FillInWith(verbatim).SendKeys(Keys.Return);

                ClickFilterButtonUntilTaskGridTermIsAvailable(verbatim);
            }

            return GetTaskGridVerbatimElementByVerbatimTerm(verbatim);
        }

        private SessionElementScope GetTaskGridVerbatimElementByVerbatimTermAndAdditionalField(string verbatim, string field, string value)
        {
            if (String.IsNullOrEmpty(verbatim))      throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(field))         throw new ArgumentNullException("field");
            if (String.IsNullOrEmpty(value))         throw new ArgumentNullException("value");
            if(!HeaderToIndexMap.ContainsKey(field)) throw new KeyNotFoundException("field");

            var codingTaskGridDataRows = GetCodingTaskGridDataRows()
                .Select(codingTaskGridRow => codingTaskGridRow.FindAllSessionElementsByXPath("td"))
                .Where(codingTaskGridRow => codingTaskGridRow[VerbatimTermIndex].Text.EqualsIgnoreCase(verbatim) &&
                                            codingTaskGridRow[HeaderToIndexMap[field]].Text.EqualsIgnoreCase(value))
                .Select(codingTaskGridRow => codingTaskGridRow[VerbatimTermIndex]).ToList();

            if (codingTaskGridDataRows.Count > 1)
            {
                throw new InvalidOperationException(String.Format("codingTaskGridDataRows contains more than one verbatim, {0}, with {1} {2}.", verbatim, field, value));
            }

            if (!codingTaskGridDataRows.Any())  
            {
                return null;
            }
            
            return codingTaskGridDataRows[0];
        }

        private SessionElementScope SearchForTaskGridVerbatimElementByVerbatimTermAndAdditionalField(string verbatim, string field, string value)
        {
            if (String.IsNullOrEmpty(verbatim))       throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(field))          throw new ArgumentNullException("field");
            if (String.IsNullOrEmpty(value))          throw new ArgumentNullException("value");
            if (!HeaderToIndexMap.ContainsKey(field)) throw new KeyNotFoundException("field");

            if (ReferenceEquals(GetTaskGridVerbatimElementByVerbatimTermAndAdditionalField(verbatim, field, value), null))
            {
                GetSearchTaskTextBox().FillInWith(verbatim).SendKeys(Keys.Return);

                ClickFilterButtonUntilTaskGridTermAndAdditionalFieldIsAvailable(verbatim, field, value);
            }

            return GetTaskGridVerbatimElementByVerbatimTermAndAdditionalField(verbatim, field, value);
        }

        private void ClickFilterButtonUntilTaskGridTermIsAvailable(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            
            var options = Config.GetDefaultTransmissionOptions();

            try
            {
                _Session.TryUntil(
                    () => GetFilterButton().Click(),
                    () => !ReferenceEquals(GetTaskGridVerbatimElementByVerbatimTerm(verbatim), null),
                    options.WaitBeforeClick,
                    options);
            }
            catch (MissingHtmlException)
            {
                Console.WriteLine(
                    "\n\nUnable to find task. Could be an error when uploading ODM where task stuck in Start status or incorrect browse and code configuration.\n");
                throw new MissingHtmlException(
                    "Unable to find task. Could be an error when uploading ODM where task stuck in Start status or incorrect browse and code configuration.");
            }
        }

        private void ClickFilterButtonUntilTaskGridTermAndAdditionalFieldIsAvailable(string verbatim, string field, string value)
        {
            if (String.IsNullOrEmpty(verbatim))       throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(field))          throw new ArgumentNullException("field");
            if (String.IsNullOrEmpty(value))          throw new ArgumentNullException("value");
            if (!HeaderToIndexMap.ContainsKey(field)) throw new KeyNotFoundException("field");

            var options = Config.GetDefaultTransmissionOptions();

            try
            {
                _Session.TryUntil(
                    () => GetFilterButton().Click(),
                    () => !ReferenceEquals(GetTaskGridVerbatimElementByVerbatimTermAndAdditionalField(verbatim, field, value), null),
                    options.WaitBeforeClick,
                    options);
            }
            catch (MissingHtmlException)
            {
                Console.WriteLine(
                    "\n\nUnable to find task. Could be an error when uploading ODM where task stuck in Start status or incorrect browse and code configuration.\n");
                throw new MissingHtmlException(
                    "Unable to find task. Could be an error when uploading ODM where task stuck in Start status or incorrect browse and code configuration.");
            }
        }

        internal SessionElementScope GetTaskGridSelectedRow()
        {
            var selectedRowElement = GetTaskGrid().FindSessionElementByXPath("//tbody/tr[@class='dxgvSelectedRow_Main_Theme']");

            return selectedRowElement;
        }

        internal CodingTask GetSelectedCodingTask()
        {
            if (GetCodingTaskGridDataRows().Count == 0)
            {
                return null;
            }
            var codingTaskColumns  = GetTaskGridSelectedRow().FindAllSessionElementsByXPath("td");
            var selectedCodingTask = new CodingTask
            {
                VerbatimTerm = codingTaskColumns[VerbatimTermIndex].Text,
                Group        = codingTaskColumns[GroupIndex].Text,
                Priority     = codingTaskColumns[PriorityIndex].Text,
                Status       = codingTaskColumns[StatusIndex].Text,
                AssignedTerm = codingTaskColumns[AssignedTermIndex].Text,
                Dictionary   = codingTaskColumns[DictionaryIndex].Text,
                Queries      = codingTaskColumns[QueriesIndex].Text,
                TimeElaps    = codingTaskColumns[TimeElapsIndex].Text
            };

            return selectedCodingTask;
        }

        internal SessionElementScope GetSourceSystemDropdown()
        {
            var sourceSystemDropdown = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_DdlSourceSystems\"]");

            return sourceSystemDropdown;
        }

        internal SessionElementScope GetStudiesDropdown()
        {
            var studiesDropdown = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_DdlTrackables\"]");

            return studiesDropdown;
        }

        internal SessionElementScope GetTrackablesDropdown()
        {
            var trackablesDropdown = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_DdlMultiView\"]");

            return trackablesDropdown;
        }

        internal void SetTaskFilters(string sourceSystemFilterCriteria, string studiesFilterCriteria, string trackablesFilterCriteria)
        {
            // The filter criteria may be empty or null, to signal that the filter should remain unchanged.
            SelectTaskFilterOption(GetSourceSystemDropdown(), sourceSystemFilterCriteria);
            SelectTaskFilterOption(GetStudiesDropdown()     , studiesFilterCriteria);
            SelectTaskFilterOption(GetTrackablesDropdown()  , trackablesFilterCriteria);
        }

        private void SelectTaskFilterOption(SessionElementScope dropDown, string targetOption)
        {
            if (ReferenceEquals(dropDown, null)) throw new ArgumentNullException("dropDown");

            // The filter criteria may be empty or null, to signal that the filter should remain unchanged.
            if (String.IsNullOrEmpty(targetOption))
                return;

            dropDown.SelectOptionAlphanumericOnly(targetOption);
        }

        internal SessionElementScope GetFilterButton()
        {
            var filterButton = _Session.FindSessionElementByXPath("//*[@id=\"MainContent\"]/div[3]/table[1]/tbody/tr/td[1]/a[1]");

            return filterButton;
        }

        internal SessionElementScope GetCodingTasksFoundTableHeader()
        {
            var codingTasksFoundTableHeader = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_ctl00\"]");

            return codingTasksFoundTableHeader;
        }

        internal SessionElementScope GetCodingTasksSelectedTableHeader()
        {
            var codingTasksSelectedTableHeader = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_UpElementTitle_LblElementTitle\"]");

            return codingTasksSelectedTableHeader;
        }

        internal SessionElementScope GetColumnHeader(string columnName)
        {
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");

            SessionElementScope columnHeader = null;
            switch (columnName)
            {
                case "Verbatim Term":
                    {
                        columnHeader = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGScol0\"]");

                        break;
                    }
                case "Group":
                    {
                        columnHeader = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGcol1\"]");

                        break;
                    }
                case "Priority":
                    {
                        columnHeader = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGcol2\"]");

                        break;
                    }
                case "Status":
                    {
                        columnHeader = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGcol3\"]");

                        break;
                    }
                case "Assigned Term":
                    {
                        columnHeader = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGScol4\"]");

                        break;
                    }
                case "Dictionary":
                    {
                        columnHeader = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGcol5\"]");

                        break;
                    }
                case "Queries":
                    {
                        columnHeader = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGcol6\"]");

                        break;
                    }
                case "Time Elapsed":
                    {
                        columnHeader = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGcol7\"]");

                        break;
                    }
                default:
                    {
                        throw new ArgumentException("The columnName is not valid or has not yet been mapped to a page object." +
                                "\nExpected \"Verbatim Term\", \"Group\", \"Priority\", \"Status\", "+
                                "\n\"Assigned Term\", \"Dictionary\", \"Queries\", or \"Time Elapsed\"");
                    }
            }
            return columnHeader;
        }

        internal SessionElementScope GetColumnHeaderSortIndicator(string columnName)
        {
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");

            SessionElementScope columnHeaderSortIndicator = null;
            switch (columnName)
            {
                case "Verbatim Term":
                    {
                        columnHeaderSortIndicator = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGScol0\"]/table/tbody/tr/td[2]/img");

                        break;
                    }
                case "Assigned Term":
                    {
                        columnHeaderSortIndicator = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGScol4\"]/table/tbody/tr/td[2]/img");

                        break;
                    }
                default:
                    {
                        throw new ArgumentException("The columnName is not valid, can't be sorted, or has not yet been mapped to a page object." +
                            "\nExpected \"Verbatim Term\" or \"Assigned Term\"");
                    }
            }
            return columnHeaderSortIndicator;
        }

        internal SessionElementScope GetColumnHeaderFilterButton(string columnName)
        {
            {
                if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");

                SessionElementScope columnHeaderFilterButton = null;
                switch (columnName)
                {
                    case "Priority":
                        {
                            columnHeaderFilterButton = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGcol2\"]/table/tbody/tr/td[2]/img");

                            break;
                        }
                    case "Status":
                        {
                            columnHeaderFilterButton = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGcol3\"]/table/tbody/tr/td[2]/img");

                            break;
                        }
                    case "Dictionary":
                        {
                            columnHeaderFilterButton = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGcol5\"]/table/tbody/tr/td[2]/img");

                            break;
                        }
                    case "Queries":
                        {
                            columnHeaderFilterButton = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGcol6\"]/table/tbody/tr/td[2]/img");

                            break;
                        }
                    case "Time Elapsed":
                        {
                            columnHeaderFilterButton = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXTGcol7\"]/table/tbody/tr/td[2]/img");

                            break;
                        }
                    default:
                        {
                            throw new ArgumentException("The columnName is not valid, can't be filtered, or has not yet been mapped to a page object."+
                                "\nExpected \"Priority\", \"Status\", \"Dictionary\", \"Queries\", or \"Time Elapsed\"");
                        }
                }
                return columnHeaderFilterButton;
            }
        }

        internal SessionElementScope GetColumnHeaderFilterWindow()
        {
            var columnHeaderFilterWindow = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_FPW\"]");

            _Session.WaitUntilElementDisappears(GetFilterLoadingIndicator);

            return columnHeaderFilterWindow;
        }

        private SessionElementScope GetFilterLoadingIndicator()
        {
            var loadingIndicator = _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_LPV\"]");

            return loadingIndicator;
        }

        internal SessionElementScope GetColumnHeaderFilterWindowItem(int columnHeaderFilterWindowItemIndex)
        {
            var columnHeaderFilterWindowItem =
                _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_FPC\"]/table/tbody/tr[" + columnHeaderFilterWindowItemIndex + "]");

            return columnHeaderFilterWindowItem;
        }

        internal bool IsTasksSummaryTableFooterVisible()
        {
            return GetTasksSummaryTableFooter().Exists(Config.ExistsOptions);
        }

        internal int GetItemFromTasksSummaryTableFooter(string itemName)
        {
            if (String.IsNullOrEmpty(itemName)) throw new ArgumentNullException("itemName");
            if (itemName != "Current Page" && itemName != "Page Count" && itemName != "Task Count")
            {
                throw new ArgumentException("itemName is not valid. Expected \"Current Page\", \"Page Count\", or \"Task Count\"");
            }

            const int summaryComponents = 3;

            int itemValue = 0;

            string tasksSummaryTableFooterText = GetTasksSummaryTableFooter().Text;

            string[] splitFooterText = tasksSummaryTableFooterText.Split(new string[] { "Page", " of ", " (", " Items)" }, StringSplitOptions.RemoveEmptyEntries);

            if (splitFooterText.Length != summaryComponents)
            {
                throw new InvalidOperationException("Parsing of the Tasks Summary Table Footer returned unexpected results.");
            }

            switch (itemName)
            {
                case "Current Page":
                    {
                        itemValue = splitFooterText[0].ToInteger();
                        break;
                    }
                case "Page Count":
                    {
                        itemValue = splitFooterText[1].ToInteger();
                        break;
                    }
                case "Task Count":
                    {
                        itemValue = splitFooterText[2].ToInteger();
                        break;
                    }
                default:
                    {
                        throw new ArgumentException("The itemName is not valid or has not yet been mapped to a page object." +
                            "\nExpected \"Current Page\", \"Page Count\", or \"Task Count\"");
                    }
            }
            return itemValue;
        }

        internal int GetCurrentPageFromPageLinks()
        {
            var currentPageLink = GetCurrentPageLink();

            string currentPageLinkTextStripped = Regex.Replace(currentPageLink.Text, @"[\[\]]", string.Empty);

            int currentPageNumber = 0;
            if (!int.TryParse(currentPageLinkTextStripped, out currentPageNumber))
            {
                throw new ArgumentException("Parsing of the current page link returned unexpected results.");
            }
            return currentPageNumber;
        }

        internal void GoToSpecificTaskPage(string destinationPage)
        {
            if (String.IsNullOrEmpty(destinationPage)) throw new ArgumentNullException("destinationPage");

            switch (destinationPage.ToUpper())
            {
                case "FIRST":
                {
                    GetFirstPageLink().Click();
                    break;
                }
                case "PREVIOUS":
                {
                    GetPreviousPageLink().Click();
                    break;
                }
                case "NEXT":
                {
                    GetNextPageLink().Click();
                    break;
                }
                case "LAST":
                {
                    GetLastPageLink().Click();
                    break;
                }
                default:
                {
                    int specificPageNumber = 0;
                    if (!int.TryParse(destinationPage, out specificPageNumber))
                    {
                        throw new ArgumentException("destinationPage is not a valid page");
                    }

                    GetSpecificPageNumberLink(specificPageNumber).Click();
                    break;
                }
            }
            WaitForTaskPageToFinishLoading();
        }

        private SessionElementScope GetTasksSummaryTableFooter()
        {
            var tasksSummaryTableFooter =
                _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXPagerBottom\"]//td[contains(text(),'Page')]");

            return tasksSummaryTableFooter;
        }

        private SessionElementScope GetFirstPageLink()
        {
            var firstPageLink =
                _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXPagerBottom\"]//span[text()='First']");

            return firstPageLink;
        }

        private SessionElementScope GetPreviousPageLink()
        {
            var previousPageLink =
                _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXPagerBottom\"]//span[text()='Previous']");

            return previousPageLink;
        }

        private SessionElementScope GetNextPageLink()
        {
            var nextPageLink =
                _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXPagerBottom\"]//span[text()='Next']");

            return nextPageLink;
        }

        private SessionElementScope GetLastPageLink()
        {
            var lastPageLink =
                _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXPagerBottom\"]//span[text()='Last']");

            return lastPageLink;
        }

        private SessionElementScope GetSpecificPageNumberLink(int specificPageNumber)
        {
            if (specificPageNumber <= 0)
            {
                throw new ArgumentException("specificPageNumber is less than 1");
            }

            int pageCount = GetItemFromTasksSummaryTableFooter("Page Count");

            if (pageCount < specificPageNumber)
            {
                throw new ArgumentException("The specificPageNumber is greater than the current number of pages");
            }

            string specificPageNumberLinkXPath = string.Format(
                "//*[@id=\"ctl00_Content_gridElements_DXPagerBottom\"]//td[text()='{0}' or text()='[{0}]']",
                specificPageNumber);

            var specificPageNumberLink = _Session.FindSessionElementByXPath(specificPageNumberLinkXPath);

            return specificPageNumberLink;
        }

        private SessionElementScope GetCurrentPageLink()
        {
            var CurrentPageNumberLink =
                _Session.FindSessionElementByXPath("//*[@id=\"ctl00_Content_gridElements_DXPagerBottom\"]//td[contains(text(),'[') and contains(text(),']')]");

            return CurrentPageNumberLink;
        }

        internal int GetGroupCountByVerbatim(string verbatim)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim"); 

            var taskGridRowXPath = String.Format("//tr[contains(@id,'ctl00_Content_gridElements_DXDataRow') and //td[contains(text(), '{0}')]]/td[2]", verbatim.ToUpper());
            var groupCount       = _Session.FindSessionElementByXPath(taskGridRowXPath).Text.ToInteger();

            return groupCount;
        }

        internal void InitiateBrowseAndCode(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            GetTasksTab().Click();

            SelectTaskGridByVerbatimName(verbatim);

            RetryPolicy.FindElement.Execute(TryInitiateBrowseAndCode);
        }

        internal void InitiateBrowseAndCodeForFirstTaskInGroup(string verbatim, string group = null)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            ViewGroupByVerbatimName(verbatim, group);

            var codingTaskGridDataRows = GetCodingTaskGridDataRows();
            
            if (GetCodingTaskGridDataRows().Count == 0)
            {
                throw new InvalidOperationException(String.Format("There are no tasks for verbatim {0} in the group {1} to browse and code.", verbatim, group ?? String.Empty));
            }

            codingTaskGridDataRows[0].Click();

            WaitForTaskPageToFinishLoading();

            RetryPolicy.FindElement.Execute(TryInitiateBrowseAndCode);
        }

        internal void InitiateReCode(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim"); 

            GetTasksTab().Click();

            ClearFilters();
            
            SelectTaskGridByVerbatimName(verbatim);

            RetryPolicy.FindElement.Execute(TryInitiateReCode);
        }

        internal void ClearFilters()
        {
            GetClearFilterLink().Click();
            WaitForTaskPageToFinishLoading();

            RetryPolicy.SyncStaleElement.Execute(VerifyTaskFiltersReset);
        }

        private void VerifyTaskFiltersReset()
        {

            var sourceSystem = GetSourceSystemDropdown().SelectedOption;
            var study        = GetStudiesDropdown().SelectedOption;
            var taskView     = GetTrackablesDropdown().SelectedOption;
            var searchText   = GetSearchTaskTextBox().Text;

            var filtersReset = sourceSystem.Equals("All Source Systems")
                               && study    .Equals("All Studies")
                               && taskView .Equals("Task View (actionable)")
                               && String.IsNullOrWhiteSpace(searchText);

            if (!filtersReset)
            {
                GetClearFilterLink().Click();
                WaitForTaskPageToFinishLoading();
                throw new MissingHtmlException("Task page filters not yet reset");
            }
        }

        private void TryInitiateBrowseAndCode()
        {
            var browseCodeButton = GetBrowseCodeButton();
            browseCodeButton.Click();

            RetryPolicy.FindElementShort.Execute(CheckIfBrowseAndCodeInitiated);
        }

        private void TryInitiateReCode()
        {
            var reCodeButton = GetReCodeButton();
            reCodeButton.Click();

            Config.FindElementShortPolicy.Execute(reCodeButton.Click);
        }

        private void CheckIfBrowseAndCodeInitiated()
        {
            var pageHeader = _Session.GetPageHeader();
            if (pageHeader.IsBrowserOnTasksPage()) throw new MissingHtmlException("browse and code not initiated");
        }

        internal SessionElementScope GetCodingTaskGrid()
        {
            var codingTaskGrid = _Session.FindSessionElementById("ctl00_Content_gridElements_DXMainTable");

            return codingTaskGrid;
        }

        internal IList<SessionElementScope> GetCodingTaskGridDataRows()
        {
            var codingTaskGridRows =
                GetCodingTaskGrid().FindAllSessionElementsByXPath("tbody/tr[not(contains(@id,\"HeadersRow\"))]");

            return codingTaskGridRows;
        }

        internal IList<CodingTask> GetCodingTaskValues()
        {
            if (GetCodingTaskGridDataRows().Count == 0)
            {
                return null;
            }

            var codingTaskValues = (
                from codingTaskGridRow in GetCodingTaskGridDataRows()
                select codingTaskGridRow.FindAllSessionElementsByXPath("td")
                    into codingTaskColumns
                    select new CodingTask
                    {
                        VerbatimTerm = codingTaskColumns[VerbatimTermIndex].Text,
                        Group        = codingTaskColumns[GroupIndex].Text,
                        Priority     = codingTaskColumns[PriorityIndex].Text,
                        Status       = codingTaskColumns[StatusIndex].Text,
                        AssignedTerm = codingTaskColumns[AssignedTermIndex].Text,
                        Dictionary   = codingTaskColumns[DictionaryIndex].Text,
                        Queries      = codingTaskColumns[QueriesIndex].Text,
                        TimeElaps    = codingTaskColumns[TimeElapsIndex].Text
                    })
                .ToList();

            return codingTaskValues;
        }

        internal IList<CodingTask> GetCodingTaskValuesForGroup(string verbatim, string group = null)
        {
            if (String.IsNullOrEmpty("verbatim")) throw new ArgumentNullException("verbatim");

            ViewGroupByVerbatimName(verbatim, group);

            // Find any filter status indicators and mark the "Group" as "FILTERED" in codingTaskValues
            var codingTaskFilterStatuses = (
                from codingTaskGridRow in GetCodingTaskGridDataRows()
                select codingTaskGridRow.FindAllSessionElementsByXPath("td")
                into codingTaskColumns
                select codingTaskColumns[GroupIndex])
                .ToList();

            var filterStatusIndicators = (
                from codingTaskFilterStatus in codingTaskFilterStatuses
                select codingTaskFilterStatus.FindAllSessionElementsByXPath("img"))
                .ToList();

            var codingTaskValues = GetCodingTaskValues();

            codingTaskValues.Count.ShouldBeEquivalentTo(filterStatusIndicators.Count);

            for (int rowIndex = 0; rowIndex < filterStatusIndicators.Count; rowIndex++)
            {
                var filterStatusIndicator = filterStatusIndicators[rowIndex];

                if (filterStatusIndicator.Count > 0)
                {
                    codingTaskValues[rowIndex].Group = "FILTERED";
                }
            }

            return codingTaskValues;
        }

        internal CodingTask GetTaskGridVerbatimElementValuesByVerbatimTerm(string verbatimTerm)
        {
            if (String.IsNullOrEmpty("verbatimTerm")) throw new ArgumentNullException("verbatimTerm");

            var codingTaskValues = GetCodingTaskValues();

            return codingTaskValues.FirstOrDefault(codingTaskValue => codingTaskValue.VerbatimTerm.Equals(verbatimTerm));
        }

        //MEV Download related
        internal void AssertTaskLoaded(string term)
        {             
            if (String.IsNullOrEmpty(term)) throw new ArgumentNullException("term");

            var verbatimElement = SearchForTaskGridVerbatimElementByVerbatimTerm(term);

            verbatimElement.ClickWhenAvailable();

            verbatimElement.InnerHTML.ShouldBeEquivalentTo(term);
        }

        internal void QueryingAndClickOkButton()
        {
            GetReasonOkButton().Click();
        }

        internal void SelectTaskGridByVerbatimName(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            var verbatimElement = SearchForTaskGridVerbatimElementByVerbatimTerm(verbatim);

            verbatimElement.Click();

            WaitForTaskPageToFinishLoading();
        }

        internal void SelectTaskGridByVerbatimNameAndAdditionalField(string verbatim, string field, string value)
        {
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(field))    throw new ArgumentNullException("field");
            if (String.IsNullOrEmpty(value))    throw new ArgumentNullException("value");
            
            var verbatimElement = SearchForTaskGridVerbatimElementByVerbatimTermAndAdditionalField(verbatim, field, value);

            verbatimElement.ClickWhenAvailable();
            
            WaitForTaskPageToFinishLoading();
        }

        internal void OpenQuery(string queryComments)
        {
            if (String.IsNullOrWhiteSpace(queryComments)) throw new InvalidOperationException("queryComments missing");

            GetOpenQueryButton().ClickWhenAvailable();
            GetReasonTextArea().FillInWith(queryComments);
            QueryingAndClickOkButton();
        }

        internal void CancelQuery()
        {
            GetCancelQueryButton().Click();
        }

        private string GetAssignedTermXPath(string rowXPath, string verbatimTerm)
        {
            if (String.IsNullOrEmpty(rowXPath))     throw new ArgumentNullException("rowXPath");
            if (String.IsNullOrEmpty(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            var xPath = _Session.FindSessionElementByXPath(String.Format(rowXPath, verbatimTerm, "td[5]/a"))
                .Exists()
                ? String.Format(rowXPath, verbatimTerm, "td[5]/a")
                : String.Format(rowXPath, verbatimTerm, "td[5]");

            return xPath;
        }

        internal void WaitUntilFinishLoading()
        {
            _Session.WaitUntilElementDisappears(GetLoadingIndicator);
        }

        internal void WaitFormTaskGroupToFinishLoading(string verbatim, int expectedCount)
        {
            if (String.IsNullOrWhiteSpace(verbatim)) throw new ArgumentNullException("verbatim"); 
            if(expectedCount <= 0)                   throw new ArgumentOutOfRangeException("expectedCount");

            var options = Config.GetLoadingCoypuOptions();

            _Session.TryUntil(
                () => GetFilterButton().Click(),
                () => GetGroupCountByVerbatim(verbatim).Equals(expectedCount),
                options.RetryInterval,
                options);
        }

        internal void WaitForTaskPageToFinishLoading()
        {
            WaitUntilFinishLoading();

            _Session.RetryUntilTimeout(() => TabContentFormExists(), Config.GetLoadingCoypuOptions());

            _Session.WaitUntilElementExists(GetActionButtonsFrame);
        }

        private SessionElementScope GetLoadingIndicator()
        {
            var loadingIndicator = _Session.FindSessionElementByXPath("//div[@class= 'ajaxProgress' ]");

            return loadingIndicator;
        }

        internal void SelectSourceTermTab()
        {
            GetSourceTermsTab().Click();
        }

        internal void SelectPropertiesTab()
        {
            GetPropertiesTab().Click();
        }

        internal void SelectAssignmentTab()
        {
            GetAssignmentsTab().Click();
        }

        internal void SelectCodingHistoryTab()
        {
            GetCodingHistoryTab().Click();
        }

        internal void SelectQueryHistoryTab()
        {
            GetQueryHistoryTab().Click();
        }

        internal void SelectTabByName(string tabName)
        {
            if (String.IsNullOrEmpty(tabName)) throw new ArgumentNullException("tabName");

            if (tabName.Equals("Source Terms", StringComparison.OrdinalIgnoreCase))
            {
                SelectSourceTermTab();
            }

            if (tabName.Equals("Properties", StringComparison.OrdinalIgnoreCase))
            {
                SelectPropertiesTab();
            }

            if (tabName.Equals("Assignments", StringComparison.OrdinalIgnoreCase))
            {
                SelectAssignmentTab();
            }

            if (tabName.Equals("Coding History", StringComparison.OrdinalIgnoreCase))
            {
                SelectCodingHistoryTab();
            }

            if (tabName.Equals("Query History", StringComparison.OrdinalIgnoreCase))
            {
                SelectQueryHistoryTab();
            }
        }

        internal void ClickHelpLinkUntilIsHelpPageIsAvailable()
        {
            var options = Config.GetDefaultCoypuOptions();

            _Session.TryUntil(
                () => GetContextHelpLink().Click(),
                () => _Session.FindWindow(Config.ELearningLoginTitle).Exists(),
                options.WaitBeforeClick,
                options);
        }

        internal string GetPageSummary()
        {
            var pageSummary = _Session
                .FindSessionElementByXPath("//table[@id='ctl00_Content_gridElements_DXPagerBottom']//td[@class='dxpSummary_Main_Theme']")
                .Text;

            return pageSummary;
        }

        public void AssertThatAllTasksAreFinishedProcessing(int expectedTaskCount)
        {
            if(expectedTaskCount < 0 ) throw new ArgumentOutOfRangeException("expectedTaskCount");

            var options = Config.GetDefaultCoypuOptions();

            var headerText = expectedTaskCount + (" Coding Tasks Found");

            _Session.TryUntil(
                () => GetFilterButton().Click(),
                () => GetCodingTasksFoundTableHeader().Text.Contains(headerText, StringComparison.OrdinalIgnoreCase),
                options.WaitBeforeClick,
                options);
        }
    }
}
