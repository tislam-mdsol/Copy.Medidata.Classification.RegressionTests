using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;

namespace Coder.TestSteps.Transformations
{
    [Binding]
    public class TableTransformer
    {
        private readonly StepContext                _StepContext;

        public TableTransformer(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext"); 

            _StepContext    = stepContext;
        }

        [StepArgumentTransformation]
        public List<dynamic> TransformFeatureTable(Table table)
        {
            if (ReferenceEquals(table, null))               throw new ArgumentNullException("table"); 

            var featureData = table.CreateDynamicSet().ToList();  

            foreach (var row in featureData)
            {
                var rowDictionary = row as IDictionary<string, object>;

                if (ReferenceEquals(rowDictionary, null))  throw new NullReferenceException("rowDictionary"); 

                var featureDataToTransform = GetFeatureTableTransformationParameters(row);

                foreach (var pair in featureDataToTransform)
                {
                    rowDictionary[pair.Key] = pair.Value;
                }
            }

            return featureData;
        }

        private IEnumerable<KeyValuePair<string, object>> GetFeatureTableTransformationParameters(ExpandoObject row)
        {
            if (ReferenceEquals(row, null))                 throw new ArgumentNullException("row"); 

            var dataToTransform = (
                from column in row
                where column.Value.ToString().StartsWith("<") && column.Value.ToString().EndsWith(">")
                let columnValue = column.Value.ToString().TrimStart('<').TrimEnd('>')
                select new KeyValuePair<string, object>(column.Key, _StepContext.GetProperty(columnValue)))
                .ToList();

            return dataToTransform;
        }
    }
}
