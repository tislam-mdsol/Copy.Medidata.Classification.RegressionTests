Feature: EDC will still be able to receive coding decisions even when the field has been locked or frozen.

@VAL
@MCC-207752-001
@Release2016.1.0
Scenario: A coding decision will still be processed even if the data point has been frozen

Given a Rave project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form        | Field          | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms													  |
| ETE2        | Coding Field   | <Dictionary> |        | LLT            | 1        | true               | true           | LOGSUPPFIELD2,LOGSUPPFIELD4,LOGCOMPFIELD1,COMPANY,LOGCOMPFIELD3,SOURCE |
When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
When adding a new subject "TST"
And adding a new verbatim term to form "ETE2"
| Field                    | Value              | ControlType |
| Coding Field             | terrible head pain | LongText    |
And the Rave row on form "ETE2" with verbatim term "Sharp pain down leg" is frozen
And Coder App Segment is loaded
And task "sharp pain in nerves" is coded to term "ACHES-N-PAIN" at search level "Low Level Term" with code "??????????????" at level "LLT"
And Rave Modules App Segment is loaded
Then the coding decision for verbatim "terrible head pain" on form "ETE2" for field "Coding Field" contains the following data
| Level | Code     | Term Path                    |
| SOC   | 10007541 | Cardiac disorders            |
| HLGT  | 10007521 | Cardiac arrhythmias          |
| HLT   | 10042600 | Supraventricular arrhythmias |
| PT    | 10003658 | Atrial fibrillation          |
| LLT   | 10003658 | Atrial fibrillation          |

@VAL
@MCC-207752-002
@Release2016.1.0
Scenario: A coding decision will still be processed even if the data point has been locked

Given a Rave project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form        | Field          | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms													  |
| ETE2        | Coding Field   | <Dictionary> |        | LLT            | 1        | true               | true           | LOGSUPPFIELD2,LOGSUPPFIELD4,LOGCOMPFIELD1,COMPANY,LOGCOMPFIELD3,SOURCE |
When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
When adding a new subject "TST"
And adding a new verbatim term to form "ETE2"
| Field                    | Value              | ControlType |
| Coding Field             | terrible head pain | LongText    |
And the Rave row on form "ETE2" with verbatim term "Sharp pain down leg" is locked
And Coder App Segment is loaded
And task "sharp pain in nerves" is coded to term "ACHES-N-PAIN" at search level "Low Level Term" with code "??????????????" at level "LLT"
And Rave Modules App Segment is loaded
Then the coding decision for verbatim "terrible head pain" on form "ETE2" for field "Coding Field" contains the following data
| Level | Code     | Term Path                    |
| SOC   | 10007541 | Cardiac disorders            |
| HLGT  | 10007521 | Cardiac arrhythmias          |
| HLT   | 10042600 | Supraventricular arrhythmias |
| PT    | 10003658 | Atrial fibrillation          |
| LLT   | 10003658 | Atrial fibrillation          |


@VAL
@MCC-207752-003
@Release2016.1.0
Scenario:  A coding decision will still be processed even if the forms have been locked
Given a Rave project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form        | Field          | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms													  |
| ETE2        | Coding Field   | <Dictionary> |        | LLT            | 1        | true               | true           | LOGSUPPFIELD2,LOGSUPPFIELD4,LOGCOMPFIELD1,COMPANY,LOGCOMPFIELD3,SOURCE |
When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
When adding a new subject "TST"
And adding a new verbatim term to form "ETE2"
| Field                    | Value              | ControlType |
| Coding Field             | terrible head pain | LongText    |
And form "ETE2" is locked
And Coder App Segment is loaded
And task "sharp pain in nerves" is coded to term "ACHES-N-PAIN" at search level "Low Level Term" with code "??????????????" at level "LLT"
And Rave Modules App Segment is loaded
Then the coding decision for verbatim "terrible head pain" on form "ETE2" for field "Coding Field" contains the following data
| Level | Code     | Term Path                    |
| SOC   | 10007541 | Cardiac disorders            |
| HLGT  | 10007521 | Cardiac arrhythmias          |
| HLT   | 10042600 | Supraventricular arrhythmias |
| PT    | 10003658 | Atrial fibrillation          |
| LLT   | 10003658 | Atrial fibrillation          |


@VAL
@MCC-207752-004
@Release2016.1.0
Scenario: A coding decision will still be processed even if the data page has been frozen
Given a Rave project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form        | Field          | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms													  |
| ETE2        | Coding Field   | <Dictionary> |        | LLT            | 1        | true               | true           | LOGSUPPFIELD2,LOGSUPPFIELD4,LOGCOMPFIELD1,COMPANY,LOGCOMPFIELD3,SOURCE |
When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
When adding a new subject "TST"
And adding a new verbatim term to form "ETE2"
| Field                    | Value              | ControlType |
| Coding Field             | terrible head pain | LongText    |
And form "ETE2" is frozen
And Coder App Segment is loaded
And task "sharp pain in nerves" is coded to term "ACHES-N-PAIN" at search level "Low Level Term" with code "??????????????" at level "LLT"
And Rave Modules App Segment is loaded
Then the coding decision for verbatim "terrible head pain" on form "ETE2" for field "Coding Field" contains the following data
| Level | Code     | Term Path                    |
| SOC   | 10007541 | Cardiac disorders            |
| HLGT  | 10007521 | Cardiac arrhythmias          |
| HLT   | 10042600 | Supraventricular arrhythmias |
| PT    | 10003658 | Atrial fibrillation          |
| LLT   | 10003658 | Atrial fibrillation          |
