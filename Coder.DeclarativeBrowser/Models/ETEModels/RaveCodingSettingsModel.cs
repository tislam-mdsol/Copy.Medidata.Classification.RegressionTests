//@author:smalik
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.ExtensionMethods;

namespace Coder.DeclarativeBrowser.Models.ETEModels
{
    public class RaveCodingSettingsModel
    {
        public string Column        { get; set; }
        public string TermSuffix    { get; set; }
        public string TermSASSuffix { get; set; }
        public string TermLength    { get; set; }
        public string CodeSuffix    { get; set; }
        public string CodeSASSuffix { get; set; }
        public string CodeLength    { get; set; }

        public bool Equals(RaveCodingSettingsModel expected)
         {
             if (ReferenceEquals(expected, null)) throw new ArgumentNullException("expected");

             var result = Column       .IsNullOrEqualsIfRequired(expected.Column)
                       && TermSuffix   .IsNullOrEqualsIfRequired(expected.TermSuffix)
                       && TermSASSuffix.IsNullOrEqualsIfRequired(expected.TermSASSuffix)
                       && TermLength   .IsNullOrEqualsIfRequired(expected.TermLength)
                       && CodeSuffix   .IsNullOrEqualsIfRequired(expected.CodeSuffix)
                       && CodeSASSuffix.IsNullOrEqualsIfRequired(expected.CodeSASSuffix)
                       && CodeLength   .IsNullOrEqualsIfRequired(expected.CodeLength);

                   return result;
         }
    }
}
