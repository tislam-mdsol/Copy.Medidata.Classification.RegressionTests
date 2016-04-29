using System;
using System.Xml;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Helpers;
using Coder.DeclarativeBrowser.Models;

namespace Coder.DeclarativeBrowser.OdmBuilder
{
    public static class OdmElementCreator
    {
        public static XmlElement CreateRootOdmElement(
            this XmlDocument xmlDoc,
            string fileOid)
        {
            if (ReferenceEquals(xmlDoc, null))   throw new ArgumentNullException("xmlDoc");      
            if (String.IsNullOrEmpty(fileOid))   throw new ArgumentNullException("fileOid");    

            var odmElement = xmlDoc.CreateElement("ODM");

            odmElement.SetAttribute("xmlns"             , "http://www.cdisc.org/ns/odm/v1.3");
            odmElement.SetAttribute("xmlns:mdsol"       , "http://www.mdsol.com/ns/odm/metadata");
            odmElement.SetAttribute("FileType"          , "Transactional");
            odmElement.SetAttribute("FileOID"           , fileOid);
            odmElement.SetAttribute("CreationDateTime"  , DateTime.Now.ToString("yyyy'-'MM'-'dd'T'HH':'mm':'ss"));
            odmElement.SetAttribute("ODMVersion"        , "1.3");
            odmElement.SetAttribute("BatchReference"    , "");

            return odmElement;
        }

        public static XmlElement CreateStudyElement(
            this XmlDocument xmlDoc,
            string oid)
        {
            if (ReferenceEquals(xmlDoc, null))   throw new ArgumentNullException("xmlDoc"); 
            if (String.IsNullOrEmpty(oid))       throw new ArgumentNullException("oid"); 

            var studyElement = xmlDoc.CreateElement("Study");

            studyElement.SetAttribute("OID", oid);
            studyElement.SetNamespaceAttribute("mdsol", "StudyOIDType", "iMedidata");

            return studyElement;
        }

        public static XmlElement CreateGlobalVariablesElement(
            this XmlDocument xmlDoc,
            string studyName,
            string studyDescription,
            string protocolName)
        {
            if (ReferenceEquals(xmlDoc, null))          throw new ArgumentNullException("xmlDoc");
            if (String.IsNullOrEmpty(studyName))        throw new ArgumentNullException("studyName");
            if (String.IsNullOrEmpty(studyDescription)) throw new ArgumentNullException("studyDescription");
            if (String.IsNullOrEmpty(protocolName))     throw new ArgumentNullException("protocolName");

            var globalVariablesElement = xmlDoc.CreateElement("GlobalVariables");

            var studyNameElement = xmlDoc.CreateElementWithInnerText(
                "StudyName",
                studyName);

            var studyDescriptionElement = xmlDoc.CreateElementWithInnerText(
                "StudyDescription",
                studyDescription);

            var protocolNameElement = xmlDoc.CreateElementWithInnerText(
                "ProtocolName",
                protocolName);

            globalVariablesElement.AppendChild(studyNameElement);
            globalVariablesElement.AppendChild(studyDescriptionElement);
            globalVariablesElement.AppendChild(protocolNameElement);

            return globalVariablesElement;
        }

        public static XmlElement CreateMetaDataVersionElement(
            this XmlDocument xmlDoc,
            string metaDataVersionOid,
            string metaDataVersionName)
        {
            if (ReferenceEquals(xmlDoc, null))               throw new ArgumentNullException("xmlDoc");                
            if (String.IsNullOrEmpty(metaDataVersionOid))    throw new ArgumentNullException("metaDataVersionOid");
            if (String.IsNullOrEmpty(metaDataVersionName))    throw new ArgumentNullException("metaDataVersionName");

            var metaDataVersionElement = xmlDoc.CreateElement("MetaDataVersion");

            metaDataVersionElement.SetAttribute("OID"   , metaDataVersionOid);
            metaDataVersionElement.SetAttribute("Name"  , metaDataVersionName);

            return metaDataVersionElement;
        }

        public static XmlElement CreateFormDefElement(
            this XmlDocument xmlDoc,
            string oid,
            string name,
            string repeating)
        {
            if (ReferenceEquals(xmlDoc, null))       throw new ArgumentNullException("xmlDoc");    
            if (String.IsNullOrEmpty(oid))           throw new ArgumentNullException("oid");       
            if (String.IsNullOrEmpty(name))          throw new ArgumentNullException("name");      
            if (String.IsNullOrEmpty(repeating))     throw new ArgumentNullException("repeating"); 

            var formDefElement = xmlDoc.CreateElement("FormDef");

            formDefElement.SetAttribute("OID"           , oid);
            formDefElement.SetAttribute("Name"          , name);
            formDefElement.SetAttribute("Repeating"     , repeating);

            return formDefElement;
        }

        public static XmlElement CreateItemGroupRefElement(
            this XmlDocument xmlDoc,
            string itemGroupOid,
            string mandatory)
        {
            if (ReferenceEquals(xmlDoc, null))           throw new ArgumentNullException("xmlDoc");        
            if (String.IsNullOrEmpty(itemGroupOid))      throw new ArgumentNullException("itemGroupOid");  
            if (String.IsNullOrEmpty(mandatory))         throw new ArgumentNullException("mandatory");     

            var itemGroupRefElement = xmlDoc.CreateElement("ItemGroupRef");

            itemGroupRefElement.SetAttribute("ItemGroupOID"     , itemGroupOid);
            itemGroupRefElement.SetAttribute("Mandatory"        , mandatory);

            return itemGroupRefElement;
        }

        public static XmlElement CreateItemGroupDefElement(
            this XmlDocument xmlDoc,
            string oid,
            string name,
            string repeating)
        {
            if (ReferenceEquals(xmlDoc, null))       throw new ArgumentNullException("xmlDoc");    
            if (String.IsNullOrEmpty(oid))           throw new ArgumentNullException("oid");       
            if (String.IsNullOrEmpty(name))          throw new ArgumentNullException("name");      
            if (String.IsNullOrEmpty(repeating))     throw new ArgumentNullException("repeating"); 

            var itemGroupDefElement = xmlDoc.CreateElement("ItemGroupDef");

            itemGroupDefElement.SetAttribute("OID"          , oid);
            itemGroupDefElement.SetAttribute("Name"         , name);
            itemGroupDefElement.SetAttribute("Repeating"    , repeating);

            return itemGroupDefElement;
        }

        public static XmlElement CreateItemRefElement(
            this XmlDocument xmlDoc,
            string itemOid,
            string mandatory)
        {
            if (ReferenceEquals(xmlDoc, null))           throw new ArgumentNullException("xmlDoc");        
            if (String.IsNullOrEmpty(itemOid))           throw new ArgumentNullException("itemOid");       
            if (String.IsNullOrEmpty(mandatory))         throw new ArgumentNullException("mandatory");     

            var itemRefElement = xmlDoc.CreateElement("ItemRef");

            itemRefElement.SetAttribute("ItemOID"       , itemOid);
            itemRefElement.SetAttribute("Mandatory"     , mandatory);

            return itemRefElement;
        }

        public static XmlElement CreateItemDefElement(
            this XmlDocument xmlDoc,
            string oid,
            string name,
            string dataType)
        {
            if (ReferenceEquals(xmlDoc, null))       throw new ArgumentNullException("xmlDoc");    
            if (String.IsNullOrEmpty(oid))           throw new ArgumentNullException("oid");       
            if (String.IsNullOrEmpty(name))          throw new ArgumentNullException("name");      
            if (String.IsNullOrEmpty(dataType))      throw new ArgumentNullException("dataType");  

            var itemDefElement = xmlDoc.CreateElement("ItemDef");

            itemDefElement.SetAttribute("OID"           , oid);
            itemDefElement.SetAttribute("Name"          , name);
            itemDefElement.SetAttribute("DataType"      , dataType);

            return itemDefElement;
        }

        public static XmlElement CreateCodingRequestDefElement(
            this XmlDocument xmlDoc,
            string codingDictionaryLevelOid,
            string codingDictionaryOid,
            string codingPriority,
            string codingLocale,
            string markingGroup)
        {
            if (ReferenceEquals(xmlDoc, null))                       throw new ArgumentNullException("xmlDoc");                    
            if (String.IsNullOrEmpty(codingDictionaryLevelOid))      throw new ArgumentNullException("codingDictionaryLevelOid");  
            if (String.IsNullOrEmpty(codingDictionaryOid))           throw new ArgumentNullException("codingDictionaryOid");       
            if (String.IsNullOrEmpty(codingPriority))                throw new ArgumentNullException("codingPriority");            
            if (String.IsNullOrEmpty(codingLocale))                  throw new ArgumentNullException("codingLocale");
            if (String.IsNullOrEmpty(markingGroup))                  throw new ArgumentNullException("markingGroup");

            var codingRequestDefElement = xmlDoc.CreateElement("mdsol:CodingRequestDef", "mdsol");

            codingRequestDefElement.SetNamespaceAttribute("mdsol"   , "CodingWorkflowOID", "DEFAULT");
            codingRequestDefElement.SetNamespaceAttribute("mdsol"   , "CodingDictionaryLevelOID", codingDictionaryLevelOid);
            codingRequestDefElement.SetNamespaceAttribute("mdsol"   , "CodingDictionaryOID", codingDictionaryOid);
            codingRequestDefElement.SetNamespaceAttribute("mdsol"   , "CodingPriority", codingPriority);
            codingRequestDefElement.SetNamespaceAttribute("mdsol"   , "CodingLocale", codingLocale);

            codingRequestDefElement.SetAttribute("MarkingGroup", markingGroup);

            return codingRequestDefElement;
        }

        public static XmlElement CreateDictionaryLevelComponentRefElement(
            this XmlDocument xmlDoc,
            string dictionaryLevelComponentOid,
            string itemRef)
        {
            if (ReferenceEquals(xmlDoc, null))                       throw new ArgumentNullException("xmlDoc");                        
            if (String.IsNullOrEmpty(dictionaryLevelComponentOid))   throw new ArgumentNullException("dictionaryLevelComponentOid");   
            if (String.IsNullOrEmpty(itemRef))                       throw new ArgumentNullException("itemRef");                       

            var dictionaryLevelComponentRefElement = xmlDoc.CreateElement("mdsol:DictionaryLevelComponentRef", "mdsol");

            dictionaryLevelComponentRefElement.SetAttribute("DictionaryLevelComponentOID"   , dictionaryLevelComponentOid);
            dictionaryLevelComponentRefElement.SetAttribute("ItemRef"                       , itemRef);

            return dictionaryLevelComponentRefElement;
        }

        public static XmlElement CreateSupplementalRefElement(
            this XmlDocument xmlDoc,
            string itemRef)
        {
            if (ReferenceEquals(xmlDoc, null))       throw new ArgumentNullException("xmlDoc");     
            if (String.IsNullOrEmpty(itemRef))       throw new ArgumentNullException("itemRef");    

            var supplementalRefElement = xmlDoc.CreateElement("mdsol:SupplementalRef", "mdsol");

            supplementalRefElement.SetAttribute("ItemRef", itemRef);

            return supplementalRefElement;
        }

        public static XmlElement CreateCodingWorkflowDataElement(
           this XmlDocument xmlDoc,
           string name,
           string value)
        {
            if (ReferenceEquals(xmlDoc, null))       throw new ArgumentNullException("xmlDoc");    
            if (String.IsNullOrEmpty(name))          throw new ArgumentNullException("name");      
            if (String.IsNullOrEmpty(value))         throw new ArgumentNullException("value");     

            var codingWorkflowDataElement = xmlDoc.CreateElement("mdsol:CodingWorkflowData", "mdsol");

            codingWorkflowDataElement.SetAttribute("Name"       , name);
            codingWorkflowDataElement.SetAttribute("Value"      , value);

            return codingWorkflowDataElement;
        }

        public static XmlElement CreateClinicalDataElement(
            this XmlDocument xmlDoc,
            string studyOid,
            string metaDataVersionOid)
        {
            if (ReferenceEquals(xmlDoc, null))               throw new ArgumentNullException("xmlDoc");                
            if (String.IsNullOrEmpty(studyOid))              throw new ArgumentNullException("studyOid");              
            if (String.IsNullOrEmpty(metaDataVersionOid))    throw new ArgumentNullException("metaDataVersionOid");    

            var clinicalDataElement = xmlDoc.CreateElement("ClinicalData", "mdsol");

            clinicalDataElement.SetAttribute("StudyOID", studyOid);
            clinicalDataElement.SetNamespaceAttribute("mdsol", "StudyOIDType", "iMedidata");
            clinicalDataElement.SetAttribute("MetaDataVersionOID", metaDataVersionOid);

            return clinicalDataElement;
        }

        public static XmlElement CreateSubjectDataElement(
            this XmlDocument xmlDoc,
            string subjectKey)
        {
            if (ReferenceEquals(xmlDoc, null))       throw new ArgumentNullException("xmlDoc");        
            if (String.IsNullOrEmpty(subjectKey))    throw new ArgumentNullException("subjectKey");    

            var subjectDataElement = xmlDoc.CreateElement("SubjectData");

            subjectDataElement.SetAttribute("SubjectKey"        , subjectKey);
            subjectDataElement.SetAttribute("TransactionType"   , "Update");

            return subjectDataElement;
        }

        public static XmlElement CreateSiteRefElement(
            this XmlDocument xmlDoc,
            string locationOid)
        {
            if (ReferenceEquals(xmlDoc, null))       throw new ArgumentNullException("xmlDoc");        
            if (String.IsNullOrEmpty(locationOid))   throw new ArgumentNullException("locationOid");   

            var siteRefElement = xmlDoc.CreateElement("SiteRef", "mdsol");

            siteRefElement.SetAttribute("LocationOID", locationOid);
            siteRefElement.SetNamespaceAttribute("mdsol", "LocationName", locationOid);

            return siteRefElement;
        }

        public static XmlElement CreateStudyEventDataElement(
            this XmlDocument xmlDoc,
            string studyEventOid,
            string studyEventRepeatKey = null)
        {
            if (ReferenceEquals(xmlDoc, null))           throw new ArgumentNullException("xmlDoc");        
            if (String.IsNullOrEmpty(studyEventOid))     throw new ArgumentNullException("studyEventOid"); 

            var studyEventDataElement = xmlDoc.CreateElement("StudyEventData");

            studyEventDataElement.SetAttribute("StudyEventOID", studyEventOid);

            if (!ReferenceEquals(studyEventRepeatKey, null))
            {
                studyEventDataElement.SetAttribute("StudyEventRepeatKey", studyEventRepeatKey);
            }

            return studyEventDataElement;
        }

        public static XmlElement CreateFormDataElement(
            this XmlDocument xmlDoc,
            string formOid,
            string formRepeatKey)
        {
            if (ReferenceEquals(xmlDoc, null))           throw new ArgumentNullException("xmlDoc");        
            if (String.IsNullOrEmpty(formOid))           throw new ArgumentNullException("formOid");       
            if (String.IsNullOrEmpty(formRepeatKey))     throw new ArgumentNullException("formRepeatKey"); 

            var formDataElement = xmlDoc.CreateElement("FormData");

            formDataElement.SetAttribute("FormOID"          , formOid);
            formDataElement.SetAttribute("FormRepeatKey"    , formRepeatKey);

            return formDataElement;
        }

        public static XmlElement CreateItemGroupDataElement(
            this XmlDocument xmlDoc,
            string itemGroupOid,
            string itemGroupRepeatKey = null)
        {
            if (ReferenceEquals(xmlDoc, null))           throw new ArgumentNullException("xmlDoc");        
            if (String.IsNullOrEmpty(itemGroupOid))      throw new ArgumentNullException("itemGroupOid");  

            var itemGroupDataElement = xmlDoc.CreateElement("ItemGroupData");

            itemGroupDataElement.SetAttribute("ItemGroupOID", itemGroupOid);

            if (!ReferenceEquals(itemGroupRepeatKey, null))
            {
                itemGroupDataElement.SetAttribute("ItemGroupRepeatKey", itemGroupRepeatKey);
            }

            return itemGroupDataElement;
        }

        public static XmlElement CreateItemDataElement(
            this XmlDocument xmlDoc,
            string itemOid,
            string value,
            string codingContextUri     = null,
            string codingTermUuid       = null,
            string updateTimeStamp      = null)
        {
            if (ReferenceEquals(xmlDoc, null))       throw new ArgumentNullException("xmlDoc");    
            if (String.IsNullOrEmpty(itemOid))       throw new ArgumentNullException("itemOid");   
            if (ReferenceEquals(value, null))        throw new ArgumentNullException("value");     

            var itemDataElement = xmlDoc.CreateElement("ItemData", "mdsol");

            itemDataElement.SetAttribute("ItemOID"      , itemOid);
            itemDataElement.SetAttribute("Value"        , value);

            if (!ReferenceEquals(codingContextUri, null))
            {
                itemDataElement.SetNamespaceAttribute("mdsol", "CodingContextURI", codingContextUri);
            }

            if (!ReferenceEquals(codingTermUuid, null))
            {
                itemDataElement.SetNamespaceAttribute("mdsol", "CodingTermUUID", codingTermUuid);
            }

            if (!ReferenceEquals(updateTimeStamp, null))
            {
                itemDataElement.SetNamespaceAttribute("mdsol", "UpdatedTimeStamp", updateTimeStamp);
            }

            return itemDataElement;
        }

        public static XmlElement CreateQueueItemElement(
            this XmlDocument xmlDoc,
            string queueItemOid)
        {
            if (ReferenceEquals(xmlDoc, null))           throw new ArgumentNullException("xmlDoc");        
            if (String.IsNullOrEmpty(queueItemOid))      throw new ArgumentNullException("queueItemOid");  

            var queueItemElement = xmlDoc.CreateElement("mdsol:QueueItem", "mdsol");

            queueItemElement.SetAttribute("OID", queueItemOid);

            return queueItemElement;
        }

        public static XmlElement CreateQueryElement(
            this XmlDocument xmlDoc,
            OdmQueryParameters odmQueryParameters)
        {
            if (ReferenceEquals(xmlDoc, null))                           throw new ArgumentNullException("xmlDoc");
            if (ReferenceEquals(odmQueryParameters, null))               throw new ArgumentNullException("odmQueryParameters");
            if (String.IsNullOrEmpty(odmQueryParameters.QueryUuid     )) throw new ArgumentNullException("odmQueryParameters.QueryUuid");
            if (String.IsNullOrEmpty(odmQueryParameters.Recipient     )) throw new ArgumentNullException("odmQueryParameters.Recipient");
            if (String.IsNullOrEmpty(odmQueryParameters.QueryRepeatKey)) throw new ArgumentNullException("odmQueryParameters.QueryRepeatKey");
            if (String.IsNullOrEmpty(odmQueryParameters.Status        )) throw new ArgumentNullException("odmQueryParameters.Status");
            if (String.IsNullOrEmpty(odmQueryParameters.Value         )) throw new ArgumentNullException("odmQueryParameters.Value");
            if (String.IsNullOrEmpty(odmQueryParameters.Response      )) throw new ArgumentNullException("odmQueryParameters.Response");
            if (String.IsNullOrEmpty(odmQueryParameters.Username      )) throw new ArgumentNullException("odmQueryParameters.Username");
            if (String.IsNullOrEmpty(odmQueryParameters.DateTime      )) throw new ArgumentNullException("odmQueryParameters.DateTime");

            var queryElement = xmlDoc.CreateElement("mdsol:Query", "mdsol");

            queryElement.SetAttribute("UUID"          , odmQueryParameters.QueryUuid     );
            queryElement.SetAttribute("Recipient"     , odmQueryParameters.Recipient     );
            queryElement.SetAttribute("QueryRepeatKey", odmQueryParameters.QueryRepeatKey);
            queryElement.SetAttribute("Status"        , odmQueryParameters.Status        );
            queryElement.SetAttribute("Value"         , odmQueryParameters.Value         );
            queryElement.SetAttribute("Response"      , odmQueryParameters.Response      );
            queryElement.SetAttribute("Username"      , odmQueryParameters.Username      );
            queryElement.SetAttribute("DateTime"      , odmQueryParameters.DateTime      );

            return queryElement;
        }
    }
}
