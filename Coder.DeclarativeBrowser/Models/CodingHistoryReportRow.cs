using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.FileHelpers;

namespace Coder.DeclarativeBrowser.Models
{
    public class CodingHistoryReportRow : IDelimitedRow, IEquatable<CodingHistoryReportRow>
    {
        private const char _Delimiter = ',';
        private const char _QuoteChar = '"';

        public char Delimiter { get { return _Delimiter; } }
        public char QuoteChar { get { return _QuoteChar; } }

        [CsvColumnName(Name="Subject", Order = 1)]
        public string Subject      { get; set; }
        
        [CsvColumnName(Name = "Verbatim Term", Order = 2)]
        public string VerbatimTerm    { get; set; }
        
        [CsvColumnName(Name = "User", Order = 3)]
        public string User        { get; set; }

        [CsvColumnName(Name = "Term", Order = 4)]
        public string Term            { get; set; }

        [CsvColumnName(Name = "Code", Order = 5)]
        public string Code            { get; set; }

        [CsvColumnName(Name = "Path", Order = 6)]
        public string Path            { get; set; }

        [CsvColumnName(Name = "Dictionary", Order = 7)]
        public string Dictionary      { get; set; }

        [CsvColumnName(Name = "Version", Order = 8)]
        public string Version         { get; set; }

        [CsvColumnName(Name = "Created", Order = 9)]
        public string Created         { get; set; }

        [CsvColumnName(Name = "Status", Order = 10)]
        public string Status          { get; set; }

        [CsvColumnName(Name = "Action", Order = 11)]
        public string Action          { get; set; }

        [CsvColumnName(Name = "System Action", Order = 12)]
        public string SystemAction    { get; set; }

        [CsvColumnName(Name = "Study", Order = 13)]
        public string Study           { get; set; }

        [CsvColumnName(Name = "Form", Order = 14)]
        public string Form            { get; set; }

        [CsvColumnName(Name = "Field", Order = 15)]
        public string Field           { get; set; }

        [CsvColumnName(Name = "Source System", Order = 16)]
        public string SourceSystem    { get; set; }

        [CsvColumnName(Name = "Comment", Order = 17)]
        public string Comment         { get; set; }

        [CsvColumnName(Name = "CodingElementId", Order = 18)]
        public string CodingElementId { get; set; }

        [CsvColumnName(Name = "UUID", Order = 19)]
        public string Uuid            { get; set; }

        [CsvColumnName(Name = "Query Status", Order = 20)]
        public string QueryStatus     { get; set; }

        [CsvColumnName(Name = "Query Text", Order = 21)]
        public string QueryText       { get; set; }

        [CsvColumnName(Name = "Query Response", Order = 22)]
        public string QueryReponse    { get; set; }

        [CsvColumnName(Name = "Query Notes", Order = 23)]
        public string QueryNotes      { get; set; }

        [CsvColumnName(Name = "Time Stamp", Order = 24)]
        public string TimeStamp       { get; set; }

        public bool Equals(CodingHistoryReportRow expected)
        {
            if (ReferenceEquals(expected, null)) return false;

            var result = this.AreCsvRowStringsEqual(expected);

            return result;
        }

        public new string ToString()
        {
            var result = String.Format("Subject: {0}, Verbatim Term: {1}, Dictionary: {2}, Term: {3}, Code: {4}",
                Subject,
                VerbatimTerm,
                Dictionary,
                Term,
                Code);

            return result;
        }
    }
}
