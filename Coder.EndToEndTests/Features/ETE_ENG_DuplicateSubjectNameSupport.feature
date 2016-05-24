Feature: Coding decisions will post in EDC regardless of subject name

@MCC-207752
@ETE_ENG_dup_namesupport
Scenario: Subject with duplicate names when one is inactivated will still be able to receive coding decisions
And Coder App Segment is loaded
And a project registration with dictionary "Medra 11.0 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE1  | Adverse Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TES1"                     ##subject and form must stay the same for scenario
When adding a new verbatim term to form "TES1"
	| Field         | Value                | ControlType | Control Value |
	| AdverseEvent1 | terrible head pain   |             |               |
And I navigate to Coder 
When I browse and code Term "terrible head pain" located in "Coder Main Table" entering value "Headache" and selecting "Headache" located in "Dictionary Tree Table"
And I navigate to Rave
Then when I view task "terrible head pain" on form "Subject" I should see the following data
    |data                       |
    |terrible head pain         |
    |SOC                        |
    |Nervous system disorders   |
    |10029205                   |
    |HLGT                       |
    |Headaches                  |
    |10019231                   |
    |HLT                        |
    |Headaches NEC              |
    |10019233                   |
    |PT                         |
    |Headache                   |
    |10019211                   |