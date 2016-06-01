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
    [NUnit.Framework.DescriptionAttribute("Verify using Dynamic Search List combinations of Standard Fields, Log Line Fields" +
        ", Search List, etc. for Coding Fields & Supplement and Component Values is fully" +
        " supported and the round trip integration works successfully.")]
    [NUnit.Framework.CategoryAttribute("specENG_DynamicSearchList")]
    [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
    public partial class VerifyUsingDynamicSearchListCombinationsOfStandardFieldsLogLineFieldsSearchListEtc_ForCodingFieldsSupplementAndComponentValuesIsFullySupportedAndTheRoundTripIntegrationWorksSuccessfully_Feature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specENG_DynamicSearchList.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Verify using Dynamic Search List combinations of Standard Fields, Log Line Fields" +
                    ", Search List, etc. for Coding Fields & Supplement and Component Values is fully" +
                    " supported and the round trip integration works successfully.", "", ProgrammingLanguage.CSharp, new string[] {
                        "specENG_DynamicSearchList",
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
        [NUnit.Framework.DescriptionAttribute("Standard verbatim and supplemental fields using a control type of Dynamic Search " +
            "List will be successfully coded.")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PB92926DSL.002SUP")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void StandardVerbatimAndSupplementalFieldsUsingAControlTypeOfDynamicSearchListWillBeSuccessfullyCoded_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Standard verbatim and supplemental fields using a control type of Dynamic Search " +
                    "List will be successfully coded.", new string[] {
                        "VAL",
                        "PB92926DSL.002SUP",
                        "Release2016.1.0"});
#line 10
this.ScenarioSetup(scenarioInfo);
#line 12
 testRunner.Given("a Rave project registration with dictionary \"WhoDrug-DDE-B2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 13
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
                        "ETE19",
                        "Coding Field",
                        "<Dictionary>",
                        "",
                        "PRODUCTSYNONYM",
                        "1",
                        "true",
                        "true",
                        "DSearchlist LL Sup"});
#line 14
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 17
 testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 18
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table2.AddRow(new string[] {
                        "Coding Field",
                        "child advil cold extreme",
                        ""});
            table2.AddRow(new string[] {
                        "Dynamic Search List Supplemental Field B",
                        "DarkRed",
                        "DynamicSearchList"});
#line 19
 testRunner.And("adding a new verbatim term to form \"ETE19\"", ((string)(null)), table2, "And ");
#line 23
    testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Term",
                        "Value"});
            table3.AddRow(new string[] {
                        "ETE19.DSEARCHLISTLLSUP",
                        "DarkRed"});
#line 24
 testRunner.Then("the \"child advil cold extreme\" task has the following supplemental information", ((string)(null)), table3, "Then ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Source System",
                        "Study",
                        "Dictionary",
                        "Locale",
                        "Term",
                        "Level",
                        "Priority"});
            table4.AddRow(new string[] {
                        "Rave EDC",
                        "<StudyDisplayName>",
                        "WhoDrugDDEB2 - 200703",
                        "ENG",
                        "child advil cold extreme",
                        "Trade Name",
                        "1"});
#line 27
 testRunner.And("task \"child advil cold extreme\" should contain the following source term informat" +
                    "ion", ((string)(null)), table4, "And ");
#line 30
 testRunner.When("task \"child advil cold extreme\" is coded to term \"CHILDRENS ADVIL COLD\" at search" +
                    " level \"Trade Name\" with code \"010502 01 015\" at level \"TN\" and a synonym is cre" +
                    "ated", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 31
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table5.AddRow(new string[] {
                        "ATC",
                        "M",
                        "MUSCULO-SKELETAL SYSTEM"});
            table5.AddRow(new string[] {
                        "ATC",
                        "M01",
                        "ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS"});
            table5.AddRow(new string[] {
                        "ATC",
                        "M01A",
                        "ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS"});
            table5.AddRow(new string[] {
                        "ATC",
                        "M01AE",
                        "PROPIONIC ACID DERIVATIVES"});
            table5.AddRow(new string[] {
                        "PRODUCT",
                        "010502 01 001",
                        "CO-ADVIL"});
            table5.AddRow(new string[] {
                        "PRODUCTSYNONYM",
                        "010502 01 015",
                        "CHILDRENS ADVIL COLD"});
#line 32
 testRunner.Then("the coding decision for verbatim \"child advil cold extreme\" on form \"ETE19\" for f" +
                    "ield \"Log Search List Coding Field\" contains the following data", ((string)(null)), table5, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Log line verbatim and supplemental fields using a control type of Dynamic Search " +
            "List will be successfully coded.")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("PB92926DSL.005LLSUP")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void LogLineVerbatimAndSupplementalFieldsUsingAControlTypeOfDynamicSearchListWillBeSuccessfullyCoded_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Log line verbatim and supplemental fields using a control type of Dynamic Search " +
                    "List will be successfully coded.", new string[] {
                        "DFT",
                        "PB92926DSL.005LLSUP",
                        "Release2016.1.0"});
#line 45
this.ScenarioSetup(scenarioInfo);
#line 47
 testRunner.Given("a Rave project registration with dictionary \"WhoDrugDDEB2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 48
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "CodingLevel",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table6.AddRow(new string[] {
                        "ETE19",
                        "LL Coding Field",
                        "<Dictionary>",
                        "<Locale>",
                        "PRODUCTSYNONYM",
                        "1",
                        "true",
                        "true",
                        "DSearchlist LL Sup"});
#line 49
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table6, "And ");
#line 52
 testRunner.When("a Rave Draft is published and pushed using draft \"<Draft>\" for Project \"<StudyNam" +
                    "e>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 53
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table7.AddRow(new string[] {
                        "Log Coding Field",
                        "child advil cold extreme",
                        "LongText"});
            table7.AddRow(new string[] {
                        "DSearchlist LL Sup",
                        "Sup1",
                        "DynamicSearchList"});
#line 54
 testRunner.And("adding a new verbatim term to form \"ETE19\"", ((string)(null)), table7, "And ");
#line 58
 testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {
                        "Supplemental Term",
                        "Supplemental Value"});
            table8.AddRow(new string[] {
                        "ETE19.DSEARCHLISTLLSUP",
                        "Sup1"});
#line 59
 testRunner.Then("I verify the following Supplemental information is displayed", ((string)(null)), table8, "Then ");
#line hidden
            TechTalk.SpecFlow.Table table9 = new TechTalk.SpecFlow.Table(new string[] {
                        "Source System",
                        "Study",
                        "Dictionary",
                        "Locale",
                        "Term",
                        "Level",
                        "Priority"});
            table9.AddRow(new string[] {
                        "Rave EDC",
                        "<StudyDisplayName>",
                        "WhoDrugDDEB2 - 200703",
                        "ENG",
                        "child advil cold extreme",
                        "Trade Name",
                        "1"});
#line 62
 testRunner.And("task \"child advil cold extreme\" should contain the following source term informat" +
                    "ion", ((string)(null)), table9, "And ");
#line 65
 testRunner.When("task \"child advil cold extreme\" is coded to term \"CHILDRENS ADVIL COLD\" at search" +
                    " level \"Trade Name\" with code \"010502 01 015\" at level \"TN\" and a synonym is cre" +
                    "ated", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 66
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table10 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table10.AddRow(new string[] {
                        "ATC",
                        "M",
                        "MUSCULO-SKELETAL SYSTEM"});
            table10.AddRow(new string[] {
                        "ATC",
                        "M01",
                        "ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS"});
            table10.AddRow(new string[] {
                        "ATC",
                        "M01A",
                        "ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS"});
            table10.AddRow(new string[] {
                        "ATC",
                        "M01AE",
                        "PROPIONIC ACID DERIVATIVES"});
            table10.AddRow(new string[] {
                        "PRODUCT",
                        "010502 01 001",
                        "CO-ADVIL"});
            table10.AddRow(new string[] {
                        "PRODUCTSYNONYM",
                        "010502 01 015",
                        "CHILDRENS ADVIL COLD"});
#line 67
 testRunner.Then("the coding decision for verbatim \"child advil cold extreme\" on form \"ETE19\" for f" +
                    "ield \"Log Search List Coding Field\" contains the following data", ((string)(null)), table10, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
