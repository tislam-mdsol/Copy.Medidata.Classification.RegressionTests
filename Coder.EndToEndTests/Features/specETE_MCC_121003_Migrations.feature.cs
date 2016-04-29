﻿// ------------------------------------------------------------------------------
//  <auto-generated>
//      This code was generated by SpecFlow (http://www.specflow.org/).
//      SpecFlow Version:1.9.0.77
//      SpecFlow Generator Version:1.9.0.0
//      Runtime Version:4.0.30319.34209
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
    [NUnit.Framework.DescriptionAttribute("Verify MCC_121003 Migrations")]
    public partial class VerifyMCC_121003MigrationsFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specETE_MCC_121003_Migrations.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Verify MCC_121003 Migrations", "", ProgrammingLanguage.CSharp, ((string[])(null)));
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
        [NUnit.Framework.DescriptionAttribute(@"Enter project registration in Coder, setup Rave study with Coder Coding fields, enter data in EDC, migrate study in Rave from Medidata Coder Coding to Medidata Coder Coding but with different coding level, then verify terms appear in Coder after migration.")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("Release2016.2.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_207807_1.1.2_001")]
        public virtual void EnterProjectRegistrationInCoderSetupRaveStudyWithCoderCodingFieldsEnterDataInEDCMigrateStudyInRaveFromMedidataCoderCodingToMedidataCoderCodingButWithDifferentCodingLevelThenVerifyTermsAppearInCoderAfterMigration_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo(@"Enter project registration in Coder, setup Rave study with Coder Coding fields, enter data in EDC, migrate study in Rave from Medidata Coder Coding to Medidata Coder Coding but with different coding level, then verify terms appear in Coder after migration.", new string[] {
                        "DFT",
                        "Release2016.2.0",
                        "PBMCC_207807_1.1.2_001"});
#line 6
this.ScenarioSetup(scenarioInfo);
#line 7
 testRunner.Given("a Rave project registration with dictionary \"WhoDrugDDEB2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
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
                        "IsAutoApproval"});
            table1.AddRow(new string[] {
                        "ETE2",
                        "AETerm",
                        "<Dictionary>",
                        "<Locale>",
                        "PRODUCT",
                        "1",
                        "true",
                        "true"});
#line 9
 testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 12
 testRunner.When("a Rave Draft is published using draft \"<Draft>\" for Project \"<SourceSystemStudyNa" +
                    "me>\" to environment \"Production\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
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
                        "",
                        ""});
#line 14
 testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table2, "And ");
#line 17
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
#line 18
 testRunner.Then("Rave Adverse Events form \"ETE2\" should display", ((string)(null)), table3, "Then ");
#line 24
 testRunner.When("a Rave Draft is published with form \"ETE2\" in draft \"Draft 1\" for Project \"RaveCo" +
                    "derProject\" with coding dictionary set to", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "Coding Level",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval"});
            table4.AddRow(new string[] {
                        "ETE2",
                        "AETerm",
                        "<Dictionary>",
                        "<Locale>",
                        "PRODUCTSYNONYM",
                        "1",
                        "true",
                        "true"});
#line 25
 testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table4, "And ");
#line 29
 testRunner.And("an Amendment Manager migration is started with \"SETE5<CoderRaveStudy>\" in \"AM Sub" +
                    "ject Search\" and \"SETE5<CoderRaveStudy>\" in \"Rave Migration Subject Seletion Dro" +
                    "pdown\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 30
 testRunner.Then("Rave Adverse Events form \"ETE2\" should not display \"BAYER CHILDREN\'S COLD\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 31
 testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Source System",
                        "Study",
                        "Dictionary",
                        "Locale",
                        "Term",
                        "Level",
                        "Priority"});
            table5.AddRow(new string[] {
                        "<SourceSystem>",
                        "<SourceSystemStudyDisplayName>",
                        "WhoDrugDDEB2 - 200703",
                        "ENG",
                        "Drug Verbatim 15",
                        "Trade Name",
                        "1"});
#line 32
 testRunner.And("I verify the following Source Term information is displayed", ((string)(null)), table5, "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute(@"Enter project registration in Coder, setup Rave study with Coder Coding fields, enter data in EDC, migrate study in Rave from Medidata Coder Coding to Medidata Coder Coding but with adding supplemental value, then verify terms appear in Coder after migration.")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("PBMCC121003_3")]
        [NUnit.Framework.CategoryAttribute("Release2015.1.0")]
        public virtual void EnterProjectRegistrationInCoderSetupRaveStudyWithCoderCodingFieldsEnterDataInEDCMigrateStudyInRaveFromMedidataCoderCodingToMedidataCoderCodingButWithAddingSupplementalValueThenVerifyTermsAppearInCoderAfterMigration_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo(@"Enter project registration in Coder, setup Rave study with Coder Coding fields, enter data in EDC, migrate study in Rave from Medidata Coder Coding to Medidata Coder Coding but with adding supplemental value, then verify terms appear in Coder after migration.", new string[] {
                        "DFT",
                        "PBMCC121003_3",
                        "Release2015.1.0"});
#line 39
this.ScenarioSetup(scenarioInfo);
#line 40
 testRunner.Given("a Rave project registration with dictionary \"WhoDrugDDEB2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 41
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 42
 testRunner.And("a Rave Coder setup with the following options", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
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
                        "ETE2",
                        "AETerm",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "2",
                        "true",
                        "true",
                        "LogSuppField2"});
#line 43
 testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table6, "And ");
#line 46
 testRunner.When("a Rave Draft is published and pushed using draft \"<Draft>\" for Project \"<SourceSy" +
                    "stemStudyName>\" to environment \"Production\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 47
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType",
                        "Control Value"});
            table7.AddRow(new string[] {
                        "Coding Field",
                        "Drug Verbatim 1",
                        "LongText",
                        ""});
#line 48
 testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table7, "And ");
#line 51
 testRunner.When("task \"Drug Verbatim 1\" is coded to term \"BAYER CHILDREN\'S COLD\" at search level \"" +
                    "Preferred Name\" with code \"005581 01 001\" at level \"PN\" and a synonym is created" +
                    "", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
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
#line 52
 testRunner.Then("Rave Adverse Events form \"ETE2\" should display", ((string)(null)), table8, "Then ");
#line hidden
            TechTalk.SpecFlow.Table table9 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table9.AddRow(new string[] {
                        "Coder Field",
                        "Drug Verbatim 1",
                        "LongText"});
            table9.AddRow(new string[] {
                        "Log Supp Field 2",
                        "Top",
                        ""});
#line 58
 testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table9, "And ");
#line 62
 testRunner.When("a Rave Draft is published and pushed using draft \"<Draft>\" for Project \"<SourceSy" +
                    "stemStudyName>\" to environment \"Production\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 63
 testRunner.And("an Amendment Manager migration is started with \"SETE5<CoderRaveStudy>\" in \"AM Sub" +
                    "ject Search\" and \"SETE5<CoderRaveStudy>\" in \"Rave Migration Subject Seletion Dro" +
                    "pdown\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 64
 testRunner.Then("Rave Adverse Events form \"ETE2\" should not display \"BAYER CHILDREN\'S COLD\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 65
 testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table10 = new TechTalk.SpecFlow.Table(new string[] {
                        "Supplemental Term",
                        "Supplemental Value"});
            table10.AddRow(new string[] {
                        "LogSuppField2",
                        "Top"});
#line 66
 testRunner.And("I verify the following Supplemental information is displayed", ((string)(null)), table10, "And ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
