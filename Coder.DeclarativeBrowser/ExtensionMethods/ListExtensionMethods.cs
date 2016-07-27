using System;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.Models;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    public static class ListExtensionMethods
    {
        public static void SetNonRequiredMevColumnsToDefaultValues(this IEnumerable<ExternalVerbatim> externalVerbatims, StepContext stepContext)
        {
            if (ReferenceEquals(externalVerbatims, null)) throw new ArgumentNullException("externalVerbatims");
            if (ReferenceEquals(stepContext, null))       throw new ArgumentNullException("stepContext");

            foreach (var externalVerbatim in externalVerbatims)
            {
                if (String.IsNullOrWhiteSpace(externalVerbatim.VerbatimTerm))       throw new NullReferenceException("Verbatim");
                if (String.IsNullOrWhiteSpace(externalVerbatim.DictionaryLevel))    throw new NullReferenceException("DictionaryLevel");

                SetContextStudyId(externalVerbatim, stepContext);
                
                if (String.IsNullOrWhiteSpace(externalVerbatim.Dictionary))         { externalVerbatim.Dictionary         = stepContext.Dictionary;         }
                if (String.IsNullOrWhiteSpace(externalVerbatim.IsApprovalRequired)) { externalVerbatim.IsApprovalRequired = stepContext.IsApprovalRequired; }
                if (String.IsNullOrWhiteSpace(externalVerbatim.IsAutoApproval))     { externalVerbatim.IsAutoApproval     = stepContext.IsAutoApproval;     }
                if (String.IsNullOrWhiteSpace(externalVerbatim.Locale))             { externalVerbatim.Locale             = stepContext.Locale.ToLower();   }
                if (String.IsNullOrWhiteSpace(externalVerbatim.Subject))            { externalVerbatim.Subject            = Config.DefaultSubjectKey;       }
                if (String.IsNullOrWhiteSpace(externalVerbatim.Site))               { externalVerbatim.Site               = Config.DefaultSiteKey;          }
                if (String.IsNullOrWhiteSpace(externalVerbatim.Event))              { externalVerbatim.Event              = Config.DefaultEventKey;         }
                if (String.IsNullOrWhiteSpace(externalVerbatim.Form))               { externalVerbatim.Form               = Config.DefaultFormKey;          }
                if (String.IsNullOrWhiteSpace(externalVerbatim.Line))               { externalVerbatim.Line               = Config.DefaultLineKey;          }
                if (String.IsNullOrWhiteSpace(externalVerbatim.Field))              { externalVerbatim.Field              = Config.DefaultFieldKey;         }
                if (String.IsNullOrWhiteSpace(externalVerbatim.Priority))           { externalVerbatim.Priority           = Config.DefaultPriority;         }
                if (String.IsNullOrWhiteSpace(externalVerbatim.BatchIdentifier))    { externalVerbatim.BatchIdentifier    = Config.DefaultBatchIdentifier;  }

                if (String.IsNullOrWhiteSpace(externalVerbatim.VerbatimTerm))       throw new NullReferenceException("Verbatim");
                if (String.IsNullOrWhiteSpace(externalVerbatim.Dictionary))         throw new NullReferenceException("Dictionary");
                if (String.IsNullOrWhiteSpace(externalVerbatim.IsApprovalRequired)) throw new NullReferenceException("IsApprovalRequired");
                if (String.IsNullOrWhiteSpace(externalVerbatim.IsAutoApproval))     throw new NullReferenceException("IsAutoApproval");

                externalVerbatim.SupplementalField1 = externalVerbatim.SupplementalField1.NullSafeRemoveAllWhiteSpace();
                externalVerbatim.SupplementalField2 = externalVerbatim.SupplementalField2.NullSafeRemoveAllWhiteSpace();
                externalVerbatim.SupplementalField3 = externalVerbatim.SupplementalField3.NullSafeRemoveAllWhiteSpace();
                externalVerbatim.SupplementalField4 = externalVerbatim.SupplementalField4.NullSafeRemoveAllWhiteSpace();
                externalVerbatim.SupplementalField5 = externalVerbatim.SupplementalField5.NullSafeRemoveAllWhiteSpace();
            }
        }

        public static void SetContextStudyId(this IEnumerable<ExternalVerbatim> externalVerbatims, StepContext stepContext)
        {
            if (ReferenceEquals(externalVerbatims, null)) throw new ArgumentNullException(nameof(externalVerbatims));
            if (ReferenceEquals(stepContext, null))       throw new ArgumentNullException(nameof(stepContext));

            foreach (var externalVerbatim in externalVerbatims)
            {
                SetContextStudyId(externalVerbatim, stepContext);
            }
        }

        private static void SetContextStudyId(ExternalVerbatim externalVerbatim, StepContext stepContext)
        {
            if (ReferenceEquals(externalVerbatim, null)) throw new ArgumentNullException(nameof(externalVerbatim));
            if (ReferenceEquals(stepContext, null))      throw new ArgumentNullException(nameof(stepContext));

            if (ReferenceEquals(externalVerbatim.StudyID, null))
            {
                externalVerbatim.StudyID = String.Empty;
            }

            var inputId = externalVerbatim.StudyID.ToLower();

            switch (inputId)
            {
                case "dev":
                case "development":
                    externalVerbatim.StudyID = stepContext.GetDevStudyUuid();
                    break;
                case "uat":
                case "user acceptance":
                case "useracceptancetesting":
                    externalVerbatim.StudyID = stepContext.GetUatStudyUuid();
                    break;
                case "prod":
                case "production":
                case "":
                    externalVerbatim.StudyID = stepContext.GetStudyUuid();
                    break;
            }
        }

        public static CodingHistoryReportRow[] SetNonRequiredCodingHistoryReportColumnsToDefaultValues(
            this CodingHistoryReportRow[] codingHistoryReportRows,
            string dictionary,
            string version,
            string locale,
            string study)
        {
            if (ReferenceEquals(codingHistoryReportRows, null)) throw new ArgumentNullException("codingHistoryReportRows");
            if (String.IsNullOrWhiteSpace(dictionary))          throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(version))             throw new ArgumentNullException("version");
            if (String.IsNullOrWhiteSpace(locale))              throw new ArgumentNullException("locale");
            if (String.IsNullOrWhiteSpace(study))               throw new ArgumentNullException("study");

            foreach (var codingHistoryReportRow in codingHistoryReportRows)
            {
                if (String.IsNullOrWhiteSpace(codingHistoryReportRow.Subject))      { codingHistoryReportRow.Subject      = Config.DefaultSubjectKey; }
                if (String.IsNullOrWhiteSpace(codingHistoryReportRow.Dictionary))   { codingHistoryReportRow.Dictionary   = String.Format("{0} {1} ({2})", dictionary, version, locale); }
                if (String.IsNullOrWhiteSpace(codingHistoryReportRow.Version))      { codingHistoryReportRow.Version      = version; }
                if (String.IsNullOrWhiteSpace(codingHistoryReportRow.Study))        { codingHistoryReportRow.Study        = study; }
                if (String.IsNullOrWhiteSpace(codingHistoryReportRow.Form))         { codingHistoryReportRow.Form         = Config.DefaultFormKey; }
                if (String.IsNullOrWhiteSpace(codingHistoryReportRow.Field))        { codingHistoryReportRow.Field        = Config.DefaultFieldKey; }
                if (String.IsNullOrWhiteSpace(codingHistoryReportRow.SourceSystem)) { codingHistoryReportRow.SourceSystem = Config.ApplicationName; }
            }

            return codingHistoryReportRows;
        }

        public static CodingDecisionsReportRow[] ValidateCodingDecisionsReportRequiredColumns(
          this CodingDecisionsReportRow[] codingDecisionsReportRows)
        {
            if (ReferenceEquals(codingDecisionsReportRows, null)) throw new ArgumentNullException("codingDecisionsReportRows");

            foreach (var codingDecisionsReportRow in codingDecisionsReportRows)
            {
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.VerbatimTerm))         throw new NullReferenceException("Verbatim");
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.CurrentWorkflowState)) throw new NullReferenceException("CurrentWorkflowState");
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.DictionaryLevel))      throw new NullReferenceException("DictionaryLevel");
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.Path))                 throw new NullReferenceException("Path");
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.Code))                 throw new NullReferenceException("Code");
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.Term))                 throw new NullReferenceException("Term");
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.IsAutoCoded))          throw new NullReferenceException("IsAutoCoded");
            }

            return codingDecisionsReportRows;
        }

        public static CodingDecisionsReportRow[] SetNonRequiredCodingDecisionsReportColumnsToDefaultValues(
            this CodingDecisionsReportRow[] codingDecisionsReportRows,
            string study,
            string dictionary,
            string version,
            string locale,
            string userName)
        {
            if (ReferenceEquals(codingDecisionsReportRows, null)) throw new ArgumentNullException("codingDecisionsReportRows");
            if (String.IsNullOrWhiteSpace(study))                 throw new ArgumentNullException("study");
            if (String.IsNullOrWhiteSpace(dictionary))            throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(version))               throw new ArgumentNullException("version");
            if (String.IsNullOrWhiteSpace(locale))                throw new ArgumentNullException("locale");
            if (String.IsNullOrWhiteSpace(userName))              throw new ArgumentNullException("userName");

            foreach (var codingDecisionsReportRow in codingDecisionsReportRows)
            {
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.StudyName))          { codingDecisionsReportRow.StudyName          = study; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.Dictionary))         { codingDecisionsReportRow.Dictionary         = String.Format("{0} {1} ({2})", dictionary, version, locale); }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.CodedBy))            { codingDecisionsReportRow.CodedBy            = userName; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.Subject))            { codingDecisionsReportRow.Subject            = Config.DefaultSubjectKey; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.CodedBy))            { codingDecisionsReportRow.CodedBy            = String.Empty; }               
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.Priority))           { codingDecisionsReportRow.ApprovedBy         = Config.DefaultPriority; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.Logline))            { codingDecisionsReportRow.Logline            = Config.DefaultLineKey; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.SupplementalField1)) { codingDecisionsReportRow.SupplementalField1 = String.Empty; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.SupplementalValue1)) { codingDecisionsReportRow.SupplementalValue1 = String.Empty; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.SupplementalField2)) { codingDecisionsReportRow.SupplementalField2 = String.Empty; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.SupplementalValue2)) { codingDecisionsReportRow.SupplementalValue2 = String.Empty; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.SupplementalField3)) { codingDecisionsReportRow.SupplementalField3 = String.Empty; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.SupplementalValue3)) { codingDecisionsReportRow.SupplementalValue3 = String.Empty; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.SupplementalField4)) { codingDecisionsReportRow.SupplementalField4 = String.Empty; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.SupplementalValue4)) { codingDecisionsReportRow.SupplementalValue4 = String.Empty; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.SupplementalField5)) { codingDecisionsReportRow.SupplementalField5 = String.Empty; }
                if (String.IsNullOrWhiteSpace(codingDecisionsReportRow.SupplementalValue5)) { codingDecisionsReportRow.SupplementalValue5 = String.Empty; }
            }

            return codingDecisionsReportRows;
        }

        public static void SetOptionalIngredientReportRowColumns(this IEnumerable<IngredientReportRow> reportRows,
            string studyName)
        {
            if (ReferenceEquals(reportRows,null)) throw new ArgumentNullException("reportRows");

            foreach (var reportRow in reportRows)
            {
                reportRow.Study            = reportRow.Study           .SetInstantiatedValue(studyName);
                reportRow.Site             = reportRow.Site            .SetInstantiatedValue(Config.DefaultSiteKey);
                reportRow.Subject          = reportRow.Subject         .SetInstantiatedValue(Config.DefaultSubjectKey);
                reportRow.SupplementalData = reportRow.SupplementalData.SetInstantiatedValue(String.Empty);
            }
        }
    }
}

