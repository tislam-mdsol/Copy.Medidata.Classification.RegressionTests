@specStudyReport.feature
@CoderCore
Feature: These scenarios will validate the Coder Study Report behavior

@VAL
@Release2015.3.0
@PBMCC_185572_001
@IncreaseTimeout

Scenario: Study Report returns correct number of tasks
    Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	When coding tasks are loaded from CSV file "Tasks_6_CodeAndNext.csv"
	Then Study Report data should have "6" tasks

@VAL
@Release2015.3.0
@PBMCC_185572_002
@IncreaseTimeout

Scenario:  Study Report returns data for task with a task state of "Not Coded"
    Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	When coding tasks are loaded from CSV file "Tasks_6_CodeAndNext.csv"
	Then the study report task status count information should have the following  
	| Status                    | Count |
	| Completed Count           | 0     |
	| Not Coded Count           | 6     |
	| Coded Not Completed Count | 0     |
	| With Open Query Count     | 0     |


@VAL
@Release2015.3.0
@PBMCC_185572_003
@IncreaseTimeout

Scenario:  Study Report returns data for task with a task state of "completed" 
    Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	When coding tasks are loaded from CSV file "Tasks_6_CodeAndNext.csv"
	And a browse and code for task "Burning" is performed
	And I code next available task
	| Verbatim     | SearchText                | SearchLevel    | Code     | Level | CreateSynonym |
	| Burning      | Gastroesophageal burning  | Low Level Term | 10066998 | LLT   | False         |
	| Congestion   | Congestion nasal          | Low Level Term | 10010676 | LLT   | False         |
	| Heart Burn   | Reflux gastritis          | Low Level Term | 10057969 | LLT   | False         |
	| Nasal Drip   | Postnasal drip            | Low Level Term | 10036402 | LLT   | False         |
	| Reflux       | Gastritis alkaline reflux | Low Level Term | 10017858 | LLT   | False         |
	| Stiff Joints | Stiff joint               | Low Level Term | 10042041 | LLT   | False         |
	Then the study report task status count information should have the following  
	| Status                    | Count |
	| Completed Count           | 6     |
	| Not Coded Count           | 0     |
	| Coded Not Completed Count | 0     |
	| With Open Query Count     | 0     |


@VAL
@Release2015.3.0
@PBMCC_185572_004
@IncreaseTimeout

Scenario:  Study Report returns data for tasks with a task state of "completed" as wells as "NotCoded"
    Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	And coding tasks from CSV file "Tasks_6_CodeAndNext.csv"
	When task "Congestion" is coded to term "Congestion nasal" at search level "Low Level Term" with code "10010676" at level "LLT" and a synonym is created
	Then the study report task status count information should have the following   
	| Status                    | Count |
	| Completed Count           | 1     |
	| Not Coded Count           | 5     |
	| Coded Not Completed Count | 0     |
	| With Open Query Count     | 0     |


@VAL
@Release2015.3.0
@PBMCC_185572_005
@IncreaseTimeout

Scenario:  Study Report returns data for tasks with a task state of "Coded But Not Completed" 
    Given a "Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	And coding task "Congestion" for dictionary level "LLT"
	When task "Congestion" is coded to term "Congestion nasal" at search level "Low Level Term" with code "10010676" at level "LLT" and a synonym is created
	And reclassifying task "CONGESTION" with Include Autocoded Items set to "True"
	Then the study report task status count information should have the following   
	| Status                    | Count |
	| Completed Count           | 0     |
	| Not Coded Count           | 0     |
	| Coded Not Completed Count | 1     |
	| With Open Query Count     | 0     |


@VAL
@Release2015.3.0
@PBMCC_185572_006
@IncreaseTimeout

Scenario:  Study Report returns data for tasks with a task state of "With Open Query Count" 
    Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
    When the query for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"	
	Then the study report task status count information should have the following   
	| Status                    | Count |
	| Completed Count           | 0     |
	| Not Coded Count           | 1     |
	| Coded Not Completed Count | 0     |
	| With Open Query Count     | 1     |


@DFT
@Release2015.3.0
@PBMCC_185572_007
@IncreaseTimeout

Scenario:  Study Report returns verbatim data for tasks with a task state of "Not Coded"
    Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	When coding tasks are loaded from CSV file "Tasks_6_CodeAndNext.csv"
	Then the study report task detail information for a study with task category "Not Coded" should have the following   
	| Verbatim     | Dictionary  | Dictionary Level | Code | Term | Workflow Status     | Path | Batch          |
	| Burning      | MedDRA 15.0 | Low Level Term   |      |      | Waiting Manual Code |      | MedDRA Batch 1 |
	| Congestion   | MedDRA 15.0 | Low Level Term   |      |      | Waiting Manual Code |      | MedDRA Batch 1 |
	| Heart Burn   | MedDRA 15.0 | Low Level Term   |      |      | Waiting Manual Code |      | MedDRA Batch 1 |
	| Nasal Drip   | MedDRA 15.0 | Low Level Term   |      |      | Waiting Manual Code |      | MedDRA Batch 1 |
	| Reflux       | MedDRA 15.0 | Low Level Term   |      |      | Waiting Manual Code |      | MedDRA Batch 1 |
	| Stiff Joints | MedDRA 15.0 | Low Level Term   |      |      | Waiting Manual Code |      | MedDRA Batch 1 |      