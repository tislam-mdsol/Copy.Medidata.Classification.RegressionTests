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
namespace Coder.RegressionTests.Features
{
    using TechTalk.SpecFlow;
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("TechTalk.SpecFlow", "1.9.0.77")]
    [System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [NUnit.Framework.TestFixtureAttribute()]
    [NUnit.Framework.DescriptionAttribute("Verify Coding History Report")]
    [NUnit.Framework.CategoryAttribute("specCodingHistoryReport.feature")]
    [NUnit.Framework.CategoryAttribute("CoderCore")]
    public partial class VerifyCodingHistoryReportFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specCodingHistoryReport.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Verify Coding History Report", "", ProgrammingLanguage.CSharp, new string[] {
                        "specCodingHistoryReport.feature",
                        "CoderCore"});
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
        [NUnit.Framework.DescriptionAttribute("Verify the user is able to export using verbatim")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_37359_MCC_178485_001")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void VerifyTheUserIsAbleToExportUsingVerbatim()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify the user is able to export using verbatim", new string[] {
                        "VAL",
                        "PBMCC_37359_MCC_178485_001",
                        "Release2015.3.0"});
#line 8
this.ScenarioSetup(scenarioInfo);
#line 9
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 10
 testRunner.And("coding task \"Adverse Event Term 1\" for dictionary level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 11
 testRunner.When("a new report type \"Coding History\" is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 12
 testRunner.And("searching for the verbatim \"Adverse Event Term 1\" in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 13
 testRunner.And("searching for auto coded items in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 14
 testRunner.And("exporting all columns in the Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "User",
                        "Term",
                        "Code",
                        "Path",
                        "Status",
                        "Action",
                        "System Action",
                        "Comment"});
            table1.AddRow(new string[] {
                        "Adverse Event Term 1",
                        "System User",
                        "",
                        "",
                        "",
                        "Start",
                        "",
                        "",
                        "Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAuto" +
                            "Approval=true,IsBypassTransmit=True]"});
            table1.AddRow(new string[] {
                        "Adverse Event Term 1",
                        "System User",
                        "",
                        "",
                        "",
                        "Waiting Manual Code",
                        "Start Auto Code",
                        "",
                        ""});
#line 15
 testRunner.Then("the Coding History Report should contain the following", ((string)(null)), table1, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify the user is able to export using code")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_37359_MCC_178485_002")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void VerifyTheUserIsAbleToExportUsingCode()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify the user is able to export using code", new string[] {
                        "VAL",
                        "PBMCC_37359_MCC_178485_002",
                        "Release2015.3.0"});
#line 24
this.ScenarioSetup(scenarioInfo);
#line 25
 testRunner.Given("a \"Waiting Approval\" Coder setup with no tasks and no synonyms and dictionary \"Wh" +
                    "oDrugDDEB2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 26
 testRunner.And("coding task \"ASPIRIN PLUS C\" for dictionary level \"PRODUCT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 27
 testRunner.When("a new report type \"Coding History\" is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 28
 testRunner.And("searching for the term \"ASPIRIN PLUS C\" in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 29
 testRunner.And("searching for the code \"003467 01 001\" in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 30
 testRunner.And("searching for auto coded items in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 31
 testRunner.And("exporting all columns in the Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "User",
                        "Term",
                        "Code",
                        "Path",
                        "Status",
                        "Action",
                        "System Action",
                        "Comment"});
            table2.AddRow(new string[] {
                        "ASPIRIN PLUS C",
                        "System User",
                        "",
                        "",
                        "",
                        "Start",
                        "",
                        "",
                        "Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAuto" +
                            "Approval=false,IsBypassTransmit=True]"});
            table2.AddRow(new string[] {
                        "ASPIRIN PLUS C",
                        "System User",
                        "ASPIRIN PLUS C",
                        "003467 01 001",
                        "ATC: NERVOUS SYSTEM: N; ATC: ANALGESICS: N02; ATC: OTHER ANALGESICS AND ANTIPYRET" +
                            "ICS: N02B; ATC: SALICYLIC ACID AND DERIVATIVES: N02BA; PRODUCT: ASPIRIN PLUS C: " +
                            "003467 01 001",
                        "Waiting Approval",
                        "Start Auto Code",
                        "Auto Coding",
                        "Auto coded by direct dictionary match"});
#line 32
 testRunner.Then("the Coding History Report should contain the following", ((string)(null)), table2, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify the user is able to export using term")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_37359_MCC_178485_003")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void VerifyTheUserIsAbleToExportUsingTerm()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify the user is able to export using term", new string[] {
                        "VAL",
                        "PBMCC_37359_MCC_178485_003",
                        "Release2015.3.0"});
#line 41
this.ScenarioSetup(scenarioInfo);
#line 42
 testRunner.Given("a \"Waiting Approval\" Coder setup with no tasks and no synonyms and dictionary \"Wh" +
                    "oDrugDDEB2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 43
 testRunner.And("coding task \"ASPIRIN PLUS C\" for dictionary level \"PRODUCT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 44
 testRunner.When("a new report type \"Coding History\" is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 45
 testRunner.And("searching for the term \"ASPIRIN PLUS C\" in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 46
 testRunner.And("searching for auto coded items in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 47
 testRunner.And("exporting all columns in the Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "User",
                        "Term",
                        "Code",
                        "Path",
                        "Status",
                        "Action",
                        "System Action",
                        "Comment"});
            table3.AddRow(new string[] {
                        "ASPIRIN PLUS C",
                        "System User",
                        "",
                        "",
                        "",
                        "Start",
                        "",
                        "",
                        "Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAuto" +
                            "Approval=false,IsBypassTransmit=True]"});
            table3.AddRow(new string[] {
                        "ASPIRIN PLUS C",
                        "System User",
                        "ASPIRIN PLUS C",
                        "003467 01 001",
                        "ATC: NERVOUS SYSTEM: N; ATC: ANALGESICS: N02; ATC: OTHER ANALGESICS AND ANTIPYRET" +
                            "ICS: N02B; ATC: SALICYLIC ACID AND DERIVATIVES: N02BA; PRODUCT: ASPIRIN PLUS C: " +
                            "003467 01 001",
                        "Waiting Approval",
                        "Start Auto Code",
                        "Auto Coding",
                        "Auto coded by direct dictionary match"});
#line 48
 testRunner.Then("the Coding History Report should contain the following", ((string)(null)), table3, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify the user is able to select statuses in current status")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_37359_MCC_178485_004")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void VerifyTheUserIsAbleToSelectStatusesInCurrentStatus()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify the user is able to select statuses in current status", new string[] {
                        "VAL",
                        "PBMCC_37359_MCC_178485_004",
                        "Release2015.3.0"});
#line 57
this.ScenarioSetup(scenarioInfo);
#line 58
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 59
 testRunner.And("coding task \"Adverse Event Term 1\" for dictionary level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 60
 testRunner.When("a new report type \"Coding History\" is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 61
 testRunner.And("searching for the verbatim \"Adverse Event Term 1\" in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 62
 testRunner.And("searching for the status \"Waiting Manual Code\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 63
 testRunner.And("searching for auto coded items in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 64
 testRunner.And("exporting all columns in the Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "User",
                        "Term",
                        "Code",
                        "Path",
                        "Status",
                        "Action",
                        "System Action",
                        "Comment"});
            table4.AddRow(new string[] {
                        "Adverse Event Term 1",
                        "System User",
                        "",
                        "",
                        "",
                        "Start",
                        "",
                        "",
                        "Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAuto" +
                            "Approval=true,IsBypassTransmit=True]"});
            table4.AddRow(new string[] {
                        "Adverse Event Term 1",
                        "System User",
                        "",
                        "",
                        "",
                        "Waiting Manual Code",
                        "Start Auto Code",
                        "",
                        ""});
#line 65
 testRunner.Then("the Coding History Report should contain the following", ((string)(null)), table4, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify the user is able to enter a start and end date")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_37359_MCC_178485_005")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void VerifyTheUserIsAbleToEnterAStartAndEndDate()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify the user is able to enter a start and end date", new string[] {
                        "VAL",
                        "PBMCC_37359_MCC_178485_005",
                        "Release2015.3.0"});
#line 74
this.ScenarioSetup(scenarioInfo);
#line 75
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 76
 testRunner.And("coding task \"Adverse Event Term 1\" for dictionary level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 77
 testRunner.When("a new report type \"Coding History\" is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 78
 testRunner.And("searching for the verbatim \"Adverse Event Term 1\" in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 79
 testRunner.And("searching for start date of \"01 Jan 2015\" and end date of \"01 Jan 2050\" in Coding" +
                    " History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 80
 testRunner.And("searching for auto coded items in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 81
 testRunner.And("exporting all columns in the Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "User",
                        "Term",
                        "Code",
                        "Path",
                        "Status",
                        "Action",
                        "System Action",
                        "Comment"});
            table5.AddRow(new string[] {
                        "Adverse Event Term 1",
                        "System User",
                        "",
                        "",
                        "",
                        "Start",
                        "",
                        "",
                        "Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAuto" +
                            "Approval=true,IsBypassTransmit=True]"});
            table5.AddRow(new string[] {
                        "Adverse Event Term 1",
                        "System User",
                        "",
                        "",
                        "",
                        "Waiting Manual Code",
                        "Start Auto Code",
                        "",
                        ""});
#line 82
 testRunner.Then("the Coding History Report should contain the following", ((string)(null)), table5, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify the user is able to export multiple terms")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_37359_MCC_178485_006")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void VerifyTheUserIsAbleToExportMultipleTerms()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify the user is able to export multiple terms", new string[] {
                        "VAL",
                        "PBMCC_37359_MCC_178485_006",
                        "Release2015.3.0"});
#line 92
this.ScenarioSetup(scenarioInfo);
#line 93
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Dictionary",
                        "Dictionary Level",
                        "Is Approval Required",
                        "Is Auto Approval",
                        "Locale"});
            table6.AddRow(new string[] {
                        "Adverse Event Term 1",
                        "MedDRA",
                        "LLT",
                        "TRUE",
                        "FALSE",
                        "eng"});
            table6.AddRow(new string[] {
                        "Adverse Event Term 1",
                        "MedDRA",
                        "LLT",
                        "TRUE",
                        "FALSE",
                        "eng"});
#line 94
 testRunner.When("uploading MEV content", ((string)(null)), table6, "When ");
#line 98
 testRunner.And("a new report type \"Coding History\" is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 99
 testRunner.And("searching for auto coded items in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 100
 testRunner.And("exporting all columns in the Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "User",
                        "Term",
                        "Code",
                        "Path",
                        "Status",
                        "Action",
                        "System Action",
                        "Comment"});
            table7.AddRow(new string[] {
                        "Adverse Event Term 1",
                        "System User",
                        "",
                        "",
                        "",
                        "Start",
                        "",
                        "",
                        "Workflow=DEFAULT,WorkflowVariables[IsApprovalRequired=TRUE,IsAutoApproval=FALSE,I" +
                            "sBypassTransmit=True,IsAutoCode=True]"});
            table7.AddRow(new string[] {
                        "Adverse Event Term 1",
                        "System User",
                        "",
                        "",
                        "",
                        "Waiting Manual Code",
                        "Start Auto Code",
                        "",
                        ""});
#line 101
 testRunner.Then("the Coding History Report should contain the following", ((string)(null)), table7, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify the user is able to export using verbatim on a non production study")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_37359_MCC_178485_007")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void VerifyTheUserIsAbleToExportUsingVerbatimOnANonProductionStudy()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify the user is able to export using verbatim on a non production study", new string[] {
                        "VAL",
                        "PBMCC_37359_MCC_178485_007",
                        "Release2015.3.0"});
#line 110
this.ScenarioSetup(scenarioInfo);
#line 111
  testRunner.Given("a \"Basic\" Coder setup for a non-production study with no tasks and no synonyms an" +
                    "d dictionary \"MedDRA ENG 15.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 112
  testRunner.And("coding task \"Adverse Event Term 2\" for dictionary level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 113
  testRunner.When("a new report type \"Coding History\" is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 114
  testRunner.And("searching for the verbatim \"Adverse Event Term 2\" in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 115
  testRunner.And("searching for auto coded items in Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 116
  testRunner.And("exporting all columns in the Coding History Report", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {
                        "Study",
                        "Verbatim Term",
                        "User",
                        "Term",
                        "Code",
                        "Path",
                        "Status",
                        "Action",
                        "System Action",
                        "Comment"});
            table8.AddRow(new string[] {
                        "<DevStudyName>",
                        "Adverse Event Term 2",
                        "System User",
                        "",
                        "",
                        "",
                        "Start",
                        "",
                        "",
                        "Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAuto" +
                            "Approval=true,IsBypassTransmit=True]"});
            table8.AddRow(new string[] {
                        "<DevStudyName>",
                        "Adverse Event Term 2",
                        "System User",
                        "",
                        "",
                        "",
                        "Waiting Manual Code",
                        "Start Auto Code",
                        "",
                        ""});
#line 117
  testRunner.Then("the Coding History Report should contain the following", ((string)(null)), table8, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
