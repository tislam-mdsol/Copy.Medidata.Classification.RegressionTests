@specTaskQueriesAfterStudyMigration.feature
@CoderCore
Feature: Verifies Coder Task Query processing and display of information after a Study Migration.

When a task with a query reaches the completed state after a Study Migration, the queries shall be "canceled by Coder" (put in the "Queued" query status)
 if their query status prior to the Study Migration was "Open" or "Answered".
When a task with a query reaches the completed state after a Study Migration, the queries shall not be changed
 if their query status prior to the Study Migration was "Cancelled" or "Closed".

_ The following environment configuration settings were enabled:

   Synonym Lists Registered:
   Synonym List 1: MedDRA              (ENG) 16.0      Empty_List 
   Synonym List 2: MedDRA              (ENG) 16.0      Initial_List 
   Synonym List 3: MedDRA              (ENG) 16.1      New_Primary_List

   Common Configurations:   
   Basic                    
   Waiting Approval 

@DFT
@PBMCC_205137_001
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205373
Scenario: STUDY MIGRATION Study migrations shall cancel queries with "Open" status if the associated terms with "Waiting Manual Code" status are placed in a complete state due to path changes in new synonyms

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the query for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   And performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <User>       | HEADACHES     | Queued       |            |                |                    |             | <TimeStamp> |
		| <SystemUser> | HEADACHES     | Open         | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User   | Action     | Status               | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify | Waiting Manual Code  | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |            | Completed            | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Open Query | Waiting Manual Code  | HEADACHES     |                                                                                                                 | <TimeStamp> |
   And the query status for task "HEADACHES" is "Queued"

@DFT
@PBMCC_205137_002
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205373
Scenario: STUDY MIGRATION Study migrations shall cancel queries with "Answered" status if the associated terms with "Waiting Manual Code" status are placed in a complete state due to path changes in new synonyms

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the query for new task "HEADACHES" with comment "Severity?" is "Answered" with response "Acute"
   And performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <User>       | HEADACHES     | Queued       |            |                |                    |             | <TimeStamp> |
		| <SystemUser> | HEADACHES     | Answered     | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User   | Action     | Status               | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify | Waiting Manual Code  | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |            | Completed            | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Open Query | Waiting Manual Code  | HEADACHES     |                                                                                                                 | <TimeStamp> |
   And the query status for task "HEADACHES" is "Queued"

@DFT
@PBMCC_205137_003
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205373
Scenario: STUDY MIGRATION Study migrations shall not change the status of queries with "Cancelled" status if the associated terms with "Waiting Manual Code" status are placed in a complete state due to path changes in new synonyms

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the query for new task "HEADACHES" with comment "Severity?" is "Cancelled" with response "Acute"
   And performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <SystemUser> | HEADACHES     | Cancelled    | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User   | Action     | Status               | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify | Waiting Manual Code  | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |            | Completed            | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Open Query | Waiting Manual Code  | HEADACHES     |                                                                                                                 | <TimeStamp> |
   And the query status for task "HEADACHES" is "Cancelled"
			
@DFT
@PBMCC_205137_004
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205373
Scenario: STUDY MIGRATION Study migrations shall not change the status of queries with "Closed" status if the associated terms with "Waiting Manual Code" status are placed in a complete state due to path changes in new synonyms

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the query for new task "HEADACHES" with comment "Severity?" is "Closed" with response "Acute"
   And performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <SystemUser> | HEADACHES     | Closed       | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User   | Action     | Status               | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify | Waiting Manual Code  | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |            | Completed            | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Open Query | Waiting Manual Code  | HEADACHES     |                                                                                                                 | <TimeStamp> |
   And the query status for task "HEADACHES" is "Closed"

@DFT
@PBMCC_205137_005
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205391
Scenario: STUDY MIGRATION Study migrations shall cancel queries with "Open" status if the associated manually coded terms with "Waiting Approval" status are placed in a complete state due to path changes in new synonyms

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the query for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   And task "HEADACHES" is coded to term "Acetabular dysplasia" at search level "Low Level Term" with code "10000396" at level "LLT"
   And performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <User>       | HEADACHES     | Queued       |            |                |                    |             | <TimeStamp> |
		| <SystemUser> | HEADACHES     | Open         | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User   | Action          | Status              | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify      | Waiting Manual Code | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |                 | Completed           | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Browse And Code | Waiting Approval    | HEADACHES     |                                                                                                                 | <TimeStamp> |
   		| <User> | Open Query      | Waiting Manual Code | HEADACHES     |                                                                                                                 | <TimeStamp> |
   And the query status for task "HEADACHES" is "Queued"

@DFT
@PBMCC_205137_006
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205391
Scenario: STUDY MIGRATION Study migrations shall cancel queries with "Answered" status if the associated manually coded terms with "Waiting Approval" status are placed in a complete state due to path changes in new synonyms

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the query for new task "HEADACHES" with comment "Severity?" is "Answered" with response "Acute"
   And task "HEADACHES" is coded to term "Acetabular dysplasia" at search level "Low Level Term" with code "10000396" at level "LLT"
   And performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <User>       | HEADACHES     | Queued       |            |                |                    |             | <TimeStamp> |
		| <SystemUser> | HEADACHES     | Answered     | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User   | Action          | Status              | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify      | Waiting Manual Code | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |                 | Completed           | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Browse And Code | Waiting Approval    | HEADACHES     |                                                                                                                 | <TimeStamp> |
   		| <User> | Open Query      | Waiting Manual Code | HEADACHES     |                                                                                                                 | <TimeStamp> |
   And the query status for task "HEADACHES" is "Queued"

@DFT
@PBMCC_205137_007
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205391
Scenario: STUDY MIGRATION Study migrations shall not change the status of queries with "Cancelled" status if the associated manually coded terms with "Waiting Approval" status are placed in a complete state due to path changes in new synonyms

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the query for new task "HEADACHES" with comment "Severity?" is "Cancelled" with response "Acute"
   And task "HEADACHES" is coded to term "Acetabular dysplasia" at search level "Low Level Term" with code "10000396" at level "LLT"
   And performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <SystemUser> | HEADACHES     | Cancelled    | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User   | Action          | Status              | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify      | Waiting Manual Code | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |                 | Completed           | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Browse And Code | Waiting Approval    | HEADACHES     |                                                                                                                 | <TimeStamp> |
   		| <User> | Open Query      | Waiting Manual Code | HEADACHES     |                                                                                                                 | <TimeStamp> |
   And the query status for task "HEADACHES" is "Cancelled"
			
@DFT
@PBMCC_205137_008
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205391
Scenario: STUDY MIGRATION Study migrations shall not change the status of queries with "Closed" status if the associated manually coded terms with "Waiting Approval" status are placed in a complete state due to path changes in new synonyms

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the query for new task "HEADACHES" with comment "Severity?" is "Closed" with response "Acute"
   And task "HEADACHES" is coded to term "Acetabular dysplasia" at search level "Low Level Term" with code "10000396" at level "LLT"
   And performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <SystemUser> | HEADACHES     | Closed       | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User   | Action          | Status              | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify      | Waiting Manual Code | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |                 | Completed           | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Browse And Code | Waiting Approval    | HEADACHES     |                                                                                                                 | <TimeStamp> |
   		| <User> | Open Query      | Waiting Manual Code | HEADACHES     |                                                                                                                 | <TimeStamp> |
   And the query status for task "HEADACHES" is "Closed"
  
@DFT
@PBMCC_205137_009
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205373
#Comment: Failing due to defect MCC-205391
Scenario: STUDY MIGRATION Study migrations shall cancel queries with "Open" status if the associated manually coded terms with "Waiting Approval" status are placed in a complete state due to synonyms to new terms

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the query for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   And task "HEADACHES" is coded to term "Haemoglobinuria" at search level "Low Level Term" with code "10018906" at level "LLT"
   And performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <User>       | HEADACHES     | Queued       |            |                |                    |             | <TimeStamp> |
		| <SystemUser> | HEADACHES     | Open         | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User   | Action          | Status              | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify      | Waiting Manual Code | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |                 | Completed           | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Browse And Code | Waiting Approval    | HEADACHES     |                                                                                                                 | <TimeStamp> |
   		| <User> | Open Query      | Waiting Manual Code | HEADACHES     |                                                                                                                 | <TimeStamp> |
   And the query status for task "HEADACHES" is "Queued"

@DFT
@PBMCC_205137_010
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205373
#Comment: Failing due to defect MCC-205391
Scenario: STUDY MIGRATION Study migrations shall cancel queries with "Answered" status if the associated manually coded terms with "Waiting Approval" status are placed in a complete state due to synonyms to new terms

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the query for new task "HEADACHES" with comment "Severity?" is "Answered" with response "Acute"
   And task "HEADACHES" is coded to term "Haemoglobinuria" at search level "Low Level Term" with code "10018906" at level "LLT"
   And performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <User>       | HEADACHES     | Queued       |            |                |                    |             | <TimeStamp> |
		| <SystemUser> | HEADACHES     | Answered     | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User   | Action          | Status              | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify      | Waiting Manual Code | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |                 | Completed           | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Browse And Code | Waiting Approval    | HEADACHES     |                                                                                                                 | <TimeStamp> |
   		| <User> | Open Query      | Waiting Manual Code | HEADACHES     |                                                                                                                 | <TimeStamp> |
   And the query status for task "HEADACHES" is "Queued"

@DFT
@PBMCC_205137_011
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205373
#Comment: Failing due to defect MCC-205391
Scenario: STUDY MIGRATION Study migrations shall not change the status of queries with "Cancelled" status if the associated manually coded terms with "Waiting Approval" status are placed in a complete state due to synonyms to new terms

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the query for new task "HEADACHES" with comment "Severity?" is "Cancelled" with response "Acute"
   And task "HEADACHES" is coded to term "Haemoglobinuria" at search level "Low Level Term" with code "10018906" at level "LLT"
   And performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <SystemUser> | HEADACHES     | Cancelled    | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User   | Action          | Status              | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify      | Waiting Manual Code | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |                 | Completed           | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Browse And Code | Waiting Approval    | HEADACHES     |                                                                                                                 | <TimeStamp> |
   		| <User> | Open Query      | Waiting Manual Code | HEADACHES     |                                                                                                                 | <TimeStamp> |
   And the query status for task "HEADACHES" is "Cancelled"
			
@DFT
@PBMCC_205137_012
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-205373
#Comment: Failing due to defect MCC-205391
Scenario: STUDY MIGRATION Study migrations shall not change the status of queries with "Closed" status if the associated manually coded terms with "Waiting Approval" status are placed in a complete state due to synonyms to new terms

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And a populated activated synonym list "MedDRA ENG 16.1 New_Primary_List" containing entry "HEADACHES|10000396|LLT|LLT:10000396;PT:10073767;HLT:10028381;HLGT:10028396;SOC:10010331|True|||"
   When the query for new task "HEADACHES" with comment "Severity?" is "Closed" with response "Acute"
   And task "HEADACHES" is coded to term "Haemoglobinuria" at search level "Low Level Term" with code "10018906" at level "LLT"
   And performing study migration
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <SystemUser> | HEADACHES     | Closed       | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User   | Action          | Status              | Verbatim Term | Comment                                                                                                         | Time Stamp  |
   		| <User> | Reclassify      | Waiting Manual Code | HEADACHES     | Reconfirm                                                                                                       | <TimeStamp> |
   		| <User> |                 | Completed           | HEADACHES     | Version Change - From MedDRA-16_0-English To MedDRA-16_1-English. Recoded due to synonym change across versions | <TimeStamp> |
   		| <User> | Browse And Code | Waiting Approval    | HEADACHES     |                                                                                                                 | <TimeStamp> |
   		| <User> | Open Query      | Waiting Manual Code | HEADACHES     |                                                                                                                 | <TimeStamp> |
   And the query status for task "HEADACHES" is "Closed"

@VAL
@PBMCC_205137_013
@Release2015.3.0
Scenario: STUDY MIGRATION Study migrations shall not change the status of queries with "Queued" status for associated terms with "Not Affected" migration impact status

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And an activated synonym list "MedDRA ENG 16.1 New_Primary_List"
   When I open a query for new task "HEADACHES" with comment "Severity?"
   And performing study migration
   Then the query status for task "HEADACHES" is "Queued"
   	
@VAL
@PBMCC_205137_014
@Release2015.3.0
Scenario Outline: STUDY MIGRATION Study migrations shall not change the status of queries for associated terms with "Not Affected" migration impact status

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 16.0 Empty_List" containing entry ""
   And an activated synonym list "MedDRA ENG 16.1 New_Primary_List"
   When the query for new task "HEADACHES" with comment "Severity?" is "<Query Status>" with response "Acute"
   And performing study migration
   Then the query status for task "HEADACHES" is "<Query Status>"
   
Examples:
  |Query Status |
  |Open         |
  |Answered     |
  |Closed       |
  |Cancelled    |
