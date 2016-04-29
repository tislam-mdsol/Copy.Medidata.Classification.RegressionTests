Feature: Verify using Search List combinations of standard fields, log line fields, search list, etc. for coding fields & supplement and component values is fully supported and the around trip integration works successfully.

@DFT
@PB92926SL-001
@Release2016.1.0
Scenario: Log line verbatim fields using a control type of Search List will be successfully coded.
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field        | Dictionary   | Locale   | CodingLevel 		| Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms   	|
  	 | ETE19 | CoderField19 | <Dictionary> | <Locale> | PRODUCTSYNONYM       | 1        | true               | true           |  					|
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field              	| Value 					  	| ControlType       |
	| Search List LL      	| child advil cold extreme 		| SearchListLL      |
	And Coder App Segment is loaded
	Then task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	And Coder tasks should display "CHILDRENS ADVIL COLD"	
	And I verify the following Source Term information is displayed
       | Source System  | Study                          | Dictionary    			| Locale | Term                 | Level      		| Priority |
       | <SourceSystem> | <SourceSystemStudyDisplayName> | WhoDrugDDEB2 - 200703 	| ENG    | CHILDRENS ADVIL COLD	| Trade Name	 	| 1        |	
	And Rave Adverse Events form "ETE19" should not display "CHILDRENS ADVIL COLD" 
	
@DFT
@PB92926SL-002
@Release2016.1.0
Scenario: Standard verbatim fields using a control type of Search List will be successfully coded.
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field        | Dictionary   | Locale   | CodingLevel 		| Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms   	|
  	 | ETE19 | CoderField19 | <Dictionary> | <Locale> | PRODUCTSYNONYM       | 1        | true               | true           |  					|
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field              	| Value 					  	| ControlType       |
	| Search List	      	| child advil cold extreme 		| SearchList        |
	Then task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	And Rave Adverse Events form "ETE19" should display "CHILDRENS ADVIL COLD" 
	And Coder tasks should display "CHILDRENS ADVIL COLD"	

@DFT
@PB92926SL-004
@Release2016.1.0
Scenario: Standard verbatim and supplemental fields using a control type of Search List will be successfully coded.
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field        | Dictionary   | Locale   | CodingLevel 		| Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms   	|
  	 | ETE19 | CoderField19 | <Dictionary> | <Locale> | PRODUCTSYNONYM       | 1        | true               | true           |  					|
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field              	| Value 					  	| ControlType       |
	| Search List	      	| child advil cold extreme 		| SearchList        |
	| Search List Sup 		| LogSuppField19				| SearchList 		|
	And supplemental terms for the following fields
 	| Form  | Field        | SupplementalTerm |
 	| ETE19 | CoderField19 | LogSuppField19   |
    Then Coder Source Terms contains the following Supplemental Term "LogSuppField19"
	And task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	And Rave Adverse Events form "ETE19" should display "CHILDRENS ADVIL COLD" 
	And Coder tasks should display "CHILDRENS ADVIL COLD"

@DFT
@PB92926SL-008
@Release2016.1.0
Scenario: Log line verbatim and  supplement fields using a control type of Search List will be successfully coded. 
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field        | Dictionary   | Locale   | CodingLevel 		| Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms   	|
  	 | ETE19 | CoderField19 | <Dictionary> | <Locale> | PRODUCTSYNONYM       | 1        | true               | true           |  					|
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field              	| Value 					  	| ControlType       |
	| Search List LL      	| child advil cold extreme 		| SearchList        |
	| Search List Sup 		| LogSuppField19				| SearchList 		|
	And supplemental terms for the following fields
 	| Form  | Field        | SupplementalTerm |
 	| ETE19 | CoderField19 | LogSuppField19   |
    Then Coder Source Terms contains the following Supplemental Term "LogSuppField19"
	And task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	And Rave Adverse Events form "ETE19" should display "CHILDRENS ADVIL COLD" 
	And Coder tasks should display "CHILDRENS ADVIL COLD"
