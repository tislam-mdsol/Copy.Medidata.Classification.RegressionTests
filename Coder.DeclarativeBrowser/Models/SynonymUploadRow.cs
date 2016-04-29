using Coder.DeclarativeBrowser.ExtensionMethods;
using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.FileHelpers;
using Microsoft.VisualBasic.FileIO;

namespace Coder.DeclarativeBrowser.Models
{
    public class SynonymUploadRow : IEquatable<SynonymUploadRow>, IDelimitedRow
    {
        private const char _Delimiter = '|';
        private const char _QuoteChar = '"';

        public char Delimiter { get { return _Delimiter; } }
        public char QuoteChar { get { return _QuoteChar; } }

        [CsvColumnName(Name = "Verbatim"               , Order = 0)]
        public string Verbatim { get; set; }

        [CsvColumnName(Name = "Code"                   , Order = 1)]
        public string Code { get; set; }

        [CsvColumnName(Name = "Level"                  , Order = 2)]
        public string Level { get; set; }

        [CsvColumnName(Name = "Path"                   , Order = 3)]
        public string Path { get; set; }

        [CsvColumnName(Name = "Primary Flag"           , Order = 4)]
        public string PrimaryFlag { get; set; }

        [CsvColumnName(Name = "Supplemental Info"      , Order = 5)]
        public string SupplementalInfo { get; set; }

        [CsvColumnName(Name = "Status"                 , Order = 6)]
        public string Status { get; set; }

        [CsvColumnName(Name = "Dictionary Term Literal", Order = 7)]
        public string DictionaryTermLiteral { get; set; }

        public SynonymUploadRow() { }

        public SynonymUploadRow(string[] synonymRowData)
        {
            if (ReferenceEquals(synonymRowData, null)) throw new ArgumentNullException("synonymRowData");

            if (synonymRowData.Count() < 7)
            {
                throw new ArgumentException("Not enough synonymRowData fields provided. Check that the source data has the correct number of columns.");
            }

            Verbatim              = synonymRowData.ElementAtOrEmpty(0);
            Code                  = synonymRowData.ElementAtOrEmpty(1);
            Level                 = synonymRowData.ElementAtOrEmpty(2);
            Path                  = synonymRowData.ElementAtOrEmpty(3);
            PrimaryFlag           = synonymRowData.ElementAtOrEmpty(4);
            SupplementalInfo      = synonymRowData.ElementAtOrEmpty(5);
            Status                = synonymRowData.ElementAtOrEmpty(6);
            DictionaryTermLiteral = synonymRowData.ElementAtOrEmpty(7);
        }

        public override bool Equals(object obj)
        {
            var result = Equals(obj as SynonymUploadRow);
            return result;
        }

        public bool Equals(SynonymUploadRow other)
        {
            if (ReferenceEquals(other, null))
                return false;

            var comparisonType = StringComparison.OrdinalIgnoreCase;
            
            var result =
               Verbatim             .Equals(other.Verbatim             , comparisonType) &&
               Code                 .Equals(other.Code                 , comparisonType) &&
               Level                .Equals(other.Level                , comparisonType) &&
               Path                 .Equals(other.Path                 , comparisonType) &&
               PrimaryFlag          .Equals(other.PrimaryFlag          , comparisonType) &&
               SupplementalInfo     .Equals(other.SupplementalInfo     , comparisonType) &&
               Status               .Equals(other.Status               , comparisonType) &&
               DictionaryTermLiteral.Equals(other.DictionaryTermLiteral, comparisonType);

            return result;
        }

        public override int GetHashCode()
        {
            var comparer = StringComparer.OrdinalIgnoreCase;

            var result =
                comparer.GetHashCode(Verbatim)         ^
                comparer.GetHashCode(Code)             ^
                comparer.GetHashCode(Level)            ^
                comparer.GetHashCode(Path)             ^
                comparer.GetHashCode(PrimaryFlag)      ^
                comparer.GetHashCode(SupplementalInfo) ^
                comparer.GetHashCode(Status)           ^
                comparer.GetHashCode(DictionaryTermLiteral);

            return result;
        }

        public static Boolean operator ==(SynonymUploadRow target, SynonymUploadRow other)
        {
            if (ReferenceEquals(target, other))
                return true;

            if (ReferenceEquals(target, null) || ReferenceEquals(other,null))
                return false;

            var result = target.Equals(other);
            return result;
        }

        public static Boolean operator !=(SynonymUploadRow target, SynonymUploadRow other)
        {
            var result = !(target == other);
            return result;
        }
        
        /// <summary>
        /// Parses a Synonym List File into a sorted list of synonyms with verbatim terms as key values. 
        /// <para> Synonym lists downloaded from Coder do not have a consistent order. The sorted lists is used to ensure that 
        ///  multiple downloads of the same list is always represented the same.</para>
        /// </summary>
        /// <param name="sourceFilePath">Assumes file in the same format as the Synonym List Template, https://learn.mdsol.com/display/CODERstg/SynonymUploadRow+List+File+Definition?lang=en </param>
        /// <returns> A sorted list of synonyms with verbatim terms as key values.</returns>
        public static SortedList<string, SynonymUploadRow> GetSynonymsFromTxtFile(string sourceFilePath)
        {
            if (String.IsNullOrWhiteSpace(sourceFilePath)) throw new ArgumentNullException("sourceFilePath");

            SortedList<string, SynonymUploadRow> synonyms = new SortedList<string, SynonymUploadRow>();

            using (TextFieldParser txtReader = new TextFieldParser(sourceFilePath))
            {
                txtReader.SetDelimiters(new string[] {"|"});
                txtReader.HasFieldsEnclosedInQuotes = true;
                string[] headerFields = txtReader.ReadFields();
                while (!txtReader.EndOfData)
                {
                    string[] rowData = txtReader.ReadFields();

                    SynonymUploadRow synonymUploadRow = new SynonymUploadRow(rowData);

                    synonyms.Add(synonymUploadRow.Verbatim, synonymUploadRow);
                }
            }

            return synonyms;
        }
    }
}
