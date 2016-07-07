using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.Models.ETEModels
{
    public class RaveCoderGlobalConfiguration
    {
        public string ReviewMarkingGroup      { get; set; }

        public bool IsRequiresResponse        { get; set; }

        public string GlobalConfigWorksheetName = "Coder Configuration";
    }
}
