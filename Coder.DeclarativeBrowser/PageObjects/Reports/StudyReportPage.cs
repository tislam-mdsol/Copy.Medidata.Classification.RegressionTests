using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using Castle.Core.Internal;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;
using NUnit.Framework;

namespace Coder.DeclarativeBrowser.PageObjects.Reports
{
    
    internal sealed class StudyReportPage
    {
        private const string PageName                      = "Study Report";
   
        //Verbatim Stats  
        private const int _StudyReportStatStudy            = 0;
        private const int _StudyReportStatDictionary       = 1;
        private const int _NotCodedCount                   = 2;
        private const int _CodedNotCompletedCount          = 3;
        private const int _WithOpenQueryCount              = 4;
        private const int _CompletedCount                  = 5;

        //Verbatim Stat Details
        private const int _StudyReportStatDetailStudy      = 0;
        private const int _StudyReportStatVerbatim         = 1;
        private const int _StudyReportStatDetailDictionary = 2;
        private const int _StudyReportStatDictionaryLevel  = 3;
        private const int _StudyReportStatCode             = 4;
        private const int _StudyReportStatTerm             = 5;
        private const int _StudyReportStatStatus           = 6;
        private const int _StudyReportStatPath             = 7;
        private const int _StudyReportStatBatch            = 8;

        //Upversioning History
        private const int _UpStudyName                     = 0;
        private const int _UpDictionary                    = 1;
        private const int _NumberOfUpversions              = 2;
        private const int _InitialVersion                  = 3;
        private const int _CurrentVersion                  = 4;
        private const int _UpversioningHistory             = 5;
            
        //Upversioning Details
        private const int _FromVersion                      = 0;
        private const int _ToVersion                        = 1;
        private const int _User                             = 2;
        private const int _StartedOn                        = 3;
        private const int _NotAffected                      = 4;
        private const int _CodedtoNewVersionSynonymList     = 5;
        private const int _CodedtoNewVersionDictionaryMatch = 6;
        private const int _PathChanged                      = 7;
        private const int _CasingChangedOnly                = 8;
        private const int _Obsolete                         = 9;
        private const int _TermNotFound                     = 10;

        private readonly BrowserSession _Session;

        internal StudyReportPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Session = session;
        } 

        internal void GoTo()
        {
            _Session.GoToReportPage(PageName);
        } 

        private SessionElementScope GetStudyOptionDropDown()
        {
            var studyNameOption = _Session.FindSessionElementById("study");

            return studyNameOption;
        }

        internal void SelectStudyOption(string studyName)
        {
            if (String.IsNullOrWhiteSpace(studyName)) throw new ArgumentNullException(nameof(studyName));

            var studyDropDown= GetStudyOptionDropDown();

            studyDropDown.SelectOptionAlphanumericOnly(studyName);
        }

        private SessionElementScope GetDictionaryTypeDropDown()
        {
            var dTNameOption = _Session.FindSessionElementById("dictionaryType");

            return dTNameOption;
        }

        internal void SelectDictionaryType(string dictType)
        {
            if (String.IsNullOrWhiteSpace(dictType)) throw new ArgumentNullException(nameof(dictType));

            var dTNameOption = GetDictionaryTypeDropDown();

            dTNameOption.SelectOptionAlphanumericOnly(dictType);
        }

        private SessionElementScope GetStudyReportDescription(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);

            var enterDescriptionTextbox = _Session.FindSessionElementById("reportDescription");

            return enterDescriptionTextbox;
        }

        internal void EnterStudyReportDescription(string descriptionText)
        {
            if (String.IsNullOrWhiteSpace(descriptionText)) throw new ArgumentNullException(descriptionText);

            var enterDescriptionTextbox = GetStudyReportDescription(descriptionText);

            enterDescriptionTextbox.FillInWith(descriptionText);
        }

        private SessionElementScope GetCreateNewStudyReportButton()
        {
            var createButton = _Session.FindSessionElementById("createNew");

            return createButton;
        }

        internal void NewStudyReportButton()
        {
            var createNewReportButton = GetCreateNewStudyReportButton();

            createNewReportButton.Click();
        }

        
        private SessionElementScope GetVerbatimStatsTable()
        {
            var verbatimStatsTable = _Session.FindSessionElementById("masterVerbatimStats");

            return verbatimStatsTable;
        }

        private IEnumerable<SessionElementScope> GetVerbatimStatsTableRows()
        {
            var verbatimStatsTable     = GetVerbatimStatsTable();
            var verbatimStatsTableRows = _Session.FindAllSessionElementsByXPath("//tbody//tr");

            return verbatimStatsTableRows;
        }

        private SessionElementScope GetVerbatimStatsDetailsTable()
        {
            var verbatimStatsTable = _Session.FindSessionElementById("verbatimStatsDetails");

            return verbatimStatsTable;
        }

        private IEnumerable<SessionElementScope> GetVerbatimStatsDetailsTableRows()
        {
            var verbatimStatsTable     = GetVerbatimStatsDetailsTable();
            var verbatimStatsTableRows = _Session.FindAllSessionElementsByXPath("//tbody//tr");

            return verbatimStatsTableRows;
        }

        private SessionElementScope GetStudyUpVersioningTable()
        {
            var verbatimStatsTable = _Session.FindSessionElementById("masterStudyUpVersioning");

            return verbatimStatsTable;
        }

        private IEnumerable<SessionElementScope> GetStudyUpVersioningTableRows()
        {
            var studyUpTable     = GetStudyUpVersioningTable();
            var studyUpTableRows = _Session.FindAllSessionElementsByXPath("//tbody//tr");

            return studyUpTableRows;
        }

        private SessionElementScope GetMigrationStatsDetailsTable()
        {
            var migrationStatsDetailsTable = _Session.FindSessionElementById("migrationStatsDetails");

            return migrationStatsDetailsTable;
        }

        private IEnumerable<SessionElementScope> GetMigrationStatsDetailsTableRows()
        {
            var migrationStatsDetailsTable = GetStudyUpVersioningTable();
            var studyUpTableRows           = _Session.FindAllSessionElementsByXPath("//tbody//tr");

            return studyUpTableRows;
        }

        private SessionElementScope GetNotCodedButton(string studyName, string dictionaryName)
        {
            if (String.IsNullOrEmpty(studyName))      throw new ArgumentNullException(nameof(studyName));
            if (String.IsNullOrEmpty(dictionaryName)) throw new ArgumentNullException(nameof(dictionaryName));

            var statsDetailRows                      = GetVerbatimStatsTableRows();

            var statsDetailRowViaStudyDictionaryName = from   row in statsDetailRows
                                                       where  row.InnerHTML.Contains(studyName) && row.InnerHTML.Contains(dictionaryName)
                                                       select row;

            var statLink = statsDetailRowViaStudyDictionaryName.FirstOrDefault().FindSessionElementByXPath("//a[contains(@id, 'notCoded-')]");

            return statLink;
        }

        private SessionElementScope GetCodedNotCompletedButton(string studyName, string dictionaryName)
        {
            if (String.IsNullOrEmpty(studyName))      throw new ArgumentNullException(nameof(studyName));
            if (String.IsNullOrEmpty(dictionaryName)) throw new ArgumentNullException(nameof(dictionaryName));

            var statsDetailRows                      = GetVerbatimStatsTableRows();

            var statsDetailRowViaStudyDictionaryName = from row in statsDetailRows
                                                       where row.InnerHTML.Contains(studyName) && row.InnerHTML.Contains(dictionaryName)
                                                       select row;

            var statLink = statsDetailRowViaStudyDictionaryName.FirstOrDefault().FindSessionElementByXPath("//a[contains(@id, 'codedNotCompleted-')]");

            return statLink;
        }

        private SessionElementScope GetWithOpenQueryButton(string studyName, string dictionaryName)
        {
            if (String.IsNullOrEmpty(studyName))      throw new ArgumentNullException(nameof(studyName));
            if (String.IsNullOrEmpty(dictionaryName)) throw new ArgumentNullException(nameof(dictionaryName));

            var statsDetailRows                      = GetVerbatimStatsTableRows();

            var statsDetailRowViaStudyDictionaryName = from row in statsDetailRows
                                                       where row.InnerHTML.Contains(studyName) && row.InnerHTML.Contains(dictionaryName)
                                                       select row;

            var statLink = statsDetailRowViaStudyDictionaryName.FirstOrDefault().FindSessionElementByXPath("//a[contains(@id, 'withOpenQuery-')]");

            return statLink;
        }

        private SessionElementScope GetCompletedButton(string studyName, string dictionaryName)
        {
            if (String.IsNullOrEmpty(studyName))      throw new ArgumentNullException(nameof(studyName));
            if (String.IsNullOrEmpty(dictionaryName)) throw new ArgumentNullException(nameof(dictionaryName));

            var statsDetailRows                      = GetVerbatimStatsTableRows();

            var statsDetailRowViaStudyDictionaryName = from row in statsDetailRows
                                                       where row.InnerHTML.Contains(studyName) && row.InnerHTML.Contains(dictionaryName)
                                                       select row;

            var statLink = statsDetailRowViaStudyDictionaryName.FirstOrDefault().FindSessionElementByXPath("//a[contains(@id, 'completed-')]");

            return statLink;
        }

        private SessionElementScope GetDetailsButton(string studyName, string dictionaryName)
        {
            if (String.IsNullOrEmpty(studyName))      throw new ArgumentNullException(nameof(studyName));
            if (String.IsNullOrEmpty(dictionaryName)) throw new ArgumentNullException(nameof(dictionaryName));

            var detailRows                      = GetVerbatimStatsTableRows();

            var detailRowViaStudyDictionaryName = from row in detailRows
                                                  where row.InnerHTML.Contains(studyName) && row.InnerHTML.Contains(dictionaryName)
                                                  select row;

            var statLink = detailRowViaStudyDictionaryName.FirstOrDefault().FindSessionElementByXPath("//a[contains(@id, 'migrationDetails-')]");

            return statLink;
        }

        private SessionElementScope GetStatExportLink(string studyName, string dictionaryName)
        {
            if (String.IsNullOrEmpty(studyName))      throw new ArgumentNullException(nameof(studyName));
            if (String.IsNullOrEmpty(dictionaryName)) throw new ArgumentNullException(nameof(dictionaryName));

            var statsDetailRows                      = GetVerbatimStatsTableRows();

            var statsDetailRowViaStudyDictionaryName = from row in statsDetailRows
                                                       where row.InnerHTML.Contains(studyName) && row.InnerHTML.Contains(dictionaryName)
                                                       select row;

            var statLink = statsDetailRowViaStudyDictionaryName.FirstOrDefault().FindSessionElementByLink("Export");

            return statLink;
        }

        private SessionElementScope GetExportSummaryLink()
        {
            var statLink = _Session.FindSessionElementByLink("Export Summary");

            return statLink;
        }

        private SessionElementScope GetStudyUpversioningTab()
        {
            var statLink = _Session.FindSessionElementByLink("Study Upversioning");

            return statLink;
        }

        private SessionElementScope GetVerbatomStatsTab()
        {
            var statLink = _Session.FindSessionElementByLink("Verbatim Statistics");

            return statLink;
        }

        private SessionElementScope SelectTermPathExpandButton(SessionElementScope rowElements)
        {
            if (ReferenceEquals(rowElements, null)) throw new ArgumentNullException(nameof(rowElements));

            var searchResultsElement     = rowElements.FindSessionElementByXPath(".//div[@class='term']");
            var searchResultExpandButton = searchResultsElement.FindSessionElementByXPath("span[@class='term-expander']/i");

            return searchResultExpandButton;
        }

        internal void ExpandTermPath(SessionElementScope columnPath)
        {
            if (ReferenceEquals(columnPath, null)) throw new ArgumentNullException(nameof(columnPath));

            var expandPathButton = SelectTermPathExpandButton(columnPath);
            expandPathButton.Click();

            RetryPolicy
                .FindElementShort
                .Execute(() => WaitForResultExpansion(columnPath));
        }

        private void WaitForResultExpansion(SessionElementScope columnPath)
        {
            if (ReferenceEquals(columnPath, null)) throw new ArgumentNullException(nameof(columnPath));

            var termPaths = columnPath.FindAllSessionElementsByXPath(".//div[@class='term']");
            
            if(termPaths.Count < 2) throw new MissingHtmlException("Results not yet expanded");
        }

        private IEnumerable<TermPathRow> GetTermPathRowsFromStatsDetailsPath(SessionElementScope columnPath)
        {
            if (ReferenceEquals(columnPath, null)) throw new ArgumentNullException(nameof(columnPath));

            ExpandTermPath(columnPath);

            var collectionOfTermPaths = columnPath.FindAllSessionElementsByXPath(".//div[@class='term']");

            var collectionTermPathRows = (from termPath in collectionOfTermPaths
                let pathTerm = termPath.FindSessionElementByXPath("span[@class='.//term-text']/i").Text.Trim()
                let pathLevel = termPath.FindSessionElementByXPath("span[@class='.//term-level']/i").Text.Trim()
                let pathCode = termPath.FindSessionElementByXPath("span[@class='.//term-code']/i").Text.Trim()
                select new TermPathRow
                {
                    TermPath = pathTerm,
                    Level    = pathLevel,
                    Code     = pathCode
                }).ToList();

            return collectionTermPathRows;
        }

        internal IEnumerable<StudyReportStatsDetails> GetStudyReportStatsDetailsByStatus(SessionElementScope statusButton)
        {
            statusButton.Click();

            var verbatimStatDetailsRows             = GetVerbatimStatsDetailsTableRows();

            var collectionOfStudyReportStatsDetails = new List<StudyReportStatsDetails>();

            foreach (var rowSD in verbatimStatDetailsRows)
            {
                var sdColumns = rowSD.FindAllSessionElementsByXPath("td");
                SelectTermPathExpandButton(rowSD).Click();

                var verbatimStatDetailValues = new StudyReportStatsDetails
                {
                    Study        = sdColumns[_StudyReportStatStudy].Text.Trim(),
                    Verbatim     = sdColumns[_StudyReportStatVerbatim].Text.Trim(),
                    Dictionary   = sdColumns[_StudyReportStatDictionary].Text.Trim(),
                    Status       = sdColumns[_StudyReportStatStatus].Text.Trim(),
                    Batch        = sdColumns[_StudyReportStatBatch].Text.Trim(),

                    SelectedTerm = new TermPathRow
                    {
                        Level    = sdColumns[_StudyReportStatDictionaryLevel].Text.Trim(),
                        Code     = sdColumns[_StudyReportStatCode].Text.Trim(),
                        TermPath = sdColumns[_StudyReportStatTerm].Text.Trim(),
                    },

                    SelectedTermpath = GetTermPathRowsFromStatsDetailsPath(sdColumns[_StudyReportStatPath])
                };

                collectionOfStudyReportStatsDetails.Add(verbatimStatDetailValues);
            }

            return collectionOfStudyReportStatsDetails;
        }
    

        internal StudyReportStats GetStudyReportStatsDetails(StudyReportStats statsValues)
        {
            if (ReferenceEquals(statsValues, null)) throw new ArgumentNullException(nameof(statsValues));

            var notCodedStatsDetailsButton          = GetNotCodedButton(statsValues.StudyStatName, statsValues.DictionaryName);
            var codedNotCompletedStatsDetailsButton = GetCodedNotCompletedButton(statsValues.StudyStatName, statsValues.DictionaryName);
            var withOpenQueryStatsDetailsButton     = GetWithOpenQueryButton(statsValues.StudyStatName, statsValues.DictionaryName);
            var completedCountStatsDetailsButton    = GetCompletedButton(statsValues.StudyStatName, statsValues.DictionaryName);

            if (statsValues.NotCodedCount > 0)
                statsValues.NotCodedTasks           = GetStudyReportStatsDetailsByStatus(notCodedStatsDetailsButton);
            
            if (statsValues.CodedNotCompletedCount > 0)
                statsValues.CodedNotCompletedTasks  = GetStudyReportStatsDetailsByStatus(codedNotCompletedStatsDetailsButton);
            
            if (statsValues.WithOpenQueryCount > 0)
                statsValues.WithOpenQueryTasks      = GetStudyReportStatsDetailsByStatus(withOpenQueryStatsDetailsButton);                
            
            if (statsValues.CompletedCount > 0)
                statsValues.CompletedTasks          = GetStudyReportStatsDetailsByStatus(completedCountStatsDetailsButton);

            return statsValues;
        }

        internal IEnumerable<StudyReportStats> GetStudyReportStatsDataSet()
        {
            var verbatimStatsTableRows = GetVerbatimStatsTableRows();

            var collectionOfStudyReportStatsWithDetails =
                (
                    from row in verbatimStatsTableRows
                    select row.FindAllSessionElementsByXPath("td")
                    into verbatimStatsColumns
                    select new StudyReportStats
                    {
                        StudyStatName          = verbatimStatsColumns[_StudyReportStatStudy].Text.Trim(),
                        DictionaryName         = verbatimStatsColumns[_StudyReportStatDictionary].Text.Trim(),

                        NotCodedCount          = Convert.ToInt32(verbatimStatsColumns[_NotCodedCount].Text.Trim()),
                        CodedNotCompletedCount = Convert.ToInt32(verbatimStatsColumns[_CodedNotCompletedCount].Text.Trim()),
                        WithOpenQueryCount     = Convert.ToInt32(verbatimStatsColumns[_WithOpenQueryCount].Text.Trim()),
                        CompletedCount         = Convert.ToInt32(verbatimStatsColumns[_CompletedCount].Text.Trim()),
                    }
                    into statsValues
                    select GetStudyReportStatsDetails(statsValues)
                ).ToList();

            return collectionOfStudyReportStatsWithDetails;
        }

        internal IEnumerable<StudyReportUpversionHistoryDetails> GetStudyUpversioningDetails()
        {
            var upVersioningHistoryDetailsRows   = GetMigrationStatsDetailsTableRows();

            var upVerHistoryDetailsCollection    = upVersioningHistoryDetailsRows
                                                  .Select(row            => row.FindAllSessionElementsByXPath("td"))
                                                  .Select(historyColumns => new StudyReportUpversionHistoryDetails
                                                  {
                                                      FromVersion                  = historyColumns[_FromVersion].Text.Trim(),
                                                      ToVersion                    = historyColumns[_ToVersion].Text.Trim(),
                                                      User                         = historyColumns[_User].Text.Trim(),
                                                      StartedOn                    = historyColumns[_StartedOn].Text.Trim(),
                                                      NotAffected                  = historyColumns[_NotAffected].Text.Trim(),
                                                      CodedToNewVersionSynonym     = historyColumns[_CodedtoNewVersionSynonymList].Text.Trim(),
                                                      CodedToNewVersionBetterMatch = historyColumns[_CodedtoNewVersionDictionaryMatch].Text.Trim(),
                                                      PathChanged                  = historyColumns[_PathChanged].Text.Trim(),
                                                      CasingChangeOnly             = historyColumns[_CasingChangedOnly].Text.Trim(),
                                                      Obsolete                     = historyColumns[_Obsolete].Text.Trim(),
                                                      TermNotFound                 = historyColumns[_TermNotFound].Text.Trim()
                                                  })
                                                  .ToList();
            return upVerHistoryDetailsCollection;
        }

        internal IEnumerable<StudyReportUpVersion> GetStudyReportUpversionDataSet()
        {
            var upversioningButton = GetStudyUpversioningTab();
            upversioningButton.Click();

            var studyUpVerTableRows = GetStudyUpVersioningTableRows();

            var collectionOfStudyReportVersions = new List<StudyReportUpVersion>();

            foreach (var mainRow in studyUpVerTableRows)
            {
                var mainRowColumns = mainRow.FindAllSessionElementsByXPath(".//td");

                var studyName      = mainRowColumns[_UpStudyName].Text.Trim();
                var dictionaryName = mainRowColumns[_UpDictionary].Text.Trim();

                var upVersioningHistoryDetailsButton = GetDetailsButton(studyName,dictionaryName);
                upVersioningHistoryDetailsButton.Click();

                collectionOfStudyReportVersions = studyUpVerTableRows
                    .Select(row => row.FindAllSessionElementsByXPath(".//td"))                    
                    .Select(columns => new StudyReportUpVersion
                    {
                        StudyName           = studyName,
                        Dictionary          = dictionaryName,
                        NumberOfUpversions  = columns[_NumberOfUpversions].Text.Trim(),
                        InitialVersion      = columns[_InitialVersion].Text.Trim(),
                        CurrentVersion      = columns[_CurrentVersion].Text.Trim(),

                        UpversioningDetails = GetStudyUpversioningDetails()
                    })
                    .ToList();
            }

            return collectionOfStudyReportVersions;
        }

        internal StudyReport GetStudyReportDataSet()
        {
            var studyReportSet = new StudyReport
            {
                    StudyStats         = GetStudyReportStatsDataSet(),
                    UpversionHistories = GetStudyReportUpversionDataSet()
            };

            return studyReportSet;
        }

        internal int GetTotalStudyReportTaskCounts(string studyName, string dictionaryType)
        {

            var notCodedValue           = Convert.ToInt32(GetNotCodedButton(studyName, dictionaryType).Text.Trim());
            var codedNotCompletedValue  = Convert.ToInt32(GetCodedNotCompletedButton(studyName, dictionaryType).Text.Trim());
            var completedValue          = Convert.ToInt32(GetCompletedButton(studyName, dictionaryType).Text.Trim());

            var totalTaskCount          = notCodedValue + codedNotCompletedValue + completedValue;

            return totalTaskCount;
        }

        internal int GetStudyReportTotalTaskCount()
        {
            var studyDataSetCollection = GetStudyReportDataSet();

            var statStudyData          = studyDataSetCollection.StudyStats;

            var taskCount              = 0;

            foreach (var studyData in statStudyData)
            {
                taskCount = studyData.CodedNotCompletedCount + studyData.NotCodedCount + studyData.CompletedCount;
            }

            return taskCount;
        }

    }
}
