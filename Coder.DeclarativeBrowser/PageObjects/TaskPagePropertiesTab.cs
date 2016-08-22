using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class TaskPagePropertiesTab
    {
        private readonly BrowserSession _Browser;
        private const string EmptyHtmlValue = "&nbsp;";

        public TaskPagePropertiesTab(BrowserSession browser) { if (ReferenceEquals(browser, null)) { throw new ArgumentNullException("browser"); }  _Browser = browser; }

        public SessionElementScope GetPropertiesFrame()
        {
            var propertiesFrame = _Browser.FindSessionElementById("ctl00_Content_FrmProperty");

            return propertiesFrame;
        }

        public SessionElementScope GetPropertiesGrid()
        {
            var propertiesGrid = GetPropertiesFrame().FindSessionElementById("gridProperty_DXMainTable");

            return propertiesGrid;
        }

        public SessionElementScope GetMedicalDictionaryGrid()
        {
            var medicalDictionaryGrid = GetPropertiesGrid().FindSessionElementById("gridProperty_DXDataRow0");

            return medicalDictionaryGrid;
        }

        public SessionElementScope GetSourceSystemGrid()
        {
            var sourceSystemGrid = GetPropertiesGrid().FindSessionElementById("gridProperty_DXDataRow1");

            return sourceSystemGrid;
        }

        public SessionElementScope GetCodingStatusGrid()
        {
            var codingStatusGrid = GetPropertiesGrid().FindSessionElementById("gridProperty_DXDataRow2");

            return codingStatusGrid;
        }

        private SessionElementScope GetMedicalDictionaryGridExpander()
        {
            var medicalDictionaryGridExpander = GetMedicalDictionaryGrid().FindSessionElementByXPath("td/img");

            return medicalDictionaryGridExpander;
        }

        private SessionElementScope GetSourceSystemGridExpander()
        {
            var sourceSystemGridExpander = GetSourceSystemGrid().FindSessionElementByXPath("td/img");

            return sourceSystemGridExpander;
        }

        private SessionElementScope GetCodingStatusGridExpander()
        {
            var codingStatusGridExpander = GetCodingStatusGrid().FindSessionElementByXPath("td/img");

            return codingStatusGridExpander;
        }

        private SessionElementScope GetMedicalDictionaryDetailGrid()
        {
            var medicalDictionaryDetailGrid = GetPropertiesGrid()
                .FindSessionElementById("gridProperty_DXDRow0")
                .FindSessionElementById("gridProperty_dxdt0_gridPropertyDetail_DXMainTable");

            return medicalDictionaryDetailGrid;
        }

        private SessionElementScope GetSourceSystemDetailGrid()
        {
            var sourceSystemDetailGrid = GetPropertiesGrid()
                .FindSessionElementById("gridProperty_DXDRow1")
                .FindSessionElementById("gridProperty_dxdt1_gridPropertyDetail_DXMainTable");

            return sourceSystemDetailGrid;
        }

        private SessionElementScope GetCodingStatusDetailGrid()
        {
            var codingStatusDetailGrid = GetPropertiesGrid()
                .FindSessionElementById("gridProperty_DXDRow2")
                .FindSessionElementById("gridProperty_dxdt2_gridPropertyDetail_DXMainTable");

            return codingStatusDetailGrid;
        }

        private IList<SessionElementScope> GetMedicalDictionaryDetailGridRows()
        {
            var medicalDictionaryDetailGridRows = GetMedicalDictionaryDetailGrid().FindAllSessionElementsByXPath("tbody/tr");

            return medicalDictionaryDetailGridRows;
        }

        private IList<SessionElementScope> GetSourceSystemDetailGridRows()
        {
            var sourceSystemDetailGridRows = GetSourceSystemDetailGrid().FindAllSessionElementsByXPath("tbody/tr");

            return sourceSystemDetailGridRows;
        }

        private IList<SessionElementScope> GetCodingStatusDetailGridRows()
        {
            var codingStatusDetailGridRows = GetCodingStatusDetailGrid().FindAllSessionElementsByXPath("tbody/tr");

            return codingStatusDetailGridRows;
        }

        private bool IsMedicalDictionaryGridExpanded()
        {
            var isMedicalDictionaryGridExpanded = !GetMedicalDictionaryGridExpander()
                .OuterHTML
                .Contains("alt=\"[Expand]\"");

            return isMedicalDictionaryGridExpanded;
        }

        private bool IsSourceSystemGridExpanded()
        {
            var isSourceSystemGridExpanded = !GetSourceSystemGridExpander()
                .OuterHTML
                .Contains("alt=\"[Expand]\"");

            return isSourceSystemGridExpanded;
        }

        private bool IsCodingStatusGridExpanded()
        {
            var isCodingStatusGridExpanded = !GetCodingStatusGridExpander()
                .OuterHTML
                .Contains("alt=\"[Expand]\"");

            return isCodingStatusGridExpanded;
        }

        internal void ExpandMedicalDictionaryGrid()
        {
            bool isMedicalDictionaryGridExpanded = IsMedicalDictionaryGridExpanded();

            if (!isMedicalDictionaryGridExpanded)
            {
                GetMedicalDictionaryGridExpander().Click();

                WaitUntilFinishLoading();
            }
        }

        internal void ExpandSourceSystemGrid()
        {
            bool isSourceSystemGridExpanded = IsSourceSystemGridExpanded();

            if (!isSourceSystemGridExpanded)
            {
                GetSourceSystemGridExpander().Click();

                WaitUntilFinishLoading();
            }
        }

        internal void ExpandCodingStatusGrid()
        {
            bool isCodingStatusGridExpanded = IsCodingStatusGridExpanded();

            if (!isCodingStatusGridExpanded)
            {
                GetCodingStatusGridExpander().Click();

                WaitUntilFinishLoading();
            }
        }

        internal PropertyMedicalDictionary GetPropertyMedicalDictionaryTableValues()
        {
            var propertyMedicalDictionary = new PropertyMedicalDictionary
            {
                MedicalDictionary = GetMedicalDictionaryGrid().FindAllSessionElementsByXPath("td").Last().InnerHTML,
                Segment           = GetMedicalDictionaryDetailGridRows()[0].FindAllSessionElementsByXPath("td").Last().InnerHTML,
                DictionaryLevel   = GetMedicalDictionaryDetailGridRows()[1].FindAllSessionElementsByXPath("td").Last().InnerHTML,
                VerbatimTerm      = GetMedicalDictionaryDetailGridRows()[2].FindAllSessionElementsByXPath("td").Last().InnerHTML,
                Priority          = GetMedicalDictionaryDetailGridRows()[3].FindAllSessionElementsByXPath("td").Last().InnerHTML,
                Locale            = GetMedicalDictionaryDetailGridRows()[4].FindAllSessionElementsByXPath("td").Last().InnerHTML
            };

            return propertyMedicalDictionary;
        }

        internal PropertySourceSystem GetPropertySourceSystemTableValues()
        {
            var propertySourceSystem = new PropertySourceSystem
            {
                SourceSystem        = GetSourceSystemGrid().FindAllSessionElementsByXPath("td").Last().InnerHTML,
                Locale              = GetSourceSystemDetailGridRows()[0].FindAllSessionElementsByXPath("td").Last().InnerHTML,
                StudyName           = GetSourceSystemDetailGridRows()[1].FindAllSessionElementsByXPath("td").Last().InnerHTML,
                ConnectionUri       = GetSourceSystemDetailGridRows()[2].FindAllSessionElementsByXPath("td").Last().InnerHTML,
                FileOid             = GetSourceSystemDetailGridRows()[3].FindAllSessionElementsByXPath("td").Last().InnerHTML,
                ProtocolNumber      = GetSourceSystemDetailGridRows()[4].FindAllSessionElementsByXPath("td").Last().InnerHTML,
                ProtocolName        = GetSourceSystemDetailGridRows()[5].FindAllSessionElementsByXPath("td").Last().InnerHTML
            };

            //TODO: iMedidata syncing isn't working correctly, hard code this value until it's working properly
            if (propertySourceSystem.ProtocolName.Equals(EmptyHtmlValue))
            {
                propertySourceSystem.ProtocolName = string.Empty;
            }

            return propertySourceSystem;
        }

        internal PropertyCodingStatus GetPropertyCodingStatusTableValues()
        {
            var propertyCodingStatus = new PropertyCodingStatus
            {
                CodingStatus = GetCodingStatusGrid().FindAllSessionElementsByXPath("td").Last().InnerHTML,
                Workflow     = GetCodingStatusDetailGridRows()[0].FindAllSessionElementsByXPath("td").Last().InnerHTML,
                CreationDate = GetCodingStatusDetailGridRows()[1].FindAllSessionElementsByXPath("td").Last().InnerHTML,
                AutoCodeDate = GetCodingStatusDetailGridRows()[2].FindAllSessionElementsByXPath("td").Last().InnerHTML
            };

            if (propertyCodingStatus.AutoCodeDate.Equals(EmptyHtmlValue))
            {
                propertyCodingStatus.AutoCodeDate = string.Empty;
            }

            return propertyCodingStatus;
        }

        private void WaitUntilFinishLoading()
        {
            _Browser.WaitUntilElementDisappears(GetLoadingIndicator);
        }

        private SessionElementScope GetLoadingIndicator()
        {
            var loadingIndicator = _Browser.FindSessionElementByXPath("//*[contains(@id, '_LPV')]");

            return loadingIndicator;
        }
    }
}
