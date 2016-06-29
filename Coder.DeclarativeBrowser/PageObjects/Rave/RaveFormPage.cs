using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Helpers;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coypu;
using OpenQA.Selenium;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveFormPage
    {
        private enum FormState
        {
            Invalid,
            Blank,
            PartiallyComplete,
            PartiallyCompleteDataSentToCoder,
            RequiringCoding,
            Locked,
            Frozen,
            OpenQuery,
            RequiringSignature,
            Complete
        };

        private readonly BrowserSession _Session;
        
        private const string _TextTypeXpath                 = ".//input";
        private const string _SelectTypeXpath               = ".//select";
        private const string _LongTextTypeXpath             = ".//textarea";
        private const string _RadioButtonListTypeXpath      = ".//table";
        private const string _RadioButtonTypeXpath          = ".//input";
        private const string _CheckboxTypeXpath             = ".//input";
        
        private const string _CheckboxType                  = "Checkbox";
        private const string _TextType                      = "Text";
        private const string _PasswordType                  = "Password";

        private const string _AuditLinkXpath                = ".//a[contains(@id, '_DataStatusHyperlink')]";
        private const string _ModifyLinkXpath               = ".//input[contains(@id, '_PencilButton')]";
        private const string _MarkLinkXpath                 = ".//input[contains(@id, '_MarkingButton')]";
        
        private const string _FreezeIdSuffix                = "_EntryLockBox";
        private const string _LockIdSuffix                  = "_HardLockBox";

        private const string _ActiveFormText                = "Inactivate Page";
        private const string _InactiveFormText              = "Activate Page";

        private const string _MarkingTypeQuery              = "Open Query";
        private const string _MarkingTypeSticky             = "Place Sticky";
        private const string _MarkingTypeProtocolDeviation  = "Protocol Deviation";

        private const int _MarkingSelectListTypeIndex           = 0;
        private const int _MarkingSelectListProtocolTypeIndex   = 1;
        private const int _MarkingSelectListProtocolReasonIndex = 2;

        private const int _TermPathLevelIndex                   = 0;
        private const int _TermPathCodeIndex                    = 1;
        private const int _TermPathTermIndex                    = 2;
        private const int _TermPathLevelElements                = 3;

        private readonly Dictionary<string, FormState> FormIconToState = new Dictionary<string, FormState>
            {
                {"crf_bl.gif" , FormState.Blank                           },
                {"crf_pc.gif" , FormState.PartiallyComplete               },
                {"crf_rcd.gif", FormState.PartiallyCompleteDataSentToCoder},
                {"crf_rc.gif" , FormState.RequiringCoding                 },
                {"crf_lo.gif" , FormState.Locked                          },
                {"crf_fr.gif" , FormState.Frozen                          },
                {"crf_oq.gif" , FormState.OpenQuery                       },
                {"crf_sg.gif" , FormState.RequiringSignature              },
                {"crf_ok.gif" , FormState.Complete                        }
            };

        internal RaveFormPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }
        
        private SessionElementScope GetNewLogLineLink()
        {
            var newLogLineLink = _Session.FindSessionElementById("_ctl0_Content_R_log_log_AddLine");

            return newLogLineLink;
        }

        private SessionElementScope GetCompleteViewLink()
        {
            var completeViewLink = _Session.FindSessionElementById("_ctl0_Content_R_log_log_Portrait");

            return completeViewLink;
        }
        
        private SessionElementScope GetFormModifyLink()
        {
            var modifyFormLink = _Session.FindSessionElementById("_ctl0_Content_R_header_SG_PencilButton");

            return modifyFormLink;
        }

        private SessionElementScope GetFormAuditLink()
        {
            var formAuditLink = _Session.FindSessionElementById("_ctl0_Content_R_header_SG_DataStatusHyperlink");

            return formAuditLink;
        }

        private SessionElementScope GetFormFreezeCheckbox()
        {
            var formFreezeCheckbox = _Session.FindSessionElementById("_ctl0_Content_R_header_SG_EntryLockBox");

            return formFreezeCheckbox;
        }

        private SessionElementScope GetFormLockCheckbox()
        {
            var formLockCheckbox = _Session.FindSessionElementById("_ctl0_Content_R_header_SG_HardLockBox");

            return formLockCheckbox;
        }

        private SessionElementScope GetFormActivationLink()
        {
            var formActivationLink = _Session.FindSessionElementById("_ctl0_Content_R_header_INA_INAHL");

            return formActivationLink;
        }

        private SessionElementScope GetFormActivationConfirmationCheckbox()
        {
            var formActivationConfirmationCheckbox = _Session.FindSessionElementById("_ctl0_Content_R_header_INA_INACB");

            return formActivationConfirmationCheckbox;
        }

        private SessionElementScope GetInactivateLogLineLink()
        {
            var inactivateLogLineLink = _Session.FindSessionElementById("_ctl0_Content_R_log_log_Inactivate");

            return inactivateLogLineLink;
        }

        private SessionElementScope GetInactivateLogLineSelectList()
        {
            var inactivateLogLineSelectList = _Session.FindSessionElementById("_ctl0_Content_R_log_log_RP");

            return inactivateLogLineSelectList;
        }

        private SessionElementScope GetInactivateLogLineButton()
        {
            var inactivateLogLineButton = _Session.FindSessionElementById("_ctl0_Content_R_log_log_IB");

            return inactivateLogLineButton;
        }

        private SessionElementScope GetReactivateLogLineLink()
        {
            var reactivateLogLineLink = _Session.FindSessionElementById("_ctl0_Content_R_log_log_Activate");

            return reactivateLogLineLink;
        }

        private SessionElementScope GetReactivateLogLineSelectList()
        {
            var reactivateLogLineSelectList = _Session.FindSessionElementById("_ctl0_Content_R_log_log_IRP");

            return reactivateLogLineSelectList;
        }

        private SessionElementScope GetReactivateLogLineButton()
        {
            var reactivateLogLineButton = _Session.FindSessionElementById("_ctl0_Content_R_log_log_AB");

            return reactivateLogLineButton;
        }

        private SessionElementScope GetLogLineModifyLink(int logLineIndex)
        {
            if (logLineIndex < 1) throw new ArgumentOutOfRangeException("logLineIndex cannot be less than 1");

            var logLineRow = GetFormRowByLabel(logLineIndex.ToString());

            var modifyLogLineLink = logLineRow.FindSessionElementByXPath(_ModifyLinkXpath);

            return modifyLogLineLink;
        }

        private SessionElementScope GetLogLinesGrid()
        {
            var logLinesGrid = _Session.FindSessionElementById("log");

            return logLinesGrid;
        }
        
        private SessionElementScope GetFormRowModifyLink(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var formRow = GetFormRowByContents(rowContents);

            var modifyFormRowLink = formRow.FindSessionElementByXPath(_ModifyLinkXpath);

            return modifyFormRowLink;
        }

        private SessionElementScope GetFormRowAuditLink(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var formRow = GetFormRowByContents(rowContents);

            var formRowAuditLink = formRow.FindSessionElementByXPath(_AuditLinkXpath);

            return formRowAuditLink;
        }

        private SessionElementScope GetFormRowMarkLink(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var formRow = GetFormRowByContents(rowContents);

            var formRowMarkLink = formRow.FindSessionElementByXPath(_MarkLinkXpath);

            return formRowMarkLink;
        }

        private IEnumerable<SessionElementScope> GetFormRowInputsByContents(string rowContents, string typeXpath)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");
            if (String.IsNullOrWhiteSpace(typeXpath))   throw new ArgumentNullException("typeXpath");

            IEnumerable<SessionElementScope> inputs = null;

            RetryPolicy.FindElement.Execute(() =>
            {
                var formRow = GetFormRowByContents(rowContents);

                inputs = formRow.FindAllSessionElementsByXPath(typeXpath);

                if (!inputs.Any())
                {
                    throw new MissingHtmlException(String.Format("No inputs of type {0} found for row containing {1}.", typeXpath, rowContents));
                }
            });

            return inputs;
        }

        private SessionElementScope GetFormRowCheckbox(string rowContents, string action)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");
            if (String.IsNullOrWhiteSpace(action))      throw new ArgumentNullException("action");
            
            SessionElementScope checkbox = null;

            RetryPolicy.FindElement.Execute(() =>
            {
                var inputs     = GetFormRowInputsByContents(rowContents, _CheckboxTypeXpath);

                var checkboxes = inputs.Select(x => x).Where(x => x.Type.EqualsIgnoreCase(_CheckboxType) && x.Id.Contains(action, StringComparison.OrdinalIgnoreCase)).ToList();

                checkbox       = checkboxes.First();
            });
            
            return checkbox;
        }

        private SessionElementScope GetFormRowSelectList(string rowContents, int selectListIndex = 0)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");
            if (selectListIndex < 0)                    throw new ArgumentOutOfRangeException("selectListIndex must be greater than 0");

            SessionElementScope selectList = null;

            RetryPolicy.FindElement.Execute(() =>
            {
                var selectLists = GetFormRowInputsByContents(rowContents, _SelectTypeXpath).ToList();

                selectList = selectLists[selectListIndex];
            });

            return selectList;
        }

        private SessionElementScope GetFormArea()
        {
            var formArea = _Session.FindSessionElementById("HorizontalScrollDiv");

            return formArea;
        }

        private IEnumerable<SessionElementScope> GetFormRows()
        {
            var formArea = GetFormArea();

            var formRows = formArea.FindAllSessionElementsByXPath(".//tr");

            var formRowsWithData = formRows.Select(x => x).Where(x => !x.Text.Equals(String.Empty));
            
            return formRowsWithData;
        }

        private SessionElementScope GetFormRowByLabel(string label)
        {
            if (String.IsNullOrWhiteSpace(label)) throw new ArgumentNullException("label");

            var formRows = GetFormRows();
            
            SessionElementScope formRow;

            if (IsFormOrientationLandscape())
            {
                var lineLabelPrimary   = string.Format("{0}\r\n", label);
                var lineLabelSecondary = string.Format(" \r\n{0}", label);

                var potentialFormRows = new List<SessionElementScope>
                {
                    formRows.FirstOrDefault(x => x.Text.Equals(label)),
                    formRows.FirstOrDefault(x => x.Text.StartsWith(lineLabelPrimary)),
                    formRows.FirstOrDefault(x => x.Text.StartsWith(lineLabelSecondary))
                };

                formRow = potentialFormRows.FirstOrDefault(x => !ReferenceEquals(x, null));
            }
            else
            {
                formRow = formRows.FirstOrDefault(x => x.Text.StartsWith(label, StringComparison.OrdinalIgnoreCase));
            }

            if (ReferenceEquals(formRow, null))
            {
                throw new MissingHtmlException(String.Format("Could not find input for label '{0}'", label));
            }

            return formRow;
        }

        private SessionElementScope GetFormRowByContents(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var formRows = GetFormRows();

            SessionElementScope formRow = null;

            RetryPolicy.FindElement.Execute(() =>
            {
                formRow = formRows.FirstOrDefault(x => x.Text.Contains(rowContents, StringComparison.OrdinalIgnoreCase));

                if (ReferenceEquals(formRow, null))
                {
                    // Text in text type inputs in edit more are not included in .Text. Explicitly check for any inputs containing the row contents.
                    foreach (var targetformRow in formRows)
                    {
                        var inputs = targetformRow.FindAllSessionElementsByXPath(_TextTypeXpath);
                        
                        var inputsWithRowContents = inputs.Select(x => x)
                                .Where(x => x.Value.Contains(rowContents, StringComparison.OrdinalIgnoreCase));

                        if (inputsWithRowContents.Any())
                        {
                            formRow = targetformRow;
                            break;
                        }
                    }
                }

                if (ReferenceEquals(formRow, null))
                {
                    throw new MissingHtmlException(String.Format("Could not find an instance of the form row with contents '{0}'", rowContents));
                }
            });

            return formRow;
        }

        private IEnumerable<SessionElementScope> GetFormRowInputsByLabel(string label, string typeXpath)
        {
            if (String.IsNullOrWhiteSpace(label))     throw new ArgumentNullException("label");
            if (String.IsNullOrWhiteSpace(typeXpath)) throw new ArgumentNullException("typeXpath");

            IEnumerable<SessionElementScope> inputs = null;

            RetryPolicy.FindElement.Execute(() =>
            {
                var formRow = GetFormRowByLabel(label);

                inputs = formRow.FindAllSessionElementsByXPath(typeXpath);
                
                if (!inputs.Any())
                {
                    throw new MissingHtmlException(String.Format("No inputs of type {0} found for {1}.", typeXpath, label));
                }
            });

            return inputs;
        }

        private SessionElementScope GetTextBoxByLabel(string label, int inputIndex = 0)
        {
            if (String.IsNullOrWhiteSpace(label))     throw new ArgumentNullException("label");
            if (inputIndex < 0)                       throw new ArgumentOutOfRangeException("inputIndex must be greater than 0");

            var inputs = GetFormRowInputsByLabel(label, _TextTypeXpath);

            var textBoxes = inputs.Select(x => x).Where(x => x.Type.EqualsIgnoreCase(_TextType)).ToList();

            if (textBoxes.Count <= inputIndex)
            {
                throw new IndexOutOfRangeException(String.Format("There are no inputs for label {0} at index {1}", label, inputIndex));
            }

            var textBox = textBoxes[inputIndex];

            return textBox;
        }

        private SessionElementScope GetLongTextBoxByLabel(string label)
        {
            if (String.IsNullOrWhiteSpace(label)) throw new ArgumentNullException("label");

            SessionElementScope textBox = null;

            RetryPolicy.FindElement.Execute(() =>
            {
                var inputs = GetFormRowInputsByLabel(label, _LongTextTypeXpath);

                textBox = inputs.First();
            });

            return textBox;
        }

        private SessionElementScope GetPasswordTextBoxByLabel(string label)
        {
            if (String.IsNullOrWhiteSpace(label)) throw new ArgumentNullException("label");

            SessionElementScope textBox = null;

            RetryPolicy.FindElement.Execute(() =>
            {
                var inputs = GetFormRowInputsByLabel(label, _TextTypeXpath);

                textBox = inputs.First(x => x.Type.EqualsIgnoreCase(_PasswordType));
            });
            
            return textBox;
        }

        private SessionElementScope GetSelectListByLabel(string label)
        {
            if (String.IsNullOrWhiteSpace(label))          throw new ArgumentNullException("label");

            SessionElementScope fieldSelectList = null;

            RetryPolicy.FindElement.Execute(() =>
            {
                var fieldSelectLists = GetFormRowInputsByLabel(label, _SelectTypeXpath);

                // Edited forms include an additional select list, defaulted to 'Entry Error', which can be ignored.
                fieldSelectList = fieldSelectLists.First(x => !x.SelectedOption.Contains("Entry Error", StringComparison.OrdinalIgnoreCase));
            });
            
            return fieldSelectList;
        }

        private SessionElementScope GetRadioButtonListByLabel(string label)
        {
            if (String.IsNullOrWhiteSpace(label)) throw new ArgumentNullException("label");

            SessionElementScope radioButtonList = null;

            RetryPolicy.FindElement.Execute(() =>
            {
                var radioButtonLists = GetFormRowInputsByLabel(label, _RadioButtonListTypeXpath);
            
                radioButtonList = radioButtonLists.First(x => x.Id.Contains("_RadioBtnList")); 
            });
            
            return radioButtonList;
        }

        private SessionElementScope GetRadioButtonByLabel(string label, string radioButtonLabel)
        {
            if (String.IsNullOrWhiteSpace(label))            throw new ArgumentNullException("label");
            if (String.IsNullOrWhiteSpace(radioButtonLabel)) throw new ArgumentNullException("radioButtonLabel");

            SessionElementScope radioButtonSet = null;

            RetryPolicy.FindElement.Execute(() =>
            {
            var radioButtonList = GetRadioButtonListByLabel(label);

            var radioButtonSets = radioButtonList.FindAllSessionElementsByXPath(".//td");
            
                radioButtonSet = radioButtonSets.First(x => x.Text.Contains(radioButtonLabel, StringComparison.OrdinalIgnoreCase));
            });

            var radioButton = radioButtonSet.FindSessionElementByXPath(_RadioButtonTypeXpath);

            return radioButton;
        }
        
        private SessionElementScope GetCheckboxByLabel(string label)
        {
            if (String.IsNullOrWhiteSpace(label)) throw new ArgumentNullException("label");

            SessionElementScope checkbox = null;

            RetryPolicy.FindElement.Execute(() =>
            {
                var inputs = GetFormRowInputsByLabel(label, _CheckboxTypeXpath);
            
                var checkboxes = inputs.Select(x => x).Where(x => x.Type.EqualsIgnoreCase(_CheckboxType)).ToList();

                checkbox = checkboxes.First();
            });

            return checkbox;
        }
        
        private SessionElementScope GetSaveButton()
        {
            var saveButton = _Session.FindSessionElementByXPath("//input[contains(@id, '_footer_SB')]");

            return saveButton;
        }
        
        private SessionElementScope GetCancelButton()
        {
            var cancelButton = _Session.FindSessionElementByXPath("//input[contains(@id, '_footer_CB')]");

            return cancelButton;
        }

        private bool DoesNewLogLineLinkExist()
        {
            return GetNewLogLineLink().Exists(Config.ExistsOptions);
        }

        private bool DoesCompleteViewLineLinkExist()
        {
            return GetCompleteViewLink().Exists(Config.ExistsOptions);
        }

        private bool IsFormOrientationLandscape()
        {
            return DoesNewLogLineLinkExist() && !DoesCompleteViewLineLinkExist();
        }

        private FormState GetFormState()
        {
            var formAuditLink = GetFormAuditLink();

            if (ReferenceEquals(formAuditLink, null))
            {
                throw new MissingHtmlException("Could not find form audit link to determine form state.");
            }

            var icon = formAuditLink.FindAllSessionElementsByXPath(".//img").FirstOrDefault();

            if (ReferenceEquals(icon, null))
            {
                throw new MissingHtmlException("Could not find form audit link icon to determine form state.");
            }
            
            var iconSource      = icon.GetAttribute("src");

            var iconSourceSplit = iconSource.Split('/');

            var iconName        = iconSourceSplit.FirstOrDefault(x => x.Contains(".gif"));

            if (String.IsNullOrWhiteSpace(iconName))
            {
                throw new MissingHtmlException("Could not find form audit link icon name to determine form state.");
            }

            FormState formState;

            if(!FormIconToState.TryGetValue(iconName, out formState))
            {
                throw new MissingHtmlException("Form state not defined by form audit link icon.");
            }

            return formState;
        }
        
        private bool IsNewLogLineRequired()
        {
            FormState formstate = GetFormState();

            return !formstate.Equals(FormState.Blank);
        }

        private void CompleteForm(IEnumerable<RaveFormInputData> formInputData)
        {
            if (ReferenceEquals(formInputData, null)) throw new NullReferenceException("formInputData");
            
            foreach (var field in formInputData)
            {
                if (String.IsNullOrWhiteSpace(field.ControlType))
                {
                    var fieldTextBox = GetTextBoxByLabel(field.Field);
                    fieldTextBox.FillInWith(field.Value);
                    continue;
                }

                switch (field.ControlType.ToUpper())
                {
                    case "LONGTEXT":
                        {
                            var fieldTextBox = GetLongTextBoxByLabel(field.Field);
                            fieldTextBox.FillInWith(field.Value);
                            break;
                        }
                    case "DROPDOWNLIST":
                        {
                            var fieldSelectList = GetSelectListByLabel(field.Field);
                            fieldSelectList.SelectOptionAlphanumericOnly(field.Value);
                            break;
                        }
                    case "DATETIME":
                        {
                            DateTime value = field.Value.ToDate();

                            var dayTextBox = GetTextBoxByLabel(field.Field);
                            dayTextBox.FillInWith(value.Day.ToString());

                            var monthSelectList = GetSelectListByLabel(field.Field);
                            monthSelectList.SelectOptionAlphanumericOnly(value.ToString("MMM"));

                            var yearTextBox = GetTextBoxByLabel(field.Field, inputIndex: 1);
                            yearTextBox.FillInWith(value.Year.ToString());
                            break;
                        }
                    case "RADIOBUTTONVERTICAL":
                    case "RADIOBUTTON":
                        {
                            var fieldRadioButton = GetRadioButtonByLabel(field.Field, field.Value);
                            fieldRadioButton.SetCheckBoxState(true);
                            break;
                        }
                    case "USERNAME":
                        {
                            var usernameTextBox = GetTextBoxByLabel(field.Field);
                            usernameTextBox.FillInWith(field.Value);
                            break;
                        }
                    case "PASSWORD":
                        {
                            var passwordTextBox = GetPasswordTextBoxByLabel(field.Field);
                            passwordTextBox.FillInWith(field.Value);
                            break;
                        }
                    case "SEARCHLIST":
                    case "DYNAMICSEARCHLIST":
                        {
                            var fieldTextBox = GetTextBoxByLabel(field.Field);
                            fieldTextBox.FillInWith(field.Value);
                            fieldTextBox.SendKeys(Keys.Tab);
                            break;
                        }
                    case "SEARCHLISTOTHER":
                        {
                            var fieldTextBox = GetTextBoxByLabel(field.Field, inputIndex: 2);
                            fieldTextBox.FillInWith(field.Value);
                            break;
                        }
                    default:
                        {
                            throw new InvalidOperationException(
                                String.Format(
                                    "Rave Form automation for the control type, '{0}', has not yet been implemented.",
                                    field.ControlType));
                        }
                }
            }

            SaveForm();
        }

        internal void CreateFormSubmission(IEnumerable<RaveFormInputData> formInputData)
        {
            if (ReferenceEquals(formInputData, null)) throw new NullReferenceException("formInputData");

            if (IsNewLogLineRequired())
            {
                GetNewLogLineLink().Click();
            }

            CompleteForm(formInputData);
        }

        internal void UpdateForm(IEnumerable<RaveFormInputData> formInputData)
        {
            if (ReferenceEquals(formInputData, null)) throw new NullReferenceException("formInputData");

            GetFormModifyLink().Click();

            CompleteForm(formInputData);
        }

        internal void UpdateLogLine(string logLineContents, IEnumerable<RaveFormInputData> formInputData)
        {
            if (String.IsNullOrWhiteSpace(logLineContents)) throw new ArgumentNullException("logLineContents");
            if (ReferenceEquals(formInputData, null))       throw new NullReferenceException("formInputData");

            GetFormRowModifyLink(logLineContents).Click();

            UpdateForm(formInputData);
        }

        internal void UpdateLogLine(int logLineIndex, IEnumerable<RaveFormInputData> formInputData)
        {
            if (logLineIndex < 1)                     throw new ArgumentOutOfRangeException("logLineIndex cannot be less than 1");
            if (ReferenceEquals(formInputData, null)) throw new NullReferenceException("formInputData");

            GetLogLineModifyLink(logLineIndex).Click();

            UpdateForm(formInputData);
        }

        internal void CancelCurrentEdit()
        {
            GetCancelButton().Click();
        }
        

        private void SaveForm()
        {
            var saveButton = GetSaveButton();
            saveButton.Click();
        }

        internal string GetQueryComment(string fieldName, string logLineContents)
        {
            if (String.IsNullOrWhiteSpace(fieldName))       throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(logLineContents)) throw new ArgumentNullException("logLineContents");

            const int QueryCommentTextIndexOffset = 1;

            GetFormRowModifyLink(logLineContents).Click();
            
            var formRow               = GetFormRowByLabel(fieldName);
            var formRowText           = formRow.Text;
            var formRowTexts          = formRowText.Split(new string[] {"\r\n"}, StringSplitOptions.RemoveEmptyEntries).ToList();
            var fieldTextIndex        = formRowTexts.IndexOf(fieldName);
            var queryCommentTextIndex = fieldTextIndex + QueryCommentTextIndexOffset;

            if (formRowTexts.Count <= queryCommentTextIndex)
            {
                throw new MissingHtmlException(String.Format("Query comment not found for field {0} containing {1}.", fieldName, logLineContents));
            }

            var queryCommentText = formRowTexts[queryCommentTextIndex];

            return queryCommentText.Trim();
        }

        private void EnterQueryResponse(string fieldName, string queryResponse)
        {
            if (String.IsNullOrWhiteSpace(fieldName))     throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(queryResponse)) throw new ArgumentNullException("queryResponse");

            var queryResponseTextBox = GetTextBoxByLabel(fieldName);

            queryResponseTextBox.FillInWith(queryResponse);
        }

        internal void RespondToQueryComment(string fieldName, string logLineContents, string queryResponse)
        {
            if (String.IsNullOrWhiteSpace(fieldName))       throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(logLineContents)) throw new ArgumentNullException("logLineContents");
            if (String.IsNullOrWhiteSpace(queryResponse))   throw new ArgumentNullException("queryResponse");

            GetFormRowModifyLink(logLineContents).Click();

            EnterQueryResponse(fieldName, queryResponse);

            SaveForm();
        }

        internal void CancelQueryComment(string fieldName, string logLineContents, string queryResponse=null)
        {
            if (String.IsNullOrWhiteSpace(fieldName))       throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(logLineContents)) throw new ArgumentNullException("logLineContents");

            GetFormRowModifyLink(logLineContents).Click();

            if (!String.IsNullOrWhiteSpace(queryResponse))
            {
                EnterQueryResponse(fieldName, queryResponse);
            }

            var cancelQueryCheckbox = GetCheckboxByLabel(fieldName);

            cancelQueryCheckbox.SetCheckBoxState(true);

            SaveForm();
        }
        
        internal void ViewAuditLog(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            GetFormRowAuditLink(rowContents).Click();
        }
        
        internal void LockForm(bool freezeForm, bool lockForm)
        {
            var formFreezeCheckbox = GetFormFreezeCheckbox();
            formFreezeCheckbox.SetCheckBoxState(freezeForm);

            var formLockCheckbox   = GetFormLockCheckbox();
            formLockCheckbox  .SetCheckBoxState(lockForm);

            SaveForm();
        }

        internal void LockRow(string rowContents, bool freezeForm, bool lockForm)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");
            
            var rowFreezeCheckbox = GetFormRowCheckbox(rowContents, _FreezeIdSuffix);
            rowFreezeCheckbox.SetCheckBoxState(freezeForm);

            var rowLockCheckbox = GetFormRowCheckbox(rowContents, _LockIdSuffix);
            rowLockCheckbox.SetCheckBoxState(lockForm);

            SaveForm();
        }

        internal IEnumerable<TermPathRow> GetCodingDecision(string rowContents, string verbatimTerm)
        {
            if (String.IsNullOrWhiteSpace(rowContents))  throw new ArgumentNullException("rowContents");
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            var termPath = new List<TermPathRow>();

            GetFormRowModifyLink(rowContents).Click();

            var formRow          = GetFormRowByContents(verbatimTerm);

            var formRowLines     = formRow.FindAllSessionElementsByXPath(".//tr");

            var formRowLinesText = formRowLines.Select(x => x.Text).Where(x => !String.IsNullOrWhiteSpace(x)).ToList();

            foreach (var formLineText in formRowLinesText)
            {
                var formLineTextSplit = formLineText.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries).ToList();

                if (formLineTextSplit.Count == _TermPathLevelElements)
                {
                    var termPathLevel = new TermPathRow
                    {
                        Level    = formLineTextSplit[_TermPathLevelIndex],
                        Code     = formLineTextSplit[_TermPathCodeIndex],
                        TermPath = formLineTextSplit[_TermPathTermIndex]
                    };

                    termPath.Add(termPathLevel);
                }
            }

            return termPath;
        }

        internal TermPathRow GetCodingDecisionVerbatim(string fieldName, string verbatimTerm)
        {
            if (String.IsNullOrWhiteSpace(fieldName))    throw new ArgumentNullException("fieldName");
            if (String.IsNullOrWhiteSpace(verbatimTerm)) throw new ArgumentNullException("verbatimTerm");

            var termPath            = new List<TermPathRow>();

            GetFormRowModifyLink(verbatimTerm).Click();

            var formRow             = GetFormRowByContents(verbatimTerm);

            var formRowLines        = formRow.FindAllSessionElementsByXPath(".//tr");

            var formRowLastLineText = formRowLines.Select(x => x.Text).Where(x => !String.IsNullOrWhiteSpace(x)).Last();

            var termPathLevel       = new TermPathRow();

            var formLineTextSplit   = formRowLastLineText.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries).ToList();
            foreach (var splitRow in formLineTextSplit)
            {
                if (formLineTextSplit.Count == _TermPathLevelElements)
                {
                    termPathLevel = new TermPathRow
                    {
                        Level     = formLineTextSplit[_TermPathLevelIndex],
                        Code      = formLineTextSplit[_TermPathCodeIndex],
                        TermPath  = formLineTextSplit[_TermPathTermIndex]
                    };
                }
                else if (splitRow.RemoveAllWhiteSpace() != fieldName.RemoveAllWhiteSpace())
                {
                    termPathLevel = new TermPathRow
                    {
                        TermPath  = formLineTextSplit[_TermPathLevelIndex]
                    };
                }
            }            
            return termPathLevel;
        }
        
        internal void InactivateLogLine(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            GetInactivateLogLineLink().Click();

            _Session.WaitUntilElementExists(GetInactivateLogLineSelectList);

            var logLineIndexElement = GetLogLinesGrid().FindTableCell(rowContents, "#");
            
            GetInactivateLogLineSelectList().SelectOptionAlphanumericOnly(logLineIndexElement.Text);

            GetInactivateLogLineButton().Click();
        }

        internal void ReactivateLogLine(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            GetReactivateLogLineLink().Click();

            _Session.WaitUntilElementExists(GetReactivateLogLineSelectList);

            var logLineIndexElement = GetLogLinesGrid().FindTableCell(rowContents, "#");

            GetReactivateLogLineSelectList().SelectOptionAlphanumericOnly(logLineIndexElement.Text);

            GetReactivateLogLineButton().Click();
        }

        internal void InactivateForm()
        {
            var formActivationLinkText = GetFormActivationLink().Text;

            if (formActivationLinkText.Equals(_ActiveFormText))
            {
                ToggleFormActiveState();
            }
        }

        internal void ReactivateForm()
        {
            var formActivationLinkText = GetFormActivationLink().Text;

            if (formActivationLinkText.Equals(_InactiveFormText))
            {
                ToggleFormActiveState();
            }
        }

        private void ToggleFormActiveState()
        {
            GetFormActivationLink().Click();

            _Session.WaitUntilElementExists(GetFormActivationConfirmationCheckbox);

            GetFormActivationConfirmationCheckbox().Click();

            SaveForm();
        }
        
        internal void MarkRowWithQuery(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            StartRowMarking(rowContents, _MarkingTypeQuery);
            
            SaveForm();
        }

        internal void MarkRowWithSticky(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            StartRowMarking(rowContents, _MarkingTypeSticky);

            SaveForm();
        }

        internal void MarkRowWithProtocolDeviation(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            StartRowMarking(rowContents, _MarkingTypeProtocolDeviation);

            var markingProtocolTypeSelectList = GetFormRowSelectList(rowContents, selectListIndex: _MarkingSelectListProtocolTypeIndex);
            var selectListOptions             = markingProtocolTypeSelectList.GetSelectListOptions();
            var lastOption                    = selectListOptions.LastOrDefault();

            if (String.IsNullOrWhiteSpace(lastOption))
            {
                throw new MissingHtmlException("No selectable options available");
            }
            markingProtocolTypeSelectList.SelectOptionAlphanumericOnly(lastOption);

            var markingProtocolReasonSelectList = GetFormRowSelectList(rowContents, selectListIndex: _MarkingSelectListProtocolReasonIndex);
            selectListOptions                   = markingProtocolReasonSelectList.GetSelectListOptions();
            lastOption                          = selectListOptions.LastOrDefault();

            if (String.IsNullOrWhiteSpace(lastOption))
            {
                throw new MissingHtmlException("No selectable options available");
            }
            markingProtocolReasonSelectList.SelectOptionAlphanumericOnly(lastOption);
            
            SaveForm();
        }

        private void StartRowMarking(string rowContents, string markingType)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");
            if (String.IsNullOrWhiteSpace(markingType)) throw new ArgumentNullException("markingType");

            GetFormRowModifyLink(rowContents).Click();

            GetFormRowMarkLink(rowContents).Click();

            var markingTypeSelectList = GetFormRowSelectList(rowContents, selectListIndex:_MarkingSelectListTypeIndex);

            markingTypeSelectList.SelectOptionAlphanumericOnly(markingType);

            var markingContentTextBox = GetMarkingContentTextBox(rowContents);

            markingContentTextBox.FillInWith(BrowserUtility.RandomString());
        }

        private SessionElementScope GetMarkingContentTextBox(string rowContents)
        {
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var markingContentTextBoxes = GetFormRowInputsByContents(rowContents, _LongTextTypeXpath);

            var markingContentTextBox = markingContentTextBoxes.First();

            return markingContentTextBox;
        }
    }
}
