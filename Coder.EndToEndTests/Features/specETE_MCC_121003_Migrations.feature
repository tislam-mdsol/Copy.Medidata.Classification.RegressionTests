@specETE_MCC_121003_Migrations.feature

@EndToEndDynamicSegment
Feature:  Verify MCC_121003 Migrations

@VAL
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
 	| Coding Field | Drug Verbatim 1 | LongText    |
	And Coder App Segment is loaded
	When task "Drug Verbatim 1" is coded to term "BAYER CHILDREN'S COLD" at search level "Preferred Name" with code "005581 01 001" at level "PN" and a synonym is created
	And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "Drug Verbatim 1" on form "ETE2" for field "Coding Field" contains the following data
	 | Level   | Code          | Term Path                         |
	 | ATC     | N             | NERVOUS SYSTEM                    |
	 | ATC     | N02           | ANALGESICS                        |
	 | ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |
	 | ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |
	 | PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |
	When a Rave Coder setup is configured with the following options
	| Form | Field        | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2 | Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | true               | true           |
	And a Rave Draft is published using draft "<DraftName>" for Project "<StudyName>"
	And an Amendment Manager migration is started for Project "<StudyName>" 
	Then the coding decision for verbatim "Drug Verbatim 1" on form "ETE2" for field "Coding Field" should not display
		 | Level   | Code          | Term Path                         |
		 | PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |
	When Coder App Segment is loaded
	Then task "Drug Verbatim 1" should contain the following source term information
       | Source System | Study              | Dictionary            | Locale | Term            | Level      | Priority |
       | Rave EDC      | <StudyDisplayName> | WhoDrugDDEB2 - 200703 | ENG    | Drug Verbatim 1 | Trade Name | 1        |
	When task "Drug Verbatim 1" is coded to term "BAYER CHILDREN'S COLD" at search level "Preferred Name" with code "005581 01 001" at level "PN" and a synonym is created
	And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "Drug Verbatim 1" on form "ETE2" for field "Coding Field" contains the following data
	 | Level   | Code          | Term Path                         |
	 | ATC     | N             | NERVOUS SYSTEM                    |
	 | ATC     | N02           | ANALGESICS                        |
	 | ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |
	 | ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |
	 | PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |

@VAL
@PBMCC121003_2
@Release2016.2.0
Scenario: Enter project registration in Coder, setup Rave study with Coder Coding fields, enter data in EDC, migrate study in Rave from Medidata Coder Coding to Medidata Coder Coding but with adding supplemental value, then verify terms appear in Coder after migration. 
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
	| Form | Field        | Dictionary   | Locale | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2 | Coding Field | <Dictionary> |        | PRODUCT      | 1        | true               | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	When a Rave Coder setup is configured with the following options
	| Form | Field        | Dictionary   | Locale | Coding Level | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
	| ETE2 | Coding Field | <Dictionary> |        | PRODUCT      | 1        | true               | true           | LogSuppField2     |
	When a Rave Draft is published using draft "<DraftName>" for Project "<StudyName>"
	And adding a new verbatim term to form "ETE2"
 	| Field                    | Value           | ControlType |
 	| Coding Field             | Drug Verbatim 1 | LongText    |
 	| Log Supplemental Field B | Top             |             |
	And an Amendment Manager migration is started for Project "<StudyName>" 
	Then the coding decision for verbatim "Drug Verbatim 1" on form "ETE2" for field "Coding Field" should not display
		 | Level   | Code          | Term Path                         |
		 | PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |
	When Coder App Segment is loaded
	Then the "Drug Verbatim 1" task has the following supplemental information
	   | Term               | Value |
	   | ETE2.LOGSUPPFIELD2 | Top   |
	When task "Drug Verbatim 1" is coded to term "BAYER CHILDREN'S COLD" at search level "Preferred Name" with code "005581 01 001" at level "PN" and a synonym is created
	And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "Drug Verbatim 1" on form "ETE2" for field "Coding Field" contains the following data
	 | Level   | Code          | Term Path                         |
	 | ATC     | N             | NERVOUS SYSTEM                    |
	 | ATC     | N02           | ANALGESICS                        |
	 | ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |
	 | ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |
	 | PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |	