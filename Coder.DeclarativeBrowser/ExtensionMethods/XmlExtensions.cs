using System;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using Coder.DeclarativeBrowser.Helpers;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.OdmBuilder;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    public static class XmlExtensions
    {
        public static XmlElement BuildClinicalDataElement(
            this XmlDocument xmlDoc, 
            OdmParameters odmParameters)
        {
            if (ReferenceEquals(xmlDoc          , null))                throw new ArgumentNullException("xmlDoc");          
            if (ReferenceEquals(odmParameters   , null))                throw new ArgumentNullException("odmParameters"); 

            var itemDataElement = xmlDoc.CreateItemDataElement(
                odmParameters.FormOid + "." + odmParameters.ItemDataOid,
                odmParameters.VerbatimTerm,
                odmParameters.CodingContextUri,
                odmParameters.CodingTermUUID,
                odmParameters.UpdatedTimeStamp);

            var itemGroupDataElement        = xmlDoc.CreateItemGroupDataElement(odmParameters.ItemGroupOid, odmParameters.ItemGroupRepeatKey);
            var formDataElement             = xmlDoc.CreateFormDataElement(odmParameters.FormOid, odmParameters.FormRepeatKey);
            var studyEventDataElement       = xmlDoc.CreateStudyEventDataElement(odmParameters.StudyEventOid, odmParameters.StudyEventRepeatKey);
            var siteRefElement              = xmlDoc.CreateSiteRefElement(odmParameters.LocationOid);
            var subjectDataElement          = xmlDoc.CreateSubjectDataElement(odmParameters.SubjectKey);
            var clinicalDataElement         = xmlDoc.CreateClinicalDataElement(odmParameters.StudyOid, odmParameters.MetaDataVersionOid);

            var componentItemDataElements = new List<XmlElement>();

            if (!ReferenceEquals(odmParameters.ComponentList, null))
            {
                for (var i = 0; i < odmParameters.ComponentList.Count; i++)
                {
                    var fieldName = odmParameters.ComponentFieldName + (i + 1);

                    componentItemDataElements.Add(
                        xmlDoc.CreateItemDataElement(
                            odmParameters.FormOid + "." + fieldName,
                            odmParameters.ComponentList[i]));
                }
            }

            var supplementalItemDataElements = new List<XmlElement>();

            if (!ReferenceEquals(odmParameters.FullSupplementList, null))
            {
                foreach (string supplementField in odmParameters.FullSupplementList.Keys)
                {
                    supplementalItemDataElements.Add(
                        xmlDoc.CreateItemDataElement(
                            odmParameters.FormOid + "." + supplementField,
                            odmParameters.FullSupplementList[supplementField]));
                }
            }

            if (!ReferenceEquals(odmParameters.odmQueryParameters, null))
            {
                var queryElement = xmlDoc.CreateQueryElement(odmParameters.odmQueryParameters);
                itemDataElement.AppendChild(queryElement);
            }
            
            itemGroupDataElement.AppendChild(itemDataElement);

            foreach (var element in componentItemDataElements)
            {
                itemGroupDataElement.AppendChild(element);
            }

            foreach (var element in supplementalItemDataElements)
            {
                itemGroupDataElement.AppendChild(element);
            }

            formDataElement.AppendChild(itemGroupDataElement);
            studyEventDataElement.AppendChild(formDataElement);
            subjectDataElement.AppendChild(siteRefElement);
            subjectDataElement.AppendChild(studyEventDataElement);
            clinicalDataElement.AppendChild(subjectDataElement);

            return clinicalDataElement;
        }

        public static XmlElement BuildMetaDataVersionElement(
            this XmlDocument xmlDoc, 
            OdmParameters odmParameters)
        {
            if (ReferenceEquals(xmlDoc          , null))                throw new ArgumentNullException("xmlDoc");           
            if (ReferenceEquals(odmParameters   , null))                throw new ArgumentNullException("odmParameters");    

            var metaDataVersionElement      = xmlDoc.CreateMetaDataVersionElement(odmParameters.MetaDataVersionOid, odmParameters.MetaDataVersionName);
            var formDefElement              = xmlDoc.CreateFormDefElement(odmParameters.FormOid, odmParameters.FormName, odmParameters.FormDefRepeating);
            var itemGroupRefElement         = xmlDoc.CreateItemGroupRefElement(odmParameters.ItemGroupOid, odmParameters.ItemGroupRefMandatory);
            var itemGroupDefElement         = xmlDoc.CreateItemGroupDefElement(odmParameters.ItemGroupOid, odmParameters.ItemGroupOid, odmParameters.ItemGroupDefRepeating);
            var itemRefElement              = xmlDoc.CreateItemRefElement(odmParameters.FormOid + "." + odmParameters.ItemDataOid, odmParameters.ItemRefMandatory);
            var itemDefElement              = xmlDoc.CreateItemDefElement(odmParameters.FormOid + "." + odmParameters.ItemDataOid, odmParameters.ItemName, odmParameters.ItemDefDataType);
            var codingRequestDefElement     = xmlDoc.CreateCodingRequestDefElement(
                odmParameters.DictionaryLevel, 
                odmParameters.Dictionary, 
                odmParameters.CodingPriority,
                odmParameters.CodingLocale,
                odmParameters.MarkingGroup);

            var componentItemDefElements                        = new List<XmlElement>();
            var componentDictionaryLevelComponentRefElements    = new List<XmlElement>();
            var componentItemRefElements                        = new List<XmlElement>();

            if (!ReferenceEquals(odmParameters.ComponentList, null))
            {
                for (var i = 0; i < odmParameters.ComponentList.Count; i++)
                {
                    var fieldName = odmParameters.ComponentFieldName          + (i + 1);
                    var oid       = odmParameters.DictionaryLevelComponentOID + (i + 1);

                    componentItemDefElements.Add(
                        xmlDoc.CreateItemDefElement(
                            odmParameters.FormOid + "." + fieldName,
                            fieldName,
                            odmParameters.ItemDefDataType));

                    componentDictionaryLevelComponentRefElements.Add(
                        xmlDoc.CreateDictionaryLevelComponentRefElement(
                            oid,
                            odmParameters.FormOid + "." + fieldName));

                    componentItemRefElements.Add(
                        xmlDoc.CreateItemRefElement(
                            odmParameters.FormOid + "." + fieldName,
                            odmParameters.ItemRefMandatory));
                }
            }

            var supplementalItemDefElements     = new List<XmlElement>();
            var supplementalRefElements         = new List<XmlElement>();
            var supplementalItemRefElements     = new List<XmlElement>();
            
            if (!ReferenceEquals(odmParameters.FullSupplementList, null))
            {
                foreach (string supplementField in odmParameters.FullSupplementList.Keys)
                {
                    supplementalItemDefElements.Add(
                        xmlDoc.CreateItemDefElement(
                            odmParameters.FormOid + "." + supplementField,
                            supplementField,
                            odmParameters.ItemDefDataType));

                    supplementalRefElements.Add(
                        xmlDoc.CreateSupplementalRefElement(
                            odmParameters.FormOid + "." + supplementField));

                    supplementalItemRefElements.Add(
                        xmlDoc.CreateItemRefElement(
                            odmParameters.FormOid + "." + supplementField,
                            odmParameters.ItemRefMandatory));
                }
            }

            var codingWorkFlowDataElements = new List<XmlElement>
            {
                xmlDoc.CreateCodingWorkflowDataElement("IsAutoCode"             , odmParameters.IsAutoCode),
                xmlDoc.CreateCodingWorkflowDataElement("IsApprovalRequired"     , odmParameters.IsApprovalRequired),
                xmlDoc.CreateCodingWorkflowDataElement("IsAutoApproval"         , odmParameters.IsAutoApproval),
                xmlDoc.CreateCodingWorkflowDataElement("IsBypassTransmit"       , odmParameters.IsBypassTransmit)
            };


            foreach (var element in componentDictionaryLevelComponentRefElements)
            {
                codingRequestDefElement.AppendChild(element);
            }

            foreach (var element in supplementalRefElements)
            {
                codingRequestDefElement.AppendChild(element);
            }

            foreach (var element in codingWorkFlowDataElements)
            {
                codingRequestDefElement.AppendChild(element);
            }

            itemDefElement.AppendChild(codingRequestDefElement);

            itemGroupDefElement.AppendChild(itemRefElement);

            foreach (var element in componentItemRefElements)
            {
                itemGroupDefElement.AppendChild(element);
            }

            foreach (var element in supplementalItemRefElements)
            {
                itemGroupDefElement.AppendChild(element);
            }

            formDefElement.AppendChild(itemGroupRefElement);

            metaDataVersionElement.AppendChild(formDefElement);
            metaDataVersionElement.AppendChild(itemGroupDefElement);
            metaDataVersionElement.AppendChild(itemDefElement);

            foreach (var item in componentItemDefElements)
            {
                metaDataVersionElement.AppendChild(item);
            }

            foreach (var item in supplementalItemDefElements)
            {
                metaDataVersionElement.AppendChild(item);
            }

            return metaDataVersionElement;
        }

        public static XmlElement BuildStudyElement(
            this XmlDocument xmlDoc, 
            OdmParameters odmParameters)
        {
            if (ReferenceEquals(xmlDoc, null))                  throw new ArgumentNullException("xmlDoc");         
            if (ReferenceEquals(odmParameters, null))           throw new ArgumentNullException("odmParameters"); 

            var studyElement                = xmlDoc.CreateStudyElement(odmParameters.StudyOid);
            var globalVariablesElement      = xmlDoc.CreateGlobalVariablesElement(
                studyName: odmParameters.StudyName,
                studyDescription: odmParameters.StudyDescription,
                protocolName: odmParameters.ProtocolName);

            var metaDataVersionElement      = xmlDoc.BuildMetaDataVersionElement(odmParameters);

            studyElement.AppendChild(globalVariablesElement);
            studyElement.AppendChild(metaDataVersionElement);

            return studyElement;
        }

        public static XmlElement CreateElementWithInnerText(
            this XmlDocument xmlDoc,
            string name,
            string innerText)
        {
            if (ReferenceEquals(xmlDoc, null))                  throw new ArgumentNullException("xmlDoc");      
            if (String.IsNullOrEmpty(name))                     throw new ArgumentNullException("name");      
            if (String.IsNullOrEmpty(innerText))                throw new ArgumentNullException("innerText"); 

            var element = xmlDoc.CreateElement(name);
            element.InnerText = innerText;

            return element;
        }

        public static XmlElement SetNamespaceAttribute(
            this XmlElement element,
            string nameSpaceName,
            string name,
            string value)
        {
            if (ReferenceEquals(element, null))                 throw new ArgumentNullException("element");         
            if (String.IsNullOrEmpty(nameSpaceName))            throw new ArgumentNullException("nameSpaceName");   
            if (String.IsNullOrEmpty(name))                     throw new ArgumentNullException("name");            
            if (String.IsNullOrEmpty(value))                    throw new ArgumentNullException("value");         

            var attribute = CreateNamespaceAttribute(
                element,
                nameSpaceName,
                name,
                value);

            element.SetAttributeNode(attribute);

            return element;
        }

        public static XmlAttribute CreateNamespaceAttribute(
            XmlElement element,
            string nameSpaceName,
            string name,
            string value)
        {
            if (ReferenceEquals(element, null))                  throw new ArgumentNullException("element");                     
            if (ReferenceEquals(element.OwnerDocument, null))    throw new NullReferenceException("element.OwnerDocument");      
            if (String.IsNullOrEmpty(nameSpaceName))             throw new ArgumentNullException("nameSpaceName");               
            if (String.IsNullOrEmpty(name))                      throw new ArgumentNullException("name");                        
            if (String.IsNullOrEmpty(value))                     throw new ArgumentNullException("value");                     

            var attribute = element.OwnerDocument.CreateAttribute(name, nameSpaceName);
            attribute.Value = value;

            return attribute;
        }

        public static string AsString(this XmlDocument xmlDoc)
        {
            if (ReferenceEquals(xmlDoc, null))                  throw new ArgumentNullException("xmlDoc"); 

            using (var sw = new StringWriter())
            {
                using (var tx = new XmlTextWriter(sw))
                {
                    xmlDoc.WriteTo(tx);
                    var strXmlText = sw.ToString();
                    return strXmlText;
                }
            }
        }
    }
}
