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
        [NUnit.Framework.CategoryAttribute("PBMCC62552_001b")]
        [NUnit.Framework.CategoryAttribute("ReleaseRave2013.1.0.1")]
        [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
        public virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainstAVerbatimField_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A coding decision remains on the verbatim when a query is opened against a verbat" +
                    "im field.", new string[] {
                        "DFT",
                        "PBMCC62552_001b",
                        "ReleaseRave2013.1.0.1",
                        "EndToEndDynamicSegment"});
#line 8
this.ScenarioSetup(scenarioInfo);
#line 9
 testRunner.Given("a Rave project registration with dictionary \"WhoDrug-DDE-B2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 10
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
                        "PRODUCTSYNONYM",
                        "1",
                        "false",
                        "false",
                        "LogSuppField2"});
#line 11
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 14
 testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 15
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
            table2.AddRow(new string[] {
                        "Log Supplemental Field B",
                        "Twenty",
                        "SmallTextInput",
                        "Other"});
#line 16
 testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table2, "And ");
#line 20
 testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 21
 testRunner.When("task \"Drug Verbatim 1\" is coded to term \"BAYER CHILDREN\'S COLD\" at search level \"" +
                    "Preferred Name\" with code \"005581 01 001\" at level \"PN\" and a synonym is created" +
                    "", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 22
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table3.AddRow(new string[] {
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
#line 23
 testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETE2\" for field \"Codi" +
                    "ng Field\" contains the following data", ((string)(null)), table3, "Then ");
#line 30
 testRunner.When("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 31
 testRunner.And("row on form \"ETE2\" containing \"Drug Verbatim 1\" is marked with a query", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table4.AddRow(new string[] {
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
#line 32
 testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETE2\" for field \"Codi" +
                    "ng Field\" contains the following data", ((string)(null)), table4, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A coding decision remains on the verbatim when a query is opened against a supplm" +
            "ental field.")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("PBMCC62552_001b")]
        [NUnit.Framework.CategoryAttribute("ReleaseRave2013.1.0.1")]
        [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
        public virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainstASupplmentalField_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A coding decision remains on the verbatim when a query is opened against a supplm" +
                    "ental field.", new string[] {
                        "DFT",
                        "PBMCC62552_001b",
                        "ReleaseRave2013.1.0.1",
                        "EndToEndDynamicSegment"});
#line 45
this.ScenarioSetup(scenarioInfo);
#line 46
 testRunner.Given("a Rave project registration with dictionary \"WhoDrug-DDE-B2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 47
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
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "<Locale>",
                        "PRODUCTSYNONYM",
                        "1",
                        "false",
                        "false",
                        "LogSuppField2"});
#line 48
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table5, "And ");
#line 51
 testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 52
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
            table6.AddRow(new string[] {
                        "Log Supplemental Field B",
                        "Twenty",
                        "SmallTextInput",
                        "Other"});
#line 53
 testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table6, "And ");
#line 57
 testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 58
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
#line 59
 testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETE2\" for field \"Codi" +
                    "ng Field\" contains the following data", ((string)(null)), table7, "Then ");
#line 65
 testRunner.When("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 66
 testRunner.And("row on form \"ETE2\" containing \"Twenty\" is marked with a query", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
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
#line 67
 testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETE2\" for field \"Codi" +
                    "ng Field\" contains the following data", ((string)(null)), table8, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A coding decision remains on the verbatim when a sticky is opened against a verba" +
            "tim field.")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("PBMCC62552_001b")]
        [NUnit.Framework.CategoryAttribute("ReleaseRave2013.1.0.1")]
        [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
        public virtual void ACodingDecisionRemainsOnTheVerbatimWhenAStickyIsOpenedAgainstAVerbatimField_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A coding decision remains on the verbatim when a sticky is opened against a verba" +
                    "tim field.", new string[] {
                        "DFT",
                        "PBMCC62552_001b",
                        "ReleaseRave2013.1.0.1",
                        "EndToEndDynamicSegment"});
#line 78
this.ScenarioSetup(scenarioInfo);
#line 79
 testRunner.Given("a Rave project registration with dictionary \"WhoDrugDDEB2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 80
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table9 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "Coding Level",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table9.AddRow(new string[] {
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "<Locale>",
                        "PRODUCTSYNONYM",
                        "1",
                        "false",
                        "false",
                        "LogSuppField2"});
#line 81
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table9, "And ");
#line 84
 testRunner.When("a Rave Draft is published and pushed using draft \"<Draft>\" for Project \"<StudyNam" +
                    "e>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 85
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table10 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType",
                        "Control Value"});
            table10.AddRow(new string[] {
                        "Coding Field A",
                        "Drug Verbatim 1",
                        "LongText",
                        ""});
            table10.AddRow(new string[] {
                        "SUP1AGE",
                        "Twenty",
                        "SmallTextInput",
                        "Other"});
#line 86
 testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table10, "And ");
#line 90
 testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 91
 testRunner.When("task \"Drug Verbatim 1\" is coded to term \"BAYER CHILDREN\'S COLD\" at search level \"" +
                    "Preferred Name\" with code \"005581 01 001\" at level \"PN\" and a synonym is created" +
                    "", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 92
    testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table11 = new TechTalk.SpecFlow.Table(new string[] {
                        "ATC",
                        "N",
                        "NERVOUS SYSTEM"});
            table11.AddRow(new string[] {
                        "ATC",
                        "N02",
                        "ANALGESICS"});
            table11.AddRow(new string[] {
                        "ATC",
                        "N02B",
                        "OTHER ANALGESICS AND ANTIPYRETICS"});
            table11.AddRow(new string[] {
                        "ATC",
                        "N02BA",
                        "SALICYLIC ACID AND DERIVATIVES"});
            table11.AddRow(new string[] {
                        "PRODUCT",
                        "005581 01 001",
                        "BAYER CHILDREN\'S COLD"});
#line 93
    testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETE2\" for field \"Codi" +
                    "ng Field\" contains the following data", ((string)(null)), table11, "Then ");
#line 99
 testRunner.When("row on form \"ETE2\" containing \"Drug Verbatim 1\" is marked with a sticky", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table12 = new TechTalk.SpecFlow.Table(new string[] {
                        "ATC",
                        "N",
                        "NERVOUS SYSTEM"});
            table12.AddRow(new string[] {
                        "ATC",
                        "N02",
                        "ANALGESICS"});
            table12.AddRow(new string[] {
                        "ATC",
                        "N02B",
                        "OTHER ANALGESICS AND ANTIPYRETICS"});
            table12.AddRow(new string[] {
                        "ATC",
                        "N02BA",
                        "SALICYLIC ACID AND DERIVATIVES"});
            table12.AddRow(new string[] {
                        "PRODUCT",
                        "005581 01 001",
                        "BAYER CHILDREN\'S COLD"});
#line 100
    testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETE2\" for field \"Codi" +
                    "ng Field\" contains the following data", ((string)(null)), table12, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A coding decision remains on the verbatim when a sticky is opened against a suppl" +
            "emental field.")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("PBMCC62552_001b")]
        [NUnit.Framework.CategoryAttribute("ReleaseRave2013.1.0.1")]
        [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
        public virtual void ACodingDecisionRemainsOnTheVerbatimWhenAStickyIsOpenedAgainstASupplementalField_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A coding decision remains on the verbatim when a sticky is opened against a suppl" +
                    "emental field.", new string[] {
                        "DFT",
                        "PBMCC62552_001b",
                        "ReleaseRave2013.1.0.1",
                        "EndToEndDynamicSegment"});
#line 111
this.ScenarioSetup(scenarioInfo);
#line 112
 testRunner.Given("a Rave project registration with dictionary \"WhoDrugDDEB2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 113
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table13 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "Coding Level",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table13.AddRow(new string[] {
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "<Locale>",
                        "PRODUCTSYNONYM",
                        "1",
                        "false",
                        "false",
                        "LogSuppField2"});
#line 114
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table13, "And ");
#line 117
 testRunner.When("a Rave Draft is published and pushed using draft \"<Draft>\" for Project \"<StudyNam" +
                    "e>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 118
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table14 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType",
                        "Control Value"});
            table14.AddRow(new string[] {
                        "Coding Field A",
                        "Drug Verbatim 1",
                        "",
                        ""});
            table14.AddRow(new string[] {
                        "SUP1AGE",
                        "Twenty",
                        "SmallTextInput",
                        "Other"});
#line 119
 testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table14, "And ");
#line 123
 testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 124
 testRunner.When("task \"Drug Verbatim 1\" is coded to term \"BAYER CHILDREN\'S COLD\" at search level \"" +
                    "Preferred Name\" with code \"005581 01 001\" at level \"PN\" and a synonym is created" +
                    "", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 125
    testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table15 = new TechTalk.SpecFlow.Table(new string[] {
                        "ATC",
                        "N",
                        "NERVOUS SYSTEM"});
            table15.AddRow(new string[] {
                        "ATC",
                        "N02",
                        "ANALGESICS"});
            table15.AddRow(new string[] {
                        "ATC",
                        "N02B",
                        "OTHER ANALGESICS AND ANTIPYRETICS"});
            table15.AddRow(new string[] {
                        "ATC",
                        "N02BA",
                        "SALICYLIC ACID AND DERIVATIVES"});
            table15.AddRow(new string[] {
                        "PRODUCT",
                        "005581 01 001",
                        "BAYER CHILDREN\'S COLD"});
#line 126
    testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETE2\" for field \"Codi" +
                    "ng Field\" contains the following data", ((string)(null)), table15, "Then ");
#line 132
 testRunner.When("row on form \"ETE2\" containing \"Twenty\" is marked with a sticky", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table16 = new TechTalk.SpecFlow.Table(new string[] {
                        "ATC",
                        "N",
                        "NERVOUS SYSTEM"});
            table16.AddRow(new string[] {
                        "ATC",
                        "N02",
                        "ANALGESICS"});
            table16.AddRow(new string[] {
                        "ATC",
                        "N02B",
                        "OTHER ANALGESICS AND ANTIPYRETICS"});
            table16.AddRow(new string[] {
                        "ATC",
                        "N02BA",
                        "SALICYLIC ACID AND DERIVATIVES"});
            table16.AddRow(new string[] {
                        "PRODUCT",
                        "005581 01 001",
                        "BAYER CHILDREN\'S COLD"});
#line 133
    testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETE2\" for field \"Codi" +
                    "ng Field\" contains the following data", ((string)(null)), table16, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
