Feature: Log line coding fields in Rave EDC who have been set with landscape view in Rave Architect will display coded decisions.


@MCC-207752
@ETE_ENG_Landscapeview
Scenario: Verify a coding decision is visible for a submitted log line verbatim in a landscape form in EDC
And Coder App Segment is loaded
And a project registration with dictionary "Medra 11 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form   | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE12  | ETE12            | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
And I change the form view to "Landscape"	
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TST"
When adding a new verbatim term to form "ETE12"
	| Field         | Value      | ControlType | Control Value |
	| AdverseEvent1 | Headache   |             |               |
When when I view form "ETE12" for "Subject" I should see the following data
   |data                      |
   |Nervous system disorders                          |
   |10029205                                          |
   |Headaches                                         |
   |10019231                                          |
   |Headaches NEC                                     |
   |10019233                                          |
   |Headache                                          |
   |10019211                                          |


@MCC-207752
@ETE_ENG_Landscapeview
Scenario: Verify a coding decisions is visible for multi-log line submissions in a landscape form in EDC
And Coder App Segment is loaded
And a project registration with dictionary "Medra 11 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form   | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE12  | ETE12            | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
And I change the form view to "Landscape"	
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TST"
When adding a new verbatim term to form "ETE12"
	| Field         | Value         | ControlType | Control Value |
	| AdverseEvent1 | Headache      |             |               |
When adding a new verbatim term to form "ETE12"
	| Field         | Value         | ControlType | Control Value |
	| AdverseEvent1 | dry throat    |             |               |	
Then when I view task "headache" on form "ETE1" for "Subject" I should see the following data
   |data                      |
   |Nervous system disorders                          |
   |10029205                                          |
   |Headaches                                         |
   |10019231                                          |
   |Headaches NEC                                     |
   |10019233                                          |
   |Headache                                          |
   |10019211                                          |
   
   
@MCC-207752
@ETE_ENG_Landscapeview   
Scenario: Verify a coding decision is visible for a submitted log line verbatim in a landscape form in EDC that contains a Rave Query.
And Coder App Segment is loaded
And a project registration with dictionary "Medra 11 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form   | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE12  | ETE12            | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
And I change the form view to "Landscape"	
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TST"
When adding a new verbatim term to form "ETE12"
	| Field         | Value      | ControlType | Control Value |
	| AdverseEvent1 | Headache   |             |               |
And I open rave query for term "headache" for form "ETE12" entering value "Opening Rave Query"	
When when I view form "ETE12" for "Subject" I should see the following data
   |data                                              |
   |Nervous system disorders                          |
   |10029205                                          |
   |Headaches                                         |
   |10019231                                          |
   |Headaches NEC                                     |
   |10019233                                          |
   |Headache                                          |
   |10019211                                          | 
   
   