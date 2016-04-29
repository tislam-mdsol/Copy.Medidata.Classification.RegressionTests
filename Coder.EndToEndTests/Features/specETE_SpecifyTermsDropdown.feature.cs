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
    [NUnit.Framework.DescriptionAttribute("Verify using the Other Specify for drop-downs and search-lists is supported and t" +
        "he around trip integration works successfully.")]
    [NUnit.Framework.CategoryAttribute("EndToEndStaticSegment")]
    public partial class VerifyUsingTheOtherSpecifyForDrop_DownsAndSearch_ListsIsSupportedAndTheAroundTripIntegrationWorksSuccessfully_Feature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specETE_SpecifyTermsDropdown.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Verify using the Other Specify for drop-downs and search-lists is supported and t" +
                    "he around trip integration works successfully.", "", ProgrammingLanguage.CSharp, new string[] {
                        "EndToEndStaticSegment"});
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
        [NUnit.Framework.DescriptionAttribute("A coding decision will be accepted by EDC for a verbatim that has data submitted " +
            "via the Other Specify dropdown option on the supplemental field")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("PBMCC40159_001b")]
        [NUnit.Framework.CategoryAttribute("ReleaseRave2013.2.0")]
        [NUnit.Framework.CategoryAttribute("DTMCC68955")]
        public virtual void ACodingDecisionWillBeAcceptedByEDCForAVerbatimThatHasDataSubmittedViaTheOtherSpecifyDropdownOptionOnTheSupplementalField()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A coding decision will be accepted by EDC for a verbatim that has data submitted " +
                    "via the Other Specify dropdown option on the supplemental field", new string[] {
                        "DFT",
                        "PBMCC40159_001b",
                        "ReleaseRave2013.2.0",
                        "DTMCC68955"});
#line 12
this.ScenarioSetup(scenarioInfo);
#line 14
 testRunner.Given("a Rave project registration with dictionary \"WhoDrugDDEB2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 15
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "CodingLevel",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table1.AddRow(new string[] {
                        "ETE17",
                        "Coding Field",
                        "<Dictionary>",
                        "<Locale>",
                        "PRODUCTSYNONYM",
                        "1",
                        "true",
                        "true",
                        "Specify Dropdown"});
#line 16
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 19
 testRunner.When("a Rave Draft is published and pushed using draft \"<Draft>\" for Project \"<SourceSy" +
                    "stemStudyName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 20
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table2.AddRow(new string[] {
                        "Coding Field",
                        "child advil cold extreme",
                        "LongText"});
            table2.AddRow(new string[] {
                        "Log Dropdown Supplemental Field A",
                        "Other Option",
                        "DropDownList"});
            table2.AddRow(new string[] {
                        "Log Dropdown Supplemental Field A",
                        "terrible head pain",
                        ""});
#line 21
 testRunner.And("adding a new verbatim term to form \"ETE17\"", ((string)(null)), table2, "And ");
#line 26
 testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Term",
                        "Value"});
            table3.AddRow(new string[] {
                        "Log Dropdown Supplemental Field A",
                        "terrible head pain"});
#line 27
 testRunner.Then("the \"child advil cold extreme\" task has the following supplemental information", ((string)(null)), table3, "Then ");
#line 30
 testRunner.When("task \"child advil cold extreme\" is coded to term \"CHILDRENS ADVIL COLD\" at search" +
                    " level \"Preferred Name\" with code \"010502 01 015 9\" at level \"PN\" and a synonym " +
                    "is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 31
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table4.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "Nervous system disorders"});
            table4.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "Headaches"});
            table4.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "Headaches NEC"});
            table4.AddRow(new string[] {
                        "PT",
                        "10019211",
                        "Headache"});
            table4.AddRow(new string[] {
                        "LLT",
                        "10019198",
                        "Head pain"});
#line 33
 testRunner.Then("the coding decision for verbatim \"child advil cold extreme\" on form \"ETE17\" for f" +
                    "ield \"Coding Field\" contains the following data", ((string)(null)), table4, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A coding decision will be accepted by EDC for a verbatim that has data submitted " +
            "via the Other Specify dropdown option")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("PBMCC40159_001d")]
        [NUnit.Framework.CategoryAttribute("ReleaseRave2013.2.0")]
        [NUnit.Framework.CategoryAttribute("DTMCC68955")]
        public virtual void ACodingDecisionWillBeAcceptedByEDCForAVerbatimThatHasDataSubmittedViaTheOtherSpecifyDropdownOption()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A coding decision will be accepted by EDC for a verbatim that has data submitted " +
                    "via the Other Specify dropdown option", new string[] {
                        "DFT",
                        "PBMCC40159_001d",
                        "ReleaseRave2013.2.0",
                        "DTMCC68955"});
#line 46
this.ScenarioSetup(scenarioInfo);
#line 47
 testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 11.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 48
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "CodingLevel",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval"});
            table5.AddRow(new string[] {
                        "ETE17",
                        "Log Dropdown Supplemental Field A",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "true"});
#line 49
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table5, "And ");
#line 52
 testRunner.When("a Rave Draft is published and pushed using draft \"<Draft>\" for Project \"<SourceSy" +
                    "stemStudyName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 53
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table6.AddRow(new string[] {
                        "Log Dropdown Supplemental Field A",
                        "Other Option",
                        "DropDownList"});
            table6.AddRow(new string[] {
                        "Log Dropdown Supplemental Field A",
                        "terrible head pain",
                        ""});
#line 54
 testRunner.And("adding a new verbatim term to form \"ETE17\"", ((string)(null)), table6, "And ");
#line 58
  testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 59
 testRunner.When("task \"terrible head pain\" is coded to term \"headache\" at search level \"Lower Leve" +
                    "l Term\" with code \"10019211\" at level \"LLT\" and a synonym is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 60
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table7.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "Nervous system disorders"});
            table7.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "Headaches"});
            table7.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "Headaches NEC"});
            table7.AddRow(new string[] {
                        "PT",
                        "10019211",
                        "Headache"});
            table7.AddRow(new string[] {
                        "LLT",
                        "10019198",
                        "Head pain"});
#line 62
 testRunner.Then("the coding decision for verbatim \"terrible head pain\" on form \"ETE17\" for field \"" +
                    "Log Dropdown Supplemental Field A\" contains the following data", ((string)(null)), table7, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
