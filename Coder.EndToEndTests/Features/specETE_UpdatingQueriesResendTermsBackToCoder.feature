Feature: When a Coder query is answered or cancelled, the verbatim will be resent to Coder.

  @DFT
  @ETE_ENG_updated_query_answer_query
  @PB3.3.3-006
  @Release2016.1.0
  Scenario: When a Coder query is answered and the verbatim is not updated, the verbatim is resent to Coder
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
    Then I submit coder query "Open query due to bad term" for task "terrible head pain"
    Then I should see the query status "open" for task "terrible head pain"
    And I navigate to Rave App form
    And I Answer query for form "ETE1" for "Subject" with value "Answered"
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
  @ETE_ENG_updated_query_cancel_query
  @PB3.3.3-004
  @Release2016.1.0
  Scenario: When a Coder query is cancelled and the verbatim is not updated, the verbatim is resent to Coder
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
  @ETE_ENG_updated_query_answer_query_view_term_in_coder
  @PB3.3.3-005
  @Release2016.1.0
  Scenario: Verify a Coder query is answered and the verbatim is updated, the updated verbatim is resent to Coder
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
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE1 | Adverse Event 1 | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field         | Value              | ControlType |
      | AdverseEvent1 | terrible head pain |             |
    And Coder App Segment is loaded
    Then I submit coder query "Rejecting Decision due to bad term" for task "head pain"
    Then I should see the query status "open" for task "terrible head pain"
    And I navigate to Rave App form
    And I cancel query for term "terrible head pain" on form "ETE1" for "Subject"
    When I change verbatim "terrible head pain" to "bad head pain" on form "ETE1" for "Subject"
    And Coder App Segment is loaded
    Then I should see task "bad head pain" in coder table
