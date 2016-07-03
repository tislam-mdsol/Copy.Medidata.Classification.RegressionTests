using System;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.OdmBuilder;
using System.Linq;
using Coder.DeclarativeBrowser.CoderConfiguration;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Medidata.Classification;
using ServiceModelEx;

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

        public static bool CreateAutomatedCodingRequestSection(
                        StepContext stepContext,
            string verbatim,
            string dictionaryLevel         = null,
            string formName                = null,
            string components              = null,
            string supplements             = null,
            string markingGroup            = null,
            bool haltOnFailure             = true,
            bool waitForAutoCodingComplete = true)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");
            if (String.IsNullOrEmpty(verbatim))     throw new ArgumentNullException("verbatim");

            var initialData      = new AutomatedCodingRequestSection();

            initialData.Request  = new StartAutomatedCodingRequest()
            {
                StudyUuid        = stepContext.GetStudyUuid(),
                UserId           = stepContext.GetUser(),
            };
            
           var codingRequest     = new CodingRequest()
           {
               AppUuid           = stepContext.GetStudyUuid(),
               BatchOid          = stepContext.FileOid,
               CodingContextUri  = stepContext.ConnectionUri,
               CreationDateTime  = stepContext.AutoCodeDate
           };

            initialData.Items    = new CodingRequest[1];
            initialData.Items[0] = codingRequest;

            //send initial data to DeclarativeBrowser for broadcasting to service bus
            bool uploadCompletedSuccesfully = stepContext.Browser.InitiateCodingRequests(initialData);

            return uploadCompletedSuccesfully;
        }

        public static bool CreateNewTask(
            StepContext stepContext                     ,
            string      verbatim                        ,
            string      dictionaryLevel           = null,
            string      formName                  = null,
            string      components                = null,
            string      supplements               = null,
            string      markingGroup              = null, 
            bool        haltOnFailure             = true,
            bool        waitForAutoCodingComplete = true)
        {
            if (ReferenceEquals(stepContext, null))            throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.OdmManager, null)) throw new ArgumentNullException("stepContext.OdmManager");
            if (String.IsNullOrEmpty(verbatim))                throw new ArgumentNullException("verbatim");

            var odmParameters = new OdmParameters
            {
                CodingLocale       = stepContext.Locale,
                Dictionary         = stepContext.Dictionary,
                DictionaryLevel    = GetDefaultDictionaryLevel(stepContext.Dictionary),
                IsApprovalRequired = stepContext.IsApprovalRequired,
                IsAutoApproval     = stepContext.IsAutoApproval,
                StudyOid           = stepContext.GetStudyUuid(),

                VerbatimTerm       = verbatim
            };

            odmParameters.DictionaryLevel = dictionaryLevel ?? odmParameters.DictionaryLevel;
            odmParameters.FormName        = formName        ?? odmParameters.FormName;
            odmParameters.MarkingGroup    = markingGroup    ?? odmParameters.MarkingGroup;

            if (!String.IsNullOrWhiteSpace(components))
            {
                odmParameters.ComponentList = components.Split(new [] {','}).ToList();
            }

            if (!String.IsNullOrWhiteSpace(supplements))
            {
                odmParameters.CreateFullSupplementListWithGenericNames(supplements.Split(new[] { ',' }).ToList());
            }

            stepContext.OdmManager.AddSentOdmParameters(odmParameters);

            stepContext.FileOid        = odmParameters.FileOid;
            stepContext.CodingTermUuid = odmParameters.CodingTermUUID;

            bool uploadCompletedSuccesfully = stepContext.Browser.BuildAndUploadOdm(odmParameters, stepContext.DumpDirectory, haltOnFailure);

            if (waitForAutoCodingComplete)
            {
                stepContext.Browser.WaitForAutoCodingToComplete();
            }

            return uploadCompletedSuccesfully;
        }

        public static void ChangeTaskVerbatim(StepContext stepContext, string currentVerbatim, string newVerbatim)
        {
            if (ReferenceEquals(stepContext, null))            throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.OdmManager, null)) throw new ArgumentNullException("stepContext.OdmManager");
            if (String.IsNullOrEmpty(currentVerbatim))         throw new ArgumentNullException("currentVerbatim");
            if (String.IsNullOrEmpty(newVerbatim))             throw new ArgumentNullException("newVerbatim");

            OdmManager odmManager = stepContext.OdmManager;

            odmManager.ChangeVerbatimOfPreviouslySentOdmParameters(currentVerbatim, newVerbatim);
            
            OdmParameters odmParameters = odmManager.GetPreviouslySentOdmParameters(newVerbatim);

            stepContext.Browser.BuildAndUploadOdm(odmParameters, stepContext.DumpDirectory);
        }
        
        public static void ChangeTaskFieldWorkflowSettings(StepContext stepContext, string verbatim, string setupType)
        {
            if (ReferenceEquals(stepContext, null))            throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.OdmManager, null)) throw new ArgumentNullException("stepContext.OdmManager");
            if (String.IsNullOrEmpty(verbatim))                throw new ArgumentNullException("verbatim");
            if (String.IsNullOrEmpty(setupType))               throw new ArgumentNullException("setupType");

            var coderConfiguration = CoderConfigurationFactory.Build(setupType);

            OdmParameters odmParameters = stepContext.OdmManager.GetPreviouslySentOdmParameters(verbatim);
            
            odmParameters.IsApprovalRequired = coderConfiguration.IsTermApprovalRequired;
            odmParameters.IsAutoApproval     = coderConfiguration.IsTermAutoApproval;
            
            stepContext.Browser.BuildAndUploadOdm(odmParameters, stepContext.DumpDirectory);
        }

        public static void SendTaskQueryResponse(StepContext stepContext, string verbatim, string status, string response, string comment = null)
        {
            if (ReferenceEquals(stepContext, null))            throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.OdmManager, null)) throw new ArgumentNullException("stepContext.OdmManager");
            if (string.IsNullOrWhiteSpace(verbatim))           throw new ArgumentNullException("verbatim");
            if (string.IsNullOrWhiteSpace(status))             throw new ArgumentNullException("status");
            if (string.IsNullOrWhiteSpace(response))           throw new ArgumentNullException("response");
            
            OdmParameters odmParameters = stepContext.OdmManager.GetPreviouslySentOdmParameters(verbatim);

            if (string.IsNullOrWhiteSpace(comment) && ReferenceEquals(odmParameters.odmQueryParameters, null))
            {
                throw new ArgumentNullException("A comment is required when sending the first task query response.");
            }

            if (ReferenceEquals(odmParameters.odmQueryParameters, null))
            {
                string queryUuid = CoderDatabaseAccess.GetTaskQueryUUID(odmParameters.CodingTermUUID);

                odmParameters.odmQueryParameters = new OdmQueryParameters(
                    queryUuid:      queryUuid,
                    recipient:      odmParameters.MarkingGroup,
                    queryRepeatKey: "10001",
                    status:         status,
                    value:          comment,
                    response:       response);
            }
            else
            {
                int repeatKey = 0;
                int.TryParse(odmParameters.odmQueryParameters.QueryRepeatKey, out repeatKey);
                repeatKey++;

                odmParameters.odmQueryParameters = new OdmQueryParameters(
                    queryUuid:      odmParameters.odmQueryParameters.QueryUuid,
                    recipient:      odmParameters.odmQueryParameters.Recipient,
                    queryRepeatKey: repeatKey.ToString(),
                    status:         status,
                    value:          comment ?? odmParameters.odmQueryParameters.Value,
                    response:       response);
            }

            stepContext.Browser.BuildAndUploadOdm(odmParameters, stepContext.DumpDirectory);
        }

        public static void AgeTask(StepContext stepContext, string verbatim, int hoursToAge)
        {
            if (ReferenceEquals(stepContext, null))            throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.OdmManager, null)) throw new ArgumentNullException("stepContext.OdmManager");
            if (String.IsNullOrWhiteSpace(verbatim))           throw new ArgumentNullException("verbatim");

            OdmParameters odmParameters = stepContext.OdmManager.GetPreviouslySentOdmParameters(verbatim);

            CoderDatabaseAccess.AgeTask(odmParameters.CodingTermUUID, hoursToAge);
        }

        public static string BuildOdmFile(OdmParameters odmParameters, string dumpDirectory)
        {
            if (ReferenceEquals(odmParameters, null))     throw new ArgumentNullException("odmParameters");
            if (String.IsNullOrWhiteSpace(dumpDirectory)) throw new ArgumentNullException("dumpDirectory");

            var odm         = new XmlDocument().BuildOdmContent(odmParameters);
            var fileName    = String.Format(@"{0}_{1}.odm", odmParameters.VerbatimTerm, odmParameters.FileOid);
            var path        = Path.Combine(dumpDirectory, fileName);

            File.WriteAllText(path, odm);

            return path;
        }

        /// <summary>
        /// Creates an ODM file from a CSV file. Returns a Tuple string, int representing the ODM file path and number of tasks.
        /// </summary>
        public static Tuple<string, int> BuildOdmFile(string csvFilePath, StepContext stepContext)
        {
            if (String.IsNullOrWhiteSpace(csvFilePath)) throw new ArgumentNullException("csvFilePath");
            if (ReferenceEquals(stepContext, null))     throw new ArgumentNullException("stepContext");

            Tuple<string, int> odmXmlAndTaskCount = new XmlDocument().BuildOdmContent(csvFilePath, stepContext);
            string odmXml = odmXmlAndTaskCount.Item1;
            int taskCount = odmXmlAndTaskCount.Item2;

            var fileName = String.Format(@"{0}_{1}.odm", Path.GetFileNameWithoutExtension(csvFilePath), Guid.NewGuid());
            var path = Path.Combine(stepContext.DumpDirectory, fileName);

            File.WriteAllText(path, odmXml);

            return Tuple.Create(path, taskCount);
        }

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
