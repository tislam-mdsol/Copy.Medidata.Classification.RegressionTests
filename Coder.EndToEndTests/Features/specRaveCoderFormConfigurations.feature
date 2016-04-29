Feature: Test full round trip integration from Rave to Coder

  @DFT
  @ETE_ENG_Form_config_register_dictionaries
  @PB1.1.2-008
  @Release2016.1.0
  Scenario: Register 1 dictionary in Coder, verify Rave only shows 1 Coder dictionary, register another dictionary in Coder, verify there are now 2 dictionaries in Rave
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE5 | coderFieldETE5  | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |
    Then the Coding Dictionary Dropdown should "see" contain value "CODER-MEDRA"
    And the Coding Dictionary Dropdown should "not see" contain value "CODER- WhoDrugDDEB2"
    And Coder App Segment is loaded
    And I preform a Coder project registraion for "WhoDrugDDEB2 ENG 200703"
    And Rave Modules App Segment is loaded
    Then the Coding Dictionary Dropdown should "see" contain value "CODER-MEDRA"
    Then the Coding Dictionary Dropdown should "see" contain value "CODER- WhoDrugDDEB2"


  @DFT
  @ETE_ENG_Form_config_edit_checks_and_derivations
  @PB1.1.2-017
  @Release2016.1.0
  Scenario: Test that Edit checks and derivations both fire when a coding response is sent back to Rave from Coder
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form  | Field     | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE11 | AETERM    | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    When adding a new verbatim term to form "ETE11"
      | Field         | Value      | ControlType |
      | AdverseEvent1 | Headache   |             |
    And I note down memo "NowTimeStampBeforeCoding" with data from "Rave Log Table" in column "NOW"
    And I note down memo "TestTimeStampBeforeCoding" with data from "Rave Log Table" in column "Test"
    When I wait for text "Headaches NEC" to show up, selecting Rave form "ETE11" and link "Headache"
    And I note down memo "NowTimeStampAfterCoding" with data from "Rave Log Table" in column "NOW"
    And I note down memo "TestTimeStampAfterCoding" with data from "Rave Log Table" in column "Test"
    Then I verify datetime memo "<NowTimeStampAfterCoding>" is equal to memo "<NowTimeStampBeforeCoding>"
    And I verify datetime memo "<TestTimeStampAfterCoding>" is greater than memo "<TestTimeStampBeforeCoding>"


  @DFT
  @ETE_ENG_Form_config_second_tag_processing
  @PB1.1.2-018
  @Release2016.1.0
  Scenario: Verify setting up a second tag processing process does not affect Coder terms from being sent over and coded
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form  | Field   | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE13 | ETE131  | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |

    And Create Study Group Configuration form "New SG Config" with the following data
      |SG Mapping TextField  |SG Mapping Option |SG Mapping Form Dropdown |SG Mapping Folder Dropdown |SG Mappings CaseID Field Dropdown |SG Mappings TermHighlighted Field Dropdown|SG Dictinoary Mapping Dropdown 1|SG Dictinoary Mapping Dropdown 2                 |SG Dictinoary Mapping Dropdown 3            |
      |senderorganization    |log Line form     |ETE13                    |SG1                        |ETE131                            |ETE132                                    |N/A                             |Yes, highlighted by the reporter, NOT Serious, 1 |Yes, highlighted by the reporter, SERIOUS, 3|

    #And I enter value "SG Config <CoderRaveStudy>" in the "SG Configuration Name Textfield"
    #And I select Button "Create"
    #And I enter value "senderorganization" in the "SG Mapping Textfield"
    #And I select Button "Save"
    #And I select Tab "Reactions"
    #And I select Button "Add Form"
    #And I set value "log line in form" located in "SG Mapping Option Dropdown" and wait for "2"
    #And I set value "ETE13" located in "SG Mapping Form Dropdown" and wait for "2"
    #And I set value "SG1" located in "SG Mapping Folder Dropdown" and wait for "2"
    #And I set value "ETE131" located in "SG Mappings CaseID Field Dropdown" and wait for "2"
    #And I set value "ETE132" located in "SG Mappings TermHighlighted Field Dropdown" and wait for "2"
    #And I select Link "/Dictionary mappings/"
    #And I set value "N/A" located in "SG Dictinoary Mapping Dropdown 1" and wait for "2"
    #And I set value "Yes, highlighted by the reporter, NOT Serious, 1" located in "SG Dictinoary Mapping Dropdown 2" and wait for "2"
    #And I set value "Yes, highlighted by the reporter, SERIOUS, 3" located in "SG Dictinoary Mapping Dropdown 3" and wait for "2"
    #And I select Button "Save"

    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    When adding a new verbatim term to form "ETE13"
      | Field         | Value      | ControlType |
      | AdverseEvent1 | Headache   |             |
    Then the field "CoderField1" on form "ETE13" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level  |  Code    | Term                       |
      |SOC           | 10029205 | Nervous system disorders   |
      |HLGT          | 10019231 | Headaches                  |
      |HLT           | 10019233 | Headaches NEC              |
      |PT            | 10019211 | Headache                   |
      |LLT           | 10019198 | Head pain                  |


  @DFT
  @ETE_ENG_Form_config_char_limit
  @PB1.1.2-022
  @Release2016.1.0
  Scenario: Enter project registration in Coder, setup Rave study, enter verbatim with the limit of 450 characters in Rave, code verbatim in Coder, and see results in Rave
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE1 | Adverse Event 1 | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    When adding a new verbatim term to form "ETE1"
      | Field         | Value      																																																																																																														   | ControlType |
      | AdverseEvent1 | abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij   |             |
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST2" contains the following coding decision data
      |Coding Level |  Code   | Term                       |
      |SOC          |10029205 | Nervous system disorders   |
      |HLGT         |10019231 | Headaches                  |
      |HLT          |10019233 | Headaches NEC              |
      |PT           |10019211 | Headache                   |
      |LLT          |10019198 | Head pain                  |



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

