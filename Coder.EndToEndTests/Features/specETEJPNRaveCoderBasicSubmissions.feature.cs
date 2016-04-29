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
    [NUnit.Framework.DescriptionAttribute("Test the full round trip integration from Rave to Coder back to Rave for Japanese" +
        "")]
    [NUnit.Framework.CategoryAttribute("EndToEndDynamicSegment")]
    public partial class TestTheFullRoundTripIntegrationFromRaveToCoderBackToRaveForJapaneseFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specETEJPNRaveCoderBasicSubmissions.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Test the full round trip integration from Rave to Coder back to Rave for Japanese" +
                    "", "", ProgrammingLanguage.CSharp, new string[] {
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
        [NUnit.Framework.DescriptionAttribute("Enter a verbatim Term in Rave EDC; code the term in Coder and see coding decision" +
            " is displayed correctly in Rave EDC")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("ETE_JPN_Rave_coder_basic_sub")]
        [NUnit.Framework.CategoryAttribute("PB1.1.2-001J")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void EnterAVerbatimTermInRaveEDCCodeTheTermInCoderAndSeeCodingDecisionIsDisplayedCorrectlyInRaveEDC()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Enter a verbatim Term in Rave EDC; code the term in Coder and see coding decision" +
                    " is displayed correctly in Rave EDC", new string[] {
                        "DFT",
                        "ETE_JPN_Rave_coder_basic_sub",
                        "PB1.1.2-001J",
                        "Release2016.1.0"});
#line 13
  this.ScenarioSetup(scenarioInfo);
#line 14
    testRunner.Given("a Rave project registration with dictionary \"MedDRA JPN 11.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 15
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
                        "true",
                        "True",
                        ""});
#line 16
    testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");
#line 19
    testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 20
    testRunner.And("adding a new subject \"TEST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table2.AddRow(new string[] {
                        "AdverseEvent1",
                        "ひどい頭痛",
                        ""});
#line 21
    testRunner.When("adding a new verbatim term to form \"ETE1\"", ((string)(null)), table2, "When ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table3.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "神経系障害"});
            table3.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "頭痛"});
            table3.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "頭痛ＮＥＣ"});
            table3.AddRow(new string[] {
                        "PT",
                        "10019211",
                        "頭痛"});
            table3.AddRow(new string[] {
                        "LLT",
                        "10019198",
                        "ひどい頭痛"});
#line 24
    testRunner.Then("the field \"CoderField1\" on form \"ETE1\" for study \"<Study>\" site \"<Site>\" subject " +
                    "\"TEST\" contains the following coding decision data", ((string)(null)), table3, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Setup Rave study with supplemental fields, enter verbatims in Rave, reject 1 verb" +
            "atim and code the other in Coder, verify supplemental data appears in Coder, and" +
            " Query and Coding results in Rave")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("ETE_JPN_Rave_coder_basic_sub_with_supp")]
        [NUnit.Framework.CategoryAttribute("PB1.1.2-002J")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void SetupRaveStudyWithSupplementalFieldsEnterVerbatimsInRaveReject1VerbatimAndCodeTheOtherInCoderVerifySupplementalDataAppearsInCoderAndQueryAndCodingResultsInRave()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Setup Rave study with supplemental fields, enter verbatims in Rave, reject 1 verb" +
                    "atim and code the other in Coder, verify supplemental data appears in Coder, and" +
                    " Query and Coding results in Rave", new string[] {
                        "DFT",
                        "ETE_JPN_Rave_coder_basic_sub_with_supp",
                        "PB1.1.2-002J",
                        "Release2016.1.0"});
#line 37
  this.ScenarioSetup(scenarioInfo);
#line 39
    testRunner.Given("a Rave project registration with dictionary \"J-Drug JPN 2011H2\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 40
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
                        "ETE2",
                        "ETE2",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "True",
                        "LOGSUPPFIELD2, LOGSUPPFIELD4"});
#line 41
    testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table4, "And ");
#line 44
    testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 45
    testRunner.And("adding a new subject \"TEST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table5.AddRow(new string[] {
                        "ETE2",
                        "足の下に鋭い痛み",
                        ""});
            table5.AddRow(new string[] {
                        "supplemental1",
                        "33",
                        "other"});
            table5.AddRow(new string[] {
                        "Supplemental2",
                        "ニュージャージー州",
                        "radio"});
#line 46
    testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table5, "And ");
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table6.AddRow(new string[] {
                        "ETE2",
                        "神経の鋭い痛み",
                        ""});
            table6.AddRow(new string[] {
                        "supplemental1",
                        "22",
                        "other"});
            table6.AddRow(new string[] {
                        "Supplemental2",
                        "ニューヨーク",
                        "radio"});
#line 51
    testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table6, "And ");
#line 56
    testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 57
    testRunner.When("I view task \"足の下に鋭い痛み\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Supplemental Term",
                        "Supplemental Value"});
            table7.AddRow(new string[] {
                        "ETE2.LOGSUPPFIELD2",
                        "ニュージャージー州"});
            table7.AddRow(new string[] {
                        "ETE2.LOGSUPPFIELD4",
                        "翻訳で失わ"});
#line 58
    testRunner.Then("I verify the following Component information is displayed", ((string)(null)), table7, "Then ");
#line 62
    testRunner.When("I view task \"足の下に鋭い痛み\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 63
    testRunner.Then("I verify the following Component information is displayed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {
                        "Supplemental Term",
                        "Supplemental Value"});
            table8.AddRow(new string[] {
                        "ETE2.LOGSUPPFIELD2",
                        "ニューヨーク"});
            table8.AddRow(new string[] {
                        "ETE2.LOGSUPPFIELD4",
                        "翻訳で失わ"});
#line 64
    testRunner.And("in Coder I verify the Supplemental data for \"足の下に鋭い痛み\"", ((string)(null)), table8, "And ");
#line 68
    testRunner.And("I open a query for new task \"神経の鋭い痛み\" with comment \"悪い言葉による拒絶決定\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 69
    testRunner.And("I browse and code task \"足の下に鋭い痛み\" entering value \"抗Ｄグロブリン\" and selecting \"抗Ｄグロブリン" +
                    "\" located in Dictionary Tree Table", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 70
    testRunner.And("I download the synonym list for \"J-Drug 2011H2 JPN\" and name it \"SynonymListj2.tx" +
                    "t\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table9 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim",
                        "Code",
                        "Level",
                        "Path",
                        "Primary Flag",
                        "Supplemental Info",
                        "Status"});
            table9.AddRow(new string[] {
                        "足の下に鋭い痛み",
                        "634340701",
                        "DrugName",
                        "DrugName:634340701;Category:6343407 注 4;PreferredName:6343407;DetailedClass:6343;" +
                            "LowLevelClass:634;MidLevelClass:63;HighLevelClass:6",
                        "False",
                        "Classification:33;Reserve:コンポーネント",
                        "LOGSUPPFIELD2:ニュージャージー州;LOGSUPPFIELD4:翻訳で失わ"});
#line 71
    testRunner.Then("in \"SynonymListj2.txt\" I should the following", ((string)(null)), table9, "Then ");
#line 74
    testRunner.And("I navigate to Rave App form", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 75
    testRunner.Then("the field on form \"ETE2\" for study \"<Study>\" site \"<Site>\" subject \"TEST\" I shoul" +
                    "d see the rave query icon for term \"神経の鋭い痛み\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            TechTalk.SpecFlow.Table table10 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table10.AddRow(new string[] {
                        "Category",
                        "4",
                        "注"});
            table10.AddRow(new string[] {
                        "English Name",
                        "634340701",
                        "ANTI-D GLOBULIN"});
            table10.AddRow(new string[] {
                        "High-Level Classification",
                        "6",
                        "病原生物に対する医薬品"});
            table10.AddRow(new string[] {
                        "Mid-Level Classification",
                        "63",
                        "生物学的製剤"});
            table10.AddRow(new string[] {
                        "Low-Level Classification",
                        "634",
                        "血液製剤類"});
            table10.AddRow(new string[] {
                        "Detailed Classification",
                        "6463",
                        "血漿分画製剤"});
            table10.AddRow(new string[] {
                        "Preferred Name",
                        "6343407",
                        "乾燥抗Ｄ（Ｒｈｏ）人免疫グロブリン"});
            table10.AddRow(new string[] {
                        "Drug Name",
                        "634340701",
                        "抗Ｄグロブリン"});
#line 76
    testRunner.Then("the field \"ETE2\" on form \"ETE2\" for study \"<Study>\" site \"<Site>\" subject \"TEST\" " +
                    "contains the following coding decision data", ((string)(null)), table10, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Setup a Rave study, enter a verbatim in Rave, change verbatim in Rave, code updat" +
            "ed verbatim in Coder, verify in Rave decision displays in Rave")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("ETE_JPN_Rave_coder_basic_sub_change_verbatim")]
        [NUnit.Framework.CategoryAttribute("PB1.1.2-003J")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void SetupARaveStudyEnterAVerbatimInRaveChangeVerbatimInRaveCodeUpdatedVerbatimInCoderVerifyInRaveDecisionDisplaysInRave()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Setup a Rave study, enter a verbatim in Rave, change verbatim in Rave, code updat" +
                    "ed verbatim in Coder, verify in Rave decision displays in Rave", new string[] {
                        "DFT",
                        "ETE_JPN_Rave_coder_basic_sub_change_verbatim",
                        "PB1.1.2-003J",
                        "Release2016.1.0"});
#line 94
  this.ScenarioSetup(scenarioInfo);
#line 95
    testRunner.Given("a Rave project registration with dictionary \"MedDRA JPN 11.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 96
    testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table11 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "CodingLevel",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table11.AddRow(new string[] {
                        "ETE3",
                        "ETE3",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "True",
                        ""});
#line 97
    testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table11, "And ");
#line 100
    testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 101
    testRunner.And("adding a new subject \"TEST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table12 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table12.AddRow(new string[] {
                        "AdverseEvent1",
                        "ひどい頭痛",
                        ""});
#line 102
    testRunner.And("adding a new verbatim term to form \"ETE3\"", ((string)(null)), table12, "And ");
#line hidden
            TechTalk.SpecFlow.Table table13 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table13.AddRow(new string[] {
                        "ETE3",
                        "左脚の足の痛み",
                        ""});
#line 105
    testRunner.And("I edit verbatim \"ひどい頭痛\" on form \"ETE2\" for study \"<Study>\" site \"<Site>\" subject " +
                    "\"TEST\"", ((string)(null)), table13, "And ");
#line hidden
            TechTalk.SpecFlow.Table table14 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table14.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "神経系障害"});
            table14.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "頭痛"});
            table14.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "頭痛ＮＥＣ"});
            table14.AddRow(new string[] {
                        "PT",
                        "10067040",
                        "片側頭痛"});
#line 108
    testRunner.Then("the field \"CoderField1\" on form \"ETE1\" for study \"<Study>\" site \"<Site>\" subject " +
                    "\"TEST\" contains the following coding decision data", ((string)(null)), table14, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Enter verbatim in Rave, code verbatim in Coder and create synonym rule, enter sam" +
            "e verbatim again in Rave and see autocode results back in Rave")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("ETE_JPN_Rave_coder_basic_sub_syn_rule")]
        [NUnit.Framework.CategoryAttribute("PB1.1.2-004J")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void EnterVerbatimInRaveCodeVerbatimInCoderAndCreateSynonymRuleEnterSameVerbatimAgainInRaveAndSeeAutocodeResultsBackInRave()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Enter verbatim in Rave, code verbatim in Coder and create synonym rule, enter sam" +
                    "e verbatim again in Rave and see autocode results back in Rave", new string[] {
                        "DFT",
                        "ETE_JPN_Rave_coder_basic_sub_syn_rule",
                        "PB1.1.2-004J",
                        "Release2016.1.0"});
#line 121
  this.ScenarioSetup(scenarioInfo);
#line 122
    testRunner.Given("a Rave project registration with dictionary \"MedDRA JPN 11.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 123
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
                        "ETE4",
                        "ETE4",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "True",
                        ""});
#line 124
    testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table15, "And ");
#line 127
    testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 128
    testRunner.And("adding a new subject \"TEST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table16 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table16.AddRow(new string[] {
                        "ETE4",
                        "左脚の足の痛み",
                        ""});
#line 129
    testRunner.And("adding a new verbatim term to form \"ETE4\"", ((string)(null)), table16, "And ");
#line 132
    testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 133
    testRunner.And("I browse and code task \"左脚の足の痛み\" entering value \"片側頭痛\" and selecting \"片側頭痛\" locat" +
                    "ed in Dictionary Tree Table", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 134
    testRunner.And("I navigate to Rave App form", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table17 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table17.AddRow(new string[] {
                        "ETE4",
                        "左脚の足の痛み",
                        ""});
#line 135
    testRunner.And("adding a new verbatim term to form \"ETE4\"", ((string)(null)), table17, "And ");
#line hidden
            TechTalk.SpecFlow.Table table18 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table18.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "神経系障害"});
            table18.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "頭痛"});
            table18.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "頭痛ＮＥＣ"});
            table18.AddRow(new string[] {
                        "PT",
                        "10067040",
                        "片側頭痛"});
#line 138
    testRunner.Then("the field \"CoderField1\" on form \"ETE4\" for study \"<Study>\" site \"<Site>\" subject " +
                    "\"TEST\" contains the following coding decision data", ((string)(null)), table18, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Setup Rave study, enter verbatim in Rave, code verbatim in Coder and create synon" +
            "ym rule, complete the up-versioning process, enter verbatim term again in Rave, " +
            "verify term gets autocoded and results display in Rave")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("ETE_JPN_Rave_coder_basic_up_version")]
        [NUnit.Framework.CategoryAttribute("PB1.1.2-007J")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void SetupRaveStudyEnterVerbatimInRaveCodeVerbatimInCoderAndCreateSynonymRuleCompleteTheUp_VersioningProcessEnterVerbatimTermAgainInRaveVerifyTermGetsAutocodedAndResultsDisplayInRave()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Setup Rave study, enter verbatim in Rave, code verbatim in Coder and create synon" +
                    "ym rule, complete the up-versioning process, enter verbatim term again in Rave, " +
                    "verify term gets autocoded and results display in Rave", new string[] {
                        "DFT",
                        "ETE_JPN_Rave_coder_basic_up_version",
                        "PB1.1.2-007J",
                        "Release2016.1.0"});
#line 150
  this.ScenarioSetup(scenarioInfo);
#line 151
    testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 12.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 152
    testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table19 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "CodingLevel",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table19.AddRow(new string[] {
                        "ETE7",
                        "ETE7",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "false",
                        ""});
#line 153
    testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table19, "And ");
#line 156
    testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 157
    testRunner.And("adding a new subject \"TEST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table20 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table20.AddRow(new string[] {
                        "ETE7",
                        "左脚の足の痛み",
                        ""});
#line 158
    testRunner.And("adding a new verbatim term to form \"ETE1\"", ((string)(null)), table20, "And ");
#line 161
    testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 162
    testRunner.And("I browse and code task \"左脚の足の痛み\" entering value \"片側頭痛\" and selecting \"片側頭痛\" locat" +
                    "ed in Dictionary Tree Table", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 163
    testRunner.And("I perform synonym migration to (Upgrade) list to \"Primary\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table21 = new TechTalk.SpecFlow.Table(new string[] {
                        "Value",
                        "dropdown"});
            table21.AddRow(new string[] {
                        "Project",
                        "Register Study Dropdown"});
            table21.AddRow(new string[] {
                        "Medra (Jpn)",
                        "IADitionary Dropdown"});
            table21.AddRow(new string[] {
                        "11.1",
                        "To Ordinal Dropdown"});
#line 164
    testRunner.And("I generate a study impact Analysis for the following data", ((string)(null)), table21, "And ");
#line 169
    testRunner.And("I navigate to Rave App form", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table22 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table22.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "神経系障害"});
            table22.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "頭痛"});
            table22.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "頭痛ＮＥＣ"});
            table22.AddRow(new string[] {
                        "PT",
                        "10067040",
                        "片側頭痛"});
#line 170
    testRunner.Then("the field \"CoderField1\" on form \"ETE7\" for study \"<Study>\" site \"<Site>\" subject " +
                    "\"TEST\" contains the following coding decision data", ((string)(null)), table22, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Setup Rave study, enter verbatim in Rave, code verbatim in Coder, verify results " +
            "in Rave, reconsider verbatim in Coder and recode it to different term, verify up" +
            "dated results in Rave")]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("ETE_JPN_Rave_coder_reconsider_verbatim")]
        [NUnit.Framework.CategoryAttribute("PB1.1.2-008J")]
        [NUnit.Framework.CategoryAttribute("Release2016.1.0")]
        public virtual void SetupRaveStudyEnterVerbatimInRaveCodeVerbatimInCoderVerifyResultsInRaveReconsiderVerbatimInCoderAndRecodeItToDifferentTermVerifyUpdatedResultsInRave()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Setup Rave study, enter verbatim in Rave, code verbatim in Coder, verify results " +
                    "in Rave, reconsider verbatim in Coder and recode it to different term, verify up" +
                    "dated results in Rave", new string[] {
                        "DFT",
                        "ETE_JPN_Rave_coder_reconsider_verbatim",
                        "PB1.1.2-008J",
                        "Release2016.1.0"});
#line 182
  this.ScenarioSetup(scenarioInfo);
#line 183
    testRunner.Given("a Rave project registration with dictionary \"MedDRA JPN 11.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 184
    testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table23 = new TechTalk.SpecFlow.Table(new string[] {
                        "Form",
                        "Field",
                        "Dictionary",
                        "Locale",
                        "CodingLevel",
                        "Priority",
                        "IsApprovalRequired",
                        "IsAutoApproval",
                        "SupplementalTerms"});
            table23.AddRow(new string[] {
                        "ETE1",
                        "Adverse Event 1",
                        "<Dictionary>",
                        "<Locale>",
                        "LLT",
                        "1",
                        "true",
                        "false",
                        ""});
#line 185
    testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table23, "And ");
#line 188
    testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +
                    "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 189
    testRunner.And("adding a new subject \"TEST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table24 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value",
                        "ControlType"});
            table24.AddRow(new string[] {
                        "Adverse Event 1",
                        "ひどい頭痛",
                        ""});
#line 190
    testRunner.And("adding a new verbatim term to form \"ETE1\"", ((string)(null)), table24, "And ");
#line 193
    testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 194
    testRunner.And("I browse and code Term \"左脚の足の痛み\" located in \"Coder Main Table\" entering value \"片側" +
                    "頭痛\" and selecting \"片側頭痛\" located in \"Dictionary Tree Table\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 195
    testRunner.And("I navigate to Rave App form", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table25 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table25.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "神経系障害"});
            table25.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "頭痛"});
            table25.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "頭痛ＮＥＣ"});
            table25.AddRow(new string[] {
                        "PT",
                        "10019211",
                        "頭痛"});
#line 196
    testRunner.Then("the field \"ETE1\" on form \"ETE1\" for study \"<Study>\" site \"<Site>\" subject \"TEST\" " +
                    "contains the following coding decision data", ((string)(null)), table25, "Then ");
#line 202
    testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 203
    testRunner.And("reclassify and Retire \"左脚の足の痛み\" entering value \"Reclassifying to test message.\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 204
    testRunner.And("in Coder I reject the coding decision for \"左脚の足の痛み\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 205
    testRunner.And("I browse and code Term \"左脚の足の痛み\" located in \"Coder Main Table\" on row \"1\", enteri" +
                    "ng value \"頚原性頭痛\" and selecting \"頚原性頭痛\" located in \"Dictionary Tree Table\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table26 = new TechTalk.SpecFlow.Table(new string[] {
                        "Coding Level",
                        "Code",
                        "Term"});
            table26.AddRow(new string[] {
                        "SOC",
                        "10029205",
                        "神経系障害"});
            table26.AddRow(new string[] {
                        "HLGT",
                        "10019231",
                        "頭痛"});
            table26.AddRow(new string[] {
                        "HLT",
                        "10019233",
                        "頭痛ＮＥＣ"});
            table26.AddRow(new string[] {
                        "PT",
                        "10064888",
                        "頚原性頭痛"});
#line 206
    testRunner.Then("the field \"ETE1\" on form \"ETE1\" for study \"<Study>\" site \"<Site>\" subject \"TEST\" " +
                    "contains the following coding decision data", ((string)(null)), table26, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
