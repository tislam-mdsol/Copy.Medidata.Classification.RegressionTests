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
    [NUnit.Framework.DescriptionAttribute("Global library will support Coder settings.  This will allow forms that contain C" +
        "oder settings to be copied.")]
    public partial class GlobalLibraryWillSupportCoderSettings_ThisWillAllowFormsThatContainCoderSettingsToBeCopied_Feature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specETEMCC42706GlobalLibraryWithCoder.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Global library will support Coder settings.  This will allow forms that contain C" +
                    "oder settings to be copied.", "", ProgrammingLanguage.CSharp, ((string[])(null)));
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
        [NUnit.Framework.DescriptionAttribute("Verify coping a form that contains Coder settings within a Project that the Coder" +
            " settings get copied to the new form.")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC42706_10")]
        [NUnit.Framework.CategoryAttribute("ETE_RaveCoderCore")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
        public virtual void VerifyCopingAFormThatContainsCoderSettingsWithinAProjectThatTheCoderSettingsGetCopiedToTheNewForm_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify coping a form that contains Coder settings within a Project that the Coder" +
                    " settings get copied to the new form.", new string[] {
                        "VAL",
                        "PBMCC42706_10",
                        "ETE_RaveCoderCore",
                        "Release2016.1.0",
                        "EndToEndDynamicSegment"});
#line 9
this.ScenarioSetup(scenarioInfo);
#line 11
testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 18.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 12
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 13
 testRunner.And("a Rave CRF copy source is added for the project", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
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
                        "LogSuppField2"});
#line 14
 testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 17
 testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 18
 testRunner.And("a new Draft \"NewCopiedDraft\" is created through copy wizard", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "Coding Level",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table2.AddRow(new string[] {
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "true",
                        "LogSuppField2"});
#line 19
 testRunner.Then("the Rave Coder setup for draft \"NewCopiedDraft\" has the following options configu" +
                    "red", ((string)(null)), table2, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify Coder settings get copied from a form that contains Coder settings to a fo" +
            "rm from another Project that has Coder registered")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC42706_20")]
        [NUnit.Framework.CategoryAttribute("ETE_RaveCoderCore")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
        public virtual void VerifyCoderSettingsGetCopiedFromAFormThatContainsCoderSettingsToAFormFromAnotherProjectThatHasCoderRegistered()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify Coder settings get copied from a form that contains Coder settings to a fo" +
                    "rm from another Project that has Coder registered", new string[] {
                        "VAL",
                        "PBMCC42706_20",
                        "ETE_RaveCoderCore",
                        "Release2016.1.0",
                        "EndToEndDynamicSegment"});
#line 30
this.ScenarioSetup(scenarioInfo);
#line 32
 testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 18.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "Coding Level",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table3.AddRow(new string[] {
                        "ETE2",
                        "Coding Field",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "true",
                        ""});
#line 33
 testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table3, "And ");
#line 36
 testRunner.And("iMedidata App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 37
 testRunner.And("a coder study is created named \"SecondRaveCoderStudy\" for environment \"Prod\" with" +
                    " site \"Active Site 2\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 38
 testRunner.And("I logout of iMedidata", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 39
 testRunner.And("I login to iMedidata as test user", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 40
 testRunner.And("Coder App Segment is loaded and refreshed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Project",
                        "Dictionary",
                        "Version",
                        "Locale",
                        "RegistrationName"});
            table4.AddRow(new string[] {
                        "SecondRaveCoderStudy",
                        "MedDRA",
                        "18.0",
                        "eng",
                        "MedDRA"});
#line 41
 testRunner.And("a project with the following options is registered", ((string)(null)), table4, "And ");
#line 44
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 45
 testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 46
 testRunner.And("a Rave CRF copy source from project \"<StudyName>\" draft \"<DraftName>\" is added fo" +
                    "r project \"SecondRaveCoderStudy\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 47
 testRunner.And("a new Draft \"NewCopiedDraft\" is created through copy wizard for project \"SecondRa" +
                    "veCoderStudy\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
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
                        "<Locale>",
                        "PRODUCTSYNONYM",
                        "1",
                        "true",
                        "true",
                        "SUPPDD"});
#line 48
 testRunner.Then("the Rave Coder setup for draft \"NewCopiedDraft\" has the following options configu" +
                    "red", ((string)(null)), table5, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify Coder settings are not copied from a form that contains Coder settings to " +
            "a from from another Project that does not have Coder registered")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("PBMCC42706_20")]
        [NUnit.Framework.CategoryAttribute("ETE_RaveCoderCore")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
        public virtual void VerifyCoderSettingsAreNotCopiedFromAFormThatContainsCoderSettingsToAFromFromAnotherProjectThatDoesNotHaveCoderRegistered()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify Coder settings are not copied from a form that contains Coder settings to " +
                    "a from from another Project that does not have Coder registered", new string[] {
                        "DFT",
                        "PBMCC42706_20",
                        "ETE_RaveCoderCore",
                        "Release2016.1.0",
                        "EndToEndDynamicSegment"});
#line 59
this.ScenarioSetup(scenarioInfo);
#line 61
 testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 18.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 62
 testRunner.And("iMedidata App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 63
 testRunner.And("a coder study is created named \"SecondRaveCoderStudy\" for environment \"Prod\" with" +
                    " site \"Active Site 2\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 64
 testRunner.And("I logout of iMedidata", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 65
 testRunner.And("I login to iMedidata as test user", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 66
 testRunner.And("Coder App Segment is loaded and refreshed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "Project",
                        "Dictionary",
                        "Version",
                        "Locale",
                        "RegistrationName"});
            table6.AddRow(new string[] {
                        "SecondRaveCoderStudy",
                        "MedDRA",
                        "18.0",
                        "eng",
                        "MedDRA"});
#line 67
 testRunner.And("a project with the following options is registered", ((string)(null)), table6, "And ");
#line 70
 testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 71
 testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 73
 testRunner.And("a Rave CRF copy source from project \"<StudyName>\" draft \"<DraftName>\" is added fo" +
                    "r project \"SecondRaveCoderStudy\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 74
 testRunner.And("a new Draft \"NewCopiedDraft\" is created through copy wizard for project \"SecondRa" +
                    "veCoderStudy\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 75
 testRunner.Then("the project \"SecondRaveCoderStudy\" draft \"NewCopiedDraft\" form \"ETE2\" field \"Codi" +
                    "ng Field\" has no Rave Coder setup options configured", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
