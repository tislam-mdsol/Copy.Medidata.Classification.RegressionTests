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
    [NUnit.Framework.DescriptionAttribute("Verify Rave Coder Migrations")]
    [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
    public partial class VerifyRaveCoderMigrationsFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specETE_ENGRaveCoderMigrations.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Verify Rave Coder Migrations", "", ProgrammingLanguage.CSharp, new string[] {
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
        [NUnit.Framework.DescriptionAttribute("For a coding field in Rave when submitting a verbatim, the term should be accepte" +
            "d by Coder to create a manually created coding decision that should be reflected" +
            " in Rave using ammendment manager")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("Release2016.2.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_207807_1.1.2_001")]
        public virtual void ForACodingFieldInRaveWhenSubmittingAVerbatimTheTermShouldBeAcceptedByCoderToCreateAManuallyCreatedCodingDecisionThatShouldBeReflectedInRaveUsingAmmendmentManager()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("For a coding field in Rave when submitting a verbatim, the term should be accepte" +
                    "d by Coder to create a manually created coding decision that should be reflected" +
                    " in Rave using ammendment manager", new string[] {
                        "DFT",
                        "Release2016.2.0",
                        "PBMCC_207807_1.1.2_001"});
#line 11
this.ScenarioSetup(scenarioInfo);
#line 12
 testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 12.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
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
                        "ETE5",
                        "CoderField5",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "true",
                        ""});
#line 14
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 17
 testRunner.When("a Rave Draft is published and pushed using draft \"<Draft>\" for Project \"<StudyNam" +
                    "e>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 18
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table2.AddRow(new string[] {
                        "AdverseEvent1",
                        "TERRIBLE HEAD PAIN",
                        ""});
#line 19
 testRunner.And("adding a new verbatim term to form \"ETE5\"", ((string)(null)), table2, "And ");
#line 22
 testRunner.Then("an Amendment Manager migration is started with \"SETE5<CoderRaveStudy>\" in \"AM Sub" +
                    "ject Search\" and \"SETE5<CoderRaveStudy>\" in \"Rave Migration Subject Seletion Dro" +
                    "pdown\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 23
 testRunner.And("Rave Adverse Events form \"ETE5\" should display \"CHILDRENS ADVIL COLD\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 24
 testRunner.And("Coder tasks should display \"terrible head pain\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("For a coding field in Rave when submitting a verbatim, the term should be accepte" +
            "d by Coder to create a manually created coding decision that should be reflected" +
            " in Rave.")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("Release2016.2.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_207807_1.1.2_002")]
        public virtual void ForACodingFieldInRaveWhenSubmittingAVerbatimTheTermShouldBeAcceptedByCoderToCreateAManuallyCreatedCodingDecisionThatShouldBeReflectedInRave_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("For a coding field in Rave when submitting a verbatim, the term should be accepte" +
                    "d by Coder to create a manually created coding decision that should be reflected" +
                    " in Rave.", new string[] {
                        "DFT",
                        "Release2016.2.0",
                        "PBMCC_207807_1.1.2_002"});
#line 29
this.ScenarioSetup(scenarioInfo);
#line 30
 testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 11.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 31
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "CodingLevel",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table3.AddRow(new string[] {
                        "ETE5",
                        "CoderField5",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "true",
                        ""});
#line 32
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table3, "And ");
#line 35
 testRunner.When("a Rave Draft is published and pushed using draft \"<Draft>\" for Project \"<StudyNam" +
                    "e>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 36
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table4.AddRow(new string[] {
                        "AdverseEvent1",
                        "TERRIBLE HEAD PAIN",
                        ""});
#line 37
 testRunner.And("adding a new verbatim term to form \"ETE5\"", ((string)(null)), table4, "And ");
#line 40
 testRunner.When("task \"terrible head pain\" is coded to term \"Biopsy skin\" at search level \"Low Lev" +
                    "el Term\" with code \"10004873\" at level \"LLT\" and a synonym is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 41
 testRunner.And("a new synonym list is created for \"MedDRA ENG 11.1\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 42
 testRunner.And("a study impact analsis migration is performed between \"MedDRA ENG 11.0\" to \"MedDR" +
                    "A ENG 11.1\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 43
 testRunner.And("a Rave submitted coding task \"terrible head pain\" for subject \"CoderSubject\" on f" +
                    "ield \"Coding Field\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term"});
            table5.AddRow(new string[] {
                        "SOC",
                        "10022891",
                        "Investigations"});
            table5.AddRow(new string[] {
                        "HLGT",
                        "10040879",
                        "Skin investigations"});
            table5.AddRow(new string[] {
                        "HLT",
                        "10040862",
                        "Skin histopathology procedures"});
            table5.AddRow(new string[] {
                        "PT",
                        "10004873",
                        "Biopsy skin"});
            table5.AddRow(new string[] {
                        "LLT",
                        "10004873",
                        "Biopsy skin"});
#line 44
 testRunner.Then("Rave should contain the following coding decision information for subject \"CoderS" +
                    "ubject\" on field \"Coding Field\"", ((string)(null)), table5, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute(@"Enter project registration in Coder, setup Rave study, enter verbatim in Rave, code verbatim in Coder and create synonym rule, migrate study to new version in Coder, migrate synonym to new version in Coder, enter verbatim term again in Rave, verify term gets autocoded and results display in Rave")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("Release2016.2.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_207807_1.1.2_003")]
        public virtual void EnterProjectRegistrationInCoderSetupRaveStudyEnterVerbatimInRaveCodeVerbatimInCoderAndCreateSynonymRuleMigrateStudyToNewVersionInCoderMigrateSynonymToNewVersionInCoderEnterVerbatimTermAgainInRaveVerifyTermGetsAutocodedAndResultsDisplayInRave()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo(@"Enter project registration in Coder, setup Rave study, enter verbatim in Rave, code verbatim in Coder and create synonym rule, migrate study to new version in Coder, migrate synonym to new version in Coder, enter verbatim term again in Rave, verify term gets autocoded and results display in Rave", new string[] {
                        "DFT",
                        "Release2016.2.0",
                        "PBMCC_207807_1.1.2_003"});
#line 55
this.ScenarioSetup(scenarioInfo);
#line 56
 testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 11.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 57
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
                        "ETE5",
                        "CoderField5",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "true",
                        ""});
#line 58
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table6, "And ");
#line 61
 testRunner.When("a Rave Draft is published and pushed using draft \"<Draft>\" for Project \"<StudyNam" +
                    "e>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 62
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table7.AddRow(new string[] {
                        "AdverseEvent1",
                        "TERRIBLE HEAD PAIN",
                        ""});
#line 63
 testRunner.And("adding a new verbatim term to form \"ETE5\"", ((string)(null)), table7, "And ");
#line 66
 testRunner.When("task \"tail bone bleeding\" is coded to term \"headache\" at search level \"Low Level " +
                    "Term\" with code \"10019211\" at level \"LLT\" and a synonym is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 67
 testRunner.And("a new synonym list is created for \"MedDRA ENG 11.1\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 68
 testRunner.And("a study impact analsis migration is performed between \"MedDRA ENG 11.0\" to \"MedDR" +
                    "A ENG 11.1\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 69
 testRunner.And("number of migrations should display \"1\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 70
 testRunner.And("a Rave submitted coding task \"terrible head pain\" for subject \"CoderSubject\" on f" +
                    "ield \"Coding Field\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term"});
            table8.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "Nervous system disorders"});
            table8.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "Headaches"});
            table8.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "Headaches NEC"});
            table8.AddRow(new string[] {
                        "PT",
                        "10019211",
                        "Headache"});
            table8.AddRow(new string[] {
                        "LLT",
                        "10019211",
                        "Headache"});
#line 71
 testRunner.Then("Rave should contain the following coding decision information for subject \"CoderS" +
                    "ubject\" on field \"Coding Field\"", ((string)(null)), table8, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Enter project registration in Coder, setup Rave study with Classic Coding fields," +
            " enter data in EDC, migrate study in Rave from Classic Coding to Medidata Coder," +
            " Verify terms appear in Coder after migration")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("Release2016.2.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_207807_1.1.2_004")]
        public virtual void EnterProjectRegistrationInCoderSetupRaveStudyWithClassicCodingFieldsEnterDataInEDCMigrateStudyInRaveFromClassicCodingToMedidataCoderVerifyTermsAppearInCoderAfterMigration()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Enter project registration in Coder, setup Rave study with Classic Coding fields," +
                    " enter data in EDC, migrate study in Rave from Classic Coding to Medidata Coder," +
                    " Verify terms appear in Coder after migration", new string[] {
                        "DFT",
                        "Release2016.2.0",
                        "PBMCC_207807_1.1.2_004"});
#line 82
this.ScenarioSetup(scenarioInfo);
#line 83
 testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 11.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 84
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table9 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "CodingLevel",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table9.AddRow(new string[] {
                        "ETE6",
                        "CoderField6",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "true",
                        ""});
#line 85
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table9, "And ");
#line 88
 testRunner.When("a Rave Draft is published and pushed using draft \"<Draft>\" for Project \"<StudyNam" +
                    "e>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 89
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table10 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table10.AddRow(new string[] {
                        "AdverseEvent1",
                        "TERRIBLE HEAD PAIN",
                        ""});
#line 90
 testRunner.And("adding a new verbatim term to form \"ETE6\"", ((string)(null)), table10, "And ");
#line 93
 testRunner.And("an Amendment Manager migration is started with \"SETE6<CoderRaveStudy>\" in \"AM Sub" +
                    "ject Search\" and \"SETE6<CoderRaveStudy>\" in \"Rave Migration Subject Seletion Dro" +
                    "pdown\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 94
 testRunner.Then("Rave Adverse Events form should display \"terrible head pain\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 95
 testRunner.And("Coder tasks should display \"terrible head pain\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
