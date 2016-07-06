@specETE_UpdatingQueriesResendTermsBackToCoder.feature

@EndToEndDynamicSegment
Feature: When a Coder query is answered or cancelled, the verbatim will be resent to Coder.

  @VAL
  @ETE_ENG_updated_query_answer_query
  @PB3.3.3_006
  @Release2016.1.0
  Scenario: When a Coder query is answered and the verbatim is not updated, the verbatim is resent to Coder
   
   Given a Rave project registration with dictionary "MedDRA ENG 11.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE1 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | false          |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field        | Value              | ControlType |
      | Coding Field | terrible head pain | LongText    |
    And Coder App Segment is loaded
	And I open a query for task "terrible head pain" with comment "Open query due to bad term"
	And a coding task "terrible head pain" returns to "Open" query status
    And Rave Modules App Segment is loaded
	And the coder query to the Rave form "ETE1" field "Coding Field" with verbatim term "terrible head pain" is responded to with "Answered Response"
	And Coder App Segment is loaded
	And a coding task "terrible head pain" returns to "Closed" query status
	And task "terrible head pain" is coded to term "Head pain" at search level "Low Level Term" with code "10019198" at level "LLT" and a synonym is created
	And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "terrible head pain" on form "ETE1" for field "Coding Field" contains the following data
      | Level | Code     | Term Path                |
      | SOC   | 10029205 | Nervous system disorders |
      | HLGT  | 10019231 | Headaches                |
      | HLT   | 10019233 | Headaches NEC            |
      | PT    | 10019211 | Headache                 |
      | LLT   | 10019198 | Head pain                |


  @DFT
  @ETE_ENG_updated_query_cancel_query
  @PB3.3.3-004
  @Release2016.1.0
  Scenario: When a Coder query is cancelled and the verbatim is not updated, the verbatim is resent to Coder
    
	Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE1 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | true               | false          |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field        | Value              | ControlType |
      | Coding Field | terrible head pain | LongText    |
    And Coder App Segment is loaded
	And I open a query for task "terrible head pain" with comment "Rejecting Decision due to bad term"
	And a coding task "terrible head pain" returns to "Open" query status
	And Rave Modules App Segment is loaded
	And the coder query to the Rave form "ETE1" field "Coding Field" with verbatim term ""terrible head pain" is canceled
    And Coder App Segment is loaded
	And a coding task "terrible head pain" returns to "Cancelled" query status
	And task "terrible head pain" is coded to term "Head pain" at search level "Low Level Term" with code "10019198" at level "LLT" and a synonym is created
	And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "terrible head pain" on form "ETE1" for field "Coding Field" contains the following data
      | Level | Code     | Term Path                |
      | SOC   | 10029205 | Nervous system disorders |
      | HLGT  | 10019231 | Headaches                |
      | HLT   | 10019233 | Headaches NEC            |
      | PT    | 10019211 | Headache                 |
      | LLT   | 10019198 | Head pain                |



  @DFT
  @ETE_ENG_updated_query_answer_query_view_term_in_coder
  @PB3.3.3-005
  @Release2016.1.0
  Scenario: Verify a Coder query is answered and the verbatim is updated, the updated verbatim is resent to Coder
  # This test does not match the description. It is canceling the query, then answering it, which is not possible in Rave. (Can be done 
  # as a single action, but cancel appears to override the comment).

  #I believe the test should be similar to PB3.3.3-006 below.

    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE1 | Adverse Event 1 | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field         | Value              | ControlType |
      | AdverseEvent1 | terrible head pain |             |
    And Coder App Segment is loaded
    Then I submit coder query "Rejecting Decision due to bad term" for task "terrible head pain"
    Then I should see the query status "open" for task "terrible head pain"
    And I navigate to Rave App form
    And I cancel query for term "terrible head pain" on form "ETE1" for "Subject"
    And answer query for form "ETE1" for "Subject" with value "Answered Query."
    And Coder App Segment is loaded
    And I browse and code task "terrible head pain" entering value "head pain" and selecting "Headaches" located in Dictionary Tree Table
    And I navigate to Rave App form
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level |  Code   | Term                       |
      |SOC          |10029205 | Nervous system disorders   |
      |HLGT         |10019231 | Headaches                  |
      |HLT          |10019233 | Headaches NEC              |
      |PT           |10019211 | Headache                   |
      |LLT          |10019198 | Head pain                  |

  @DFT
  @ETE_ENG_updated_query_change_term
  @PB3.3.3-006
  @Release2016.1.0
  Scenario: When a Coder query is cancelled and the verbatim is updated, the updated verbatim is resent to Coder

  	Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE1 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | true               | false          |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field        | Value              | ControlType |
      | Coding Field | terrible head pain | LongText    |
    And Coder App Segment is loaded
	And I open a query for task "terrible head pain" with comment "Rejecting Decision due to bad term"
	And a coding task "terrible head pain" returns to "Open" query status
	And Rave Modules App Segment is loaded
	And the coder query to the Rave form "ETE1" field "Coding Field" with verbatim term "terrible head pain" is canceled
	And modifying a verbatim term of the log line containing "terrible head pain" on form "ETE1"
	| Field        | Value         | ControlType |
	| Coding Field | bad head pain | LongText    |
    And Coder App Segment is loaded
	And a coding task "bad head pain" returns to "Closed" query status
	Then the coding task table has the following ordered information
      | Verbatim Term | Queries |
      | bad head pain | Closed  |