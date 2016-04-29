
using System;
using Coder.DeclarativeBrowser.ExtensionMethods;

namespace Coder.DeclarativeBrowser.Models.ETEModels
{
    public class RaveCoderFieldConfiguration
    {
        public string Form                { get; set; }
        public string Field               { get; set; }
        public string Dictionary          { get; set; }
        public string Locale              { get; set; }
        public string CodingLevel         { get; set; }
        public string Priority            { get; set; }
        public string IsApprovalRequired  { get; set; }
        public string IsAutoApproval      { get; set; }
        public string SupplementalTerms   { get; set; }

        public bool Equals(RaveCoderFieldConfiguration expected)
        {
            if (ReferenceEquals(expected, null)) throw new ArgumentNullException("expected");

            var result = Form                              .IsNullOrEqualsIfRequired(expected.Form)
                      && Field                             .IsNullOrEqualsIfRequired(expected.Field)
                      && Dictionary                        .IsNullOrEqualsIfRequired(expected.Dictionary)
                      && Locale                            .IsNullOrEqualsIfRequired(expected.Locale)
                      && CodingLevel                       .IsNullOrEqualsIfRequired(expected.CodingLevel)
                      && Priority                          .IsNullOrEqualsIfRequired(expected.Priority)
                      && IsApprovalRequired                .IsNullOrEqualsIfRequired(expected.IsApprovalRequired)
                      && IsAutoApproval                    .IsNullOrEqualsIfRequired(expected.IsAutoApproval)
                      && AreSupplementalTermsEqual(expected.SupplementalTerms);

            return result;
        }

        private bool AreSupplementalTermsEqual(string expectedSupplementalTerms)
        {
            if (ReferenceEquals(SupplementalTerms, null) || ReferenceEquals(expectedSupplementalTerms, null))
            {
                return SupplementalTerms.IsNullOrEqualsIfRequired(expectedSupplementalTerms);
            }

            return SupplementalTerms.RemoveNonAlphanumeric().IsNullOrEqualsIfRequired(expectedSupplementalTerms.RemoveNonAlphanumeric());
        }
    }
}
