
using System;
using System.Collections.Generic;

namespace Coder.DeclarativeBrowser.Models.GridModels
{
    public class SynonymRow : IEquatable<SynonymRow>
    {
        public string Verbatim                         { get; set; }
        public string CodedBy                          { get; set; }
        public string DictionaryAndLocale              { get; set; }
        public TermPathRow SelectedTermPathRow         { get; set; }
        public TermPathRow[] ExpandedTermPathRows      { get; set; }
        public string CreationDate                     { get; set; }
        public string ListName                         { get; set; }
        public SynonymStatus Status                    { get; set; }

        public bool Equals(SynonymRow target)
        {
            if (ReferenceEquals(target, null)) throw new ArgumentNullException("target");

            if (ReferenceEquals(this, target)) return true;

            if (String.IsNullOrWhiteSpace(Verbatim)) return false;
            if (String.IsNullOrWhiteSpace(target.Verbatim)) return false;

            if (ReferenceEquals(SelectedTermPathRow, null)) return false;
            if (ReferenceEquals(target.SelectedTermPathRow, null)) return false;

            if (Verbatim.Equals(target.Verbatim)
                && SelectedTermPathRow.Equals(target.SelectedTermPathRow))
            {
                return true;
            }

            return false;
        }
    }

    public enum SynonymStatus { Approved, Provisional }
}
