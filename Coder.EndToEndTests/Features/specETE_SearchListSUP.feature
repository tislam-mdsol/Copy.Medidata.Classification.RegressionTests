@specETE_SearchListSUP

@EndToEndDynamicSegment

Feature: Verify using Search List combinations of standard fields, log line fields, search list, etc. for coding fields & supplement and component values is fully supported and the around trip integration works successfully.

@DFT
@PB92926SL-001
@Release2016.1.0
Scenario: Log line verbatim fields using a control type of Search List will be successfully coded 1
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field                        | Dictionary   | Locale | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval |
  	 | ETE19 | Log Search List Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | true               | true           |  
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field                        | Value                    | ControlType |
 	| Log Search List Coding Field | child advil cold extreme | SEARCHLIST  |
	And Coder App Segment is loaded
	And task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	Then I verify the following Source Term information is displayed
       | Source System  | Study                          | Dictionary    			| Locale | Term                 | Level      		| Priority |
       | <SourceSystem> | <SourceSystemStudyDisplayName> | WhoDrugDDEB2 - 200703 	| ENG    | CHILDRENS ADVIL COLD	| Trade Name	 	| 1        |	
	When Rave Modules App Segment is loaded
	# This is not implemented. Need to add a step that confirms that Rave should have received the coding decision, otherwise the test will not be able
	# to determine if the coding decision was not sent or just hasn't arrived yet.
	# OR, should this be "should display"?
	Then Rave Adverse Events form "ETE19" should not display "CHILDRENS ADVIL COLD" 
	
@DFT
@PB92926SL.002
@Release2016.1.0
Scenario: Standard verbatim fields using a control type of Search List will be successfully coded 2
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field               | Dictionary   | Locale | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms  |
  	 | ETE19 | Std SL Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | true               | true           | Std Searchlist Sup |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field              	| Value 					  	| ControlType       |
	| Search List	      	| child advil cold extreme 		| SearchList        |
	And Coder App Segment is loaded
	And task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
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
	| ETE19.StdSearchlistSup | No    |
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
