//@author:smalik
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.ExtensionMethods;

namespace Coder.DeclarativeBrowser.Models.ETEModels
{
    public class ReportDataModel
    {
        public string Column { get; set; }
        public string Value  { get; set; }

        public bool Equals(ReportDataModel expected)
        {
            if (ReferenceEquals(expected, null)) throw new ArgumentNullException("expected");

            var result = Column.IsNullOrEqualsIfRequired(expected.Column)
                      && Value .IsNullOrEqualsIfRequired(expected.Value);

            return result;
        }
    }
}
