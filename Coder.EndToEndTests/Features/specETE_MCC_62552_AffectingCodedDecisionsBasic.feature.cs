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
    [NUnit.Framework.DescriptionAttribute("Verify coded decisions are affected properly with markings and other EDC function" +
        "ality for Coder supplemental and component values. Only a change in supplement, " +
        "component or the coding term will cause the coding decision to break.")]
    public partial class VerifyCodedDecisionsAreAffectedProperlyWithMarkingsAndOtherEDCFunctionalityForCoderSupplementalAndComponentValues_OnlyAChangeInSupplementComponentOrTheCodingTermWillCauseTheCodingDecisionToBreak_Feature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specETE_MCC_62552_AffectingCodedDecisionsBasic.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Verify coded decisions are affected properly with markings and other EDC function" +
                    "ality for Coder supplemental and component values. Only a change in supplement, " +
                    "component or the coding term will cause the coding decision to break.", "", ProgrammingLanguage.CSharp, ((string[])(null)));
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
        [NUnit.Framework.DescriptionAttribute("A coding decision remains on the verbatim when a query is opened against a verbat" +
            "im field.")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("DebugEndToEndDynamicSegment")]
        public virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainstAVerbatimField_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A coding decision remains on the verbatim when a query is opened against a verbat" +
                    "im field.", new string[] {
                        "DFT",
                        "DebugEndToEndDynamicSegment"});
#line 6
this.ScenarioSetup(scenarioInfo);
#line 7
 testRunner.Given("a Rave project registration with dictionary \"WhoDrug-DDE-B2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 8
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
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table1.AddRow(new string[] {
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "<Locale>",
                        "TN",
                        "1",
                        "true",
                        "true",
                        "LogSuppField2"});
#line 9
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 12
 testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 13
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType",
                        "Control Value"});
            table2.AddRow(new string[] {
                        "Coding Field",
                        "Drug Verbatim 1",
                        "LongText",
                        ""});
#line 14
 testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table2, "And ");
#line 18
 testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 19
 testRunner.When("task \"Drug Verbatim 1\" is coded to term \"BAYER CHILDREN\'S COLD\" at search level \"" +
                    "Preferred Name\" with code \"005581 01 001\" at level \"PN\" and a synonym is created" +
                    "", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "ATC",
                        "N",
                        "NERVOUS SYSTEM"});
            table3.AddRow(new string[] {
                        "ATC",
                        "N02",
                        "ANALGESICS"});
            table3.AddRow(new string[] {
                        "ATC",
                        "N02B",
                        "OTHER ANALGESICS AND ANTIPYRETICS"});
            table3.AddRow(new string[] {
                        "ATC",
                        "N02BA",
                        "SALICYLIC ACID AND DERIVATIVES"});
            table3.AddRow(new string[] {
                        "PRODUCT",
                        "005581 01 001",
                        "BAYER CHILDREN\'S COLD"});
#line 20
 testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETE2\" for field \"Codi" +
                    "ng Field\" contains the following data", ((string)(null)), table3, "Then ");
#line 26
 testRunner.When("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 27
 testRunner.And("row on form \"ETE2\" containing \"Drug Verbatim 1\" is marked with a query", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "ATC",
                        "N",
                        "NERVOUS SYSTEM"});
            table4.AddRow(new string[] {
                        "ATC",
                        "N02",
                        "ANALGESICS"});
            table4.AddRow(new string[] {
                        "ATC",
                        "N02B",
                        "OTHER ANALGESICS AND ANTIPYRETICS"});
            table4.AddRow(new string[] {
                        "ATC",
                        "N02BA",
                        "SALICYLIC ACID AND DERIVATIVES"});
            table4.AddRow(new string[] {
                        "PRODUCT",
                        "005581 01 001",
                        "BAYER CHILDREN\'S COLD"});
#line 29
 testRunner.Then("the coding decision for verbatim \"child advil cold extreme\" on form \"ETE2\" for fi" +
                    "eld \"Coding Field\" contains the following data", ((string)(null)), table4, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A coding decision remains on the verbatim when a query is opened against a supplm" +
            "ental field.")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
        public virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainstASupplmentalField_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A coding decision remains on the verbatim when a query is opened against a supplm" +
                    "ental field.", new string[] {
                        "DFT",
                        "EndToEndDynamicSegment"});
#line 39
this.ScenarioSetup(scenarioInfo);
#line 40
 testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 18.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 41
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "Coding Level",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table5.AddRow(new string[] {
                        "ETEMCC62552",
                        "AETerm",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "true",
                        "SUP1AGE"});
#line 42
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table5, "And ");
#line 45
 testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 46
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType",
                        "Control Value"});
            table6.AddRow(new string[] {
                        "Coding Field A",
                        "Drug Verbatim 1",
                        "LongText",
                        ""});
#line 47
 testRunner.And("adding a new verbatim term to form \"ETEMCC62552\"", ((string)(null)), table6, "And ");
#line 51
 testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 52
 testRunner.When("task \"Drug Verbatim 1\" is coded to term \"BAYER CHILDREN\'S COLD\" at search level \"" +
                    "Preferred Name\" with code \"005581 01 001\" at level \"PN\" and a synonym is created" +
                    "", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "ATC",
                        "N",
                        "NERVOUS SYSTEM"});
            table7.AddRow(new string[] {
                        "ATC",
                        "N02",
                        "ANALGESICS"});
            table7.AddRow(new string[] {
                        "ATC",
                        "N02B",
                        "OTHER ANALGESICS AND ANTIPYRETICS"});
            table7.AddRow(new string[] {
                        "ATC",
                        "N02BA",
                        "SALICYLIC ACID AND DERIVATIVES"});
            table7.AddRow(new string[] {
                        "PRODUCT",
                        "005581 01 001",
                        "BAYER CHILDREN\'S COLD"});
#line 53
 testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETEMCC62552\" for fiel" +
                    "d \"AETerm\" contains the following data", ((string)(null)), table7, "Then ");
#line 59
 testRunner.When("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 60
 testRunner.And("row on form \"ETEMCC62552\" containing \"Drug Verbatim 1\" is marked with a query", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {
                        "ATC",
                        "N",
                        "NERVOUS SYSTEM"});
            table8.AddRow(new string[] {
                        "ATC",
                        "N02",
                        "ANALGESICS"});
            table8.AddRow(new string[] {
                        "ATC",
                        "N02B",
                        "OTHER ANALGESICS AND ANTIPYRETICS"});
            table8.AddRow(new string[] {
                        "ATC",
                        "N02BA",
                        "SALICYLIC ACID AND DERIVATIVES"});
            table8.AddRow(new string[] {
                        "PRODUCT",
                        "005581 01 001",
                        "BAYER CHILDREN\'S COLD"});
#line 62
 testRunner.Then("the coding decision for verbatim \"child advil cold extreme\" on form \"ETE2\" for fi" +
                    "eld \"Coding Field\" contains the following data", ((string)(null)), table8, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
