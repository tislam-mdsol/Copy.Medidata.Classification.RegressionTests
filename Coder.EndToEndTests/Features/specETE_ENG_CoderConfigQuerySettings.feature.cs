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
    [NUnit.Framework.DescriptionAttribute("When selecting a requires response option for Coder configuration, when a Coder q" +
        "uery is open they will respect the configuration settings. Remove requires manua" +
        "l close and option for Coder configuration")]
    [NUnit.Framework.CategoryAttribute("ETE_ENG_CoderConfigQuerySettings.feature")]
    [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
    public partial class WhenSelectingARequiresResponseOptionForCoderConfigurationWhenACoderQueryIsOpenTheyWillRespectTheConfigurationSettings_RemoveRequiresManualCloseAndOptionForCoderConfigurationFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specETE_ENG_CoderConfigQuerySettings.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "When selecting a requires response option for Coder configuration, when a Coder q" +
                    "uery is open they will respect the configuration settings. Remove requires manua" +
                    "l close and option for Coder configuration", "", ProgrammingLanguage.CSharp, new string[] {
                        "ETE_ENG_CoderConfigQuerySettings.feature",
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
        [NUnit.Framework.DescriptionAttribute("Verify when the requires response option is checked in Coder Configuration, Coder" +
            " Configuration will be respected when a Coder query is opened.")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("MCC_207751_005")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void VerifyWhenTheRequiresResponseOptionIsCheckedInCoderConfigurationCoderConfigurationWillBeRespectedWhenACoderQueryIsOpened_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify when the requires response option is checked in Coder Configuration, Coder" +
                    " Configuration will be respected when a Coder query is opened.", new string[] {
                        "VAL",
                        "MCC_207751_005",
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
                        "Coding Level",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table1.AddRow(new string[] {
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "",
                        "PRODUCTSYNONYM",
                        "1",
                        "true",
                        "true",
                        "LOGSUPPFIELD2,LOGSUPPFIELD4,LOGCOMPFIELD1,LOGCOMPFIELD3"});
#line 13
testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 16
testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 17
testRunner.And("global Rave-Coder Configuration settings with Review Marking Group are set to \"si" +
                    "te from system\" and Requires Response are set to \"true\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 18
testRunner.When("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
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
                        "Log Supplemental Field A",
                        "33",
                        ""});
            table2.AddRow(new string[] {
                        "Std Supplemental Field A",
                        "New Jersey",
                        ""});
            table2.AddRow(new string[] {
                        "Log Supplemental Field B",
                        "United States",
                        ""});
            table2.AddRow(new string[] {
                        "Std Supplemental Field B",
                        "Lost in Translation",
                        ""});
#line 19
testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table2, "And ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table3.AddRow(new string[] {
                        "Coding Field",
                        "extremely cold children medicine",
                        "LongText"});
            table3.AddRow(new string[] {
                        "Log Supplemental Field A",
                        "22",
                        ""});
            table3.AddRow(new string[] {
                        "Log Supplemental Field B",
                        "New York",
                        ""});
#line 26
testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table3, "And ");
#line 31
testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 32
testRunner.And("task \"child advil cold extreme\" is coded to term \"CHILDRENS ADVIL COLD\" at search" +
                    " level \"Trade Name\" with code \"010502 01 015\" at level \"TN\" and a synonym is cre" +
                    "ated", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 33
testRunner.And("reclassifying task \"child advil cold extreme\" with Include Autocoded Items set to" +
                    " \"True\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 34
testRunner.And("rejecting coding decision for the task \"child advil cold extreme\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 35
testRunner.And("I open a query for task \"child advil cold extreme\" with comment \"Open query due t" +
                    "o bad term\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 36
testRunner.And("task \"extremely cold children medicine\" is coded to term \"CHILDRENS ADVIL COLD\" a" +
                    "t search level \"Trade Name\" with code \"010502 01 015\" at level \"TN\" and a synony" +
                    "m is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 37
testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 38
testRunner.Then("the coder query \"Open query due to bad term\" is available to the Rave form \"ETE2\"" +
                    " field \"Coding Field\" with verbatim term \"child advil cold extreme\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 39
testRunner.And("the coder query to the Rave form \"ETE2\" field \"Coding Field\" with verbatim term \"" +
                    "child advil cold extreme\" is responded to with \"Answered Response\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table4.AddRow(new string[] {
                        "ATC",
                        "M",
                        "MUSCULO-SKELETAL SYSTEM"});
            table4.AddRow(new string[] {
                        "ATC",
                        "M01",
                        "ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS"});
            table4.AddRow(new string[] {
                        "ATC",
                        "M01A",
                        "ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS"});
            table4.AddRow(new string[] {
                        "ATC",
                        "M01AE",
                        "PROPIONIC ACID DERIVATIVES"});
            table4.AddRow(new string[] {
                        "PRODUCT",
                        "010502 01 001",
                        "CO-ADVIL"});
            table4.AddRow(new string[] {
                        "PRODUCTSYNONYM",
                        "010502 01 015",
                        "CHILDRENS ADVIL COLD"});
#line 40
testRunner.Then("the coding decision for verbatim \"extremely cold children medicine\" on form \"ETE2" +
                    "\" for field \"Coding Field\" contains the following data", ((string)(null)), table4, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify when the requires response option is unchecked in Coder Configuration, Cod" +
            "er Configuration will be respected when a Coder query is opened.")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("EditGlobalRaveConfiguration")]
        [NUnit.Framework.CategoryAttribute("MCC_207751_006")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void VerifyWhenTheRequiresResponseOptionIsUncheckedInCoderConfigurationCoderConfigurationWillBeRespectedWhenACoderQueryIsOpened_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify when the requires response option is unchecked in Coder Configuration, Cod" +
                    "er Configuration will be respected when a Coder query is opened.", new string[] {
                        "VAL",
                        "EditGlobalRaveConfiguration",
                        "MCC_207751_006",
                        "Release2016.1.0"});
#line 54
this.ScenarioSetup(scenarioInfo);
#line 55
testRunner.Given("a Rave project registration with dictionary \"WhoDrug-DDE-B2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 56
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
                        "",
                        "PRODUCTSYNONYM",
                        "1",
                        "true",
                        "true",
                        "LOGSUPPFIELD2,LOGSUPPFIELD4,LOGCOMPFIELD1,LOGCOMPFIELD3"});
#line 57
testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table5, "And ");
#line 60
testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 61
testRunner.And("global Rave-Coder Configuration settings with Review Marking Group are set to \"si" +
                    "te from system\" and Requires Response are set to \"false\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 62
testRunner.When("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table6.AddRow(new string[] {
                        "Coding Field",
                        "child advil cold extreme",
                        "LongText"});
            table6.AddRow(new string[] {
                        "Log Supplemental Field A",
                        "33",
                        ""});
            table6.AddRow(new string[] {
                        "Std Supplemental Field A",
                        "New Jersey",
                        ""});
            table6.AddRow(new string[] {
                        "Log Supplemental Field B",
                        "United States",
                        ""});
            table6.AddRow(new string[] {
                        "Std Supplemental Field B",
                        "Lost in Translation",
                        ""});
#line 63
testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table6, "And ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table7.AddRow(new string[] {
                        "Coding Field",
                        "extremely cold children medicine",
                        "LongText"});
            table7.AddRow(new string[] {
                        "Log Supplemental Field A",
                        "22",
                        ""});
            table7.AddRow(new string[] {
                        "Log Supplemental Field B",
                        "New York",
                        ""});
#line 70
testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table7, "And ");
#line 75
testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 76
testRunner.And("task \"child advil cold extreme\" is coded to term \"CHILDRENS ADVIL COLD\" at search" +
                    " level \"Trade Name\" with code \"010502 01 015\" at level \"TN\" and a synonym is cre" +
                    "ated", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 77
testRunner.And("reclassifying task \"child advil cold extreme\" with Include Autocoded Items set to" +
                    " \"True\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 78
testRunner.And("rejecting coding decision for the task \"child advil cold extreme\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 79
testRunner.And("I open a query for task \"child advil cold extreme\" with comment \"Open query due t" +
                    "o bad term\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 80
testRunner.And("task \"extremely cold children medicine\" is coded to term \"CHILDRENS ADVIL COLD\" a" +
                    "t search level \"Trade Name\" with code \"010502 01 015\" at level \"TN\" and a synony" +
                    "m is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 81
testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 82
testRunner.Then("the coder query \"Open query due to bad term\" is available to the Rave form \"ETE2\"" +
                    " field \"Coding Field\" with verbatim term \"child advil cold extreme\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 83
testRunner.And("the coder query to the Rave form \"ETE2\" field \"Coding Field\" with verbatim term \"" +
                    "child advil cold extreme\" can not be responded to", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table8.AddRow(new string[] {
                        "ATC",
                        "M",
                        "MUSCULO-SKELETAL SYSTEM"});
            table8.AddRow(new string[] {
                        "ATC",
                        "M01",
                        "ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS"});
            table8.AddRow(new string[] {
                        "ATC",
                        "M01A",
                        "ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS"});
            table8.AddRow(new string[] {
                        "ATC",
                        "M01AE",
                        "PROPIONIC ACID DERIVATIVES"});
            table8.AddRow(new string[] {
                        "PRODUCT",
                        "010502 01 001",
                        "CO-ADVIL"});
            table8.AddRow(new string[] {
                        "PRODUCTSYNONYM",
                        "010502 01 015",
                        "CHILDRENS ADVIL COLD"});
#line 84
testRunner.And("the coding decision for verbatim \"extremely cold children medicine\" on form \"ETE2" +
                    "\" for field \"Coding Field\" contains the following data", ((string)(null)), table8, "And ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
