using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.Models
{
    public class StudyImpactAnalysisActions : IEquatable<StudyImpactAnalysisActions>
    {
        public bool GenerateReport    { get; set; }
        public bool MigrateStudy      { get; set; }
        public bool EditStudyAnalysis { get; set; }
        public bool ExportReport      { get; set; }

        public bool Equals(StudyImpactAnalysisActions other)
        {
            if (GenerateReport.Equals(other.GenerateReport)
                && MigrateStudy.Equals(other.MigrateStudy)
                && EditStudyAnalysis.Equals(other.EditStudyAnalysis)
                && ExportReport.Equals(other.ExportReport))
            {
                return true;
            }

            return false;
        }
    }
}
