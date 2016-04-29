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
    [NUnit.Framework.DescriptionAttribute("This feature file will verify Project Registration")]
    [NUnit.Framework.CategoryAttribute("specProjectRegistration.feature")]
    [NUnit.Framework.CategoryAttribute("CoderCore")]
    public partial class ThisFeatureFileWillVerifyProjectRegistrationFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specProjectRegistration.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "This feature file will verify Project Registration", "\r\n_ Project = iMedidata Study (if the study is a production study, then its envs " +
                    "will also be registered)", ProgrammingLanguage.CSharp, new string[] {
                        "specProjectRegistration.feature",
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
        [NUnit.Framework.DescriptionAttribute("The user will have ability to add new registration tables")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168480_001")]
        [NUnit.Framework.Timeout(600000)]
        public virtual void TheUserWillHaveAbilityToAddNewRegistrationTables()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("The user will have ability to add new registration tables", new string[] {
                        "VAL",
                        "Release2015.3.0",
                        "PBMCC_168480_001",
                        "IncreaseTimeout"});
#line 11
this.ScenarioSetup(scenarioInfo);
#line 13
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 11" +
                    ".0\" unregistered", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Project",
                        "Dictionary",
                        "Version",
                        "Locale",
                        "SynonymListName",
                        "RegistrationName"});
            table1.AddRow(new string[] {
                        "<Project>",
                        "MedDRA",
                        "11.0",
                        "eng",
                        "Primary List",
                        "MedDRA"});
            table1.AddRow(new string[] {
                        "<Project>",
                        "MedDRA",
                        "11.0",
                        "eng",
                        "Primary List",
                        "MedDRAMedHistory"});
#line 14
 testRunner.When("registering a project with the following options", ((string)(null)), table1, "When ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Project",
                        "Dictionary",
                        "Version",
                        "Locale",
                        "SynonymListName",
                        "RegistrationName"});
            table2.AddRow(new string[] {
                        "<Project>",
                        "MedDRA",
                        "11.0",
                        "eng",
                        "Primary List",
                        "MedDRA"});
            table2.AddRow(new string[] {
                        "<Project>",
                        "MedDRA",
                        "11.0",
                        "eng",
                        "Primary List",
                        "MedDRAMedHistory"});
#line 18
 testRunner.Then("the following content should be registered", ((string)(null)), table2, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("The user will have ability to add new registration tables with different language" +
            "s")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168480_002")]
        [NUnit.Framework.Timeout(600000)]
        public virtual void TheUserWillHaveAbilityToAddNewRegistrationTablesWithDifferentLanguages()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("The user will have ability to add new registration tables with different language" +
                    "s", new string[] {
                        "VAL",
                        "Release2015.3.0",
                        "PBMCC_168480_002",
                        "IncreaseTimeout"});
#line 27
this.ScenarioSetup(scenarioInfo);
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "SynonymListName",
                        "Dictionary",
                        "Version",
                        "Locale"});
            table3.AddRow(new string[] {
                        "Primary List",
                        "MedDRA",
                        "11.0",
                        "JPN"});
            table3.AddRow(new string[] {
                        "Primary List",
                        "MedDRA",
                        "11.0",
                        "ENG"});
#line 29
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and unregistered dictionaries" +
                    "", ((string)(null)), table3, "Given ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Project",
                        "Dictionary",
                        "Version",
                        "Locale",
                        "SynonymListName",
                        "RegistrationName"});
            table4.AddRow(new string[] {
                        "<Project>",
                        "MedDRA",
                        "11.0",
                        "jpn",
                        "Primary List",
                        "MedDRA"});
            table4.AddRow(new string[] {
                        "<Project>",
                        "MedDRA",
                        "11.0",
                        "eng",
                        "Primary List",
                        "MedDRA"});
#line 33
 testRunner.When("registering a project with the following options", ((string)(null)), table4, "When ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Project",
                        "Dictionary",
                        "Version",
                        "Locale",
                        "SynonymListName",
                        "RegistrationName"});
            table5.AddRow(new string[] {
                        "<Project>",
                        "MedDRA",
                        "11.0",
                        "jpn",
                        "Primary List",
                        "MedDRA"});
            table5.AddRow(new string[] {
                        "<Project>",
                        "MedDRA",
                        "11.0",
                        "eng",
                        "Primary List",
                        "MedDRA"});
#line 37
 testRunner.Then("the following content should be registered", ((string)(null)), table5, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Registering a project with a second identical empty synonym list should overwrite" +
            " the previous registration")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.3")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168480_002a")]
        [NUnit.Framework.Timeout(600000)]
        public virtual void RegisteringAProjectWithASecondIdenticalEmptySynonymListShouldOverwriteThePreviousRegistration()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Registering a project with a second identical empty synonym list should overwrite" +
                    " the previous registration", new string[] {
                        "VAL",
                        "Release2015.3.3",
                        "PBMCC_168480_002a",
                        "IncreaseTimeout"});
#line 46
this.ScenarioSetup(scenarioInfo);
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "SynonymListName",
                        "Dictionary",
                        "Version",
                        "Locale"});
            table6.AddRow(new string[] {
                        "Primary List",
                        "MedDRA",
                        "11.0",
                        "ENG"});
            table6.AddRow(new string[] {
                        "Second List",
                        "MedDRA",
                        "11.0",
                        "ENG"});
#line 48
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and unregistered dictionaries" +
                    "", ((string)(null)), table6, "Given ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Project",
                        "Dictionary",
                        "Version",
                        "Locale",
                        "SynonymListName",
                        "RegistrationName"});
            table7.AddRow(new string[] {
                        "<Project>",
                        "MedDRA",
                        "11.0",
                        "eng",
                        "Primary List",
                        "MedDRA"});
            table7.AddRow(new string[] {
                        "<Project>",
                        "MedDRA",
                        "11.0",
                        "eng",
                        "Second List",
                        "MedDRA"});
#line 52
 testRunner.When("registering a project with the following options", ((string)(null)), table7, "When ");
#line hidden
            TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {
                        "Project",
                        "Dictionary",
                        "Version",
                        "Locale",
                        "SynonymListName",
                        "RegistrationName"});
            table8.AddRow(new string[] {
                        "<Project>",
                        "MedDRA",
                        "11.0",
                        "eng",
                        "Second List",
                        "MedDRA"});
#line 56
 testRunner.Then("the following content should be registered", ((string)(null)), table8, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("The user will see success message when dictionary has been registered to project")]
        [NUnit.Framework.IgnoreAttribute()]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168480_003")]
        public virtual void TheUserWillSeeSuccessMessageWhenDictionaryHasBeenRegisteredToProject()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("The user will see success message when dictionary has been registered to project", new string[] {
                        "DFT",
                        "Release2015.3.0",
                        "PBMCC_168480_003",
                        "ignore"});
#line 65
this.ScenarioSetup(scenarioInfo);
#line 67
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 11" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table9 = new TechTalk.SpecFlow.Table(new string[] {
                        "Project",
                        "Dictionary",
                        "Version",
                        "Locale",
                        "SynonymListName",
                        "RegistrationName"});
            table9.AddRow(new string[] {
                        "<Project>",
                        "MedDRA",
                        "11.0",
                        "Eng",
                        "Primary",
                        "MedDRAHistory"});
#line 68
 testRunner.When("registering a project with the following options", ((string)(null)), table9, "When ");
#line 71
 testRunner.Then("I should see success message \"Dictionary has been successfully registered to <pro" +
                    "ject> Project\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("The user should see registry history when project registration history is toggled" +
            "")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168480_004")]
        public virtual void TheUserShouldSeeRegistryHistoryWhenProjectRegistrationHistoryIsToggled()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("The user should see registry history when project registration history is toggled" +
                    "", new string[] {
                        "VAL",
                        "Release2015.3.0",
                        "PBMCC_168480_004"});
#line 76
this.ScenarioSetup(scenarioInfo);
#line 78
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"WhoDrugDDEB2 " +
                    "ENG 200703\" unregistered", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table10 = new TechTalk.SpecFlow.Table(new string[] {
                        "Project",
                        "Dictionary",
                        "Version",
                        "Locale",
                        "SynonymListName",
                        "RegistrationName"});
            table10.AddRow(new string[] {
                        "<Project>",
                        "WhoDrugDDEB2",
                        "200703",
                        "eng",
                        "Primary List",
                        "WHODrug-DDE-B2"});
#line 79
 testRunner.When("registering a project with the following options", ((string)(null)), table10, "When ");
#line hidden
            TechTalk.SpecFlow.Table table11 = new TechTalk.SpecFlow.Table(new string[] {
                        "User",
                        "ProjectRegistrationSucceeded",
                        "DictionaryAndVersions",
                        "Created"});
            table11.AddRow(new string[] {
                        "<User>",
                        "Checked",
                        "WhoDrugDDEB2(WHODrug-DDE-B2):200703",
                        "<TimeStamp>"});
#line 82
 testRunner.Then("Registration History contains following information", ((string)(null)), table11, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("The user should be able to verify three projects were registered")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168480_005")]
        [NUnit.Framework.Timeout(600000)]
        public virtual void TheUserShouldBeAbleToVerifyThreeProjectsWereRegistered()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("The user should be able to verify three projects were registered", new string[] {
                        "VAL",
                        "Release2015.3.0",
                        "PBMCC_168480_005",
                        "IncreaseTimeout"});
#line 90
this.ScenarioSetup(scenarioInfo);
#line 92
 testRunner.Given("a \"Waiting Approval\" Coder setup with no tasks and no synonyms and dictionary \"Wh" +
                    "oDrugDDEB2 ENG 200703\" unregistered", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table12 = new TechTalk.SpecFlow.Table(new string[] {
                        "Project",
                        "Dictionary",
                        "Version",
                        "Locale",
                        "SynonymListName",
                        "RegistrationName"});
            table12.AddRow(new string[] {
                        "<Project>",
                        "WhoDrugDDEB2",
                        "200703",
                        "eng",
                        "Primary List",
                        "WHODrug-DDE-B2"});
#line 93
 testRunner.When("registering a project with the following options", ((string)(null)), table12, "When ");
#line hidden
            TechTalk.SpecFlow.Table table13 = new TechTalk.SpecFlow.Table(new string[] {
                        "Study Id",
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
            table13.AddRow(new string[] {
                        "Production",
                        "3-BENZHYDRYLOXY-8-ISOPROPYL-NORTROPAN MESILA.",
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
                        "WHODrug-DDE-B2",
                        "PRODUCTSYNONYM",
                        "TRUE",
                        "FALSE"});
            table13.AddRow(new string[] {
                        "Development",
                        "Allergy to Venom",
                        "SupTermFieldA",
                        "Sup Term Value 1",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "WHODrug-DDE-B2",
                        "PRODUCTSYNONYM",
                        "TRUE",
                        "FALSE"});
            table13.AddRow(new string[] {
                        "UserAcceptanceTesting",
                        "Blood Builder",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "WHODrug-DDE-B2",
                        "PRODUCTSYNONYM",
                        "TRUE",
                        "TRUE"});
#line 96
 testRunner.And("uploading MEV content and AutoCoding is complete", ((string)(null)), table13, "And ");
#line hidden
            TechTalk.SpecFlow.Table table14 = new TechTalk.SpecFlow.Table(new string[] {
                        "Term",
                        "Study"});
            table14.AddRow(new string[] {
                        "3-BENZHYDRYLOXY-8-ISOPROPYL-NORTROPAN MESILA.",
                        "<Project>"});
            table14.AddRow(new string[] {
                        "Allergy to Venom",
                        "<Project> (Dev)"});
            table14.AddRow(new string[] {
                        "BLOOD BUILDER",
                        "<Project> (UAT)"});
#line 101
 testRunner.Then("all studies for Project are registered and MEV content is loaded", ((string)(null)), table14, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
