@specETEMCC42698RaveCRFEnv.feature
@EndToEnd
Feature: Handles the CRF versioning for different project environment scenarios, such as a user should not be able to push a CRF version that contains Coder settings to a study environment that is not linked to iMedidata.
	

@DFT
@ETE_RaveCoderCore
@PBMCC42698_001
@Release2016.1.0
@EndToEndDynamicSegment

Scenario: When pushing a CRF version that contains Coder settings and environment selected is not linked to iMedidata, produce an error message.

    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
		| Form | Field         | Dictionary   | Locale   | Coding Level    | Priority | IsApprovalRequired | IsAutoApproval |
		| ETE2 | Coding Field  | <Dictionary> | <Locale> | LLT             | 1        | true               | true           |	
	When a Rave study environment "UAT_ENV" is created for project "<StudyName>"
	And a Rave Draft is published and has pushed disabled using draft "<DraftName>" for Project "<StudyName>" to environment "UAT_ENV"	
	Then pushing a CRF should be disabled with the following failed message "Push disabled. CRF Version contains coding dictionary linked to Coder, but study/environment not linked to iMedidata. Please link study/environment with iMedidata." 	
	
		
@VAL
@ETE_RaveCoderCore
@PBMCC42698_002
@Release2016.1.0
Scenario: When pushing a CRF version that contains Coder settings and environment selected is linked to iMedidata, allow push to complete

    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
		| Form | Field        | Dictionary   | Locale   | Coding Level    | Priority | IsApprovalRequired | IsAutoApproval |
		| ETE2 | Coding Field | <Dictionary> | <Locale> | LLT             | 1        | true               | true           |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "UAT"
    Then CRF was published and pushed with the following message "successfully pushed"


