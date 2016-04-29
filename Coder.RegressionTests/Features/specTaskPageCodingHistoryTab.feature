@specTaskPageCodingHistoryTab.feature
@CoderCore
Feature: This feature file will verify the Task page's history tab section for a verbatim term.

_ The following environment configuration settings were enabled:

   Empty Synonym Lists Registered:
   Synonym List 1: MedDRA       (ENG) 11.0   Primary List
   Synonym List 2: WhoDrugDDEB2 (ENG) 200703 Primary List
   Synonym List 3: WhoDrugDDEC  (ENG) 200703 Primary List

   Common Configurations:
	Configuration Name	| Force Primary Path Selection (MedDRA) | Synonym Creation Policy Flag | Bypass Reconsider Upon Reclassify | Default Select Threshold | Default Suggest Threshold | Auto Add Synonyms | Auto Approve | Term Requires Approval (IsApprovalRequired )  | Term Auto Approve with synonym (IsAutoApproval)   |IsBypassTransmit		|
	Basic			| TRUE                                  | Always Active                | TRUE                              | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE                                              |TRUE				|
	No Approval		| TRUE                                  | Always Active                | TRUE                              | 100                      | 70                        | TRUE              | FALSE        | FALSE                                         | TRUE                                              |TRUE				|
	Reconsider		| TRUE                                  | Always Active                | FALSE                             | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE                                              |TRUE				|
	Approval		| TRUE                                  | Always Active                | FALSE                             | 100                      | 70                        | FALSE             | FALSE        | TRUE                                          | FALSE                                             |TRUE				|
	Completed Reconsider	| TRUE                                  | Always Active                | TRUE                              | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE                                              |FALSE				|

@VAL
@Release2015.3.0
@PBMCC_163324_001
Scenario: The following will show Coding history of a Waiting Approval task with information on User, Action, Status, Verbatim Term, Comment, and TimeStamp

  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
  And coding task "BURN" for dictionary level "LLT"
  When I view task "BURN"  
  Then I verify the following Coding History information is displayed
		| User         | Action          | Status           | Verbatim Term | Comment                                                                                                                |
		| <SystemUser> | Start Auto Code | Waiting Approval | BURN          | Auto coded by direct dictionary match                                                                                  |
		| <SystemUser> |                 | Start            | BURN          | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAutoApproval=false,IsBypassTransmit=True] |

@VAL
@Release2015.3.0
@PBMCC_163324_002
Scenario: The following will show Term Path Coding history of a task with a coding decision that is shown expanded

  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
  And coding task "BURN" for dictionary level "LLT"
  When I view task "BURN"
  Then I verify the following Coding history term full path information is displayed in row "1"
		| Level | Term Path                                                | Code     |
		| SOC   | Injury, poisoning and procedural complications: 10022117 | 10022117 |
		| HLGT  | Injuries by physical agents: 10022119                    | 10022119 |
		| HLT   | Thermal burns: 10043418                                  | 10043418 |
		| PT    | Thermal burn: 10053615                                   | 10053615 |
		| LLT   | Burn: 10006634                                           | 10006634 |

@VAL
@Release2015.3.0
@PBMCC_163324_003
Scenario: The following will show Term Path Coding history of a task with a coding decision that is contracted

  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
  And coding task "BURN" for dictionary level "LLT"
  When I view task "BURN"
  Then I verify the following Coding history selected term path information is displayed in row "1"
		| Level | Term Path      | Code     |
		| LLT   | Burn: 10006634 | 10006634 |
		
@VAL
@Release2015.3.0
@PBMCC_163324_004
Scenario: The following will show Coding history of an Approved and Reconsidered task.

  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
  And coding task "BURN" for dictionary level "LLT"
  When approving task "BURN"
  And reclassifying task "BURN" with a comment "Test Automation Comment" and Include Autocoded Items set to "True"
  And I view task "BURN"
  Then I verify the following Coding History information is displayed
		| User         | Action                        | Status               | Verbatim Term | Comment                                                                                                                | Time Stamp  |
		| <User>       | Reclassify                    | Reconsider           | BURN          | Test Automation Comment                                                                                                | <TimeStamp> |
		| <User>       | Complete Without Transmission | Completed            | BURN          | Transmission Queue Number:                                                                                             | <TimeStamp> |
		| <User>       | Approve                       | Waiting Transmission | BURN          |                                                                                                                        | <TimeStamp> |
		| <SystemUser> | Start Auto Code               | Waiting Approval     | BURN          | Auto coded by direct dictionary match                                                                                  | <TimeStamp> |
		| <SystemUser> |                               | Start                | BURN          | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAutoApproval=false,IsBypassTransmit=True] | <TimeStamp> |

@VAL
@Release2015.3.0
@PBMCC_163324_005
Scenario: The following will show Coding history of ReCoded task.
  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
  And coding task "BURN" for dictionary level "LLT"
  When I recode task "BURN" with comment "Recode comment."
  And I view task "BURN"
  Then I verify the following Coding History information is displayed
		| User         | Action          | Status              | Verbatim Term | Comment                                                                                                                | Time Stamp  |
		| <User>       | ReCode          | Waiting Manual Code | BURN          | Recode comment.                                                                                                        | <TimeStamp> |
		| <SystemUser> | Start Auto Code | Waiting Approval    | BURN          | Auto coded by direct dictionary match                                                                                  | <TimeStamp> |
		| <SystemUser> |                 | Start               | BURN          | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAutoApproval=false,IsBypassTransmit=True] | <TimeStamp> |


@VAL
@Release2015.3.0
@PBMCC_163324_006
Scenario: The following will show Coding history of a term that was completed without transmission, this applies to Manage External Verbatims
  Given a "Reconsider" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
  And coding task "ANGIO-EDEMA" for dictionary level "LLT"
  When reclassifying task "ANGIO-EDEMA" with a comment "Test Automation Comment" and Include Autocoded Items set to "True"
  And I view task "ANGIO-EDEMA"
  Then I verify the following Coding History information is displayed
		| User         | Action                        | Status               | Verbatim Term | Comment                                                                                                               | Time Stamp  |
		| <User>       | Reclassify                    | Reconsider           | ANGIO-EDEMA   | Test Automation Comment                                                                                               | <TimeStamp> |
		| <SystemUser> | Complete Without Transmission | Completed            | ANGIO-EDEMA   | Transmission Queue Number:                                                                                            | <TimeStamp> |
		| <SystemUser> | Auto Approve Internal         | Waiting Transmission | ANGIO-EDEMA   | Auto coded by direct dictionary match                                                                                 | <TimeStamp> |
		| <SystemUser> | Start Auto Code               | Waiting Approval     | ANGIO-EDEMA   | Auto coded by direct dictionary match                                                                                 | <TimeStamp> |
		| <SystemUser> |                               | Start                | ANGIO-EDEMA   | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAutoApproval=true,IsBypassTransmit=True] | <TimeStamp> |


@VAL
@Release2015.3.0
@PBMCC_163324_007
Scenario: The following will show Coding history of a term that has been manually coded
  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 200703"
  And coding task "ASPORIZ3" for dictionary level "PRODUCT"
  When task "ASPORIZ3" is coded to term "ASPIRIN PLUS C" at search level "Preferred Name" with code "003467 01 001" at level "PN" and a synonym is created
  And I view task "ASPORIZ3"
  Then I verify the following Coding History information is displayed
		| User         | Action          | Status              | Verbatim Term | Comment                                                                                                                | Time Stamp  |
		| <User>       | Browse And Code | Waiting Approval    | ASPORIZ3      |                                                                                                                        | <TimeStamp> |
		| <SystemUser> | Start Auto Code | Waiting Manual Code | ASPORIZ3      |                                                                                                                        | <TimeStamp> |
		| <SystemUser> |                 | Start               | ASPORIZ3      | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAutoApproval=false,IsBypassTransmit=True] | <TimeStamp> |


@VAL
@Release2015.3.0
@PBMCC_163324_008
Scenario: The following will show Coding history of a term that has been transmitted
  Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
  And coding task "ANGIONEUROTIC OEDEMA AGGRAVATED" for dictionary level "LLT"
  When reclassifying task "ANGIONEUROTIC OEDEMA AGGRAVATED" with a comment "Test Automation Comment" and Include Autocoded Items set to "True"
  And I view task "ANGIONEUROTIC OEDEMA AGGRAVATED"
  Then I verify the following Coding History information is displayed
		| User         | Action                        | Status               | Verbatim Term                   | Comment                                                                                                               | Time Stamp  |
		| <User>       | Reclassify                    | Waiting Manual Code  | ANGIONEUROTIC OEDEMA AGGRAVATED | Test Automation Comment                                                                                               | <TimeStamp> |
		| <SystemUser> | Complete Without Transmission | Completed            | ANGIONEUROTIC OEDEMA AGGRAVATED | Transmission Queue Number:                                                                                            | <TimeStamp> |
		| <SystemUser> | Auto Approve Internal         | Waiting Transmission | ANGIONEUROTIC OEDEMA AGGRAVATED | Auto coded by direct dictionary match                                                                                 | <TimeStamp> |
		| <SystemUser> | Start Auto Code               | Waiting Approval     | ANGIONEUROTIC OEDEMA AGGRAVATED | Auto coded by direct dictionary match                                                                                 | <TimeStamp> |
		| <SystemUser> |                               | Start                | ANGIONEUROTIC OEDEMA AGGRAVATED | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=true,IsAutoApproval=true,IsBypassTransmit=True] | <TimeStamp> |
	
@VAL
@Release2015.3.0
@PBMCC_163324_009
Scenario: The following will show Coding history of a term that has been Auto Approved and reclassified with Bypass Reconsider Upon Reclassify turned on
  Given a "No Approval" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 200703"
  And coding task "amethadone" for dictionary level "PRODUCT"
  When task "amethadone" is coded to term "methadone" at search level "Preferred Name" with code "000689 01 001" at level "PN" and a synonym is created
  And reclassifying task "amethadone" with a comment "Test Automation Comment" and Include Autocoded Items set to "True"
  And I view task "amethadone"
  Then I verify the following Coding History information is displayed
		| User         | Action                        | Status               | Verbatim Term | Comment                                                                                                                | Time Stamp  |
		| <User>       | Reclassify                    | Waiting Manual Code  | AMETHADONE    | Test Automation Comment                                                                                                | <TimeStamp> |
		| <User>       | Complete Without Transmission | Completed            | AMETHADONE    | Transmission Queue Number:                                                                                             | <TimeStamp> |
		| <User>       | Browse And Code               | Waiting Transmission | AMETHADONE    |                                                                                                                        | <TimeStamp> |
		| <SystemUser> | Start Auto Code               | Waiting Manual Code  | AMETHADONE    |                                                                                                                        | <TimeStamp> |
		| <SystemUser> |                               | Start                | AMETHADONE    | Workflow=DEFAULT,WorkflowVariables[IsAutoCode=True,IsApprovalRequired=false,IsAutoApproval=true,IsBypassTransmit=True] | <TimeStamp> |
	

@VAL
@Release2015.3.0
@PBMCC_163324_010
Scenario: The following will show Coding history of a term that has a status of waiting approval where an option of adding a comment is allowed
  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 200703"
  And coding task "ARMILLARISIN A" for dictionary level "PRODUCT"
  When a user adds a comment "Adding a comment!" for task "ARMILLARISIN A"
  Then the Coding History contains following information
		| User   | Action      | Status           | Verbatim Term  | Comment           | Time Stamp  |
		| <User> | Add Comment | Waiting Approval | ARMILLARISIN A | Adding a comment! | <TimeStamp> |

@VAL
@Release2015.3.0
@PBMCC_163324_011
Scenario: The following will show Coding history of a term that has a status of waiting manual code where an option of adding a comment is allowed
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 200703"
  And coding task "METH-" for dictionary level "PRODUCT"
  When a user adds a comment "Adding a comment!" for task "METH-"
  Then the Coding History contains following information
		| User   | Action      | Status              | Verbatim Term | Comment           | Time Stamp  |
		| <User> | Add Comment | Waiting Manual Code | METH-         | Adding a comment! | <TimeStamp> |
	
@VAL
@Release2015.3.0
@PBMCC_163324_012
Scenario: The following will show Coding history of a term that has a status of reconsider where an option of adding a comment is allowed
  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 200703"
  And coding task "ARMILLARISIN A" for dictionary level "PRODUCT"
  And approve and reclassify task "ARMILLARISIN A" with Include Autocoded Items set to "True"
  When a user adds a comment "Adding a comment!" for task "ARMILLARISIN A"
  Then the Coding History contains following information
		| User   | Action      | Status     | Verbatim Term  | Comment           | Time Stamp  |
		| <User> | Add Comment | Reconsider | ARMILLARISIN A | Adding a comment! | <TimeStamp> |
