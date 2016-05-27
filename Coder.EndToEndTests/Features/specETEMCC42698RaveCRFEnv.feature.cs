﻿// ------------------------------------------------------------------------------
//  <auto-generated>
//      This code was generated by SpecFlow (http://www.specflow.org/).
//      SpecFlow Version:1.9.0.77
//      SpecFlow Generator Version:1.9.0.0
//      Runtime Version:4.0.30319.42000
// 
//      Changes to this file may cause incorrect behavior and will be lost if
//      the code is regenerated.
//  </auto-generated>
// ------------------------------------------------------------------------------
#region Designer generated code
#pragma warning disable
namespace Coder.EndToEndTests.Features
{
    using TechTalk.SpecFlow;
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("TechTalk.SpecFlow", "1.9.0.77")]
    [System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [NUnit.Framework.TestFixtureAttribute()]
    [NUnit.Framework.DescriptionAttribute("Handles the CRF versioning for different project environment scenarios, such as a" +
        " user should not be able to push a CRF version that contains Coder settings to a" +
        " study environment that is not linked to iMedidata.")]
    [NUnit.Framework.CategoryAttribute("specETEMCC42698RaveCRFEnv.feature")]
    [NUnit.Framework.CategoryAttribute("EndToEnd")]
    public partial class HandlesTheCRFVersioningForDifferentProjectEnvironmentScenariosSuchAsAUserShouldNotBeAbleToPushACRFVersionThatContainsCoderSettingsToAStudyEnvironmentThatIsNotLinkedToIMedidata_Feature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specETEMCC42698RaveCRFEnv.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Handles the CRF versioning for different project environment scenarios, such as a" +
                    " user should not be able to push a CRF version that contains Coder settings to a" +
                    " study environment that is not linked to iMedidata.", "", ProgrammingLanguage.CSharp, new string[] {
                        "specETEMCC42698RaveCRFEnv.feature",
                        "EndToEnd"});
            testRunner.OnFeatureStart(featureInfo);
        }
        
        [NUnit.Framework.TestFixtureTearDownAttribute()]
        public virtual void FeatureTearDown()
        {
            testRunner.OnFeatureEnd();
            testRunner = null;
        }
        
        [NUnit.Framework.SetUpAttribute()]
        public virtual void TestInitialize()
        {
        }
        
        [NUnit.Framework.TearDownAttribute()]
        public virtual void ScenarioTearDown()
        {
            testRunner.OnScenarioEnd();
        }
        
        public virtual void ScenarioSetup(TechTalk.SpecFlow.ScenarioInfo scenarioInfo)
        {
            testRunner.OnScenarioStart(scenarioInfo);
        }
        
        public virtual void ScenarioCleanup()
        {
            testRunner.CollectScenarioErrors();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("When pushing a CRF version that contains Coder settings and environment selected " +
            "is not linked to iMedidata, produce an error message.")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("ETE_RaveCoderCore")]
        [NUnit.Framework.CategoryAttribute("PBMCC42698_001")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
        public virtual void WhenPushingACRFVersionThatContainsCoderSettingsAndEnvironmentSelectedIsNotLinkedToIMedidataProduceAnErrorMessage_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("When pushing a CRF version that contains Coder settings and environment selected " +
                    "is not linked to iMedidata, produce an error message.", new string[] {
                        "VAL",
                        "ETE_RaveCoderCore",
                        "PBMCC42698_001",
                        "Release2016.1.0",
                        "EndToEndDynamicSegment"});
#line 12
this.ScenarioSetup(scenarioInfo);
#line 14
    testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 12.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 15
    testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "Coding Level",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval"});
            table1.AddRow(new string[] {
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "true"});
#line 16
 testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 19
 testRunner.When("a Rave study environment \"UAT_ENV\" is created for project \"<StudyName>\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 20
 testRunner.And("a Rave Draft is published and has pushed disabled using draft \"<DraftName>\" for P" +
                    "roject \"<StudyName>\" to environment \"UAT_ENV\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 21
 testRunner.Then("pushing a CRF should be disabled with the following failed message \"Push disabled" +
                    ". CRF Version contains coding dictionary linked to Coder, but study/environment " +
                    "not linked to iMedidata. Please link study/environment with iMedidata.\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("When pushing a CRF version that contains Coder settings and environment selected " +
            "is linked to iMedidata, allow push to complete")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("ETE_RaveCoderCore")]
        [NUnit.Framework.CategoryAttribute("PBMCC42698_002")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
        public virtual void WhenPushingACRFVersionThatContainsCoderSettingsAndEnvironmentSelectedIsLinkedToIMedidataAllowPushToComplete()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("When pushing a CRF version that contains Coder settings and environment selected " +
                    "is linked to iMedidata, allow push to complete", new string[] {
                        "VAL",
                        "ETE_RaveCoderCore",
                        "PBMCC42698_002",
                        "Release2016.1.0",
                        "EndToEndDynamicSegment"});
#line 29
this.ScenarioSetup(scenarioInfo);
#line 31
    testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 12.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 32
    testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "Coding Level",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval"});
            table2.AddRow(new string[] {
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "true"});
#line 33
 testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table2, "And ");
#line 36
    testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"UAT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 37
    testRunner.Then("CRF was published and pushed with the following message \"successfully pushed\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
