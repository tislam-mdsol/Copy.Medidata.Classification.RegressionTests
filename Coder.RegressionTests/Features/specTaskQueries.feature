@specTaskQueries.feature
@CoderCore
Feature: This feature verifies Coder Task Query processing and display of information.

Actions Affecting Queries:
Coding Decisions
Study Migrations (In separate feature file: specTaskQueriesAfterStudyMigration.feature)
Query Responses
User Cancellation

Coder UI Elements Affected by Query Actions:
Task Grid Query Status
Task Grid Grouping
Task Grid Filtering
Task Grid Query Controls
Coding History Tab
Query History Tab
Coding History Report 

_ The following environment configuration settings were enabled:

   Empty Synonym Lists Registered:
   Synonym List 1: MedDRA              (ENG) 15.0      Primary 
   Synonym List 2: MedDRA              (ENG) 15.0      Initial_List
   Synonym List 3: JDrug               (JPN) 2013H1    Primary

   Common Configurations:   
   Basic                    
   Waiting Approval         

@VAL
@PBMCC_163356_001
@Release2015.3.0
Scenario: CANCEL Coder shall display a Queued status for an Open Query request until EDC accepts the request

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When I open a query for new task "HEADACHES" with comment "Severity?"
   Then the query status for task "HEADACHES" is "Queued"

@VAL
@PBMCC_163356_002
@Release2015.3.0
Scenario: CANCEL The Cancel Query option is available when the Query Status is Open
  
   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   Then the query for task "HEADACHES" can only be canceled
   And the query status for task "HEADACHES" is "Open"

@VAL
@PBMCC_163356_003
@Release2015.3.0
Scenario: CANCEL The Cancel Query option is available when the Query Status is Answered
  
   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHES" with comment "Severity?" is "Answered" with response "Acute"
   Then the query for task "HEADACHES" can only be canceled
   And the query status for task "HEADACHES" is "Answered"

@VAL
@PBMCC_163356_004
@Release2015.3.0
Scenario: CANCEL The Cancel Query option is not available when the Query status is Cancelled
  
   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHES" with comment "Severity?" is "Cancelled" with response "None"
   Then the query for task "HEADACHES" can only be opened
   And the query status for task "HEADACHES" is "Cancelled"

@VAL
@PBMCC_163356_005
@Release2015.3.0
Scenario: CANCEL The Cancel Query option is not available when the Query status is Closed
  
   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHES" with comment "Severity?" is "Closed" with response "Acute"
   Then the query for task "HEADACHES" can only be opened
   And the query status for task "HEADACHES" is "Closed"

@DFT
@PBMCC_163356_006
@Release2015.3.0
@ignore
#Comment: Failing due to defect MCC-195150
Scenario: CANCEL The Cancel Query option is not available when the task has no query status
  
   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "HEADACHES" for dictionary level "LLT"
   Then the query for task "HEADACHES" can only be opened
   And the query status for task "HEADACHES" is ""

@VAL
@PBMCC_163356_007
@Release2015.3.0
Scenario: CANCEL When canceling a query request Coder shall display a Queued status until it gets confirmation back from EDC

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   And I cancel the query for task "HEADACHES"
   Then the query status for task "HEADACHES" is "Queued"

@VAL
@PBMCC_163356_008
@Release2015.3.0
Scenario: CANCEL Upon EDC successfully accepting a cancelled request from Coder Coder shall display the Query status as Cancelled

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   And I cancel the query for task "HEADACHES"
   And the latest query for task "HEADACHES" is "Cancelled" with response "Ok"
   Then the query status for task "HEADACHES" is "Cancelled"
   And the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <SystemUser> | HEADACHES     | Cancelled    | Severity?  | Ok             | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       |            |                |                    |             | <TimeStamp> |
		| <SystemUser> | HEADACHES     | Open         | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   
@VAL
@PBMCC_163356_009
@Release2015.3.0
Scenario: QUERY HISTORY When a query Response is received by Coder the appropriate information shall be logged in the Query History tab

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHES" with comment "Severity?" is "Answered" with response "Acute"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <SystemUser> | HEADACHES     | Answered     | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |

@VAL
@PBMCC_163356_010
@Release2015.3.0
Scenario: QUERY HISTORY When a query Close response is received by Coder the appropriate information shall be logged in the Query History tab

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   And the latest query for task "HEADACHES" is "Closed" with response "Closing"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <SystemUser> | HEADACHES     | Closed       | Severity?  | Closing        | SystemMarkingGroup |             | <TimeStamp> |
		| <SystemUser> | HEADACHES     | Open         | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |

@VAL
@PBMCC_163356_011
@Release2015.3.0
Scenario: QUERY HISTORY When a query Cancel response is received by Coder the appropriate information shall be logged in the Query History tab

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   And the latest query for task "HEADACHES" is "Cancelled" with response "Cancelling"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
		| <SystemUser> | HEADACHES     | Cancelled    | Severity?  | Cancelling     | SystemMarkingGroup |             | <TimeStamp> |
		| <SystemUser> | HEADACHES     | Open         | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |

@VAL
@PBMCC_163356_012
@Release2015.3.0
Scenario: QUERY HISTORY When a markinggroup is received by Coder the appropriate information shall be logged in OpenTo column in the Query History tab

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query sent to marking group "Quality" for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To | Query Notes | Time Stamp  |
		| <SystemUser> | HEADACHES     | Open         | Severity?  | Acute          | Quality |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | Quality |             | <TimeStamp> |

@VAL
@PBMCC_163356_013
@Release2015.3.0
Scenario: QUERY HISTORY The Query History tab shall show the latest version of the verbatim under the Verbatim column

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the verbatim term for new task "HEADACHED" is changed to "HEADACHES"
   And the query for task "HEADACHES" with comment "Severity?" is "Cancelled" with response "Cancelling"
   Then the query history contains the following information
		| User         | Verbatim Term | Query Status | Query Text | Query Response | Open To | Query Notes | Time Stamp  |
		| <SystemUser> | HEADACHES     | Cancelled    | Severity?  | Cancelling     | SystemMarkingGroup     |             | <TimeStamp> |
		| <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup     |             | <TimeStamp> |

@VAL
@PBMCC_163356_014
@Release2015.3.0
@IncreaseTimeout_600000
Scenario: QUERY HISTORY The Coding and Query History Tables shall display supplemental and component information when the verbatim changes and a query is updated

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the verbatim term for new task "Blood Term"  with additional information is changed to "Blood Clotted"
   | SupplementalValues | ComponenetValues |
   | Head               | Person           |
   And the query for task "Blood Clotted" with comment "Where is the blood clot?" is "Open" with response "Investigating"
   And the latest query for task "Blood Clotted" is "Answered" with response "The blood was clotted right under the brain, a place between the neck and the brain."
   Then the query history contains the following information
		| User         | Verbatim Term                                                | Query Status | Query Text               | Query Response                                                                       | Open To            | Query Notes | Time Stamp  |
		| <SystemUser> | BLOOD CLOTTED(S) LOGSUPPFIELD1 : HEAD(S) TestDLCOID1 : PERSON | Answered     | Where is the blood clot? | The blood was clotted right under the brain, a place between the neck and the brain. | SystemMarkingGroup |             | <TimeStamp> |
		| <SystemUser> | BLOOD CLOTTED(S) LOGSUPPFIELD1 : HEAD(S) TestDLCOID1 : PERSON | Open         | Where is the blood clot? | Investigating                                                                        | SystemMarkingGroup |             | <TimeStamp> |
		| <User>       | BLOOD CLOTTED(S) LOGSUPPFIELD1 : HEAD(S) TestDLCOID1 : PERSON | Queued       | Where is the blood clot? |                                                                                      | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   		| User         | Action          | Status              | Verbatim Term                                                | Comment                                                                                                               | Time Stamp  |
   		| <User>       | Open Query      | Waiting Manual Code | BLOOD CLOTTED(S) LOGSUPPFIELD1 : HEAD(S) TestDLCOID1 : PERSON |                                                                                                                       | <TimeStamp> |
   		| <SystemUser> | Start Auto Code | Waiting Manual Code | BLOOD CLOTTED(S) LOGSUPPFIELD1 : HEAD(S) TestDLCOID1 : PERSON |                                                                                                                       | <TimeStamp> |
   		| <SystemUser> |                 | Start               | BLOOD CLOTTED(S) LOGSUPPFIELD1 : HEAD(S) TestDLCOID1 : PERSON | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=True,IsAutoApproval=True,IsBypassTransmit=True] | <TimeStamp> |
   		| <SystemUser> |                 | Start               | BLOOD CLOTTED(S) LOGSUPPFIELD1 : HEAD(S) TestDLCOID1 : PERSON | Field 'Verbatim' with old text of 'Blood Term' has now changed to text of 'Blood Clotted'                             | <TimeStamp> |
   		| <SystemUser> | Start Auto Code | Waiting Manual Code | BLOOD TERM(S) LOGSUPPFIELD1 : HEAD(S) TestDLCOID1 : PERSON    |                                                                                                                       | <TimeStamp> |
   		| <SystemUser> |                 | Start               | BLOOD TERM(S) LOGSUPPFIELD1 : HEAD(S) TestDLCOID1 : PERSON    | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=True,IsAutoApproval=True,IsBypassTransmit=True] | <TimeStamp> |
      
@VAL
@PBMCC_163356_015
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: CODING When a manually coded decision for a verbatim with a Query status of Open is approved Coder shall display a Queued query status and accept the coding decision approval

   Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   And task "HEADACHES" is coded to term "Acute migraine" at search level "Low Level Term" with code "10066635" at level "LLT" and the coding decision is manually approved
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   And exporting the Coding History Report for term "HEADACHES" with export columns "ALL"
   Then the Coding History Report should contain the following
	  | Verbatim Term | User        | Action          | System Action | Query Status | Query Text | Query Response | Query Notes |
	  | HEADACHES     | System User |                 |               |              |            |                |             |
	  | HEADACHES     | System User | Start Auto Code |               |              |            |                |             |
	  | HEADACHES     | <User>      | Open Query      | Open Query    |              |            |                |             |
	  | HEADACHES     | <User>      |                 |               | Queued       | Severity?  |                |             |
	  | HEADACHES     | System User |                 |               | Open         | Severity?  | Acute          |             |
	  | HEADACHES     | <User>      |                 |               | Queued       |            |                |             |
	  | HEADACHES     | <User>      | Browse and Code | Manual Coding |              |            |                |             |
   And the query history contains the following information
	  | User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
	  | <User>       | HEADACHES     | Queued       |            |                |                    |             | <TimeStamp> |
	  | <SystemUser> | HEADACHES     | Open         | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
	  | <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   	  | User   | Action                        | Status               | Verbatim Term | Comment                    | Time Stamp  |
   	  | <User> | Reclassify                    | Reconsider           | HEADACHES     | Reconfirm                  | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Completed            | HEADACHES     | Transmission Queue Number: | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Waiting Transmission | HEADACHES     | Cancel Query On Transmit:  | <TimeStamp> |
   And the query status for task "HEADACHES" is "Queued"

@VAL
@PBMCC_163356_016
@Release2015.3.0
Scenario: CODING When an auto-coded direct dictionary matching decision for a verbatim with a Query status of Open is approved Coder shall display a Queued query status and accept the coding decision approval

   Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHE" with comment "Severity?" is "Open" with response "Acute"
   And approving task "HEADACHE"
   And reclassifying task "HEADACHE" with comment "Reconfirm"
   And exporting the Coding History Report for term "HEADACHE" with export columns "ALL"
   Then the Coding History Report should contain the following
	  | Verbatim Term | User        | Action          | System Action  | Query Status | Query Text | Query Response | Query Notes |
	  | HEADACHE      | System User |                 |                |              |            |                |             |
	  | HEADACHE      | System User | Start Auto Code | Auto Coding    |              |            |                |             |
	  | HEADACHE      | <User>      | Open Query      | Open Query     |              |            |                |             |
	  | HEADACHE      | <User>      |                 |                | Queued       | Severity?  |                |             |
	  | HEADACHE      | System User |                 |                | Open         | Severity?  | Acute          |             |
	  | HEADACHE      | <User>      |                 |                | Queued       |            |                |             |
	  | HEADACHE      | <User>      | Approve         | Approve Coding |              |            |                |             |
   And the query history contains the following information
	  | User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
	  | <User>       | HEADACHE      | Queued       |            |                |                    |             | <TimeStamp> |
	  | <SystemUser> | HEADACHE      | Open         | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
	  | <User>       | HEADACHE      | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   	  | User   | Action                        | Status               | Verbatim Term | Comment                    | Time Stamp  |
   	  | <User> | Reclassify                    | Reconsider           | HEADACHE      | Reconfirm                  | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Completed            | HEADACHE      | Transmission Queue Number: | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Waiting Transmission | HEADACHE      | Cancel Query On Transmit:  | <TimeStamp> |
   And the query status for task "HEADACHE" is "Queued"

@VAL
@PBMCC_163356_017
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: CODING When an auto-coded by synonym coding decision for a verbatim with a Query status of Open is approved Coder shall display a Queued query status and accept the coding decision approval

   Given a "Waiting Approval" Coder setup with registered synonym list "MedDRA ENG 15.0 Initial_List" containing entry "HEADACHES|10066635|LLT|LLT:10066635;PT:10027599;HLT:10027603;HLGT:10019231;SOC:10029205|True||Approved|Acute migraine"
   When the query for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   And approving task "HEADACHES"
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   And exporting the Coding History Report for term "HEADACHES" with export columns "ALL"
   Then the Coding History Report should contain the following
	  | Verbatim Term | User        | Action          | System Action  | Query Status | Query Text | Query Response | Query Notes |
	  | HEADACHES     | System User |                 |                |              |            |                |             |
	  | HEADACHES     | System User | Start Auto Code | Auto Coding    |              |            |                |             |
	  | HEADACHES     | <User>      | Open Query      | Open Query     |              |            |                |             |
	  | HEADACHES     | <User>      |                 |                | Queued       | Severity?  |                |             |
	  | HEADACHES     | System User |                 |                | Open         | Severity?  | Acute          |             |
	  | HEADACHES     | <User>      |                 |                | Queued       |            |                |             |
	  | HEADACHES     | <User>      | Approve         | Approve Coding |              |            |                |             |
   And the query history contains the following information
	  | User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
	  | <User>       | HEADACHES     | Queued       |            |                |                    |             | <TimeStamp> |
	  | <SystemUser> | HEADACHES     | Open         | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
	  | <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   	  | User   | Action                        | Status               | Verbatim Term | Comment                    | Time Stamp  |
   	  | <User> | Reclassify                    | Reconsider           | HEADACHES     | Reconfirm                  | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Completed            | HEADACHES     | Transmission Queue Number: | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Waiting Transmission | HEADACHES     | Cancel Query On Transmit:  | <TimeStamp> |
   And the query status for task "HEADACHES" is "Queued"

@VAL
@PBMCC_163356_018
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: CODING When a manually coded decision for a verbatim with a Query status of Answered is approved Coder shall display a Queued query status and accept the coding decision approval

   Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHES" with comment "Severity?" is "Answered" with response "Acute"
   And task "HEADACHES" is coded to term "Acute migraine" at search level "Low Level Term" with code "10066635" at level "LLT" and the coding decision is manually approved
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   And exporting the Coding History Report for term "HEADACHES" with export columns "ALL"
   Then the Coding History Report should contain the following
	  | Verbatim Term | User        | Action          | System Action | Query Status | Query Text | Query Response | Query Notes |
	  | HEADACHES     | System User |                 |               |              |            |                |             |
	  | HEADACHES     | System User | Start Auto Code |               |              |            |                |             |
	  | HEADACHES     | <User>      | Open Query      | Open Query    |              |            |                |             |
	  | HEADACHES     | <User>      |                 |               | Queued       | Severity?  |                |             |
	  | HEADACHES     | System User |                 |               | Answered     | Severity?  | Acute          |             |
	  | HEADACHES     | <User>      |                 |               | Queued       |            |                |             |
	  | HEADACHES     | <User>      | Browse and Code | Manual Coding |              |            |                |             |
   And the query history contains the following information
	  | User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
	  | <User>       | HEADACHES     | Queued       |            |                |                    |             | <TimeStamp> |
	  | <SystemUser> | HEADACHES     | Answered     | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
	  | <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   	  | User   | Action                        | Status               | Verbatim Term | Comment                    | Time Stamp  |
   	  | <User> | Reclassify                    | Reconsider           | HEADACHES     | Reconfirm                  | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Completed            | HEADACHES     | Transmission Queue Number: | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Waiting Transmission | HEADACHES     | Cancel Query On Transmit:  | <TimeStamp> |
   And the query status for task "HEADACHES" is "Queued"

@VAL
@PBMCC_163356_019
@Release2015.3.0
Scenario: CODING When an auto-coded direct dictionary matching decision for a verbatim with a Query status of Answered is approved Coder shall display a Queued query status and accept the coding decision approval

   Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When the query for new task "HEADACHE" with comment "Severity?" is "Answered" with response "Acute"
   And approving task "HEADACHE"
   And reclassifying task "HEADACHE" with comment "Reconfirm"
   And exporting the Coding History Report for term "HEADACHE" with export columns "ALL"
   Then the Coding History Report should contain the following
	  | Verbatim Term | User        | Action          | System Action  | Query Status | Query Text | Query Response | Query Notes |
	  | HEADACHE      | System User |                 |                |              |            |                |             |
	  | HEADACHE      | System User | Start Auto Code | Auto Coding    |              |            |                |             |
	  | HEADACHE      | <User>      | Open Query      | Open Query     |              |            |                |             |
	  | HEADACHE      | <User>      |                 |                | Queued       | Severity?  |                |             |
	  | HEADACHE      | System User |                 |                | Answered     | Severity?  | Acute          |             |
	  | HEADACHE      | <User>      |                 |                | Queued       |            |                |             |
	  | HEADACHE      | <User>      | Approve         | Approve Coding |              |            |                |             |
   And the query history contains the following information
	  | User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
	  | <User>       | HEADACHE      | Queued       |            |                |                    |             | <TimeStamp> |
	  | <SystemUser> | HEADACHE      | Answered     | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
	  | <User>       | HEADACHE      | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   	  | User   | Action                        | Status               | Verbatim Term | Comment                    | Time Stamp  |
   	  | <User> | Reclassify                    | Reconsider           | HEADACHE      | Reconfirm                  | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Completed            | HEADACHE      | Transmission Queue Number: | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Waiting Transmission | HEADACHE      | Cancel Query On Transmit:  | <TimeStamp> |
   And the query status for task "HEADACHE" is "Queued"

@VAL
@PBMCC_163356_020
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: CODING When an auto-coded by synonym coding decision for a verbatim with a Query status of Answered is approved Coder shall display a Queued query status and accept the coding decision approval

   Given a "Waiting Approval" Coder setup with registered synonym list "MedDRA ENG 15.0 Initial_List" containing entry "HEADACHES|10066635|LLT|LLT:10066635;PT:10027599;HLT:10027603;HLGT:10019231;SOC:10029205|True||Approved|Acute migraine"
   When the query for new task "HEADACHES" with comment "Severity?" is "Answered" with response "Acute"
   And approving task "HEADACHES"
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   And exporting the Coding History Report for term "HEADACHES" with export columns "ALL"
   Then the Coding History Report should contain the following
	  | Verbatim Term | User        | Action          | System Action  | Query Status | Query Text | Query Response | Query Notes |
	  | HEADACHES     | System User |                 |                |              |            |                |             |
	  | HEADACHES     | System User | Start Auto Code | Auto Coding    |              |            |                |             |
	  | HEADACHES     | <User>      | Open Query      | Open Query     |              |            |                |             |
	  | HEADACHES     | <User>      |                 |                | Queued       | Severity?  |                |             |
	  | HEADACHES     | System User |                 |                | Answered     | Severity?  | Acute          |             |
	  | HEADACHES     | <User>      |                 |                | Queued       |            |                |             |
	  | HEADACHES     | <User>      | Approve         | Approve Coding |              |            |                |             |
   And the query history contains the following information
	  | User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
	  | <User>       | HEADACHES     | Queued       |            |                |                    |             | <TimeStamp> |
	  | <SystemUser> | HEADACHES     | Answered     | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
	  | <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   	  | User   | Action                        | Status               | Verbatim Term | Comment                    | Time Stamp  |
   	  | <User> | Reclassify                    | Reconsider           | HEADACHES     | Reconfirm                  | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Completed            | HEADACHES     | Transmission Queue Number: | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Waiting Transmission | HEADACHES     | Cancel Query On Transmit:  | <TimeStamp> |
   And the query status for task "HEADACHES" is "Queued"

@VAL
@PBMCC_163356_021
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: CODING When a manually coded decision for a verbatim with a Query status of Open is approved for J-Drug Coder shall display a Queued query status and accept the coding decision approval

   Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "JDrug JPN 2013H1"
   When the query for new task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   And task "HEADACHES" is coded to term "コカイン塩酸塩" at search level "DrugName" with code "8121700" at level "薬" and the coding decision is manually approved
   And reclassifying task "HEADACHES" with comment "Reconfirm"
   And exporting the Coding History Report for term "HEADACHES" with export columns "ALL"
   Then the Coding History Report should contain the following
	  | Verbatim Term | User        | Action          | System Action | Query Status | Query Text | Query Response | Query Notes |
	  | HEADACHES     | System User |                 |               |              |            |                |             |
	  | HEADACHES     | System User | Start Auto Code |               |              |            |                |             |
	  | HEADACHES     | <User>      | Open Query      | Open Query    |              |            |                |             |
	  | HEADACHES     | <User>      |                 |               | Queued       | Severity?  |                |             |
	  | HEADACHES     | System User |                 |               | Open         | Severity?  | Acute          |             |
	  | HEADACHES     | <User>      |                 |               | Queued       |            |                |             |
	  | HEADACHES     | <User>      | Browse and Code | Manual Coding |              |            |                |             |
   And the query history contains the following information
	  | User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
	  | <User>       | HEADACHES     | Queued       |            |                |                    |             | <TimeStamp> |
	  | <SystemUser> | HEADACHES     | Open         | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
	  | <User>       | HEADACHES     | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   	  | User   | Action                        | Status               | Verbatim Term | Comment                    | Time Stamp  |
   	  | <User> | Reclassify                    | Reconsider           | HEADACHES     | Reconfirm                  | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Completed            | HEADACHES     | Transmission Queue Number: | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Waiting Transmission | HEADACHES     | Cancel Query On Transmit:  | <TimeStamp> |
   And the query status for task "HEADACHES" is "Queued"

@VAL
@PBMCC_163356_022
@Release2015.3.0
Scenario: CODING When an auto-coded direct dictionary matching decision for a verbatim with a Query status of Answered is approved for J-Drug Coder shall display a Queued query status and accept the coding decision approval

   Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "JDrug JPN 2013H1"
   When the query for new task "コカイン塩酸塩" with comment "Severity?" is "Answered" with response "Acute"
   And approving task "コカイン塩酸塩"
   And reclassifying task "コカイン塩酸塩" with comment "Reconfirm"
   And exporting the Coding History Report for term "コカイン塩酸塩" with export columns "ALL"
   Then the Coding History Report should contain the following
	  | Verbatim Term       | User        | Action          | System Action  | Query Status | Query Text | Query Response | Query Notes |
	  | コカイン塩酸塩       | System User |                 |                |              |            |                |             |
	  | コカイン塩酸塩       | System User | Start Auto Code | Auto Coding    |              |            |                |             |
	  | コカイン塩酸塩       | <User>      | Open Query      | Open Query     |              |            |                |             |
	  | コカイン塩酸塩       | <User>      |                 |                | Queued       | Severity?  |                |             |
	  | コカイン塩酸塩       | System User |                 |                | Answered     | Severity?  | Acute          |             |
	  | コカイン塩酸塩       | <User>      |                 |                | Queued       |            |                |             |
	  | コカイン塩酸塩       | <User>      | Approve         | Approve Coding |              |            |                |             |
   And the query history contains the following information
	  | User         | Verbatim Term | Query Status | Query Text | Query Response | Open To            | Query Notes | Time Stamp  |
	  | <User>       | コカイン塩酸塩       | Queued       |            |                |                    |             | <TimeStamp> |
	  | <SystemUser> | コカイン塩酸塩       | Answered     | Severity?  | Acute          | SystemMarkingGroup |             | <TimeStamp> |
	  | <User>       | コカイン塩酸塩       | Queued       | Severity?  |                | SystemMarkingGroup |             | <TimeStamp> |
   And the Coding History contains following information
   	  | User   | Action                        | Status               | Verbatim Term | Comment                    | Time Stamp  |
   	  | <User> | Reclassify                    | Reconsider           | コカイン塩酸塩 | Reconfirm                  | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Completed            | コカイン塩酸塩 | Transmission Queue Number: | <TimeStamp> |
   	  | <User> | Complete Without Transmission | Waiting Transmission | コカイン塩酸塩 | Cancel Query On Transmit:  | <TimeStamp> |
   And the query status for task "コカイン塩酸塩" is "Queued"

@VAL
@PBMCC_163356_023
@Release2015.3.0
@IncreaseTimeout_600000
Scenario: REPORT The Query History Information shall not be displayed in the report if Include Query Fields is not selected as an Export Column

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "EMPTY" for dictionary level "LLT"
   When I open a query for new task "FLUS" with comment "Epidemic?"
   And the query for new task "OPEN WOUNDED" with comment "Size?" is "Open" with response "Small"
   And the query for new task "PAINS" with comment "Many?" is "Answered" with response "A lot"
   And the query for new task "HEADACHES" with comment "Severity?" is "Cancelled" with response "Acute"
   And the query for new task "CLOTHES" with comment "Is this a typo?" is "Closed" with response "Yes"  
   And exporting the Coding History Report with export columns "None"  
   Then the Coding History Report includes no query history information

@VAL
@PBMCC_163356_024
@Release2015.3.0
@IncreaseTimeout_600000
Scenario: REPORT The Query History Information shall be displayed in the report if Include Query Fields is selected as an Export Column

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "EMPTY" for dictionary level "LLT"
   When I open a query for new task "FLUS" with comment "Epidemic?"
   And the query for new task "OPEN WOUNDED" with comment "Size?" is "Open" with response "Small"
   And the query for new task "PAINS" with comment "Many?" is "Answered" with response "A lot"
   And the query for new task "HEADACHES" with comment "Severity?" is "Cancelled" with response "Acute"
   And the query for new task "CLOTHES" with comment "Is this a typo?" is "Closed" with response "Yes"   
   And exporting the Coding History Report with export columns "ALL"
   Then the Coding History Report should contain the following
	  | Verbatim Term | User        | Action          | System Action | Query Status | Query Text      | Query Response | Query Notes |
	  | EMPTY         | System User |                 |               |              |                 |                |             |
	  | EMPTY         | System User | Start Auto Code |               |              |                 |                |             |
	  | FLUS          | System User |                 |               |              |                 |                |             |
	  | FLUS          | System User | Start Auto Code |               |              |                 |                |             |
	  | FLUS          | <User>      | Open Query      | Open Query    |              |                 |                |             |
	  | FLUS          | <User>      |                 |               | Queued       | Epidemic?       |                |             |
	  | OPEN WOUNDED  | System User |                 |               |              |                 |                |             |
	  | OPEN WOUNDED  | System User | Start Auto Code |               |              |                 |                |             |
	  | OPEN WOUNDED  | <User>      | Open Query      | Open Query    |              |                 |                |             |
	  | OPEN WOUNDED  | <User>      |                 |               | Queued       | Size?           |                |             |
	  | OPEN WOUNDED  | System User |                 |               | Open         | Size?           | Small          |             |
	  | PAINS         | System User |                 |               |              |                 |                |             |
	  | PAINS         | System User | Start Auto Code |               |              |                 |                |             |
	  | PAINS         | <User>      | Open Query      | Open Query    |              |                 |                |             |
	  | PAINS         | <User>      |                 |               | Queued       | Many?           |                |             |
	  | PAINS         | System User |                 |               | Answered     | Many?           | A lot          |             |
	  | HEADACHES     | System User |                 |               |              |                 |                |             |
	  | HEADACHES     | System User | Start Auto Code |               |              |                 |                |             |
	  | HEADACHES     | <User>      | Open Query      | Open Query    |              |                 |                |             |
	  | HEADACHES     | <User>      |                 |               | Queued       | Severity?       |                |             |
	  | HEADACHES     | System User |                 |               | Cancelled    | Severity?       | Acute          |             |
	  | CLOTHES       | System User |                 |               |              |                 |                |             |
	  | CLOTHES       | System User | Start Auto Code |               |              |                 |                |             |
	  | CLOTHES       | <User>      | Open Query      | Open Query    |              |                 |                |             |
	  | CLOTHES       | <User>      |                 |               | Queued       | Is this a typo? |                |             |
	  | CLOTHES       | System User |                 |               | Closed       | Is this a typo? | Yes            |             |

@DFT
@PBMCC_163356_025
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-195150
Scenario: FILTER User can filter Queries by Open Answered Cancelled Closed Queued and All

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "EMPTY" for dictionary level "LLT"
   When I open a query for new task "FLUS" with comment "Epidemic?"
   And the query for new task "OPEN WOUNDED" with comment "Size?" is "Open" with response "Small"
   And the query for new task "PAINS" with comment "Many?" is "Answered" with response "A lot"
   And the query for new task "HEADACHES" with comment "Severity?" is "Cancelled" with response "Acute"
   And the query for new task "CLOTHES" with comment "Is this a typo?" is "Closed" with response "Yes"
   And all task filters are cleared
   And I filter for tasks with "Queries" of "Queued"
   Then Only tasks with "Queries" of "Queued" will be displayed
   When I filter for tasks with "Queries" of "Open"
   Then Only tasks with "Queries" of "Open" will be displayed
   When I filter for tasks with "Queries" of "Answered"
   Then Only tasks with "Queries" of "Answered" will be displayed
   When I filter for tasks with "Queries" of "Cancelled"
   Then Only tasks with "Queries" of "Cancelled" will be displayed
   When I filter for tasks with "Queries" of "Closed"
   Then Only tasks with "Queries" of "Closed" will be displayed
   When I filter for tasks with "Queries" of "All"
   Then the coding task table has the following ordered information
       | Verbatim Term | Queries   |
       | EMPTY         |           |
       | FLUS          | Queued    |
       | OPEN WOUNDED  | Open      |
       | PAINS         | Answered  |
       | HEADACHES     | Cancelled |
       | CLOTHES       | Closed    |

@VAL
@PBMCC_163356_026
@Release2015.3.0
@IncreaseTimeout_420000
Scenario: GROUPING Verbatims shall be grouped by query and workflow status

   Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding tasks "HEADACHES, HEADACHES, HEADACHES, PAINS, PAINS, CLOTHES, CLOTHES, CLOTHES, CLOTHES"
   When the query for task "HEADACHES" with comment "Severity?" is "Open" with response "Acute"
   And the query for task "PAINS" with comment "Many?" is "Answered" with response "A lot"
   And the query for task "CLOTHES" with comment "Is this a typo?" is "Closed" with response "Yes"
   Then the coding task table has the following ordered information
       | Verbatim Term | Group | Queries  |
       | CLOTHES       | 3     | Queued   |
       | CLOTHES       | 1     | Closed   |
       | HEADACHES     | 2     | Queued   |
       | HEADACHES     | 1     | Open     |
       | PAINS         | 1     | Queued   |
       | PAINS         | 1     | Answered |
   When the first task "CLOTHES" in group "3" is coded to term "Acute migraine" at search level "Low Level Term" with code "10066635" at level "LLT"
   When all task filters are cleared
   Then the coding task table has the following ordered information
       | Verbatim Term | Group | Status              | Queries  |
       | CLOTHES       | 2     | Waiting Manual Code | Queued   |
       | CLOTHES       | 1     | Waiting Manual Code | Closed   |
       | CLOTHES       | 1     | Waiting Approval    | Queued   |
       | HEADACHES     | 2     | Waiting Manual Code | Queued   |
       | HEADACHES     | 1     | Waiting Manual Code | Open     |
       | PAINS         | 1     | Waiting Manual Code | Queued   |
       | PAINS         | 1     | Waiting Manual Code | Answered |
