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
    [NUnit.Framework.DescriptionAttribute("EDC will still be able to receive coding decisions even when the field has been l" +
        "ocked or frozen.")]
    [NUnit.Framework.CategoryAttribute("specETE_ENG_FrozenLockedDP.feature")]
    [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
    public partial class EDCWillStillBeAbleToReceiveCodingDecisionsEvenWhenTheFieldHasBeenLockedOrFrozen_Feature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specETE_ENG_FrozenLockedDP.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "EDC will still be able to receive coding decisions even when the field has been l" +
                    "ocked or frozen.", "", ProgrammingLanguage.CSharp, new string[] {
                        "specETE_ENG_FrozenLockedDP.feature",
                        "EndToEndDynamicSegment"});
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
        [NUnit.Framework.DescriptionAttribute("A coding decision will still be processed even if the data point has been frozen")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("MCC_207752_001")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void ACodingDecisionWillStillBeProcessedEvenIfTheDataPointHasBeenFrozen()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A coding decision will still be processed even if the data point has been frozen", new string[] {
                        "VAL",
                        "MCC_207752_001",
                        "Release2016.1.0"});
#line 9
this.ScenarioSetup(scenarioInfo);
#line 11
 testRunner.Given("a Rave project registration with dictionary \"WhoDrug-DDE-B2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 12
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
                        "IsAutoApproval"});
            table1.AddRow(new string[] {
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "",
                        "PRODUCTSYNONYM",
                        "1",
                        "true",
                        "true"});
#line 13
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 16
 testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 17
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
#line 18
 testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table2, "And ");
#line 21
 testRunner.And("the Rave row on form \"ETE2\" with verbatim term \"child advil cold extreme\" is froz" +
                    "en", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 22
 testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 23
  testRunner.And("task \"child advil cold extreme\" is coded to term \"CO-ADVIL\" at search level \"Pref" +
                    "erred Name\" with code \"010502 01 001\" at level \"PN\" and a synonym is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 24
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table3.AddRow(new string[] {
                        "ATC",
                        "M",
                        "MUSCULO-SKELETAL SYSTEM"});
            table3.AddRow(new string[] {
                        "ATC",
                        "M01",
                        "ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS"});
            table3.AddRow(new string[] {
                        "ATC",
                        "M01A",
                        "ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS"});
            table3.AddRow(new string[] {
                        "ATC",
                        "M01AE",
                        "PROPIONIC ACID DERIVATIVES"});
            table3.AddRow(new string[] {
                        "PRODUCT",
                        "010502 01 001",
                        "CO-ADVIL"});
#line 25
    testRunner.Then("the coding decision for verbatim \"child advil cold extreme\" on form \"ETE2\" for fi" +
                    "eld \"Coding Field\" contains the following data", ((string)(null)), table3, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A coding decision will still be processed even if the data point has been locked")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("MCC-207752-002")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void ACodingDecisionWillStillBeProcessedEvenIfTheDataPointHasBeenLocked()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A coding decision will still be processed even if the data point has been locked", new string[] {
                        "DFT",
                        "MCC-207752-002",
                        "Release2016.1.0"});
#line 36
this.ScenarioSetup(scenarioInfo);
#line 38
testRunner.Given("a Rave project registration with dictionary \"WHODRUGB2 200703 ENG\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 39
testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "Coding Level",
                        "Priority",
                        "IsApproDFTRequired",
                        "IsAutoApproDFT",
                        "SupplementalTerms"});
            table4.AddRow(new string[] {
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "",
                        "LLT",
                        "1",
                        "true",
                        "true",
                        "LOGSUPPFIELD2,LOGSUPPFIELD4,LOGCOMPFIELD1,COMPANY,LOGCOMPFIELD3,SOURCE"});
#line 40
testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table4, "And ");
#line 43
testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 44
testRunner.When("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "DFTue",
                        "ControlType"});
            table5.AddRow(new string[] {
                        "Coding Field",
                        "terrible head pain",
                        "LongText"});
#line 45
testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table5, "And ");
#line 48
testRunner.And("the Rave row on form \"ETE2\" with verbatim term \"Sharp pain down leg\" is locked", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 49
testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 50
testRunner.And("task \"sharp pain in nerves\" is coded to term \"ACHES-N-PAIN\" at search level \"Low " +
                    "Level Term\" with code \"??????????????\" at level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 51
testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table6.AddRow(new string[] {
                        "SOC",
                        "10007541",
                        "Cardiac disorders"});
            table6.AddRow(new string[] {
                        "HLGT",
                        "10007521",
                        "Cardiac arrhythmias"});
            table6.AddRow(new string[] {
                        "HLT",
                        "10042600",
                        "Supraventricular arrhythmias"});
            table6.AddRow(new string[] {
                        "PT",
                        "10003658",
                        "Atrial fibrillation"});
            table6.AddRow(new string[] {
                        "LLT",
                        "10003658",
                        "Atrial fibrillation"});
#line 52
testRunner.Then("the coding decision for verbatim \"terrible head pain\" on form \"ETE2\" for field \"C" +
                    "oding Field\" contains the following data", ((string)(null)), table6, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A coding decision will still be processed even if the forms have been locked")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("MCC-207752-003")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void ACodingDecisionWillStillBeProcessedEvenIfTheFormsHaveBeenLocked()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A coding decision will still be processed even if the forms have been locked", new string[] {
                        "DFT",
                        "MCC-207752-003",
                        "Release2016.1.0"});
#line 64
this.ScenarioSetup(scenarioInfo);
#line 65
testRunner.Given("a Rave project registration with dictionary \"WHODRUGB2 200703 ENG\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 66
testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "Coding Level",
                        "Priority",
                        "IsApproDFTRequired",
                        "IsAutoApproDFT",
                        "SupplementalTerms"});
            table7.AddRow(new string[] {
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "",
                        "LLT",
                        "1",
                        "true",
                        "true",
                        "LOGSUPPFIELD2,LOGSUPPFIELD4,LOGCOMPFIELD1,COMPANY,LOGCOMPFIELD3,SOURCE"});
#line 67
testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table7, "And ");
#line 70
testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 71
testRunner.When("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "DFTue",
                        "ControlType"});
            table8.AddRow(new string[] {
                        "Coding Field",
                        "terrible head pain",
                        "LongText"});
#line 72
testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table8, "And ");
#line 75
testRunner.And("form \"ETE2\" is locked", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 76
testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 77
testRunner.And("task \"sharp pain in nerves\" is coded to term \"ACHES-N-PAIN\" at search level \"Low " +
                    "Level Term\" with code \"??????????????\" at level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 78
testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table9 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table9.AddRow(new string[] {
                        "SOC",
                        "10007541",
                        "Cardiac disorders"});
            table9.AddRow(new string[] {
                        "HLGT",
                        "10007521",
                        "Cardiac arrhythmias"});
            table9.AddRow(new string[] {
                        "HLT",
                        "10042600",
                        "Supraventricular arrhythmias"});
            table9.AddRow(new string[] {
                        "PT",
                        "10003658",
                        "Atrial fibrillation"});
            table9.AddRow(new string[] {
                        "LLT",
                        "10003658",
                        "Atrial fibrillation"});
#line 79
testRunner.Then("the coding decision for verbatim \"terrible head pain\" on form \"ETE2\" for field \"C" +
                    "oding Field\" contains the following data", ((string)(null)), table9, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A coding decision will still be processed even if the data page has been frozen")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("MCC-207752-004")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void ACodingDecisionWillStillBeProcessedEvenIfTheDataPageHasBeenFrozen()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A coding decision will still be processed even if the data page has been frozen", new string[] {
                        "DFT",
                        "MCC-207752-004",
                        "Release2016.1.0"});
#line 91
this.ScenarioSetup(scenarioInfo);
#line 92
testRunner.Given("a Rave project registration with dictionary \"WHODRUGB2 200703 ENG\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 93
testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table10 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "Coding Level",
                        "Priority",
                        "IsApproDFTRequired",
                        "IsAutoApproDFT",
                        "SupplementalTerms"});
            table10.AddRow(new string[] {
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "",
                        "LLT",
                        "1",
                        "true",
                        "true",
                        "LOGSUPPFIELD2,LOGSUPPFIELD4,LOGCOMPFIELD1,COMPANY,LOGCOMPFIELD3,SOURCE"});
#line 94
testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table10, "And ");
#line 97
testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 98
testRunner.When("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table11 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "DFTue",
                        "ControlType"});
            table11.AddRow(new string[] {
                        "Coding Field",
                        "terrible head pain",
                        "LongText"});
#line 99
testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table11, "And ");
#line 102
testRunner.And("form \"ETE2\" is frozen", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 103
testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 104
testRunner.And("task \"sharp pain in nerves\" is coded to term \"ACHES-N-PAIN\" at search level \"Low " +
                    "Level Term\" with code \"??????????????\" at level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 105
testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table12 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table12.AddRow(new string[] {
                        "SOC",
                        "10007541",
                        "Cardiac disorders"});
            table12.AddRow(new string[] {
                        "HLGT",
                        "10007521",
                        "Cardiac arrhythmias"});
            table12.AddRow(new string[] {
                        "HLT",
                        "10042600",
                        "Supraventricular arrhythmias"});
            table12.AddRow(new string[] {
                        "PT",
                        "10003658",
                        "Atrial fibrillation"});
            table12.AddRow(new string[] {
                        "LLT",
                        "10003658",
                        "Atrial fibrillation"});
#line 106
testRunner.Then("the coding decision for verbatim \"terrible head pain\" on form \"ETE2\" for field \"C" +
                    "oding Field\" contains the following data", ((string)(null)), table12, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
