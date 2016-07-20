@specRaveCoderFormConfigurations.feature
@EndToEndDynamicSegment
Feature: Test full round trip integration from Rave to Coder



  @DFT
  @ETE_ENG_Form_config_char_limit
  @PB1.1.2-022
  @Release2016.1.0
  Scenario: Enter project registration in Coder, setup Rave study, enter verbatim with the limit of 450 characters in Rave, code verbatim in Coder, and see results in Rave
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE1 | Adverse Event 1 | <Dictionary> | <Locale> | LLT            | 1        | false              | false          |                              |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    When adding a new verbatim term to form "ETE1"
      | Field         | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                             | ControlType |
      | AdverseEvent1 | This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters........|             |
	And Coder App Segment is loaded
    And task "This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters. This string contains 450 characters........" is coded to term "Head Pain" at search level "Low Level Term" with code "10019198" at level "LLT" and a synonym is created
    And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "Headache" on form "ETE1" for field "Coding Field" contains the following data
      | Level | Code     | Term Path                |
      | SOC   | 10029205 | Nervous system disorders |
      | HLGT  | 10019231 | Headaches                |
      | HLT   | 10019233 | Headaches NEC            |
      | PT    | 10019211 | Headache                 |
      | LLT   | 10019198 | Head pain                |


  @DFT
  @ETE_ENG_Form_config_repeat_parent_folders
  @PB1.1.2-024
  @Release2016.1.0
  Scenario: Verify that when you have more than 10 instances of a repeat parent folder, terms are still able to be sent to Coder from Rave and Rave is still able to receive both coding decisions and rejects from Coder.
  Scenario:Basic Rave Coder Submission and reconsider term and recode
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE1 | Adverse Event 1 | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST" with "10" added "ParentRepeat" events
    And adding a new verbatim term to form "ETE1" for "ParentRepeat (1)"
      | Field         | Value                | ControlType |
      | AdverseEvent1 | terrible head pain 1 |             |
    And adding a new verbatim term to form "ETE1" for "ParentRepeat (4)"
      | Field         | Value                | ControlType |
      | AdverseEvent1 | terrible head pain 4 |             |
    And adding a new verbatim term to form "ETE1" for "ParentRepeat (6)"
      | Field         | Value                | ControlType |
      | AdverseEvent1 | terrible head pain 6 |             |
    And adding a new verbatim term to form "ETE1" for "ParentRepeat (8)"
      | Field         | Value                | ControlType |
      | AdverseEvent1 | terrible head pain 8 |             |
    Then on field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" for "ParentRepeat (3)" I submit a query with the following data
      |query                               |
      |Rejecting Decision due to bad term  |
    And Coder App Segment is loaded
    And With data below, I browse and code Term "<value1>" located in "Coder Main Table" on row "1", entering value "<text>" and selecting "<value2>" located in "Dictionary Tree Table"
      |value1			     |text               |value2            |
      |terrible head pain 4  |headache           |Headache          |
      |terrible head pain 6  |Basilar migraine   |Basilar migraine  |
      |terrible head pain 8  |migraine           |Migraine          |
    And I navigate to Rave App form
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" for "ParentRepeat (4)" contains the following coding decision data
      |Coding Level |  Code    | Term                       |
      |PT           | 10019211 | Headache                   |
      |HLT          |10019233  |Headaches NEC               |
      |HLGT         |10019231  |Headaches                   |
      |SOC          |10029205  |Nervous system disorders    |
      |LLT          |          |                            |
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" for "ParentRepeat (6)" contains the following coding decision data
      |Coding Level |  Code    | Term                       |
      |PT           |10050258  |Basilar migraine            |
      |HLT          |10027603  |Migraine headaches          |
      |HLGT         |10019231  |Headaches                   |
      |SOC          |10029205  |Nervous system disorders    |
      |LLT          |          |                            |
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" for "ParentRepeat (8)" contains the following coding decision data
      |Coding Level |  Code    | Term                       |
      |PT           |10027599  | Migraine                   |
      |HLT          |10027603  |Migraine headaches          |
      |HLGT         |10019231  |Headaches                   |
      |SOC          |10029205  |Nervous system disorders    |
      |LLT          |          |                            |
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" for "ParentRepeat (3)" contains the following coding decision data
      |querytext                                    |
      |Rejecting Decision due to bad term           |


  @MCC-207807
  @ETE_ENG_Form_config
  Scenario: Verify that after submitting a blank log line on an auto-coded term displays no data and when resubmitting an auto-coded term that the coded decision appears
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE1 | Adverse Event 1 | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field         | Value     | ControlType |
      | AdverseEvent1 | headache  |             |
    Then the field "CoderField1" on form "ETE13" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level  |  Code    | Term                       |
      |SOC           | 10029205 | Nervous system disorders   |
      |HLGT          | 10019231 | Headaches                  |
      |HLT           | 10019233 | Headaches NEC              |
      |PT            | 10019211 | Headache                   |
      |LLT           | 10019198 | Head pain                  |
    And I edit verbatim "terrible head pain " on form "ETE1" for study "<Study>" site "<Site>" subject "TEST"
      | Field         | Value    | ControlType |
      | ETE3          |          |             |
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level |  Code     | Term         |
      |             |           |         |
    And I edit verbatim "terrible head pain " on form "ETE1" for study "<Study>" site "<Site>" subject "TEST"
      | Field           | Value    | ControlType |
      | Adverse Event 1 |headache  |             |
    Then the field "CoderField1" on form "ETE13" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level  |  Code    | Term                       |
      |SOC           | 10029205 | Nervous system disorders   |
      |HLGT          | 10019231 | Headaches                  |
      |HLT           | 10019233 | Headaches NEC              |
      |PT            | 10019211 | Headache                   |
      |LLT           | 10019198 | Head pain                  |

