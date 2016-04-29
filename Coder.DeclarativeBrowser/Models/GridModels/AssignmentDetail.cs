
using System;
using FluentAssertions;

namespace Coder.DeclarativeBrowser.Models.GridModels
{
    public class AssignmentDetail : IEquatable<AssignmentDetail>
    {
        public string Dictionary    { get; set; }
        public string User          { get; set; }
        public string Term          { get; set; }
        public string IsAutoCoded   { get; set; }
        public string IsActive      { get; set; }

        public bool Equals(AssignmentDetail other)
        {
            if (ReferenceEquals(other,null)) throw new ArgumentNullException("other");

            var result = Dictionary.Equals  (other.Dictionary)
                && User            .Contains(other.User)
                && Term            .Equals  (other.Term)
                && IsAutoCoded     .Equals  (other.IsAutoCoded)
                && IsActive        .Equals  (other.IsActive);

            return result;
        }
    }
}
