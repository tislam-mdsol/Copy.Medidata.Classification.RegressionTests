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
    [NUnit.Framework.DescriptionAttribute("Illustrate the work flow when Reclassifying a term")]
    [NUnit.Framework.CategoryAttribute("specReclassifyWorkFlow.feature")]
    [NUnit.Framework.CategoryAttribute("CoderCore")]
    public partial class IllustrateTheWorkFlowWhenReclassifyingATermFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specReclassifyWorkflow.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Illustrate the work flow when Reclassifying a term", @"
 Common Configurations:
 Configuration Name	| Force Primary Path Selection (MedDRA) | Synonym Creation Policy Flag	| Bypass Reconsider Upon Reclassify 	| Default Select Threshold 	| Default Suggest Threshold	| Auto Add Synonyms 	| Auto Approve 	| Term Requires Approval (IsApprovalRequired )  | Term Auto Approve with synonym (IsAutoApproval)	|
 Basic		        | TRUE					| Always Active			| TRUE					| 100				| 70				| TRUE			| FALSE		| TRUE						| TRUE							|							
 Reconsider		| TRUE					| Always Active			| FALSE					| 100				| 70				| TRUE 			| FALSE		| TRUE						| TRUE							|", ProgrammingLanguage.CSharp, new string[] {
                        "specReclassifyWorkFlow.feature",
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
        [NUnit.Framework.DescriptionAttribute("Coder users are able to Reclassify a coded term without removing the synonym for " +
            "that term")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168609_01")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.Timeout(300000)]
        public virtual void CoderUsersAreAbleToReclassifyACodedTermWithoutRemovingTheSynonymForThatTerm()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Coder users are able to Reclassify a coded term without removing the synonym for " +
                    "that term", new string[] {
                        "VAL",
                        "PBMCC_168609_01",
                        "Release2015.3.0",
                        "IncreaseTimeout_300000"});
#line 16
this.ScenarioSetup(scenarioInfo);
#line 17
 testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 18
 testRunner.And("coding task \"Heart Burn\" for dictionary level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 19
 testRunner.When("task \"Heart Burn\" is coded to term \"Reflux gastritis\" at search level \"Low Level " +
                    "Term\" with code \"10057969\" at level \"LLT\" and a synonym is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 20
 testRunner.And("reclassifying task \"Heart Burn\" with Include Autocoded Items set to \"True\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 21
 testRunner.Then("the synonym for verbatim \"HEART BURN\" and code \"10057969\" should be active", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Coder users are able to Reclassify a term and retire the mapped synonym")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168609_02")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.Timeout(300000)]
        public virtual void CoderUsersAreAbleToReclassifyATermAndRetireTheMappedSynonym()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Coder users are able to Reclassify a term and retire the mapped synonym", new string[] {
                        "VAL",
                        "PBMCC_168609_02",
                        "Release2015.3.0",
                        "IncreaseTimeout_300000"});
#line 28
this.ScenarioSetup(scenarioInfo);
#line 29
    testRunner.Given("a \"Basic\" Coder setup with registered synonym list \"MedDRA ENG 15.0 Clear_Match\" " +
                    "containing entry \"HEADACHE|10019211|LLT|LLT:10019211;PT:10019211;HLT:10019233;HL" +
                    "GT:10019231;SOC:10029205|True|AE.AECAT:OTHER|Approved|Headache\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 30
 testRunner.And("coding task \"Heart Burn\" for dictionary level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 31
 testRunner.When("task \"Heart Burn\" is coded to term \"Reflux gastritis\" at search level \"Low Level " +
                    "Term\" with code \"10057969\" at level \"LLT\" and a synonym is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 32
 testRunner.And("reclassifying and retiring synonym task \"Heart Burn\" with Include Autocoded Items" +
                    " set to \"True\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 33
 testRunner.Then("the synonym for verbatim \"HEART BURN\" and code \"10057969\" should not exist", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A Coder user can reject a coding decision of a reclassified term")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168609_03")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.Timeout(300000)]
        public virtual void ACoderUserCanRejectACodingDecisionOfAReclassifiedTerm()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A Coder user can reject a coding decision of a reclassified term", new string[] {
                        "VAL",
                        "PBMCC_168609_03",
                        "Release2015.3.0",
                        "IncreaseTimeout_300000"});
#line 39
this.ScenarioSetup(scenarioInfo);
#line 40
 testRunner.Given("a \"Reconsider\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA E" +
                    "NG 15.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 41
 testRunner.And("coding task \"Heart Burn\" for dictionary level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 42
 testRunner.When("task \"Heart Burn\" is coded to term \"Reflux gastritis\" at search level \"Low Level " +
                    "Term\" with code \"10057969\" at level \"LLT\" and a synonym is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 43
 testRunner.And("reclassifying task \"Heart Burn\" with Include Autocoded Items set to \"True\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 44
 testRunner.And("rejecting coding decision for the task \"Heart Burn\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 45
 testRunner.Then("the task \"Heart Burn\" should have a status of \"Waiting Manual Code\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("User has the option to reject the coding decision of reclassified term")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168609_04")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.Timeout(300000)]
        public virtual void UserHasTheOptionToRejectTheCodingDecisionOfReclassifiedTerm()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("User has the option to reject the coding decision of reclassified term", new string[] {
                        "VAL",
                        "PBMCC_168609_04",
                        "Release2015.3.0",
                        "IncreaseTimeout_300000"});
#line 52
this.ScenarioSetup(scenarioInfo);
#line 53
 testRunner.Given("a \"Reconsider\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA E" +
                    "NG 15.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 54
 testRunner.And("coding task \"Heart Burn\" for dictionary level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 55
 testRunner.When("task \"Heart Burn\" is coded to term \"Reflux gastritis\" at search level \"Low Level " +
                    "Term\" with code \"10057969\" at level \"LLT\" and a synonym is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 56
 testRunner.And("reclassifying task \"Heart Burn\" with Include Autocoded Items set to \"True\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 57
 testRunner.And("rejecting coding decision for the task \"Heart Burn\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 58
 testRunner.Then("the task \"Heart Burn\" should have a status of \"Waiting Manual Code\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A Coder user can Reclassify a group and place it in the \"Reconsider\" state")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168609_05")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.Timeout(300000)]
        public virtual void ACoderUserCanReclassifyAGroupAndPlaceItInTheReconsiderState()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A Coder user can Reclassify a group and place it in the \"Reconsider\" state", new string[] {
                        "VAL",
                        "PBMCC_168609_05",
                        "Release2015.3.0",
                        "IncreaseTimeout_300000"});
#line 65
this.ScenarioSetup(scenarioInfo);
#line 66
 testRunner.Given("a \"Reconsider\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA E" +
                    "NG 15.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Dictionary Level"});
            table1.AddRow(new string[] {
                        "Heart Burn",
                        "LLT"});
            table1.AddRow(new string[] {
                        "Heart Burn",
                        "LLT"});
#line 67
 testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table1, "When ");
#line 71
 testRunner.And("task \"Heart Burn\" is coded to term \"Reflux gastritis\" at search level \"Low Level " +
                    "Term\" with code \"10057969\" at level \"LLT\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 72
 testRunner.And("approving task \"HEART BURN\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 73
 testRunner.And("reclassifying group for the task \"HEART BURN\" with Include Autocoded Items set to" +
                    " \"True\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 74
 testRunner.Then("the task \"Heart Burn\" should have a status of \"Reconsider\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A Coder user can Reclassify group and retire the mapped synonym")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_168609_06")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.Timeout(300000)]
        public virtual void ACoderUserCanReclassifyGroupAndRetireTheMappedSynonym()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A Coder user can Reclassify group and retire the mapped synonym", new string[] {
                        "VAL",
                        "PBMCC_168609_06",
                        "Release2015.3.0",
                        "IncreaseTimeout_300000"});
#line 80
this.ScenarioSetup(scenarioInfo);
#line 81
 testRunner.Given("a \"Basic\" Coder setup with registered synonym list \"MedDRA ENG 15.0 Clear_Match\" " +
                    "containing entry \"HEADACHE|10019211|LLT|LLT:10019211;PT:10019211;HLT:10019233;HL" +
                    "GT:10019231;SOC:10029205|True|AE.AECAT:OTHER|Approved|Headache\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Dictionary Level"});
            table2.AddRow(new string[] {
                        "Heart Burn",
                        "LLT"});
            table2.AddRow(new string[] {
                        "Heart Burn",
                        "LLT"});
#line 82
 testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table2, "When ");
#line 86
 testRunner.And("task \"Heart Burn\" is coded to term \"Reflux gastritis\" at search level \"Low Level " +
                    "Term\" with code \"10057969\" at level \"LLT\" and a synonym is created", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 87
 testRunner.And("reclassifying and retiring group for the task \"HEART BURN\" with Include Autocoded" +
                    " Items set to \"True\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 88
 testRunner.Then("the synonym for verbatim \"HEART BURN\" and code \"10057969\" should not exist", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A Coder user shall not be able to reclassify a task while the task\'s study is bei" +
            "ng migrated")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_193388_002")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.Timeout(600000)]
        public virtual void ACoderUserShallNotBeAbleToReclassifyATaskWhileTheTaskSStudyIsBeingMigrated()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A Coder user shall not be able to reclassify a task while the task\'s study is bei" +
                    "ng migrated", new string[] {
                        "VAL",
                        "PBMCC_193388_002",
                        "Release2015.3.0",
                        "IncreaseTimeout_600000"});
#line 94
this.ScenarioSetup(scenarioInfo);
#line 96
    testRunner.Given("a \"Basic\" Coder setup with registered synonym list \"MedDRA ENG 14.0 Empty_List\" c" +
                    "ontaining entry \"\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 97
    testRunner.And("an activated synonym list \"MedDRA ENG 15.0 New_Primary_List\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 98
    testRunner.When("the following externally managed verbatim requests are made \"Tasks_1000_MedDRA_Ma" +
                    "tch_Upload.json\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 99
    testRunner.When("performing study migration without waiting", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 100
    testRunner.Then("reclassification of coding task \"ABRASIONS\" cannot occur while the study migratio" +
                    "n is in progress", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 101
    testRunner.And("study migration is complete for the latest version", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 102
    testRunner.When("reclassifying task \"ABRASIONS\" with comment \"Reclassified After Study Migration\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 103
    testRunner.And("I view task \"ABRASIONS\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 104
    testRunner.Then("the task \"ABRASIONS\" should have a status of \"Waiting Manual Code\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
