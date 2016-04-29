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
    [NUnit.Framework.DescriptionAttribute("UPDATED Verify JPN Rave Coder Migrations")]
    public partial class UPDATEDVerifyJPNRaveCoderMigrationsFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specETE_JPNRaveCoderMigrations.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "UPDATED Verify JPN Rave Coder Migrations", "", ProgrammingLanguage.CSharp, ((string[])(null)));
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
        [NUnit.Framework.DescriptionAttribute("Setup Rave study with all non coding fields, enter data in EDC, migrate study in " +
            "Rave from non-coding to Medidata Coder, Verify terms appear in Coder after migra" +
            "tion")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("PB1.1.2_005J")]
        [NUnit.Framework.CategoryAttribute("Release2012.1.0")]
        public virtual void SetupRaveStudyWithAllNonCodingFieldsEnterDataInEDCMigrateStudyInRaveFromNon_CodingToMedidataCoderVerifyTermsAppearInCoderAfterMigration()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Setup Rave study with all non coding fields, enter data in EDC, migrate study in " +
                    "Rave from non-coding to Medidata Coder, Verify terms appear in Coder after migra" +
                    "tion", new string[] {
                        "DFT",
                        "PB1.1.2_005J",
                        "Release2012.1.0"});
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
                        "CodingLevel",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table1.AddRow(new string[] {
                        "ETE5",
                        "CoderFieldETE5",
                        "<Dictionary>",
                        "<Locale>",
                        "PRODUCTSYNONYM",
                        "1",
                        "false",
                        "true",
                        ""});
#line 9
  testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 12
 testRunner.When("a Rave Draft is published and pushed using draft \"<Draft>\" for Project \"<SourceSy" +
                    "stemStudyName>\" to environment \"Production\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 13
 testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table2.AddRow(new string[] {
                        "Coder  Field ETE 5",
                        "左脚の足の痛み",
                        ""});
#line 14
 testRunner.And("adding a new verbatim term to form \"ETE5\"", ((string)(null)), table2, "And ");
#line 17
 testRunner.And("an Amendment Manager migration is started with \"SETE5<CoderRaveStudy>\" in \"AM Sub" +
                    "ject Search\" and \"SETE5<CoderRaveStudy>\" in \"Rave Migration Subject Seletion Dro" +
                    "pdown\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 18
 testRunner.Then("Rave Adverse Events form should display \"左脚の足の痛み\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 19
 testRunner.And("Coder tasks should display \"左脚の足の痛み\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
