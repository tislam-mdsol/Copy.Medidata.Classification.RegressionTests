@specETE_SpecifyTermsDropdown

@EndToEndStaticSegment

Feature: Verify using the Other Specify for drop-downs and search-lists is supported and the around trip integration works successfully.

@DFT
@PBMCC40159_001b
@ReleaseRave2013.2.0
@DTMCC68955
Scenario: A coding decision will be accepted by EDC for a verbatim that has data submitted via the Other Specify dropdown option on the supplemental field

	Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field        | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE17 | Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | true               | true           | Specify Dropdown  |
	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE17"
 	| Field                             | Value                    | ControlType  |
 	| Coding Field                      | child advil cold extreme | LongText     |
 	| Log Dropdown Supplemental Field A | Other Option             | DropDownList |
 	| Log Dropdown Supplemental Field A | terrible head pain       |              |
	And Coder App Segment is loaded
	Then the "child advil cold extreme" task has the following supplemental information
	| Term                  | Value              |
	| ETE17.SPECIFYDROPDOWN | terrible head pain |
	When task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Trade Name" with code "010502 01 015" at level "TN" and a synonym is created
	And Rave Modules App Segment is loaded
    Then the coding decision for verbatim "child advil cold extreme" on form "ETE17" for field "Coding Field" contains the following data
      | Level          | Code          | Term Path                                         |
      | ATC            | M             | MUSCULO-SKELETAL SYSTEM                           |
      | ATC            | M01           | ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS       |
      | ATC            | M01A          | ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS |
      | ATC            | M01AE         | PROPIONIC ACID DERIVATIVES                        |
      | PRODUCT        | 010502 01 001 | CO-ADVIL                                          |
      | PRODUCTSYNONYM | 010502 01 015 | CHILDRENS ADVIL COLD                              |


@DFT
@PBMCC40159_001d
@ReleaseRave2013.2.0
@DTMCC68955
Scenario: A coding decision will be accepted by EDC for a verbatim that has data submitted via the Other Specify dropdown option
	Given a Rave project registration with dictionary "MedDRA ENG 11.0"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field                             | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
  	 | ETE17 | Log Dropdown Supplemental Field A | <Dictionary> | <Locale> | LLT         | 1        | true               | true           |			
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE17"
 	| Field                             | Value              | ControlType  |
 	| Log Dropdown Supplemental Field A | Other Option       | DropDownList |
 	| Log Dropdown Supplemental Field A | terrible head pain |              |
		And Coder App Segment is loaded
	When task "terrible head pain" is coded to term "headache" at search level "Lower Level Term" with code "10019211" at level "LLT" and a synonym is created
	And Rave Modules App Segment is loaded
	# the coding path needs to be updated in the table below
	Then the coding decision for verbatim "terrible head pain" on form "ETE17" for field "Log Dropdown Supplemental Field A" contains the following data
      | Level | Code     | Term Path                |
      | SOC   | 10029205 | Nervous system disorders |
      | HLGT  | 10019231 | Headaches                |
      | HLT   | 10019233 | Headaches NEC            |
      | PT    | 10019211 | Headache                 |
      | LLT   | 10019198 | Head pain                |