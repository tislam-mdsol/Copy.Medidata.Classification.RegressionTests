@specETE_MCC_121003_Migrations.feature

@EndToEndDynamicSegment
Feature:  Verify MCC_121003 Migrations

@DFT
@Release2016.2.0
@PBMCC_207807_1.1.2_001
Scenario: Enter project registration in Coder, setup Rave study with Coder Coding fields, enter data in EDC, migrate study in Rave from Medidata Coder Coding to Medidata Coder Coding but with different coding level, then verify terms appear in Coder after migration.
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
	| Form | Field        | Dictionary   | Locale | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2 | Coding Field | <Dictionary> |        | PRODUCT      | 1        | true               | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
 	| Field        | Value           | ControlType |
 	| Coding Field | Drug Verbatim 1 |             |
	When task "Drug Verbatim 1" is coded to term "BAYER CHILDREN'S COLD" at search level "Preferred Name" with code "005581 01 001" at level "PN" and a synonym is created
	Then the coding decision for verbatim "Drug Verbatim 1" on form "ETE2" for field "Coding Field" contains the following data
	 | Level   | Code          | Term Path                         |
	 | ATC     | N             | NERVOUS SYSTEM                    |
	 | ATC     | N02           | ANALGESICS                        |
	 | ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |
	 | ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |
	 | PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |
	When a Rave Draft is published using draft "<DraftName>" for Project "<StudyName>"
	Given a Rave Coder setup with the following options
	| Form | Field        | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2 | Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | true               | true           |
	When an Amendment Manager migration is started for Project "<StudyName>" 
	#Then Rave Adverse Events form "ETE2" should not display "BAYER CHILDREN'S COLD" 
	And Coder App Segment is loaded
	Then task "Drug Verbatim " should contain the following source term information
       | Source System  | Study                          | Dictionary            | Locale | Term             | Level      | Priority |
       | <SourceSystem> | <SourceSystemStudyDisplayName> | WhoDrugDDEB2 - 200703 | ENG    | Drug Verbatim 15 | Trade Name | 1        |
	
@DFT
@PBMCC121003_3
@Release2015.1.0
Scenario: Enter project registration in Coder, setup Rave study with Coder Coding fields, enter data in EDC, migrate study in Rave from Medidata Coder Coding to Medidata Coder Coding but with adding supplemental value, then verify terms appear in Coder after migration. 
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	And a Rave Coder setup with the following options
		| Form | Field       	| Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms      |
		| ETE2 | AETerm 		| <Dictionary> | <Locale> | LLT         | 2        | true               | true          | LogSuppField2			|
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
 	| Field         		| Value      			| ControlType | Control Value |
 	| Coding Field 		| Drug Verbatim 1 	| LongText            |               |
	When task "Drug Verbatim 1" is coded to term "BAYER CHILDREN'S COLD" at search level "Preferred Name" with code "005581 01 001" at level "PN" and a synonym is created
	Then Rave Adverse Events form "ETE2" should display 
		| ATC     | N             | NERVOUS SYSTEM                    |
		| ATC     | N02           | ANALGESICS                        |
		| ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |
		| ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |
		| PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |
	And adding a new verbatim term to form "ETE2"
  	| Field            | Value    			| ControlType 	| 
  	| Coder Field      | Drug Verbatim 1 	| LongText    	| 
  	| Log Supp Field 2 | Top   				|			 	|
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And an Amendment Manager migration is started with "SETE5<CoderRaveStudy>" in "AM Subject Search" and "SETE5<CoderRaveStudy>" in "Rave Migration Subject Seletion Dropdown"
	Then Rave Adverse Events form "ETE2" should not display "BAYER CHILDREN'S COLD" 
	And Coder App Segment is loaded
	And I verify the following Supplemental information is displayed
       | Supplemental Term   	| Supplemental Value  	|
       | LogSuppField2			| Top               	|
	