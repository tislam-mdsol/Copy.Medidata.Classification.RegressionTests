

#@EndToEndDynamicSegment
#@EndToEndDynamicStudy
@EndToEndStaticSegment

Feature: Verify using Search List combinations of standard fields, log line fields, search list, etc. for coding fields & supplement and component values is fully supported and the around trip integration works successfully.

@DFT
@PB92926SL-001
@Release2016.1.0
Scenario: Log line verbatim fields using a control type of Search List will be successfully coded 1
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field                        | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | 
  	 | ETE19 | Log Search List Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | true               | true           | 
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
@PB92926SL-002
@Release2016.1.0
Scenario: Standard verbatim fields using a control type of Search List will be successfully coded 2
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field                    | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | 
  	 | ETE19 | Search List Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | true               | true           | 
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field              	| Value 					  	| ControlType       |
	| Search List	      	| child advil cold extreme 		| SearchList        |
	And Coder App Segment is loaded
	And task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	And Rave Modules App Segment is loaded
	# the coding path needs to be updated in the table below
	Then the coding decision for verbatim "child advil cold extreme" on form "ETE19" for field "Search List Coding Field" contains the following data
      | Level | Code     | Term Path                |
      | SOC   | 10029205 | Nervous system disorders |
      | HLGT  | 10019231 | Headaches                |
      | HLT   | 10019233 | Headaches NEC            |
      | PT    | 10019211 | Headache                 |
      | LLT   | 10019198 | Head pain                |

@DFT
@PB92926SL-004
@Release2016.1.0
Scenario: Standard verbatim and supplemental fields using a control type of Search List will be successfully coded 3
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field                    | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms  |
  	 | ETE19 | Search List Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | true               | true           | Std Searchlist Sup |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field                            | Value                    | ControlType |
 	| Search List Coding Field         | child advil cold extreme | SearchList  |
 	| Search List Supplemental Field B | No                       | SearchList  |
	And Coder App Segment is loaded
	Then the "child advil cold extreme" task has the following supplemental information
	| Term                             | Value |
	| Search List Supplemental Field B | No    |
	When task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	And Rave Modules App Segment is loaded
	# the coding path needs to be updated in the table below
	Then the coding decision for verbatim "child advil cold extreme" on form "ETE19" for field "Search List Coding Field" contains the following data
      | Level | Code     | Term Path                |
      | SOC   | 10029205 | Nervous system disorders |
      | HLGT  | 10019231 | Headaches                |
      | HLT   | 10019233 | Headaches NEC            |
      | PT    | 10019211 | Headache                 |
      | LLT   | 10019198 | Head pain                |

@DFT
@PB92926SL-008
@Release2016.1.0
Scenario: Log line verbatim and  supplement fields using a control type of Search List will be successfully coded. 
	Given a Rave project registration with dictionary "WhoDrugDDEB2 ENG 200703"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form  | Field            | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE19 | Log Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | true               | true           | LL SL Sup         |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<StudyName>" to environment "Prod"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE19"
 	| Field                                | Value                    | ControlType |
 	| Log Coding Field                     | child advil cold extreme | SearchList  |
 	| Log Search List Supplemental Field B | No                       | SearchList  |
	And Coder App Segment is loaded
	Then the "child advil cold extreme" task has the following supplemental information
	| Term                                 | Value |
	| Log Search List Supplemental Field B | No    |
	When task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Preferred Name" with code "010502 01 015 9" at level "PN" and a synonym is created
	And Rave Modules App Segment is loaded
	# the coding path needs to be updated in the table below
	Then the coding decision for verbatim "child advil cold extreme" on form "ETE19" for field "Log Coding Field" contains the following data
      | Level | Code     | Term Path                |
      | SOC   | 10029205 | Nervous system disorders |
      | HLGT  | 10019231 | Headaches                |
      | HLT   | 10019233 | Headaches NEC            |
      | PT    | 10019211 | Headache                 |
      | LLT   | 10019198 | Head pain                |
