Feature: Coding decisions will post in EDC regardless of subject name

@DFT
@ETE_ENG_dup_namesupport
@PB3.6.6_001
@Release2016_1_0
@EndToEndDynamicSegment

Scenario: Subject with duplicate names when one is inactivated will still be able to receive coding decisions

 Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
  And Rave Modules App Segment is loaded
  And a Rave Coder setup with the following options
    | Form | Field        | Dictionary   | Locale   | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval |
    | ETE2 | Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | true               | true           |
  When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
  And adding a set of duplicate subject with initial "TST"
  #click on studyname tab again
  #click add subject 
  #click add subject with the same name
  And deactivating a duplicate subject 
  #go to rave home
  #go to site administration
  #search for your study
  #select your study
  #go into your study
  #click on subjects
  #click on edit associated with your subject
  #uncheck active
  And adding a new verbatim term to form "ETE1"
    | Field        | Value    | ControlType |
    | Coding Field | HeadBang | LongText    |
  And Coder App Segment is loaded
  And task "HeadBang" is coded to term "ACHES-N-PAIN" at search level "Low Level Term" with code "??????????????" at level "LLT"
  And Rave Modules App Segment is loaded
  Then the coding decision for verbatim "HeadBang" on form "ETE1" for field "Coding Field" contains the following data
    | Level | Code     | Term Path                    |
    | SOC   | 10007541 | Cardiac disorders            |
    | HLGT  | 10007521 | Cardiac arrhythmias          |
    | HLT   | 10042600 | Supraventricular arrhythmias |
    | PT    | 10003658 | Atrial fibrillation          |
    | LLT   | 10003658 | Atrial fibrillation          |
