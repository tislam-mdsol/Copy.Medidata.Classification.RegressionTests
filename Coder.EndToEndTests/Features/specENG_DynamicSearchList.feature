Feature: UPDATED 041316 COMPLETED Verify using Dynamic Search List combinations of Standard Fields, Log Line Fields, Search List, etc. for Coding Fields & Supplement and Component Values is fully supported and the round trip integration works successfully.
 
@DFT
@PB92926DSL-002SUP
@Release2016.1.0
Scenario: Standard verbatim and supplemental fields using a control type of Dynamic Search List will be successfully coded. 

	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field        | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms  |
  	 | ETE19 | Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | true               | true           | DSearchlist LL Sup |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field                                    | Value                    | ControlType       |
 	| Coding Field                             | child advil cold extreme |                   |
 	| Dynamic Search List Supplemental Field B | DarkRed                  | DynamicSearchList |
    And Coder App Segment is loaded
	Then the "child advil cold extreme" task has the following supplemental information
	| Term                                     | Value   |
	| Dynamic Search List Supplemental Field B | DarkRed |
	When task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	# This is not implemented. Need to add a step that confirms that Rave should have received the coding decision, otherwise the test will not be able
	# to determine if the coding decision was not sent or just hasn't arrived yet.
	# OR, should this be "should display"?
	# OR, should the verbatim field be a dynamic field?
	Then Rave Adverse Events form "ETE2" should not display "child advil cold extreme" 
	# Is this required?
	And I verify the following Source Term information is displayed
       | Source System  | Study       | Dictionary            | Locale | Term                     | Level      | Priority |
       | <SourceSystem> | <StudyName> | WhoDrugDDEB2 - 200703 | ENG    | child advil cold extreme | Trade Name | 1        |
	  
@DFT
@PB92926DSL-005LLSUP
@Release2016.1.0
Scenario: Log line verbatim and supplemental fields using a control type of Dynamic Search List will be successfully coded.
#This scenario should be updated based on the above scenarios for LL fields. See above comments.
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field        	| Dictionary   | Locale   | CodingLevel 			| Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms             |
  	 | ETE19 | LL Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM          | 1        | true               | true           |  DSearchlist LL Sup			|
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field              	| Value 					  	| ControlType       |
	| Log Coding Field    	| child advil cold extreme 		| LongText          |
 	| DSearchlist LL Sup 	| Sup1						| DynamicSearchList |
	Then I verify the following Supplemental information is displayed
       | Supplemental Term   		| Supplemental Value  |
       | ETE19.DSearchlist LL Sup 	| Sup1               |
	When task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	Then Rave Adverse Events form "ETE2" should not display "child advil cold extreme" 
	And I verify the following Source Term information is displayed
       | Source System  | Study                          | Dictionary    			| Locale | Term                 		| Level      		| Priority |
       | <SourceSystem> | <SourceSystemStudyDisplayName> | WhoDrugDDEB2 - 200703 	| ENG    | child advil cold extreme	 	| Trade Name	 	| 1        |
	