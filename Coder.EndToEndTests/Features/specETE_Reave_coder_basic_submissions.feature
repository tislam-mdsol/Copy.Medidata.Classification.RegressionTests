@specETE_Reave_coder_basic_submissions.feature

#@EndToEndDynamicSegment
#@EndToEndDynamicStudy
@EndToEndStaticSegment

Feature: Test full round trip integration from Rave to Coder.  New features converted from ETE_ENGRaveCoder_BasicSubmissions.feature from task MCC-208901


  @DFT
  @ETE_ENG_Rave_coder_basic_Sub
  #@PB1.1.2-001
  @Release2016.1.0
  Scenario: Basic Rave Coder Submission
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | 
      | ETE1 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | false          | 
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    When adding a new verbatim term to form "ETE1"
      | Field        | Value    | ControlType |
      | Coding Field | Headache | LongText    |
	Then the coding decision for verbatim "Headache" on form "ETE1" for field "Coding Field" contains the following data
      |Coding Level  |  Code    | Term                       |
      |SOC           | 10029205 | Nervous system disorders   |
      |HLGT          | 10019231 | Headaches                  |
      |HLT           | 10019233 | Headaches NEC              |
      |PT            | 10019211 | Headache                   |
      |LLT           | 10019198 | Head pain                  |


  @DFT
  @ETE_ENG_Rave_coder_basic_Sub_change_term
  #@PB1.1.2-002
  @Release2016.1.0
  Scenario:Basic Rave Coder Submission and change verbatim
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
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
	And a coding task "terrible head pain" returns to "Waiting Manual Code" status
    And modifying a verbatim term of the log line containing "terrible head pain" on form "ETE1"
	  | Field        | Value                 | ControlType |
	  | Coding Field | foot pain in left leg | LongText    |	
	Then the coding decision for verbatim "foot pain in left leg" on form "ETE1" for field "Coding Field" contains the following data
      | Level | Code     | Term Path                                            |
      | SOC   | 10018065 | General disorders and administration site conditions |
      | HLGT  | 10018073 | General system disorders NEC                         |
      | HLT   | 10008479 | Pain and discomfort NEC                              |
      | PT    | 10008479 | Chest pain                                           |
      | LLT   | 10019198 | Head pain                                            |


  @DFT
  @ETE_ENG_Rave_coder_basic_Sub_autocode
  #@PB1.1.2-003
  @Release2016.1.0
  Scenario:Basic Rave Coder Submission and submit same verbatim and autocode
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | false          |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE2"
      | Field                    | Value              | ControlType |
      | Coding Field             | terrible head pain | LongText    |
      | Log Supplemental Field A | ALPHA              |             |
    And Coder App Segment is loaded
    And task "terrible head pain" is coded to term "Head pain" at search level "Low Level Term" with code "10019198" at level "LLT" and a synonym is created
    And Rave Modules App Segment is loaded
	Then the coding decision on form "ETE2" for field "Coding Field" with row text "ALPHA" for verbatim "terrible head pain" contains the following data
      | Level | Code     | Term Path                |
      | SOC   | 10029205 | Nervous system disorders |
      | HLGT  | 10019231 | Headaches                |
      | HLT   | 10019233 | Headaches NEC            |
      | PT    | 10019211 | Headache                 |
      | LLT   | 10019198 | Head pain                |
    When adding a new verbatim term to form "ETE2"
      | Field                    | Value              | ControlType |
      | Coding Field             | terrible head pain | LongText    |
      | Log Supplemental Field A | BRAVO              |             |
	Then the coding decision on form "ETE2" for field "Coding Field" with row text "BRAVO" for verbatim "terrible head pain" contains the following data
      | Level | Code     | Term Path                |
      |SOC          |10029205 | Nervous system disorders   |
      |HLGT         |10019231 | Headaches                  |
      |HLT          |10019233 | Headaches NEC              |
      |PT           |10019211 | Headache                   |
      |LLT          |10019198 | Head pain                  |

  @DFT
  #@PB1.1.2-004
  @ETE_ENG_Rave_coder_basic_Sub_recon
  #@PB1.1.2-003
  @Release2016.1.0
  Scenario:Basic Rave Coder Submission and reconsider term and recode
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
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
    And task "terrible head pain" is coded to term "Head pain" at search level "Low Level Term" with code "10019198" at level "LLT" and a synonym is created
    And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "terrible head pain" on form "ETE1" for field "Coding Field" contains the following data
      | Level | Code     | Term Path                |
      | SOC   | 10029205 | Nervous system disorders |
      | HLGT  | 10019231 | Headaches                |
      | HLT   | 10019233 | Headaches NEC            |
      | PT    | 10019211 | Headache                 |
      | LLT   | 10019198 | Head pain                |
    When Coder App Segment is loaded
	And reclassifying and retiring synonym task "terrible head pain" with Include Autocoded Items set to "True"
	And rejecting coding decision for the task "terrible head pain"
	And task "terrible head pain" is coded to term "Biopsy skin" at search level "Low Level Term" with code "10004873" at level "LLT" and a synonym is created
    And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "terrible head pain" on form "ETE1" for field "Coding Field" contains the following data
      | Level | Code     | Term Path                      |
      | SOC   | 10022891 | Investigations                 |
      | HLGT  | 10040879 | Skin investigations            |
      | HLT   | 10040862 | Skin histopathology procedures |
      | PT    | 10004873 | Biopsy skin                    |
      | LLT   | 10004873 | Biopsy skin                    |


  @DFT
  #@PB1.1.2-005
  @MCC-207807
  @ETE_ENG_Rave_coder_basic_Sub_code_group
  Scenario:Basic Rave Coder Submission 2 terms that are in the same group
    Given a Rave project registration with dictionary "MedDRA ENG 11.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | false          |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE2"
      | Field                    | Value            | ControlType |
      | Coding Field             | raving head pain | LongText    |
      | Log Supplemental Field A | ALPHA            |             |
    And adding a new verbatim term to form "ETE2"
      | Field                    | Value            | ControlType |
      | Coding Field             | raving head pain | LongText    |
      | Log Supplemental Field A | BRAVO            |             |
    And Coder App Segment is loaded
	Then the coding task table has the following ordered information
      |Verbatim Term    | Group | Priority |
      |raving head pain |  2    |  1       |
    When task "raving head pain" is coded to term "Head pain" at search level "Low Level Term" with code "10019198" at level "LLT" and a synonym is created
    And Rave Modules App Segment is loaded
	Then the coding decision on form "ETE2" for field "Coding Field" with row text "ALPHA" for verbatim "terrible head pain" contains the following data
      | Level | Code     | Term Path                |
      |SOC          |10029205 | Nervous system disorders   |
      |HLGT         |10019231 | Headaches                  |
      |HLT          |10019233 | Headaches NEC              |
      |PT           |10019211 | Headache                   |
      |LLT          |10019198 | Head pain                  |
	Then the coding decision on form "ETE2" for field "Coding Field" with row text "BRAVO" for verbatim "terrible head pain" contains the following data
      | Level | Code     | Term Path                |
      |SOC          |10029205 | Nervous system disorders   |
      |HLGT         |10019231 | Headaches                  |
      |HLT          |10019233 | Headaches NEC              |
      |PT           |10019211 | Headache                   |
      |LLT          |10019198 | Head pain                  |