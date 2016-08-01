@specStudyMigration.feature
@CoderCore
Feature: Verify study migration up-versioning

@VAL
@Release2015.3.0
@PBMCC_185551_001
@IncreaseTimeout_1800000
Scenario: Verify there are no incorrect categorizations for Reinstated instead of Node path changed for MedDRA ENG
	Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 Empty_List" containing entry ""
	And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
	When the following externally managed verbatim requests are made
		| Verbatim Term   | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Adverse Event 1 | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Tapas Rash      | MedDRA     | LLT              | TRUE                 | FALSE            |
    And coding the tasks 
		| Verbatim        | Dictionary Level | Search Text           | Search Level   | Synonym Term          | Synonym Code | Add Synonym |
		| Adverse Event 1 | LLT              | Hernia abdominal wall | Low Level Term | Hernia abdominal wall | 10019911     | True        |
		| Tapas Rash      | LLT              | Disbacteriosis        | Low Level Term | Disbacteriosis        | 10064389     | True        |
	And starting synonym list migration																						  
	And accepting the reconciliation suggestion for the synonym "Adverse Event 1" under the category "Path Does Not Exist"		  
	And dropping the reconciliation suggestion for the synonym "Tapas Rash" under the category "No Clear Match"					  
	And completing synonym migration																							  
	And performing Study Impact Analysis																						  
	Then the verbatim term "Adverse Event 1" exists under Path Changed															  
	And the verbatim term "Tapas Rash" exists under Term Not Found																  
    When performing study migration
	Then study migration is complete for the latest version
	And the following study report information exists
		| Verbatim        | Category                | Workflow Status     |
		| Adverse Event 1 | Coded but not Completed | Waiting Approval    |
		| Tapas Rash      | Not Coded               | Waiting Manual Code |
	And the term has the following coding history comments
		| Verbatim        | Comment                                                                                                         | Workflow Status     |
		| Adverse Event 1 | Version Change - From MedDRA-15_0-English To MedDRA-18_0-English. Recoded due to synonym change across versions | Waiting Approval    |
		| Tapas Rash      | Version Change - From MedDRA-15_0-English To MedDRA-18_0-English                                                | Waiting Manual Code |


@VAL
@Release2015.3.0
@PBMCC_185551_002
@IncreaseTimeout_1800000
Scenario: Any verbatim term with a direct dictionary match that has been re-coded to a non direct match term should auto code to a better match during up-versioning
	Given a "Waiting Approval" Coder setup with registered synonym list "MedDRA ENG 15.0 Empty_List" containing entry ""
	And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
	When the following externally managed verbatim requests are made
		| Verbatim Term | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Headache      | MedDRA     | LLT              | TRUE                 | FALSE            |
    And re-coding the tasks 
		| Verbatim | Dictionary Level | Search Text | Search Level   | Synonym Term | Synonym Code | Add Synonym | Comment       |
		| Headache | LLT              | Migraine    | Low Level Term | Migraine     | 10027599     | False       | Recoding task |
	And starting synonym list migration
	And performing Study Impact Analysis
	Then the study has "1" task(s) that is not affected
    When performing study migration
	Then study migration is complete for the latest version
	And the following study report information exists
		| Verbatim | Category                | Workflow Status  |
		| Headache | Coded but not Completed | Waiting Approval |
	And the term has the following coding history comments
		| Verbatim | Comment                                                                                       | Workflow Status  |
		| Headache | Version Change - From MedDRA-15_0-English To MedDRA-18_0-English. Recoded due to better match | Waiting Approval |


@VAL
@Release2015.3.0
@PBMCC_174921_001
@IncreaseTimeout_1800000
Scenario: Verify study up-versioning across all study impact analysis categories
	Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 9.0 Empty_List" containing entry ""
	And an unactivated synonym list "MedDRA ENG 12.0 New_Primary_List"
	When the following externally managed verbatim requests are made
		| Verbatim Term     | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Adverse Event 1   | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Tapas Rash        | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Blood Splatter 1  | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Human Error       | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Television Eyes   | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Blue Whale Legs   | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Foot Inflammation | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Box Cut           | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Headache          | MedDRA     | LLT              | FALSE                | FALSE            |
		| Blotchy rash      | MedDRA     | LLT              | FALSE                | FALSE            |
		| Case Changed Term | MedDRA     | LLT              | TRUE                 | FALSE            |
	And coding the tasks 
		| Verbatim          | Dictionary Level | Search Text                                         | Search Level   | Synonym Term                                        | Synonym Code | Add Synonym |
		| Adverse Event 1   | LLT              | Parathyrn                                           | Low Level Term | Parathyrn                                           | 10033933     | false       |
		| Tapas Rash        | LLT              | Broken leg                                          | Low Level Term | Broken leg                                          | 10006391     | false       |
		| Blood Splatter 1  | LLT              | Drug exposure prior and during pregnancy via father | Low Level Term | Drug exposure prior and during pregnancy via father | 10061359     | false       |
		| Human Error       | LLT              | Optic neuritis                                      | Low Level Term | Optic neuritis                                      | 10030942     | false       |
		| Television Eyes   | LLT              | Coronary artery restenosis                          | Low Level Term | Coronary artery restenosis                          | 10056489     | false       |
		| Blue Whale Legs   | LLT              | Oxalosis                                            | Low Level Term | Oxalosis                                            | 10049226     | false       |
		| Foot Inflammation | LLT              | Echolalia                                           | Low Level Term | Echolalia                                           | 10014127     | false       |
		| Box Cut           | LLT              | Angiofibroma                                        | Low Level Term | Angiofibroma                                        | 10002429     | false       |
		| Case Changed Term | LLT              | Parkinsonism                                        | Low Level Term | Parkinsonism                                        | 10034010     | true        |
	And starting synonym list migration
	And performing Study Impact Analysis
	Then the verbatim term "Case Changed Term" exists under Casing Changed
	When performing study migration
	Then study migration is complete for the latest version
	And the following study report information exists
		| Verbatim          | Category                | Workflow Status     |
		| Adverse Event 1   | Not Coded               | Waiting Manual Code |
		| Blood Splatter 1  | Not Coded               | Waiting Manual Code |
		| Human Error       | Not Coded               | Waiting Manual Code |
		| Television Eyes   | Not Coded               | Waiting Manual Code |
		| Blue Whale Legs   | Not Coded               | Waiting Manual Code |
		| Foot Inflammation | Not Coded               | Waiting Manual Code |
		| Box Cut           | Not Coded               | Waiting Manual Code |
		| Tapas Rash        | Coded but not Completed | Waiting Approval    |
		| Case Changed Term | Coded but not Completed | Waiting Approval    |
		| Headache          | Completed               | Completed           |
		| Blotchy rash      | Completed               | Completed           |
	And the term has the following coding history comments
		| Verbatim          | Comment                                                                                                        | Workflow Status     |
		| Adverse Event 1   | Version Change - From MedDRA-9_0-English To MedDRA-12_0-English                                                | Waiting Manual Code |
		| Blood Splatter 1  | Version Change - From MedDRA-9_0-English To MedDRA-12_0-English                                                | Waiting Manual Code |
		| Human Error       | Version Change - From MedDRA-9_0-English To MedDRA-12_0-English                                                | Waiting Manual Code |
		| Television Eyes   | Version Change - From MedDRA-9_0-English To MedDRA-12_0-English                                                | Waiting Manual Code |
		| Blue Whale Legs   | Version Change - From MedDRA-9_0-English To MedDRA-12_0-English                                                | Waiting Manual Code |
		| Foot Inflammation | Version Change - From MedDRA-9_0-English To MedDRA-12_0-English                                                | Waiting Manual Code |
		| Box Cut           | Version Change - From MedDRA-9_0-English To MedDRA-12_0-English                                                | Waiting Manual Code |
		| Tapas Rash        | Version Change - From MedDRA-9_0-English To MedDRA-12_0-English                                                | Waiting Approval    |
		| Case Changed Term | Version Change - From MedDRA-9_0-English To MedDRA-12_0-English. Recoded due to synonym change across versions | Waiting Approval    |


@VAL
@Release2015.3.0
@PBMCC_174921_002
@IncreaseTimeout_1800000
Scenario: Verify case sensitiveness during study up-versioning 
	Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 9.0 Empty_List" containing entry ""
	And an unactivated synonym list "MedDRA ENG 12.0 New_Primary_List"
	When the following externally managed verbatim requests are made
		| Verbatim Term     | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Case Changed Term | MedDRA     | LLT              | TRUE                 | FALSE            |
	And coding the tasks 
		| Verbatim          | Dictionary Level | Search Text  | Search Level   | Synonym Term | Synonym Code | Add Synonym |
		| Case Changed Term | LLT              | Parkinsonism | Low Level Term | Parkinsonism | 10034010     | true        |
	And starting synonym list migration
	And performing Study Impact Analysis
	Then the verbatim term "Case Changed Term" exists under Casing Changed
	When performing study migration
	Then study migration is complete for the latest version
	And the following study report information exists
		| Verbatim          | Category                | Workflow Status  |
		| Case Changed Term | Coded but not Completed | Waiting Approval |
	And the term has the following coding history comments
		| Verbatim          | Comment                                                                                                        | Workflow Status  |
		| Case Changed Term | Version Change - From MedDRA-9_0-English To MedDRA-12_0-English. Recoded due to synonym change across versions | Waiting Approval |

@DFT
@PBMCC_205138_001
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205373
Scenario: Tasks in "Waiting Manual Code" status shall be affected and completed by a Study Migration with a synonym for the verbatim term.

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the following externally managed verbatim requests are made
		| Verbatim Term | Dictionary Level |
		| HEADACHES     | LLT              |
   When performing Study Impact Analysis
   Then the verbatim term "HEADACHES" exists under Path Changed
   When performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the Coding History contains following information
   		| User   | Action     | Status               | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify | Waiting Manual Code  | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |            | Completed            | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Open Query | Waiting Manual Code  | HEADACHES     |                                                                                                                 | <TimeStamp> |

@DFT
@PBMCC_205138_002
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205391
Scenario: Manually coded tasks in "Waiting Approval" status shall be affected and completed by a Study Migration with a same term synonym for the verbatim term.

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the following externally managed verbatim requests are made
		| Verbatim Term | Dictionary Level |
		| HEADACHES     | LLT              |
   And task "HEADACHES" is coded to term "Acetabular dysplasia" at search level "Low Level Term" with code "10000396" at level "LLT"
   And performing Study Impact Analysis
   Then the verbatim term "HEADACHES" exists under Path Changed
   When performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the Coding History contains following information
   		| User   | Action          | Status              | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify      | Waiting Manual Code | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |                 | Completed           | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Browse And Code | Waiting Approval    | HEADACHES     |                                                                                                                 | <TimeStamp> |
   		| <User> | Open Query      | Waiting Manual Code | HEADACHES     |                                                                                                                 | <TimeStamp> |

@DFT
@PBMCC_205138_003
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205373
#TODO: This test can be dropped once MCC-205373 is verified. PBMCC_205138_004 now covers both the "affected" and "completion" tests.
Scenario: Manually coded tasks requiring approval in "Waiting Approval" status shall be affected by a Study Migration with a different term synonym for the verbatim term

   Given a "Waiting Approval" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the following externally managed verbatim requests are made
		| Verbatim Term | Dictionary Level |
		| HEADACHES     | LLT              |
   And task "HEADACHES" is coded to term "Haemoglobinuria" at search level "Low Level Term" with code "10018906" at level "LLT"
   And performing Study Impact Analysis
   Then the verbatim term "HEADACHES" exists under Path Changed
   When performing study migration
   Then the Coding History contains following information
   		| User   | Action          | Status              | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> |                 | Waiting Approval    | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Browse And Code | Waiting Approval    | HEADACHES     |                                                                                                                 | <TimeStamp> |
   		| <User> | Open Query      | Waiting Manual Code | HEADACHES     |                                                                                                                 | <TimeStamp> |

@DFT
@PBMCC_205138_004
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205373
#Comment: Failing due to defect MCC-205391
Scenario: Manually coded tasks in "Waiting Approval" status shall be affected and completed by a Study Migration with a different term synonym for the verbatim term

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the following externally managed verbatim requests are made
		| Verbatim Term | Dictionary Level |
		| HEADACHES     | LLT              |
   And task "HEADACHES" is coded to term "Haemoglobinuria" at search level "Low Level Term" with code "10018906" at level "LLT"
   And performing Study Impact Analysis
   Then the verbatim term "HEADACHES" exists under Path Changed
   When performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the Coding History contains following information
   		| User   | Action          | Status              | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify      | Waiting Manual Code | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |                 | Completed           | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Browse And Code | Waiting Approval    | HEADACHES     |                                                                                                                 | <TimeStamp> |
   		| <User> | Open Query      | Waiting Manual Code | HEADACHES     |                                                                                                                 | <TimeStamp> |
