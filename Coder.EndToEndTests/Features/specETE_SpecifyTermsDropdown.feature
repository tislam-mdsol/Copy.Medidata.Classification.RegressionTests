Feature: Verify using the Other Specify for drop-downs and search-lists is supported and the around trip integration works successfully.

@DFT
@PBMCC40159_001b
@ReleaseRave2013.2.0
@DTMCC68955
Scenario: A coding decision will be accepted by EDC for a verbatim that has data submitted via the Other Specify dropdown option on the supplemental field
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field        | Dictionary   | Locale   | CodingLevel 		| Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms   	|
  	 | ETE17 | CoderField17 | <Dictionary> | <Locale> | PRODUCTSYNONYM       | 1        | true               | true           |  					|
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE17"
 	| Field              	| Value 					  	| ControlType       |
	| Medical Term      	| child advil cold extreme 		| LongText          |
 	| Specify Dropdown      | Other Option   				| DropDownList      |
 	| Specify Dropdown      | terrible head pain    		|                   |
    Then Coder Source Terms contains the following
      |Value				      |Column		        |Table				    |
      |ETE17.Specify Dropdown	  |Supplemental Term    |Supplements Table		|
      |terrible head pain         |Supplemental Value   |Supplements Table		|
	When task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	Then Rave Adverse Events form "ETE17" should display "CHILDRENS ADVIL COLD" 
	And Coder tasks should display "CHILDRENS ADVIL COLD"	

@DFT
@PBMCC40159_001d
@ReleaseRave2013.2.0
@DTMCC68955
Scenario: A coding decision will be accepted by EDC for a verbatim that has data submitted via the Other Specify dropdown option
	Given a Rave project registration with dictionary "MedDRA ENG 11.0"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field        | Dictionary   | Locale   | CodingLevel 		| Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms   	|
  	 | ETE17 | CoderField17 | <Dictionary> | <Locale> | LLT		         | 1        | true               | true           |  					|
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE17"
 	| Field              	| Value 					  	| ControlType       |
 	| Specify Dropdown      | Other Option   				| DropDownList      |
 	| Specify Dropdown      | terrible head pain    		|                   |
	When task "terrible head pain" is coded to term "headache" at search level "Lower Level Term" with code "10019211" at level "LLT" and a synonym is created
	Then Rave Adverse Events form "ETE17" should display "headache" 
	And Coder tasks should display "headache"	