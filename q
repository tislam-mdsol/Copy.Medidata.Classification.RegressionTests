[1mdiff --git a/Coder.EndToEndTests/Features/specETE_MCC_62552_AffectingCodedDecisionsBasic.feature b/Coder.EndToEndTests/Features/specETE_MCC_62552_AffectingCodedDecisionsBasic.feature[m
[1mindex a67ac31..bb0e89a 100644[m
[1m--- a/Coder.EndToEndTests/Features/specETE_MCC_62552_AffectingCodedDecisionsBasic.feature[m
[1m+++ b/Coder.EndToEndTests/Features/specETE_MCC_62552_AffectingCodedDecisionsBasic.feature[m
[36m@@ -1,30 +1,29 @@[m
 Feature: Verify coded decisions are affected properly with markings and other EDC functionality for Coder supplemental and component values. Only a change in supplement, component or the coding term will cause the coding decision to break.[m
 [m
 @DFT[m
[31m-#@EndToEndDynamicSegment[m
 @DebugEndToEndDynamicSegment[m
 Scenario: A coding decision remains on the verbatim when a query is opened against a verbatim field.[m
[31m-	Given a Rave project registration with dictionary "MedDRA ENG 18.0"[m
[32m+[m	[32mGiven a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"[m
 	And Rave Modules App Segment is loaded[m
  	And a Rave Coder setup with the following options[m
 	| Form | Field        | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |[m
[31m-	| ETE2 | Coding Field | <Dictionary> | <Locale> | LLT          | 1        | true               | true           | LogSuppField2     |[m
[32m+[m	[32m| ETE2 | Coding Field | <Dictionary> | <Locale> | TN           | 1        | true               | true           | LogSuppField2     |[m
 	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"[m
 	And adding a new subject "TST"[m
 	And adding a new verbatim term to form "ETE2"[m
[31m- 	| Field          | Value           | ControlType | Control Value |[m
[31m- 	| Coding Field A | Drug Verbatim 1 | LongText    |               |[m
[31m- 	#| SUP1AGE        | Twenty          | SelectList  | Other         |[m
[32m+[m[41m [m	[32m| Field        | Value           | ControlType | Control Value |[m
[32m+[m[41m [m	[32m| Coding Field | Drug Verbatim 1 | LongText    |               |[m
[32m+[m[41m [m	[32m| SUP1AGE      | Twenty          | SelectList  | Other         |[m
 	And Coder App Segment is loaded[m
 	When task "Drug Verbatim 1" is coded to term "BAYER CHILDREN'S COLD" at search level "Preferred Name" with code "005581 01 001" at level "PN" and a synonym is created[m
[31m-	Then the coding decision for verbatim "Drug Verbatim 1" on form "ETEMCC62552" for field "AETerm" contains the following data[m
[32m+[m	[32mThen the coding decision for verbatim "Drug Verbatim 1" on form "ETE2" for field "Coding Field" contains the following data[m
 		| ATC     | N             | NERVOUS SYSTEM                    |[m
 		| ATC     | N02           | ANALGESICS                        |[m
 		| ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |[m
 		| ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |[m
 		| PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             | [m
 	When Rave Modules App Segment is loaded[m
[31m-	And row on form "ETEMCC62552" containing "Drug Verbatim 1" is marked with a query [m
[32m+[m	[32mAnd row on form "ETE2" containing "Drug Verbatim 1" is marked with a query[m[41m [m
 	# change containing to field value may be, also add one scenario for opening a query on verbatim and one for supplemental for verbatim and another set for stickies[m
 	Then the coding decision for verbatim "child advil cold extreme" on form "ETE2" for field "Coding Field" contains the following data[m
 		| ATC     | N             | NERVOUS SYSTEM                    |[m
[1mdiff --git a/Coder.EndToEndTests/Features/specETE_MCC_62552_AffectingCodedDecisionsBasic.feature.cs b/Coder.EndToEndTests/Features/specETE_MCC_62552_AffectingCodedDecisionsBasic.feature.cs[m
[1mindex 0ea0066..7997283 100644[m
[1m--- a/Coder.EndToEndTests/Features/specETE_MCC_62552_AffectingCodedDecisionsBasic.feature.cs[m
[1m+++ b/Coder.EndToEndTests/Features/specETE_MCC_62552_AffectingCodedDecisionsBasic.feature.cs[m
[36m@@ -79,11 +79,11 @@[m [mpublic virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainst[m
                     "im field.", new string[] {[m
                         "DFT",[m
                         "DebugEndToEndDynamicSegment"});[m
[31m-#line 6[m
[32m+[m[32m#line 5[m
 this.ScenarioSetup(scenarioInfo);[m
[32m+[m[32m#line 6[m
[32m+[m[32m testRunner.Given("a Rave project registration with dictionary \"WhoDrug-DDE-B2 ENG 200703\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");[m
 #line 7[m
[31m- testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 18.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");[m
[31m-#line 8[m
  testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");[m
 #line hidden[m
             TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {[m
[36m@@ -101,17 +101,17 @@[m [mpublic virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainst[m
                         "Coding Field",[m
                         "<Dictionary>",[m
                         "<Locale>",[m
[31m-                        "LLT",[m
[32m+[m[32m                        "TN",[m
                         "1",[m
                         "true",[m
                         "true",[m
                         "LogSuppField2"});[m
[31m-#line 9[m
[32m+[m[32m#line 8[m
   testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table1, "And ");[m
[31m-#line 12[m
[32m+[m[32m#line 11[m
  testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +[m
                     "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");[m
[31m-#line 13[m
[32m+[m[32m#line 12[m
  testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");[m
 #line hidden[m
             TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {[m
[36m@@ -120,15 +120,20 @@[m [mpublic virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainst[m
                         "ControlType",[m
                         "Control Value"});[m
             table2.AddRow(new string[] {[m
[31m-                        "Coding Field A",[m
[32m+[m[32m                        "Coding Field",[m
                         "Drug Verbatim 1",[m
                         "LongText",[m
                         ""});[m
[31m-#line 14[m
[32m+[m[32m            table2.AddRow(new string[] {[m
[32m+[m[32m                        "SUP1AGE",[m
[32m+[m[32m                        "Twenty",[m
[32m+[m[32m                        "SelectList",[m
[32m+[m[32m                        "Other"});[m
[32m+[m[32m#line 13[m
  testRunner.And("adding a new verbatim term to form \"ETE2\"", ((string)(null)), table2, "And ");[m
[31m-#line 18[m
[32m+[m[32m#line 17[m
  testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");[m
[31m-#line 19[m
[32m+[m[32m#line 18[m
  testRunner.When("task \"Drug Verbatim 1\" is coded to term \"BAYER CHILDREN\'S COLD\" at search level \"" +[m
                     "Preferred Name\" with code \"005581 01 001\" at level \"PN\" and a synonym is created" +[m
                     "", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");[m
[36m@@ -153,13 +158,13 @@[m [mpublic virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainst[m
                         "PRODUCT",[m
                         "005581 01 001",[m
                         "BAYER CHILDREN\'S COLD"});[m
[31m-#line 20[m
[31m- testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETEMCC62552\" for fiel" +[m
[31m-                    "d \"AETerm\" contains the following data", ((string)(null)), table3, "Then ");[m
[31m-#line 26[m
[32m+[m[32m#line 19[m
[32m+[m[32m testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETE2\" for field \"Codi" +[m
[32m+[m[32m                    "ng Field\" contains the following data", ((string)(null)), table3, "Then ");[m
[32m+[m[32m#line 25[m
  testRunner.When("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");[m
[31m-#line 27[m
[31m- testRunner.And("row on form \"ETEMCC62552\" containing \"Drug Verbatim 1\" is marked with a query", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");[m
[32m+[m[32m#line 26[m
[32m+[m[32m testRunner.And("row on form \"ETE2\" containing \"Drug Verbatim 1\" is marked with a query", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");[m
 #line hidden[m
             TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {[m
                         "ATC",[m
[36m@@ -181,7 +186,7 @@[m [mpublic virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainst[m
                         "PRODUCT",[m
                         "005581 01 001",[m
                         "BAYER CHILDREN\'S COLD"});[m
[31m-#line 29[m
[32m+[m[32m#line 28[m
  testRunner.Then("the coding decision for verbatim \"child advil cold extreme\" on form \"ETE2\" for fi" +[m
                     "eld \"Coding Field\" contains the following data", ((string)(null)), table4, "Then ");[m
 #line hidden[m
[36m@@ -199,11 +204,11 @@[m [mpublic virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainst[m
                     "ental field.", new string[] {[m
                         "DFT",[m
                         "EndToEndDynamicSegment"});[m
[31m-#line 39[m
[32m+[m[32m#line 38[m
 this.ScenarioSetup(scenarioInfo);[m
[31m-#line 40[m
[32m+[m[32m#line 39[m
  testRunner.Given("a Rave project registration with dictionary \"MedDRA ENG 18.0\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");[m
[31m-#line 41[m
[32m+[m[32m#line 40[m
  testRunner.And("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");[m
 #line hidden[m
             TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {[m
[36m@@ -226,12 +231,12 @@[m [mpublic virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainst[m
                         "true",[m
                         "true",[m
                         "SUP1AGE"});[m
[31m-#line 42[m
[32m+[m[32m#line 41[m
   testRunner.And("a Rave Coder setup with the following options", ((string)(null)), table5, "And ");[m
[31m-#line 45[m
[32m+[m[32m#line 44[m
  testRunner.When("a Rave Draft is published and pushed using draft \"<DraftName>\" for Project \"<Stud" +[m
                     "yName>\" to environment \"Prod\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");[m
[31m-#line 46[m
[32m+[m[32m#line 45[m
  testRunner.And("adding a new subject \"TST\"", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");[m
 #line hidden[m
             TechTalk.SpecFlow.Table table6 = new TechTalk.SpecFlow.Table(new string[] {[m
[36m@@ -244,11 +249,11 @@[m [mpublic virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainst[m
                         "Drug Verbatim 1",[m
                         "LongText",[m
                         ""});[m
[31m-#line 47[m
[32m+[m[32m#line 46[m
  testRunner.And("adding a new verbatim term to form \"ETEMCC62552\"", ((string)(null)), table6, "And ");[m
[31m-#line 51[m
[32m+[m[32m#line 50[m
  testRunner.And("Coder App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");[m
[31m-#line 52[m
[32m+[m[32m#line 51[m
  testRunner.When("task \"Drug Verbatim 1\" is coded to term \"BAYER CHILDREN\'S COLD\" at search level \"" +[m
                     "Preferred Name\" with code \"005581 01 001\" at level \"PN\" and a synonym is created" +[m
                     "", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");[m
[36m@@ -273,12 +278,12 @@[m [mpublic virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainst[m
                         "PRODUCT",[m
                         "005581 01 001",[m
                         "BAYER CHILDREN\'S COLD"});[m
[31m-#line 53[m
[32m+[m[32m#line 52[m
  testRunner.Then("the coding decision for verbatim \"Drug Verbatim 1\" on form \"ETEMCC62552\" for fiel" +[m
                     "d \"AETerm\" contains the following data", ((string)(null)), table7, "Then ");[m
[31m-#line 59[m
[32m+[m[32m#line 58[m
  testRunner.When("Rave Modules App Segment is loaded", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");[m
[31m-#line 60[m
[32m+[m[32m#line 59[m
  testRunner.And("row on form \"ETEMCC62552\" containing \"Drug Verbatim 1\" is marked with a query", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");[m
 #line hidden[m
             TechTalk.SpecFlow.Table table8 = new TechTalk.SpecFlow.Table(new string[] {[m
[36m@@ -301,7 +306,7 @@[m [mpublic virtual void ACodingDecisionRemainsOnTheVerbatimWhenAQueryIsOpenedAgainst[m
                         "PRODUCT",[m
                         "005581 01 001",[m
                         "BAYER CHILDREN\'S COLD"});[m
[31m-#line 62[m
[32m+[m[32m#line 61[m
  testRunner.Then("the coding decision for verbatim \"child advil cold extreme\" on form \"ETE2\" for fi" +[m
                     "eld \"Coding Field\" contains the following data", ((string)(null)), table8, "Then ");[m
 #line hidden[m
[1mdiff --git a/Coder.TestSteps/StepDefinitions/StepHooks.cs b/Coder.TestSteps/StepDefinitions/StepHooks.cs[m
[1mindex df0f59b..ed822cd 100644[m
[1m--- a/Coder.TestSteps/StepDefinitions/StepHooks.cs[m
[1m+++ b/Coder.TestSteps/StepDefinitions/StepHooks.cs[m
[36m@@ -85,16 +85,16 @@[m [mpublic void BeforeDebugEndToEndScenarioDynamicSegment()[m
             };[m
             _StepContext.CoderAdminUser   = adminUser;[m
 [m
[31m-            var newStudyGroup             = CreateSegmentSetupData("MDF101e9b861818");[m
[32m+[m[32m            var newStudyGroup             = CreateSegmentSetupData("95e2d4e01891");[m
             _StepContext.SegmentUnderTest = newStudyGroup;[m
 [m
             SetSegmentContext(newStudyGroup);[m
             MedidataUser newUser = new MedidataUser[m
             {[m
[31m-                Username = "medidatacoder+MDF101e9b861818@gmail.com",[m
[32m+[m[32m                Username = "medidatacoder+MDF95e2d4e01891@gmail.com",[m
                 Password = "Password1",[m
[31m-                Email = "medidatacoder+MDF101e9b861818@gmail.com",[m
[31m-                MedidataId = "101e9b861818",[m
[32m+[m[32m                Email = "medidatacoder+MDF95e2d4e01891@gmail.com",[m
[32m+[m[32m                MedidataId = "95e2d4e01891",[m
                 FirstName = "Coder"[m
             };[m
             _StepContext.CoderTestUser = newUser;[m
[1mdiff --git a/Medidata.Classification.RegressionTests.sln b/Medidata.Classification.RegressionTests.sln[m
[1mindex b961f61..c1f3db4 100644[m
[1m--- a/Medidata.Classification.RegressionTests.sln[m
[1m+++ b/Medidata.Classification.RegressionTests.sln[m
[36m@@ -13,8 +13,14 @@[m [mProject("{2150E333-8FDC-42A3-9474-1A3956D46DE8}") = ".nuget", ".nuget", "{9D21F1[m
 	EndProjectSection[m
 EndProject[m
 Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "Coder.EndToEndTests", "Coder.EndToEndTests\Coder.EndToEndTests.csproj", "{57B8FA7D-8B1F-4BAF-ABB4-2B6E4BEF20F1}"[m
[32m+[m	[32mProjectSection(ProjectDependencies) = postProject[m
[32m+[m		[32m{F78BDA11-98EB-45BC-AD23-120E600A6A19} = {F78BDA11-98EB-45BC-AD23-120E600A6A19}[m
[32m+[m	[32mEndProjectSection[m
 EndProject[m
 Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "Coder.TestSteps", "Coder.TestSteps\Coder.TestSteps.csproj", "{F78BDA11-98EB-45BC-AD23-120E600A6A19}"[m
[32m+[m	[32mProjectSection(ProjectDependencies) = postProject[m
[32m+[m		[32m{02EAE425-8FF4-4726-951F-7155EE9BC11D} = {02EAE425-8FF4-4726-951F-7155EE9BC11D}[m
[32m+[m	[32mEndProjectSection[m
 EndProject[m
 Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "Coder.ApplicationMonitoringTests", "Coder.ApplicationMonitoringTests\Coder.ApplicationMonitoringTests.csproj", "{1D19FFD2-5F3A-4C8D-B196-701F478530EC}"[m
 EndProject[m
