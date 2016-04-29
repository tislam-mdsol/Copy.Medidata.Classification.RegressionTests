@specProjectRegistration.feature
@CoderCore
Feature: This feature file will verify Project Registration 

_ Project = iMedidata Study (if the study is a production study, then its envs will also be registered)

@VAL
@Release2015.3.0
@PBMCC_168480_001
@IncreaseTimeout
Scenario: The user will have ability to add new registration tables

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0" unregistered
	When registering a project with the following options
		| Project     | Dictionary | Version | Locale | SynonymListName | RegistrationName |
		| <StudyName> | MedDRA     | 11.0    | eng    | Primary List    | MedDRA           |
		| <StudyName> | MedDRA     | 11.0    | eng    | Primary List    | MedDRAMedHistory |
	Then the following content should be registered
		| Project     | Dictionary | Version | Locale | SynonymListName | RegistrationName |
		| <StudyName> | MedDRA     | 11.0    | eng    | Primary List    | MedDRA           |
		| <StudyName> | MedDRA     | 11.0    | eng    | Primary List    | MedDRAMedHistory |

@VAL
@Release2015.3.0
@PBMCC_168480_002
@IncreaseTimeout
Scenario: The user will have ability to add new registration tables with different languages

	Given a "Basic" Coder setup with no tasks and no synonyms and unregistered dictionaries
		| SynonymListName | Dictionary | Version | Locale |
		| Primary List    | MedDRA     | 11.0    | JPN    |
		| Primary List    | MedDRA     | 11.0    | ENG    |
	When registering a project with the following options
		| Project     | Dictionary | Version | Locale | SynonymListName | RegistrationName |
		| <StudyName> | MedDRA     | 11.0    | jpn    | Primary List    | MedDRA           |
		| <StudyName> | MedDRA     | 11.0    | eng    | Primary List    | MedDRA           |
	Then the following content should be registered
		| Project     | Dictionary | Version | Locale | SynonymListName | RegistrationName |
		| <StudyName> | MedDRA     | 11.0    | jpn    | Primary List    | MedDRA           |
		| <StudyName> | MedDRA     | 11.0    | eng    | Primary List    | MedDRA           |

@VAL
@Release2015.3.3
@PBMCC_168480_002a
@IncreaseTimeout
Scenario: Registering a project with a second identical empty synonym list should overwrite the previous registration

	Given a "Basic" Coder setup with no tasks and no synonyms and unregistered dictionaries
		| SynonymListName | Dictionary | Version | Locale |
		| Primary List    | MedDRA     | 11.0    | ENG    |
		| Second List     | MedDRA     | 11.0    | ENG    |
	When registering a project with the following options
		| Project     | Dictionary | Version | Locale | SynonymListName | RegistrationName |
		| <StudyName> | MedDRA     | 11.0    | eng    | Primary List    | MedDRA           |
		| <StudyName> | MedDRA     | 11.0    | eng    | Second List     | MedDRA           |
	Then the following content should be registered
		| Project     | Dictionary | Version | Locale | SynonymListName | RegistrationName |
		| <StudyName> | MedDRA     | 11.0    | eng    | Second List     | MedDRA           |

@DFT
@Release2015.3.0
@PBMCC_168480_003
@ignore
#skipping this scenario because no message is showing on UI (end to end rave scenario)
Scenario: The user will see success message when dictionary has been registered to project

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
	When registering a project with the following options
		| Project     | Dictionary | Version | Locale | SynonymListName | RegistrationName |
		| <StudyName> | MedDRA     | 11.0    | Eng    | Primary         | MedDRAHistory    |
	Then I should see success message "Dictionary has been successfully registered to <StudyName> Project"

@VAL
@Release2015.3.0
@PBMCC_168480_004
Scenario: The user should see registry history when project registration history is toggled
	
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 200703" unregistered
	When registering a project with the following options
		| Project     | Dictionary   | Version | Locale | SynonymListName | RegistrationName |
		| <StudyName> | WhoDrugDDEB2 | 200703  | eng    | Primary List    | WHODrug-DDE-B2   |
	Then Registration History contains following information
		| User   | ProjectRegistrationSucceeded | DictionaryAndVersions               | Created     |
		| <User> | Checked                      | WhoDrugDDEB2(WHODrug-DDE-B2):200703 | <TimeStamp> |

@VAL
@Release2015.3.0
@PBMCC_168480_005
@IncreaseTimeout
Scenario: The user should be able to verify three projects were registered

	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 200703" unregistered
	When registering a project with the following options
		| Project     | Dictionary   | Version | Locale | SynonymListName | RegistrationName |
		| <StudyName> | WhoDrugDDEB2 | 200703  | eng    | Primary List    | WHODrug-DDE-B2   |
	And uploading MEV content and AutoCoding is complete
		| Study Id              | Verbatim Term                                 | Supplemental Field 1 | Supplemental Value 1 | Supplemental Field 2 | Supplemental Value 2 | Supplemental Field 3 | Supplemental Value 3 | Supplemental Field 4 | Supplemental Value 4 | Supplemental Field 5 | Supplemental Value 5 | Dictionary     | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Production            | 3-BENZHYDRYLOXY-8-ISOPROPYL-NORTROPAN MESILA. | SupTermFieldA        | Sup Term Value 1     | SupTermFieldB        | Sup Term Value 2     | SupTermFieldC        | Sup Term Value 3     | SupTermFieldD        | Sup Term Value 4     | SupTermFieldE        | Sup Term Value 5     | WHODrug-DDE-B2 | PRODUCTSYNONYM   | TRUE                 | FALSE            |
		| Development           | Allergy to Venom                              | SupTermFieldA        | Sup Term Value 1     |                      |                      |                      |                      |                      |                      |                      |                      | WHODrug-DDE-B2 | PRODUCTSYNONYM   | TRUE                 | FALSE            |
		| UserAcceptanceTesting | Blood Builder                                 |                      |                      |                      |                      |                      |                      |                      |                      |                      |                      | WHODrug-DDE-B2 | PRODUCTSYNONYM   | TRUE                 | TRUE             |
	Then all studies for Project are registered and MEV content is loaded
		| Term                                          | Study             |
		| 3-BENZHYDRYLOXY-8-ISOPROPYL-NORTROPAN MESILA. | <StudyName>       |
		| Allergy to Venom                              | <StudyName> (Dev) |
		| BLOOD BUILDER                                 | <StudyName> (UAT) |

	
	
