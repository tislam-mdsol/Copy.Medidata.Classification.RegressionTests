Feature: Verify coded decisions are affected properly with markings and other EDC functionality for Coder supplemental and component values. Only a change in supplement, component or the coding term will cause the coding decision to break.

@VAL
@PBMCC62552_001a
@ReleaseRave2013.1.0.1
@EndToEndDynamicSegment
Scenario: A coding decision remains on the verbatim when a query is opened against a verbatim field.
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
	| Form | Field        | Dictionary   | Locale   | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
	| ETE2 | Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | false              | false          | LogSuppField2     |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
 	| Field                    | Value            | ControlType    | Control Value |
 	| Coding Field             | Drug Verbatim 1  | LongText       |               |
 	| Log Supplemental Field B | Twenty           | SmallTextInput | Other         |
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
	When Rave Modules App Segment is loaded
	And row on form "ETE2" containing "Drug Verbatim 1" is marked with a query 
	Then the coding decision for verbatim "Drug Verbatim 1" on form "ETE2" for field "Coding Field" contains the following data
		  | Level   | Code          | Term Path                         |
		  | ATC     | N             | NERVOUS SYSTEM                    |
		  | ATC     | N02           | ANALGESICS                        |
		  | ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |
		  | ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |
		  | PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |
		
@VAL
@PBMCC62552_001b
@ReleaseRave2013.1.0.1
@EndToEndDynamicSegment
Scenario: A coding decision remains on the verbatim when a query is opened against a supplmental field.
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
	| Form | Field        | Dictionary   | Locale   | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
	| ETE2 | Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | false              | false          | LogSuppField2     |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
 	| Field                    | Value           | ControlType    | Control Value |
 	| Coding Field             | Drug Verbatim 1 | LongText       |               |
 	| Log Supplemental Field B | Twenty          | SmallTextInput | Other         |
	And Coder App Segment is loaded
	When task "Drug Verbatim 23" is coded to term "BAYER CHILDREN'S COLD" at search level "Preferred Name" with code "005581 01 001" at level "PN" and a synonym is created
	And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "Drug Verbatim 1" on form "ETE2" for field "Coding Field" contains the following data
		  | Level   | Code          | Term Path                         |
		  | ATC     | N             | NERVOUS SYSTEM                    |
		  | ATC     | N02           | ANALGESICS                        |
		  | ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |
		  | ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |
		  | PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |
	When Rave Modules App Segment is loaded
	And row on form "ETE2" containing "Twenty" is marked with a query 
	Then the coding decision for verbatim "Drug Verbatim 1" on form "ETE2" for field "Coding Field" contains the following data
		  | Level   | Code          | Term Path                         |
		  | ATC     | N             | NERVOUS SYSTEM                    |
		  | ATC     | N02           | ANALGESICS                        |
		  | ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |
		  | ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |
		  | PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |

@DFT
@PBMCC62552_001c
@ReleaseRave2013.1.0.1
@EndToEndDynamicSegment
Scenario: A coding decision remains on the verbatim when a sticky is opened against a verbatim field.
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
	| Form | Field        | Dictionary   | Locale   | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
	| ETE2 | Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | false              | false          | LogSuppField2     |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
 	| Field        | Value           | ControlType    | Control Value |
 	| Coding Field | Drug Verbatim 1 | LongText       |               |
 	| SUP1AGE      | Twenty          | SmallTextInput | Other         |
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
	When row on form "ETE2" containing "Drug Verbatim 1" is marked with a sticky
    Then the coding decision for verbatim "Drug Verbatim 1" on form "ETE2" for field "Coding Field" contains the following data
		  | Level   | Code          | Term Path                         |
		  | ATC     | N             | NERVOUS SYSTEM                    |
		  | ATC     | N02           | ANALGESICS                        |
		  | ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |
		  | ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |
		  | PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |	

@DFT
@PBMCC62552_001d
@ReleaseRave2013.1.0.1
@EndToEndDynamicSegment
Scenario: A coding decision remains on the verbatim when a sticky is opened against a supplemental field.
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
	| Form | Field        | Dictionary   | Locale   | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
	| ETE2 | Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | false              | false          | LogSuppField2     |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
 	| Field        | Value           | ControlType    | Control Value |
 	| Coding Field | Drug Verbatim 1 |                |               |
 	| SUP1AGE      | Twenty          | SmallTextInput | Other         |
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
	When row on form "ETE2" containing "Twenty" is marked with a sticky
    Then the coding decision for verbatim "Drug Verbatim 1" on form "ETE2" for field "Coding Field" contains the following data
		  | Level   | Code          | Term Path                         |
		  | ATC     | N             | NERVOUS SYSTEM                    |
		  | ATC     | N02           | ANALGESICS                        |
		  | ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |
		  | ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |
		  | PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |
		


