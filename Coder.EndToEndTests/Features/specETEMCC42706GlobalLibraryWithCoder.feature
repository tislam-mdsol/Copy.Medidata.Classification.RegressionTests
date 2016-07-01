Feature: Global library will support Coder settings.  This will allow forms that contain Coder settings to be copied.

@DFT
@PBMCC42706_10
@ETE_RaveCoderCore
@Release2016.1.0
@EndToEndDynamicSegment
Scenario: Verify coping a form that contains Coder settings within a Project that the Coder settings get copied to the new form.

Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave CRF copy source is added for the project 
	And a Rave Coder setup with the following options
		| Form | Field        | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
		| ETE2 | Coding Field | <Dictionary> | <Locale> | LLT          | 1        | true               | true           | LogSuppField2     |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"			
	And a new Draft "NewCopiedDraft" is created through copy wizard 
	Then the Rave Coder setup for draft "NewCopiedDraft" has the following options configured
		| Form | Field        | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
		| ETE2 | Coding Field | <Dictionary> | <Locale> | LLT          | 1        | true               | true           | LogSuppField2     |


@DFT
@PBMCC42706_20
@ETE_RaveCoderCore
@Release2016.1.0
@EndToEndDynamicSegment
#@DebugEndToEndDynamicSegment
Scenario: Verify Coder settings get copied from a form that contains Coder settings to a form from another Project that has Coder registered 

	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And a Rave Coder setup with the following options
		| Form | Field        | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
		| ETE2 | Coding Field | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |                   |
	And a coder study is created named "SecondRaveCoderStudy" for environment "Prod" with site "Active Site 2"
	And app permissions are given for the "<SecondStudyName>" for "<testuser>"
	#select app from drop down and assign appropriate role for each app
		# create page object for the page
		# add approproate methods from the page object to declarative browser
		# call appropriate method from declarative browser in stephooks
	And Coder App Segment is loaded
	And a project with the following options is registered
		| Project              | Dictionary | Version | Locale | SynonymListName | RegistrationName |
		| SecondRaveCoderStudy | MedDRA     | 18.0    | eng    | Primary List    | MedDRA           |
	And Rave Modules App Segment is loaded
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"	
	# The above is done for the first study
	# And a Rave CRF copy source is added for copy target project "SecondRaveCoderStudy" using copy source project "<StudyName>"
	And a Rave CRF copy source from project "<StudyName>" draft "<Draft>" is added for project "<SecondRaveCoderStudy>"
	And a new Draft "NewCopiedDraft" is created through copy wizard for project "SecondRaveCoderStudy"
	Then verify the CRF has the following options for draft "NewCopiedDraft" for Project "SecondRaveCoderStudy"
		| Form | Field         | Dictionary   | Locale   | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
		| ETE2 | CodingField10 | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | true               | true           | SUPPDD            |

	

@DFT
@PBMCC42706_30
@ETE_RaveCoderCore
@Release2016.1.0
Scenario: Verify Coder settings are not copied from a form that contains Coder settings to a from from another Project that does not have Coder registered
	

	Given iMedidata App Segment is loaded
	And a coder study is created named "SecondRaveCoderStudy" for environment "Prod" with site "Active Site 2"
	And Coder App Segment is loaded
	And a project registration with dictionary "WhoDrugB2 200703 ENG"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
		| Form | Field         | Dictionary   | Locale   | Coding Level    | Priority | IsApprovalRequired | IsAutoApproval |
		| ETE2 | CodingField10 | <Dictionary> | <Locale> | PRODUCTSYNONYM  | 1        | true               | true           |
	And the following supplementals fields for following forms
		| Form | Field        | Supplemental  |
		| ETE2 | CodingField10 | SUPPDD        |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"	
	And a Rave CRF copy source is added for copy target project "SecondRaveCoderStudy" using copy source project "<StudyName>"
	And a new Draft "NewCopiedDraft" is created through copy wizard for project "SecondRaveCoderStudy"
	Then verify the Rave Coder setup does not have the following options for draft "NewCopiedDraft" for Project "SecondRaveCoderStudy"
		| Form  | Field         | Dictionary   | Locale   | Coding Level    | Priority | IsApprovalRequired | IsAutoApproval |
		| ETE2  | CodingField10 | <Dictionary> | <Locale> | PRODUCTSYNONYM  | 1        | true               | true           |
	And verify the following supplemental fields for following forms are not present
		| Form  | Field         | Supplemental |
		| ETE2  | CodingField10 | SUPPDD       | 

	
