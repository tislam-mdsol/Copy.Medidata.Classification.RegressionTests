using System;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text; 
using System.Xml; 
using System.Xml.Linq;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.ExtensionMethods;


namespace Coder.DeclarativeBrowser.FileHelpers
{
    public static class GenericFileHelper
    {
        private static XNamespace _Css_Ss_Class = "urn:schemas-microsoft-com:office:spreadsheet";
        private static XNamespace _Css_O_Class  = "urn:schemas-microsoft-com:office:office";
        private static XNamespace _Css_X_Class  = "urn:schemas-microsoft-com:office:excel";

        public static int GetFileRowCount(string filePath)
        {
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException(nameof(filePath));

            RetryPolicy.CheckDownloadFileExists.Execute( 
                () =>
                {
                    if (!File.Exists(filePath))
                        throw new FileNotFoundException(String.Format("Cannot find file {0}", filePath));
                });

            var rowCount = File.ReadLines(filePath).Count();

            return rowCount;
        }

        internal static void DownloadVerifiedFile(string downloadDirectory, string fileName, Action downloadAction, int expectedRows = 2)
        {
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException(nameof(downloadDirectory));
            if (String.IsNullOrWhiteSpace(fileName))          throw new ArgumentNullException(nameof(fileName));
            if (!Directory.Exists(downloadDirectory))         throw new ArgumentException(String.Format("Directory {0} does not exist", nameof(downloadDirectory)));

            var filePath = Path.Combine(downloadDirectory, fileName);

            RetryPolicy.ValidateDownloadedFile.Execute(() =>
            {
                File.Delete(filePath);
                downloadAction();
                VerifyFileRows(filePath, expectedRows);
            });
        }

        internal static void VerifyFileRows(string filePath, int expectedRows)
        {
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException(nameof(filePath));

            var rowCount = GetFileRowCount(filePath);

            if (rowCount < expectedRows)
            {
                throw new ApplicationException(String.Format("{0} only has {1} rows but expected at least {2} rows",
                    filePath,
                    rowCount,
                    expectedRows));
            }
        }

        internal static string UnzipFile(string zippedPath, string zippedFileName, string downloadDirectory)
        {
            if (String.IsNullOrWhiteSpace(zippedPath))        throw new ArgumentNullException(nameof(zippedPath));
            if (String.IsNullOrWhiteSpace(zippedFileName))    throw new ArgumentNullException(nameof(zippedFileName));
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException(nameof(downloadDirectory));

            var zippedFilePath = Path.Combine(zippedPath, zippedFileName);
            var unZippedPath   = zippedFilePath.Replace(".zip", "");

            using (ZipArchive archive = ZipFile.OpenRead(zippedFilePath))
            {
                foreach (ZipArchiveEntry entry in archive.Entries)
                {
                  entry.ExtractToFile(Path.Combine(downloadDirectory, entry.FullName),true);
                }
            }

            return unZippedPath;
        }

        internal static bool IsRaveXLSWorkSheetRowDataComparison(string filePath, string workSheetName, List<string> expectedSheetDataValues)
        {
            if (String.IsNullOrWhiteSpace(filePath))                   throw new ArgumentNullException(nameof(filePath));
            if (String.IsNullOrWhiteSpace(workSheetName))              throw new ArgumentNullException(nameof(workSheetName));
            if (!expectedSheetDataValues.Any())                        throw new ArgumentNullException("No expected values from table");

            XDocument workSheets = XDocument.Load(filePath + ".xls");

            var i = 0;

            foreach (XElement worksheet in workSheets.Descendants(_Css_Ss_Class + "Worksheet"))
            {
                if (worksheet.Attribute(_Css_Ss_Class + "Name").Value.Equals(workSheetName, StringComparison.OrdinalIgnoreCase))
                {
                    var skipFirstRow = worksheet.Descendants(_Css_Ss_Class + "Row").Skip(1);

                    foreach (XElement row in skipFirstRow)
                    {
                       foreach (XElement cell in row.Descendants(_Css_Ss_Class + "Data"))
                       {
                         var expectedValue = expectedSheetDataValues[i];
                         var actualValue   = cell.Value;

                         if (!expectedValue.Equals(actualValue, StringComparison.OrdinalIgnoreCase))
                         {
                            return false;
                         }

                         i++;
                       }
                    }
                 }
            }
            
            return true;
        }

        internal static string GetValueinSpreadSheetByRowAndColumnIndex(string filePath, string workSheetName, int rowIndex, int columnIndex)
        {
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException(nameof(filePath));
            if (String.IsNullOrWhiteSpace(workSheetName)) throw new ArgumentNullException(nameof(workSheetName));

            XDocument workSheets = XDocument.Load(filePath + ".xls");

            var valueContent = "";

            foreach (XElement worksheet in workSheets.Descendants(_Css_Ss_Class + "Worksheet"))
            {
                if (worksheet.Attribute(_Css_Ss_Class + "Name").Value.Equals(workSheetName, StringComparison.OrdinalIgnoreCase))
                {
                    var workSheetRows    = worksheet.Descendants(_Css_Ss_Class + "Row").ToArray();

                    var workSheetColumns = workSheetRows[rowIndex].Descendants(_Css_Ss_Class + "Data").ToArray();

                    valueContent         = workSheetColumns[columnIndex].Value;
                }
            }

            return valueContent;
        }

        internal static string[] GetDirectoryPaths(string downloadDirectory, string filePath)
        {
            string[] filePaths = Directory.GetFiles(@downloadDirectory, filePath);

            return filePaths;
        }


    }
}
