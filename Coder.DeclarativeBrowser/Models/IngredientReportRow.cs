using System;
using Coder.DeclarativeBrowser.FileHelpers;

namespace Coder.DeclarativeBrowser.Models
{
    public class IngredientReportRow : IEquatable<IngredientReportRow>
    {
        [CsvColumnName(Name = "Study"            , Order = 0)]
        public string Study { get; set; }

        [CsvColumnName(Name = "Site"             , Order = 1)]
        public string Site { get; set; }

        [CsvColumnName(Name = "Subject"          , Order = 2)]
        public string Subject { get; set; }

        [CsvColumnName(Name = "Verbatim"         , Order = 3)]
        public string Verbatim { get; set; }

        [CsvColumnName(Name = "Dictionary"       , Order = 4)]
        public string Dictionary { get; set; }

        [CsvColumnName(Name = "Dictionary Level" , Order = 5)]
        public string DictionaryLevel { get; set; }

        [CsvColumnName(Name = "Path"             , Order = 6)]
        public string Path { get; set; }

        [CsvColumnName(Name = "Supplemental Data", Order = 7)]
        public string SupplementalData { get; set; }

        [CsvColumnName(Name = "Ingredients"      , Order = 8)]
        public string Ingredients { get; set; }

        public bool Equals(IngredientReportRow other)
        {
            if (ReferenceEquals(other, null)) return false;

            var result = Study.Equals              (other.Study)
                         && Site.Equals            (other.Site)
                         && Subject.Equals         (other.Subject)
                         && Verbatim.Equals        (other.Verbatim)
                         && Dictionary.Equals      (other.Dictionary)
                         && DictionaryLevel.Equals (other.DictionaryLevel)
                         && Path.Equals            (other.Path)
                         && SupplementalData.Equals(other.SupplementalData)
                         && Ingredients.Equals     (other.Ingredients);

            return result;
        }

        public new string ToString()
        {
            var result = String.Format(
                "Study: {0}, " +
                "Site: {1}, " +
                "Subject: {2}, " +
                "Verbatim: {3}, " +
                "Dictionary: {4}, " +
                "Dictionary Level: {5}, " +
                "Path: {6}, " +
                "Supplemental Data: {7}, " +
                "Ingredients: {8}",
                Study, Site, Subject, Verbatim, Dictionary, DictionaryLevel, Path, SupplementalData, Ingredients);

            return result;
        }
    }
}
