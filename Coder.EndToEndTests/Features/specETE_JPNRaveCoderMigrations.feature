@specETE_JPNRaveCoderMigrations.feature

@EndToEndDynamicSegment
Feature: UPDATED Verify JPN Rave Coder Migrations

@VAL
@PB1.1.2_005J
@Release2012.1.0
Scenario: Setup Rave study with all non coding fields, enter data in EDC, migrate study in Rave from non-coding to Medidata Coder, Verify terms appear in Coder after migration
	Given a Rave project registration with dictionary "MedDRA JPN 11.0"
    And Rave Modules App Segment is loaded
   	When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
	And a Rave Coder setup is configured with the following options
      | Form | Field        | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval |
      | ETE2 | Coding Field | <Dictionary> | <Locale> | PT         | 1        | false              | false          |
	And adding a new subject "TST"
	And a Rave Draft is published using draft "<DraftName>" for Project "<StudyName>"
	And adding a new verbatim term to form "ETE2"
	| Field                    | Value   | ControlType |
	| Coding Field             | 左脚の足の痛み | LongText    |
	And an Amendment Manager migration is started for Project "<StudyName>" 
	And Coder App Segment is loaded
    And task "左脚の足の痛み" is coded to term "片側頭痛" at search level "Preferred Term" with code "10067040" at level "PT" and a synonym is created
	And Rave Modules App Segment is loaded
	Then the coding decision for verbatim "左脚の足の痛み" on form "ETE2" for field "Coding Field" contains the following data
      | Level | Code     | Term Path |
      | SOC   | 10029205 | 神経系障害     |
      | HLGT  | 10019231 | 頭痛        |
      | HLT   | 10019233 | 頭痛ＮＥＣ     |
      | PT    | 10067040 | 片側頭痛      |

	