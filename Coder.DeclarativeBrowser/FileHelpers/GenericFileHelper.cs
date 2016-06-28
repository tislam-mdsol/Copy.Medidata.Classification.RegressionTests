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

        internal static string[] GetDirectoryPaths(string downloadDirectory, string filePath)
        {
            string[] filePaths = Directory.GetFiles(@downloadDirectory, filePath);
           
            return filePaths;
        }

        internal static string GetFilePathByPartialName(string downloadDirectory, string partialName)
        {
            if (String.IsNullOrWhiteSpace(partialName)) throw new ArgumentNullException(nameof(partialName));
            if (String.IsNullOrWhiteSpace(downloadDirectory))
                throw new ArgumentNullException(nameof(downloadDirectory));
            
            string[] filePaths = Directory.GetFiles(downloadDirectory);

            if (!filePaths.Any())
            {
                throw new FileNotFoundException("No files in download directory");
            }

            var filePath = RetryPolicy.ValidateOperation.Execute
            (
                () =>
                {
                    filePaths = null;

                    filePaths = Directory.GetFiles(downloadDirectory);

                    var matchingFile = filePaths.
                                       SingleOrDefault(x => Path.GetFileName(x).Contains(partialName));

                    return matchingFile;
                }
            );

            if (ReferenceEquals(filePath, null))
            {
                throw new FileNotFoundException($"No partial file name with {partialName}");
            }

            return filePath;
        }

        internal static void DeleteFilesInDirectory(string downloadDirectory)
        {
            if (String.IsNullOrWhiteSpace(downloadDirectory)) throw new ArgumentNullException(nameof(downloadDirectory));

            string[] filePaths = Directory.GetFiles(downloadDirectory);

            if (!filePaths.Any())
            {
                throw new FileNotFoundException("No files in download directory");
            }

            foreach (var filePath in filePaths)
            {
                if (!filePath.Equals(null))
                {
                    File.Delete(filePath);                    
                }
            }
        }

    }
}
