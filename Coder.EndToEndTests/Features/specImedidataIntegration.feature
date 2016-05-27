@specImedidataIntegration.feature
@EndToEndDynamicSegment

Feature: The following scenarios will validate the behavior of the integration between the coding system and iMedidata

@VAL
@Release2016.1.0
@PBMCC_182173_001
Scenario: Changes to a study name in iMedidata should be reflected in existing tasks in the coding system

	Given a Rave project registration with dictionary "MedDRA ENG 15.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | true               | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "SUB"
	And adding a new verbatim term to form "ETE2"
	| Field        | Value           | ControlType |
	| Coding Field | Adverse Event 4 | LongText    |
	And Coder App Segment is loaded
	Then task "Adverse Event 4" should contain the following source term information
       | Source System | Study              | Dictionary    | Locale | Term            | Level          | Priority |
       | Rave EDC      | <StudyDisplayName> | MedDRA - 15.0 | ENG    | Adverse Event 4 | Low Level Term | 1        |
	When the study name is changed
	And Coder App Segment is loaded
	Then task "Adverse Event 4" should contain the following source term information
       | Source System | Study              | Dictionary    | Locale | Term            | Level          | Priority |
       | Rave EDC      | <StudyDisplayName> | MedDRA - 15.0 | ENG    | Adverse Event 4 | Low Level Term | 1        |
	When task "Adverse Event 4" is coded to term "Head pain" at search level "Low Level Term" with code "10019198" at level "LLT" and a synonym is created
	And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "Adverse Event 4" on form "ETE2" for field "Coding Field" contains the following data
      | Level | Code     | Term Path                |
      | SOC   | 10029205 | Nervous system disorders |
      | HLGT  | 10019231 | Headaches                |
      | HLT   | 10019233 | Headaches NEC            |
      | PT    | 10019211 | Headache                 |
      | LLT   | 10019198 | Head pain                |


@VAL
@Release2016.1.0
@PBMCC_182173_002
Scenario: Changes to a study name in iMedidata should allow queries to still be opened

	Given a Rave project registration with dictionary "MedDRA ENG 15.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	 | ETE1 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | true               | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "SUB"
	And adding a new verbatim term to form "ETE1"
	| Field        | Value           | ControlType |
	| Coding Field | Adverse Event 1 | LongText    |
	And Coder App Segment is loaded
	And the study name is changed
	And Coder App Segment is loaded
	And I open a query for task "Adverse Event 1" with comment "Open query due to bad term"
	And Rave Modules App Segment is loaded
	Then the coder query "Open query due to bad term" is available to the Rave form "ETE1" field "Coding Field" with verbatim term "Adverse Event 1"


@VAL
@Release2016.1.0
@PBMCC_182173_003
Scenario: Changes to a study name in iMedidata should allow proejcts to be registered

	Given a Rave project registration with dictionary "MedDRA ENG 15.0"
	When Coder App Segment is loaded
	And the study name is changed
	When a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 201503"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup is configured with the following options
	| Form | Field        | Dictionary     | Locale | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE3 | Coding Field | WhoDrug-DDE-B2 |        | PRODUCT     | 1        | true               | true           |
	Then verify coding dictionary "WHODrug-DDE-B2" is an option on Rave form "ETE3"
