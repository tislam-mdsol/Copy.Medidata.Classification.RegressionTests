using System;
using Coder.DeclarativeBrowser.FileHelpers;

namespace Coder.DeclarativeBrowser.Models
{
    public class CodingDecisionsReportRow : IDelimitedRow, IEquatable<CodingDecisionsReportRow>
    {
        private const char _Delimiter = ',';
        private const char _QuoteChar = '"';

        public char Delimiter { get { return _Delimiter; } }
        public char QuoteChar { get { return _QuoteChar; } }

        [CsvColumnName(Name = "Study Name"            , Order = 1)]
        public string StudyName                    { get; set; }
        
        [CsvColumnName(Name = "Verbatim Term"         , Order = 2)]
        public string VerbatimTerm                 { get; set; }

        [CsvColumnName(Name = "Dictionary"            , Order = 3)]
        public string Dictionary                   { get; set; }

        [CsvColumnName(Name = "Dictionary Level"      , Order = 4)]
        public string DictionaryLevel              { get; set; }

        [CsvColumnName(Name = "Path"                  , Order = 5)]
        public string Path                         { get; set; }

        [CsvColumnName(Name = "Subject"               , Order = 6)]
        public string Subject                      { get; set; }

        [CsvColumnName(Name = "Coded by"              , Order = 7)]
        public string CodedBy                      { get; set; }

        [CsvColumnName(Name = "Approved By"           , Order = 8)]
        public string ApprovedBy                   { get; set; }

        [CsvColumnName(Name = "Current Workflow State", Order = 9)]
        public string CurrentWorkflowState         { get; set; }

        [CsvColumnName(Name = "Code"                  , Order = 10)]
        public string Code                         { get; set; }

        [CsvColumnName(Name = "Term"                  , Order = 11)]
        public string Term                         { get; set; }

        [CsvColumnName(Name = "Is Auto Coded"         , Order = 12)]
        public string IsAutoCoded                  { get; set; }

        [CsvColumnName(Name = "Coded Date"            , Order = 13)]
        public string CodedDate                    { get; set; }

        [CsvColumnName(Name = "Priority"              , Order = 14)]
        public string Priority                     { get; set; }

        [CsvColumnName(Name = "Logline"               , Order = 15)]
        public string Logline                      { get; set; }

        [CsvColumnName(Name = "Supplemental Field 1"  , Order = 16)]
        public string SupplementalField1           { get; set; }

        [CsvColumnName(Name = "Supplemental Value 1"  , Order = 17)]
        public string SupplementalValue1           { get; set; }

        [CsvColumnName(Name = "Supplemental Field 2"  , Order = 18)]
        public string SupplementalField2           { get; set; }

        [CsvColumnName(Name = "Supplemental Value 2"  , Order = 19)]
        public string SupplementalValue2           { get; set; }

        [CsvColumnName(Name = "Supplemental Field 3"  , Order = 20)]
        public string SupplementalField3           { get; set; }

        [CsvColumnName(Name = "Supplemental Value 3"  , Order = 21)]
        public string SupplementalValue3           { get; set; }

        [CsvColumnName(Name = "Supplemental Field 4"  , Order = 22)]
        public string SupplementalField4           { get; set; }

        [CsvColumnName(Name = "Supplemental Value 4"  , Order = 23)]
        public string SupplementalValue4           { get; set; }

        [CsvColumnName(Name = "Supplemental Field 5"  , Order = 24)]
        public string SupplementalField5           { get; set; }

        [CsvColumnName(Name = "Supplemental Value 5"  , Order = 25)]
        public string SupplementalValue5           { get; set; }

        public bool Equals(CodingDecisionsReportRow expected)
        {
            if (ReferenceEquals(expected, null)) return false;

            bool result = this.AreCsvRowStringsEqual(expected);

            return result;
        }

        public new string ToString()
        {
            var response = String.Format("Study Name: {0}; Verbatim Term: {1}; Dictionary: {2}; Level: {3}; Code: {4}",
                StudyName,
                VerbatimTerm,
                Dictionary,
                DictionaryLevel,
                Code);

            return response;
        }
    }
}
