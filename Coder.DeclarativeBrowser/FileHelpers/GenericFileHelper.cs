using System;
using System.IO;
using System.Linq;

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

        private static void VerifyFileRows(string filePath, int expectedRows)
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
    }
}
