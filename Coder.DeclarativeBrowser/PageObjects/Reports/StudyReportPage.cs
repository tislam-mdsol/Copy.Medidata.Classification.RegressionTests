using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects.Reports
{
    public enum WorkflowState
    {
        AllWorkflowStates,
        NotCoded,
        CodedButNotComplete,
        OpenQuery,
        Completed,
        NotCompleted
    }
    
    internal sealed class StudyReportPage
    {
        private const string PageName                       = "Study Report";
        private const string StudyReportXPath               = "//tr[contains(@id, 'ctl00_Content_studyList_DXDataRow') and ./td[contains(text(),'{0}')]]/{1}";
        private const string CodingElementsXPath            = "//tr[contains(@id, 'ctl00_Content_gridCodingElements_DXDataRow') and ./td[contains(text(),'{0}')]]/{1}";
        private const string TaskCountXPath                 = "//td[contains(@id, 'ctl00_Content_studyList_tccell')]";
        private const string VariableTaskCountXPath         = "//td[contains(@id, 'ctl00_Content_studyList_tccell') and contains(@id, '_{0}')]";
        
        private const int StudyIndex                   = 1;
        private const int CurrentVersionIndex          = 2;
        private const int InitialVersionIndex          = 3;
        private const int NumberOfMigrationsIndex      = 4;
        private const int NotCodedIndex                = 5;
        private const int CodedButNotYetCompletedIndex = 6;
        private const int OpenQueryIndex               = 7;
        private const int CompletedIndex               = 8;
        private const int DictionaryIndex              = 9;

        private readonly BrowserSession _Session;

        private SessionElementScope GetStudyReportDescription(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);

            var enterDescriptionTextbox = _Session.FindSessionElementById("reportDescription");

            return enterDescriptionTextbox;
        }

        private SessionElementScope GetCreateNewStudyReportButton()
        {
            var createButton = _Session.FindSessionElementById("createNew");

            return createButton;
        }
        internal void NewStudyReportButton()
        {
            var createNewIngReportButton = GetCreateNewStudyReportButton();

            createNewIngReportButton.Click();
        }

        internal void EnterStudyReportDescription(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);

            var enterDescriptionTextbox = GetStudyReportDescription(descriptionText);

            enterDescriptionTextbox.FillInWith(descriptionText);
        }

        internal StudyReportPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))  throw new ArgumentNullException("session"); 
            
            _Session = session;
        }

        internal void GoTo()
        {
            _Session.GoToReportPage(PageName);
        }

        internal SessionElementScope GetDictionaryTypeDropDownList()
        {
            var dictionaryTypeDropDownList = _Session
                .FindSessionElementById("ctl00_Content_ddlDictionary");

            return dictionaryTypeDropDownList;
        }

        internal SessionElementScope GetStudyDropDownList()
        {
            var studyDropDownList = _Session
                .FindSessionElementById("ctl00_Content_DdlStudies");

            return studyDropDownList;
        }

        internal SessionElementScope GetGenerateReportButton()
        {
            var generateReportButton = _Session
                .FindSessionElementById("ctl00_Content_btnSearch");

            return generateReportButton;
        }

        internal bool IsStudyReportGridEmpty()
        {
            return _Session.FindAllSessionElementsByXPath( "//*[@id=\"ctl00_Content_studyList_DXMainTable\"]/tbody/tr[2]/td[2]/div").Count > 0;
        }

        internal SessionElementScope GetNotCodedButtonByStudyName(string study)
        {
            if (String.IsNullOrEmpty(study)) throw new ArgumentNullException("study");

            var notCodedButton = _Session
                .FindSessionElementByXPath(String.Format(StudyReportXPath, study, "/td[6]/a"));

            return notCodedButton;
        }

        internal SessionElementScope GetCompletedButtonByStudyName(string study)
        {
            if (String.IsNullOrEmpty(study)) throw new ArgumentNullException("study");

            var notCodedButton = _Session
                .FindSessionElementByXPath(String.Format(StudyReportXPath, study, "/td[9]/a"));

            return notCodedButton;
        }

        internal SessionElementScope GetCodedButNotCompletedButtonByStudyName(string study)
        {
            if (String.IsNullOrEmpty(study)) throw new ArgumentNullException("study");

            var notCodedButton = _Session
                .FindSessionElementByXPath(String.Format(StudyReportXPath, study, "/td[7]/a"));

            return notCodedButton;
        }

        internal StudyReport GetStudyReportValuesByStudy(string study)
        {
            var studyReportGridRows = _Session.FindAllSessionElementsByXPath("//tr[contains(@id, 'ctl00_Content_studyList_DXDataRow')]");
            
            var studyReportValues = (
                from studyReportGridRow in studyReportGridRows
                select studyReportGridRow.FindAllSessionElementsByXPath("td")
                into studyReportColumns
                select new StudyReport
                {
                    Study                   = studyReportColumns[StudyIndex].Text.Trim(),
                    CurrentVersion          = studyReportColumns[CurrentVersionIndex].Text.Trim(),
                    InitialVersion          = studyReportColumns[InitialVersionIndex].Text.Trim(),
                    NumberOfMigrations      = studyReportColumns[NumberOfMigrationsIndex].Text.Trim(),
                    NotCoded                = studyReportColumns[NotCodedIndex].Text.Trim(),
                    CodedButNotYetCompleted = studyReportColumns[CodedButNotYetCompletedIndex].Text.Trim(),
                    OpenQuery               = studyReportColumns[OpenQueryIndex].Text.Trim(),
                    Completed               = studyReportColumns[CompletedIndex].Text.Trim(),
                    Dictionary              = studyReportColumns[DictionaryIndex].Text.Trim()
                })
                .ToList();

            return studyReportValues.FirstOrDefault(studyReportValueX => studyReportValueX.Study.Equals(study));
        }

        internal StudyReportCodingElements GetStudyReportCodingElementsByVerbatimTerm(string verbatimTerm)
        {
            if (String.IsNullOrEmpty(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            var studyReportCodingElements = new StudyReportCodingElements
            {
                Study           = _Session.FindSessionElementByXPath(String.Format(CodingElementsXPath, verbatimTerm, "td[1]")).Text,
                VerbatimTerm    = _Session.FindSessionElementByXPath(String.Format(CodingElementsXPath, verbatimTerm, "td[2]")).Text,
                Dictionary      = _Session.FindSessionElementByXPath(String.Format(CodingElementsXPath, verbatimTerm, "td[3]")).Text,
                DictionaryLevel = _Session.FindSessionElementByXPath(String.Format(CodingElementsXPath, verbatimTerm, "td[4]")).Text,
                Code            = _Session.FindSessionElementByXPath(String.Format(CodingElementsXPath, verbatimTerm, "td[5]")).Text,
                Term            = _Session.FindSessionElementByXPath(String.Format(CodingElementsXPath, verbatimTerm, "td[6]")).Text,
                Path            = _Session.FindSessionElementByXPath(String.Format(CodingElementsXPath, verbatimTerm, "td[7]")).Text,
                Batch           = _Session.FindSessionElementByXPath(String.Format(CodingElementsXPath, verbatimTerm, "td[8]")).Text,
                WorkflowStatus  = _Session.FindSessionElementByXPath(String.Format(CodingElementsXPath, verbatimTerm, "td[9]")).Text
            };

            return studyReportCodingElements;
        }

        internal int TotalTaskCounts(WorkflowState workflowState)
        {
            int taskCount = 0;

            string taskCountElementXPath = "";

            switch (workflowState)
            {
                case WorkflowState.AllWorkflowStates:
                {
                    taskCountElementXPath = TaskCountXPath;
                    break;
                }
                case WorkflowState.NotCoded:
                {
                    taskCountElementXPath = string.Format(VariableTaskCountXPath, NotCodedIndex);
                    break;
                }
                case WorkflowState.CodedButNotComplete:
                {
                    taskCountElementXPath = string.Format(VariableTaskCountXPath, CodedButNotYetCompletedIndex);
                    break;
                }
                case WorkflowState.OpenQuery:
                {
                    taskCountElementXPath = string.Format(VariableTaskCountXPath, OpenQueryIndex);
                    break;
                }
                case WorkflowState.Completed:
                {
                    taskCountElementXPath = string.Format(VariableTaskCountXPath, CompletedIndex);
                    break;
                }
                default:
                {
                    throw new ArgumentException("The workflowState is not valid or has not yet been mapped to a page object." +
                        "\nExpected \"All\", \"Not coded\", \"Coded but not Completed\", \"Open Query\", or \"Completed\"");
                }
            }

            IList<SessionElementScope> taskCountElements = _Session.FindAllSessionElementsByXPath(taskCountElementXPath);

            foreach (SessionElementScope taskCountElement in taskCountElements)
            {
                taskCount += taskCountElement.Text.ToInteger();
            }

            return taskCount;
        }

        private string GetNotCodedXPath(string rowXPath, string study)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");
            if (String.IsNullOrEmpty(study))    throw new ArgumentNullException("study");

            if (_Session.FindSessionElementByXPath(String.Format(rowXPath, study, "/td[6]//u")).Exists())
            {
                return String.Format(rowXPath, study, "/td[6]//u");
            }

            return String.Format(rowXPath, study, "/td[6]");
        }

        private string GetCodedButNotCompletedXPath(string rowXPath, string study)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");
            if (String.IsNullOrEmpty(study))    throw new ArgumentNullException("study");

            if (_Session.FindSessionElementByXPath(String.Format(rowXPath, study, "/td[7]//u")).Exists())
            {
                return String.Format(rowXPath, study, "/td[7]//u");
            }

            return String.Format(rowXPath, study, "/td[7]");
        }

        private string GetOpenQueryXPath(string rowXPath, string study)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");
            if (String.IsNullOrEmpty(study))    throw new ArgumentNullException("study");

            if (_Session.FindSessionElementByXPath(String.Format(rowXPath, study, "/td[8]//u")).Exists())
            {
                return String.Format(rowXPath, study, "/td[8]//u");
            }

            return String.Format(rowXPath, study, "/td[8]");
        }

        private string GetCompletedXPath(string rowXPath, string study)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");
            if (String.IsNullOrEmpty(study))    throw new ArgumentNullException("study");

            if (_Session.FindSessionElementByXPath(String.Format(rowXPath, study, "/td[9]//u")).Exists())
            {
                return String.Format(rowXPath, study, "/td[9]//u");
            }

            return String.Format(rowXPath, study, "/td[9]");
        }
        
        internal SessionElementScope GetStudyReportCategoryButtonByStudyAndCategoryName(string study, string categoryName)
        {
            if (String.IsNullOrEmpty(study))        throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(categoryName)) throw new ArgumentNullException("categoryName");

            if (categoryName.Equals("Not Coded", StringComparison.OrdinalIgnoreCase))
            {
                return GetNotCodedButtonByStudyName(study);
            }

            if (categoryName.Equals("Coded but not Completed", StringComparison.OrdinalIgnoreCase))
            {
                return GetCodedButNotCompletedButtonByStudyName(study);
            }

            if (categoryName.Equals("Completed", StringComparison.OrdinalIgnoreCase))
            {
                return GetCompletedButtonByStudyName(study);
            }

            throw new NullReferenceException("Unable to find category");
        }

        //TODO: GB move options into config class
        internal void WaitForStudyMigrationToComplete(string study, string currentVersion)
        {
            if (String.IsNullOrEmpty(study))          throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(currentVersion)) throw new ArgumentNullException("currentVersion");

            var options = new Options
            {
                RetryInterval = TimeSpan.FromSeconds(1),
                Timeout       = TimeSpan.FromSeconds(480)
            };

            _Session.TryUntil(
                GetGenerateReportButton().Click,
                () => !_Session.FindSessionElementByXPath(String.Format(StudyReportXPath, study, "/td[6]")).Text.Equals("In Migration", StringComparison.OrdinalIgnoreCase),
                options.WaitBeforeClick,
                options);
        }
    }
}
