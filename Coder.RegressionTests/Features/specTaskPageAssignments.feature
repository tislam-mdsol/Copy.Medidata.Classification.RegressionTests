@specTaskPageAssignments.feature
@CoderCore
Feature: This feature file will verify the display history of all coding assignments for the task selected in the Tasks List, including properties for each dictionary level of an assignment.

	The following environment configuration settings were enabled:

	Empty Synonym Lists Registered:
	Synonym List 1: MedDRA       (ENG) 11.0   Primary List
	Synonym List 2: WhoDrugDDEB2 (ENG) 200703 Primary List
	Synonym List 3: WhoDrugDDEC  (ENG) 200703 Primary List

	Common Configurations:
	Configuration Name		| Force Primary Path Selection (MedDRA) | Synonym Creation Policy Flag | Bypass Reconsider Upon Reclassify | Default Select Threshold | Default Suggest Threshold | Auto Add Synonyms | Auto Approve | Term Requires Approval (IsApprovalRequired )  | Term Auto Approve with synonym (IsAutoApproval)   |
	Basic					| TRUE                                  | Always Active                | TRUE                              | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE                                              |
	Reconsider Bypass On	| TRUE                                  | Always Active                | TRUE                              | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE                                              |
	Reconsider Bypass Off	| TRUE                                  | Always Active                | FALSE                             | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE                                              |
	Waiting Approval		| TRUE                                  | Always Active                | FALSE                             | 100                      | 70                        | FALSE             | FALSE        | TRUE	                                         | FALSE                                             |
	
@VAL
@Release2015.3.0 
@PBMCC_163273_001
@SmokeTest
Scenario: The following will appear for Assignments Properties information for a status of Waiting Manual

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
  When the following externally managed verbatim requests are made
      | Verbatim Term   | Dictionary Level |
      | Adverse Event 4 | LLT              |
  When I view task "Adverse Event 4"
  Then I verify Assignment Detail information displayed is No data
  And I verify Coding Assignments Path information displayed is No data
		
@VAL
@Release2015.3.0
@PBMCC_163273_002
Scenario: The following will appear for Assignments Properties information for a term that has been auto coded and waiting approval which will now have an active coding decision

  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 200703"  
  When the following externally managed verbatim requests are made
      | Verbatim Term  | Dictionary Level |
      | ASPIRIN PLUS C | PRODUCT          |
  When I view task "ASPIRIN PLUS C"
  Then I verify the following Assignment Detail information is displayed
		| Dictionary            | User         | Term                          | Is Auto Coded | Is Active |
		| WhoDrugDDEB2 - 200703 | <SystemUser> | 003467 01 001: ASPIRIN PLUS C | Checked       | Checked   |
  And I verify the following Coding Assignments Path information is displayed
		| Level   | Code          | Term                              |
		| ATC     | N             | NERVOUS SYSTEM                    |
		| ATC     | N02           | ANALGESICS                        |
		| ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |
		| ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |
		| PRODUCT | 003467 01 001 | ASPIRIN PLUS C                    |

@VAL
@Release2015.3.0
@PBMCC_163273_003
Scenario: The following will appear for Assignments Properties information for a term waiting for coding through browser tree

  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 200703"  
  When the following externally managed verbatim requests are made
      | Verbatim Term   | Dictionary Level |
      | Adverse Event 4 | PRODUCT          |
  When task "Adverse Event 4" is coded to term "ASPIRIN PLUS C" at search level "Preferred Name" with code "003467 01 001" at level "PN" and a synonym is created
  And I view task "Adverse Event 4"
  Then I verify the following Assignment Detail information is displayed
		| Dictionary            | User   | Term                          | Is Auto Coded | Is Active |
		| WhoDrugDDEB2 - 200703 | <User> | 003467 01 001: ASPIRIN PLUS C | Unchecked     | Checked   |

@VAL
@Release2015.3.0
@PBMCC_163273_004
Scenario: The following will appear for Assignments Properties information for a term that was auto coded and was inactivated after selecting to recode the coding decision

  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 200703"  
  When the following externally managed verbatim requests are made
      | Verbatim Term | Dictionary Level |
      | SALICYLAMIDE  | PRODUCT          |
  When I recode task "SALICYLAMIDE" with comment "Recoding."
  Then I verify the following Assignment Detail information is displayed
		| Dictionary            | User         | Term                        | Is Auto Coded | Is Active |
		| WhoDrugDDEB2 - 200703 | <SystemUser> | 000965 01 001: SALICYLAMIDE | Checked       | Unchecked |

@VAL
@Release2015.3.0
@PBMCC_163273_005
@IncreaseTimeout
Scenario: The following information will be available to the client as an Assignment Property information for a status of Reconsider with Bypass Reconsider Upon Reclassify turned off

  Given a "Reconsider Bypass Off" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0" 
  When the following externally managed verbatim requests are made
      | Verbatim Term      | Dictionary Level |
      | Dizziness postural | LLT              |
  When reclassifying task "Dizziness postural" with comment "Regression testing" in a "Reconsider Bypass Off" coder setup
  And task "Dizziness postural" is coded to term "Dizzy on standing" at search level "Low Level Term" with code "10013581" at level "LLT"
  And I view task "Dizziness postural"
  Then I verify the following Assignment Detail information is displayed
		| Dictionary    | User         | Term                         | Is Auto Coded | Is Active |
		| MedDRA - 11.0 | <User>       | 10013581: Dizzy on standing  | Unchecked     | Checked   |
		| MedDRA - 11.0 | <SystemUser> | 10013578: Dizziness postural | Checked       | Unchecked |
		

@VAL
@Release2015.3.0
@PBMCC_163273_006
Scenario: The following information will be available to the client as an Assignment Property information for a status of Reconsider with Bypass Reconsider Upon Reclassify turned on

  Given a "Reconsider Bypass On" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0" 
  When the following externally managed verbatim requests are made
      | Verbatim Term      | Dictionary Level |
      | Dizziness postural | LLT              |
  When reclassifying task "Dizziness postural" with comment "Regression testing" in a "Reconsider Bypass On" coder setup
  And I view task "Dizziness postural"
  Then I verify the following Assignment Detail information is displayed
		| Dictionary    | User         | Term                         | Is Auto Coded | Is Active |
		| MedDRA - 11.0 | <SystemUser> | 10013578: Dizziness postural | Checked       | Unchecked |
		