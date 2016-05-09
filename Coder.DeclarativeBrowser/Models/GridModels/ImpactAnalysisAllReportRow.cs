using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Microsoft.VisualBasic.ApplicationServices;

namespace Coder.DeclarativeBrowser.Models.GridModels
{
    public class ImpactAnalysisAllReportRow
    {
        public string Study { get; set; }
        public string DictionaryType { get; set; }
        public string ToVersion { get; set; }
        public string ToSynonymList { get; set; }
        public string ReportCreated { get; set; }


        public bool Equals(ImpactAnalysisAllReportRow expected)
        {
            if (ReferenceEquals(expected, null)) throw new ArgumentNullException("expected");

            var result = expected.Study.Contains(Study, StringComparison.OrdinalIgnoreCase)
                         && DictionaryType.IsNullOrEqualsIfRequired(expected.DictionaryType)
                         && ToVersion.IsNullOrEqualsIfRequired(expected.ToVersion)
                         && ToSynonymList.IsNullOrEqualsIfRequired(expected.ToSynonymList);


            return result;
        }

        public string ToString()
        {
            var response =
                $"Study: {Study}, DictionaryType: {DictionaryType}, ToVersion: {ToVersion}, ToSynonymList: {ToSynonymList}";

            return response;
        }

    }
}
