using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.ExtensionMethods;

namespace Coder.DeclarativeBrowser.Models
{
    public class IMedidataStudy
    {
        public string StudyGroup            { get; set; }
        public string Name                  { get; set; }
        public string ProtocolNumber        { get; set; }
        public string ObjectID              { get; set; }
        public StudyEnvironment Environment { get; set; }

        public IMedidataStudy Merge(IMedidataStudy newValues)
        {
            if (ReferenceEquals(newValues,null)) throw new ArgumentNullException("newValues");

            var mergedStudy = new IMedidataStudy
            {
                Name           = this.Name.ReplaceWith(newValues.Name),
                ProtocolNumber = this.ProtocolNumber.ReplaceWith(newValues.ProtocolNumber),
                StudyGroup     = this.StudyGroup
            };

            if (!Equals(newValues.Environment, StudyEnvironment.None))
                mergedStudy.Environment = newValues.Environment;

            return mergedStudy;
        }
    }

    public enum StudyEnvironment { None, Other, Development, Training, UserAcceptanceTesting, Production }
}
