@specETE_ENG_LandscapeView.feature

@EndToEndDynamicSegment
Feature: Log line coding fields in Rave EDC who have been set with landscape view in Rave Architect will display coded decisions.

@VAL
@MCC_207752_001
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

@VAL
@MCC_207752_002
@Release2016.1.0
@IncreaseTimeout
Scenario: Verify a coding decisions is visible for multi-log line submissions in a landscape form in EDC

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
	And adding a new verbatim term to form "ETE12"
	| Field | Value                    | ControlType |
	| 2     | Drug Verbatim 1          | LongText    |
	And Coder App Segment is loaded
 	And task "child advil cold extreme" is coded to term "CO-ADVIL" at search level "Preferred Name" with code "010502 01 001" at level "PN" and a synonym is created
	And task "Drug Verbatim 1" is coded to term "BAYER CHILDREN'S COLD" at search level "Preferred Name" with code "005581 01 001" at level "PN" and a synonym is created
	And Rave Modules App Segment is loaded
    Then the coding decision for verbatim "child advil cold extreme" on form "ETE12" for field "Coding Field" contains the following data
      | Level          | Code          | Term Path                                         |
      | ATC            | M             | MUSCULO-SKELETAL SYSTEM                           |
      | ATC            | M01           | ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS       |
      | ATC            | M01A          | ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS |
      | ATC            | M01AE         | PROPIONIC ACID DERIVATIVES                        |
      | PRODUCT        | 010502 01 001 | CO-ADVIL                                          |
	And the coding decision for verbatim "Drug Verbatim 1" on form "ETE12" for field "Coding Field" contains the following data
	 | Level   | Code          | Term Path                         |
	 | ATC     | N             | NERVOUS SYSTEM                    |
	 | ATC     | N02           | ANALGESICS                        |
	 | ATC     | N02B          | OTHER ANALGESICS AND ANTIPYRETICS |
	 | ATC     | N02BA         | SALICYLIC ACID AND DERIVATIVES    |
	 | PRODUCT | 005581 01 001 | BAYER CHILDREN'S COLD             |

@VAL
@MCC_207752_003
@Release2016.1.0
Scenario: Verify a coding decision is visible for a submitted log line verbatim in a landscape form in EDC that contains a Rave Query.

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
	And row on form "ETE12" containing "child advil cold extreme" is marked with a query
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
