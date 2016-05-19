@specENG_SearchListForceEntry.feature

@EndToEndDynamicSegment
Feature: Verify using the search list by entering a value not in the options is fully supported and the around trip integration works successfully.

@DFT
@PBMCC57210-001b
@ReleaseRave2013.2.0
Scenario: A coding decision will be accepted by EDC for a verbatim that has supplemental data that is not part of the SearchList dropdown values.
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field        | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE17 | CoderField17 | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | true               | true           |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE17"
		| Field               | Value                    | ControlType |
		| Specify Search List | child advil cold extreme | SearchList  |
	And supplemental term for the following field
 	| Form  | Field               | SupplementalTerm | SupplementalValue |
 	| ETE17 | Specify Search List | LogSuppField17   | Extra Strength    |
    And Coder Source Terms contains the following
      | Supplemental Term         | Supplemental Value |
      | ETE17.Specify Search List | Extra Strength     |
	And task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	Then Rave Adverse Events form "ETE17" should not display "child advil cold extreme"
	And I verify the following Source Term information is displayed
       | Source System  | Study                          | Dictionary            | Locale | Term                     | Level      | Priority |
       | <SourceSystem> | <SourceSystemStudyDisplayName> | WhoDrugDDEB2 - 200703 | ENG    | child advil cold extreme | Trade Name | 1        |
	
@DFT
@PBMCC57210-001d
@ReleaseRave2013.2.0
Scenario: A coding decision will be accepted by EDC for a verbatim that is not part of the SearchList dropdown values.
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field        | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE17 | CoderField17 | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | true               | true           |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE17"
		| Field               | Value                    | ControlType |
		| Specify Search List | child advil cold extreme | SearchList  |
	And task "child advil cold extra" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	Then Rave Adverse Events form "ETE17" should not display "child advil cold extreme"
	And I verify the following Source Term information is displayed
       | Source System  | Study                          | Dictionary            | Locale | Term                     | Level      | Priority |
       | <SourceSystem> | <SourceSystemStudyDisplayName> | WhoDrugDDEB2 - 200703 | ENG    | child advil cold extreme | Trade Name | 1        |
