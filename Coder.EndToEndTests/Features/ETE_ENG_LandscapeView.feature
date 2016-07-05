Feature: Log line coding fields in Rave EDC who have been set with landscape view in Rave Architect will display coded decisions.

@VAL
@MCC-207752-005
@Release2016.1.0
Scenario: Verify a coding decision is visible for a submitted log line verbatim in a landscape form in EDC

Given a Rave project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form        | Field          | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval |
| ETE12       | Coding Field   | <Dictionary> |        | LLT            | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
When adding a new subject "TST"
And adding a new verbatim term to form "ETE12"
| Field                    | Value              | ControlType |
| Coding Field             | terrible head pain | LongText    |
And Coder App Segment is loaded
And task "terrible head pain" is coded to term "ACHES-N-PAIN" at search level "Low Level Term" with code "??????????????" at level "LLT"
And Rave Modules App Segment is loaded
Then the coding decision for verbatim "terrible head pain" on form "ETE2" for field "Coding Field" contains the following data
| Level | Code     | Term Path                    |
| SOC   | 10007541 | Cardiac disorders            |
| HLGT  | 10007521 | Cardiac arrhythmias          |
| HLT   | 10042600 | Supraventricular arrhythmias |
| PT    | 10003658 | Atrial fibrillation          |
| LLT   | 10003658 | Atrial fibrillation          |


@VAL
@MCC-207752-006
@Release2016.1.0
Scenario: Verify a coding decisions is visible for multi-log line submissions in a landscape form in EDC

Given a Rave project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form        | Field          | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval |
| ETE12       | Coding Field   | <Dictionary> |        | LLT            | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
When adding a new subject "TST"
And adding a new verbatim term to form "ETE12"
| Field                    | Value              | ControlType |
| Coding Field             | terrible head pain | LongText    |
And adding a new verbatim term to form "ETE12"
| Field                    | Value              | ControlType |
| Coding Field             | Ankle Pain         | LongText    |
And Coder App Segment is loaded
And task "terrible head pain" is coded to term "ACHES-N-PAIN" at search level "Low Level Term" with code "??????????????" at level "LLT"
And Rave Modules App Segment is loaded
Then the coding decision for verbatim "terrible head pain" on form "ETE2" for field "Coding Field" contains the following data
| Level | Code     | Term Path                    |
| SOC   | 10007541 | Cardiac disorders            |
| HLGT  | 10007521 | Cardiac arrhythmias          |
| HLT   | 10042600 | Supraventricular arrhythmias |
| PT    | 10003658 | Atrial fibrillation          |
| LLT   | 10003658 | Atrial fibrillation          |


@VAL
@MCC-207752-007
@Release2016.1.0
Scenario: Verify a coding decision is visible for a submitted log line verbatim in a landscape form in EDC that contains a Rave Query.
Given a Rave project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form        | Field          | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval |
| ETE12       | Coding Field   | <Dictionary> |        | LLT            | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
When adding a new subject "TST"
And adding a new verbatim term to form "ETE12"
| Field                    | Value              | ControlType |
| Coding Field             | terrible head pain | LongText    |
And I open a rave query for task "terrible head pain" on form "ETE12" with comment "this is a rave query"
And Coder App Segment is loaded
And task "terrible head pain" is coded to term "ACHES-N-PAIN" at search level "Low Level Term" with code "??????????????" at level "LLT"
And Rave Modules App Segment is loaded
Then the coding decision for verbatim "terrible head pain" on form "ETE2" for field "Coding Field" contains the following data
| Level | Code     | Term Path                    |
| SOC   | 10007541 | Cardiac disorders            |
| HLGT  | 10007521 | Cardiac arrhythmias          |
| HLT   | 10042600 | Supraventricular arrhythmias |
| PT    | 10003658 | Atrial fibrillation          |
| LLT   | 10003658 | Atrial fibrillation          |

   
