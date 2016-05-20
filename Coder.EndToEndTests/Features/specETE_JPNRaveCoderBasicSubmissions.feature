@specETE_JPN_Rave_coder_basic_submissions.feature

@EndToEndDynamicSegment

Feature: Test the full round trip integration from Rave to Coder back to Rave for Japanese

  @DFT
  @ETE_JPN_Rave_coder_basic_sub
  @PB1.1.2.001J
  @Release2016.1.0
  Scenario: Enter a verbatim Term in Rave EDC, code the term in Coder and see coding decision is displayed correctly in Rave EDC
    Given a Rave project registration with dictionary "MedDRA JPN 11.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
      | ETE1 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | true               | true           |                   |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    When adding a new subject "TEST"
    When adding a new verbatim term to form "ETE1"
      | Field        | Value | ControlType |
      | Coding Field | 頭痛 | LongText    |
   Then the coding decision for verbatim "頭痛" on form "ETE1" for field "Coding Field" contains the following data
      | Coding Level | Code     | Term  |
      | SOC          | 10029205 | 神経系障害 |
      | HLGT         | 10019231 | 頭痛    |
      | HLT          | 10019233 | 頭痛ＮＥＣ |
      | PT           | 10019211 | 頭痛    |
      | LLT          | 10019211 | 頭痛    |


  @DFT
  @ETE_JPN_Rave_coder_basic_sub_with_supp
  @PB1.1.2-002J
  @Release2016.1.0
  Scenario: Setup Rave study with supplemental fields, enter verbatims in Rave, reject 1 verbatim and code the other in Coder, verify supplemental data appears in Coder, and Query and Coding results in Rave

    Given a Rave project registration with dictionary "J-Drug JPN 2011H2"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field   | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE2 | ETE2    | <Dictionary> | <Locale> | LLT            | 1        | true               | True          | LOGSUPPFIELD2, LOGSUPPFIELD4 |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE2"
      | Field         | Value            | ControlType |
      | ETE2          | 足の下に鋭い痛み   |             |
      | supplemental1 | 33               |other           |
      | Supplemental2 | ニュージャージー州 | radio            |
    And adding a new verbatim term to form "ETE2"
      | Field         | Value           | ControlType |
      | ETE2          | 神経の鋭い痛み    |             |
      | supplemental1 | 22              |other           |
      | Supplemental2 | ニューヨーク      | radio            |
    And Coder App Segment is loaded
    When I view task "足の下に鋭い痛み"
    Then I verify the following Component information is displayed
      | Supplemental Term    | Supplemental Value  |
      | ETE2.LOGSUPPFIELD2   | ニュージャージー州    |
      | ETE2.LOGSUPPFIELD4   | 翻訳で失わ           |
    When I view task "足の下に鋭い痛み"
    Then I verify the following Component information is displayed
    And in Coder I verify the Supplemental data for "足の下に鋭い痛み"
      | Supplemental Term    | Supplemental Value  |
      |ETE2.LOGSUPPFIELD2    |ニューヨーク           |
      |ETE2.LOGSUPPFIELD4    |翻訳で失わ  |
    And I open a query for new task "神経の鋭い痛み" with comment "悪い言葉による拒絶決定"
    And I browse and code task "足の下に鋭い痛み" entering value "抗Ｄグロブリン" and selecting "抗Ｄグロブリン" located in Dictionary Tree Table
    And I download the synonym list for "J-Drug 2011H2 JPN" and name it "SynonymListj2.txt"
    Then in "SynonymListj2.txt" I should the following
      | Verbatim | Code      | Level    | Path                                                                                                                                 | Primary Flag | Supplemental Info                 | Status                                      |
      | 足の下に鋭い痛み | 634340701 | DrugName | DrugName:634340701;Category:6343407 注 4;PreferredName:6343407;DetailedClass:6343;LowLevelClass:634;MidLevelClass:63;HighLevelClass:6 | False        | Classification:33;Reserve:コンポーネント | LOGSUPPFIELD2:ニュージャージー州;LOGSUPPFIELD4:翻訳で失わ |
    And I navigate to Rave App form
    Then the field on form "ETE2" for study "<Study>" site "<Site>" subject "TEST" I should see the rave query icon for term "神経の鋭い痛み"
    Then the field "ETE2" on form "ETE2" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level              |  Code     | Term                            |
      |Category                  | 4         |注                                |
      |English Name              | 634340701 |ANTI-D GLOBULIN                   |
      |High-Level Classification |   6       | 病原生物に対する医薬品              |
      |Mid-Level Classification  |   63      |生物学的製剤                        |
      |Low-Level Classification  |634        | 血液製剤類                         |
      |Detailed Classification   |6463       |    血漿分画製剤                    |
      |Preferred Name            |6343407    | 乾燥抗Ｄ（Ｒｈｏ）人免疫グロブリン     |
      |Drug Name                 |634340701  | 抗Ｄグロブリン                      |




  @DFT
  @ETE_JPN_Rave_coder_basic_sub_change_verbatim
  @PB1.1.2.003J
  @Release2016.1.0
  Scenario: Setup a Rave study, enter a verbatim in Rave, change verbatim in Rave, code updated verbatim in Coder, verify in Rave decision displays in Rave
    Given a Rave project registration with dictionary "MedDRA JPN 11.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
      | ETE3 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | true               | True           |                   |
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
    And task "ひどい頭痛" is coded to term "片側頭痛" at search level "Preferred Term" with code "10067040" at level "PT" and a synonym is created
    And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "左脚の足の痛み" on form "ETE3" for field "Coding Field" contains the following data
      | Coding Level | Code     | Term  |
      | SOC          | 10029205 | 神経系障害 |
      | HLGT         | 10019231 | 頭痛    |
      | HLT          | 10019233 | 頭痛ＮＥＣ |
      | PT           | 10067040 | 片側頭痛  |



  @DFT
  @ETE_JPN_Rave_coder_basic_sub_syn_rule
  @PB1.1.2.004J
  @Release2016.1.0
 Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE2 | Coding Field | <Dictionary> | <Locale> | LLT         | 1        | false              | false          |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE2"
      | Field                    | Value              | ControlType |
      | Coding Field             | 左脚の足の痛み | LongText    |
      | Log Supplemental Field A | ALPHA              |             |
    And Coder App Segment is loaded
    And task "terrible head pain" is coded to term "Head pain" at search level "Low Level Term" with code "10019198" at level "LLT" and a synonym is created
    And Rave Modules App Segment is loaded
	Then the coding decision on form "ETE2" for field "Coding Field" with row text "ALPHA" for verbatim "terrible head pain" contains the following data
         | Coding Level | Code     | Term  |
         | SOC          | 10029205 | 神経系障害 |
         | HLGT         | 10019231 | 頭痛    |
         | HLT          | 10019233 | 頭痛ＮＥＣ |
         | PT           | 10067040 | 片側頭痛  |
    When adding a new verbatim term to form "ETE2"
      | Field                    | Value              | ControlType |
      | Coding Field             | 左脚の足の痛み | LongText    |
      | Log Supplemental Field A | BRAVO              |             |
	Then the coding decision on form "ETE2" for field "Coding Field" with row text "BRAVO" for verbatim "terrible head pain" contains the following data
         | Coding Level | Code     | Term  |
         | SOC          | 10029205 | 神経系障害 |
         | HLGT         | 10019231 | 頭痛    |
         | HLT          | 10019233 | 頭痛ＮＥＣ |
         | PT           | 10067040 | 片側頭痛  |

  @DFT
  @ETE_JPN_Rave_coder_basic_up_version
  @PB1.1.2.005J
  @Release2016.1.0
  Scenario: Setup Rave study, enter verbatim in Rave, code verbatim in Coder and create synonym rule, complete the up-versioning process, enter verbatim term again in Rave, verify term gets autocoded and results display in Rave
    Given a Rave project registration with dictionary "MedDRA ENG 12.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE7 | ETE7            | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field    | Value         | ControlType |
      | ETE7     | 左脚の足の痛み  |             |
    And Coder App Segment is loaded
    And I browse and code task "左脚の足の痛み" entering value "片側頭痛" and selecting "片側頭痛" located in Dictionary Tree Table
    And I perform synonym migration to (Upgrade) list to "Primary"
    And I generate a study impact Analysis for the following data
      |Value        |dropdown               |
      |Project      |Register Study Dropdown|
      |Medra (Jpn)  |IADitionary Dropdown   |
      |11.1         |To Ordinal Dropdown    |
    And I navigate to Rave App form
    Then the field "CoderField1" on form "ETE7" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level |  Code   | Term       |
      |SOC          |10029205 |神経系障害   |
      |HLGT         |10019231 |頭痛        |
      |HLT          |10019233 |頭痛ＮＥＣ   |
      |PT           |10067040 |片側頭痛    |


  @DFT
  @ETE_JPN_Rave_coder_reconsider_verbatim
  @PB1.1.2.006J
  @Release2016.1.0
  Scenario: Setup Rave study, enter verbatim in Rave, code verbatim in Coder, verify results in Rave, reconsider verbatim in Coder and recode it to different term, verify updated results in Rave
    Given a Rave project registration with dictionary "MedDRA JPN 11.0"
    And Rave Modules App Segment is loaded
    And a Rave Coder setup with the following options
      | Form | Field           | Dictionary   | Locale   | CodingLevel    | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms            |
      | ETE1 | Adverse Event 1 | <Dictionary> | <Locale> | LLT            | 1        | true               | false          |                              |
    When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
    And adding a new subject "TEST"
    And adding a new verbatim term to form "ETE1"
      | Field           | Value      | ControlType |
      | Adverse Event 1 | ひどい頭痛   |             |
    And Coder App Segment is loaded
    And I browse and code Term "左脚の足の痛み" located in "Coder Main Table" entering value "片側頭痛" and selecting "片側頭痛" located in "Dictionary Tree Table"
    And I navigate to Rave App form
    Then the field "ETE1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level |  Code   | Term     |
      |SOC          |10029205 |神経系障害     |
      | HLGT        |10019231 |頭痛        |
      | HLT         |10019233 |頭痛ＮＥＣ     |
      | PT          |10019211 |頭痛        |
    And Coder App Segment is loaded
    And reclassify and Retire "左脚の足の痛み" entering value "Reclassifying to test message."
    And in Coder I reject the coding decision for "左脚の足の痛み"
    And I browse and code Term "左脚の足の痛み" located in "Coder Main Table" on row "1", entering value "頚原性頭痛" and selecting "頚原性頭痛" located in "Dictionary Tree Table"
    Then the field "ETE1" on form "ETE1" for study "<Study>" site "<Site>" subject "TEST" contains the following coding decision data
      |Coding Level |  Code   | Term     |
      |SOC          |10029205 |神経系障害     |
      | HLGT        |10019231 |頭痛        |
      | HLT         |10019233 |頭痛ＮＥＣ     |
      | PT          |10064888 |頚原性頭痛        |


















