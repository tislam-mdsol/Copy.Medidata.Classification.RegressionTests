//@author:smalik
using Coder.DeclarativeBrowser.ExtensionMethods;
using System;
using Coypu;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.Models.ETEModels;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveClinicalViewSettingsCodingSettingsPage
    {   
        private readonly BrowserSession _Browser;
        private const string _TextTypeXpath = ".//input";

        private const int _TermSuffix       = 0;
        private const int _TermSASSuffix    = 1;
        private const int _TermLength       = 2;
        private const int _CodeSuffix       = 3;
        private const int _CodeSASSuffix    = 4;
        private const int _CodeLength       = 5;

        internal RaveClinicalViewSettingsCodingSettingsPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

       private SessionElementScope GetContentColumnsGrid()
        {
            var contentsGrid = _Browser.FindSessionElementById("_ctl0_Content_ColumnGrid");

            return contentsGrid;
        }

       private SessionElementScope GetDictionaryDDL()
       {
           var dictionaryDDL = _Browser.FindSessionElementById("_ctl0_Content_DdlDictionary");

           return dictionaryDDL;
       }

       private IList<SessionElementScope> GetAllTextBoxesByRow(RaveCodingSettingsModel modelRow)
       {
           if (ReferenceEquals(modelRow, null)) throw new NullReferenceException("modelRow");

           var contentGrid = GetContentColumnsGrid();
           var targetRow = contentGrid.FindTableRow(modelRow.Column);

           IEnumerable<SessionElementScope> inputs = null;

           RetryPolicy.FindElement.Execute(() =>
           {
               inputs = targetRow.FindAllSessionElementsByXPath(_TextTypeXpath);

               if (!inputs.Any())
               {
                   throw new MissingHtmlException(String.Format("No inputs of type {0} found for {1}.", _TextTypeXpath, modelRow.Column));
               }
           });

           var textBoxes = inputs.Select(x => x).Where(x => x.Type.EqualsIgnoreCase("Text")).ToList();

           if (!textBoxes.Any())
           {
               throw new MissingHtmlException(String.Format("No textBoxes found for {0}.", modelRow.Column));
           }

           return textBoxes;
       }

       private void ChooseDictionary(string dictionaryName)
       {
          
           string dictionaryToSelect = dictionaryName + " Version:Coder";

           GetDictionaryDDL().SelectOption(dictionaryToSelect);
       }

        internal void CreateCodingSettingSubmission(string dictionary, IEnumerable<RaveCodingSettingsModel> settingsInputData)
        {
            if (String.IsNullOrWhiteSpace(dictionary))    throw new ArgumentNullException("dictionary");
            if (ReferenceEquals(settingsInputData, null)) throw new NullReferenceException("formInputData");

            ChooseDictionary(dictionary);

            foreach(var row in settingsInputData)
            {
               var allTextBoxes         = GetAllTextBoxesByRow(row);

               var termSuffixTextBox    = allTextBoxes[_TermSuffix];
               var termSASSuffixTextBox = allTextBoxes[_TermSASSuffix];
               var termLengthTextBox    = allTextBoxes[_TermLength];
               var codeSuffixTextBox    = allTextBoxes[_CodeSuffix];
               var codeSASSuffixTextBox = allTextBoxes[_CodeSASSuffix];
               var codeLengthTextBox    = allTextBoxes[_CodeLength];

                termSuffixTextBox   .FillInWith(row.TermSuffix);
                termSASSuffixTextBox.FillInWith(row.TermSASSuffix);
                termLengthTextBox   .FillInWith(row.TermLength);
                codeSuffixTextBox   .FillInWith(row.CodeSuffix);
                codeSASSuffixTextBox.FillInWith(row.CodeSASSuffix);
                codeLengthTextBox   .FillInWith(row.CodeLength);
            }
        }

    }
}
