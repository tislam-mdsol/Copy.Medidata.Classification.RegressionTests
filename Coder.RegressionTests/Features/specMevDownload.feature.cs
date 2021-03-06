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
    [NUnit.Framework.DescriptionAttribute("A user is able to download coding and query information from within the Manage Ex" +
        "ternal Verbatim page.")]
    [NUnit.Framework.CategoryAttribute("specMevDownload.feature")]
    [NUnit.Framework.CategoryAttribute("CoderCore")]
    public partial class AUserIsAbleToDownloadCodingAndQueryInformationFromWithinTheManageExternalVerbatimPage_Feature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specMevDownload.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "A user is able to download coding and query information from within the Manage Ex" +
                    "ternal Verbatim page.", "", ProgrammingLanguage.CSharp, new string[] {
                        "specMevDownload.feature",
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
        [NUnit.Framework.DescriptionAttribute("Coder will provide the user with the ability to extract imported data")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168482_001")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.Timeout(900000)]
        public virtual void CoderWillProvideTheUserWithTheAbilityToExtractImportedData()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Coder will provide the user with the ability to extract imported data", new string[] {
                        "VAL",
                        "PBMCC_168482_001",
                        "Release2015.3.0",
                        "IncreaseTimeout_900000"});
#line 9
this.ScenarioSetup(scenarioInfo);
#line 11
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 11" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Supplemental Field 1",
                        "Supplemental Value 1",
                        "Supplemental Field 2",
                        "Supplemental Value 2",
                        "Supplemental Field 3",
                        "Supplemental Value 3",
                        "Supplemental Field 4",
                        "Supplemental Value 4",
                        "Supplemental Field 5",
                        "Supplemental Value 5",
                        "Dictionary",
                        "Dictionary Level",
                        "Is Approval Required",
                        "Is Auto Approval"});
            table1.AddRow(new string[] {
                        "Headache",
                        "SupTermFieldA",
                        "Sup Term Value 1",
                        "SupTermFieldB",
                        "Sup Term Value 2",
                        "SupTermFieldC",
                        "Sup Term Value 3",
                        "SupTermFieldD",
                        "Sup Term Value 4",
                        "SupTermFieldE",
                        "Sup Term Value 5",
                        "MedDRA",
                        "LLT",
                        "FALSE",
                        "TRUE"});
#line 12
 testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table1, "When ");
#line 15
 testRunner.Then("task \"HEADACHE\" is available within reclassification", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 16
 testRunner.When("downloading MEV file", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Study ID",
                        "Verbatim Term",
                        "Dictionary Version Locale",
                        "Supplemental Field 1",
                        "Supplemental Value 1",
                        "Supplemental Field 2",
                        "Supplemental Value 2",
                        "Level 1",
                        "Level 1 Text",
                        "Level 1 Code",
                        "Level 2",
                        "Level 2 Text",
                        "Level 2 Code",
                        "Level 3",
                        "Level 3 Text",
                        "Level 3 Code",
                        "Level 4",
                        "Level 4 Text",
                        "Level 4 Code",
                        "Level 5",
                        "Level 5 Text",
                        "Level 5 Code"});
            table2.AddRow(new string[] {
                        "<StudyName>",
                        "Headache",
                        "MedDRA-11_0-English",
                        "SupTermFieldA",
                        "Sup Term Value 1",
                        "SupTermFieldB",
                        "Sup Term Value 2",
                        "SOC",
                        "Nervous system disorders",
                        "10029205",
                        "HLGT",
                        "Headaches",
                        "10019231",
                        "HLT",
                        "Headaches NEC",
                        "10019233",
                        "PT",
                        "Headache",
                        "10019211",
                        "LLT",
                        "Headache",
                        "10019211"});
#line 17
 testRunner.Then("the downloaded MEV file should contain the following external verbatims", ((string)(null)), table2, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify a coding task that goes to a seventh level where it is displayed in the Do" +
            "wnload coding tasks csv")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168482_002")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.Timeout(900000)]
        public virtual void VerifyACodingTaskThatGoesToASeventhLevelWhereItIsDisplayedInTheDownloadCodingTasksCsv()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify a coding task that goes to a seventh level where it is displayed in the Do" +
                    "wnload coding tasks csv", new string[] {
                        "VAL",
                        "PBMCC_168482_002",
                        "Release2015.3.0",
                        "IncreaseTimeout_900000"});
#line 25
this.ScenarioSetup(scenarioInfo);
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "ListName",
                        "Dictionary",
                        "Version",
                        "Locale"});
            table3.AddRow(new string[] {
                        "Primary ",
                        "MedDRA   ",
                        "16.0   ",
                        "JPN   "});
            table3.AddRow(new string[] {
                        "Primary ",
                        "JDrug     ",
                        "2013H1 ",
                        "JPN   "});
#line 27
    testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionries", ((string)(null)), table3, "Given ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Dictionary",
                        "Dictionary Level",
                        "Is Approval Required",
                        "Is Auto Approval",
                        "Locale"});
            table4.AddRow(new string[] {
                        "アセチルコリン塩化物",
                        "JDrug",
                        "DrugName",
                        "FALSE",
                        "TRUE",
                        "jpn"});
#line 31
 testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table4, "When ");
#line 34
 testRunner.Then("task \"アセチルコリン塩化物\" is available within reclassification for dictionary \"J-Drug\" ve" +
                    "rsion \"2013H1\" locale \"JPN\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 35
 testRunner.When("downloading MEV file", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level 7 Text",
                        "Level 7 Code"});
            table5.AddRow(new string[] {
                        "アセチルコリン塩化物",
                        "1232401"});
#line 36
 testRunner.Then("the downloaded MEV file should contain the following external verbatims", ((string)(null)), table5, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A CSV task with an open query will be removed from the UI and upon downloading th" +
            "e report, it will contain a status of Open")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168482_003")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.Timeout(900000)]
        public virtual void ACSVTaskWithAnOpenQueryWillBeRemovedFromTheUIAndUponDownloadingTheReportItWillContainAStatusOfOpen()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A CSV task with an open query will be removed from the UI and upon downloading th" +
                    "e report, it will contain a status of Open", new string[] {
                        "VAL",
                        "PBMCC_168482_003",
                        "Release2015.3.0",
                        "IncreaseTimeout_900000"});
#line 45
this.ScenarioSetup(scenarioInfo);
#line 47
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 11" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Supplemental Field 1",
                        "Supplemental Value 1",
                        "Dictionary",
                        "Dictionary Level",
                        "Is Approval Required",
                        "Is Auto Approval"});
            table6.AddRow(new string[] {
                        "Major Big Painful Headache",
                        "SupFieldA",
                        "Sup1",
                        "MedDRA",
                        "LLT",
                        "FALSE",
                        "TRUE"});
#line 48
 testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table6, "When ");
#line 51
 testRunner.And("opening a query for task \"MAJOR BIG PAINFUL HEADACHE\" with comment \"Opening query" +
                    ", removing the invalid task.\" and not waiting for the task query status to updat" +
                    "e", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 52
 testRunner.And("downloading MEV file", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Coder Username",
                        "Query Value",
                        "Query Status"});
            table7.AddRow(new string[] {
                        "Major Big Painful Headache",
                        "<UserDisplayName>",
                        "\"Opening query, removing the invalid task.\"",
                        "Open"});
#line 53
 testRunner.Then("the downloaded MEV file should contain the following external verbatims", ((string)(null)), table7, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify download filter MEV Study affects export file correctly")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168482_004")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.Timeout(900000)]
        public virtual void VerifyDownloadFilterMEVStudyAffectsExportFileCorrectly()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify download filter MEV Study affects export file correctly", new string[] {
                        "VAL",
                        "PBMCC_168482_004",
                        "Release2015.3.0",
                        "IncreaseTimeout_900000"});
#line 62
this.ScenarioSetup(scenarioInfo);
#line hidden
            TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {
                        "ListName",
                        "Dictionary",
                        "Version",
                        "Locale"});
            table8.AddRow(new string[] {
                        "Primary ",
                        "MedDRA   ",
                        "11.0   ",
                        "ENG   "});
            table8.AddRow(new string[] {
                        "Primary ",
                        "WhoDrugDDEB2     ",
                        "201203 ",
                        "ENG   "});
#line 64
    testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionries", ((string)(null)), table8, "Given ");
#line hidden
            TechTalk.SpecFlow.Table table9 = new TechTalk.SpecFlow.Table(new string[] {
                        "Study Id",
                        "Verbatim Term",
                        "Dictionary",
                        "Dictionary Level",
                        "Is Approval Required",
                        "Is Auto Approval"});
            table9.AddRow(new string[] {
                        "Development",
                        "PAIN AID PLUS",
                        "WhoDrugDDEB2",
                        "PRODUCTSYNONYM",
                        "FALSE",
                        "TRUE"});
            table9.AddRow(new string[] {
                        "Production",
                        "NEOLAMIN MULTI YAM",
                        "WhoDrugDDEB2",
                        "PRODUCTSYNONYM",
                        "FALSE",
                        "TRUE"});
            table9.AddRow(new string[] {
                        "Development",
                        "NATURES OWN ZN AND C NATURAL ORANGE FLAVOUR",
                        "WhoDrugDDEB2",
                        "PRODUCTSYNONYM",
                        "FALSE",
                        "TRUE"});
            table9.AddRow(new string[] {
                        "Development",
                        "DEATH ADDER ANTIVN",
                        "WhoDrugDDEB2",
                        "PRODUCTSYNONYM",
                        "FALSE",
                        "TRUE"});
            table9.AddRow(new string[] {
                        "Development",
                        "DEATH ADDER ANTIVENOM",
                        "WhoDrugDDEB2",
                        "PRODUCTSYNONYM",
                        "FALSE",
                        "TRUE"});
            table9.AddRow(new string[] {
                        "Development",
                        "Feeling happy inappropriately",
                        "MedDRA",
                        "LLT",
                        "FALSE",
                        "TRUE"});
            table9.AddRow(new string[] {
                        "Production",
                        "Heavy cigarette smoker",
                        "MedDRA",
                        "LLT",
                        "FALSE",
                        "TRUE"});
            table9.AddRow(new string[] {
                        "Development",
                        "Cigarette smoker",
                        "MedDRA",
                        "LLT",
                        "FALSE",
                        "TRUE"});
            table9.AddRow(new string[] {
                        "Development",
                        "Feeling sad",
                        "MedDRA",
                        "LLT",
                        "FALSE",
                        "TRUE"});
            table9.AddRow(new string[] {
                        "Development",
                        "Impending doom",
                        "MedDRA",
                        "LLT",
                        "FALSE",
                        "TRUE"});
#line 68
 testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table9, "When ");
#line 80
 testRunner.And("downloading MEV file", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table10 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Level 5 Text"});
            table10.AddRow(new string[] {
                        "NEOLAMIN MULTI YAM",
                        "NEOLAMIN MULTI /05665101/"});
            table10.AddRow(new string[] {
                        "Heavy cigarette smoker",
                        "Heavy cigarette smoker"});
#line 81
 testRunner.Then("the downloaded MEV file should contain the following external verbatims", ((string)(null)), table10, "Then ");
#line 85
 testRunner.And("only \"3\" rows are present in the csv file", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("An uploaded 5000 task csv file is able to be downloaded")]
        [NUnit.Framework.CategoryAttribute("VALLongRunningTask")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168482_005")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.Timeout(1800000)]
        public virtual void AnUploaded5000TaskCsvFileIsAbleToBeDownloaded()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("An uploaded 5000 task csv file is able to be downloaded", new string[] {
                        "VALLongRunningTask",
                        "PBMCC_168482_005",
                        "Release2015.3.0",
                        "IncreaseTimeout_1800000"});
#line 91
this.ScenarioSetup(scenarioInfo);
#line hidden
            TechTalk.SpecFlow.Table table11 = new TechTalk.SpecFlow.Table(new string[] {
                        "SynonymListName",
                        "Dictionary",
                        "Version",
                        "Locale"});
            table11.AddRow(new string[] {
                        "WhoDrugDDEB2_DDM",
                        "WhoDrugDDEB2",
                        "201306",
                        "ENG"});
#line 93
    testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionaries", ((string)(null)), table11, "Given ");
#line 96
 testRunner.When("uploading synonym list file \"WHODrug_DDEB2_201306_5kSynonym.txt\" to \"WhoDrugDDEB2" +
                    " ENG 201306 WhoDrugDDEB2_DDM\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 97
 testRunner.And("uploading \"5000\" WhoDrug tasks", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 98
 testRunner.Then("\"5000\" tasks are processed by the workflow", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 99
 testRunner.When("downloading MEV file", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 100
 testRunner.Then("only \"5001\" rows are present in the csv file", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
