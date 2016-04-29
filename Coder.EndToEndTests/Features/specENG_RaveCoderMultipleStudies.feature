Feature: Test the full round trip integration from Rave to Coder back to Rave using Multiple Studies

@DFT
@PB1.1.2-016
@ReleasePatch08
@DT13652,DT13787,DT13793
Scenario: Test that Rave is able to send coding terms to Coder even when more than 1 study is on the same Rave URL
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms   |
  	 | ETE19 | LL Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | true               | true           | DSearchlist Std Sup |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Prod"
	And a Rave Draft is published using draft "<Draft1>" for Project "<SourceSystemStudyName1>" to environment "UAT"
	And adding a new subject "TST" for Project "<SourceSystemStudyName>" to environment "Prod"
	And adding a new verbatim term to form "ETE19" for Project "<SourceSystemStudyName>" to environment "Prod"
 	| Field                                    | Value                    | ControlType       |
 	| Log Coding Field                         | child advil cold extreme | LongText          |
 	| Dynamic Search List Supplemental Field A | Sup1                     | DynamicSearchList |
	Then I verify the following Supplemental information is displayed
       | Supplemental Term         | Supplemental Value |
       | ETE19.DSearchlist Std Sup | Sup1               |
	When task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	And Rave Adverse Events form "ETE19" should display "CHILDRENS ADVIL COLD" 
	And Coder tasks should display "CHILDRENS ADVIL COLD"	