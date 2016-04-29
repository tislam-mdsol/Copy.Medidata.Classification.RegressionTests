﻿//@author:smalik
using System;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.Models;
using TechTalk.SpecFlow;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public sealed class CoderSetupSteps
    {
        private readonly CoderDeclarativeBrowser _Browser;
        private readonly StepContext _StepContext;

        public CoderSetupSteps(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null)) throw new NullReferenceException("Browser");

            _StepContext = stepContext;
            _Browser     = _StepContext.Browser;
        }

        [Given("a new segment to be enrolled in Coder")]
        public void aNewSegmentToBeEnrolledInCoder()
        {
            _Browser.EnrollSegment(_StepContext.NewGeneratedSegment);
        }

        [When(@"a dictionary ""(.*)"" is rolled out")]
        public void aDictionaryIsRolledOut(String dictionaryName)
        {
            if (ReferenceEquals(dictionaryName, null)) throw new ArgumentNullException("dictionaryName");

            _Browser.RolloutDictionary(_StepContext.NewGeneratedSegment, dictionaryName);
        }

        [Then(@"Verify dictionary has rolled out")]
        public void ThenVerifyDictionaryHasRolledOut()
        {
            _Browser.VerifyRollOutDictionaryResult(_StepContext.User);
        }

        [Given(@"a new Coder User")]
        public void GivenANewCoderUser()
        {
            _Browser.LoadiMedidataCoderAppSegment(_StepContext.Segment);
        }

    }
}
