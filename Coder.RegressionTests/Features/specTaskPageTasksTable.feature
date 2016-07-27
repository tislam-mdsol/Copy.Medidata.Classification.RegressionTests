@specTaskPageTasksTable.feature
@CoderCore
Feature: This feature will verify that Coder will display and manipulate tasks in the Task Table. 
This feature file uses data in CSV files located in DynamicCSVReports and the ODMFileBuilder to 
load multiple tasks to two studies, each with a different dictionary.

_ The following Task attributes are needed to be available to the client in order to obtain information about a term:

	Task Attributes 
	_______________________________ 
	Verbatim Term
	Priority
	Status
	Assigned Term
	Dictionary
	Queries           
	Segment                             

  Verbatim Term: (Set in CSV) The verbatim text.
  Priority: (Set in CSV) [1_255] Priority is defined in Rave and can represent a "true" priority or can be a way to subset source data types. Priority is defined on the form level. For example, all Rave Adverse Events (AE) forms can be set to Priority 2, Rave Conmeds Priority 3, and Rave Medical History Terms Priority 4. You can also have all AEs, Conmeds, and Medical History Terms for one study set to Priority 1, and all AEs, Conmeds, and Medical History Terms for another study set to Priority 2. This number displays in the Task page in Coder for any verbatim term entered in this form. For example, if AE form =1, and the verbatim term "headache" is entered in this form, this number displays in the Task page for this verbatim term. Tip: The Priority field can be used to search for a form in Coder. This is a good way to determine what form the data is from. Make sure you are consistent with your numbering.
  Status: The status of the coding operation; for example, Waiting Approval.
  Assigned Term: The text of the coded term. This will only appear to non-approver users if the task has been reclassified and is Waiting Manual Code. 
  Dictionary: (Set in CSV) The dictionary assigned to the segment.
  Queries:	Status of the query: Queued, Open, Answered, Closed, or Canceled
  Segment: (Set in CSV) This refers to the client division/segment that contains coding data from a collection of studies; a Segment can be equated to an iMedidata Study Group which contains these studies.

_ Reference the coding help information residing in:
   https://learn.mdsol.com/display/CODERstg/Viewing+Coder+Transaction+Details+While+Coding?lang=en


_ The following environment configuration settings were enabled:

   Empty Synonym Lists Registered:
   Synonym List 1: MedDRA              (ENG) 15.0     Primary List
   Synonym List 2: WhoDrugDDEB2        (ENG) 201503   Primary List
   Synonym List 3: MedDRA              (ENG) 14.0     Empty_List
   Synonym List 4: MedDRA              (ENG) 15.0     New_Primary_List

   Common Configurations:
   Configuration Name       | Declarative Browser Class | 
   Basic                    | BasicSetup                | 
   Waiting Approval         | WaitingApprovalSetup      | 

@VAL
@PBMCC_191152_001
@Release2015.3.0
Scenario: SORT The task table shall sort in descending order by verbatim term when the verbatim term column header is clicked

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  And I sort the tasks by "Verbatim Term" "descending"
  Then the tasks will be sorted by "Verbatim Term" "descending"

@VAL
@PBMCC_191152_002
@Release2015.3.0
Scenario: SORT The task table shall sort in ascending order by verbatim term when the verbatim term column header is clicked

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  And I sort the tasks by "Verbatim Term" "ascending"
  Then the tasks will be sorted by "Verbatim Term" "ascending"

@VAL
@PBMCC_191152_003
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: SORT The task table shall sort in descending order by assigned term when the assigned term column header is clicked

  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  And task "ECHO" is coded to term "Echo virus infection NOS" at search level "Low Level Term" with code "10014112" at level "LLT"
  And task "GULF" is coded to term "Gulf war syndrome" at search level "Low Level Term" with code "10056557" at level "LLT"
  And task "SIERRA" is coded to term "Feeling of residual sleepiness" at search level "Low Level Term" with code "10016353" at level "LLT"
  And reclassifying task "ECHO" with a comment "Reclassify ECHO to populate Assigned Term column." and Include Autocoded Items set to "True"
  And reclassifying task "GULF" with a comment "Reclassify GULF to populate Assigned Term column." and Include Autocoded Items set to "True"
  And reclassifying task "SIERRA" with a comment "Reclassify SIERRA to populate Assigned Term column." and Include Autocoded Items set to "True"
  And all task filters are cleared
  And I sort the tasks by "Assigned Term" "descending"
  Then the tasks will be sorted by "Assigned Term" "descending"

@VAL
@PBMCC_191152_004
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: SORT The task table shall sort in ascending order by assigned term when the assigned term column header is clicked

  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  And task "ECHO" is coded to term "Echo virus infection NOS" at search level "Low Level Term" with code "10014112" at level "LLT"
  And task "GULF" is coded to term "Gulf war syndrome" at search level "Low Level Term" with code "10056557" at level "LLT"
  And task "SIERRA" is coded to term "Feeling of residual sleepiness" at search level "Low Level Term" with code "10016353" at level "LLT"
  And reclassifying task "ECHO" with a comment "Reclassify ECHO to populate Assigned Term column." and Include Autocoded Items set to "True"
  And reclassifying task "GULF" with a comment "Reclassify GULF to populate Assigned Term column." and Include Autocoded Items set to "True"
  And reclassifying task "SIERRA" with a comment "Reclassify SIERRA to populate Assigned Term column." and Include Autocoded Items set to "True"
  And all task filters are cleared
  And I sort the tasks by "Assigned Term" "ascending"
  Then the tasks will be sorted by "Assigned Term" "ascending"

@VAL
@PBMCC_191152_005
@Release2015.3.0
Scenario: FILTER The task table shall show all actionable tasks when Task View is selected as the filter criteria

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  And I limit the displayed tasks by
       | Filter Name            | Filter Criteria        |
       | Trackables             | Task View (actionable) |
  Then Only tasks with "Status" of "Waiting Manual Code" will be displayed
  And The task count is "30"

@VAL
@PBMCC_191152_006
@Release2015.3.0
Scenario: FILTER The task table shall show no actionable tasks when In Workflow is selected as the filter criteria

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  And I limit the displayed tasks by
       | Filter Name            | Filter Criteria              |
       | Trackables             | In Workflow (non-actionable) |
  Then The task count is "0"

@VAL
@PBMCC_191152_007
@Release2015.3.0
Scenario: FILTER The task table shall show only the tasks associated with the Dev study when selected as the filter criteria
  
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  And I limit the displayed tasks by
       | Filter Name | Filter Criteria |
       | Studies     | Dev             |
  Then the tasks will be filtered by 
       | Column Name  | Filter Criteria                      |
       | Priority     | 2                                    |
       | Dictionary   | WhoDrugDDEB2 - 201503 - Primary List |
  And The task count is "11"

@VAL
@PBMCC_191152_008
@Release2015.3.0
@IncreaseTimeout_3000000
Scenario: FILTER The task table shall show only the tasks in Study Migration when selected as the filter criteria
  
  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 14.0 Empty_List" containing entry ""
  And an activated synonym list "MedDRA ENG 15.0 New_Primary_List"
  When the following externally managed verbatim requests are made "Tasks_1000_MedDRA_Match_Upload.csv" and auto-coding in progress
  And  I limit the displayed tasks by
       | Filter Name            | Filter Criteria                        |
       | Trackables             | In Study Migration (non-actionable)    |	
  Then The task count is "0"
  When performing study migration without waiting
  Then The task count is not "0"
	   
@VAL
@PBMCC_191152_009
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: FILTER The task table shall show only the tasks in the Workflow when selected as the filter criteria

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 201503"
  When the following externally managed verbatim requests are made "Tasks_1500_SingleStudy_NoSup_SingleDict.csv" and auto-coding in progress
  And The system "In Workflow (non-actionable)" count is at least "1" percent of all tasks
  And I limit the displayed tasks by
       | Filter Name            | Filter Criteria                     |
       | Trackables             | In Workflow (non-actionable)        |	
  Then The task count is not "0"
  And Only tasks with "Status" of "Start" will be displayed and the queue will empty

@VAL
@PBMCC_191152_010
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: FILTER The task table shall show only the tasks not in the Workflow when selected as the filter criteria

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 201503"
  When the following externally managed verbatim requests are made "Tasks_1500_SingleStudy_NoSup_SingleDict.csv" and auto-coding in progress
  And The system "Not In Workflow (non-actionable)" count is at least "1" percent of all tasks
  And I limit the displayed tasks by
       | Filter Name            | Filter Criteria                     |
       | Trackables             | Not In Workflow (non-actionable)    |	
  Then The task count is not "0"
  And Only tasks with "Status" of "Start" will be displayed and the queue will empty

@VAL
@PBMCC_191152_011
@Release2015.3.0
Scenario: FILTER HEADER The task table shall filter by priority

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  And I filter for tasks with "Priority" of "2"
  Then Only tasks with "Priority" of "2" will be displayed
  
@VAL
@PBMCC_191152_012
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: FILTER HEADER The task table shall filter by status

  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When task "ECHO" is coded to term "Echo virus infection NOS" at search level "Low Level Term" with code "10014112" at level "LLT"
  And task "GULF" is coded to term "Gulf war syndrome" at search level "Low Level Term" with code "10056557" at level "LLT"
  And task "SIERRA" is coded to term "Feeling of residual sleepiness" at search level "Low Level Term" with code "10016353" at level "LLT"
  And reclassifying task "ECHO" with a comment "Reclassify ECHO to populate Assigned Term column." and Include Autocoded Items set to "True"
  And reclassifying task "GULF" with a comment "Reclassify GULF to populate Assigned Term column." and Include Autocoded Items set to "True"
  And reclassifying task "SIERRA" with a comment "Reclassify SIERRA to populate Assigned Term column." and Include Autocoded Items set to "True"
  And all task filters are cleared
  And I filter for tasks with "Status" of "Reconsider"
  Then Only tasks with "Status" of "Reconsider" will be displayed

@VAL
@PBMCC_191152_013
@Release2015.3.0
Scenario: FILTER HEADER The task table shall filter by Dictionary MedDRA

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When I filter for tasks with "Dictionary" of "MedDRA - 15.0 - Primary List"
  Then Only tasks with "Dictionary" of "MedDRA - 15.0 - Primary List" will be displayed
  

@VAL
@PBMCC_191152_014
@Release2015.3.0
Scenario: FILTER HEADER The task table shall filter by Dictionary WhoDrugDDEB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When I filter for tasks with "Dictionary" of "WhoDrugDDEB2 - 201503 - Primary List"
  Then Only tasks with "Dictionary" of "WhoDrugDDEB2 - 201503 - Primary List" will be displayed

@DFT
@PBMCC_191152_015
@Release2015.3.0
@IncreaseTimeout_300000
@ignore
#comment Failing due to defect MCC-195150
Scenario: FILTER HEADER The task table shall filter by Queries
  
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When I open a query for task "CHARLIE" with comment "Query Sort Test Alpha"
  And I open a query for task "HOTEL" with comment "Query Sort Test Alpha"
  And I open a query for task "YANKEE" with comment "Query Sort Test Alpha"
  And I open a query for task "DELTA" with comment "Query Sort Test Alpha"
  And I open a query for task "ALPHA AMBER" with comment "Query Sort Test Bravo"
  And I open a query for task "SIERRA" with comment "Query Sort Test Bravo"
  And all task filters are cleared
  And I filter for tasks with "Queries" of "Queued"
  Then Only tasks with "Queries" of "Queued" will be displayed

@VAL
@PBMCC_159410_001
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: FILTER HEADER The task table shall filter by Time Elapsed
  
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  When the following externally managed verbatim requests are made
		| Verbatim Term | Dictionary Level |
		| ALPHA         | LLT              |
		| BRAVO         | LLT              |
		| CHARLIE       | LLT              |
		| DELTA         | LLT              |
		| ECHO          | LLT              |
		| FOXTROT       | LLT              |
  And the time elapsed since task "BRAVO" was created is "0" days and "15" hours
  And the time elapsed since task "CHARLIE" was created is "1" days and "1" hours
  And the time elapsed since task "DELTA" was created is "3" days and "0" hours
  And the time elapsed since task "ECHO" was created is "7" days and "0" hours
  And I filter for tasks with "Time Elapsed" of "0.5 days"
  Then Only tasks with "Time Elapsed" of "0.5 days" will be displayed
  When I filter for tasks with "Time Elapsed" of "0.5 to 1 day"
  Then Only tasks with "Time Elapsed" of "0.5 to 1 day" will be displayed
  When I filter for tasks with "Time Elapsed" of "1 to 2 days"
  Then Only tasks with "Time Elapsed" of "1 to 2 days" will be displayed
  When I filter for tasks with "Time Elapsed" of "2 to 5 days"
  Then Only tasks with "Time Elapsed" of "2 to 5 days" will be displayed
  When I filter for tasks with "Time Elapsed" of "5 days or greater"
  Then Only tasks with "Time Elapsed" of "5 days or greater" will be displayed
  When I filter for tasks with "Time Elapsed" of "All"
  Then the coding task table has the following ordered information
       | Verbatim Term | Time Elapsed      |
       | ALPHA         | 0.5 days          |
       | BRAVO         | 0.5 to 1 day      |
       | CHARLIE       | 1 to 2 days       |
       | DELTA         | 2 to 5 days       |
       | ECHO          | 5 days or greater |
       | FOXTROT       | 0.5 days          |

@VAL
@PBMCC_159410_002
@Release2015.3.0
Scenario: FILTER HEADER The Group shall display the filtered count when grouped verbatims are filtered by priority

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  When the following externally managed verbatim requests are made "Tasks_21_GroupedVerbatimsOfVaryingPriority.csv"
  When I filter for tasks with "Priority" of "1"
  Then the coding task table has the following ordered information
       | Verbatim Term | Group  | Priority |
       | ALPHA         | 2 of 6 | 1        |
       | BRAVO         | 2 of 5 | 1        |
       | CHARLIE       | 2 of 4 | 1        |
       | DELTA         | 1 of 3 | 1        |
       | FOXTROT       | 1      | 1        |
  And the group view of the coding task table for task "ALPHA" differentiates the tasks with "Priority" of "1"

@VAL
@PBMCC_191152_016
@Release2015.3.0
Scenario: The task table shall filter when sorted

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When I sort the tasks by "Verbatim Term" "descending"
  And I filter the tasks by 
       | Column Name            | Filter Criteria              |
       | Priority               | 2                            |
       | Status                 | Waiting Manual Code          |
       | Dictionary             | All                          |
       | Queries                | All                          |
       | Time Elapsed           | 0.5 days                     |
  Then the tasks will be filtered by 
       | Column Name            | Filter Criteria              |
       | Priority               | 2                            |
       | Status                 | Waiting Manual Code          |
       | Time Elapsed           | 0.5 days                     |
  And the tasks will be sorted by "Verbatim Term" "descending"

@VAL
@PBMCC_191152_017
@Release2015.3.0
Scenario: The task table shall sort when a filter is applied

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When I filter the tasks by 
       | Column Name            | Filter Criteria              |
       | Priority               | 2                            |
       | Status                 | Waiting Manual Code          |
       | Dictionary             | All                          |
       | Queries                | All                          |
       | Time Elapsed           | 0.5 days                     |
  And I sort the tasks by "Verbatim Term" "descending"
  Then the tasks will be filtered by 
       | Column Name            | Filter Criteria              |
       | Priority               | 2                            |
       | Status                 | Waiting Manual Code          |
       | Time Elapsed           | 0.5 days                     |
  And the tasks will be sorted by "Verbatim Term" "descending"

@VAL
@PBMCC_191152_018
@Release2015.3.0
Scenario: PAGINATION The First page link shall go to the first page

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When I go to page "Next"
  Then The current page is "2"
  When I go to page "First"
  Then The current page is "1"
    
@VAL
@PBMCC_191152_019
@Release2015.3.0
Scenario: PAGINATION The Previous page link shall go to the Previous page

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When I go to page "Last"
  Then The current page is "3"
  When I go to page "Previous"
  Then The current page is "2"
    
@VAL
@PBMCC_191152_020
@Release2015.3.0
Scenario: PAGINATION The Next page link shall go to the next page

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When I go to page "Next"
  Then The current page is "2"

@VAL
@PBMCC_191152_021
@Release2015.3.0
Scenario: PAGINATION The Last page link shall go to the last page

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When I go to page "Last"
  Then The current page is "3"
      
@VAL
@PBMCC_191152_022
@Release2015.3.0
Scenario: PAGINATION The numeric page links shall go to the corresponding pages

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When I go to page "2"
  Then The current page is "2"
  When I go to page "3"
  Then The current page is "3"
  When I go to page "1"
  Then The current page is "1"

@VAL
@PBMCC_191152_023
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: PAGINATION The numeric page links shall go to the corresponding pages when more than twelve pages are generated

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_520_MultiStudy_MultiSup_MultiDict.csv"
  When I go to page "7"
  Then The current page is "7"
  When I go to page "9	"
  Then The current page is "9"
  When I go to page "49"
  Then The current page is "49"
  When I go to page "44"
  Then The current page is "44"

@VAL
@PBMCC_191152_024
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: COUNT The number of tasks shall be available to the client when I load 520 from CSV

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_520_MultiStudy_MultiSup_MultiDict.csv"
  Then The task count is "520"

@VAL
@PBMCC_191152_025
@Release2015.3.0
Scenario: COUNT The number of tasks shall be available to the client when I load 30 from CSV and the display limit is 50

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When entering value "50" for Configuration "Coding Task Page Size" and save
  Then The task count is "30"

@DFT
@Release2015.3.0
@PBMCC_191152_026
@IncreaseTimeout_3000000
@ignore
Scenario: The ODBFileBuilder will be backwards compatible with existing CSV files

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary List           | MedDRA                | 15.0                      | ENG    |
	| Primary List           | WhoDrugDDEB2          | 201503                    | ENG    |
  When the following externally managed verbatim requests are made "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
  When the following externally managed verbatim requests are made "Tasks_520_MultiStudy_MultiSup_MultiDict.csv"
  When the following externally managed verbatim requests are made "Tasks_1000_MedDRA_Match_Upload.csv"
  When the following externally managed verbatim requests are made "Tasks_1500_SingleStudy_NoSup_SingleDict.csv"
  When the following externally managed verbatim requests are made "AutoApproveSynonymApprovalMedDRA.csv"
  When the following externally managed verbatim requests are made "AutoApproveSynonymApprovalWhoDrugDDEB2.csv"
  Then The task count is not "0"

@VAL
@PBMCC_193388_001
@Release2015.3.0
@IncreaseTimeout_600000
Scenario: New tasks shall not be accepted while the target study is being migrated
  
  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 14.0 Empty_List" containing entry ""
  And an activated synonym list "MedDRA ENG 15.0 New_Primary_List"
  When the following externally managed verbatim requests are made "Tasks_1000_MedDRA_Match_Upload.csv" and auto-coding in progress
  When performing study migration without waiting
  Then new coding task "AARDWOLF" is not be accepted until the study migration completes





