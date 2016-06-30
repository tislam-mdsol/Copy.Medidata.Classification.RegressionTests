@specETE_ENG_LandscapeView.feature

@EndToEndDynamicSegment
Feature: Log line coding fields in Rave EDC who have been set with landscape view in Rave Architect will display coded decisions.

@VAL
@MCC_207752_005
@Release2016.1.0
Scenario: Verify a coding decision is visible for a submitted log line verbatim in a landscape form in EDC

	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
      | Form  | Field        | Dictionary   | Locale | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE12 | Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | true               | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE12"
	| Field | Value                    | ControlType |
	| 1     | child advil cold extreme | LongText    |
	#And the Rave row on form "ETE12" with verbatim term "child advil cold extreme" is frozen
	And Coder App Segment is loaded
 	And task "child advil cold extreme" is coded to term "CO-ADVIL" at search level "Preferred Name" with code "010502 01 001" at level "PN" and a synonym is created
	And Rave Modules App Segment is loaded
    Then the coding decision for verbatim "child advil cold extreme" on form "ETE12" for field "Coding Field" contains the following data
      | Level          | Code          | Term Path                                         |
      | ATC            | M             | MUSCULO-SKELETAL SYSTEM                           |
      | ATC            | M01           | ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS       |
      | ATC            | M01A          | ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS |
      | ATC            | M01AE         | PROPIONIC ACID DERIVATIVES                        |
      | PRODUCT        | 010502 01 001 | CO-ADVIL                                          |

@DFT
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


@DFT
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

   
