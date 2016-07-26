@specSynonymApproval.feature
@CoderCore
Feature: The Coder system will provide a mechanism by which synonyms created by users can be reviewed and approved

@VAL
@Release2015.3.0
@PBMCC_164725_001
Scenario Outline: When adding a synonym that requires approval the coding system should successfully activate it upon approval
	Given a "Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionary "<Dictionary>"
	And coding task "<Verbatim>" for dictionary level "<Dictionary Level>"
	When task "<Verbatim>" is coded to term "<Search Text>" at search level "<Search Level>" with code "<Synonym Code>" at level "<Dictionary Level>" and a synonym is created
	And the synonym for verbatim "<Verbatim>" and code "<Synonym Code>" is approved
	Then the synonym for verbatim "<Verbatim>" and code "<Synonym Code>" should be active
	Examples:
	| Dictionary      | Verbatim | Dictionary Level | Search Text         | Search Level   | Synonym Term        | Synonym Code |
	| MedDRA ENG 11.0 | A-FIB    | LLT              | Atrial Fibrillation | Low Level Term | Atrial Fibrillation | 10003658     |

@VAL
@Release2015.3.0
@PBMCC_192362_002
@IncreaseTimeout_900000
Scenario: The coding system should allow a large number of provisional synonyms to be filtered by term during the approval process
	Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	When uploading "2000" MedDRA direct dictionary matches
	And the "1100" provisional synonyms are filtered by term "pain"
	Then all provisional synonyms should be for a verbatim that contains "pain"

@VAL
@Release2015.3.0
@PBMCC_194721_003
@IncreaseTimeout_300000
Scenario: The coding system should provide a distinct set of provisional synonyms upon requesting the subsequent set
    Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	When uploading "60" MedDRA direct dictionary matches
	And the "30" provisional synonyms are requested
	Then each provisional synonym should be unique across all sets


@VAL
@Release2015.3.0
@PBMCC_171567_001
@IncreaseTimeout_300000
Scenario: The coding system should allow a synonym to be retired
	Given a "Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName | Dictionary | Version | Locale |
	  | Retired_List    | MedDRA     | 15.0    | ENG    |
	And coding task "Adverse Event 1" for dictionary level "LLT"
	When task "Adverse Event 1" is coded to term "Reflux gastritis" at search level "Low Level Term" with code "10057969" at level "LLT" and a synonym is created
	Then the following synonym terms require approval
      | Verbatim        |
      | ADVERSE EVENT 1 |
	When the synonym for verbatim "Adverse Event 1" and code "10057969" is retired
	Then no synonym terms require approval
    And the number of synonyms for list "MedDRA ENG 15.0 Retired_List" is "0"

@VAL
@Release2015.3.0
@PBMCC_206142_001
@IncreaseTimeout_300000
Scenario: A user shall be able to retire synonyms from the Synonym Approval page

    Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	When the following externally managed verbatim requests are made
	    | Verbatim Term | Dictionary Level |
	    | ACHES         | LLT              |
	And task "ACHES" is coded to term "HEADACHE" at search level "Low Level Term" with code "10019211" at level "LLT" and a synonym is created
	And the provisional synonym for verbatim term "ACHES" is retired from the Synonym Approval page
	Then the synonym for verbatim "ACHES" and code "10019211" should not exist
	When the following externally managed verbatim requests are made
	    | Verbatim Term | Dictionary Level |
	    | ACHES         | LLT              |
	Then the Coding History contains following information for task "ACHES" in status "Waiting Manual Code"
   		| User         | Action          | Status              | Verbatim Term | Comment | Time Stamp  |
   		| <SystemUser> | Start Auto Code | Waiting Manual Code | ACHES         |         | <TimeStamp> |

@VAL
@Release2015.3.0
@PBMCC_206142_002
@IncreaseTimeout_300000
Scenario: Tasks shall remain in the current status when synonyms are retired from the Synonym Approval page

    Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And "2" manually approved coding tasks with verbatim "ACHES" coded to term "HEADACHE" code "10019211" with a synonym created
	And "2" unapproved coding tasks with verbatim "ACHES" coded to term "HEADACHE" code "10019211"
	When the provisional synonym for verbatim term "ACHES" is retired from the Synonym Approval page
	Then the synonym for verbatim "ACHES" and code "10019211" should not exist
	And the coding task table has the following ordered information
         | Verbatim Term | Group | Status           |
         | ACHES         | 2     | Waiting Approval |
	When performing reclassification search
	Then the reclassification search should contain
	   | Study       | Subject   | Verbatim | Term     | Code     | Priority | Form   |
	   | <StudyName> | Subject 1 | ACHES    | Headache | 10019211 | 1        | Form 1 |
	   | <StudyName> | Subject 1 | ACHES    | Headache | 10019211 | 1        | Form 1 |

@VAL
@Release2015.3.0
@PBMCC_206142_003
@IncreaseTimeout_300000
Scenario: Non Single Path DDM tasks with provisional synonyms shall return to manual code status when the synonyms are retired from the Synonym Details page and existing tasks are reconsidered

    Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And "2" manually approved coding tasks with verbatim "ACHES" coded to term "HEADACHE" code "10019211" with a synonym created
	And "2" unapproved coding tasks with verbatim "ACHES" coded to term "HEADACHE" code "10019211"
	When the provisional synonym for verbatim term "ACHES" is retired from the Synonym Details page
	And a coding task "ACHES" returns to "Waiting Manual Code" status 
	And a coding task "ACHES" returns to "Reconsider" status 
	Then the synonym for verbatim "ACHES" and code "10019211" should not exist
	And the coding task table has the following ordered information
         | Verbatim Term | Group | Status              |
         | ACHES         | 2     | Waiting Manual Code |
         | ACHES         | 2     | Reconsider          |
	And the Coding History contains following information for task "ACHES" in status "Waiting Manual Code"
         | User   | Action     | Status              | Verbatim Term | Comment         | Time Stamp  |
         | <User> | Reclassify | Waiting Manual Code | ACHES         | Synonym Retired | <TimeStamp> |
	And the Coding History contains following information for task "ACHES" in status "Reconsider"
         | User   | Action     | Status     | Verbatim Term | Comment         | Time Stamp  |
         | <User> | Reclassify | Reconsider | ACHES         | Synonym Retired | <TimeStamp> |

@VAL
@Release2015.3.0
@PBMCC_206142_004
@IncreaseTimeout_300000
Scenario: Single Path DDM tasks with provisional synonyms shall return to the manual code status when the synonyms are retired from the Synonym Details page and existing tasks are reconsidered

    Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	When the following externally managed verbatim requests are made
	    | Verbatim Term | Dictionary Level |
	    | HEADACHE      | LLT              |
	And the provisional synonym for verbatim term "HEADACHE" is retired from the Synonym Details page
	And a coding task "HEADACHE" returns to "Waiting Manual Code" status 
	Then the synonym for verbatim "HEADACHE" and code "10019211" should not exist
	And the coding task table has the following ordered information
         | Verbatim Term | Status              |
         | HEADACHE      | Waiting Manual Code |
	And the Coding History contains following information
         | User   | Action     | Status              | Verbatim Term | Comment         | Time Stamp  |
         | <User> | Reclassify | Waiting Manual Code | HEADACHE      | Synonym Retired | <TimeStamp> |

@VAL
@Release2015.3.0
@PBMCC_206142_005
@IncreaseTimeout_300000
Scenario: The Reconsider Dialog shall display the number of coding decisions affected when retiring a synonym from the Synonym Details page

    Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And "3" manually approved coding tasks with verbatim "ACHES" coded to term "HEADACHE" code "10019211" with a synonym created
	And "4" unapproved coding tasks with verbatim "ACHES" coded to term "HEADACHE" code "10019211"
	Then the reconsider dialog displays "3" completed and "4" in progress coding decisions when retiring the provisional synonym for verbatim term "ACHES"

@VAL
@Release2015.3.0
@PBMCC_206142_006
@IncreaseTimeout_420000
Scenario: Provisional synonyms shall be updated with path changes and remain in the provisional status after Study Migrations

    Given a "Auto Code Synonyms Need Approval" Coder setup with registered synonym list "MedDRA ENG 16.0 Current_List" containing entry ""
    And an unactivated synonym list "MedDRA ENG 16.1 New_List"
	And "1" unapproved coding tasks with verbatim "ACHES" coded to term "Acetabular dysplasia" code "10000396" with a synonym created
	When I perform a synonym migration accepting the reconciliation suggestion for the synonym "ACHES" under the category "Path Does Not Exist"
    And performing study migration
	Then the synonym "ACHES" requires approval after synonym migration is completed
	And the master path for synonym "ACHES" after synonym migration is completed is
		| Level | Term Path                                                                     | Code     |
		| SOC   | Congenital, familial and genetic disorders: 10010331                          | 10010331 |
		| HLGT  | Musculoskeletal and connective tissue disorders congenital: 10028396          | 10028396 |
		| HLT   | Musculoskeletal and connective tissue disorders of limbs congenital: 10028381 | 10028381 |
		| PT    | Developmental hip dysplasia: 10073767                                         | 10073767 |
		| LLT   | Acetabular dysplasia: 10000396                                                | 10000396 |
	Then the Coding History contains following information
         | User         | Action          | Status              | Verbatim Term | Comment                                         | Time Stamp  |
         | <SystemUser> | Start Auto Code | Waiting Manual Code | ACHES         | Cannot auto code because synonym is provisional | <TimeStamp> |
        
@VAL
@Release2015.3.0
@PBMCC_206142_007
@IncreaseTimeout_420000
Scenario: Provisional synonyms unaffected by Study Migrations shall remain in the provisional status 

    Given a "Auto Code Synonyms Need Approval" Coder setup with registered synonym list "MedDRA ENG 15.0 Current_List" containing entry ""
    And an unactivated synonym list "MedDRA ENG 16.0 New_List"
	And "1" unapproved coding tasks with verbatim "ACHES" coded to term "HEADACHE" code "10019211" with a synonym created
    When starting synonym list migration
    And performing study migration
	Then the synonym "ACHES" requires approval after synonym migration is completed
	And the master path for synonym "ACHES" after synonym migration is completed is
		| Level | Term Path                          | Code     |
		| SOC   | Nervous system disorders: 10029205 | 10029205 |
		| HLGT  | Headaches: 10019231                | 10019231 |
		| HLT   | Headaches NEC: 10019233            | 10019233 |
		| PT    | Headache: 10019211                 | 10019211 |
		| LLT   | Headache: 10019211                 | 10019211 |
	Then the Coding History contains following information
         | User   | Action | Status           | Verbatim Term | Comment                                                          | Time Stamp  |
         | <User> |        | Waiting Approval | ACHES         | Version Change - From MedDRA-15_0-English To MedDRA-16_0-English | <TimeStamp> |

@VAL
@Release2015.3.0
@PBMCC_206142_008
@IncreaseTimeout_300000
Scenario: Uploaded provisional synonyms shall be added in the provisional status to the target synonym list during synonym list upgrades

     Given a "Auto Code Synonyms Need Approval" Coder setup with registered synonym list "MedDRA ENG 15.0 Current_List" containing entry "ACHES|10019211|LLT|LLT:10019211;PT:10019211;HLT:10019233;HLGT:10019231;SOC:10029205|True||Provisional|Cluster headache"
     And an unactivated synonym list "MedDRA ENG 16.0 New_List"
     When starting synonym list migration
	 Then the synonym for verbatim "ACHES" and code "10019211" should be active after synonym migration

@VAL
@Release2015.3.0
@PBMCC_206142_009
@IncreaseTimeout_300000
Scenario:  Provisional synonyms shall be added in the provisional status to the target synonym list during synonym list upgrades

     Given a "Auto Code Synonyms Need Approval" Coder setup with registered synonym list "MedDRA ENG 15.0 Current_List" containing entry ""
	 And an unactivated synonym list "MedDRA ENG 16.0 New_List"
	 And "1" unapproved coding tasks with verbatim "ACHES" coded to term "HEADACHE" code "10019211" with a synonym created
	 When starting synonym list migration
	 Then the synonym "ACHES" requires approval after synonym migration is completed

@DFT
@Release2015.3.0
@PBMCC_206142_010
@IncreaseTimeout_300000
@ignore
#Comment: Failing due to defect MCC-171991.
Scenario: The Synonym Approval page shall filter by the Study

	Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName | Dictionary   | Version | Locale |
	| MedDRA_List     | MedDRA       | 15.0    | ENG    |
	| WHODrug_List    | WhoDrugDDEB2 | 201503  | ENG    |
	And coding tasks from CSV file "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
	And task "ALPHA" is coded to term "HEADACHE" at search level "Low Level Term" with code "10019211" at level "LLT" and a synonym is created
	And task "TANGO" is coded to term "VITAMIN-C" at search level "Trade Name" with code "000080 01 517" at level "TN" and a synonym is created
	Then the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by study "All Studies"
	| Verbatim | DictionaryAndLocale | ListName              |
	| ALPHA    | MedDRA (ENG)        | MedDRA_List (15.0)    |
	| TANGO    | WhoDrugDDEB2 (ENG)  | WHODrug_List (201503) |
	Then the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by study "Study"
	| Verbatim | DictionaryAndLocale | ListName              |
	| ALPHA    | MedDRA (ENG)        | MedDRA_List (15.0)    |
	Then the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by study "Dev"
	| Verbatim | DictionaryAndLocale | ListName              |
	| TANGO    | WhoDrugDDEB2 (ENG)  | WHODrug_List (201503) |

@VAL
@Release2015.3.0
@PBMCC_206142_011
@IncreaseTimeout_300000
Scenario: The Synonym Approval page shall filter by the Dictionary

	Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName | Dictionary   | Version | Locale |
	| MedDRA_List     | MedDRA       | 15.0    | ENG    |
	| WHODrug_List    | WhoDrugDDEB2 | 201503  | ENG    |
	And coding tasks from CSV file "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
	And task "ALPHA" is coded to term "HEADACHE" at search level "Low Level Term" with code "10019211" at level "LLT" and a synonym is created
	And task "TANGO" is coded to term "VITAMIN-C" at search level "Trade Name" with code "000080 01 517" at level "TN" and a synonym is created
	Then the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by dictionary "All Dictionary Types"
	| Verbatim | DictionaryAndLocale |
	| ALPHA    | MedDRA (ENG)        |
	| TANGO    | WhoDrugDDEB2 (ENG)  |
	Then the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by dictionary "MedDRA (ENG)"
	| Verbatim | DictionaryAndLocale |
	| ALPHA    | MedDRA (ENG)        |
	Then the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by dictionary "WhoDrugDDEB2 (ENG)"
	| Verbatim | DictionaryAndLocale |
	| TANGO    | WhoDrugDDEB2 (ENG)  |

@VAL
@Release2015.3.0
@PBMCC_206142_012
@IncreaseTimeout_300000
Scenario: The Synonym Approval page shall filter by the Synonym List

	Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName | Dictionary   | Version | Locale |
	| MedDRA_List     | MedDRA       | 15.0    | ENG    |
	| WHODrug_List    | WhoDrugDDEB2 | 201503  | ENG    |
	And coding tasks from CSV file "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
	And task "ALPHA" is coded to term "HEADACHE" at search level "Low Level Term" with code "10019211" at level "LLT" and a synonym is created
	And task "TANGO" is coded to term "VITAMIN-C" at search level "Trade Name" with code "000080 01 517" at level "TN" and a synonym is created
	Then the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by synonym list "All Synonym Lists"
	| Verbatim | ListName              |
	| ALPHA    | MedDRA_List (15.0)    |
	| TANGO    | WHODrug_List (201503) |
	Then the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by synonym list "MedDRA_List (15.0)"
	| Verbatim | ListName              |
	| ALPHA    | MedDRA_List (15.0)    |
	Then the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by synonym list "WHODrug_List (201503)"
	| Verbatim | ListName              |
	| TANGO    | WHODrug_List (201503) |

@DFT
@Release2015.3.0
@PBMCC_206142_013
@IncreaseTimeout_600000
@ignore
#Comment: Failing due to defect MCC-208723.
Scenario: The Synonym Approval page shall filter by the Date

	Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName | Dictionary   | Version | Locale |
	| MedDRA_List     | MedDRA       | 15.0    | ENG    |
	| WHODrug_List    | WhoDrugDDEB2 | 201503  | ENG    |
	And coding tasks from CSV file "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
	When a browse and code for task "ALPHA" is performed
	And I code next available task
         | Verbatim      | SearchText | SearchLevel    | Code          | Level | CreateSynonym |
         | ALPHA         | HEADACHE   | Low Level Term | 10019211      | LLT   | True          |
         | ALPHA AMBER   | VITAMIN-C  | Trade Name     | 000080 01 517 | TN    | True          |
         | AMBER CHARLIE | VITAMIN-C  | Trade Name     | 000080 01 517 | TN    | True          |
         | AMBER DELTA   | VITAMIN-C  | Trade Name     | 000080 01 517 | TN    | True          |
         | BRAVO         | HEADACHE   | Low Level Term | 10019211      | LLT   | True          |
         | BRAVO AMBER   | VITAMIN-C  | Trade Name     | 000080 01 517 | TN    | True          |
         | CHARLIE       | HEADACHE   | Low Level Term | 10019211      | LLT   | True          |
         | DELTA         | HEADACHE   | Low Level Term | 10019211      | LLT   | True          |
         | ECHO          | HEADACHE   | Low Level Term | 10019211      | LLT   | True          |
         | FOXTROT       | HEADACHE   | Low Level Term | 10019211      | LLT   | True          |
	And the time elapsed since synonym "AMBER CHARLIE " was created is "3" days
	And the time elapsed since synonym "AMBER DELTA" was created is "10" days
	And the time elapsed since synonym "BRAVO" was created is "20" days
	And the time elapsed since synonym "BRAVO AMBER" was created is "40" days
	And the time elapsed since synonym "CHARLIE" was updated is "3" days
	And the time elapsed since synonym "DELTA" was updated is "10" days
	And the time elapsed since synonym "ECHO" was updated is "20" days
	And the time elapsed since synonym "FOXTROT" was updated is "40" days
	Then the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by date range
	| DateRange                        | ExpectedVerbatims                                                                                 |
	| All Dates                        | ALPHA, ALPHA AMBER, AMBER CHARLIE, AMBER DELTA, BRAVO, BRAVO AMBER, CHARLIE, DELTA, ECHO, FOXTROT |
	| Today                            | ALPHA, ALPHA AMBER                                                                                |
	| Last Seven Days                  | AMBER CHARLIE, CHARLIE                                                                            |
	| Between Seven And Fourteen Days  | AMBER DELTA, DELTA                                                                                |
	| Between Fourteen And Thirty Days | BRAVO, ECHO                                                                                       |
	| Older Than Thirty Days           | BRAVO AMBER, FOXTROT                                                                              |

@VAL
@Release2015.3.0
@PBMCC_206142_014
@IncreaseTimeout_300000
Scenario: The Synonym Approval page shall filter by the Synonym Term

	Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName | Dictionary   | Version | Locale |
	| MedDRA_List     | MedDRA       | 15.0    | ENG    |
	| WHODrug_List    | WhoDrugDDEB2 | 201503  | ENG    |
	And coding tasks from CSV file "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
	And task "ALPHA" is coded to term "HEADACHE" at search level "Low Level Term" with code "10019211" at level "LLT" and a synonym is created
	And task "AMBER CHARLIE" is coded to term "VITAMIN-C" at search level "Trade Name" with code "000080 01 517" at level "TN" and a synonym is created
	And task "AMBER DELTA" is coded to term "VITAMIN-C" at search level "Trade Name" with code "000080 01 517" at level "TN" and a synonym is created
	Then the synonyms for approval are limited to those synonyms that meet the filter criteria when filtered by search text
	| SearchText    | ExpectedVerbatims          |
	| ALPHA         | ALPHA                      |
	| ALP*          | ALPHA                      |
	| AMBER CHARLIE | AMBER CHARLIE, AMBER DELTA |
	| AMBER DELTA   | AMBER CHARLIE, AMBER DELTA |
	| AMBER         | AMBER CHARLIE, AMBER DELTA |
	| AMB*          | AMBER CHARLIE, AMBER DELTA |
	| AMBER*CHARLIE | AMBER CHARLIE              |
	| AMBER*DELTA   | AMBER DELTA                |

@VAL
@Release2015.3.0
@PBMCC_206142_015
@IncreaseTimeout_600000
Scenario: The Synonym Details page shall filter by status

    Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName | Dictionary   | Version | Locale |
	| MedDRA_List     | MedDRA       | 15.0    | ENG    |
	| WHODrug_List    | WhoDrugDDEB2 | 201503  | ENG    |
	And coding tasks from CSV file "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
	And task "TANGO" is coded to term "ANTIVENOM" at search level "Trade Name" with code "003416 01 006" at level "TN" and a synonym is created
	And task "UNIFORM" is coded to term "ANTIVENOM" at search level "Trade Name" with code "003416 01 006" at level "TN" and a synonym is created
	And task "VICTOR" is coded to term "ANTIVENOM" at search level "Trade Name" with code "003416 01 006" at level "TN" and a synonym is created
	And task "WHISKEY" is coded to term "ANTIVENOM" at search level "Trade Name" with code "003416 01 006" at level "TN" and a synonym is created
	And task "XRAY" is coded to term "ANTIVENOM" at search level "Trade Name" with code "003416 01 006" at level "TN" and a synonym is created
	When the synonym for verbatim "TANGO" and code "003416 01 006" is approved
	And the synonym for verbatim "VICTOR" and code "003416 01 006" is approved
	Then the synonym details are limited to those synonyms that meet the filter criteria when filtered by status
	| Status      | SearchText | ExpectedVerbatim | ExpectedStatus |
	| All         | TANGO      | TANGO            | Active         |
	| All         | UNIFORM    | UNIFORM          | Provisional    |
	| All         | VICTOR     | VICTOR           | Active         |
	| All         | WHISKEY    | WHISKEY          | Provisional    |
	| All         | XRAY       | XRAY             | Provisional    |
	| Provisional | UNIFORM    | UNIFORM          | Provisional    |
	| Provisional | WHISKEY    | WHISKEY          | Provisional    |
	| Provisional | XRAY       | XRAY             | Provisional    |
	| Active      | TANGO      | TANGO            | Active         |
	| Active      | VICTOR     | VICTOR           | Active         |

@VAL
@Release2015.3.0
@PBMCC_206142_016
@IncreaseTimeout_600000
#Comment: Failing due to defect MCC-209628. The "By Term" cases have been disabled. Only the "By Verbatim" cases will execute.
Scenario: The Synonym Details page shall filter by verbatim or term

	Given a "Auto Code Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName | Dictionary   | Version | Locale |
	| MedDRA_List     | MedDRA       | 15.0    | ENG    |
	| WHODrug_List    | WhoDrugDDEB2 | 201503  | ENG    |
	And coding tasks from CSV file "Tasks_30_MultiStudy_MultiSup_MultiDict.csv"
	And task "AMBER CHARLIE" is coded to term "VITAMIN-A" at search level "Trade Name" with code "000560 01 078" at level "TN" and a synonym is created
	And task "AMBER DELTA" is coded to term "ANTIVENOM" at search level "Trade Name" with code "003416 01 006" at level "TN" and a synonym is created
	And task "TANGO" is coded to term "VITAMIN-A" at search level "Trade Name" with code "000560 01 078" at level "TN" and a synonym is created
	And task "UNIFORM" is coded to term "VITAMIN-C" at search level "Trade Name" with code "000080 01 517" at level "TN" and a synonym is created
	And task "VICTOR" is coded to term "ANTIVENOM" at search level "Trade Name" with code "003416 01 006" at level "TN" and a synonym is created
	When the synonym for verbatim "TANGO" and code "000560 01 078" is approved
	When the synonym for verbatim "VICTOR" and code "003416 01 006" is approved
	Then the synonym details are limited to those synonyms that meet the filter criteria when filtered by search text
	| SearchText    | ExpectedVerbatims          | SearchBy    |
	| TANGO         | TANGO                      | By Verbatim |
	| TAN*          | TANGO                      | By Verbatim |
	| UNIFORM       | UNIFORM                    | By Verbatim |
	| VICTOR        | VICTOR                     | By Verbatim |
	| AMBER CHARLIE | AMBER CHARLIE, AMBER DELTA | By Verbatim |
	| AMBER DELTA   | AMBER CHARLIE, AMBER DELTA | By Verbatim |
	| AMBER         | AMBER CHARLIE, AMBER DELTA | By Verbatim |
	| AMB*          | AMBER CHARLIE, AMBER DELTA | By Verbatim |
	| AMBER*CHARLIE | AMBER CHARLIE              | By Verbatim |
	| AMBER*DELTA   | AMBER DELTA                | By Verbatim |
	#| TANGO         | TANGO                      | By Term     |
	#| TAN*          | TANGO                      | By Term     |
	#| UNIFORM       | UNIFORM                    | By Term     |
	#| VICTOR        | VICTOR                     | By Term     |
	#| AMBER CHARLIE | AMBER CHARLIE, AMBER DELTA | By Term     |
	#| AMBER DELTA   | AMBER CHARLIE, AMBER DELTA | By Term     |
	#| AMBER         | AMBER CHARLIE, AMBER DELTA | By Term     |
	#| AMB*          | AMBER CHARLIE, AMBER DELTA | By Term     |
	#| AMBER*CHARLIE | AMBER CHARLIE              | By Term     |
	#| AMBER*DELTA   | AMBER DELTA                | By Term     |
	
