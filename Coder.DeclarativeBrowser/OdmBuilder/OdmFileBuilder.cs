using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Microsoft.VisualBasic.FileIO;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Xml;

namespace Coder.DeclarativeBrowser.OdmBuilder
{
    public static class OdmFileBuilder
    {
        private const string xmlVersion = "1.0";
        private const string xmlEncoding = "utf-8";
        private const string xmlStandalone = null;

        public static string BuildOdmContent(
            this XmlDocument xmlDoc,
            OdmParameters odmParameters)
        {
            if (ReferenceEquals(xmlDoc, null))        throw new ArgumentNullException("xmlDoc");
            if (ReferenceEquals(odmParameters, null)) throw new ArgumentNullException("odmParameters");

            var xmlDeclaration = xmlDoc.CreateXmlDeclaration(xmlVersion, xmlEncoding, xmlStandalone);

            xmlDoc.InsertBefore(xmlDeclaration, xmlDoc.DocumentElement);

            var odmElement = xmlDoc.CreateRootOdmElement(odmParameters.FileOid);
            var studyElement = xmlDoc.BuildStudyElement(odmParameters);
            var clinicalDataElement = xmlDoc.BuildClinicalDataElement(odmParameters);

            odmElement.AppendChild(studyElement);
            odmElement.AppendChild(clinicalDataElement);

            xmlDoc.AppendChild(odmElement);

            var xmlText = xmlDoc
                .AsString()
                .Replace("d2p1", "mdsol")
                .Replace("xmlns:mdsol=\"mdsol\"", string.Empty)
                .Replace("xmlns=\"mdsol\"", string.Empty)
                .Replace("xmlns=\"\"", string.Empty)
                .Replace("  ", string.Empty);

            return xmlText;
        }

        /// <summary>
        /// Creates the XMl for an ODM file from a CSV file. Returns a Tuple string, int representing the XML and number of tasks.
        /// </summary>
        public static Tuple<string,int> BuildOdmContent(
            this XmlDocument xmlDoc,
            string csvFilePath,
            StepContext stepContext)
        {
            if (ReferenceEquals(xmlDoc, null))                          throw new ArgumentNullException("xmlDoc");
            if (ReferenceEquals(csvFilePath, null))                     throw new ArgumentNullException("csvFilePath");
            if (ReferenceEquals(stepContext,null))                      throw new ArgumentNullException("stepContext");
            if (!File.Exists(csvFilePath))                              throw new FileNotFoundException("csvFilePath: " + csvFilePath);
            if (!String.Equals(Path.GetExtension(csvFilePath), ".csv")) throw new ArgumentException("csvFilePath may not be a CSV file: " + csvFilePath);

            var prodStudyOid    = stepContext.SegmentUnderTest.ProdStudy.StudyUuid;
            var nonProdStudyOid = stepContext.SegmentUnderTest.DevStudy.StudyUuid;

            var xmlDeclaration = xmlDoc.CreateXmlDeclaration(xmlVersion, xmlEncoding, xmlStandalone);

            xmlDoc.InsertBefore(xmlDeclaration, xmlDoc.DocumentElement);

            var odmElement = xmlDoc.CreateRootOdmElement(Guid.NewGuid().ToString());

            DataTable tasks = GetDataTableFromCSVFile(csvFilePath);

            Dictionary<string, OdmParameters> studyOdmParameters = GetStudyOdmParameters(tasks, prodStudyOid, nonProdStudyOid);

            foreach (OdmParameters studyOdmParameter in studyOdmParameters.Values)
            {
                var studyElement = xmlDoc.BuildStudyElement(studyOdmParameter);

                odmElement.AppendChild(studyElement);
            }

            Dictionary<string, OdmParameters> clinicalDataOdmParameters = GetClinicalDataOdmParameters(tasks, prodStudyOid, nonProdStudyOid);

            foreach (OdmParameters clinicalDataOdmParameter in clinicalDataOdmParameters.Values)
            {
                // Check that all supplemental fields defined in the study exist in the clinical data
                string odmElementKey = CreateOdmElementKey(clinicalDataOdmParameter);

                if (!studyOdmParameters.ContainsKey(odmElementKey))
                {
                    throw new InvalidOperationException("Could not process the ODM.csv file correctly. Task has no parent Study/Form/Field.");
                }

                OdmParameters studyOdmParameter = studyOdmParameters[odmElementKey];

                foreach (string supplementField in studyOdmParameter.FullSupplementList.Keys)
                {
                    if(!clinicalDataOdmParameter.FullSupplementList.ContainsKey(supplementField))
                    {
                        clinicalDataOdmParameter.FullSupplementList.Add(supplementField, "");
                    }
                }

                var clinicalDataElement = xmlDoc.BuildClinicalDataElement(clinicalDataOdmParameter);

                odmElement.AppendChild(clinicalDataElement);
            }
            
            xmlDoc.AppendChild(odmElement);

            var xmlText = xmlDoc
                .AsString()
                .Replace("d2p1", "mdsol")
                .Replace("xmlns:mdsol=\"mdsol\"", string.Empty)
                .Replace("xmlns=\"mdsol\"", string.Empty)
                .Replace("xmlns=\"\"", string.Empty)
                .Replace("  ", string.Empty);

            return Tuple.Create(xmlText, clinicalDataOdmParameters.Count);
        }

        private static Dictionary<string, OdmParameters> GetStudyOdmParameters(DataTable tasks, string prodStudyOid, string nonProdStudyOid)
        {
            if (ReferenceEquals(tasks, null)) throw new ArgumentNullException("tasks");
            if (String.IsNullOrWhiteSpace(prodStudyOid)) throw new ArgumentNullException("prodStudyOid");
            if (String.IsNullOrWhiteSpace(nonProdStudyOid)) throw new ArgumentNullException("nonProdStudyOid");

            Dictionary<string, OdmParameters> studyOdmParameters = new Dictionary<string, OdmParameters>();
            Dictionary<string, string> testIdKeyLookup = new Dictionary<string, string>();

            foreach (DataRow task in tasks.Rows)
            {
                string studyOid      = GetStudyOid(task["Study ID"].ToString(), prodStudyOid, nonProdStudyOid);
                string odmElementKey = CreateOdmElementKey(studyOid, task);
                string testId        = task["Test ID"].ToString();

                if (task["Field Type"].ToString().ToUpper() == "MAIN")
                {
                    // All tasks are being processed to find unique studies. If a duplicate is found, it is skipped.
                    if (!studyOdmParameters.ContainsKey(odmElementKey))
                    {
                        var odmParameters = CreateOdmParamtersFromDataRow(studyOid, task);

                        studyOdmParameters.Add(odmElementKey, odmParameters);
                    }

                    // Map the Test ID to the ODM Element Key to link supplemental fields to the main field.
                    testIdKeyLookup.Add(testId, odmElementKey);
                }
                else
                {
                    if (!testIdKeyLookup.ContainsKey(testId))
                    {
                        throw new InvalidOperationException("Could not process the ODM.csv file correctly. Supplemental Field has no parent Test ID.");
                    }

                    odmElementKey = testIdKeyLookup[testId];

                    if (!studyOdmParameters.ContainsKey(odmElementKey))
                    {
                        throw new InvalidOperationException("Could not process the ODM.csv file correctly. Supplemental Field has no parent Study/Form/Field.");
                    }

                    string itemName = task["Field"].ToString();

                    // All tasks are being processed to find unique supplement fields. If a duplicate is found, it is skipped.
                    if (!studyOdmParameters[odmElementKey].FullSupplementList.ContainsKey(itemName))
                    {
                        studyOdmParameters[odmElementKey].FullSupplementList.Add(itemName, "");
                    }
                }
            }

            return studyOdmParameters;
        }

        private static Dictionary<string, OdmParameters> GetClinicalDataOdmParameters(DataTable tasks, string prodStudyOid, string nonProdStudyOid)
        {
            if (ReferenceEquals(tasks, null)) throw new ArgumentNullException("tasks");
            if (String.IsNullOrWhiteSpace(prodStudyOid)) throw new ArgumentNullException("prodStudyOid");
            if (String.IsNullOrWhiteSpace(nonProdStudyOid)) throw new ArgumentNullException("nonProdStudyOid");

            Dictionary<string, OdmParameters> clinicalDataOdmParameters = new Dictionary<string, OdmParameters>();

            foreach (DataRow task in tasks.Rows)
            {
                string studyOid = GetStudyOid(task["Study ID"].ToString(), prodStudyOid, nonProdStudyOid);

                string testId = task["Test ID"].ToString();

                if (task["Field Type"].ToString().ToUpper() == "MAIN")
                {
                    if (clinicalDataOdmParameters.ContainsKey(testId))
                    {
                        throw new ArgumentException("Could not process the ODM.csv file correctly. Duplicate definition for Test ID detected: " + testId);
                    }

                    var odmParameters = CreateOdmParamtersFromDataRow(studyOid, task);

                    clinicalDataOdmParameters.Add(testId, odmParameters);
                }
                else
                {
                    if (!clinicalDataOdmParameters.ContainsKey(testId))
                    {
                        throw new InvalidOperationException("Could not process the ODM.csv file correctly. Supplemental Field has no parent Study/Form/Test ID: " + testId);
                    }

                    string itemName = task["Field"].ToString();
                    string fieldValue = task["Field Value"].ToString();

                    if (clinicalDataOdmParameters[testId].FullSupplementList.ContainsKey(itemName))
                    {
                        throw new ArgumentException("Could not process the ODM.csv file correctly. Duplicate definition for Supplement Field detected: " + itemName);
                    }

                    clinicalDataOdmParameters[testId].FullSupplementList.Add(itemName, fieldValue);
                }
            }

            return clinicalDataOdmParameters;
        }

        private static string GetStudyOid(string studyId, string prodStudyOid, string nonProdStudyOid)
        {
            if (String.IsNullOrWhiteSpace(studyId)) throw new ArgumentNullException("studyId");
            if (String.IsNullOrWhiteSpace(prodStudyOid)) throw new ArgumentNullException("prodStudyOid");
            if (String.IsNullOrWhiteSpace(nonProdStudyOid)) throw new ArgumentNullException("nonProdStudyOid");
            
            if (studyId == "PROD")
            {
                return prodStudyOid;
            }

            return nonProdStudyOid;
        }

        private static string CreateOdmElementKey(string studyOid, DataRow task)
        {
            if (String.IsNullOrWhiteSpace(studyOid)) throw new ArgumentNullException("studyOid");
            if (ReferenceEquals(task, null)) throw new ArgumentNullException("task");

            var odmParameters = CreateOdmParamtersFromDataRow(studyOid, task);

            return CreateOdmElementKey(odmParameters);
        }

        private static string CreateOdmElementKey(OdmParameters odmParameters)
        {
            if (ReferenceEquals(odmParameters, null)) throw new ArgumentNullException("odmParameters");

            return string.Format("{0}.{1}.{2}", odmParameters.StudyOid, odmParameters.FormOid, odmParameters.ItemDataOid);
        }

        private static OdmParameters CreateOdmParamtersFromDataRow(string studyOid, DataRow task)
        {
            if (String.IsNullOrWhiteSpace(studyOid)) throw new ArgumentNullException("studyOid");
            if (ReferenceEquals(task, null))         throw new ArgumentNullException("task");

            OdmParameters odmParameters = null;

            odmParameters = new OdmParameters {};

            odmParameters.StudyOid           = studyOid;
            odmParameters.FormName           = CreateTaskParameterValue(task, "Form"              , odmParameters.FormName);
            odmParameters.FormOid            = CreateTaskParameterValue(task, "Form"              , odmParameters.FormOid);
            odmParameters.ItemName           = CreateTaskParameterValue(task, "Field"             , odmParameters.ItemName);
            odmParameters.ItemDataOid        = CreateTaskParameterValue(task, "Field"             , odmParameters.ItemDataOid);
            odmParameters.DictionaryLevel    = CreateTaskParameterValue(task, "Dictionary Level"  , odmParameters.DictionaryLevel);
            odmParameters.Dictionary         = CreateTaskParameterValue(task, "Dictionary"        , odmParameters.Dictionary);
            odmParameters.CodingPriority     = CreateTaskParameterValue(task, "Priority"          , odmParameters.CodingPriority);
            odmParameters.CodingLocale       = CreateTaskParameterValue(task, "Locale"            , odmParameters.CodingLocale);
            odmParameters.IsApprovalRequired = CreateTaskParameterValue(task, "IsApprovalRequired", odmParameters.IsApprovalRequired);
            odmParameters.IsAutoApproval     = CreateTaskParameterValue(task, "IsAutoApproval"    , odmParameters.IsAutoApproval);
            odmParameters.IsAutoCode         = CreateTaskParameterValue(task, "IsAutoCode"        , odmParameters.IsAutoCode);
            odmParameters.IsBypassTransmit   = CreateTaskParameterValue(task, "IsBypassTransmit"  , odmParameters.IsBypassTransmit);
            
            odmParameters.VerbatimTerm       = CreateTaskParameterValue(task, "Field Value"       , odmParameters.VerbatimTerm);
            odmParameters.StudyEventOid      = CreateTaskParameterValue(task, "Event"             , odmParameters.StudyEventOid);
            odmParameters.SubjectKey         = CreateTaskParameterValue(task, "Subject"           , odmParameters.SubjectKey);
            odmParameters.LocationOid        = CreateTaskParameterValue(task, "Site"              , odmParameters.LocationOid);
            
            return odmParameters;
        }

        private static string CreateTaskParameterValue( DataRow task, string parameter,  string defaultParameterValue)
            {
            if (ReferenceEquals(task, null))          throw new ArgumentNullException("task");
            if (String.IsNullOrWhiteSpace(parameter)) throw new ArgumentNullException("parameter");

            string parameterValue = defaultParameterValue;

            if (task.Table.Columns.Contains(parameter) && !String.IsNullOrWhiteSpace(task[parameter].ToString()))
            {
                parameterValue = task[parameter].ToString();
            }

            return parameterValue;
        }
        
        //Source: http://stackoverflow.com/questions/16606753/populating-a-dataset-from-a-csv-file
        private static DataTable GetDataTableFromCSVFile(string csvFilePath)
        {
            DataTable csvData = new DataTable();

            using (TextFieldParser csvReader = new TextFieldParser(csvFilePath))
            {
                csvReader.SetDelimiters(new string[] { "," });
                csvReader.HasFieldsEnclosedInQuotes = true;
                string[] headerFields = csvReader.ReadFields();
                foreach (string headerField in headerFields)
                {
                    DataColumn column = new DataColumn(headerField);
                    column.AllowDBNull = true;
                    csvData.Columns.Add(column);
                }
                while (!csvReader.EndOfData)
                {
                    string[] rowData = csvReader.ReadFields();
                    //Making empty value as null
                    for (int i = 0; i < rowData.Length; i++)
                    {
                        if (rowData[i] == "")
                        {
                            rowData[i] = null;
                        }
                    }
                    csvData.Rows.Add(rowData);
                }
            }

            return csvData;
        }
    }
}