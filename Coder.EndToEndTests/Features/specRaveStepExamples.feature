@specRaveModulesIntegration.feature
@EndToEndDynamicSegment
#@EndToEndDynamicStudy
#@EndToEndStaticSegment

Feature: The following scenarios will serve as a coder setup script


@DFT
@Release2016.1.0
@PBMCC_216333_001
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Different Rave Architect Coding Configurations
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          | LogSuppField2, LogSuppField4 |
	And a Rave Coder setup with the following options
	 | Form  | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
	 | ETE17 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          | AGESUP17          |
	And a Rave Coder setup with the following options
	 | Form  | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
	 | ETE11 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |                   |
	And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	And supplemental terms for the following fields
	 | Form | Field        | SupplementalTerm |
	 | ETE2 | Coding Field | LogSuppField2    |
	 | ETE2 | Coding Field | LogSuppField4    |
	When the supplemental term "LogSuppField4" is removed from the Rave Coder setup of form "ETE2" field "Coding Field"
	And the Coding Dictionary for the Rave Coder setup of form "ETE2" field "Coding Field" is removed
	And the Coding Dictionary for the Rave Coder setup of form "ETE2" field "Coding Field" is set to "Rave- MedDRA 10.0 Version: 10.0"
	And a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "c"
	

@DFT
@Release2016.1.0
@PBMCC_216333_002
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Add data to forms with different input types
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
# Add
	And adding a new verbatim term to form "ETE2"
	| Field                    | Value    | ControlType |
	| Coding Field             | Headache | LongText    |
	| Log Supplemental Field A | Top      |             |
	| Std Supplemental Field B | Head     |             |
	And adding a new verbatim term to form "ETE10"
	| Field                             | Value  | ControlType  |
	| Coding Field                      | person |              |
	| Log Dropdown Supplemental Field A | male   | DropDownList |
	And adding a new verbatim term to form "ETE11"
	| Field                                 | Value      | ControlType         |
	| Coding Field                          | Headachery | LongText            |
	| Log Start Date Supplemental Field     | 02/29/2016 | DateTime            |
	| Log Vertical Radio Supplemental Field | No         | RadioButtonVertical |
	And adding a new verbatim term to form "ETE17"
	| Field                                 | Value           | ControlType         |
	| Coding Field                          | Headachery      |                     |
	| Log Dropdown Supplemental Field A     | Other Option    | DropDownList        |
	| Log Dropdown Supplemental Field A     | other text      |                     |
	| Log Radio Supplemental Field          | Other Option    | RadioButton         |
	| Log Radio Supplemental Field          | another text    |                     |
	| Log Vertical Radio Supplemental Field | Other Option    | RadioButtonVertical |
	| Log Vertical Radio Supplemental Field | test again      |                     |
	| Log Search List Supplemental Field    | Specify Other 2 | SearchList          |
	| Log Search List Supplemental Field    | more text       | SearchListOther     |
	And adding a new verbatim term to form "ETE19"
	| Field                                        | Value   | ControlType       |
	| Log Dynamic Search List Supplemental Field A | DarkRed | DynamicSearchList |
# Modify
	And modifying a verbatim term on form "ETE2"
	| Field                    | Value | ControlType |
	| Std Supplemental Field B | Leg   |             |
	And modifying a verbatim term of the log line containing "Headache" on form "ETE2"
	| Field                    | Value      | ControlType |
	| Coding Field             | Ankle Pain | LongText    |
	| Std Supplemental Field B | Ankle      |             |
	And modifying a verbatim term of log line "1" on form "ETE2"
	| Field                    | Value     | ControlType |
	| Coding Field             | Foot Pain | LongText    |
	| Std Supplemental Field B | Foot      |             |

@DFT
@Release2016.1.0
@PBMCC_216333_003
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Adding or modifying loglines on a landscape form
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
#Form 12
	And adding a new verbatim term to form "ETE12"
	| Field | Value      | ControlType |
	| 1     | Headachery | LongText    |
	And adding a new verbatim term to form "ETE12"
	| Field | Value      | ControlType |
	| 2     | Foot Pains | LongText    |
	And modifying a verbatim term of the log line containing "Headachery" on form "ETE12"
	| Field | Value      | ControlType |
	| 1     | Ankle Pain | LongText    |
	And modifying a verbatim term of the log line containing "Foot Pains" on form "ETE12"
	| Field | Value    | ControlType |
	| 2     | Leg Ouch | LongText    |
	And modifying a verbatim term of log line "1" on form "ETE12"
	| Field | Value | ControlType |
	| 1     | hand  | LongText    |
	And modifying a verbatim term of log line "2" on form "ETE12"
	| Field | Value | ControlType |
	| 2     | arm   | LongText    |
#Form 15
	And adding a new verbatim term to form "ETE15"
	| Field | Value      | ControlType |
	| 1     | Headachery |             |
	And adding a new verbatim term to form "ETE15"
	| Field | Value      | ControlType |
	| 2     | Foot Pains |             |
	And modifying a verbatim term of the log line containing "Headachery" on form "ETE15"
	| Field | Value      | ControlType |
	| 1     | Ankle Pain |             |
	And modifying a verbatim term of the log line containing "Foot Pains" on form "ETE15"
	| Field | Value    | ControlType |
	| 2     | Leg Ouch |             |
	And modifying a verbatim term of log line "1" on form "ETE15"
	| Field | Value | ControlType |
	| 1     | hand  |             |
	And modifying a verbatim term of log line "2" on form "ETE15"
	| Field | Value | ControlType |
	| 2     | arm   |             |

@DFT
@Release2016.1.0
@PBMCC_216333_004
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Verifying Query comments from Coder
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	| Form  | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2  | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	| ETE12 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	| ETE15 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	And adding a new verbatim term to form "ETE12"
	| Field | Value        | ControlType |
	| 1     | LLHeadachery | LongText    |
	And adding a new verbatim term to form "ETE15"
	| Field | Value        | ControlType |
	| 1     | UUHeadachery |             |
	And Coder App Segment is loaded
	And I open a query for task "Headachery" with comment "Now we test two too"
	And I open a query for task "LLHeadachery" with comment "Then we test one with two"
	And I open a query for task "UUHeadachery" with comment "Test one"
	And Rave Modules App Segment is loaded
	Then the coder query "Now we test two too" is available to the Rave form "ETE2" field "Coding Field" with verbatim term "Headachery"
	And the coder query "Then we test one with two" is available to the Rave form "ETE12" field "Coding Field" with verbatim term "LLHeadachery"
	And the coder query "Test one" is available to the Rave form "ETE15" field "Coding Field" with verbatim term "UUHeadachery"
			
@DFT
@Release2016.1.0
@PBMCC_216333_005
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Respond to Query comments from Coder
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	When adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	And Coder App Segment is loaded
	And I open a query for task "Headachery" with comment "Now we test two too"
	And a coding task "Headachery" returns to "Open" query status
	And Rave Modules App Segment is loaded
	And the coder query to the Rave form "ETE2" field "Coding Field" with verbatim term "Headachery" is responded to with "Test Worked"
	And Coder App Segment is loaded
	And a coding task "Headachery" returns to "Closed" query status
	Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text          | Query Response | Query Notes |
		| <SystemUser> | Headachery    | Closed       |                     |                |             |
		| <User>       | Headachery    | Answered     |                     | Test Worked    |             |
		| CoderImport  | Headachery    | Open         | Now we test two too |                |             |
		| <User>       | Headachery    | Queued       | Now we test two too |                |             |

@DFT
@Release2016.1.0
@PBMCC_216333_005
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Cancel Query from Coder
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	When adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	And Coder App Segment is loaded
	And I open a query for task "Headachery" with comment "Now we test two too"
	And a coding task "Headachery" returns to "Open" query status
	And Rave Modules App Segment is loaded
	And the coder query to the Rave form "ETE2" field "Coding Field" with verbatim term "Headachery" is canceled
	And Coder App Segment is loaded
	And a coding task "Headachery" returns to "Cancelled" query status
	Then the query history contains the following information
		| User        | Verbatim Term | Query Status | Query Text          | Query Response | Query Notes |
		| <User>      | Headachery    | Cancelled    |                     |                |             |
		| CoderImport | Headachery    | Open         | Now we test two too |                |             |
		| <User>      | Headachery    | Queued       | Now we test two too |                |             |

@DFT
@Release2016.1.0
@PBMCC_216333_006
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Respond to Query comments from Coder on landscape forms
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	| Form  | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2  | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	| ETE12 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	| ETE15 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	When adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	And adding a new verbatim term to form "ETE12"
	| Field | Value        | ControlType |
	| 1     | LLHeadachery | LongText    |
	And adding a new verbatim term to form "ETE15"
	| Field | Value        | ControlType |
	| 1     | UUHeadachery |             |
	And Coder App Segment is loaded
	And I open a query for task "Headachery" with comment "Now we test two too"
	And I open a query for task "LLHeadachery" with comment "Then we test one with two"
	And I open a query for task "UUHeadachery" with comment "Test one"
	And a coding task "Headachery" returns to "Open" query status
	And a coding task "LLHeadachery" returns to "Open" query status
	And a coding task "UUHeadachery" returns to "Open" query status
	And Rave Modules App Segment is loaded
	And the coder query to the Rave form "ETE2" field "Coding Field" with verbatim term "Headachery" is responded to with "Test Worked"
	And the coder query to the Rave form "ETE12" field "Coding Field" with verbatim term "LLHeadachery" is responded to with "Test again"
	And the coder query to the Rave form "ETE15" field "Coding Field" with verbatim term "UUHeadachery" is responded to with "Test did work"
	And Coder App Segment is loaded
	And a coding task "Headachery" returns to "Closed" query status
	Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text          | Query Response | Query Notes |
		| <SystemUser> | Headachery    | Closed       |                     |                |             |
		| <User>       | Headachery    | Answered     |                     | Test Worked    |             |
		| CoderImport  | Headachery    | Open         | Now we test two too |                |             |
		| <User>       | Headachery    | Queued       | Now we test two too |                |             |
	When a coding task "LLHeadachery" returns to "Closed" query status
	Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text                | Query Response | Query Notes |
		| <SystemUser> | LLHeadachery  | Closed       |                           |                |             |
		| <User>       | LLHeadachery  | Answered     |                           | Test again     |             |
		| CoderImport  | LLHeadachery  | Open         | Then we test one with two |                |             |
		| <User>       | LLHeadachery  | Queued       | Then we test one with two |                |             |
	When a coding task "UUHeadachery" returns to "Closed" query status
	Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Query Notes |
		| <SystemUser> | UUHeadachery  | Closed       |            |                |             |
		| <User>       | UUHeadachery  | Answered     |            | Test did work  |             |
		| CoderImport  | UUHeadachery  | Open         | Test one   |                |             |
		| <User>       | UUHeadachery  | Queued       | Test one   |                |             |

@DFT
@Release2016.1.0
@PBMCC_216333_007
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Cancel Query from Coder on landscape forms
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	| Form  | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2  | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	| ETE12 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	| ETE15 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	When adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	And adding a new verbatim term to form "ETE12"
	| Field | Value        | ControlType |
	| 1     | LLHeadachery | LongText    |
	And adding a new verbatim term to form "ETE15"
	| Field | Value        | ControlType |
	| 1     | UUHeadachery |             |
	And Coder App Segment is loaded
	And I open a query for task "Headachery" with comment "Now we test two too"
	And I open a query for task "LLHeadachery" with comment "Then we test one with two"
	And I open a query for task "UUHeadachery" with comment "Test one"
	And a coding task "Headachery" returns to "Open" query status
	And a coding task "LLHeadachery" returns to "Open" query status
	And a coding task "UUHeadachery" returns to "Open" query status
	And Rave Modules App Segment is loaded
	And the coder query to the Rave form "ETE2" field "Coding Field" with verbatim term "Headachery" is canceled
	And the coder query to the Rave form "ETE12" field "Coding Field" with verbatim term "LLHeadachery" is canceled
	And the coder query to the Rave form "ETE15" field "Coding Field" with verbatim term "UUHeadachery" is canceled
	And Coder App Segment is loaded
	And a coding task "Headachery" returns to "Cancelled" query status
	Then the query history contains the following information
		| User        | Verbatim Term | Query Status | Query Text          | Query Response | Query Notes |
		| <User>      | Headachery    | Cancelled    |                     |                |             |
		| CoderImport | Headachery    | Open         | Now we test two too |                |             |
		| <User>      | Headachery    | Queued       | Now we test two too |                |             |
	When a coding task "LLHeadachery" returns to "Cancelled" query status
	Then the query history contains the following information
		| User        | Verbatim Term | Query Status | Query Text                | Query Response | Query Notes |
		| <User>      | LLHeadachery  | Cancelled    |                           |                |             |
		| CoderImport | LLHeadachery  | Open         | Then we test one with two |                |             |
		| <User>      | LLHeadachery  | Queued       | Then we test one with two |                |             |
	When a coding task "UUHeadachery" returns to "Cancelled" query status
	Then the query history contains the following information
		| User        | Verbatim Term | Query Status | Query Text | Query Response | Query Notes |
		| <User>      | UUHeadachery  | Cancelled    |            |                |             |
		| CoderImport | UUHeadachery  | Open         | Test one   |                |             |
		| <User>      | UUHeadachery  | Queued       | Test one   |                |             |

@DFT
@Release2016.1.0
@PBMCC_216333_008
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Freeze and Lock Rave Forms
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	| Form  | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2  | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	| ETE12 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	| ETE15 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	When adding a new subject "TST"	
	And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	And adding a new verbatim term to form "ETE12"
	| Field | Value        | ControlType |
	| 1     | LLHeadachery | LongText    |
	And adding a new verbatim term to form "ETE15"
	| Field | Value        | ControlType |
	| 1     | UUHeadachery |             |
	And form "ETE2" is frozen
	And form "ETE12" is locked
	And form "ETE15" is frozen and locked

@DFT
@Release2016.1.0
@PBMCC_216333_009
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Freeze and Lock Rave Fields
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	| Form  | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2  | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	| ETE12 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	| ETE15 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	When adding a new subject "TST"
    And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	And adding a new verbatim term to form "ETE12"
	| Field | Value        | ControlType |
	| 1     | LLHeadachery | LongText    |
	And adding a new verbatim term to form "ETE15"
	| Field | Value        | ControlType |
	| 1     | UUHeadachery |             |
	And the Rave row on form "ETE2" with verbatim term "Headachery" is frozen
	And the Rave row on form "ETE12" with verbatim term "LLHeadachery" is locked
	And the Rave row on form "ETE15" with verbatim term "UUHeadachery" is frozen and locked

@DFT
@Release2016.1.0
@PBMCC_216333_010
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Amendment Manager Migration Success
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | true           | LogSuppField2, LogSuppField4 |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    When adding a new subject "TST"
    And adding a new verbatim term to form "ETE2"
	| Field                    | Value      | ControlType |
	| Coding Field             | Headachery | LongText    |
	| Log Supplemental Field B | Top        |             |
	| Std Supplemental Field B | Head       |             |
	When the supplemental term "LogSuppField4" is removed from the Rave Coder setup of form "ETE2" field "Coding Field"
	And a Rave Draft is published using draft "<DraftName>" for Project "<StudyName>"
	When an Amendment Manager migration is started for Project "<StudyName>" 
		
@DFT
@Release2016.1.0
@PBMCC_216333_011
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Amendment Manager Migration Failure
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    When adding a new subject "TST"
    And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	When the Coding Dictionary for the Rave Coder setup of form "ETE2" field "Coding Field" is removed
	And the Coding Dictionary for the Rave Coder setup of form "ETE2" field "Coding Field" is set to "Rave- MedDRA 10.0 Version: 10.0"
	And a Rave Draft is published using draft "<DraftName>" for Project "<StudyName>"
	When an Amendment Manager migration is started for Project "<StudyName>" 
	
@DFT
@Release2016.1.0
@PBMCC_219307_001
@PBMCC_219308_001
Scenario: Rave ETE Example Verifying Coding Decision

    Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | false              | true           | LogSuppField2, LogSuppField4 |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	When adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	And Coder App Segment is loaded
    And task "Headachery" is coded to term "atrial fibrillation" at search level "Low Level Term" with code "10003658" at level "LLT"
    And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "Headachery" on form "ETE2" for field "Coding Field" contains the following data
             | Level | Code     | Term Path                    |
             | SOC   | 10007541 | Cardiac disorders            |
             | HLGT  | 10007521 | Cardiac arrhythmias          |
             | HLT   | 10042600 | Supraventricular arrhythmias |
             | PT    | 10003658 | Atrial fibrillation          |
             | LLT   | 10003658 | Atrial fibrillation          |

	
@DFT
@Release2016.1.0
@PBMCC_216333_012
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Inactivate and Reactivate Form Row
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    When adding a new subject "TST"
    And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	When the log line on form "ETE2" containing "Headachery" is inactivated
	And the log line on form "ETE2" containing "Headachery" is reactivated

@DFT
@Release2016.1.0
@PBMCC_216333_013
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Inactivate and Reactivate Form
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    When adding a new subject "TST"
    And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	When form "ETE2" is inactivated
	And form "ETE2" is reactivated

@DFT
@Release2016.1.0
@PBMCC_216333_014
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Marking Open Query
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    When adding a new subject "TST"
    And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	And row on form "ETE2" containing "Headachery" is marked with a query

@DFT
@Release2016.1.0
@PBMCC_216333_015
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Marking Place Sticky
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    When adding a new subject "TST"
    And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	And row on form "ETE2" containing "Headachery" is marked with a sticky

@DFT
@Release2016.1.0
@PBMCC_216333_016
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Marking Protocol Deviation
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    When adding a new subject "TST"
    And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	And row on form "ETE2" containing "Headachery" is marked with a protocol deviation

	
@DFT
@Release2016.1.0
@PBMCC_216333_016
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Add Audit Log Comment
	
	Given a Rave project registration with dictionary "MedDRA ENG 18.0"
	And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
	 | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    When adding a new subject "TST"
    And adding a new verbatim term to form "ETE2"
	| Field                    | Value | ControlType |
	| Coding Field             | ALPHA | LongText    |
	| Log Supplemental Field A | BRAVO |             |
	| Std Supplemental Field A | ZULU  |             |
    And adding a new verbatim term to form "ETE2"
	| Field                    | Value   | ControlType |
	| Coding Field             | CHARLIE | LongText    |
	| Log Supplemental Field A | DELTA   |             |
    And adding a new verbatim term to form "ETE2"
	| Field        | Value | ControlType |
	| Coding Field | ECHO  | LongText    |
    And adding a new verbatim term to form "ETE2"
	| Field        | Value   | ControlType |
	| Coding Field | FOXTROT | LongText    |
    And adding a new verbatim term to form "ETE3"
	| Field        | Value | ControlType |
	| Coding Field | GULF  |             |
    And adding a new verbatim term to form "ETEMCC62552"
	| Field          | Value  | ControlType |
	| Coding Field A | XRAY   |             |
	| Coding Field B | YANKEE |             |
	And adding a new verbatim term to form "ETE12"
	| Field | Value | ControlType |
	| 1     | HOTEL | LongText    |
	And adding a new verbatim term to form "ETE12"
	| Field | Value | ControlType |
	| 2     | INDIA | LongText    |
	And an audit log entry "ALPHA1" is manually added to field "Coding Field" of the form "ETE2" row containing "ALPHA"
	And an audit log entry "BRAVO1" is manually added to field "Log Supplemental Field A" of the form "ETE2" row containing "BRAVO"
	And an audit log entry "CHARLIE1" is manually added to field "Coding Field" of the form "ETE2" row containing "CHARLIE"
	And an audit log entry "DELTA1" is manually added to field "Log Supplemental Field A" of the form "ETE2" row containing "DELTA"
	And an audit log entry "ECHO1" is manually added to field "Coding Field" of the form "ETE2" row containing "ECHO"
	And an audit log entry "FOXTROT1" is manually added to field "Coding Field" of the form "ETE2" row containing "FOXTROT"
	And an audit log entry "GULF1" is manually added to field "Coding Field" of the form "ETE3" row containing "GULF"
	And an audit log entry "HOTEL1" is manually added to field "Coding Field" of the form "ETE12" row containing "HOTEL"
	And an audit log entry "INDIA1" is manually added to field "Coding Field" of the form "ETE12" row containing "INDIA"
	And an audit log entry "XRAY1" is manually added to field "Coding Field A" of the form "ETEMCC62552" row containing "XRAY"
	And an audit log entry "YANKEE1" is manually added to field "Coding Field B" of the form "ETEMCC62552" row containing "YANKEE"
	And an audit log entry "ZULU1" is manually added to field "Std Supplemental Field A" of the form "ETE2" row containing "ZULU"
	
@DFT
@Release2016.1.0
@PBMCC_216333_017
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Copy CRF Draft

	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
	And a Rave CRF copy source is added for the project 
	And a Rave Coder setup with the following options
		| Form        | Field          | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms     |
		| ETE2        | Coding Field   | <Dictionary> |        | PRODUCTSYNONYM | 2        | true               | true           | LogSuppField4         |
		| ETEMCC62552 | Coding Field A | MedDRA       | ENG    | LLT            | 3        | false              | true           | ETEDRUG01, STDFIELD01 |
		| ETEMCC62552 | Coding Field B | MedDRA       | ENG    | LLT            | 4        | false              | false          |                       |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"	
	And a new Draft "NewCopiedDraft" is created through copy wizard 
	Then the Rave Coder setup for draft "NewCopiedDraft" has the following options configured
		| Form        | Field          | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms     |
		| ETE2        | Coding Field   | <Dictionary> |        | PRODUCTSYNONYM | 2        | true               | true           | LogSuppField4         |
		| ETEMCC62552 | Coding Field A | MedDRA       | ENG    | LLT            | 3        | false              | true           | ETEDRUG01, STDFIELD01 |
		| ETEMCC62552 | Coding Field B | MedDRA       | ENG    | LLT            | 4        | false              | false          |                       |
		
@DFT
@Release2016.1.0
@PBMCC_216333_018
@IncreaseTimeout_1800000

Scenario: Rave ETE Example Copy CRF Draft to a Different Study

	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
	And a Rave CRF copy source from project "<StudyName>" draft "<DraftName>" is added for project "NewStudy"
	When a new Draft "NewCopiedDraft" is created through copy wizard for project "NewStudy"

@DFT
@Release2016.1.0
@PBMCC_216333_019
@IncreaseTimeout_1800000
Scenario: Rave ETE Example Copy CRF Draft to a Different Study Verify Coder Settings are not Copied

	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
	And a Rave CRF copy source from project "<StudyName>" draft "<DraftName>" is added for project "NewStudy"
	And a Rave Coder setup with the following options
		| Form        | Field          | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms     |
		| ETE2        | Coding Field   | <Dictionary> |        | PRODUCTSYNONYM | 2        | true               | true           | LogSuppField4         |
		| ETEMCC62552 | Coding Field A | MedDRA       | ENG    | LLT            | 3        | false              | true           | ETEDRUG01, STDFIELD01 |
		| ETEMCC62552 | Coding Field B | MedDRA       | ENG    | LLT            | 4        | false              | false          |                       |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"	
	And a new Draft "NewCopiedDraft" is created through copy wizard for project "NewStudy"
	Then the project "NewStudy" draft "NewCopiedDraft" form "ETE2" field "Coding Field" has no Rave Coder setup options configured
	And the project "NewStudy" draft "NewCopiedDraft" form "ETEMCC62552" field "Coding Field A" has no Rave Coder setup options configured
	And the project "NewStudy" draft "NewCopiedDraft" form "ETEMCC62552" field "Coding Field B" has no Rave Coder setup options configured
		

@DFT
@Release2016.1.0
@PBMCC_223229_001
@PBMCC_223228_001
Scenario: Rave ETE Example Verifying Coding Decision within the Clincial Views
    Given a Rave project registration with dictionary "MedDRA ENG 19.0"
	And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
	 | Form | Field       | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
	 | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 2        | true               | false          | LogSuppField2, LogSuppField4 |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And setting the clinical view settings for dictionary "<Dictionary>" with the following data
    | Column | Term Suffix | Term SAS Suffix | Term Length | Code Suffix | Code SAS Suffix | Code Length |
    | ATC    | _ATC_       | _SAS_ATC_       | 50          | _ATC_CD_    | _SAS_ATC_CD_    | 50          |
    When adding a new subject "TST"
	And adding a new verbatim term to form "ETE2"
	| Field        | Value      | ControlType |
	| Coding Field | Headachery | LongText    |
	And Clinical Views for Project "<StudyName>" with mode "Full Then Incremental" is configured
	And report "Data Listing" for Project "<StudyName>", Data Source "Clinical Views" and Form "ETE2" is generated
	Then In report generated, I should see the data below
	| project                 | subject | CODERFIELD2_PS    | CODERFIELD2_PS_C |
	| <SourceSystemStudyName> | AA1     | SLOW RELEASE IRON | 000235 01 027 9  |


	
@DFT
@PBMCC_223226_001
Scenario: Rave ETE Example editting global Rave-Coder Configuration settings

Given Rave Modules App Segment is loaded
And global Rave-Coder Configuration settings with Review Marking Group set to "Data Management" and Requires Response set to "false" 