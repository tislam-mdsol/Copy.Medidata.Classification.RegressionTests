﻿using System;
using System.Linq;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.GridModels;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Assist;
using Coder.DeclarativeBrowser.ExtensionMethods.Assertions;
﻿using Coder.TestSteps;
﻿using Coder.TestSteps.Transformations;

namespace Coder.RegressionTests.StepDefinitions
{
    [Binding]
    public class TaskPageQueryHistorySteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext _StepContext;

        public TaskPageQueryHistorySteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser = _StepContext.Browser;
        }

        [Then(@"the query history contains the following information")]
        public void ThenTheQueryHistoryContainsTheFollowingInformation(Table table)
        {
            if (ReferenceEquals(table, null)) { throw new ArgumentNullException("table"); }

            var featureData = table.TransformFeatureTableStrings(_StepContext).CreateSet<QueryHistoryDetail>().ToArray();

            _Browser.AssertQueryHistoryHasTheInformationForTask(featureData, Config.TimeStampHoursDiff);
        }
    }
}
