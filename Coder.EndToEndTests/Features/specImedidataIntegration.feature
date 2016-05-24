@specImedidataIntegration.feature
@EndToEndDynamicSegment

Feature: The following scenarios will validate the behavior of the integration between the coding system and iMedidata

@DFT
@Release2016.1.0
@PBMCC_182173_001
Scenario: Changes to a study name in iMedidata should be reflected in existing tasks in the coding system

	Given a Rave project registration with dictionary "MedDRA ENG 15.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	 | Form | Field       | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	 | ETE2 | CoderField2 | <Dictionary> | <Locale> | LLT         | 1        | true               | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
	| Field         | Value           | ControlType |
	| Coder Field 2 | Adverse Event 4 | LongText    |
	Then task "Adverse Event 4" should contain the following source term information
       | Study              | Dictionary    | Locale | Term            | Level          | Priority |
       | <StudyDisplayName> | MedDRA - 15.0 | ENG    | Adverse Event 4 | Low Level Term | 1        |
	When the study name is changed
	Then task "Adverse Event 4" should contain the following source term information
       | Study              | Dictionary    | Locale | Term            | Level          | Priority |
       | <StudyDisplayName> | MedDRA - 15.0 | ENG    | Adverse Event 4 | Low Level Term | 1        |
