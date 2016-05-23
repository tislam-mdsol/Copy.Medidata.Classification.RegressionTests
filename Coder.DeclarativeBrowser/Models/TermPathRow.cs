using System;
using System.Collections.Generic;
using System.Linq;

namespace Coder.DeclarativeBrowser.Models
{
    public class TermPathRow : IEquatable<TermPathRow>
    {
        public string Level     { get; set; }
        public string TermPath  { get; set; }
        public string Code      { get; set; }
        public bool HasSynonym  { get; set; }
        
        public bool Equals(TermPathRow other)
        {
            if (ReferenceEquals(other, null)) throw new ArgumentNullException("other");

            var result =   Level.Equals(other.Level,    StringComparison.OrdinalIgnoreCase)
                   &&   TermPath.Equals(other.TermPath, StringComparison.OrdinalIgnoreCase)
                   &&       Code.Equals(other.Code,     StringComparison.OrdinalIgnoreCase)
                   && HasSynonym.Equals(other.HasSynonym);

            return result;
        }

        public bool EqualsIgnoreCode(TermPathRow other)
        {
            if (ReferenceEquals(other, null)) throw new ArgumentNullException("other");

            var result = Level.Equals(other.Level, StringComparison.OrdinalIgnoreCase)
                   && TermPath.Equals(other.TermPath, StringComparison.OrdinalIgnoreCase)
                   && HasSynonym.Equals(other.HasSynonym);

            return result;
        }
    }
}
