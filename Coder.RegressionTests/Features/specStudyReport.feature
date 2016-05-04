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

Scenario:  Study Report returns data for task with a workflow state of "Not Coded"
    Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	When coding tasks are loaded from CSV file "Tasks_6_CodeAndNext.csv"
	Then Study Report data should have "6" tasks  with a workflow state of "NotCoded"

@VAL
@Release2015.3.0
@PBMCC_185572_003
@IncreaseTimeout

Scenario:  Study Report returns data for task with a workflow state of "completed" 
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
	Then Study Report data should have "6" tasks  with a workflow state of "Completed"


@VAL
@Release2015.3.0
@PBMCC_185572_004
@IncreaseTimeout

Scenario:  Study Report returns data for tasks with a workflow state of "completed" as wells as "NotCoded"
    Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	And coding tasks from CSV file "Tasks_6_CodeAndNext.csv"
	When task "Congestion" is coded to term "Congestion nasal" at search level "Low Level Term" with code "10010676" at level "LLT" and a synonym is created
	Then Study Report data should have "1" tasks  with a workflow state of "Completed"
	And Study Report data should have "5" tasks  with a workflow state of "NotCoded"


@VAL
@Release2015.3.0
@PBMCC_185572_005
@IncreaseTimeout

Scenario:  Study Report returns data for tasks with a workflow state of "Coded But Not Completed" 
    Given a "Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	And coding task "Congestion" for dictionary level "LLT"
	When task "Congestion" is coded to term "Congestion nasal" at search level "Low Level Term" with code "10010676" at level "LLT" and a synonym is created
	And reclassifying task "CONGESTION" with Include Autocoded Items set to "True"
	Then Study Report data should have "1" tasks  with a workflow state of "CodedButNotComplete"