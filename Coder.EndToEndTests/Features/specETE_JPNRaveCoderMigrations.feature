Feature: UPDATED Verify JPN Rave Coder Migrations

@DFT
@PB1.1.2_005J
@Release2012.1.0
Scenario: Setup Rave study with all non coding fields, enter data in EDC, migrate study in Rave from non-coding to Medidata Coder, Verify terms appear in Coder after migration
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form | Field          | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE5 | CoderFieldETE5 | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | false              | true           |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE5"
	| Field              | Value   | ControlType |
	| Coder  Field ETE 5 | 左脚の足の痛み |             |
	And an Amendment Manager migration is started with "SETE5<CoderRaveStudy>" in "AM Subject Search" and "SETE5<CoderRaveStudy>" in "Rave Migration Subject Seletion Dropdown"
	Then Rave Adverse Events form should display "左脚の足の痛み" 
	And Coder tasks should display "左脚の足の痛み"
	