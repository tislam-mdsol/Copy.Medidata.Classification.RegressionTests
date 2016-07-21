@specENG_SearchListForceEntry.feature

@EndToEndDynamicSegment
Feature: Verify using the search list by entering a value not in the options is fully supported and the around trip integration works successfully.

@VAL
@PBMCC57210.001b
@ReleaseRave2013.2.0
Scenario: A coding decision will be accepted by EDC for a verbatim that has supplemental data that is not part of the SearchList dropdown values.
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
      | Form  | Field        | Dictionary   | Locale | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
      | ETE17 | Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | false              | false          | SEARCHLIST        |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE17"
	| Field                              | Value                    | ControlType |
	| Coding Field                       | child advil cold extreme |             |
	| Log Search List Supplemental Field | Extra Strength           | SearchList  |
	And Coder App Segment is loaded
 	And task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Trade Name" with code "010502 01 015" at level "TN" and a synonym is created
	And Rave Modules App Segment is loaded
    Then the coding decision for verbatim "child advil cold extreme" on form "ETE17" for field "Coding Field" contains the following data
      | Level          | Code          | Term Path                                         |
      | ATC            | M             | MUSCULO-SKELETAL SYSTEM                           |
      | ATC            | M01           | ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS       |
      | ATC            | M01A          | ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS |
      | ATC            | M01AE         | PROPIONIC ACID DERIVATIVES                        |
      | PRODUCT        | 010502 01 001 | CO-ADVIL                                          |
      | PRODUCTSYNONYM | 010502 01 015 | CHILDRENS ADVIL COLD                              |

@VAL
@PBMCC57210.001d
@ReleaseRave2013.2.0
Scenario: A coding decision will be accepted by EDC for a verbatim that is not part of the SearchList dropdown values and has no supplemental term.
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
      | Form  | Field               | Dictionary   | Locale | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE17 | Specify Search List | <Dictionary> |        | PRODUCTSYNONYM | 1        | false              | false          |  
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE17"
	| Field                              | Value                    | ControlType |
	| Log Search List Supplemental Field | child advil cold extreme | SearchList  |
	And Coder App Segment is loaded
 	And task "child advil cold extreme" is coded to term "CO-ADVIL" at search level "Preferred Name" with code "010502 01 001" at level "PN" and a synonym is created
	And Rave Modules App Segment is loaded
    Then the coding decision for verbatim "child advil cold extreme" on form "ETE17" for field "Log Search List Supplemental Field" contains the following data
      | Level          | Code          | Term Path                                         |
      | ATC            | M             | MUSCULO-SKELETAL SYSTEM                           |
      | ATC            | M01           | ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS       |
      | ATC            | M01A          | ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS |
      | ATC            | M01AE         | PROPIONIC ACID DERIVATIVES                        |
      | PRODUCT        | 010502 01 001 | CO-ADVIL                                          |
