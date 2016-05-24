using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.ExtensionMethods;

namespace Coder.DeclarativeBrowser.Models.ETEModels
{
    public class MainReportTableModel
    {
        public string ReportType { get; set; }

        public string Description { get; set; }

        public string InformationStudyText { get; set; }

        public string InformationDictionaryText { get; set; }

        public string LastRun { get; set; }

        public string ReportStatus { get; set; }

        public bool Equals(MainReportTableModel expectedText)
        {
            if (ReferenceEquals(expectedText, null)) throw new ArgumentNullException("expectedText");

            var result = ReportType               .IsNullOrEqualsIfRequired(expectedText.ReportType)
                      && Description              .IsNullOrEqualsIfRequired(expectedText.Description)
                      && InformationStudyText     .IsNullOrEqualsIfRequired(expectedText.InformationStudyText)
                      && InformationDictionaryText.IsNullOrEqualsIfRequired(expectedText.InformationDictionaryText)
                      && LastRun                  .IsNullOrEqualsIfRequired(expectedText.LastRun);

            return result;
        }

    }
}
