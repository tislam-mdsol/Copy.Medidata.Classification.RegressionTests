using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models;
using FluentAssertions;
using Newtonsoft.Json;
using TechTalk.SpecFlow;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding] 
    public sealed class MainReportSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext             _StepContext;

        public MainReportSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser     = _StepContext.Browser;
        }

        [When(@"a new report type ""(.*)"" is created")]
        public void ANewReportTypeIsCreated(string reportType)
        {
            if (String.IsNullOrWhiteSpace(reportType)) throw new ArgumentNullException(reportType);

            _Browser.CreateMainReportForType(reportType);
        }

    }
}
