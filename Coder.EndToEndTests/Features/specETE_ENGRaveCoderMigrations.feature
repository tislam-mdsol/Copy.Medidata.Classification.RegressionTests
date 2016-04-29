Feature: Verify Rave Coder Migrations

@DFT
@Release2016.2.0
@PBMCC_207807_1.1.2_001
Scenario: For a coding field in Rave when submitting a verbatim, the term should be accepted by Coder to create a manually created coding decision that should be reflected in Rave using ammendment manager
	Given a Rave project registration with dictionary "MedDRA ENG 12.0"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form | Field       | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE5 | CoderField5 | <Dictionary> | <Locale> | LLT         | 1        | true               | true           |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE5"
	| Field         | Value              | ControlType |
	| AdverseEvent1 | TERRIBLE HEAD PAIN |             |
	Then an Amendment Manager migration is started with "SETE5<CoderRaveStudy>" in "AM Subject Search" and "SETE5<CoderRaveStudy>" in "Rave Migration Subject Seletion Dropdown"
	And Rave Adverse Events form "ETE5" should display "CHILDRENS ADVIL COLD" 
	And Coder tasks should display "terrible head pain"	

@DFT
@Release2016.2.0
@PBMCC_207807_1.1.2_002
Scenario: For a coding field in Rave when submitting a verbatim, the term should be accepted by Coder to create a manually created coding decision that should be reflected in Rave.
	Given a Rave project registration with dictionary "MedDRA ENG 11.0"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form | Field       | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE5 | CoderField5 | <Dictionary> | <Locale> | LLT         | 1        | true               | true           |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE5"
	| Field         | Value              | ControlType |
	| AdverseEvent1 | TERRIBLE HEAD PAIN |             |
	When task "terrible head pain" is coded to term "Biopsy skin" at search level "Low Level Term" with code "10004873" at level "LLT" and a synonym is created
	And a new synonym list is created for "MedDRA ENG 11.1"
	And a study impact analsis migration is performed between "MedDRA ENG 11.0" to "MedDRA ENG 11.1"
	And a Rave submitted coding task "terrible head pain" for subject "CoderSubject" on field "Coding Field"
	Then Rave should contain the following coding decision information for subject "CoderSubject" on field "Coding Field"
		| Level | Code     | Term                           |
		| SOC   | 10022891 | Investigations                 |
		| HLGT  | 10040879 | Skin investigations            |
		| HLT   | 10040862 | Skin histopathology procedures |
		| PT    | 10004873 | Biopsy skin                    |
		| LLT   | 10004873 | Biopsy skin                    |
		
@DFT
@Release2016.2.0
@PBMCC_207807_1.1.2_003
Scenario: Enter project registration in Coder, setup Rave study, enter verbatim in Rave, code verbatim in Coder and create synonym rule, migrate study to new version in Coder, migrate synonym to new version in Coder, enter verbatim term again in Rave, verify term gets autocoded and results display in Rave
	Given a Rave project registration with dictionary "MedDRA ENG 11.0"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form | Field       | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE5 | CoderField5 | <Dictionary> | <Locale> | LLT         | 1        | true               | true           |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE5"
	| Field         | Value              | ControlType |
	| AdverseEvent1 | TERRIBLE HEAD PAIN |             |
	When task "tail bone bleeding" is coded to term "headache" at search level "Low Level Term" with code "10019211" at level "LLT" and a synonym is created
	And a new synonym list is created for "MedDRA ENG 11.1"
	And a study impact analsis migration is performed between "MedDRA ENG 11.0" to "MedDRA ENG 11.1"
	And number of migrations should display "1"
	And a Rave submitted coding task "terrible head pain" for subject "CoderSubject" on field "Coding Field"
	Then Rave should contain the following coding decision information for subject "CoderSubject" on field "Coding Field"
		| Level | Code     | Term                     |
		| SOC   | 10029205 | Nervous system disorders |
		| HLGT  | 10019231 | Headaches                |
		| HLT   | 10019233 | Headaches NEC            |
		| PT    | 10019211 | Headache                 |
		| LLT   | 10019211 | Headache                 |
		
@DFT
@Release2016.2.0
@PBMCC_207807_1.1.2_004
Scenario: Enter project registration in Coder, setup Rave study with Classic Coding fields, enter data in EDC, migrate study in Rave from Classic Coding to Medidata Coder, Verify terms appear in Coder after migration
	Given a Rave project registration with dictionary "MedDRA ENG 11.0"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form | Field       | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE6 | CoderField6 | <Dictionary> | <Locale> | LLT         | 1        | true               | true           |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE6"
	| Field         | Value              | ControlType |
	| AdverseEvent1 | TERRIBLE HEAD PAIN |             |
	And an Amendment Manager migration is started with "SETE6<CoderRaveStudy>" in "AM Subject Search" and "SETE6<CoderRaveStudy>" in "Rave Migration Subject Seletion Dropdown"
	Then Rave Adverse Events form should display "terrible head pain" 
	And Coder tasks should display "terrible head pain"
	
