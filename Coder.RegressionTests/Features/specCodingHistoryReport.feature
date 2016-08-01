@specCodingHistoryReport.feature
@CoderCore
Feature: Verify Coding History Report

@VAL
@PBMCC_37359_MCC_178485_001
@Release2015.3.0
Scenario: Verify the user is able to export using verbatim
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And coding task "Adverse Event Term 1" for dictionary level "LLT"
	When searching for the verbatim "Adverse Event Term 1" in Coding History Report
	And searching for auto coded items in Coding History Report
	And exporting all columns in the Coding History Report
	Then the Coding History Report should contain the following
	| Verbatim Term        | User        | Term | Code | Path | Status              | Action          | System Action | Comment                                                                                                               |
	| Adverse Event Term 1 | System User |      |      |      | Start               |                 |               | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAutoApproval=true,IsBypassTransmit=True] |
	| Adverse Event Term 1 | System User |      |      |      | Waiting Manual Code | Start Auto Code |               |                                                                                                                       |
	

@VAL
@PBMCC_37359_MCC_178485_002
@Release2015.3.0
Scenario: Verify the user is able to export using code
	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 200703" 
	And coding task "ASPIRIN PLUS C" for dictionary level "PRODUCT"
	When searching for the term "ASPIRIN PLUS C" in Coding History Report
	And searching for the code "003467 01 001" in Coding History Report
	And searching for auto coded items in Coding History Report
	And exporting all columns in the Coding History Report
	Then the Coding History Report should contain the following
	| Verbatim Term  | User        | Term           | Code          | Path                                                                                                                                                                           | Status           | Action          | System Action | Comment                                                                                                                |
	| ASPIRIN PLUS C | System User |                |               |                                                                                                                                                                                | Start            |                 |               | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAutoApproval=false,IsBypassTransmit=True] |
	| ASPIRIN PLUS C | System User | ASPIRIN PLUS C | 003467 01 001 | ATC: NERVOUS SYSTEM: N; ATC: ANALGESICS: N02; ATC: OTHER ANALGESICS AND ANTIPYRETICS: N02B; ATC: SALICYLIC ACID AND DERIVATIVES: N02BA; PRODUCT: ASPIRIN PLUS C: 003467 01 001 | Waiting Approval | Start Auto Code | Auto Coding   | Auto coded by direct dictionary match                                                                                  |                                                                                                                	


@VAL
@PBMCC_37359_MCC_178485_003
@Release2015.3.0
Scenario: Verify the user is able to export using term
	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 200703" 
	And coding task "ASPIRIN PLUS C" for dictionary level "PRODUCT"
	When searching for the term "ASPIRIN PLUS C" in Coding History Report
	And searching for auto coded items in Coding History Report
	And exporting all columns in the Coding History Report
	Then the Coding History Report should contain the following
	| Verbatim Term  | User        | Term           | Code          | Path                                                                                                                                                                           | Status           | Action          | System Action | Comment                                                                                                                |
	| ASPIRIN PLUS C | System User |                |               |                                                                                                                                                                                | Start            |                 |               | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAutoApproval=false,IsBypassTransmit=True] |
	| ASPIRIN PLUS C | System User | ASPIRIN PLUS C | 003467 01 001 | ATC: NERVOUS SYSTEM: N; ATC: ANALGESICS: N02; ATC: OTHER ANALGESICS AND ANTIPYRETICS: N02B; ATC: SALICYLIC ACID AND DERIVATIVES: N02BA; PRODUCT: ASPIRIN PLUS C: 003467 01 001 | Waiting Approval | Start Auto Code | Auto Coding   | Auto coded by direct dictionary match                                                                                  |                                                                                                              
	

@VAL
@PBMCC_37359_MCC_178485_004
@Release2015.3.0
Scenario: Verify the user is able to select statuses in current status
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And coding task "Adverse Event Term 1" for dictionary level "LLT"
	When searching for the verbatim "Adverse Event Term 1" in Coding History Report
	And searching for the status "Waiting Manual Code"
	And searching for auto coded items in Coding History Report
	And exporting all columns in the Coding History Report
	Then the Coding History Report should contain the following
	| Verbatim Term        | User        | Term | Code | Path | Status              | Action          | System Action | Comment                                                                                                               |
	| Adverse Event Term 1 | System User |      |      |      | Start               |                 |               | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAutoApproval=true,IsBypassTransmit=True] |
	| Adverse Event Term 1 | System User |      |      |      | Waiting Manual Code | Start Auto Code |               |                                                                                                                       |
	

@VAL
@PBMCC_37359_MCC_178485_005
@Release2015.3.0
Scenario: Verify the user is able to enter a start and end date
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And coding task "Adverse Event Term 1" for dictionary level "LLT"
	When searching for the verbatim "Adverse Event Term 1" in Coding History Report
	And searching for start date of "01 Jan 2015" and end date of "01 Jan 2050" in Coding History Report
	And searching for auto coded items in Coding History Report
	And exporting all columns in the Coding History Report
	Then the Coding History Report should contain the following
	| Verbatim Term        | User        | Term | Code | Path | Status              | Action          | System Action | Comment                                                                                                               |
	| Adverse Event Term 1 | System User |      |      |      | Start               |                 |               | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAutoApproval=true,IsBypassTransmit=True] |
	| Adverse Event Term 1 | System User |      |      |      | Waiting Manual Code | Start Auto Code |               |                                                                                                                       |
	


@VAL
@PBMCC_37359_MCC_178485_006
@Release2015.3.0
Scenario: Verify the user is able to export multiple terms
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	When the following externally managed verbatim requests are made
	| Verbatim Term        | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval | Locale |
	| Adverse Event Term 1 | MedDRA     | LLT              | TRUE                 | FALSE            | eng    |
	| Adverse Event Term 1 | MedDRA     | LLT              | TRUE                 | FALSE            | eng    |
	And searching for auto coded items in Coding History Report
	And exporting all columns in the Coding History Report
	Then the Coding History Report should contain the following
	| Verbatim Term        | User        | Term | Code | Path | Status              | Action          | System Action | Comment                                                                                                                |
	| Adverse Event Term 1 | System User |      |      |      | Start               |                 |               | Workflow=DEFAULT,WorkflowVariables[IsApprovalRequired=TRUE,IsAutoApproval=FALSE,IsBypassTransmit=True,IsAutoCode=True] |
	| Adverse Event Term 1 | System User |      |      |      | Waiting Manual Code | Start Auto Code |               |                                                                                                                        |
	

@VAL
@PBMCC_37359_MCC_178485_007
@Release2015.3.0
Scenario: Verify the user is able to export using verbatim on a non production study
  Given a "Basic" Coder setup for a non-production study with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And coding task "Adverse Event Term 2" for dictionary level "LLT"
  When searching for the verbatim "Adverse Event Term 2" in Coding History Report
  And searching for auto coded items in Coding History Report
  And exporting all columns in the Coding History Report
  Then the Coding History Report should contain the following
  | Study          | Verbatim Term        | User        | Term | Code | Path | Status | Action | System Action | Comment                                                                                                               |
  | <DevStudyName> | Adverse Event Term 2 | System User |      |      |      | Start  |        |               | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAutoApproval=true,IsBypassTransmit=True] |
  | <DevStudyName> | Adverse Event Term 2 | System User |      |      |      | Waiting Manual Code | Start Auto Code |               |                                                                                                                       |
	
