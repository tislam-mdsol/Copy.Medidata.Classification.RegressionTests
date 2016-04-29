Feature: Global library will support Coder settings.  This will allow forms that contain Coder settings to be copied.

@DFT
@PBMCC42706_10
@ETE_RaveCoderCore
@Release2016.1.0
Scenario: Verify coping a form that contains Coder settings within a Project that the Coder settings get copied to the new form.

	Given Coder App Segment is loaded
	And a project registration with dictionary "WhoDrugB2 200703 ENG"
	And Rave Modules App Segment is loaded
	And a Rave CRF copy source is added for the project 
	And a Rave Coder setup with the following options
		| Form | Field         | Dictionary   | Locale   | Coding Level    | Priority | IsApprovalRequired | IsAutoApproval |
		| ETE2 | CodingField10 | <Dictionary> | <Locale> | PRODUCTSYNONYM  | 1        | true               | true           |
	And the following supplementals fields for following forms
		| Form | Field         | Supplemental  |
		| ETE2 | CodingField10 | SUPPDD        |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Prod"	
	And a new Draft "NewCopiedDraft" is created through copy wizard 
	Then verify the CRF has the following options for draft "NewCopiedDraft"
		| Form | Field         | Dictionary   | Locale   | Coding Level    | Priority | IsApprovalRequired | IsAutoApproval |
		| ETE2 | CodingField10 | <Dictionary> | <Locale> | PRODUCTSYNONYM  | 1        | true               | true           |
	And verify the following supplemental fields for following forms
		| Form | Field         | Supplemental  |
		| ETE2 | CodingField10 | SUPPDD        | 


##Adding CRF Copy Resources
#	And I select Link "Architect" and wait for "5"
#   And I select Link "<RaveCoderInvETEProjectB>"
#	And I select Link "Define Copy Sources"	
#	And I select Link "Add New Copy Source"
#	And I set value "Project - Drafts" located in "Copy Source Type Dropdown"
#	And I set value "<RaveCoderInvETEProjectB>" located in "Copy Source Name Dropdown"
#   And I set value with partial match "Draft 1" located in "Copy Source Draft Version Dropdown"
#	And I select Link "Update"

##Creating a new draft through copy wizard 
#   And I select Link "<RaveCoderInvETEProjectB>"
#	And I select Link "Add New Draft"
#	And I enter value "Draft4270610<CoderRaveStudy>" in the "Draft Name Text Field"
#	And I note down memo "Draft Name" with data from "Draft Name Text Field"
#	And I select Button "Rave Create Draft Button"
#	And I select Link "Copy to Draft"
#	And I select Image "Plus Icon" for Index "2"
#	And I select Image "Plus Icon" for Index "2"
#	And I select Image "Plus Icon" for Index "2"	
#	And I check the "Library Wizard Checkbox"
#	And I check the "Library Wizard Tree Checkbox"
#	And I select Button "Copy Wizard Next Button"
#	And I check the "Library Wizard Forms Checkbox"
#	And I select Image "Copy Draft Dictionary Image" located in "Copy Draft Tabs Table"
#   And I wait for "5"
#	And I check the "Library Wizard Data Dictionaries Checkbox"
#	And I select Image "Copy Draft Folders Image" located in "Copy Draft Tabs Table"
#   And I wait for "5"
#	And I check the "Library Wizard Folders Checkbox"
#	And I select Image "Copy Draft Matrix Image" located in "Copy Draft Tabs Table"
#   And I wait for "5"
#	And I check the "Library Wizard Matrices Checkbox"
#   And I select Image "Copy Draft Custom Functions Image" located in "Copy Draft Tabs Table"
#   And I wait for "5"
# 	And I check the "Library Wizard Custom Functions Checkbox"
#	And I select Image "Copy Draft Edit Checks Image" located in "Copy Draft Tabs Table"
#   And I wait for "5"
#	And I check the "Library Wizard Checks Checkbox"
#	And I select Image "Copy Draft Derivations Image" located in "Copy Draft Tabs Table"
#   And I wait for "5"
#	And I check the "Library Wizard Derivations Checkbox"
#	And I select Button "Copy Wizard Next Button"
#   And I bypass select Button "Copy Wizard Next Button"
#   And I wait for "120"


@DFT
@PBMCC42706_20
@ETE_RaveCoderCore
@Release2016.1.0
Scenario: Verify Coder settings get copied from a form that contains Coder settings to a form from another Project that has Coder registered 

	Given iMedidata App Segment is loaded
	And a coder study is created named "SecondRaveCoderStudy" for environment "Prod" with site "Active Site 2"
	And Coder App Segment is loaded
	And a project registration with dictionary "WhoDrugB2 200703 ENG" for Project "SecondRaveCoderStudy"
	And a project registration with dictionary "WhoDrugB2 200703 ENG"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
		| Form | Field         | Dictionary   | Locale   | Coding Level    | Priority | IsApprovalRequired | IsAutoApproval |
		| ETE2 | CodingField10 | <Dictionary> | <Locale> | PRODUCTSYNONYM  | 1        | true               | true           |
	And the following supplementals fields for following forms
		| Form | Field        | Supplemental  |
		| ETE2 | CodingField10 | SUPPDD        |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Prod"	
	And a Rave CRF copy source is added for copy target project "SecondRaveCoderStudy" using copy source project "<SourceSystemStudyName>"
	And a new Draft "NewCopiedDraft" is created through copy wizard for project "SecondRaveCoderStudy"
	Then verify the CRF has the following options for draft "NewCopiedDraft" for Project "SecondRaveCoderStudy"
		| Form  | Field         | Dictionary   | Locale   | Coding Level    | Priority | IsApprovalRequired | IsAutoApproval |
		| ETE2  | CodingField10 | <Dictionary> | <Locale> | PRODUCTSYNONYM  | 1        | true               | true           |
	And verify the following supplemental fields for following forms
		| Form  | Field         | Supplemental |
		| ETE2  | CodingField10 | SUPPDD       | 

	

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
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Prod"	
	And a Rave CRF copy source is added for copy target project "SecondRaveCoderStudy" using copy source project "<SourceSystemStudyName>"
	And a new Draft "NewCopiedDraft" is created through copy wizard for project "SecondRaveCoderStudy"
	Then verify the Rave Coder setup does not have the following options for draft "NewCopiedDraft" for Project "SecondRaveCoderStudy"
		| Form  | Field         | Dictionary   | Locale   | Coding Level    | Priority | IsApprovalRequired | IsAutoApproval |
		| ETE2  | CodingField10 | <Dictionary> | <Locale> | PRODUCTSYNONYM  | 1        | true               | true           |
	And verify the following supplemental fields for following forms are not present
		| Form  | Field         | Supplemental |
		| ETE2  | CodingField10 | SUPPDD       | 

	
