@specSynonymUpload.feature
@CoderCore
Feature: This feature will demonstrate Coder's functionality on uploading a synonym list.

@VALLongRunningTask
@PBMCC_155558_001
@PBMCC_158325_001
@Release2015.3.0
@IncreaseTimeout_1800000
Scenario: Coder will allow a user to be able to upload a synonym list file.

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary_List           | MedDRA                | 12.0                      | ENG    |
	When uploading synonym list file "SynonymUpload_PrimaryList.txt" to "MedDRA ENG 12.0 Primary_List"
	Then the loading of synonym list file "SynonymUpload_PrimaryList.txt" is completed without errors


@VAL
@PBMCC_208336_002
@Release2015.3.3
Scenario Outline: Autocoding will adhere to cross level synonyms created through synonym upload

	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "<Dictionary>"
	And a synonym list upload with the following synonyms
		| Verbatim   | Code   | Level       | Path   | Primary Flag  | Supplemental Info | Status   |
		| <Verbatim> | <Code> | <TaskLevel> | <Path> | <PrimaryFlag> | <SuppInfo>        | <Status> |
    When the following externally managed verbatim requests are made
        | Verbatim Term | Dictionary Level |
        | <Verbatim>    | <TaskLevel>      |
	Then task "<Verbatim>" should have the following Coding history selected term path information is displayed in row "1"
		| Level       | Term Path  | Code   |
		| <TermLevel> | <TermDesc> | <Code> |

Examples:
| Dictionary              | Verbatim    | TaskLevel      | Code          | Path                                                                                                                       | PrimaryFlag | SuppInfo | Status | TermLevel | TermDesc                                              |
| WHODrugDDEB2 ENG 201306 | New Drug 92 | PRODUCT        | 000764 02 019 | PRODUCTSYNONYM:000764 02 019;PRODUCT:000764 02 001;ATC:J01EC;ATC:J01E;ATC:J01;ATC:J                                        | false       |          | Active | TN        | SILVER SULFADIAZINE: 000764 02 019                    |
| WHODrugDDEB2 ENG 201306 | New Drug 92 | PRODUCTSYNONYM | 000764 02 001 | PRODUCT:000764 02 001;ATC:J01EC;ATC:J01E;ATC:J01;ATC:J                                                                     | false       |          | Active | PN        | SULFADIAZINE SILVER: 000764 02 001                    |
| MedDRA ENG 15.0         | Adverse 92  | PT             | 10009589      | LLT:10009589;PT:10049946;HLT:10041574;HLGT:10005942;SOC:10022117                                                           | true        |          | Active | LLT       | Closed fracture of second cervical vertebra: 10009589 |
| MedDRA ENG 15.0         | Adverse 92  | LLT            | 10049946      | PT:10049946;HLT:10041574;HLGT:10005942;SOC:10022117                                                                        | true        |          | Active | PT        | Cervical vertebral fracture: 10049946                 |
| JDrug ENG 2015H1        | New Drug 92 | DetailedClass  | 131970902     | DrugName:131970902;Category:6;PreferredName:1319709;DetailedClass:1319;LowLevelClass:131;MidLevelClass:13;HighLevelClass:1 | false       |          | Active | 薬        | CHONDRON: 131970902                                   |
| JDrug ENG 2015H1        | New Drug 92 | DrugName       | 1319          | DetailedClass:1319;LowLevelClass:131;MidLevelClass:13;HighLevelClass:1													  | false       |          | Active | 細        | OTHER AGENTS FOR OPHTHALMIC USE: 1319                 |
| JDrug JPN 2015H1        | New Drug 92 | DetailedClass  | 131970902     | DrugName:131970902;Category:6;PreferredName:1319709;DetailedClass:1319;LowLevelClass:131;MidLevelClass:13;HighLevelClass:1 | false       |          | Active | 薬        | コンドロン: 131970902                                  |
| JDrug JPN 2015H1        | New Drug 92 | DrugName       | 1319          | DetailedClass:1319;LowLevelClass:131;MidLevelClass:13;HighLevelClass:1													  | false       |          | Active | 細        | その他の眼科用剤: 1319					                |
