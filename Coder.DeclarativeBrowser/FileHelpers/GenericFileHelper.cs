using System;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text; 
using System.Xml; 
using System.Xml.Linq;
using System.Collections.Generic; 


namespace Coder.DeclarativeBrowser.FileHelpers
{
    public static class GenericFileHelper
    {
        public static int GetFileRowCount(string filePath)
        {
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException("filePath");

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
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException("downloadDirectory");
            if (String.IsNullOrWhiteSpace(fileName))          throw new ArgumentNullException("fileName");
            if (!Directory.Exists(downloadDirectory))         throw new ArgumentException(String.Format("Directory {0} does not eixst", downloadDirectory));

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
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException("filePath");

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
            if (String.IsNullOrWhiteSpace(zippedPath)) throw new ArgumentNullException("zippedPath");
            if (String.IsNullOrWhiteSpace(zippedFileName)) throw new ArgumentNullException("zippedFileName");
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException("downloadDirectory");

            var zippedFilePath = Path.Combine(zippedPath, zippedFileName);

            ZipFile.ExtractToDirectory(zippedFilePath, downloadDirectory);

            return zippedFilePath;
        }

        internal static bool IsRaveXLSWorkSheetRowDataComparison(string filePath, string workSheetName, int startValueIndex, List<string> expectedSheetDataValues)
        {
            if (String.IsNullOrWhiteSpace(filePath))                   throw new ArgumentNullException("filePath");
            if (String.IsNullOrWhiteSpace(workSheetName))              throw new ArgumentNullException("workSheetName");
            if (String.IsNullOrWhiteSpace(startValueIndex.ToString())) throw new ArgumentNullException("startIndex");
            if (!expectedSheetDataValues.Any())                        throw new ArgumentNullException("No expected values from table");

            XElement xelement = XElement.Load(filePath);
            var xmlItemWorkSheet = from xmlTag in xelement.Elements("Worksheet")
                                   where (string)xmlTag.Element("Worksheet").Value == workSheetName
                                   select xmlTag;

            var actualSheetDataValues = xmlItemWorkSheet.Descendants("Data").ToList();

            for (int i = 0; i < expectedSheetDataValues.Count; i++)
            {
                if (!(expectedSheetDataValues[i] == actualSheetDataValues[startValueIndex].Value))
                {
                    return false;
                }
                startValueIndex++;
            }
            return true;
        }

        internal static void DownloadVerifiedFile(string _DownloadDirectory, string configReportFileName, object v)
        {
            throw new NotImplementedException();
        }
    }
}
