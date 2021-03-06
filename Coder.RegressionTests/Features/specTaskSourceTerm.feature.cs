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
    [NUnit.Framework.DescriptionAttribute("This feature will verify that Coder will display Source information on a term.")]
    [NUnit.Framework.CategoryAttribute("specTaskSourceTerm.feature")]
    [NUnit.Framework.CategoryAttribute("CoderCore")]
    public partial class ThisFeatureWillVerifyThatCoderWillDisplaySourceInformationOnATerm_Feature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "specTaskSourceTerm.feature"
#line hidden
        
        [NUnit.Framework.TestFixtureSetUpAttribute()]
        public virtual void FeatureSetup()
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "This feature will verify that Coder will display Source information on a term.", "\r\n- The following source term attributes are needed to be available to the client" +
                    " in order to obtain information about a term:\r\n\r\n Source information   Source Co" +
                    "ding information   EDC information   Component information   Supplemental inform" +
                    "ation\r\n ------------------   -------------------------   ---------------   -----" +
                    "----------------   ------------------------\r\n Source System        Dictionary   " +
                    "               Field             Component Name          Supplemental Name\r\n Stu" +
                    "dy                Locale                      Line              Component Value " +
                    "        Supplemental Value\r\n                      Priority                    Fo" +
                    "rm\r\n                      Level                       Event\r\n                   " +
                    "   Term                        Subject\r\n                                        " +
                    "          Site\r\n\r\nSource System: The integrated system that is the source of whe" +
                    "re the term came from.\r\nStudy:         The iMedidata study that was created for " +
                    "that Study Group / Segment\r\n\r\nDictionary: The medical coding dictionary name whe" +
                    "re the term will be coded in.\r\nLocale:     The coding dictionary\'s locale, such " +
                    "as ENG or JPN\r\nPriority:   The number associated with the relative priority of t" +
                    "he task as set up in EDC for that form. The task with the highest priority shows" +
                    " the smallest number.\r\nLevel:      The term\'s coding level.\r\nTerm:       The ver" +
                    "batim and entered text submission to be coded.\r\n\r\nField:   The field the verbati" +
                    "m was entered in. (In EDC correlates to Field OID)\r\nLine:    The line the verbat" +
                    "im was entered in.   (In EDC correlates to Log-line Number)\r\nForm:    The form t" +
                    "he verbatim was entered in.   (In EDC correlates to Form OID)\r\nEvent:   The even" +
                    "t the verbatim was entered in.\r\nSubject: The subject\'s name the verbatim was ent" +
                    "ered for.\r\nSite:    The site\'s name where the verbatim was entered.\r\n\r\nSupplemen" +
                    "tal Name:  From Dictionary Term Search, text of additional properties for the ve" +
                    "rbatim term.\r\nSupplemental Value: From Dictionary Term Search, text showing exac" +
                    "t match of supplemental name.\r\n\r\nComponent Name:  From Dictionary Term Search, t" +
                    "ext of additional properties for verbatim term.\r\nComponent Value: From the Dicti" +
                    "onary Term Search, text showing exact match of component or component type.\r\n\r\n\r" +
                    "\n- Reference the coding help information residing in:  https://learn.mdsol.com/d" +
                    "isplay/CODERprd/Viewing+Coder+Transaction+Details+While+Coding?lang=en#ViewingCo" +
                    "derTransactionDetailsWhileCoding-ViewSourceTerms\r\n\r\n\r\n- The following environmen" +
                    "t configuration settings were enabled:\r\n\r\n Empty Synonym Lists Registered:\r\n Syn" +
                    "onym List 1: MedDRA       (ENG) 15.0   Primary List\r\n\r\n Common Configurations:\r\n" +
                    " Configuration Name | Force Primary Path Selection (MedDRA) | Synonym Creation P" +
                    "olicy Flag | Bypass Reconsider Upon Reclassify | Default Select Threshold | Defa" +
                    "ult Suggest Threshold | Auto Add Synonyms | Auto Approve | Term Requires Approva" +
                    "l (IsApprovalRequired )  | Term Auto Approve with synonym (IsAutoApproval)   |\r\n" +
                    " Basic              | TRUE                                  | Always Active     " +
                    "           | TRUE                              | 100                      | 70  " +
                    "                      | TRUE              | FALSE        | TRUE                 " +
                    "                         | TRUE                                              |", ProgrammingLanguage.CSharp, new string[] {
                        "specTaskSourceTerm.feature",
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
        [NUnit.Framework.DescriptionAttribute("The following information will be available to the client as Source Term informat" +
            "ion as well as testing auto coding")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        [NUnit.Framework.CategoryAttribute("PBMCC_152100_001a")]
        [NUnit.Framework.CategoryAttribute("SmokeTest")]
        public virtual void TheFollowingInformationWillBeAvailableToTheClientAsSourceTermInformationAsWellAsTestingAutoCoding()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("The following information will be available to the client as Source Term informat" +
                    "ion as well as testing auto coding", new string[] {
                        "VAL",
                        "Release2015.3.0",
                        "PBMCC_152100_001a",
                        "SmokeTest"});
#line 55
this.ScenarioSetup(scenarioInfo);
#line 57
  testRunner.Given("a \"Waiting Approval\" Coder setup with no tasks and no synonyms and dictionary \"Me" +
                    "dDRA ENG 15.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Dictionary Level"});
            table1.AddRow(new string[] {
                        "Toxic effect of venom",
                        "LLT"});
#line 58
  testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table1, "When ");
#line 61
  testRunner.Then("the task \"Toxic effect of venom\" should have a status of \"Waiting Approval\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Source System",
                        "Study",
                        "Dictionary",
                        "Locale",
                        "Term",
                        "Level",
                        "Priority"});
            table2.AddRow(new string[] {
                        "<SourceSystem>",
                        "<StudyDisplayName>",
                        "MedDRA - 15.0",
                        "ENG",
                        "Toxic effect of venom",
                        "Low Level Term",
                        "1"});
#line 62
  testRunner.And("I verify the following Source Term information is displayed", ((string)(null)), table2, "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("The following information will be available to the client as a term\'s source info" +
            "rmation:   Source System, Study, Dictionary, Locale, Term, Level, Priority")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_152100_001")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void TheFollowingInformationWillBeAvailableToTheClientAsATermSSourceInformationSourceSystemStudyDictionaryLocaleTermLevelPriority()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("The following information will be available to the client as a term\'s source info" +
                    "rmation:   Source System, Study, Dictionary, Locale, Term, Level, Priority", new string[] {
                        "VAL",
                        "PBMCC_152100_001",
                        "Release2015.3.0"});
#line 70
this.ScenarioSetup(scenarioInfo);
#line 71
  testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Dictionary Level"});
            table3.AddRow(new string[] {
                        "Adverse Event Term 1",
                        "LLT"});
#line 72
  testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table3, "When ");
#line 75
  testRunner.When("I view task \"Adverse Event Term 1\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Source System",
                        "Study",
                        "Dictionary",
                        "Locale",
                        "Term",
                        "Level",
                        "Priority"});
            table4.AddRow(new string[] {
                        "<SourceSystem>",
                        "<StudyDisplayName>",
                        "MedDRA - 15.0",
                        "ENG",
                        "Adverse Event Term 1",
                        "Low Level Term",
                        "1"});
#line 76
  testRunner.Then("I verify the following Source Term information is displayed", ((string)(null)), table4, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("The following information will be available to the client as a term\'s term EDC da" +
            "ta information:   Field, Line, Form, Event, Subject, Site")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_152100_003")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void TheFollowingInformationWillBeAvailableToTheClientAsATermSTermEDCDataInformationFieldLineFormEventSubjectSite()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("The following information will be available to the client as a term\'s term EDC da" +
                    "ta information:   Field, Line, Form, Event, Subject, Site", new string[] {
                        "VAL",
                        "PBMCC_152100_003",
                        "Release2015.3.0"});
#line 84
this.ScenarioSetup(scenarioInfo);
#line 86
  testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Dictionary Level"});
            table5.AddRow(new string[] {
                        "Adverse Event Term 1",
                        "LLT"});
#line 87
  testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table5, "When ");
#line 90
  testRunner.When("I view task \"Adverse Event Term 1\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Line",
                        "Form",
                        "Event",
                        "Subject",
                        "Site"});
            table6.AddRow(new string[] {
                        "Field 1",
                        "Line 1",
                        "Form 1",
                        "Event 1",
                        "Subject 1",
                        "Site 1"});
#line 91
  testRunner.Then("I verify the following EDC information is displayed", ((string)(null)), table6, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("The following information will be available to the client as a term\'s supplementa" +
            "l data information:   Supplemental Term, Supplemental Value")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_152100_005")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void TheFollowingInformationWillBeAvailableToTheClientAsATermSSupplementalDataInformationSupplementalTermSupplementalValue()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("The following information will be available to the client as a term\'s supplementa" +
                    "l data information:   Supplemental Term, Supplemental Value", new string[] {
                        "VAL",
                        "PBMCC_152100_005",
                        "Release2015.3.0"});
#line 98
this.ScenarioSetup(scenarioInfo);
#line 100
  testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table7 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Dictionary Level",
                        "Supplemental Field 1",
                        "Supplemental Value 1"});
            table7.AddRow(new string[] {
                        "Adverse Event Term",
                        "LLT",
                        "Field1",
                        "Oral"});
#line 101
  testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table7, "When ");
#line 104
  testRunner.When("I view task \"Adverse Event Term\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {
                        "Supplemental Term",
                        "Supplemental Value"});
            table8.AddRow(new string[] {
                        "Field1",
                        "Oral"});
#line 105
  testRunner.Then("I verify the following Supplemental information is displayed", ((string)(null)), table8, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("Non-production studies are displayed in the source term information")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_152100_006")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void Non_ProductionStudiesAreDisplayedInTheSourceTermInformation()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Non-production studies are displayed in the source term information", new string[] {
                        "VAL",
                        "PBMCC_152100_006",
                        "Release2015.3.0"});
#line 113
this.ScenarioSetup(scenarioInfo);
#line 114
  testRunner.Given("a \"Basic\" Coder setup for a non-production study with no tasks and no synonyms an" +
                    "d dictionary \"MedDRA ENG 15.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table9 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Dictionary Level"});
            table9.AddRow(new string[] {
                        "Adverse Event Term 2",
                        "LLT"});
#line 115
  testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table9, "When ");
#line 118
  testRunner.When("I view task \"Adverse Event Term 2\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table10 = new TechTalk.SpecFlow.Table(new string[] {
                        "Source System",
                        "Study",
                        "Dictionary",
                        "Locale",
                        "Term",
                        "Level",
                        "Priority"});
            table10.AddRow(new string[] {
                        "<SourceSystem>",
                        "<StudyDisplayName>",
                        "MedDRA - 15.0",
                        "ENG",
                        "Adverse Event Term 2",
                        "Low Level Term",
                        "1"});
#line 119
  testRunner.Then("I verify the following Source Term information is displayed", ((string)(null)), table10, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("A term will have multiple and blank supplemental information displayed")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_152100_008")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void ATermWillHaveMultipleAndBlankSupplementalInformationDisplayed()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A term will have multiple and blank supplemental information displayed", new string[] {
                        "VAL",
                        "PBMCC_152100_008",
                        "Release2015.3.0"});
#line 126
this.ScenarioSetup(scenarioInfo);
#line 128
  testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table11 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Dictionary Level",
                        "Supplemental Field 1",
                        "Supplemental Value 1",
                        "Supplemental Field 2",
                        "Supplemental Value 2"});
            table11.AddRow(new string[] {
                        "Adverse Event Term 3",
                        "LLT",
                        "Field1",
                        "",
                        "Field2",
                        "INDICATION ONE"});
#line 129
  testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table11, "When ");
#line 132
  testRunner.When("I view task \"Adverse Event Term 3\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table12 = new TechTalk.SpecFlow.Table(new string[] {
                        "Supplemental Term",
                        "Supplemental Value"});
            table12.AddRow(new string[] {
                        "Field1",
                        ""});
            table12.AddRow(new string[] {
                        "Field2",
                        "INDICATION ONE"});
#line 133
  testRunner.Then("I verify the following Supplemental information is displayed", ((string)(null)), table12, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("When there is no component or supplemental information, No data will be displayed" +
            "")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_152100_009")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void WhenThereIsNoComponentOrSupplementalInformationNoDataWillBeDisplayed()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("When there is no component or supplemental information, No data will be displayed" +
                    "", new string[] {
                        "VAL",
                        "PBMCC_152100_009",
                        "Release2015.3.0"});
#line 142
this.ScenarioSetup(scenarioInfo);
#line 144
  testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table13 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Dictionary Level"});
            table13.AddRow(new string[] {
                        "Adverse Event Term 4",
                        "LLT"});
#line 145
  testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table13, "When ");
#line 148
  testRunner.When("I view task \"Adverse Event Term 4\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 149
  testRunner.Then("I verify when no component or supplemental data is present and Coder displays \"No" +
                    " data\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [NUnit.Framework.TestAttribute()]
        [NUnit.Framework.DescriptionAttribute("When selecting a term the default view will display Source Term Information")]
        [NUnit.Framework.CategoryAttribute("VAL")]
        [NUnit.Framework.CategoryAttribute("PBMCC_133578_001")]
        [NUnit.Framework.CategoryAttribute("Release2015.3.0")]
        public virtual void WhenSelectingATermTheDefaultViewWillDisplaySourceTermInformation()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("When selecting a term the default view will display Source Term Information", new string[] {
                        "VAL",
                        "PBMCC_133578_001",
                        "Release2015.3.0"});
#line 155
this.ScenarioSetup(scenarioInfo);
#line 157
  testRunner.Given("a \"Basic\" Coder setup with no tasks and no synonyms and dictionary \"MedDRA ENG 15" +
                    ".0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table14 = new TechTalk.SpecFlow.Table(new string[] {
                        "Verbatim Term",
                        "Dictionary Level"});
            table14.AddRow(new string[] {
                        "Adverse Event Term",
                        "LLT"});
#line 158
  testRunner.When("the following externally managed verbatim requests are made", ((string)(null)), table14, "When ");
#line 161
  testRunner.When("I view task \"Adverse Event Term\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 162
  testRunner.Then("I verify that the default view contains Source Term information", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
