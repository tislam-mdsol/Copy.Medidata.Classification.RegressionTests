@specDoNotAutoCode.feature
@CoderCore
Feature: This feature file will verify Do Not Auto Code 

@VAL
@Release2015.3.0
@PBMCC_189072_001
@IncreaseTimeout
Scenario: Verify that when direct dictionary terms are set to do not auto code that when uploading these tasks, auto code isn't performed
	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" unregistered
	And an activated synonym list "MedDRA ENG 15.0 History_List"
	When registering a project with the following options
		| Project     | Dictionary | Version | Locale | SynonymListName | RegistrationName |
		| <StudyName> | MedDRA     | 15.0    | eng    | Primary List    | MedDRA           |
		| <StudyName> | MedDRA     | 15.0    | eng    | History_List    | MedDRAMedHistory |
	And do not auto code "Back arched backwards" for dictionary "MedDRA-15_0-English" level "LLT"
	And do not auto code "Death sudden" for dictionary "MedDRAMedHistory-15_0-English" level "LLT"
	And the following externally managed verbatim requests are made
		| Verbatim Term         | Dictionary       | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Back arched backwards | MedDRA           | LLT              | TRUE                 | FALSE            |
		| Death sudden          | MedDRA           | LLT              | TRUE                 | FALSE            |
		| Back arched backwards | MedDRAMedHistory | LLT              | TRUE                 | FALSE            |
		| Death sudden          | MedDRAMedHistory | LLT              | TRUE                 | FALSE            |
    Then the dictionary list term has the following coding history comments
		| Verbatim              | Dictionary                   | Status              | Comment                                                   |
		| Back arched backwards | MedDRA - 15.0 - Primary List | Waiting Manual Code | Cannot auto code because term is in Do Not Auto Code list |
		| Death sudden          | MedDRA - 15.0 - Primary List | Waiting Approval    | Auto coded by direct dictionary match                     |
		| Back arched backwards | MedDRA - 15.0 - History_List | Waiting Approval    | Auto coded by direct dictionary match                     |
		| Death sudden          | MedDRA - 15.0 - History_List | Waiting Manual Code | Cannot auto code because term is in Do Not Auto Code list |