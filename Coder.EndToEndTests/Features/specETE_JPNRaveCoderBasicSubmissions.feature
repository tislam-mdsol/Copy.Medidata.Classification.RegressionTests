@specETE_JPN_Rave_coder_basic_submissions.feature

@EndToEndDynamicSegment

Feature: Test the full round trip integration from Rave to Coder back to Rave for Japanese

  @VAL
  @ETE_JPN_Rave_coder_basic_sub
  @PB1.1.2.001J
  @Release2016.1.0
  Scenario: Enter a verbatim Term in Rave EDC, code the term in Coder and see coding decision is displayed correctly in Rave EDC
    Given a Rave project registration with dictionary "MedDRA JPN 11.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE1 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | false          |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    When adding a new subject "TEST"
    When adding a new verbatim term to form "ETE1"
      | Field        | Value | ControlType |
      | Coding Field | 頭痛 | LongText    |
   Then the coding decision for verbatim "頭痛" on form "ETE1" for field "Coding Field" contains the following data
      | Level | Code     | Term Path |
      | SOC   | 10029205 | 神経系障害     |
      | HLGT  | 10019231 | 頭痛        |
      | HLT   | 10019233 | 頭痛ＮＥＣ     |
      | PT    | 10019211 | 頭痛        |
      | LLT   | 10019211 | 頭痛        |


  @DFT
  @ETE_JPN_Rave_coder_basic_sub_with_supp
  @PB1.1.2.002J
  @Release2016.1.0
  Scenario: Setup Rave study with supplemental fields, enter verbatims in Rave, reject 1 verbatim and code the other in Coder, verify supplemental data appears in Coder, and Query and Coding results in Rave

    Given a Rave project registration with dictionary "JDrug JPN 2011H2"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE2 | Coding Field | <Dictionary> | <Locale> | DrugName    | 1        | true               | True           | LOGSUPPFIELD2, LOGCOMPFIELD1 |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE2"
      | Field                    | Value             | ControlType |
      | Coding Field             | 足の下に鋭い痛み   | LongText    |
      | Log Supplemental Field A | 33                |             |
      | Log Supplemental Field B | ニュージャージー州 |             |
    And adding a new verbatim term to form "ETE2"
      | Field                    | Value         | ControlType |
      | Coding Field             | 神経の鋭い痛み | LongText    |
      | Log Supplemental Field A | 22            |             |
      | Log Supplemental Field B | ニューヨーク   |             |
    And Coder App Segment is loaded
    When I view task "足の下に鋭い痛み"
    Then I verify the following Supplemental information is displayed
      | Supplemental Term  | Supplemental Value |
      | ETE2.LOGSUPPFIELD2 | ニュージャージー州  |
      | ETE2.LOGCOMPFIELD1 | 33                 |
    When I open a query for task "神経の鋭い痛み" with comment "悪い言葉による拒絶決定"
    And I view task "神経の鋭い痛み"
    Then I verify the following Supplemental information is displayed
      | Supplemental Term  | Supplemental Value |
      | ETE2.LOGSUPPFIELD2 | ニューヨーク        |
      | ETE2.LOGCOMPFIELD1 | 22                 |
    When task "足の下に鋭い痛み" is coded to term "抗Ｄグロブリン" at search level "Drug Name" with code "634340701" at level "Drug Name" and a synonym is created
	And downloading the Synonym List to "DownloadedSynonymListFile.txt"
    Then synonym list "DownloadedSynonymListFile.txt" should contain the following information
      | Verbatim        | Code      | Level    | Path                                                                                                                                  | Primary Flag | Supplemental Info                       | Status                                                  |
      | 足の下に鋭い痛み | 634340701 | DrugName | DrugName:634340701;Category:6343407 注 4;PreferredName:6343407;DetailedClass:6343;LowLevelClass:634;MidLevelClass:63;HighLevelClass:6 | False        | Classification:33;Reserve:コンポーネント | LOGSUPPFIELD2:ニュージャージー州;LOGSUPPFIELD4:翻訳で失わ |
    When Rave Modules App Segment is loaded
    Then the coder query "悪い言葉による拒絶決定" is available to the Rave form "ETE2" field "Coding Field" with verbatim term "神経の鋭い痛み"
	And the coding decision on form "ETE2" for field "Coding Field" with row text "足の下に鋭い痛み" for verbatim "足の下に鋭い痛み" contains the following data
      | Level                     | Code      | Term Path                        |
      | Category                  | 4         | 注                               |
      | English Name              | 634340701 | ANTI-D GLOBULIN                  |
      | High-Level Classification | 6         | 病原生物に対する医薬品             |
      | Mid-Level Classification  | 63        | 生物学的製剤                      |
      | Low-Level Classification  | 634       | 血液製剤類                        |
      | Detailed Classification   | 6463      | 血漿分画製剤                      |
      | Preferred Name            | 6343407   | 乾燥抗Ｄ（Ｒｈｏ）人免疫グロブリン |
      | Drug Name                 | 634340701 | 抗Ｄグロブリン                    |




  @VAL
  @ETE_JPN_Rave_coder_basic_sub_change_verbatim
  @PB1.1.2.003J
  @Release2016.1.0
  Scenario: Setup a Rave study, enter a verbatim in Rave, change verbatim in Rave, code updated verbatim in Coder, verify in Rave decision displays in Rave
    Given a Rave project registration with dictionary "MedDRA JPN 11.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE3 | Coding Field | <Dictionary> | <Locale> | PT         | 1        | false              | false          |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE3"
      | Field        | Value | ControlType |
      | Coding Field | ひどい頭痛 |             |
     And Coder App Segment is loaded
	And a coding task "ひどい頭痛" returns to "Waiting Manual Code" status
	And Rave Modules App Segment is loaded
    And modifying a verbatim term of the log line containing "ひどい頭痛" on form "ETE3"
      | Field        | Value   | ControlType |
      | Coding Field | 左脚の足の痛み |             |
	And Coder App Segment is loaded
    And task "左脚の足の痛み" is coded to term "片側頭痛" at search level "Preferred Term" with code "10067040" at level "PT" and a synonym is created
    And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "左脚の足の痛み" on form "ETE3" for field "Coding Field" contains the following data
      | Level | Code     | Term Path |
      | SOC   | 10029205 | 神経系障害     |
      | HLGT  | 10019231 | 頭痛        |
      | HLT   | 10019233 | 頭痛ＮＥＣ     |
      | PT    | 10067040 | 片側頭痛      |



  @VAL
  @ETE_ENG_Rave_coder_basic_Sub_autocode
  @PB1.1.2.004J
  @Release2016.1.0
  Scenario: Basic Rave Coder Submission and submit same verbatim and autocode
  Given a Rave project registration with dictionary "MedDRA JPN 11.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | false          |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE2"
      | Field                    | Value   | ControlType |
      | Coding Field             | 左脚の足の痛み | LongText    |
      | Log Supplemental Field A | ALPHA   |             |
    And Coder App Segment is loaded
    And task "左脚の足の痛み" is coded to term "頭痛" at search level "Low Level Term" with code "10019211" at level "LLT" and a synonym is created
    And Rave Modules App Segment is loaded
	Then the coding decision on form "ETE2" for field "Coding Field" with row text "ALPHA" for verbatim "左脚の足の痛み" contains the following data
      | Level | Code     | Term Path |
      | SOC   | 10029205 | 神経系障害     |
      | HLGT  | 10019231 | 頭痛        |
      | HLT   | 10019233 | 頭痛ＮＥＣ     |
      | PT    | 10019211 | 頭痛        |
      | LLT   | 10019211 | 頭痛        |
    When adding a new verbatim term to form "ETE2"
      | Field                    | Value   | ControlType |
      | Coding Field             | 左脚の足の痛み | LongText    |
      | Log Supplemental Field A | BRAVO   |             |
	Then the coding decision on form "ETE2" for field "Coding Field" with row text "BRAVO" for verbatim "左脚の足の痛み" contains the following data
      | Level | Code     | Term Path |
      | SOC   | 10029205 | 神経系障害     |
      | HLGT  | 10019231 | 頭痛        |
      | HLT   | 10019233 | 頭痛ＮＥＣ     |
      | PT    | 10019211 | 頭痛        |
      | LLT   | 10019211 | 頭痛        |

  @DFT
  @ETE_JPN_Rave_coder_basic_up_version
  @PB1.1.2.005J
  @Release2016.1.0
  Scenario: Setup Rave study, enter verbatim in Rave, code verbatim in Coder and create synonym rule, complete the up-versioning process, enter verbatim term again in Rave, verify term gets autocoded and results display in Rave
    Given a Rave project registration with dictionary "MedDRA JPN 11.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE1 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | false          |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field                    | Value   | ControlType |
      | Coding Field             | 左脚の足の痛み | LongText    |
    And Coder App Segment is loaded
	And task "左脚の足の痛み" is coded to term "頭痛" at search level "Low Level Term" with code "10019211" at level "LLT" and a synonym is created
    And I perform a synonym migration accepting the reconciliation suggestion for the synonym "左脚の足の痛み" under the category "Primary"
    When performing Study Impact Analysis
    And Rave Modules App Segment is loaded
	Then the coding decision on form "ETE2" for field "Coding Field" with row text "ALPHA" for verbatim "左脚の足の痛み" contains the following data
      | Level | Code     | Term Path |
      | SOC   | 10029205 | 神経系障害     |
      | HLGT  | 10019231 | 頭痛        |
      | HLT   | 10019233 | 頭痛ＮＥＣ     |
      | PT    | 10019211 | 頭痛        |
      | LLT   | 10019211 | 頭痛        |


  @VAL
  @ETE_JPN_Rave_coder_reconsider_verbatim
  @PB1.1.2.006J
  @Release2016.1.0
  Scenario: Setup Rave study, enter verbatim in Rave, code verbatim in Coder, verify results in Rave, reconsider verbatim in Coder and recode it to different term, verify updated results in Rave
    Given a Rave project registration with dictionary "MedDRA JPN 11.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE1 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | false          |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field        | Value | ControlType |
      | Coding Field | ひどい頭痛 | LongText    |
    And Coder App Segment is loaded
    And task "ひどい頭痛" is coded to term "頭痛" at search level "Low Level Term" with code "10019211" at level "LLT" and a synonym is created
    And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "ひどい頭痛" on form "ETE1" for field "Coding Field" contains the following data
      | Level | Code     | Term Path |
      | SOC   | 10029205 | 神経系障害     |
      | HLGT  | 10019231 | 頭痛        |
      | HLT   | 10019233 | 頭痛ＮＥＣ     |
      | PT    | 10019211 | 頭痛        |
      | LLT   | 10019211 | 頭痛        |
    When Coder App Segment is loaded
	And reclassifying and retiring synonym task "ひどい頭痛" with Include Autocoded Items set to "True"
	And rejecting coding decision for the task "ひどい頭痛"
	And task "ひどい頭痛" is coded to term "片側頭痛" at search level "Low Level Term" with code "10067040" at level "LLT" and a synonym is created
    And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "ひどい頭痛" on form "ETE1" for field "Coding Field" contains the following data
      | Level | Code     | Term Path |
      | SOC   | 10029205 | 神経系障害     |
      | HLGT  | 10019231 | 頭痛        |
      | HLT   | 10019233 | 頭痛ＮＥＣ     |
      | PT    | 10067040 | 片側頭痛      |
      | LLT   | 10067040 | 片側頭痛      |
















