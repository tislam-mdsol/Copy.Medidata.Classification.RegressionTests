Feature: Coding decisions will post in EDC regardless of subject name

@DFT
@ETE_ENG_dup_namesupport
@PB3.6.6-001
@Release2016.1.0


Scenario: Subject with duplicate names when one is inactivated will still be able to receive coding decisions

  Given a Rave project registration with dictionary "MedDRA 11.0 ENG"
  And Rave Modules App Segment is loaded
  And a Rave Coder setup with the following options
    | Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
    | ETE1 | Adverese Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
  When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
  And adding a new subject "TST"
  And adding a new subject "TST"
  And adding a new verbatim term to form "ETE1"
    | Field            | Value	  | ControlType |
    | Adverese Event 1 | HeadBang | LongText    |
  And Coder App Segment is loaded
  And task "HeadBang" is coded to term "ACHES-N-PAIN" at search level "Low Level Term" with code "??????????????" at level "LLT"
  And Rave Modules App Segment is loaded
  Then the coding decision for verbatim "HeadBang" on form "ETE1" for field "Adverese Event 1" contains the following data
    | Level | Code     | Term Path                    |
    | SOC   | 10007541 | Cardiac disorders            |
    | HLGT  | 10007521 | Cardiac arrhythmias          |
    | HLT   | 10042600 | Supraventricular arrhythmias |
    | PT    | 10003658 | Atrial fibrillation          |
    | LLT   | 10003658 | Atrial fibrillation          |
