using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects.Administration
{
    internal sealed class StudyImpactAnalysisPage
    {
        private const string PageName = "Study Impact Analysis";
        private const string StudyReportRowXPath = "//tr[@id='ctl00_Content_studyVersionView_DXDataRow0']/{0}";
        private const string StudyReportDetailsRowXPath = "//tr[contains(@id, 'ctl00_Content_studyImpactDetail_DXDataRow') and ./td[text()='{0}']]/{1}";
        private readonly BrowserSession _Session;

        internal StudyImpactAnalysisPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))  throw new ArgumentNullException("session"); 
            
            _Session = session;
        }

        internal void GoTo()
        {
            _Session.GoToAdminPage(PageName);
        }

        internal void GoToWithValues(
            string study,
            string dictionary,
            SynonymList sourceSynonymList,
            SynonymList targetSynonymList)
        {
            if (String.IsNullOrEmpty(study))              throw new ArgumentNullException("study");
            if (String.IsNullOrEmpty(dictionary))         throw new ArgumentNullException("dictionary");
            if (ReferenceEquals(sourceSynonymList, null)) throw new ArgumentNullException("sourceSynonymList");
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            GoTo();

            GetStudyDropDownList().SelectOption(study);
            GetDictionaryDropDownList().SelectOption(dictionary);
            GetIncludeKeptCheckBox().SetCheckBoxState("True");
            GetFromVersionDropDownList().SelectOption(sourceSynonymList.Version + "-" + sourceSynonymList.Locale);
            GetFromSynonymListDropDownList().SelectOption(sourceSynonymList.SynonymListName);
            GetToVersionDropDownList().SelectOption(targetSynonymList.Version + "-" + targetSynonymList.Locale);
            GetToSynonymListDropDownList().SelectOption(targetSynonymList.SynonymListName);
        }

        internal SessionElementScope GetStudyDropDownList()
        {
            var studyDropDownList = _Session
                .FindSessionElementById("ctl00_Content_controlACG_ddlStudy");

            return studyDropDownList;
        }

        internal SessionElementScope GetDictionaryDropDownList()
        {
            var dictionaryDropDownList = _Session
                .FindSessionElementById("ctl00_Content_controlACG_ddlDictionary");

            return dictionaryDropDownList;
        }

        internal SessionElementScope GetFromVersionDropDownList()
        {
            var fromVersionDropDownList = _Session
                .FindSessionElementById("ctl00_Content_controlACG_ddlFromVersion");

            return fromVersionDropDownList;
        }

        internal SessionElementScope GetFromSynonymListDropDownList()
        {
            var fromSynonymListDropDownList = _Session
                .FindSessionElementById("ctl00_Content_controlACG_ddlFromSynonymList");

            return fromSynonymListDropDownList;
        }

        internal SessionElementScope GetToVersionDropDownList()
        {
            var toVersionDropDownList = _Session
                .FindSessionElementById("ctl00_Content_controlACG_ddlToVersion");

            return toVersionDropDownList;
        }

        internal SessionElementScope GetToSynonymListDropDownList()
        {
            var toSynonymListDropDownList = _Session
                .FindSessionElementById("ctl00_Content_controlACG_ddlToSynonymList");

            return toSynonymListDropDownList;
        }

        internal SessionElementScope GetIncludeKeptCheckBox()
        {
            var includeKeptCheckBox = _Session
                .FindSessionElementById("ctl00_Content_controlACG_chkIncludeIsReAssess");

            return includeKeptCheckBox;
        }

        internal SessionElementScope GetGenerateReportButton()
        {
            var generateReportButton = _Session
                .FindSessionElementById("ctl00_Content_btnSearch");

            return generateReportButton;
        }

        internal SessionElementScope GetExportStudyReportButton()
        {
            var exportStudyReportButton = _Session
                .FindSessionElementById("ctl00_Content_btnExportStudyReport");

            return exportStudyReportButton;
        }

        internal SessionElementScope GetExportStudyDetailReportButton()
        {
            var exportStudyDetailReportButton = _Session
                .FindSessionElementById("ctl00_Content_btnExportStudyDetailReport");

            return exportStudyDetailReportButton;
        }

        internal SessionElementScope GetStudyReportGridRow()
        {
            var studyReportGridRow = _Session
                .FindSessionElementById("ctl00_Content_studyVersionView_DXDataRow0");

            return studyReportGridRow;
        }

        internal SessionElementScope GetStudyReportGridActionButton()
        {
            var studyReportGridActionButtonXPath = GetStudyReportGridActionButtonXPath(StudyReportRowXPath);

            var studyReportGridActionButton = _Session
                .FindSessionElementByXPath(studyReportGridActionButtonXPath);

            return studyReportGridActionButton;
        }

        private SessionElementScope GetGridActionButton()
        {
            var actionRow = _Session.FindSessionElementByXPath("//tr[@id='ctl00_Content_studyVersionView_DXDataRow0']");
            var actionButton = actionRow.FindSessionElementByXPath("td[1]/a");

            return actionButton;
        }

        internal SessionElementScope GetStudyReportGridObsoleteButton()
        {
            var studyReportGridObsoleteButtonXPath = GetStudyReportGridObsoleteButtonXPath(StudyReportRowXPath);

            var studyReportGridObsoleteButton = _Session
                .FindSessionElementByXPath(studyReportGridObsoleteButtonXPath);

            return studyReportGridObsoleteButton;
        }

        internal SessionElementScope GetStudyReportGridReinstatedButton()
        {
            var studyReportGridReinstatedButtonXPath = GetStudyReportGridReinstatedButtonXPath(StudyReportRowXPath);

            var studyReportGridReinstatedButton = _Session
                .FindSessionElementByXPath(studyReportGridReinstatedButtonXPath);

            return studyReportGridReinstatedButton;
        }

        internal SessionElementScope GetStudyReportGridPathChangedButton()
        {
            var studyReportGridPathChangedButtonXPath = GetStudyReportGridPathChangedButtonXPath(StudyReportRowXPath);

            var studyReportGridPathChangedButton = _Session
                .FindSessionElementByXPath(studyReportGridPathChangedButtonXPath);

            return studyReportGridPathChangedButton;
        }

        internal SessionElementScope GetStudyReportGridTermNotFoundButton()
        {
            var studyReportGridTermNotFoundButtonXPath = GetStudyReportGridTermNotFoundButtonXPath(StudyReportRowXPath);

            var studyReportGridTermNotFoundButton = _Session
                .FindSessionElementByXPath(studyReportGridTermNotFoundButtonXPath);

            return studyReportGridTermNotFoundButton;
        }

        internal SessionElementScope GetStudyReportGridCasingChangedOnlyButton()
        {
            var studyReportGridCasingChangedOnlyButtonXPath = GetStudyReportGridCasingChangedOnlyButtonXPath(StudyReportRowXPath);

            var studyReportGridCasingChangedOnlyButton = _Session
                .FindSessionElementByXPath(studyReportGridCasingChangedOnlyButtonXPath);

            return studyReportGridCasingChangedOnlyButton;
        }

        internal SessionElementScope GetStudyReportGridDictionaryLabel()
        {
            var studyReportGridDictionaryLabel = _Session
                .FindSessionElementByXPath(String.Format(StudyReportRowXPath, "td[2]"));

            return studyReportGridDictionaryLabel;
        }

        internal SessionElementScope GetStudyReportGridNotAffectedLabel()
        {
            var studyReportGridNotAffectedLabel = _Session
                .FindSessionElementByXPath(String.Format(StudyReportRowXPath, "td[3]"));

            return studyReportGridNotAffectedLabel;
        }

        internal SessionElementScope GetPopupMigrateStudyButton()
        {
            var migrateStudyButton = _Session
                .FindSessionElementById("ctl00_Content_pcMigrationWarning_MigrateOK");

            return migrateStudyButton;
        }

        internal SessionElementScope GetPopupCancelMigrationButton()
        {
            var cancelMigrationButton = _Session
                .FindSessionElementById("ctl00_Content_pcMigrationWarning_CancelMigration");

            return cancelMigrationButton;
        }

        private SessionElementScope GetStudyImpactAnalysisEditButton()
        {
            var editButtonCell = _Session.FindSessionElementByXPath(String.Format(StudyReportRowXPath, "td[11]"));
            var editButton     = editButtonCell.FindSessionElementByXPath("a");

            return editButton;
        }

        internal SessionElementScope GetStudyMigrationStartingIndicator()
        {
            var studyMigrationStartingIndicator = _Session
                .FindSessionElementById("ctl00_Content_studyVersionView_LPV");

            return studyMigrationStartingIndicator;
        }

        internal SessionElementScope GetStudyMigrationStartedIndicator()
        {
            var studyMigrationStartedIndicator = _Session
                .FindSessionElementById("ctl00_StatusPaneACG_SuccessPane");

            return studyMigrationStartedIndicator;
        }

        internal StudyImpactAnalysisDetail GetStudyImpactAnalysisDetailValuesByVerbatim(string verbatimTerm)
        {
            if (String.IsNullOrEmpty(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            var studyImpactAnalysisDetailValues = new StudyImpactAnalysisDetail
            {
                Verbatim         = _Session.FindSessionElementByXPath(String.Format(StudyReportDetailsRowXPath, verbatimTerm, "td[1]")).Text,
                CurrentTerm      = _Session.FindSessionElementByXPath(String.Format(StudyReportDetailsRowXPath, verbatimTerm, "td[2]")).Text,
                CurrentCode      = _Session.FindSessionElementByXPath(String.Format(StudyReportDetailsRowXPath, verbatimTerm, "td[3]")).Text,
                TermInNewVersion = _Session.FindSessionElementByXPath(String.Format(StudyReportDetailsRowXPath, verbatimTerm, "td[5]")).Text,
                CodeInNewVersion = _Session.FindSessionElementByXPath(String.Format(StudyReportDetailsRowXPath, verbatimTerm, "td[6]")).Text
            };

            var currentNodePath = _Session.FindSessionElementByXPath(String.Format(StudyReportDetailsRowXPath, verbatimTerm, "td[4]"));

            studyImpactAnalysisDetailValues.CurrentNodePath = TermPathRowDisplay
                .GetExpandedCodingHistoryTermPathRows(currentNodePath);

            return studyImpactAnalysisDetailValues;
        }

        internal void GenerateReport()
        {
            GetGenerateReportButton().Click();
            WaitForMigrationReportToLoad();
        }

        internal StudyImpactAnalysisActions GetAvailableActions()
        {
            var availableActions = new StudyImpactAnalysisActions
            {
                GenerateReport    = GetGenerateReportButton().Exists(Config.ExistsOptions),
                MigrateStudy      = GetGridActionButton().Exists(Config.ExistsOptions),
                EditStudyAnalysis = GetStudyImpactAnalysisEditButton().Exists(Config.ExistsOptions),
                ExportReport      = GetExportStudyReportButton().Exists(Config.ExistsOptions)
            };

            return availableActions;
        }

        private string GetStudyReportGridActionButtonXPath(string rowXPath)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");

            var xPath = String.Format(rowXPath, _Session.FindSessionElementByXPath(String.Format(rowXPath, "td[1]/a"))
                .Exists()
                ? "td[1]/a"
                : "td[1]");

            return xPath;
        }

        private string GetStudyReportGridObsoleteButtonXPath(string rowXPath)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");

            var xPath = String.Format(rowXPath, _Session.FindSessionElementByXPath(String.Format(rowXPath, "td[4]/a"))
                .Exists()
                ? "td[4]/a"
                : "td[4]");

            return xPath;
        }

        private string GetStudyReportGridReinstatedButtonXPath(string rowXPath)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");

            var xPath = String.Format(rowXPath, _Session.FindSessionElementByXPath(String.Format(rowXPath, "td[5]/a"))
                .Exists()
                ? "td[5]/a"
                : "td[5]");

            return xPath;
        }

        private string GetStudyReportGridPathChangedButtonXPath(string rowXPath)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");

            var xPath = String.Format(rowXPath, _Session.FindSessionElementByXPath(String.Format(rowXPath, "td[6]/a"))
                .Exists()
                ? "td[6]/a"
                : "td[6]");

            return xPath;
        }

        private string GetStudyReportGridTermNotFoundButtonXPath(string rowXPath)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");

            var xPath = String.Format(rowXPath, _Session.FindSessionElementByXPath(String.Format(rowXPath, "td[7]/a"))
                .Exists()
                ? "td[7]/a"
                : "td[7]");

            return xPath;
        }

        private string GetStudyReportGridCasingChangedOnlyButtonXPath(string rowXPath)
        {
            if (String.IsNullOrEmpty(rowXPath)) throw new ArgumentNullException("rowXPath");

            var xPath = String.Format(rowXPath, _Session.FindSessionElementByXPath(String.Format(rowXPath, "td[8]/a"))
                .Exists()
                ? "td[8]/a"
                : "td[8]");

            return xPath;
        }

        internal void WaitForMigrationReportToLoad()
        {
            var options = Config.GetLoadingCoypuOptions();

            _Session.TryUntil(
                GetStudyReportGridRow().Click,
                () => GetStudyReportGridRow().Exists(),
                options.WaitBeforeClick,
                options);
        }
    }
}
