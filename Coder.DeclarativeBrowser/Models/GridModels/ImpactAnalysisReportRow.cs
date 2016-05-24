using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Microsoft.VisualBasic.ApplicationServices;

namespace Coder.DeclarativeBrowser.Models.GridModels
{
    public class ImpactAnalysisReportRow
    {
        public string NotAffected                    { get; set; }
        public string CodingToNewVersionSynonym      { get; set; }
        public string CodingToNewVersionDirectMatch { get; set; }
        public string PathChanged                    { get; set; }
        public string CasingChangedOnly              { get; set; }
        public string Obsolete                       { get; set; }
        public string TermNotFound                   { get; set; }
        

        public bool Equals(ImpactAnalysisReportRow expected)
        {
            if (ReferenceEquals(expected, null)) throw new ArgumentNullException("expected");

            var result = expected.NotAffected.Contains(NotAffected, StringComparison.OrdinalIgnoreCase)
                         && CodingToNewVersionSynonym.IsNullOrEqualsIfRequired(expected.CodingToNewVersionSynonym)
                         && CodingToNewVersionDirectMatch.IsNullOrEqualsIfRequired(expected.CodingToNewVersionDirectMatch)
                         && PathChanged.IsNullOrEqualsIfRequired(expected.PathChanged)
                         && CasingChangedOnly.IsNullOrEqualsIfRequired(expected.CasingChangedOnly)
                         && Obsolete.IsNullOrEqualsIfRequired(expected.Obsolete)
                         && TermNotFound.IsNullOrEqualsIfRequired(expected.TermNotFound);


            return result;
        }

        public string ToString()
        {
            var response =
                $"NotAffected: {NotAffected}, CodingToNewVersionSynonym: {CodingToNewVersionSynonym}, CodingToNewVErsionDicrectMatch: {CodingToNewVersionDirectMatch}, " +
                $"PathChanged: {PathChanged}, CasingChangedOnly: {CasingChangedOnly}, Obsolete: {Obsolete}, TermNotFound: {TermNotFound}";

            return response;
        }

    }
}
