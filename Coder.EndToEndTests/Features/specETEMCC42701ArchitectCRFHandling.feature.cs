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
    [NUnit.Framework.DescriptionAttribute("Architect CRF download will contain Coder settings and Architect upload will save" +
        " Coder settings")]
    [NUnit.Framework.CategoryAttribute("specETEMCC42701ArchitectCRFHandling.feature")]
    [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
    public partial class ArchitectCRFDownloadWillContainCoderSettingsAndArchitectUploadWillSaveCoderSettingsFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specETEMCC42701ArchitectCRFHandling.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Architect CRF download will contain Coder settings and Architect upload will save" +
                    " Coder settings", "", ProgrammingLanguage.CSharp, new string[] {
                        "specETEMCC42701ArchitectCRFHandling.feature",
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
        [NUnit.Framework.DescriptionAttribute("When downloading an architect CRF spreadsheet containing Coder information on a p" +
            "roject that has registered to a Coding Dictionary, Coding configuration data wil" +
            "l be present upon selection")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC42701_10")]
        [NUnit.Framework.CategoryAttribute("ETE_RaveCoderCore")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void WhenDownloadingAnArchitectCRFSpreadsheetContainingCoderInformationOnAProjectThatHasRegisteredToACodingDictionaryCodingConfigurationDataWillBePresentUponSelection()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("When downloading an architect CRF spreadsheet containing Coder information on a p" +
                    "roject that has registered to a Coding Dictionary, Coding configuration data wil" +
                    "l be present upon selection", new string[] {
                        "VAL",
                        "PBMCC42701_10",
                        "ETE_RaveCoderCore",
                        "Release2016.1.0"});
#line 14
this.ScenarioSetup(scenarioInfo);
#line 16
 testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 15.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 17
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
                        "LLT",
                        "1",
                        "true",
                        "true",
                        "LOGSUPPFIELD2"});
#line 18
 testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 21
 testRunner.When("downloading Rave Architect CRF", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Coding Level",
                        "Priority",
                        "Locale",
                        "IsApprovalRequired",
                        "IsAutoApproval"});
            table2.AddRow(new string[] {
                        "ETE2",
                        "CoderField2",
                        "LLT",
                        "1",
                        "eng",
                        "true",
                        "true"});
#line 22
 testRunner.Then("verify the following Rave Architect CRF Download Coder Configuration information", ((string)(null)), table2, "Then ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Supplemental Term"});
            table3.AddRow(new string[] {
                        "ETE2",
                        "CODERFIELD2",
                        "LOGSUPPFIELD2"});
#line 25
 testRunner.And("verify the following Rave Architect CRF Download Coder Supplemental Term informat" +
                    "ion", ((string)(null)), table3, "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("When uploading an architect spreadsheet to a project that is not registered to a " +
            "Coding Dictionary, then the upload should fail.")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC42701_40")]
        [NUnit.Framework.CategoryAttribute("ETE_RaveCoderCore")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void WhenUploadingAnArchitectSpreadsheetToAProjectThatIsNotRegisteredToACodingDictionaryThenTheUploadShouldFail_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("When uploading an architect spreadsheet to a project that is not registered to a " +
                    "Coding Dictionary, then the upload should fail.", new string[] {
                        "VAL",
                        "PBMCC42701_40",
                        "ETE_RaveCoderCore",
                        "Release2016.1.0"});
#line 34
this.ScenarioSetup(scenarioInfo);
#line 36
 testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 15.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 37
    testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 38
 testRunner.When("uploading a rave architect draft error template", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 39
 testRunner.Then("verify the following CRF upload error message \"Error while reading row 5. Field O" +
                    "ID \'CODERTERM1\' in form OID \'ETE1\' : Coding dictionary \'MedDRAMedHistory (Coder)" +
                    "\' not found in the target database.\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
