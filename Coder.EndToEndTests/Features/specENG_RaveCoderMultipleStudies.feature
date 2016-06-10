@specENG_RaveCoderMultipleStudies.feature

@EndToEndMultipleProdStudy
Feature: Test the full round trip integration from Rave to Coder back to Rave using Multiple Studies

@DFT
@PB1.1.2.016
@ReleasePatch08
#@DT13652,DT13787,DT13793
Scenario: Test that Rave is able to send coding terms to Coder even when more than 1 study is on the same Rave URL
	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field           | Dictionary   | Locale | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms   |
  	 | ETE19 | LL Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | true               | true           | DSearchlist Std Sup |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And a Rave Draft is published using draft "<DraftName>" for Project "<UatStudyName>"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field                                    | Value                    | ControlType       |
 	| Log Coding Field                         | child advil cold extreme |                   |
 	| Dynamic Search List Supplemental Field B | Sup1                     | DynamicSearchList |
	And Coder App Segment is loaded
	Then the "child advil cold extreme" task has the following supplemental information
	| Term                    | Value |
	| ETE19.DSEARCHLISTSTDSUP | Sup1  |
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
