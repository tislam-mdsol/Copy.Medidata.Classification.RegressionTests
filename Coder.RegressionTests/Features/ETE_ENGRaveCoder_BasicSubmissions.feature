Feature: Test full round trip integration from Rave to Coder.  New features converted from ETE_ENGRaveCoder_BasicSubmissions.feature from task MCC-208901


  @DFT
  @ETE_ENG_Rave_coder_basic_Sub
  @PB1.1.2-001
  @Release2016.1.0
  Scenario: Basic Rave Coder Submission
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE1 | Adverse Event 1 | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Production"
    And adding a new subject "TEST"
    When adding a new verbatim term to form "ETE1"
      | Field         | Value      | ControlType |
      | AdverseEvent1 | Headache   |             |
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level  |  Code    | Term                       |
      |SOC           | 10029205 | Nervous system disorders   |
      |HLGT          | 10019231 | Headaches                  |
      |HLT           | 10019233 | Headaches NEC              |
      |PT            | 10019211 | Headache                   |
      |LLT           | 10019198 | Head pain                  |


  @DFT
  @ETE_ENG_Rave_coder_basic_Sub_change_term
  @PB1.1.2-002
  @Release2016.1.0
  Scenario:Basic Rave Coder Submission and change verbatim
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms  |
      | ETE1 | Adverse Event 1 | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                    |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Production"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field         | Value              | ControlType |
      | AdverseEvent1 | terrible head pain |             |
    And Coder App Segment is loaded
    And the coding task table has the following ordered information
      |Verbatim Term      |
      |terrible head pain |
    When I change verbatim "terrible head pain" to "foot pain in left leg" on form "ETE1" for "Subject"
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level |  Code   | Term                                                   |
      |SOC          |10018065 | General disorders and administration site conditions   |
      |HLGT         |10018073 | General system disorders NEC                           |
      |HLT          |10008479 | Pain and discomfort NEC                                |
      |PT           |10008479 | Chest pain                                             |
      |LLT          |10019198| Head pain                                               |

  @DFT
  @ETE_ENG_Rave_coder_basic_Sub_autocode
  @PB1.1.2-003
  @Release2016.1.0
  Scenario:Basic Rave Coder Submission and submit same verbatim and autocode
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE1 | Adverse Event 1 | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Production"
    And Coder App Segment is loaded
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field         | Value              | ControlType |
      | AdverseEvent1 | terrible head pain |             |
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level |  Code   | Term                       |
      |SOC          |10029205 | Nervous system disorders   |
      |HLGT         |10019231 | Headaches                  |
      |HLT          |10019233 | Headaches NEC              |
      |PT           |10019211 | Headache                   |
      |LLT          |10019198 | Head pain                  |
    And adding a new subject "TEST2"
    And adding a new verbatim term to form "ETE1"
      | Field         | Value              | ControlType | Control Value |
      | AdverseEvent1 | terrible head pain |             |               |
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST2" contains the following coding decision data
      |Coding Level |  Code   | Term                       |
      |SOC          |10029205 | Nervous system disorders   |
      |HLGT         |10019231 | Headaches                  |
      |HLT          |10019233 | Headaches NEC              |
      |PT           |10019211 | Headache                   |
      |LLT          |10019198 | Head pain                  |

  @DFT
  @PB1.1.2-004
  @ETE_ENG_Rave_coder_basic_Sub_recon
  @PB1.1.2-003
  @Release2016.1.0
  Scenario:Basic Rave Coder Submission and reconsider term and recode
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE1 | Adverse Event 1 | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Production"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field         | Value              | ControlType |
      | AdverseEvent1 | terrible head pain |             |
    And Coder App Segment is loaded
    And I browse and code task "terrible head pain" entering value "Headache" and selecting "Headache" located in Dictionary Tree Table
    And I navigate to Rave App form
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level |  Code   | Term                       |
      |SOC          |10029205 | Nervous system disorders   |
      |HLGT         |10019231 | Headaches                  |
      |HLT          |10019233 | Headaches NEC              |
      |PT           |10019211 | Headache                   |
      |LLT          |10019198 | Head pain                  |
    And Coder App Segment is loaded
    And I reclassify and retire term "terrible head pain" entering value "Reclassifying to test message" in the comment text area
    And I reject the coding decision for term "terrible head pain"
    And I browse and code task "terrible head pain" entering value "Biopsy skin" and selecting "Biopsy skin" located in Dictionary Tree Table
    And I navigate to Rave App form
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level |  Code    | Term                           |
      |SOC          | 10022891 | Investigations                 |
      |HLGT         | 10040879 | Skin investigations            |
      |HLT          | 10040862 | Skin histopathology procedures |
      |PT           | 10004873 | Biopsy skin                    |
      |LLT          | 10019198 | Head pain                      |


  @DFT
  @PB1.1.2-005
  @MCC-207807
  @ETE_ENG_Rave_coder_basic_Sub_code group
  Scenario:Basic Rave Coder Submission 2 terms that are in the same group
    Given a Rave project registration with dictionary "MedDRA ENG 11.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms  |
      | ETE9 | CoderFieldETE9  | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                    |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Production"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field         | Value             | ControlType |
      | CoderField9   | raving head pain  |             |
    And adding a new subject "TEST2"
    And adding a new verbatim term to form "ETE1"
      | Field         | Value            | ControlType |
      | AdverseEvent1 | raving head pain |             |
    And Coder App Segment is loaded
    And the coding task table has the following ordered information
      |Verbatim Term    | Group | Priority |
      |raving head pain |  2    |  1       |
    And I browse and code task "terrible head pain" entering value "Headache" and selecting "Headache" located in Dictionary Tree Table
    And I navigate to Rave App form
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level |  Code    | Term                      |
      |SOC          | 10029205 | Nervous system disorders  |
      |HLGT         | 10019231 | Headaches                 |
      |HLT          | 10019233 | Headaches NEC             |
      |PT           | 10019211 | Headache                  |
      |LLT          | 10019198 | Head pain                 |
    Then the field "CoderField1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST2" contains the following coding decision data
      |Coding Level |  Code    | Term                      |
      |SOC          | 10029205 | Nervous system disorders  |
      |HLGT         | 10019231 | Headaches                 |
      |HLT          | 10019233 | Headaches NEC             |
      |PT           | 10019211 | Headache                  |
      |LLT          | 10019198 | Head pain                 |