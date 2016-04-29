using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using CsvHelper;

namespace Coder.DeclarativeBrowser.FileHelpers
{
    public static class GenericCsvHelper
    {
        public static IEnumerable<T> GetReportRows<T>(string downloadedFilePath) where T : new()
        {
            if (String.IsNullOrWhiteSpace(downloadedFilePath)) throw new ArgumentNullException("downloadedFilePath");

            RetryPolicy.CheckDownloadFileExists.Execute(
                () =>
                {
                    if (!File.Exists(downloadedFilePath))
                        throw new FileNotFoundException(String.Format("Cannot find file {0}", downloadedFilePath));
                });

            using(var textReader = File.OpenText(downloadedFilePath))
            {
                var reportRows = GetRowsFromTextReader<T>(textReader);

                return reportRows;
            }
        }

        public static IEnumerable<T> GetReportRows<T>(IEnumerable<string> csvRows) where T : new()
        {
            if (ReferenceEquals(csvRows,null)) throw new ArgumentNullException("csvRows");

            using (var textReader = new StringReader(String.Join(Environment.NewLine, csvRows)))
            {
                var reportRows = GetRowsFromTextReader<T>(textReader);

                return reportRows;
            }
        }

        public static bool AreCsvRowStringsEqual(this IDelimitedRow actual, IDelimitedRow expected)
        {
            if (ReferenceEquals(actual, null))   throw new ArgumentNullException("actual");
            if (ReferenceEquals(expected, null)) throw new ArgumentNullException("expected");

            bool propertiesAreEquivalent = false;

            var properties = actual.GetType().GetProperties()
                .Where(x => x.CanRead && x.CanWrite)
                .Where(x => x.PropertyType == typeof(String));

            foreach (var property in properties)
            {
                var actualProperty   = property.GetValue(actual, null);
                var expectedProperty = expected.GetType().GetProperty(property.Name).GetValue(expected, null);

                var actualValue      = actualProperty.ToStringOrDefault();
                var expectedValue    = expectedProperty.ToStringOrDefault();

                propertiesAreEquivalent = actualValue.IsNullOrEqualsIfRequired(expectedValue);

                if (!propertiesAreEquivalent)
                {
                    break;
                }
            }

            return propertiesAreEquivalent;
        }

        public static void WriteDelimitedFile<T>(IEnumerable<T> dataRows, string filePath, bool writeHeader) where T : IDelimitedRow
        {
            if (ReferenceEquals(dataRows, null))     throw new ArgumentNullException("dataRows");
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException("filePath");

            var rowsArray = dataRows.ToArray();
            if (!rowsArray.Any()) throw new ArgumentException("data collection is empty");
            
            using (var writer = new StreamWriter(filePath))
            {
                if (writeHeader)
                {
                    writer.WriteLine(GetDelimitedHeader<T>(rowsArray.First().Delimiter));
                }

                foreach (var row in rowsArray)
                {
                    writer.WriteLine(GetDelimitedRow<T>(row, row.Delimiter, row.QuoteChar));
                }
            }
        }

        private static IEnumerable<T> GetRowsFromTextReader<T>(TextReader textReader) where T : new()
        {
            if (ReferenceEquals(textReader, null)) throw new ArgumentNullException("textReader");

            var csvReader = new CsvReader(textReader);
            Config.SetCsvReaderConfig(csvReader);

            var reportModelRows = csvReader.GetRecords<T>();

            return reportModelRows.ToArray();
        }
        
        private static string GetDelimitedHeader<T>(char delimiter)
        {
            var propertyInfos = typeof(T).GetProperties();

            var headersSorted = propertyInfos
                .Select(x => (CsvColumnNameAttribute)Attribute.GetCustomAttribute(x, typeof(CsvColumnNameAttribute), false))
                .Where(x => x != null)
                .OrderBy(x => x.Order)
                .Select(x => x.Name);

            var csvHeaderSorted = String.Join(delimiter.ToString(), headersSorted);

            return csvHeaderSorted;
        }

        private static string GetDelimitedRow<T>(T csvDataObject, char delimiter, char quoteChar)
        {
            if (ReferenceEquals(csvDataObject, null)) throw new ArgumentNullException("csvDataObject");

            var propertyInfos = typeof (T).GetProperties();

            var valuesSorted = propertyInfos
                .Select(x => new
                {
                    Value = x.GetValue(csvDataObject, null),
                    Attribute =
                        (CsvColumnNameAttribute) Attribute.GetCustomAttribute(x, typeof (CsvColumnNameAttribute), false)
                })
                .Where(x => x.Attribute != null)
                .OrderBy(x => x.Attribute.Order)
                .Select(x => GetPropertyValueAsString(x.Value));

            var outputValues = valuesSorted.EscapeDelimitersWithQuotes(quoteChar, delimiter);
            var delimitedRow = String.Join(delimiter.ToString(), outputValues);

            return delimitedRow;
        }

        private static string GetPropertyValueAsString(object propertyValue)
        {
            if (ReferenceEquals(propertyValue, null))
            {
                return String.Empty;
            }

            var propertyValueString = propertyValue.ToString();

            return propertyValueString;
        }
    }
}
