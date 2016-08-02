using System;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using Coder.DeclarativeBrowser.Models;
using System.Linq;
using Coder.DeclarativeBrowser.CoderConfiguration;
using Coder.DeclarativeBrowser.ExtensionMethods;

namespace Coder.DeclarativeBrowser.Helpers
{
    public static class BrowserUtility
    {
        private static readonly IDictionary<string,string> DictionaryToDefaultDictionaryLevelMap = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            {"MedDRA"      , "LLT"     },
            {"JDrug"       , "DrugName"},
            {"WhoDrugDDEB2", "PRODUCT" },
            {"AZDD"        , "PRODUCT" }
        };

        public static string GetScreenshotDirectory()
        {
            var parentDirectory = AppDomain.CurrentDomain.BaseDirectory;
            var screenshotDirectory = parentDirectory + "\\" + Config.ScreenshotDirectoryName;

            return screenshotDirectory;
        }

        public static string GetDynamicCsvFilePath(string fileName, string applicationFolder)
        {
            var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;

            if (ReferenceEquals(fileName, null))          throw new ArgumentNullException("fileName");
            if (ReferenceEquals(applicationFolder, null)) throw new ArgumentNullException("applicationFolder");
            if (ReferenceEquals(baseDirectory, null))     throw new ArgumentNullException("baseDirectory");

            var filePath = Path.Combine(baseDirectory, "DynamicCSVReports", fileName);

            return filePath;
        }

        public static string RandomString()
        {
            var result = Path.GetRandomFileName().Replace(".", "");

            return result.ToUpper();
        }

        public static string GetDefaultDictionaryLevel(string dictionary)
        {
            if (string.IsNullOrWhiteSpace(dictionary)) throw new ArgumentNullException("dictionary");

            if (!DictionaryToDefaultDictionaryLevelMap.ContainsKey(dictionary))
            {
                throw new KeyNotFoundException(
                    String.Format("Dictionary {0} does not have a default dictionary level defined.", dictionary));
            }

            return DictionaryToDefaultDictionaryLevelMap[dictionary];
        }
        
        public static string CreateDraftFile(string studyName, string draftName, string draftTemplateFilePath, string targetDirectory)
        {
            if (String.IsNullOrWhiteSpace(studyName))             throw new ArgumentNullException("studyName");
            if (String.IsNullOrWhiteSpace(draftName))             throw new ArgumentNullException("draftName");
            if (String.IsNullOrWhiteSpace(draftTemplateFilePath)) throw new ArgumentNullException("draftTemplateFilePath");
            if (String.IsNullOrWhiteSpace(targetDirectory))       throw new ArgumentNullException("targetDirectory");
            
            var draftFileName = String.Format("{0}_{1}.xml", studyName.RemoveNonAlphanumeric(), draftName);
            var draftFilePath = Path.Combine(targetDirectory, draftFileName);

            Dictionary<string, string> replacementPairs = new Dictionary<string, string>
            {
                {"RaveCoderDraftTemplateName"       , draftName},
                {"RaveCoderDraftTemplateProjectName", studyName}
            };

            BrowserUtility.ReplaceTextInFile(draftTemplateFilePath, draftFilePath, replacementPairs);

            return draftFilePath;
        }

        public static void ReplaceTextInFile(string sourceFilePath, string destinationFilePath, Dictionary<string,string> replacementPairs)
        {
            if (string.IsNullOrWhiteSpace(sourceFilePath)) throw new ArgumentNullException("sourceFilePath");
            if (string.IsNullOrWhiteSpace(sourceFilePath)) throw new ArgumentNullException("sourceFilePath");
            if (ReferenceEquals(replacementPairs, null))   throw new ArgumentNullException("replacementPairs");

            var fileContents = File.ReadAllText(sourceFilePath);

            foreach (var replacementPair in replacementPairs)
            {
                fileContents = fileContents.Replace(replacementPair.Key, replacementPair.Value);
            }

            File.WriteAllText(destinationFilePath, fileContents);
        }
    }
}
