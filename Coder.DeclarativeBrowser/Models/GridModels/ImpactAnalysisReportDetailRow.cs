using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Microsoft.VisualBasic.ApplicationServices;


namespace Coder.DeclarativeBrowser.Models.GridModels
{

    namespace Coder.DeclarativeBrowser.Models.GridModels
    {
        public class ImpactAnalysisReportDetailRow
        {
            public string Verbatim         { get; set; }
            public string CurrentTerm      { get; set; }
            public string CurrentCode      { get; set; }
            public string CurrentCodedPath { get; set; }
            public string TermInNewVersion { get; set; }
            public string CodeInNewVersion { get; set; }
            public string NewCodedPath     { get; set; }


            public bool Equals(ImpactAnalysisReportDetailRow expected)
            {
                if (ReferenceEquals(expected, null)) throw new ArgumentNullException("expected");

                var result = expected.Verbatim.Contains(Verbatim, StringComparison.OrdinalIgnoreCase)
                             && CurrentTerm.IsNullOrEqualsIfRequired(expected.CurrentTerm)
                             && CurrentCode.IsNullOrEqualsIfRequired(expected.CurrentCode)
                             && CurrentCodedPath.IsNullOrEqualsIfRequired(expected.CurrentCodedPath)
                             && TermInNewVersion.IsNullOrEqualsIfRequired(expected.TermInNewVersion)
                             && CodeInNewVersion.IsNullOrEqualsIfRequired(expected.CodeInNewVersion)
                             && NewCodedPath.IsNullOrEqualsIfRequired(expected.NewCodedPath);


                return result;
            }

            public string ToString()
            {
                var response =
                    $"Verbatim: {Verbatim}, CurrentTerm: {CurrentTerm}, CurrentCode: {CurrentCode}, " +
                    $"CurrentCodedPath: {CurrentCodedPath}, TermInNewVersion: {TermInNewVersion}, CodeInNewVersion: {CodeInNewVersion}, NewCodedPath: {NewCodedPath}";

                return response;
            }

        }
    }
}
