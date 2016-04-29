using Coder.DeclarativeBrowser.Models;
using System;
using Coder.DeclarativeBrowser.ExtensionMethods;
using TechTalk.SpecFlow;

namespace Coder.TestSteps.Transformations
{
    [Binding]
    public class StepArgumentTransformations
    {
        internal static string TransformFeatureString(string input, StepContext stepContext)
        {
            if (String.IsNullOrWhiteSpace(input))   throw new ArgumentNullException("input");
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");

            if (input.StartsWith("<") && input.EndsWith(">"))
            {
                var output = stepContext.GetProperty(input.TrimStart('<').TrimEnd('>'));
                return output;
            }

            return input;
        }
    }
}
