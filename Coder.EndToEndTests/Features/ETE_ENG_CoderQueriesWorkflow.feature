Feature: When a Coder query is answered or cancelled, the verbatim will be resent to Coder.



@VAL
@PB9.1.0-001
@Release2016.1.0
Scenario: Verify after opening a Query in Coder that the Query is Opened in Rave and an Answer for that Closed Query makes it to Coder.

Given a Rave project registration with dictionary "MedDRA 12.0 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
| ETE1 | Adverese Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
And adding a new subject "TST"
And adding a new verbatim term to form "ETE1"
| Field        | Value					   | ControlType |
| Coding Field | sharp pain down leg query | LongText    |
And Coder App Segment is loaded
And I open a query for task "sharp pain down leg query" with comment "Opening Query, does this make sense?"
And a coding task "sharp pain down leg" returns to "Open" query status
Then the query history contains the following information
| User         | Verbatim Term              | Query Status | Query Text                           | Query Response | Open To            | Query Notes |
| <SystemUser> | SHARP PAIN DOWN LEG QUERY  |  Open        | Opening Query, does this make sense? |                | SystemMarkingGroup |             |
When Rave Modules App Segment is loaded
And the coder query to the Rave form "ETE1" field "Adverese Event 1" with verbatim term "SHARP PAIN DOWN LEG QUERY" is responded to with "Answered Query, yes it makes sense."
And Coder App Segment is loaded
And a coding task "sharp pain down leg query" returns to "closed" query status
Then the query history contains the following information
| User         | Verbatim Term              | Query Status | Query Text                           | Query Response                      | Query Notes |
| <SystemUser> | sharp pain down leg query  | Closed       | Opening Query, does this make sense? |Answered Query, yes it makes sense.  |             |



@VAL
@PB9.1.0-002
@Release2016.1.0
Scenario: Verify after opening a Query in Coder that the Query is Opened and then Cancelled in Rave which updates the Query status in Coder

Given a Rave project registration with dictionary "MedDRA 12.0 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
| ETE1  | Adverese Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
And adding a new subject "TST"
And adding a new verbatim term to form "ETE1"
| Field        | Value					   | ControlType |
| Coding Field | sharp pain down leg query | LongText    |
And Coder App Segment is loaded
And I open a query for task "sharp pain down leg query" with comment "Opening Query, does this make sense?"
And a coding task "sharp pain down leg" returns to "Open" query status
Then the query history contains the following information
| User         | Verbatim Term              | Query Status | Query Text                           | Query Response | Query Notes |
| <SystemUser> | SHARP PAIN DOWN LEG QUERY  |  Open        | Opening Query, does this make sense? |                |             |
When Rave Modules App Segment is loaded
And the coder query to the Rave form "ETE1" field "Adverese Event 1" with verbatim term "SHARP PAIN DOWN LEG QUERY" is canceled
And Coder App Segment is loaded
And a coding task "SHARP PAIN DOWN LEG QUERY" returns to "Cancelled" query status
Then the query history contains the following information
| User         | Verbatim Term              | Query Status | Query Text                           | Query Response | Query Notes |
| <SystemUser> | SHARP PAIN DOWN LEG QUERY  | Cancelled    | Opening Query, does this make sense? |                |             |



@VAL
@PB9.1.0-003
@Release2016.1.0
Scenario: Verify after opening a Query in Coder that the Query is Opened and then Cancelled in Coder which updates the Query status in Rave.

Given a Rave project registration with dictionary "MedDRA 12.0 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
| ETE1  | Adverese Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
And adding a new subject "TST"
And adding a new verbatim term to form "ETE1"
| Field        | Value					   | ControlType |
| Coding Field | sharp pain down leg query | LongText    |
And Coder App Segment is loaded
And I open a query for task "sharp pain down leg query" with comment "Opening Query, does this make sense?"
And a coding task "sharp pain down leg query" returns to "Open" query status
Then the query history contains the following information
| User         | Verbatim Term              | Query Status | Query Text                           | Query Response | Query Notes |
| <SystemUser> | sharp pain down leg query  |  Open        | Opening Query, does this make sense? |                |             |
When I cancel the query for task "sharp pain down leg query"
And a coding task "sharp pain down leg query" returns to "Cancelled" query status
Then the query history contains the following information
| User         | Verbatim Term              | Query Status | Query Text                           | Query Response | Query Notes |
| <SystemUser> | sharp pain down leg query  |  Cancelled   | Opening Query, does this make sense? |                |             |
When Rave Modules App Segment is loaded
And the coder query to the Rave form "ETE1" field "Adverese Event 1" with verbatim term "sharp pain down leg query" is canceled




@VAL
@PB9.1.0-004
@Release2016.1.0
Scenario: Verify after opening a Query in Coder that the Query is Opened in Rave but then is Closed in Rave when the term has been coded and approved in Coder.

Given a Rave project registration with dictionary "MedDRA 12.0 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
| ETE1  | Adverese Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
And adding a new subject "TST"
And adding a new verbatim term to form "ETE1"
| Field        | Value					        | ControlType |
| Coding Field | sharp pain down leg query code | LongText    |
And Coder App Segment is loaded
And I open a query for task "sharp pain down leg query code" with comment "Code this anyway"
And a coding task "sharp pain down leg" returns to "Open" query status
Then the query history contains the following information
| User         | Verbatim Term                   | Query Status | Query Text       | Query Response | Query Notes |
| <SystemUser> | sharp pain down leg query code  |  Open        | Code this anyway |                |             |
When task "sharp pain down leg query code" is coded to term "ALEVE" at search level "Low Level Term" with code "??????????????" at level "LLT"
And approve and reclassify task "sharp pain down leg query code" with Include Autocoded Items set to "True"
Then the query history contains the following information
| User         | Verbatim Term                   | Query Status | Query Text       | Query Response | Query Notes |
| <SystemUser> | sharp pain down leg query code  | Cancelled    | Code this anyway |                |             |
