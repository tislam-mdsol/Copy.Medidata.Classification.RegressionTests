@specCodingDecisionsReport.feature
@CoderCore
Feature: This feature will demonstrate Coder's functionality on generating Coding Decision Reports which contains task information about terms that have gone through coding and approval.

@VAL
@PBMCC_189285_001
@Release2015.3.0
Scenario: Coder will allow a user to be able to export a Coding Decision Report, which contains information on coded and approved coding decisions via verbatim text
    Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0" 
	And coding task "Headache" for dictionary level "LLT"
	When searching for the verbatim "Headache" in Coding Decisions Report
	And searching for auto coded items in Coding Decisions Report
	And exporting all columns in the Coding Decisions Report
	Then the Coding Decisions Report should contain the following
		| Verbatim Term | Dictionary Level | Coded By    | Current Workflow State | Term     | Code     | Is Auto Coded | Priority | Logline | Path                                                                                                                                              |
		| Headache      | Low Level Term   | System User | Completed              | Headache | 10019211 | True          | 1        | 1       | SOC: Nervous system disorders: 10029205; HLGT: Headaches: 10019231; HLT: Headaches NEC: 10019233; PT: Headache: 10019211; LLT: Headache: 10019211 | 

@VAL
@PBMCC_197264_001
@Release2015.3.2
Scenario: Verify the user is able to export using verbatim for Coding Decisions Report
	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And coding task "Adverse Event Term 1" for dictionary level "LLT"
    When task "Adverse Event Term 1" is coded to term "Dizzy on standing" at search level "Low Level Term" with code "10013581" at level "LLT" and higher level terms
	     | Operator | Attribute          | Text               |
	     | Has      | System Organ Class | Vascular disorders |
	And searching for the verbatim "Adverse Event Term 1" in Coding Decisions Report
	And searching for auto coded items in Coding Decisions Report
	And exporting all columns in the Coding Decisions Report
	Then the Coding Decisions Report should contain the following
		| Verbatim Term        | Dictionary Level | Current Workflow State | Term              | Code     | Is Auto Coded | Priority | Logline | Path                                                                                                                                                                                                                               | 
		| Adverse Event Term 1 | Low Level Term   | Waiting Approval       | Dizzy on standing | 10013581 | False         | 1        | 1       | SOC: Vascular disorders: 10047065; HLGT: Decreased and nonspecific blood pressure disorders and shock: 10011954; HLT: Circulatory collapse and shock: 10009193; PT: Dizziness postural: 10013578; LLT: Dizzy on standing: 10013581 | 

@VAL
@PBMCC_197264_002
@Release2015.3.2
Scenario: Verify the user is able to export using verbatim for Coding Decisions Report with Auto Coded unchecked
	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And coding task "PAIN IN UPPER CHEST" for dictionary level "LLT"
    When task "PAIN IN UPPER CHEST" is coded to term "Acute chest pain" at search level "Low Level Term" with code "10066987" at level "LLT" and higher level terms
	     | Operator | Attribute          | Text               |
	     | Has      | System Organ Class | General disorders and administration site conditions |
	And searching for the verbatim "PAIN IN UPPER CHEST" in Coding Decisions Report
	And exporting all columns in the Coding Decisions Report
	Then the Coding Decisions Report should contain the following
		| Verbatim Term       | Dictionary Level | Current Workflow State | Term             | Code     | Is Auto Coded | Priority | Logline | Path                                                                                                                                                                                                                    | 
		| PAIN IN UPPER CHEST | Low Level Term   | Waiting Approval       | Acute chest pain | 10066987 | False         | 1        | 1       | SOC: General disorders and administration site conditions: 10018065; HLGT: General system disorders NEC: 10018073; HLT: Pain and discomfort NEC: 10033372; PT: Chest pain: 10008479; LLT: Acute chest pain: 10066987	   | 

@VAL
@PBMCC_197264_003
@Release2015.3.2
Scenario: Verify the user is able to select statuses in current status for Coding Decisions Report
	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And coding task "Adverse Event Term 1" for dictionary level "LLT"
    When task "Adverse Event Term 1" is coded to term "Dizzy on standing" at search level "Low Level Term" with code "10013581" at level "LLT" and higher level terms
	     | Operator | Attribute          | Text               |
	     | Has      | System Organ Class | Vascular disorders |
	And searching for the verbatim "Adverse Event Term 1" in Coding Decisions Report
	And searching for the status "Waiting Approval" in Coding Decisions Report
	And searching for auto coded items in Coding Decisions Report
	And exporting all columns in the Coding Decisions Report
	Then the Coding Decisions Report should contain the following
		| Verbatim Term        | Dictionary Level | Current Workflow State | Term              | Code     | Is Auto Coded | Priority | Logline | Path                                                                                                                                                                                                                               | 
		| Adverse Event Term 1 | Low Level Term   | Waiting Approval       | Dizzy on standing | 10013581 | False         | 1        | 1       | SOC: Vascular disorders: 10047065; HLGT: Decreased and nonspecific blood pressure disorders and shock: 10011954; HLT: Circulatory collapse and shock: 10009193; PT: Dizziness postural: 10013578; LLT: Dizzy on standing: 10013581 |
	

@VAL
@PBMCC_197264_004
@Release2015.3.2
Scenario: Verify the user is able to enter a start and end date for Coding Decisions Report
	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And coding task "Adverse Event Term 1" for dictionary level "LLT"
	When task "Adverse Event Term 1" is coded to term "Dizzy on standing" at search level "Low Level Term" with code "10013581" at level "LLT" and higher level terms
	    | Operator | Attribute          | Text               |
	    | Has      | System Organ Class | Vascular disorders |
	And searching for the verbatim "Adverse Event Term 1" in Coding Decisions Report
	And searching for start date of "01 Jan 2015" and end date of "01 Jan 2050" in Coding Decisions Report
	And searching for auto coded items in Coding Decisions Report
	And exporting all columns in the Coding Decisions Report
	Then the Coding Decisions Report should contain the following
		| Verbatim Term        | Dictionary Level | Current Workflow State | Term              | Code     | Is Auto Coded | Priority | Logline | Path                                                                                                                                                                                                                               | 
		| Adverse Event Term 1 | Low Level Term   | Waiting Approval       | Dizzy on standing | 10013581 | False         | 1        | 1       | SOC: Vascular disorders: 10047065; HLGT: Decreased and nonspecific blood pressure disorders and shock: 10011954; HLT: Circulatory collapse and shock: 10009193; PT: Dizziness postural: 10013578; LLT: Dizzy on standing: 10013581 | 


@VAL
@PBMCC_197264_005
@Release2015.3.2
@IncreaseTimeout_3000000
Scenario: Verify the user is able to export multiple terms for Coding Decisions Report
	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	When the following externally managed verbatim requests are made
		| Verbatim Term        | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval | Locale |
		| Adverse Event Term 1 | MedDRA     | LLT              | TRUE                 | FALSE            | eng    |
		| Adverse Event Term 1 | MedDRA     | LLT              | TRUE                 | FALSE            | eng    |
	And task "Adverse Event Term 1" is coded to term "Dizzy on standing" at search level "Low Level Term" with code "10013581" at level "LLT" and higher level terms
	    | Operator | Attribute          | Text               |
	    | Has      | System Organ Class | Vascular disorders |
	And searching for the verbatim "Adverse Event Term 1" in Coding Decisions Report
	And searching for auto coded items in Coding Decisions Report
	And exporting all columns in the Coding Decisions Report
	Then the Coding Decisions Report should contain the following
		| Verbatim Term        | Dictionary Level | Current Workflow State | Term              | Code     | Is Auto Coded | Priority | Logline | Path                                                                                                                                                                                                                               | 
		| Adverse Event Term 1 | Low Level Term   | Waiting Approval       | Dizzy on standing | 10013581 | False         | 1        | Line 1  | SOC: Vascular disorders: 10047065; HLGT: Decreased and nonspecific blood pressure disorders and shock: 10011954; HLT: Circulatory collapse and shock: 10009193; PT: Dizziness postural: 10013578; LLT: Dizzy on standing: 10013581 | 
		| Adverse Event Term 1 | Low Level Term   | Waiting Approval       | Dizzy on standing | 10013581 | False         | 1        | Line 1  | SOC: Vascular disorders: 10047065; HLGT: Decreased and nonspecific blood pressure disorders and shock: 10011954; HLT: Circulatory collapse and shock: 10009193; PT: Dizziness postural: 10013578; LLT: Dizzy on standing: 10013581 |  
	

@VAL
@PBMCC_197264_006
@Release2015.3.2
Scenario: Verify the user is able to export using verbatim on a non production study for Coding Decisions Report
	Given a "Waiting Approval" Coder setup for a non-production study with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And coding task "Adverse Event Term 2" for dictionary level "LLT"
	When task "Adverse Event Term 2" is coded to term "Dizzy on standing" at search level "Low Level Term" with code "10013581" at level "LLT" and higher level terms
	    | Operator | Attribute          | Text               |
	    | Has      | System Organ Class | Vascular disorders |
	And searching for the verbatim "Adverse Event Term 2" in Coding Decisions Report
	And searching for auto coded items in Coding Decisions Report
	And exporting all columns in the Coding Decisions Report
	Then the Coding Decisions Report should contain the following
		| Study Name     | Verbatim Term | Dictionary Level | Current Workflow State | Term | Code | Is Auto Coded | Priority | Logline | Path |
		| <DevStudyName> | Adverse Event Term 2 | Low Level Term   | Waiting Approval       | Dizzy on standing | 10013581 | False         | 1        | 1       | SOC: Vascular disorders: 10047065; HLGT: Decreased and nonspecific blood pressure disorders and shock: 10011954; HLT: Circulatory collapse and shock: 10009193; PT: Dizziness postural: 10013578; LLT: Dizzy on standing: 10013581 | 
	