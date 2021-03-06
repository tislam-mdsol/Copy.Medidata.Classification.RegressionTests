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
    [NUnit.Framework.DescriptionAttribute("Test full round trip integration from Rave to Coder")]
    [NUnit.Framework.CategoryAttribute("specRaveCoderFormConfigurations.feature")]
    [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
    public partial class TestFullRoundTripIntegrationFromRaveToCoderFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specETE_RaveCoderFormConfigurations.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Test full round trip integration from Rave to Coder", "", ProgrammingLanguage.CSharp, new string[] {
                        "specRaveCoderFormConfigurations.feature",
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
        [NUnit.Framework.DescriptionAttribute("Enter project registration in Coder, setup Rave study, enter verbatim with a limi" +
            "t of 450 characters in Rave, code verbatim in Coder, and see results in Rave")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("ETE_ENG_Form_config_char_limit")]
        [NUnit.Framework.CategoryAttribute("PB1.1.2-022")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void EnterProjectRegistrationInCoderSetupRaveStudyEnterVerbatimWithALimitOf450CharactersInRaveCodeVerbatimInCoderAndSeeResultsInRave()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Enter project registration in Coder, setup Rave study, enter verbatim with a limi" +
                    "t of 450 characters in Rave, code verbatim in Coder, and see results in Rave", new string[] {
                        "DFT",
                        "ETE_ENG_Form_config_char_limit",
                        "PB1.1.2-022",
                        "Release2016.1.0"});
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
                        "ETE1",
                        "Adverse Event 1",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "false",
                        "false",
                        ""});
#line 14
    testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 17
    testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 18
    testRunner.And("adding a new subject \"TEST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table2.AddRow(new string[] {
                        "AdverseEvent1",
                        @"This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters........",
                        ""});
#line 19
    testRunner.When("adding a new verbatim term to form \"ETE1\"", ((string)(null)), table2, "When ");
#line 22
 testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 23
    testRunner.And(@"task ""This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters........"" is coded to term ""Head Pain"" at search level ""Low Level Term"" with code ""10019198"" at level ""LLT"" and a synonym is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 24
    testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Code",
                        "Term Path"});
            table3.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "Nervous system disorders"});
            table3.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "Headaches"});
            table3.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "Headaches NEC"});
            table3.AddRow(new string[] {
                        "PT",
                        "10019211",
                        "Headache"});
            table3.AddRow(new string[] {
                        "LLT",
                        "10019198",
                        "Head pain"});
#line 25
 testRunner.Then("the coding decision for verbatim \"Headache\" on form \"ETE1\" for field \"Coding Fiel" +
                    "d\" contains the following data", ((string)(null)), table3, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify that when you have more than 10 instances of a repeat parent folder, terms" +
            " are still able to be sent to Coder from Rave and Rave is still able to receive " +
            "both coding decisions and rejects from Coder.")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("ETE_ENG_Form_config_repeat_parent_folders")]
        [NUnit.Framework.CategoryAttribute("PB1.1.2-024")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void VerifyThatWhenYouHaveMoreThan10InstancesOfARepeatParentFolderTermsAreStillAbleToBeSentToCoderFromRaveAndRaveIsStillAbleToReceiveBothCodingDecisionsAndRejectsFromCoder_()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify that when you have more than 10 instances of a repeat parent folder, terms" +
                    " are still able to be sent to Coder from Rave and Rave is still able to receive " +
                    "both coding decisions and rejects from Coder.", new string[] {
                        "DFT",
                        "ETE_ENG_Form_config_repeat_parent_folders",
                        "PB1.1.2-024",
                        "Release2016.1.0"});
#line 38
  this.ScenarioSetup(scenarioInfo);
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Basic Rave Coder Submission and reconsider term and recode")]
        public virtual void BasicRaveCoderSubmissionAndReconsiderTermAndRecode()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Basic Rave Coder Submission and reconsider term and recode", ((string[])(null)));
#line 39
  this.ScenarioSetup(scenarioInfo);
#line 40
    testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 12.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 41
    testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "CodingLevel",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table4.AddRow(new string[] {
                        "ETE1",
                        "Adverse Event 1",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "false",
                        ""});
#line 42
    testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table4, "And ");
#line 45
    testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 46
    testRunner.And("adding a new subject \"TEST\" with \"10\" added \"ParentRepeat\" events", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table5.AddRow(new string[] {
                        "AdverseEvent1",
                        "terrible head pain 1",
                        ""});
#line 47
    testRunner.And("adding a new verbatim term to form \"ETE1\" for \"ParentRepeat (1)\"", ((string)(null)), table5, "And ");
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table6.AddRow(new string[] {
                        "AdverseEvent1",
                        "terrible head pain 4",
                        ""});
#line 50
    testRunner.And("adding a new verbatim term to form \"ETE1\" for \"ParentRepeat (4)\"", ((string)(null)), table6, "And ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table7.AddRow(new string[] {
                        "AdverseEvent1",
                        "terrible head pain 6",
                        ""});
#line 53
    testRunner.And("adding a new verbatim term to form \"ETE1\" for \"ParentRepeat (6)\"", ((string)(null)), table7, "And ");
#line hidden
            TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table8.AddRow(new string[] {
                        "AdverseEvent1",
                        "terrible head pain 8",
                        ""});
#line 56
    testRunner.And("adding a new verbatim term to form \"ETE1\" for \"ParentRepeat (8)\"", ((string)(null)), table8, "And ");
#line hidden
            TechTalk.SpecFlow.Table table9 = new TechTalk.SpecFlow.Table(new string[] {
                        "query"});
            table9.AddRow(new string[] {
                        "Rejecting Decision due to bad term"});
#line 59
    testRunner.Then("on field \"CoderField1\" on form \"ETE1\" for study \"<Study>\" site \"<Site>\" subject \"" +
                    "TEST\" for \"ParentRepeat (3)\" I submit a query with the following data", ((string)(null)), table9, "Then ");
#line 62
    testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table10 = new TechTalk.SpecFlow.Table(new string[] {
                        "value1",
                        "text",
                        "value2"});
            table10.AddRow(new string[] {
                        "terrible head pain 4",
                        "headache",
                        "Headache"});
            table10.AddRow(new string[] {
                        "terrible head pain 6",
                        "Basilar migraine",
                        "Basilar migraine"});
            table10.AddRow(new string[] {
                        "terrible head pain 8",
                        "migraine",
                        "Migraine"});
#line 63
    testRunner.And("With data below, I browse and code Term \"<value1>\" located in \"Coder Main Table\" " +
                    "on row \"1\", entering value \"<text>\" and selecting \"<value2>\" located in \"Diction" +
                    "ary Tree Table\"", ((string)(null)), table10, "And ");
#line 68
    testRunner.And("I navigate to Rave App form", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table11 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table11.AddRow(new string[] {
                        "PT",
                        "10019211",
                        "Headache"});
            table11.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "Headaches NEC"});
            table11.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "Headaches"});
            table11.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "Nervous system disorders"});
            table11.AddRow(new string[] {
                        "LLT",
                        "",
                        ""});
#line 69
    testRunner.Then("the field \"CoderField1\" on form \"ETE1\" for study \"<Study>\" site \"<Site>\" subject " +
                    "\"TEST\" for \"ParentRepeat (4)\" contains the following coding decision data", ((string)(null)), table11, "Then ");
#line hidden
            TechTalk.SpecFlow.Table table12 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table12.AddRow(new string[] {
                        "PT",
                        "10050258",
                        "Basilar migraine"});
            table12.AddRow(new string[] {
                        "HLT",
                        "10027603",
                        "Migraine headaches"});
            table12.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "Headaches"});
            table12.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "Nervous system disorders"});
            table12.AddRow(new string[] {
                        "LLT",
                        "",
                        ""});
#line 76
    testRunner.Then("the field \"CoderField1\" on form \"ETE1\" for study \"<Study>\" site \"<Site>\" subject " +
                    "\"TEST\" for \"ParentRepeat (6)\" contains the following coding decision data", ((string)(null)), table12, "Then ");
#line hidden
            TechTalk.SpecFlow.Table table13 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table13.AddRow(new string[] {
                        "PT",
                        "10027599",
                        "Migraine"});
            table13.AddRow(new string[] {
                        "HLT",
                        "10027603",
                        "Migraine headaches"});
            table13.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "Headaches"});
            table13.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "Nervous system disorders"});
            table13.AddRow(new string[] {
                        "LLT",
                        "",
                        ""});
#line 83
    testRunner.Then("the field \"CoderField1\" on form \"ETE1\" for study \"<Study>\" site \"<Site>\" subject " +
                    "\"TEST\" for \"ParentRepeat (8)\" contains the following coding decision data", ((string)(null)), table13, "Then ");
#line hidden
            TechTalk.SpecFlow.Table table14 = new TechTalk.SpecFlow.Table(new string[] {
                        "querytext"});
            table14.AddRow(new string[] {
                        "Rejecting Decision due to bad term"});
#line 90
    testRunner.Then("the field \"CoderField1\" on form \"ETE1\" for study \"<Study>\" site \"<Site>\" subject " +
                    "\"TEST\" for \"ParentRepeat (3)\" contains the following coding decision data", ((string)(null)), table14, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Verify that after submitting a blank log line on an auto-coded term displays no d" +
            "ata and when resubmitting an auto-coded term that the coded decision appears")]
        [NUnit.Framework.CategoryAttribute("MCC-207807")]
        [NUnit.Framework.CategoryAttribute("ETE_ENG_Form_config")]
        public virtual void VerifyThatAfterSubmittingABlankLogLineOnAnAuto_CodedTermDisplaysNoDataAndWhenResubmittingAnAuto_CodedTermThatTheCodedDecisionAppears()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Verify that after submitting a blank log line on an auto-coded term displays no d" +
                    "ata and when resubmitting an auto-coded term that the coded decision appears", new string[] {
                        "MCC-207807",
                        "ETE_ENG_Form_config"});
#line 97
  this.ScenarioSetup(scenarioInfo);
#line 98
    testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 12.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 99
    testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table15 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "CodingLevel",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table15.AddRow(new string[] {
                        "ETE1",
                        "Adverse Event 1",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "false",
                        ""});
#line 100
    testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table15, "And ");
#line 103
    testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 104
    testRunner.And("adding a new subject \"TEST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table16 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table16.AddRow(new string[] {
                        "AdverseEvent1",
                        "headache",
                        ""});
#line 105
    testRunner.And("adding a new verbatim term to form \"ETE1\"", ((string)(null)), table16, "And ");
#line hidden
            TechTalk.SpecFlow.Table table17 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table17.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "Nervous system disorders"});
            table17.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "Headaches"});
            table17.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "Headaches NEC"});
            table17.AddRow(new string[] {
                        "PT",
                        "10019211",
                        "Headache"});
            table17.AddRow(new string[] {
                        "LLT",
                        "10019198",
                        "Head pain"});
#line 108
    testRunner.Then("the field \"CoderField1\" on form \"ETE13\" for study \"<Study>\" site \"<Site>\" subject" +
                    " \"TEST\" contains the following coding decision data", ((string)(null)), table17, "Then ");
#line hidden
            TechTalk.SpecFlow.Table table18 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table18.AddRow(new string[] {
                        "ETE3",
                        "",
                        ""});
#line 115
    testRunner.And("I edit verbatim \"terrible head pain \" on form \"ETE1\" for study \"<Study>\" site \"<S" +
                    "ite>\" subject \"TEST\"", ((string)(null)), table18, "And ");
#line hidden
            TechTalk.SpecFlow.Table table19 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table19.AddRow(new string[] {
                        "",
                        "",
                        ""});
#line 118
    testRunner.Then("the field \"CoderField1\" on form \"ETE1\" for study \"<Study>\" site \"<Site>\" subject " +
                    "\"TEST\" contains the following coding decision data", ((string)(null)), table19, "Then ");
#line hidden
            TechTalk.SpecFlow.Table table20 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table20.AddRow(new string[] {
                        "Adverse Event 1",
                        "headache",
                        ""});
#line 121
    testRunner.And("I edit verbatim \"terrible head pain \" on form \"ETE1\" for study \"<Study>\" site \"<S" +
                    "ite>\" subject \"TEST\"", ((string)(null)), table20, "And ");
#line hidden
            TechTalk.SpecFlow.Table table21 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table21.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "Nervous system disorders"});
            table21.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "Headaches"});
            table21.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "Headaches NEC"});
            table21.AddRow(new string[] {
                        "PT",
                        "10019211",
                        "Headache"});
            table21.AddRow(new string[] {
                        "LLT",
                        "10019198",
                        "Head pain"});
#line 124
    testRunner.Then("the field \"CoderField1\" on form \"ETE13\" for study \"<Study>\" site \"<Site>\" subject" +
                    " \"TEST\" contains the following coding decision data", ((string)(null)), table21, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
