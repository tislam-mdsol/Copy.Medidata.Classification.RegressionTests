using System;
using System.Linq;
using Coder.DeclarativeBrowser.FileHelpers;
using Coder.DeclarativeBrowser.ExtensionMethods;

namespace Coder.DeclarativeBrowser.Models
{
    public class ExternalVerbatim : IDelimitedRow, IEquatable<ExternalVerbatim>
    {
        private const char _Delimiter = ',';
        private const char _QuoteChar = '"';

        public char Delimiter { get { return _Delimiter; } }
        public char QuoteChar { get { return _QuoteChar; } }
        
        [CsvColumnName(Name="Study ID",               Order = 1)]
        public string StudyID            { get; set; }

        [CsvColumnName(Name = "Subject",              Order = 2)]
        public string Subject            { get; set; }

        [CsvColumnName(Name = "Site",                 Order = 3)]
        public string Site               { get; set; }

        [CsvColumnName(Name = "Event",                Order = 4)]
        public string Event              { get; set; }

        [CsvColumnName(Name = "Form",                 Order = 5)]
        public string Form               { get; set; }

        [CsvColumnName(Name = "Line",                 Order = 6)]
        public string Line               { get; set; }

        [CsvColumnName(Name = "Field",                Order = 7)]
        public string Field              { get; set; }

        [CsvColumnName(Name = "Verbatim Term",        Order = 8)]
        public string VerbatimTerm       { get; set; }

        [CsvColumnName(Name = "Supplemental Field 1", Order = 9)]
        public string SupplementalField1 { get; set; }

        [CsvColumnName(Name = "Supplemental Value 1", Order = 10)]
        public string SupplementalValue1 { get; set; }

        [CsvColumnName(Name = "Supplemental Field 2", Order = 11)]
        public string SupplementalField2 { get; set; }

        [CsvColumnName(Name = "Supplemental Value 2", Order = 12)]
        public string SupplementalValue2 { get; set; }

        [CsvColumnName(Name = "Supplemental Field 3", Order = 13)]
        public string SupplementalField3 { get; set; }

        [CsvColumnName(Name = "Supplemental Value 3", Order = 14)]
        public string SupplementalValue3 { get; set; }

        [CsvColumnName(Name = "Supplemental Field 4", Order = 15)]
        public string SupplementalField4 { get; set; }

        [CsvColumnName(Name = "Supplemental Value 4", Order = 16)]
        public string SupplementalValue4 { get; set; }

        [CsvColumnName(Name = "Supplemental Field 5", Order = 17)]
        public string SupplementalField5 { get; set; }

        [CsvColumnName(Name = "Supplemental Value 5", Order = 18)]
        public string SupplementalValue5 { get; set; }

        [CsvColumnName(Name = "Dictionary",           Order = 19)]
        public string Dictionary { get; set; }

        [CsvColumnName(Name = "Dictionary Level",     Order = 20)]
        public string DictionaryLevel { get; set; }

        [CsvColumnName(Name = "Priority",             Order = 21)]
        public string Priority { get; set; }

        [CsvColumnName(Name = "Locale",               Order = 22)]
        public string Locale { get; set; }

        [CsvColumnName(Name = "IsApprovalRequired",   Order = 23)]
        public string IsApprovalRequired { get; set; }

        [CsvColumnName(Name = "IsAutoApproval",       Order = 24)]
        public string IsAutoApproval { get; set; }

        [CsvColumnName(Name = "Batch Identifier",     Order = 25)]
        public string BatchIdentifier { get; set; }

        public string DictionaryVersionLocale { get; set; }
        public string Level1                  { get; set; }
        public string Level1Text              { get; set; }
        public string Level1Code              { get; set; }
        public string Level2                  { get; set; }
        public string Level2Text              { get; set; }
        public string Level2Code              { get; set; }
        public string Level3                  { get; set; }
        public string Level3Text              { get; set; }
        public string Level3Code              { get; set; }
        public string Level4                  { get; set; }
        public string Level4Text              { get; set; }
        public string Level4Code              { get; set; }
        public string Level5                  { get; set; }
        public string Level5Text              { get; set; }
        public string Level5Code              { get; set; }
        public string Level6                  { get; set; }
        public string Level6Text              { get; set; }
        public string Level6Code              { get; set; }
        public string Level7                  { get; set; }
        public string Level7Text              { get; set; }
        public string Level7Code              { get; set; }
        public string Error                   { get; set; }
        public string DiagnosticError         { get; set; }

        public bool Equals(ExternalVerbatim expected)
        {
            if (ReferenceEquals(expected, null)) return false;

            bool result = this.AreCsvRowStringsEqual(expected);

            return result;
        }

        public new string ToString()
        {
            var response = String.Format("StudyUUID: {0}; Verbatim: {1}; Dictionary: {2}; Level: {3}; Error: {4}",
                StudyID,
                VerbatimTerm,
                Dictionary,
                DictionaryLevel,
                Error);

            return response;
        }
    }
}
