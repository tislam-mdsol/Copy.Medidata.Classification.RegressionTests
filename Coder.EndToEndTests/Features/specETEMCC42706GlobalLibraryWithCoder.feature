Feature: Global library will support Coder settings.  This will allow forms that contain Coder settings to be copied.

@VAL
@PBMCC42706_10
@ETE_RaveCoderCore
@Release2016.1.0
@EndToEndDynamicSegment

Scenario: Verify coping a form that contains Coder settings within a Project that the Coder settings get copied to the new form.

Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	#And Rave Modules App Segment is loaded
	And a Rave CRF copy source is added for the project 
	And a Rave Coder setup with the following options
		| Form | Field        | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
		| ETE2 | Coding Field | <Dictionary> | <Locale> | LLT          | 1        | true               | true           | LogSuppField2     |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"			
	And a new Draft "NewCopiedDraft" is created through copy wizard 
	Then the Rave Coder setup for draft "NewCopiedDraft" has the following options configured
		| Form | Field        | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
		| ETE2 | Coding Field | <Dictionary> | <Locale> | LLT          | 1        | true               | true           | LogSuppField2     |


@VAL
@PBMCC42706_20
@ETE_RaveCoderCore
@Release2016.1.0
@EndToEndDynamicSegment

Scenario: Verify Coder settings get copied from a form that contains Coder settings to a form from another Project that has Coder registered 

	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And a Rave Coder setup with the following options
		| Form | Field        | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
		| ETE2 | Coding Field | <Dictionary> | <Locale> | LLT          | 1        | true               | true           | LOGCOMPFIELD      |
	#And iMedidata App Segment is loaded
	And a coder study is created named "SecondRaveCoderStudy" for environment "Prod" with site "Active Site 2"
	And a second project with the following options is registered
		| Project              | Dictionary | Version | Locale | RegistrationName | 
		| SecondRaveCoderStudy | MedDRA     | 18.0    | eng    | MedDRA           | 
	And Rave Modules App Segment is loaded
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"	
	And a Rave CRF copy source from project "<StudyName>" draft "<DraftName>" is added for project "SecondRaveCoderStudy"
	And a new Draft "NewCopiedDraft" is created through copy wizard for project "SecondRaveCoderStudy"
	Then the Rave Coder setup for draft "NewCopiedDraft" has the following options configured
		| Form | Field        | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
		| ETE2 | Coding Field | <Dictionary> | <Locale> | LLT          | 1        | true               | true           | LOGCOMPFIELD      |


@VAL
@PBMCC42706_20
@ETE_RaveCoderCore
@Release2016.1.0
@EndToEndDynamicSegment

Scenario: Verify Coder settings are not copied from a form that contains Coder settings to a from from another Project that does not have Coder registered 

	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	#And iMedidata App Segment is loaded
	And a coder study is created named "SecondRaveCoderStudy" for environment "Prod" with site "Active Site 2"
	And a second project with the following options is registered
		| Project              | Dictionary | Version | Locale | RegistrationName |
		| SecondRaveCoderStudy | MedDRA     | 18.0    | eng    | MedDRA           |
	And Rave Modules App Segment is loaded
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"	
	And a Rave CRF copy source from project "<StudyName>" draft "<DraftName>" is added for project "SecondRaveCoderStudy"
	And a new Draft "NewCopiedDraft" is created through copy wizard for project "SecondRaveCoderStudy"
	Then the project "SecondRaveCoderStudy" draft "NewCopiedDraft" form "ETE2" field "Coding Field" has no Rave Coder setup options configured

