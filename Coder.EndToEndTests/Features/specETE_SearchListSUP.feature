@specETE_SearchListSUP

@EndToEndDynamicSegment

Feature: Verify using Search List combinations of standard fields, log line fields, search list, etc. for coding fields & supplement and component values is fully supported and the around trip integration works successfully.

@VAL
@PB92926SL.001
@Release2016.1.0
Scenario: Log line verbatim fields using a control type of Search List will be successfully coded 1
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field              | Dictionary   | Locale | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval |
  	 | ETE19 | LL SL Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | true               | true           |  
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field                        | Value                    | ControlType |
 	| Log Search List Coding Field | child advil cold extreme | SEARCHLIST  |
	And Coder App Segment is loaded
	Then task "child advil cold extreme" should contain the following source term information
       | Source System | Study              | Dictionary            | Locale | Term                     | Level      | Priority |
       | Rave EDC      | <StudyDisplayName> | WhoDrugDDEB2 - 200703 | ENG    | child advil cold extreme | Trade Name | 1        |
    When task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Trade Name" with code "010502 01 015" at level "TN" and a synonym is created	
	And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "child advil cold extreme" on form "ETE19" for field "Log Search List Coding Field" contains the following data
      | Level          | Code          | Term Path                                         |
      | ATC            | M             | MUSCULO-SKELETAL SYSTEM                           |
      | ATC            | M01           | ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS       |
      | ATC            | M01A          | ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS |
      | ATC            | M01AE         | PROPIONIC ACID DERIVATIVES                        |
      | PRODUCT        | 010502 01 001 | CO-ADVIL                                          |
      | PRODUCTSYNONYM | 010502 01 015 | CHILDRENS ADVIL COLD                              |
	
@VAL
@PB92926SL.002
@Release2016.1.0
Scenario: Standard verbatim fields using a control type of Search List will be successfully coded 2
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field               | Dictionary   | Locale | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | 
  	 | ETE19 | Std SL Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | true               | true           |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field                    | Value                    | ControlType |
 	| Search List Coding Field | child advil cold extreme | SearchList  |
	And Coder App Segment is loaded
	When task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Trade Name" with code "010502 01 015" at level "TN" and a synonym is created
	And Rave Modules App Segment is loaded
    Then the coding decision for verbatim "child advil cold extreme" on form "ETE19" for field "Search List Coding Field" contains the following data
      | Level          | Code          | Term Path                                         |
      | ATC            | M             | MUSCULO-SKELETAL SYSTEM                           |
      | ATC            | M01           | ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS       |
      | ATC            | M01A          | ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS |
      | ATC            | M01AE         | PROPIONIC ACID DERIVATIVES                        |
      | PRODUCT        | 010502 01 001 | CO-ADVIL                                          |
      | PRODUCTSYNONYM | 010502 01 015 | CHILDRENS ADVIL COLD                              |

@VAL
@PB92926SL.003
@Release2016.1.0
Scenario: Standard verbatim and supplemental fields using a control type of Search List will be successfully coded 3
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field               | Dictionary   | Locale | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms  |
  	 | ETE19 | Std SL Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | true               | true           | Std Searchlist Sup |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field                            | Value                    | ControlType |
 	| Search List Coding Field         | child advil cold extreme | SearchList  |
 	| Search List Supplemental Field B | No                       | SearchList  |
	And Coder App Segment is loaded
	Then the "child advil cold extreme" task has the following supplemental information
	| Term                   | Value |
	| ETE19.STDSEARCHLISTSUP | No    |
	When task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Trade Name" with code "010502 01 015" at level "TN" and a synonym is created
	And Rave Modules App Segment is loaded
    Then the coding decision for verbatim "child advil cold extreme" on form "ETE19" for field "Search List Coding Field" contains the following data
      | Level          | Code          | Term Path                                         |
      | ATC            | M             | MUSCULO-SKELETAL SYSTEM                           |
      | ATC            | M01           | ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS       |
      | ATC            | M01A          | ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS |
      | ATC            | M01AE         | PROPIONIC ACID DERIVATIVES                        |
      | PRODUCT        | 010502 01 001 | CO-ADVIL                                          |
      | PRODUCTSYNONYM | 010502 01 015 | CHILDRENS ADVIL COLD                              |

@VAL
@PB92926SL.004
@Release2016.1.0
Scenario: Log line verbatim and  supplement fields using a control type of Search List will be successfully coded. 
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field            | Dictionary   | Locale | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE19 | Log Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | true               | true           | LL SL Sup         |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field                                | Value                    | ControlType |
 	| Log Coding Field                     | child advil cold extreme | SearchList  |
 	| Log Search List Supplemental Field B | No                       | SearchList  |
	And Coder App Segment is loaded
	Then the "child advil cold extreme" task has the following supplemental information
	| Term          | Value |
	| ETE19.LLSLSUP | No    |
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
