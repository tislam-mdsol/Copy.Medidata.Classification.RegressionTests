using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Helpers;
using System;
using System.Collections.Generic;

namespace Coder.DeclarativeBrowser.Models
{
    public class OdmParameters
    {
        public OdmParameters()
        {
            CodingContextUri            = BrowserUtility.RandomString();
            CodingTermUUID              = Guid.NewGuid().ToString();
            CodingPriority              = "1";
            ComponentFieldName          = "LOGCOMPFIELD";
            DictionaryLevelComponentOID = "TestDLCOID"; // Changed from "BrowserUtility.RandomString();" to static due to MCC-205312
            FileOid                     = Guid.NewGuid().ToString();
            FormDefRepeating            = "Yes";
            FormName                    = Config.DefaultFormKey;
            FormOid                     = Config.DefaultFormKey;
            FormRepeatKey               = "12345";
            IsAutoCode                  = "True";
            IsBypassTransmit            = "True";
            ItemDefDataType             = "string";
            ItemGroupDefRepeating       = "Yes";
            ItemGroupOid                = "ITEMGROUP";
            ItemGroupRefMandatory       = "No";
            ItemGroupRepeatKey          = "1";
            ItemRefMandatory            = "No";
            ItemName                    = Config.DefaultFieldKey;
            ItemDataOid                 = Config.DefaultFieldKey;
            LocationOid                 = "Site 1";
            MarkingGroup                = "SystemMarkingGroup";
            MetaDataVersionName         = BrowserUtility.RandomString();
            MetaDataVersionOid          = "01";
            StudyDescription            = BrowserUtility.RandomString().WrapStringWithQuotes();
            ProtocolName                = BrowserUtility.RandomString().WrapStringWithQuotes();
            StudyEventOid               = "Event 1";
            StudyEventRepeatKey         = "1";
            StudyName                   = BrowserUtility.RandomString().WrapStringWithQuotes();
            SubjectKey                  = Config.DefaultSubjectKey;
            SupplementFieldName         = "LOGSUPPFIELD";
            UpdatedTimeStamp            = "01";

            CodingLocale                = "eng";
            Dictionary                  = "MedDRA";
            DictionaryLevel             = "LLT";
            IsApprovalRequired          = "TRUE";
            IsAutoApproval              = "TRUE";
            VerbatimTerm                = "";

            odmQueryParameters          = null;

            // The Study OID is must be supplied by the session for the user and will fail to load if not supplied.
            // StudyOid

            // The lists are empty until they are loaded with data.
            ComponentList               = new List<string>();
            FullSupplementList          = new Dictionary<string, string>();
        }

        public string CodingLocale                            { get; set; }
        public string FileOid                                 { get; set; }
        public string Dictionary                              { get; set; }
        public string DictionaryLevel                         { get; set; }
        public string IsApprovalRequired                      { get; set; }
        public string IsAutoApproval                          { get; set; }
        public string StudyOid                                { get; set; }
        public string VerbatimTerm                            { get; set; }
        public string CodingContextUri                        { get; set; }
        public string CodingTermUUID                          { get; set; }
        public string CodingPriority                          { get; set; }
        public string ComponentFieldName                      { get; set; }
        public string DictionaryLevelComponentOID             { get; set; }
        public string FormDefRepeating                        { get; set; }
        public string FormName                                { get; set; }
        public string FormOid                                 { get; set; }
        public string FormRepeatKey                           { get; set; }
        public string IsAutoCode                              { get; set; }
        public string IsBypassTransmit                        { get; set; }
        public string ItemDataOid                             { get; set; }
        public string ItemDefDataType                         { get; set; }
        public string ItemGroupDefRepeating                   { get; set; }
        public string ItemGroupOid                            { get; set; }
        public string ItemGroupRefMandatory                   { get; set; }
        public string ItemGroupRepeatKey                      { get; set; }
        public string ItemRefMandatory                        { get; set; }
        public string ItemName                                { get; set; }
        public string LocationOid                             { get; set; }
        public string MarkingGroup                            { get; set; }
        public string MetaDataVersionName                     { get; set; }
        public string MetaDataVersionOid                      { get; set; }
        public string ProtocolName                            { get; set; }
        public string StudyDescription                        { get; set; }
        public string StudyEventOid                           { get; set; }
        public string StudyEventRepeatKey                     { get; set; }
        public string StudyName                               { get; set; }
        public string SubjectKey                              { get; set; }
        public string SupplementFieldName                     { get; set; }
        public string UpdatedTimeStamp                        { get; set; }
        
        public OdmQueryParameters odmQueryParameters          { get; set; }

        public IList<string> ComponentList                    { get; set; }
        public IDictionary<string, string> FullSupplementList { get; private set; }

        public void CreateFullSupplementListWithGenericNames(IList<string> supplementList)
        {
            if (ReferenceEquals(supplementList, null)) throw new ArgumentNullException("supplementList");

            FullSupplementList = new Dictionary<string, string>();

            for (var i = 0; i < supplementList.Count; i++)
            {
                var fieldName = SupplementFieldName + (i + 1);

                FullSupplementList.Add(fieldName, supplementList[i]);
            }
        }
    }
}