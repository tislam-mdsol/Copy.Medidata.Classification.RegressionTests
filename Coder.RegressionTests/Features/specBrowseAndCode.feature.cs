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
    [NUnit.Framework.DescriptionAttribute("These scenarios will validate the behavior of the coding system during a manual b" +
        "rowse of the dictionary and coding of a task")]
    [NUnit.Framework.CategoryAttribute("specBrowseAndCode.feature")]
    [NUnit.Framework.CategoryAttribute("CoderCore")]
    public partial class TheseScenariosWillValidateTheBehaviorOfTheCodingSystemDuringAManualBrowseOfTheDictionaryAndCodingOfATaskFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specBrowseAndCode.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "These scenarios will validate the behavior of the coding system during a manual b" +
                    "rowse of the dictionary and coding of a task", "", ProgrammingLanguage.CSharp, new string[] {
                        "specBrowseAndCode.feature",
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
        [NUnit.Framework.DescriptionAttribute("The initial dictionary search for a browse and code should be using the synonym l" +
            "ist of the task")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_185768_008")]
        public virtual void TheInitialDictionarySearchForABrowseAndCodeShouldBeUsingTheSynonymListOfTheTask()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("The initial dictionary search for a browse and code should be using the synonym l" +
                    "ist of the task", new string[] {
                        "VAL",
                        "Release2015.3.0",
                        "PBMCC_185768_008"});
#line 8
this.ScenarioSetup(scenarioInfo);
#line 9
 testRunner.Given("a \"Synonyms Need Approval\" Coder setup with no tasks and no synonyms and dictiona" +
                    "ry \"MedDRA ENG 11.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 10
 testRunner.And("coding task \"A-FIB\" for dictionary level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 11
 testRunner.When("a browse and code for task \"A-FIB\" is performed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 12
 testRunner.Then("the current dictionary search criteria should be using a synonym list", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A browse and code using JDrug should allow expansion of search result levels and " +
            "coding to any selected term")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.1")]
        [NUnit.Framework.CategoryAttribute("PBMCC_193843_001")]
        [NUnit.Framework.Timeout(360000)]
        public virtual void ABrowseAndCodeUsingJDrugShouldAllowExpansionOfSearchResultLevelsAndCodingToAnySelectedTerm()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A browse and code using JDrug should allow expansion of search result levels and " +
                    "coding to any selected term", new string[] {
                        "VAL",
                        "Release2015.3.1",
                        "PBMCC_193843_001",
                        "IncreaseTimeout_360000"});
#line 18
this.ScenarioSetup(scenarioInfo);
#line 19
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"JDrug JPN 201" +
                    "4H2\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 20
 testRunner.And("coding task \"アデノシン三リン酸二ナトリウム水和物\" for dictionary level \"DrugName\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 21
 testRunner.And("I want only exact match results", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 22
 testRunner.When("a browse and code for task \"アデノシン三リン酸二ナトリウム水和物\" is performed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 23
 testRunner.And("the browse and code search is done for \"アデノシン三リン酸二ナトリウム水和物\" against \"Text\" at Lev" +
                    "el \"Drug Name\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Term Path",
                        "Code",
                        "Level"});
            table1.AddRow(new string[] {
                        "アデノシン三リン酸二ナトリウム水和物",
                        "3992001",
                        "薬"});
#line 24
 testRunner.And("I expand the following search result terms", ((string)(null)), table1, "And ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Term Path",
                        "Code",
                        "Level"});
            table2.AddRow(new string[] {
                        "アデノシン三リン酸二ナトリウム水和物",
                        "3992001",
                        "薬"});
            table2.AddRow(new string[] {
                        "アデノシン製剤",
                        "3992",
                        "細"});
#line 27
 testRunner.Then("the task should be able to be coded to the following terms", ((string)(null)), table2, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A user can continuously code to the next available task within a group until all " +
            "the items of that group are coded")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_197227_001")]
        [NUnit.Framework.Timeout(600000)]
        public virtual void AUserCanContinuouslyCodeToTheNextAvailableTaskWithinAGroupUntilAllTheItemsOfThatGroupAreCoded()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A user can continuously code to the next available task within a group until all " +
                    "the items of that group are coded", new string[] {
                        "VAL",
                        "Release2015.3.0",
                        "PBMCC_197227_001",
                        "IncreaseTimeout"});
#line 36
this.ScenarioSetup(scenarioInfo);
#line 37
    testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 38
 testRunner.When("the following externally managed verbatim requests are made \"Tasks_6_CodeAndNext." +
                    "json\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 39
 testRunner.And("a browse and code for task \"Burning\" is performed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim",
                        "SearchText",
                        "SearchLevel",
                        "Code",
                        "Level",
                        "CreateSynonym"});
            table3.AddRow(new string[] {
                        "Burning",
                        "Gastroesophageal burning",
                        "Low Level Term",
                        "10066998",
                        "LLT",
                        "False"});
            table3.AddRow(new string[] {
                        "Congestion",
                        "Congestion nasal",
                        "Low Level Term",
                        "10010676",
                        "LLT",
                        "False"});
            table3.AddRow(new string[] {
                        "Heart Burn",
                        "Reflux gastritis",
                        "Low Level Term",
                        "10057969",
                        "LLT",
                        "False"});
            table3.AddRow(new string[] {
                        "Nasal Drip",
                        "Postnasal drip",
                        "Low Level Term",
                        "10036402",
                        "LLT",
                        "False"});
            table3.AddRow(new string[] {
                        "Reflux",
                        "Gastritis alkaline reflux",
                        "Low Level Term",
                        "10017858",
                        "LLT",
                        "False"});
            table3.AddRow(new string[] {
                        "Stiff Joints",
                        "Stiff joint",
                        "Low Level Term",
                        "10042041",
                        "LLT",
                        "False"});
#line 40
 testRunner.When("I code next available task", ((string)(null)), table3, "When ");
#line 48
 testRunner.Then("The task count is \"0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A user can code to the next available task that is waiting to be coded if though " +
            "there are tasks in other states than waiting manual code")]
        [NUnit.Framework.IgnoreAttribute()]
        [NUnit.Framework.CategoryAttribute("DFT")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_197227_02")]
        [NUnit.Framework.Timeout(600000)]
        public virtual void AUserCanCodeToTheNextAvailableTaskThatIsWaitingToBeCodedIfThoughThereAreTasksInOtherStatesThanWaitingManualCode()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A user can code to the next available task that is waiting to be coded if though " +
                    "there are tasks in other states than waiting manual code", new string[] {
                        "DFT",
                        "Release2015.3.0",
                        "PBMCC_197227_02",
                        "IncreaseTimeout",
                        "ignore"});
#line 55
this.ScenarioSetup(scenarioInfo);
#line 56
    testRunner.Given("a \"Waiting Approval\" Coder setup with no tasks and no synonyms and dictionary \"Me" +
                    "dDRA ENG 15.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 57
 testRunner.And("a browse and code for task \"Burning\" is performed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim",
                        "SearchText",
                        "SearchLevel",
                        "Code",
                        "Level",
                        "CreateSynonym"});
            table4.AddRow(new string[] {
                        "Burning",
                        "Gastroesophageal burning",
                        "Low Level Term",
                        "10066998",
                        "LLT",
                        "False"});
            table4.AddRow(new string[] {
                        "Congestion",
                        "Congestion nasal",
                        "Low Level Term",
                        "10010676",
                        "LLT",
                        "False"});
            table4.AddRow(new string[] {
                        "Heart Burn",
                        "Reflux gastritis",
                        "Low Level Term",
                        "10057969",
                        "LLT",
                        "False"});
            table4.AddRow(new string[] {
                        "Nasal Drip",
                        "Postnasal drip",
                        "Low Level Term",
                        "10036402",
                        "LLT",
                        "False"});
            table4.AddRow(new string[] {
                        "Reflux",
                        "Gastritis alkaline reflux",
                        "Low Level Term",
                        "10017858",
                        "LLT",
                        "False"});
#line 58
 testRunner.When("I code next available task", ((string)(null)), table4, "When ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim"});
            table5.AddRow(new string[] {
                        "Burning"});
            table5.AddRow(new string[] {
                        "Congestion"});
            table5.AddRow(new string[] {
                        "Heart Burn"});
            table5.AddRow(new string[] {
                        "Nasal Drip"});
            table5.AddRow(new string[] {
                        "Reflux"});
#line 65
 testRunner.And("I reclassify tasks \"<Verbatim>\" with Include Autocoded Items set to \"True\"", ((string)(null)), table5, "And ");
#line 72
 testRunner.Then("The task count is \"0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A user can continuously code and create synonym for the next available task withi" +
            "n a group until all the items of that group are coded and the empty tasks list i" +
            "s provided")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_197227_003")]
        [NUnit.Framework.Timeout(600000)]
        public virtual void AUserCanContinuouslyCodeAndCreateSynonymForTheNextAvailableTaskWithinAGroupUntilAllTheItemsOfThatGroupAreCodedAndTheEmptyTasksListIsProvided()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A user can continuously code and create synonym for the next available task withi" +
                    "n a group until all the items of that group are coded and the empty tasks list i" +
                    "s provided", new string[] {
                        "VAL",
                        "Release2015.3.0",
                        "PBMCC_197227_003",
                        "IncreaseTimeout"});
#line 78
this.ScenarioSetup(scenarioInfo);
#line 79
    testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 80
 testRunner.When("the following externally managed verbatim requests are made \"Tasks_6_CodeAndNext." +
                    "json\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 81
 testRunner.And("a browse and code for task \"Burning\" is performed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim",
                        "SearchText",
                        "SearchLevel",
                        "Code",
                        "Level",
                        "CreateSynonym"});
            table6.AddRow(new string[] {
                        "Burning",
                        "Gastroesophageal burning",
                        "Low Level Term",
                        "10066998",
                        "LLT",
                        "True"});
            table6.AddRow(new string[] {
                        "Congestion",
                        "Congestion nasal",
                        "Low Level Term",
                        "10010676",
                        "LLT",
                        "True"});
            table6.AddRow(new string[] {
                        "Heart Burn",
                        "Reflux gastritis",
                        "Low Level Term",
                        "10057969",
                        "LLT",
                        "True"});
            table6.AddRow(new string[] {
                        "Nasal Drip",
                        "Postnasal drip",
                        "Low Level Term",
                        "10036402",
                        "LLT",
                        "True"});
            table6.AddRow(new string[] {
                        "Reflux",
                        "Gastritis alkaline reflux",
                        "Low Level Term",
                        "10017858",
                        "LLT",
                        "True"});
            table6.AddRow(new string[] {
                        "Stiff Joints",
                        "Stiff joint",
                        "Low Level Term",
                        "10042041",
                        "LLT",
                        "True"});
#line 82
 testRunner.When("I code next available task", ((string)(null)), table6, "When ");
#line 90
 testRunner.Then("The task count is \"0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Terms on all pages of browse and code dictionary search results should be able to" +
            " be coded to a task")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.2")]
        [NUnit.Framework.CategoryAttribute("PBMCC_204358_003")]
        [NUnit.Framework.Timeout(360000)]
        public virtual void TermsOnAllPagesOfBrowseAndCodeDictionarySearchResultsShouldBeAbleToBeCodedToATask()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Terms on all pages of browse and code dictionary search results should be able to" +
                    " be coded to a task", new string[] {
                        "VAL",
                        "Release2015.3.2",
                        "PBMCC_204358_003",
                        "IncreaseTimeout_360000"});
#line 97
this.ScenarioSetup(scenarioInfo);
#line 98
 testRunner.Given("a \"Waiting Approval\" Coder setup with no tasks and no synonyms and dictionary \"Me" +
                    "dDRA ENG 15.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 99
 testRunner.And("coding task \"A-FIB\" for dictionary level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 100
 testRunner.When("a browse and code for task \"A-FIB\" is performed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 101
 testRunner.And("the browse and code search is done for \"atrial fibrillation\" against \"Text\" at Le" +
                    "vel \"Low Level Term\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Term Path",
                        "Code",
                        "Level"});
            table7.AddRow(new string[] {
                        "Atrial fibrillation",
                        "10003658",
                        "LLT"});
            table7.AddRow(new string[] {
                        "Paroxysmal atrial flutter",
                        "10050376",
                        "LLT"});
            table7.AddRow(new string[] {
                        "Ostium secundum type atrial septal defect",
                        "10031303",
                        "LLT"});
#line 102
 testRunner.Then("the task should be able to be coded to the following terms", ((string)(null)), table7, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("MedDRA Browse and Code Search Results should contain only terms for current paths" +
            "")]
        [NUnit.Framework.CategoryAttribute("Rerun")]
        [NUnit.Framework.CategoryAttribute("PBMCC_204440_002")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.2")]
        public virtual void MedDRABrowseAndCodeSearchResultsShouldContainOnlyTermsForCurrentPaths()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("MedDRA Browse and Code Search Results should contain only terms for current paths" +
                    "", new string[] {
                        "Rerun",
                        "PBMCC_204440_002",
                        "Release2015.3.2"});
#line 111
this.ScenarioSetup(scenarioInfo);
#line 112
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA JPN 18" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 113
 testRunner.And("coding task \"Adverse Event 17\" for dictionary level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 114
 testRunner.And("I want only exact match results", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 115
 testRunner.And("I want only primary path results", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 116
 testRunner.When("a browse and code for task \"Adverse Event 17\" is performed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 117
 testRunner.And("the browse and code search is done for \"高脂血症\" against \"Text\" at Level \"Low Level " +
                    "Term\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {
                        "Term Path",
                        "Code",
                        "Level"});
            table8.AddRow(new string[] {
                        "高脂血症",
                        "10062060",
                        "LLT"});
#line 118
 testRunner.Then("the dictionary search results should contain only the following terms", ((string)(null)), table8, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Cross level browse and code is performed on MedDRA, JDrug, WhoDrugDDEB2 and AZDD")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.3")]
        [NUnit.Framework.CategoryAttribute("PBMCC_202079_001")]
        [NUnit.Framework.Timeout(360000)]
        [NUnit.Framework.TestCaseAttribute("MedDRA-18.0-English", "LLT", "Preferred Term", "PT", "MedDRA ENG 18.0", "ADVERSE EVENT 1", "Musculoskeletal discomfort", "10053156", "Musculoskeletal discomfort: 10053156", null)]
        [NUnit.Framework.TestCaseAttribute("MedDRA-18.0-English", "LLT", "Low Level Term", "LLT", "MedDRA ENG 18.0", "ADVERSE EVENT 2", "Cardiac index", "10007575", "Cardiac index: 10007575", null)]
        [NUnit.Framework.TestCaseAttribute("JDrug", "DrugName", "High Level Classification", "大", "JDrug JPN 2014H2", "アデノシン三リン酸二ナトリウム水和物", "代謝性医薬品", "3", "代謝性医薬品: 3", null)]
        [NUnit.Framework.TestCaseAttribute("JDrug", "DrugName", "Mid Level Classification", "中", "JDrug JPN 2014H2", "アデノシン三リン酸二ナトリウム水和物", "体外診断用医薬品", "74", "体外診断用医薬品: 74", null)]
        [NUnit.Framework.TestCaseAttribute("JDrug", "DrugName", "Low Level Classification", "小", "JDrug JPN 2014H2", "アデノシン三リン酸二ナトリウム水和物", "総合代謝性製剤", "397", "総合代謝性製剤: 397", null)]
        [NUnit.Framework.TestCaseAttribute("JDrug", "DrugName", "Detailed Classification", "細", "JDrug ENG 2014H2", "ADVERSE EVENT 3", "SYNTHETIC VITAMIN A AND PREPARATIONS", "3111", "SYNTHETIC VITAMIN A AND PREPARATIONS: 3111", null)]
        [NUnit.Framework.TestCaseAttribute("WhoDrugDDEB2", "PRODUCT", "Preferred Name", "PN", "WhoDrugDDEB2 ENG 201212", "ADVERSE EVENT 4", "CARBOPHAGIX", "076577 01 001", "CARBOPHAGIX: 076577 01 001", null)]
        [NUnit.Framework.TestCaseAttribute("WhoDrugDDEB2", "PRODUCT", "Trade Name", "TN", "WhoDrugDDEB2 ENG 201212", "ADVERSE EVENT 5", "AZTOR ASP", "031934 01 002", "AZTOR ASP: 031934 01 002", null)]
        [NUnit.Framework.TestCaseAttribute("AZDD", "PRODUCT", "Preferred Name", "PN", "AZDD ENG 15.1", "ADVERSE EVENT 6", "OTHER NERVOUS SYSTEM DRUGS", "900592 01 001", "OTHER NERVOUS SYSTEM DRUGS: 900592 01 001", null)]
        [NUnit.Framework.TestCaseAttribute("AZDD", "PRODUCT", "Trade Name", "TN", "AZDD ENG 15.1", "ADVERSE EVENT 7", "JALEA REAL", "007887 01 002", "JALEA REAL: 007887 01 002", null)]
        public virtual void CrossLevelBrowseAndCodeIsPerformedOnMedDRAJDrugWhoDrugDDEB2AndAZDD(string searchDictionary, string dictionaryLevel, string searchLevel, string codeLevel, string contextDictionary, string task, string term, string code, string termPath, string[] exampleTags)
        {
            string[] @__tags = new string[] {
                    "VAL",
                    "Release2015.3.3",
                    "PBMCC_202079_001",
                    "IncreaseTimeout_360000"};
            if ((exampleTags != null))
            {
                @__tags = System.Linq.Enumerable.ToArray(System.Linq.Enumerable.Concat(@__tags, exampleTags));
            }
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Cross level browse and code is performed on MedDRA, JDrug, WhoDrugDDEB2 and AZDD", @__tags);
#line 126
this.ScenarioSetup(scenarioInfo);
#line 127
  testRunner.Given(string.Format("a \"Waiting Approval\" Coder setup with no tasks and no synonyms and dictionary \"{0" +
                        "}\"", contextDictionary), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 128
  testRunner.And(string.Format("coding task \"{0}\" for dictionary level \"{1}\"", task, dictionaryLevel), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 129
  testRunner.When(string.Format("a browse and code for task \"{0}\" is performed", task), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 130
  testRunner.And("I want only exact match results", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 131
  testRunner.And(string.Format("the browse and code search is done for \"{0}\" against \"Text\" at Level \"{1}\"", term, searchLevel), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 132
  testRunner.And(string.Format("the task is coded to term \"{0}\" at level \"{1}\" with code \"{2}\" and a synonym is c" +
                        "reated", term, codeLevel, code), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 133
  testRunner.And(string.Format("I view task \"{0}\"", task), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            TechTalk.SpecFlow.Table table9 = new TechTalk.SpecFlow.Table(new string[] {
                        "Level",
                        "Term Path",
                        "Code"});
            table9.AddRow(new string[] {
                        string.Format("{0}", codeLevel),
                        string.Format("{0}", termPath),
                        string.Format("{0}", code)});
#line 134
  testRunner.Then("I verify the following Coding history selected term path information is displayed" +
                    " in row \"1\"", ((string)(null)), table9, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
