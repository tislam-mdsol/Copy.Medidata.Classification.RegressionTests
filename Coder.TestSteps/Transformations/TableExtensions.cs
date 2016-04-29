using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using TechTalk.SpecFlow;

namespace Coder.TestSteps.Transformations
{
    internal static class TableExtensions
    {
        internal static Table TransformFeatureTableStrings(this Table source, StepContext stepContext, char? quoteToTrim = null)
        {
            if (ReferenceEquals(stepContext, null)) { throw new ArgumentNullException("stepContext");}

            var target = new Table(source.Header.ToArray());

            foreach (var row in source.Rows)
            {
                var modifiedRow = TransformFeatureRowStrings(row, stepContext, quoteToTrim);
                target.AddRow(modifiedRow);
            }

            return target;
        }

        private static string[] TransformFeatureRowStrings(TableRow row, StepContext stepContext, char? quoteToTrim = null)
        {
            if (ReferenceEquals(row, null))         throw new ArgumentNullException("row"); 
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext"); 

            var transformedValues = row.Values.ToArray();

            for (var i = 0; i < transformedValues.Count(); i++)
            {
                var valueToTransform = transformedValues[i];
                if (valueToTransform.StartsWith("<") && valueToTransform.EndsWith(">"))
                {
                    transformedValues[i] = StepArgumentTransformations.TransformFeatureString(valueToTransform, stepContext);
                }

                if (!ReferenceEquals(quoteToTrim, null))
                {
                    transformedValues[i] = transformedValues[i].TrimStart(quoteToTrim.Value).TrimEnd(quoteToTrim.Value);
                }
            }
            return transformedValues;
        }

        internal static IDictionary<string, string> ToDictionary(this IEnumerable<TableRow> source, string keyHeader, string valueHeader)
        {
            if (ReferenceEquals(source, null))          throw new ArgumentNullException("source");
            if (String.IsNullOrWhiteSpace(keyHeader))   throw new ArgumentNullException("keyHeader");
            if (String.IsNullOrWhiteSpace(valueHeader)) throw new ArgumentNullException("valueHeader");

            var sourceArray = source.ToArray();

            if (!sourceArray[0].ContainsKey(keyHeader))   throw new ArgumentException("keyHeader not in source table");
            if (!sourceArray[0].ContainsKey(valueHeader)) throw new ArgumentException("valueHeader not in source table");

            var featureDictionary = sourceArray.ToDictionary(row => row[keyHeader], row => row[valueHeader]);

            return featureDictionary;
        }
    }
}
