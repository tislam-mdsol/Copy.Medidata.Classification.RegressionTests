@specMevDownload.feature
@CoderCore
Feature: A user is able to download coding and query information from within the Manage External Verbatim page.

@VAL
@PBMCC_168482_001
@Release2015.3.0
@IncreaseTimeout_900000
Scenario: Coder will provide the user with the ability to extract imported data

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"	
	When the following externally managed verbatim requests are made
		| Verbatim Term | Supplemental Field 1 | Supplemental Value 1 | Supplemental Field 2 | Supplemental Value 2 | Supplemental Field 3 | Supplemental Value 3 | Supplemental Field 4 | Supplemental Value 4 | Supplemental Field 5 | Supplemental Value 5 | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Headache      | SupTermFieldA        | Sup Term Value 1     | SupTermFieldB        | Sup Term Value 2     | SupTermFieldC        | Sup Term Value 3     | SupTermFieldD        | Sup Term Value 4     | SupTermFieldE        | Sup Term Value 5     | MedDRA     | LLT              | FALSE                | TRUE             |
	Then task "HEADACHE" is available within reclassification
	When downloading MEV file
	Then the downloaded MEV file should contain the following external verbatims
        | Study ID    | Verbatim Term | Dictionary Version Locale | Supplemental Field 1 | Supplemental Value 1 | Supplemental Field 2 | Supplemental Value 2 | Level 1 | Level 1 Text             | Level 1 Code | Level 2 | Level 2 Text | Level 2 Code | Level 3 | Level 3 Text  | Level 3 Code | Level 4 | Level 4 Text | Level 4 Code | Level 5 | Level 5 Text | Level 5 Code |
        | <StudyName> | Headache      | MedDRA-11_0-English       | SupTermFieldA        | Sup Term Value 1     | SupTermFieldB        | Sup Term Value 2     | SOC     | Nervous system disorders | 10029205     | HLGT    | Headaches    | 10019231     | HLT     | Headaches NEC | 10019233     | PT      | Headache     | 10019211     | LLT     | Headache     | 10019211     |

@VAL
@PBMCC_168482_002
@Release2015.3.0
@IncreaseTimeout_900000
Scenario: Verify a coding task that goes to a seventh level where it is displayed in the Download coding tasks csv

    Given a "Basic" Coder setup with no tasks and no synonyms and dictionries
        | ListName | Dictionary | Version | Locale |
        | Primary  | MedDRA     | 16.0    | JPN    |
        | Primary  | JDrug      | 2013H1  | JPN    |
	When the following externally managed verbatim requests are made
		| Verbatim Term		     | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval | Locale |
		| アセチルコリン塩化物    | JDrug      | DrugName         | FALSE                | TRUE             | jpn    |
	Then task "アセチルコリン塩化物" is available within reclassification for dictionary "J-Drug" version "2013H1" locale "JPN"
	When downloading MEV file
	Then the downloaded MEV file should contain the following external verbatims
	| Level 7 Text         | Level 7 Code |
	| アセチルコリン塩化物   | 1232401      |


@VAL
@PBMCC_168482_003
@Release2015.3.0
@IncreaseTimeout_900000
Scenario: A CSV task with an open query will be removed from the UI and upon downloading the report, it will contain a status of Open

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
	When the following externally managed verbatim requests are made
		| Verbatim Term              | Supplemental Field 1 | Supplemental Value 1 | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval | 
		| Major Big Painful Headache | SupFieldA            | Sup1                 | MedDRA     | LLT              | FALSE                | TRUE             | 
	And opening a query for task "MAJOR BIG PAINFUL HEADACHE" with comment "Opening query, removing the invalid task." and not waiting for the task query status to update
	And downloading MEV file
	Then the downloaded MEV file should contain the following external verbatims
	    | Verbatim Term              | Coder Username    | Query Value                                 | Query Status |
	    | Major Big Painful Headache | <UserDisplayName> | "Opening query, removing the invalid task." | Open         |


@VAL
@PBMCC_168482_004
@Release2015.3.0
@IncreaseTimeout_900000
Scenario: Verify download filter MEV Study affects export file correctly

    Given a "Basic" Coder setup with no tasks and no synonyms and dictionries
        | ListName | Dictionary		   | Version | Locale |
        | Primary  | MedDRA   		   | 11.0    | ENG    |
        | Primary  | WhoDrugDDEB2      | 201203  | ENG    |
	When the following externally managed verbatim requests are made
		| Study Id    | Verbatim Term                               | Dictionary   | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Development | PAIN AID PLUS                               | WhoDrugDDEB2 | PRODUCTSYNONYM   | FALSE                | TRUE             |
		| Production  | NEOLAMIN MULTI YAM                          | WhoDrugDDEB2 | PRODUCTSYNONYM   | FALSE                | TRUE             |
		| Development | NATURES OWN ZN AND C NATURAL ORANGE FLAVOUR | WhoDrugDDEB2 | PRODUCTSYNONYM   | FALSE                | TRUE             |
		| Development | DEATH ADDER ANTIVN                          | WhoDrugDDEB2 | PRODUCTSYNONYM   | FALSE                | TRUE             |
		| Development | DEATH ADDER ANTIVENOM                       | WhoDrugDDEB2 | PRODUCTSYNONYM   | FALSE                | TRUE             |
		| Development | Feeling happy inappropriately               | MedDRA       | LLT              | FALSE                | TRUE             |
		| Production  | Heavy cigarette smoker                      | MedDRA       | LLT              | FALSE                | TRUE             |
		| Development | Cigarette smoker                            | MedDRA       | LLT              | FALSE                | TRUE             |
		| Development | Feeling sad                                 | MedDRA       | LLT              | FALSE                | TRUE             |
		| Development | Impending doom                              | MedDRA       | LLT              | FALSE                | TRUE             |
	And downloading MEV file
	Then the downloaded MEV file should contain the following external verbatims
	| Verbatim Term          | Level 5 Text              |
	| NEOLAMIN MULTI YAM     | NEOLAMIN MULTI /05665101/ |
	| Heavy cigarette smoker | Heavy cigarette smoker    |
	And only "3" rows are present in the csv file
		
@VALLongRunningTask
@PBMCC_168482_005
@Release2015.3.0
@IncreaseTimeout_1800000
Scenario: An uploaded 5000 task csv file is able to be downloaded
  
    Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
	When uploading synonym list file "WHODrug_DDEB2_201306_5kSynonym.txt" to "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM"
	And uploading "5000" WhoDrug tasks
	Then "5000" tasks are processed by the workflow
	When downloading MEV file
	Then only "5001" rows are present in the csv file
