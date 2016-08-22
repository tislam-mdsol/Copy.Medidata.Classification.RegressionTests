
using System;

namespace Coder.DeclarativeBrowser.Models.GridModels
{
    public class PropertyMedicalDictionary : IEquatable<PropertyMedicalDictionary>
    {
        public string MedicalDictionary     { get; set; }
        public string Segment               { get; set; }
        public string DictionaryLevel       { get; set; }
        public string VerbatimTerm          { get; set; }
        public string Priority              { get; set; }
        public string Locale                { get; set; }
        public string Uuid                  { get; set; }

        public bool Equals(PropertyMedicalDictionary other)
        {
            if (ReferenceEquals(other,null)) throw new ArgumentNullException("other");

            var result = MedicalDictionary.Equals (other.MedicalDictionary)
                         && Segment.Equals        (other.Segment)
                         && DictionaryLevel.Equals(other.DictionaryLevel)
                         && VerbatimTerm.Equals   (other.VerbatimTerm)
                         && Priority.Equals       (other.Priority)
                         && Locale.Equals         (other.Locale);

            return result;
        }

        public string ToString()
        {
            var response = String.Format("Dictionary: {0}, Segment: {1}, Level: {2}, Verbatim: {3}, Priority: {4}, Locale: {5}",
                MedicalDictionary, Segment, DictionaryLevel, VerbatimTerm, Priority, Locale);

            return response;
        }
    }
}
