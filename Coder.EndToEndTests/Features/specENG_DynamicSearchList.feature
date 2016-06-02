@specENG_DynamicSearchList

@EndToEndDynamicSegment

Feature: Verify using Dynamic Search List combinations of Standard Fields, Log Line Fields, Search List, etc. for Coding Fields & Supplement and Component Values is fully supported and the round trip integration works successfully.
 
@VAL
@PB92926DSL.002SUP
@Release2016.1.0
Scenario: Standard verbatim and supplemental fields using a control type of Dynamic Search List will be successfully coded. 

	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field        | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms  |
  	 | ETE19 | Coding Field | <Dictionary> |          | PRODUCTSYNONYM | 1        | true               | true           | DSearchlist Std Sup |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	When adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field                                    | Value                    | ControlType       |
 	| Coding Field                             | child advil cold extreme |                   |
 	| Dynamic Search List Supplemental Field B | DarkRed                  | DynamicSearchList |
    And Coder App Segment is loaded
	Then the "child advil cold extreme" task has the following supplemental information
	| Term                   | Value   |
	| ETE19.DSEARCHLISTSTDSUP | DarkRed |
	And task "child advil cold extreme" should contain the following source term information
       | Source System | Study              | Dictionary            | Locale | Term                     | Level      | Priority |
       | Rave EDC      | <StudyDisplayName> | WhoDrugDDEB2 - 200703 | ENG    | child advil cold extreme | Trade Name | 1        |
	When task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Trade Name" with code "010502 01 015" at level "TN" and a synonym is created	
	And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "child advil cold extreme" on form "ETE19" for field "Coding Field" contains the following data
      | Level          | Code          | Term Path                                         |
      | ATC            | M             | MUSCULO-SKELETAL SYSTEM                           |
      | ATC            | M01           | ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS       |
      | ATC            | M01A          | ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS |
      | ATC            | M01AE         | PROPIONIC ACID DERIVATIVES                        |
      | PRODUCT        | 010502 01 001 | CO-ADVIL                                          |
      | PRODUCTSYNONYM | 010502 01 015 | CHILDRENS ADVIL COLD                              |

	  
@VAL
@PB92926DSL.005LLSUP
@Release2016.1.0
Scenario: Log line verbatim and supplemental fields using a control type of Dynamic Search List will be successfully coded.
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field           | Dictionary   | Locale | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms  |
  	 | ETE19 | LL Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | true               | true           | DSearchlist LL Sup |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field                                        | Value                    | ControlType       |
 	| Log Coding Field                             | child advil cold extreme | SearchList        |
 	| Log Dynamic Search List Supplemental Field B | Sup1                     | DynamicSearchList |
	And Coder App Segment is loaded
	Then the "child advil cold extreme" task has the following supplemental information
	   | Term                   | Value |
	   | ETE19.DSEARCHLISTLLSUP | Sup1  |
    And task "child advil cold extreme" should contain the following source term information
       | Source System | Study              | Dictionary            | Locale | Term                     | Level      | Priority |
       | Rave EDC      | <StudyDisplayName> | WhoDrugDDEB2 - 200703 | ENG    | child advil cold extreme | Trade Name | 1        |
	When task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Trade Name" with code "010502 01 015" at level "TN" and a synonym is created	
	And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "child advil cold extreme" on form "ETE19" for field "Log Coding Field" contains the following data
      | Level          | Code          | Term Path                                         |
      | ATC            | M             | MUSCULO-SKELETAL SYSTEM                           |
      | ATC            | M01           | ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS       |
      | ATC            | M01A          | ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS |
      | ATC            | M01AE         | PROPIONIC ACID DERIVATIVES                        |
      | PRODUCT        | 010502 01 001 | CO-ADVIL                                          |
      | PRODUCTSYNONYM | 010502 01 015 | CHILDRENS ADVIL COLD                              |
	