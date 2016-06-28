using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{

    internal sealed class RaveCoderConfigurationPage
    {
        private readonly BrowserSession _Session;
        
        private const string _WorkflowVariableNameHeaderText    = "Name";
        private const string _WorkflowVariableValueHeaderText   = "Value";
        private const string _WorkflowVariableEditHeaderText    = "Edit";
        private const string _WorkflowVariableSaveHeaderText    = "Edit";

        private const string _SupplementalTermNameHeaderText   = "Name";
        private const string _SupplementalTermEditHeaderText   = "Edit";
        private const string _SupplementalTermSaveHeaderText   = "Edit";
        private const string _SupplementalTermDeleteHeaderText = " ";
        
        private const string _IsApprovalRequiredLabel         = "IsApprovalRequired";
        private const string _IsAutoApprovalLabel             = "IsAutoApproval";

        internal RaveCoderConfigurationPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");

            _Session = session;
        }

        private SessionElementScope GetLocaleSelectList()
        {
            var localeSelectList = _Session.FindSessionElementById("_ctl0_Content_m_CoderFieldConfig_DDLLocale");

            return localeSelectList;
        }

        private SessionElementScope GetCodingLevelSelectList()
        {
            var codingLevelSelectList = _Session.FindSessionElementById("_ctl0_Content_m_CoderFieldConfig_LevelDDL");

            return codingLevelSelectList;
        }

        private SessionElementScope GetPriorityTextBox()
        {
            var priorityTextBox = _Session.FindSessionElementById("_ctl0_Content_m_CoderFieldConfig_PriorityTXT");

            return priorityTextBox;
        }
        
        private SessionElementScope GetSaveButton()
        {
            var saveButton = _Session.FindSessionElementById("_ctl0_Content_m_CoderFieldConfig_BtnSave");

            return saveButton;
        }

        private SessionElementScope GetSupplementalTermSelectList()
        {
            var supplementalTermSelectList = _Session.FindSessionElementById("_ctl0_Content_m_CoderFieldConfig_FieldNameForSuppDDL");

            return supplementalTermSelectList;
        }

        private SessionElementScope GetAddSupplementalTermButton()
        {
            var addSupplementalTermButton = _Session.FindSessionElementById("_ctl0_Content_m_CoderFieldConfig_BtnAddSupplemental");

            return addSupplementalTermButton;
        }

        private SessionElementScope GetWorkflowVariablesGrid()
        {
            var workflowVariablesGrid = _Session.FindSessionElementById("_ctl0_Content_m_CoderFieldConfig_VariableGrid");

            return workflowVariablesGrid;
        }

        private SessionElementScope GetWorkflowVariableValueCell(string workflowVariableName)
        {
            if (String.IsNullOrWhiteSpace(workflowVariableName)) throw new ArgumentNullException("workflowVariableName");

            var workflowVariablesGrid = GetWorkflowVariablesGrid();

            var workflowVariableValueCell = workflowVariablesGrid.FindTableCell(_WorkflowVariableNameHeaderText, workflowVariableName, _WorkflowVariableValueHeaderText);

            return workflowVariableValueCell;
        }
        
        private SessionElementScope GetWorkflowVariableSelectList(string workflowVariableName)
        {
            if (String.IsNullOrWhiteSpace(workflowVariableName)) throw new ArgumentNullException("workflowVariableName");

            var workflowVariableValueCell = GetWorkflowVariableValueCell(workflowVariableName);

            var workflowVariableSelectList = workflowVariableValueCell.FindSessionElementByXPath(".//select");

            return workflowVariableSelectList;
        }

        private SessionElementScope GetWorkflowVariableLink(string workflowVariableName, string workflowVariableHeaderText)
        {
            if (String.IsNullOrWhiteSpace(workflowVariableName))       throw new ArgumentNullException("workflowVariableName");
            if (String.IsNullOrWhiteSpace(workflowVariableHeaderText)) throw new ArgumentNullException("workflowVariableHeaderText");

            var workflowVariablesGrid = GetWorkflowVariablesGrid();

            var workflowVariableLinkCell = workflowVariablesGrid.FindTableCell(_WorkflowVariableNameHeaderText, workflowVariableName, workflowVariableHeaderText);

            var workflowVariableLink = workflowVariableLinkCell.FindAllSessionElementsByXPath(".//a").FirstOrDefault();

            if (ReferenceEquals(workflowVariableLink, null))
            {
                throw new MissingHtmlException(String.Format("Link for Workflow Variable, {0}, was not found.", workflowVariableName));
            }

            return workflowVariableLink;
        }

        private string GetWorkflowVariableValue(string workflowVariableName)
        {
            if (String.IsNullOrWhiteSpace(workflowVariableName)) throw new ArgumentNullException("workflowVariableName");
            
            var workflowVariableValueCell = GetWorkflowVariableValueCell(workflowVariableName);

            var workflowVariableValue = workflowVariableValueCell.Text;

            return workflowVariableValue;
        }
        
        private void EditWorkflowVariable(string workflowVariableName)
        {
            if (String.IsNullOrWhiteSpace(workflowVariableName)) throw new ArgumentNullException("workflowVariableName");

            var editWorkflowVariableLink = GetWorkflowVariableLink(workflowVariableName, _WorkflowVariableEditHeaderText);

            editWorkflowVariableLink.Click();
        }

        private void SaveWorkflowVariable(string workflowVariableName)
        {
            if (String.IsNullOrWhiteSpace(workflowVariableName)) throw new ArgumentNullException("workflowVariableName");

            var saveWorkflowVariableLink = GetWorkflowVariableLink(workflowVariableName, _WorkflowVariableSaveHeaderText);

            saveWorkflowVariableLink.Click();
        }

        private void SetWorkflowVariable(string workflowVariableName, string targetWorkflowVariableName)
        {
            if (String.IsNullOrWhiteSpace(workflowVariableName))       throw new ArgumentNullException("workflowVariableName");
            if (String.IsNullOrWhiteSpace(targetWorkflowVariableName)) throw new ArgumentNullException("targetWorkflowVariableName");

            string currentWorkflowVariableValue = GetWorkflowVariableValue(workflowVariableName);

            if (!currentWorkflowVariableValue.EqualsIgnoreCase(targetWorkflowVariableName))
            {
                EditWorkflowVariable(workflowVariableName);
                GetWorkflowVariableSelectList(workflowVariableName).SelectOptionAlphanumericOnly(targetWorkflowVariableName);
                SaveWorkflowVariable(workflowVariableName);
            }
        }
        
        internal void SetCoderConfiguration(RaveCoderFieldConfiguration coderConfiguration)
        {
            if (ReferenceEquals(coderConfiguration, null)) throw new ArgumentNullException("coderConfiguration");

            if (!String.IsNullOrWhiteSpace(coderConfiguration.Locale) && coderConfiguration.Dictionary.Contains("MedDRA", StringComparison.OrdinalIgnoreCase))
            {
                if (!GetLocaleSelectList().Exists())
                {
                    throw new InvalidOperationException(
                        String.Format("Locale, {0}, is not configurable for dictionary {1}", coderConfiguration.Locale, coderConfiguration.Dictionary));
                }

                GetLocaleSelectList().SelectOptionAlphanumericOnly(coderConfiguration.Locale); 
            }
            
            GetCodingLevelSelectList().SelectOptionAlphanumericOnly(coderConfiguration.CodingLevel);
            GetPriorityTextBox().FillInWith(coderConfiguration.Priority);

            GetSaveButton().Click();

            SetWorkflowVariable(_IsApprovalRequiredLabel, coderConfiguration.IsApprovalRequired);
            SetWorkflowVariable(_IsAutoApprovalLabel, coderConfiguration.IsAutoApproval);

            if (!String.IsNullOrWhiteSpace(coderConfiguration.SupplementalTerms))
            {
                var supplementalTerms = coderConfiguration.SupplementalTerms.Split(new char[] {','}, StringSplitOptions.RemoveEmptyEntries);
                foreach (var supplementalTerm in supplementalTerms)
                {
                    AddSupplementalTerm(supplementalTerm.Trim());
                }
            }
        }
        
        internal RaveCoderFieldConfiguration GetCoderConfiguration()
        {
            string locale = null;

            if (GetLocaleSelectList().Exists())
            {
                locale = GetLocaleSelectList().SelectedOption;
            }

            var codingLevel = GetCodingLevelSelectList().SelectedOption;
            var priority    = GetPriorityTextBox().Value;

            var isApprovalRequired = GetWorkflowVariableValue(_IsApprovalRequiredLabel);
            var isAutoApproval     = GetWorkflowVariableValue(_IsAutoApprovalLabel);

            IEnumerable<string> supplementalTerms = GetSupplementalTerms();

            string combinedSupplementalTerms = String.Join(",", supplementalTerms);

            RaveCoderFieldConfiguration coderConfiguration = new RaveCoderFieldConfiguration
            {
                Locale             = locale,
                CodingLevel        = codingLevel,
                Priority           = priority,
                IsApprovalRequired = isApprovalRequired,
                IsAutoApproval     = isAutoApproval,
                SupplementalTerms  = combinedSupplementalTerms
            };

            return coderConfiguration;
        }

        private SessionElementScope GetSupplementalTermsGrid()
        {
            var supplementalTermsGrid = _Session.FindSessionElementById("_ctl0_Content_m_CoderFieldConfig_SupplementalGrid");

            return supplementalTermsGrid;
        }

        private IEnumerable<string> GetSupplementalTerms()
        {
            var supplementalTermsGrid = GetSupplementalTermsGrid();

            var supplementalTermRows = supplementalTermsGrid.GetTableRows();

            var supplementalTerms = supplementalTermRows.Select(x => x.Text.Trim()).Where(x=>!x.Contains(_SupplementalTermNameHeaderText, StringComparison.OrdinalIgnoreCase));

            return supplementalTerms;
        }

        private SessionElementScope GetSupplementalTermLink(string supplementalTermName, string supplementalTermHeaderText)
        {
            if (String.IsNullOrWhiteSpace(supplementalTermName))       throw new ArgumentNullException("supplementalTermName");
            if (String.IsNullOrWhiteSpace(supplementalTermHeaderText)) throw new ArgumentNullException("supplementalTermHeaderText");

            var supplementalTermsGrid = GetSupplementalTermsGrid();

            var supplementalTermLinkCell = supplementalTermsGrid.FindTableCell(_SupplementalTermNameHeaderText, supplementalTermName, supplementalTermHeaderText);

            var supplementalTermLink = supplementalTermLinkCell.FindAllSessionElementsByXPath(".//a").FirstOrDefault();

            if (ReferenceEquals(supplementalTermLink, null))
            {
                throw new MissingHtmlException(String.Format("Link for Supplemental Term, {0}, was not found.", supplementalTermName));
            }

            return supplementalTermLink;
        }

        private SessionElementScope GetSupplementalTermDeleteCheckbox(string supplementalTermName)
        {
            if (String.IsNullOrWhiteSpace(supplementalTermName)) throw new ArgumentNullException("supplementalTermName");

            var supplementalTermsGrid          = GetSupplementalTermsGrid();

            var supplementalTermRow            = supplementalTermsGrid.FindTableRow(supplementalTermName);

            var supplementalTermRowInputs      = supplementalTermRow.FindAllSessionElementsByXPath(".//input");

            var supplementalTermDeleteCheckbox = supplementalTermRowInputs.FirstOrDefault(x => x.Type.Equals("checkbox"));

            if (ReferenceEquals(supplementalTermDeleteCheckbox, null))
            {
                throw new MissingHtmlException(String.Format("Delete Checkbox for Supplemental Term, {0}, was not found.", supplementalTermName));
            }

            return supplementalTermDeleteCheckbox;
        }

        private void EditSupplementalTerm(string supplementalTermName)
        {
            if (String.IsNullOrWhiteSpace(supplementalTermName)) throw new ArgumentNullException("supplementalTermName");

            var editSupplementalTermLink = GetSupplementalTermLink(supplementalTermName, _SupplementalTermEditHeaderText);

            editSupplementalTermLink.Click();
        }

        private void SaveSupplementalTerm(string supplementalTermName)
        {
            if (String.IsNullOrWhiteSpace(supplementalTermName)) throw new ArgumentNullException("supplementalTermName");

            var saveSupplementalTermLink = GetSupplementalTermLink(supplementalTermName, _SupplementalTermSaveHeaderText);

            saveSupplementalTermLink.Click();
        }

        internal void AddSupplementalTerm(string supplementalTerm)
        {
            if (String.IsNullOrWhiteSpace(supplementalTerm)) throw new ArgumentNullException("supplementalTerm");

            GetSupplementalTermSelectList().SelectOptionAlphanumericOnly(supplementalTerm);
            GetAddSupplementalTermButton().Click();
        }

        internal void RemoveSupplementalTerm(string supplementalTermName)
        {
            if (String.IsNullOrWhiteSpace(supplementalTermName)) throw new ArgumentNullException("supplementalTermName");
            
            EditSupplementalTerm(supplementalTermName);
            GetSupplementalTermDeleteCheckbox(supplementalTermName).SetCheckBoxState(true);
            SaveSupplementalTerm(supplementalTermName);
        }
    }
}
