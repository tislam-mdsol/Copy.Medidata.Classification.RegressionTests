@specAutoApproveSynonymApproval.feature
@CoderCore
Feature: This feature verifies synonym creation and approval based on the user configurable options of the system.
The following truth table was used to help map the requirements to the cases.

Test Case        | 	Synonym Creation Flag | 	Force Primary Path | 	Auto Approve | 	Auto Add Synonym | 	DDM Path                   | 	Dictionary  || 	Manual Coding | 	Synonym Approval
PBMCC_197255_001 | 	Always Active         | 	On                 | 	On           | 	NA (On)          | 	Single path and Multi-path | 	MedDRA      || 	No            | 	Hidden
PBMCC_197255_002 | 	Always Active         | 	On                 | 	On           | 	NA (On)          | 	Single path                | 	Not MedDRA  || 	No            | 	Hidden
PBMCC_197255_003 | 	Always Active         | 	NA (Off)           | 	On           | 	NA (On)          | 	Multi-path                 | 	Not MedDRA  || 	Yes           | 	Hidden
PBMCC_197255_004 | 	Never Active          | 	On                 | 	On           | 	NA (On)          | 	Single path and Multi-path | 	MedDRA      || 	No            | 	Hidden
PBMCC_197255_005 | 	Never Active          | 	NA (Off)           | 	On           | 	NA (On)          | 	Single path                | 	Not MedDRA  || 	No            | 	Hidden
PBMCC_197255_006 | 	Never Active          | 	NA (Off)           | 	On           | 	NA (On)          | 	Multi-path                 | 	Not MedDRA  || 	Yes           | 	Shown
PBMCC_197255_007 | 	Never Active          | 	Off                | 	On           | 	NA (On)          | 	Multi-path                 | 	MedDRA      || 	Yes           | 	Shown
PBMCC_197255_008 | 	Never Active          | 	Off                | 	On           | 	NA (On)          | 	Single path                | 	MedDRA      || 	No            | 	Hidden
PBMCC_197255_009 | 	Never Active          | 	On                 | 	Off          | 	NA (On)          | 	Single path and Multi-path | 	MedDRA      || 	No            | 	Shown
PBMCC_197255_010 | 	Never Active          | 	On                 | 	Off          | 	NA (On)          | 	Single path and Multi-path | 	Not MedDRA  || 	Yes           | 	Shown
PBMCC_197255_011 | 	Always Active         | 	On                 | 	Off          | 	NA (On)          | 	Single path and Multi-path | 	MedDRA      || 	No            | 	Hidden
PBMCC_197255_012 | 	Always Active         | 	NA (Off)           | 	Off          | 	NA (On)          | 	Single path and Multi-path | 	Not MedDRA  || 	Yes           | 	Hidden
PBMCC_197255_013 | 	Always Active         | 	On                 | 	On           | 	Off              | 	Single path and Multi-path | 	MedDRA      || 	No            | 	Hidden
PBMCC_197255_014 | 	Always Active         | 	On                 | 	On           | 	Off              | 	Single path and Multi-path | 	Not MedDRA  || 	No            | 	Hidden

_ The following environment configuration settings were enabled:

   Empty Synonym Lists Registered:
   Synonym List 1: MedDRA             (ENG) 16.0     MedDRA_DDM
   Synonym List 2: MedDRA             (ENG) 18.0     MedDRA_DDM
   Synonym List 3: WhoDrugDDEB2       (ENG) 201503   WhoDrugDDEB2_DDM

   Common Configurations:
   Configuration Name         | Declarative Browser Class | 
   Approval                   | ApprovalSetup             |
   Basic                      | BasicSetup                | 
   Completed Reconsider       | CompletedReconsiderSetup  |
   No Enforced Primary Path   | NoEnforcedPrimaryPath     |
   Synonyms Need Approval     | SynonymsNeedApproval      |

@VAL
@PBMCC_197255_001
@Release2015.3.0
@IncreaseTimeout_240000
Scenario: When Auto Approve option is "On", Synonym Creation Flag is "Always Active" and Force Primary Path is "On", Single path and Multi-path MedDRA Direct Dictionary Match shall not be displayed in the Synonym Approval page
  
   Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName            | Dictionary                  | Version                   | Locale |
	  | MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
   When coding tasks are loaded from CSV file "AutoApproveSynonymApprovalMedDRA.csv"
   Then the following coding decisions require approval 
      | Verbatim Term	       | Assigned Term      |
      | COUGHING               | Coughing           | 
      | COUGHING BLOOD         | Coughing blood     |  
   And the following terms were autocoded and approved
  	  | Verbatim          | Term              |
  	  | HEADACHE          | Headache          |
  	  | BROKEN LEG        | Broken leg        |
  	  | COUGH             | Cough             |
  	  | MIGRAINE HEADACHE | Migraine headache |
  	  | BACK PAIN         | Back pain         |
  	  | CHEST PAIN        | Chest pain        |
   And no synonym terms require approval
   And synonyms for verbatim terms should be created and exist in lists
	  | verbatim          | dictionaryLocaleVersionSynonymListName | exists |
	  | HEADACHE          | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	  | BROKEN LEG        | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	  | COUGH             | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	  | MIGRAINE HEADACHE | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	  | BACK PAIN         | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	  | CHEST PAIN        | MedDRA ENG 16.0 MedDRA_DDM             | false  |

@VAL
@PBMCC_197255_002
@Release2015.3.0
Scenario: When Auto Approve option is "On" Synonym Creation Flag is "Always Active", And Force Primary Path is "On", Single path Direct Dictionary Match shall not be displayed in the Synonym Approval page.
   
   Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName            | Dictionary                  | Version                   | Locale |
	  | WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201503                    | ENG    |
   When coding tasks are loaded from CSV file "AutoApproveSynonymApprovalWhoDrugDDEB2.csv"
   Then the following coding decisions require approval 
      | Verbatim Term  | Assigned Term  |
      | TYLENOL INFANT | Tylenol infant |
   And the following terms were autocoded and approved
  	  | Verbatim           | Term               |
  	  | TYLENOL COUGH      | Tylenol cough      |
  	  | PENICILLIN V BASIC | Penicillin v basic |
  	  | ADVIL COLD         | Advil cold         |
   And no synonym terms require approval
   And synonyms for verbatim terms should be created and exist in lists
	  | verbatim           | dictionaryLocaleVersionSynonymListName   | exists |
	  | TYLENOL COUGH      | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | false  |
	  | PENICILLIN V BASIC | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | false  |
	  | ADVIL COLD         | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | false  |
   
@VAL
@PBMCC_197255_003
@Release2015.3.0
@IncreaseTimeout_240000 
Scenario: When Auto Approve option is "On" and Synonym Creation Flag is "Always Active", Multi-path Direct Dictionary Match shall require manual coding, and shall not display in the Synonym Approval page when a synonym is created.
   
   Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName            | Dictionary                  | Version                   | Locale |
	  | WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201503                    | ENG    |
   When coding tasks are loaded from CSV file "AutoApproveSynonymApprovalWhoDrugDDEB2.csv"
   And task "JUNIOR ASPRIN" is coded to term "JUNIOR ASPRIN" at search level "Trade Name" with code "000027 01 583" at level "TN" and a synonym is created
   And task "PAIN" is coded to term "PAIN" at search level "Trade Name" with code "000277 04 191" at level "TN" and a synonym is created
   And task "VITAMIN-A" is coded to term "VITAMIN-A" at search level "Trade Name" with code "000560 01 078" at level "TN" and a synonym is created
   And task "VITAMIN-C" is coded to term "VITAMIN-C" at search level "Trade Name" with code "000080 01 517" at level "TN" and a synonym is created
   Then the following coding decisions require approval 
      | Verbatim Term  | Assigned Term  |
      | JUNIOR ASPRIN  | Junior asprin  |
      | TYLENOL INFANT | Tylenol infant |
   And no synonym terms require approval
   And synonyms for verbatim terms should be created and exist in lists
	  | verbatim  | dictionaryLocaleVersionSynonymListName   | exists |
	  | VITAMIN-A | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | true   |
	  | VITAMIN-C | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | true   |
   
@VAL
@PBMCC_197255_004
@Release2015.3.0
@IncreaseTimeout_300000 
Scenario: When Auto Approve option is "On", Synonym Creation Flag is "Never Active" and Force Primary Path is "On", Single path and Multi-path MedDRA Direct Dictionary Match shall not be displayed in the Synonym Approval page.
 	
   Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName            | Dictionary                  | Version                   | Locale |
	  | MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
   When I configure the Synonym Creation Policy Flag to "Never Active"
   And coding tasks are loaded from CSV file "AutoApproveSynonymApprovalMedDRA.csv"
   Then the following coding decisions require approval 
      | Verbatim Term	       | Assigned Term      |
      | COUGHING               | Coughing           | 
      | COUGHING BLOOD         | Coughing blood     |  
   And the following terms were autocoded and approved
  	  | Verbatim          | Term              |
  	  | HEADACHE          | Headache          |
  	  | BROKEN LEG        | Broken leg        |
  	  | COUGH             | Cough             |
  	  | MIGRAINE HEADACHE | Migraine headache |
  	  | BACK PAIN         | Back pain         |
  	  | CHEST PAIN        | Chest pain        |
   And no synonym terms require approval
   And synonyms for verbatim terms should be created and exist in lists
	  | verbatim          | dictionaryLocaleVersionSynonymListName | exists |
	  | HEADACHE          | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	  | BROKEN LEG        | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	  | COUGH             | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	  | MIGRAINE HEADACHE | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	  | BACK PAIN         | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	  | CHEST PAIN        | MedDRA ENG 16.0 MedDRA_DDM             | false  |
   
@VAL
@PBMCC_197255_005
@Release2015.3.0
Scenario: When Auto Approve option is "On", Synonym Creation Flag is "Never Active", Single path Direct Dictionary Match shall not be displayed in the Synonym Approval page.

   Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName            | Dictionary                  | Version                   | Locale |
	  | WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201503                    | ENG    |
   When I configure the Synonym Creation Policy Flag to "Never Active"
   And coding tasks are loaded from CSV file "AutoApproveSynonymApprovalWhoDrugDDEB2.csv"
   Then the following coding decisions require approval 
      | Verbatim Term  | Assigned Term  |
      | TYLENOL INFANT | Tylenol infant |
   And the following terms were autocoded and approved
  	  | Verbatim           | Term               |
  	  | TYLENOL COUGH      | Tylenol cough      |
  	  | PENICILLIN V BASIC | Penicillin v basic |
  	  | ADVIL COLD         | Advil cold         |
   And no synonym terms require approval
   And synonyms for verbatim terms should be created and exist in lists
	  | verbatim           | dictionaryLocaleVersionSynonymListName   | exists |
	  | TYLENOL COUGH      | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | false  |
	  | PENICILLIN V BASIC | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | false  |
	  | ADVIL COLD         | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | false  |
   
@VAL
@PBMCC_197255_006
@Release2015.3.0
@IncreaseTimeout_240000 
Scenario: When Auto Approve option is "On", Synonym Creation Flag is "Never Active", Multi-path Direct Dictionary Match shall require manual coding, and shall display in the Synonym Approval page when a synonym is created.
 	
   Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName            | Dictionary                  | Version                   | Locale |
	  | WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201503                    | ENG    |
   When I configure the Synonym Creation Policy Flag to "Never Active"
   And coding tasks are loaded from CSV file "AutoApproveSynonymApprovalWhoDrugDDEB2.csv"
   And task "JUNIOR ASPRIN" is coded to term "JUNIOR ASPRIN" at search level "Trade Name" with code "000027 01 583" at level "TN" and a synonym is created
   And task "PAIN" is coded to term "PAIN" at search level "Trade Name" with code "000277 04 191" at level "TN" and a synonym is created
   And task "VITAMIN-A" is coded to term "VITAMIN-A" at search level "Trade Name" with code "000560 01 078" at level "TN" and a synonym is created
   And task "VITAMIN-C" is coded to term "VITAMIN-C" at search level "Trade Name" with code "000080 01 517" at level "TN" and a synonym is created
   Then the following coding decisions require approval 
      | Verbatim Term  | Assigned Term  |
      | JUNIOR ASPRIN  | Junior asprin  |
      | PAIN           | Pain           |
      | TYLENOL INFANT | Tylenol infant | 
   And the following synonym terms require approval
      | Verbatim      |
      | JUNIOR ASPRIN |
      | PAIN          |
      | VITAMIN-A     |
      | VITAMIN-C     |
   
@VAL
@PBMCC_197255_007
@Release2015.3.0
@IncreaseTimeout_240000 
Scenario: When Auto Approve option is "On", Synonym Creation Flag is "Never Active" and Force Primary Path is "OFF", Multi-path MedDRA Direct Dictionary Match shall require manual coding, and shall display in the Synonym Approval page when a synonym is created.
 	
   Given a "No Enforced Primary Path" Coder setup with no tasks and no synonyms and dictionaries
      | SynonymListName            | Dictionary                  | Version                   | Locale |
      | MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
   When I configure the Synonym Creation Policy Flag to "Never Active"
   And I configure dictionary "MedDRA" with "Auto Approve" set to "true"
   And coding tasks are loaded from CSV file "AutoApproveSynonymApprovalMedDRA.csv"
   And task "BROKEN LEG" is coded to term "Broken leg" at search level "Low Level Term" with code "10006391" at level "LLT" and a synonym is created
   And task "CHEST PAIN" is coded to term "Chest pain" at search level "Low Level Term" with code "10008479" at level "LLT" and a synonym is created
   And task "COUGHING BLOOD" is coded to term "Coughing blood" at search level "Low Level Term" with code "10011234" at level "LLT" and a synonym is created
   And task "MIGRAINE HEADACHE" is coded to term "Migraine headache" at search level "Low Level Term" with code "10027602" at level "LLT" and a synonym is created
   Then the following coding decisions require approval 
      | Verbatim Term  | Assigned Term  |
      | BROKEN LEG     | Broken leg     |
      | COUGHING       | Coughing       |
      | COUGHING BLOOD | Coughing blood |  
   And the following synonym terms require approval
      | Verbatim               | 
      | BROKEN LEG             | 
      | CHEST PAIN             | 
      | COUGHING BLOOD         | 
	  | MIGRAINE HEADACHE      |
   
@VAL
@PBMCC_197255_008
@Release2015.3.0
Scenario: When Auto Approve option is "On", Synonym Creation Flag is "Never Active" and Force Primary Path is "OFF", Single-path MedDRA Direct Dictionary Match shall not be displayed in the Synonym Approval page.
 
   Given a "No Enforced Primary Path" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName            | Dictionary                  | Version                   | Locale |
	  | MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
   When I configure the Synonym Creation Policy Flag to "Never Active"
   And I configure dictionary "MedDRA" with "Auto Approve" set to "true"
   And coding tasks are loaded from CSV file "AutoApproveSynonymApprovalMedDRA.csv"
   Then the following coding decisions require approval 
      | Verbatim Term	       | Assigned Term      |
      | COUGHING               | Coughing           | 
   And the following terms were autocoded and approved
  	  | Verbatim  | Term      |
  	  | HEADACHE  | Headache  |
  	  | COUGH     | Cough     |
  	  | BACK PAIN | Back pain |
   And no synonym terms require approval
   And synonyms for verbatim terms should be created and exist in lists
	  | verbatim  | dictionaryLocaleVersionSynonymListName | exists |
	  | HEADACHE  | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	  | COUGH     | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	  | BACK PAIN | MedDRA ENG 16.0 MedDRA_DDM             | false  |
   
@VAL
@PBMCC_197255_009
@Release2015.3.0
@IncreaseTimeout_300000 
Scenario: When Auto Approve option is "OFF", Synonym Creation Flag is "Never Active" and Force Primary Path is "On", Single path and Multi-path MedDRA Direct Dictionary Match shall display in the Synonym Approval page
 	
   Given a "Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName          | Dictionary                   | Version                   | Locale |
	  | MedDRA_DDM               | MedDRA                       | 18.0                      | ENG    |
   When coding tasks are loaded from CSV file "AutoApproveSynonymApprovalMedDRA.csv"
   Then the following coding decisions require approval 
      | Verbatim Term	       | Assigned Term      |
      | BROKEN LEG             | Broken leg         | 
      | COUGHING               | Coughing           | 
      | COUGHING BLOOD         | Coughing blood     | 
      | HEADACHE               | Headache           |    
   And the following terms were autocoded and approved
  	  | Verbatim               | Term               | 
	  | COUGH                  | Cough              | 
	  | MIGRAINE HEADACHE      | Migraine headache  | 
	  | BACK PAIN              | Back pain          | 
	  | CHEST PAIN             | Chest pain         | 
   And the following synonym terms require approval
      | Verbatim               | 
      | BACK PAIN              | 
      | BROKEN LEG             | 
      | CHEST PAIN             | 
      | COUGH                  | 
      | COUGHING               | 
      | COUGHING BLOOD         | 
      | HEADACHE               | 
	  | MIGRAINE HEADACHE      |
   And synonyms for verbatim terms should be created and exist in lists
	  | verbatim          | dictionaryLocaleVersionSynonymListName | exists |
	  | COUGH             | MedDRA ENG 18.0 MedDRA_DDM             | true   |
	  | MIGRAINE HEADACHE | MedDRA ENG 18.0 MedDRA_DDM             | true   |
	  | BACK PAIN         | MedDRA ENG 18.0 MedDRA_DDM             | true   |
	  | CHEST PAIN        | MedDRA ENG 18.0 MedDRA_DDM             | true   |
	  
@VAL
@PBMCC_197255_010
@Release2015.3.0
@IncreaseTimeout_240000 
Scenario: When Auto Approve option is "OFF", Synonym Creation Flag is "Never Active" and Force Primary Path is "On", Single path Direct Dictionary Match and Multi-path DDM shall be displayed in the Synonym Approval page
 	
   Given a "Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName            | Dictionary                  | Version                   | Locale |
	  | WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201503                    | ENG    |
   When coding tasks are loaded from CSV file "AutoApproveSynonymApprovalWhoDrugDDEB2.csv"
   Then the following coding decisions require manual coding 
      | Verbatim Term |
      | JUNIOR ASPRIN |
      | PAIN          |
      | VITAMIN-A     |
      | VITAMIN-C     |
   And the following coding decisions require approval 
      | Verbatim Term  | Assigned Term  |
      | TYLENOL COUGH  | Tylenol cough  |
      | TYLENOL INFANT | Tylenol infant | 
   And the following terms were autocoded and approved
  	  | Verbatim           | Term               |
  	  | PENICILLIN V BASIC | Penicillin v basic |
  	  | ADVIL COLD         | Advil cold         |
   When all task filters are cleared
   And task "JUNIOR ASPRIN" is coded to term "JUNIOR ASPRIN" at search level "Trade Name" with code "000027 01 583" at level "TN" and a synonym is created
   Then the following synonym terms require approval
      | Verbatim           |
      | ADVIL COLD         |
      | JUNIOR ASPRIN      |
      | PENICILLIN V BASIC |
      | TYLENOL COUGH      |
      | TYLENOL INFANT     | 
   And synonyms for verbatim terms should be created and exist in lists
	  | verbatim           | dictionaryLocaleVersionSynonymListName   | exists |
	  | PENICILLIN V BASIC | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | true   |
	  | ADVIL COLD         | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | true   |
   
@VAL
@PBMCC_197255_011
@Release2015.3.0
Scenario: When Auto Approve option is "OFF", Synonym Creation Flag is "Always Active" and Force Primary Path is "On", Single path and Multi-path MedDRA Direct Dictionary Match shall not be displayed in the Synonym Approval page.
 	
   Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName            | Dictionary                  | Version                   | Locale |
	  | MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
   When coding tasks are loaded from CSV file "AutoApproveSynonymApprovalMedDRA.csv"
   Then the following coding decisions require approval 
      | Verbatim Term  | Assigned Term  |
      | COUGHING       | Coughing       |
      | COUGHING BLOOD | Coughing blood |
   And the following terms were autocoded and approved
  	  | Verbatim          | Term              |
  	  | HEADACHE          | Headache          |
  	  | BROKEN LEG        | Broken leg        |
  	  | COUGH             | Cough             |
  	  | MIGRAINE HEADACHE | Migraine headache |
  	  | BACK PAIN         | Back pain         |
  	  | CHEST PAIN        | Chest pain        |
   And no synonym terms require approval
   And synonyms for verbatim terms should be created and exist in lists
	  | verbatim          | dictionaryLocaleVersionSynonymListName | exists |
	  | HEADACHE          | MedDRA ENG 16.0 MedDRA_DDM             | true   |
	  | BROKEN LEG        | MedDRA ENG 16.0 MedDRA_DDM             | true   |
	  | COUGH             | MedDRA ENG 16.0 MedDRA_DDM             | true   |
	  | MIGRAINE HEADACHE | MedDRA ENG 16.0 MedDRA_DDM             | true   |
	  | BACK PAIN         | MedDRA ENG 16.0 MedDRA_DDM             | true   |
	  | CHEST PAIN        | MedDRA ENG 16.0 MedDRA_DDM             | true   |
   
@VAL
@PBMCC_197255_012
@Release2015.3.0
@IncreaseTimeout_240000 
Scenario: When Auto Approve option is "OFF", Synonym Creation Flag is "Always Active", Single path Direct Dictionary Match and Multi-path DDM shall not be displayed in the Synonym Approval page.
 	
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName            | Dictionary                  | Version                   | Locale |
	  | WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201503                    | ENG    |
   When coding tasks are loaded from CSV file "AutoApproveSynonymApprovalWhoDrugDDEB2.csv"
   Then the following coding decisions require manual coding 
      | Verbatim Term |
      | JUNIOR ASPRIN |
      | PAIN          |
      | VITAMIN-A     |
      | VITAMIN-C     |
   And the following coding decisions require approval 
      | Verbatim Term  | Assigned Term  |
      | TYLENOL INFANT | Tylenol infant |
   And the following terms were autocoded and approved
  	  | Verbatim           | Term               |
  	  | TYLENOL COUGH      | Tylenol cough      |
  	  | PENICILLIN V BASIC | Penicillin v basic |
  	  | ADVIL COLD         | Advil cold         | 
   When all task filters are cleared
   And task "JUNIOR ASPRIN" is coded to term "JUNIOR ASPRIN" at search level "Trade Name" with code "000027 01 583" at level "TN" and a synonym is created
   Then no synonym terms require approval
   And synonyms for verbatim terms should be created and exist in lists
	  | verbatim           | dictionaryLocaleVersionSynonymListName   | exists |
	  | TYLENOL COUGH      | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | true   |
	  | PENICILLIN V BASIC | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | true   |
	  | ADVIL COLD         | WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM | true   |
   
@VAL
@PBMCC_197255_013
@Release2015.3.0
Scenario: When Auto Approve option is "On", Synonym Creation Flag is "Always Active", Auto Add Synonym is "OFF", and Force Primary Path is "On", Single path and Multi-path MedDRA Direct Dictionary Match terms shall not be displayed in the Synonym Approval page.
 	
   Given a "Approval" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName            | Dictionary                  | Version                   | Locale |
	  | MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
   When I configure dictionary "MedDRA" with "Auto Approve" set to "true"
   And coding tasks are loaded from CSV file "AutoApproveSynonymApprovalMedDRA.csv"
   Then the following coding decisions require approval 
      | Verbatim Term  | Assigned Term  |
      | BROKEN LEG     | Broken leg     |
      | COUGHING       | Coughing       |
      | COUGHING BLOOD | Coughing blood |
      | HEADACHE       | Headache       |
   And the following terms were autocoded and approved
  	  | Verbatim               | Term               | 
	  | COUGH                  | Cough              | 
	  | MIGRAINE HEADACHE      | Migraine headache  | 
	  | BACK PAIN              | Back pain          | 
	  | CHEST PAIN             | Chest pain         | 
   And no synonym terms require approval
   And the number of synonyms created for list "MedDRA ENG 16.0 MedDRA_DDM" is "0"

@VAL
@PBMCC_197255_014
@Release2015.3.0
@IncreaseTimeout_240000 
Scenario: When Auto Approve option is "On", Synonym Creation Flag is "Always Active", Auto Add Synonym is "OFF", and Force Primary Path is "On", Single path Direct Dictionary Match terms and Multi-path DDM will not be displayed in the Synonym Approval page.
 
   Given a "Approval" Coder setup with no tasks and no synonyms and dictionaries
	  | SynonymListName            | Dictionary                  | Version                   | Locale |
	  | WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201503                    | ENG    |
   When I configure dictionary "WhoDrugDDEB2" with "Auto Approve" set to "true"
   And coding tasks are loaded from CSV file "AutoApproveSynonymApprovalWhoDrugDDEB2.csv"
   Then the following coding decisions require manual coding 
      | Verbatim Term |
      | JUNIOR ASPRIN |
      | PAIN          |
      | VITAMIN-A     |
      | VITAMIN-C     |
   And the following coding decisions require approval 
      | Verbatim Term  | Assigned Term  |
      | TYLENOL COUGH  | Tylenol cough  |
      | TYLENOL INFANT | Tylenol infant | 
   And the following terms were autocoded and approved
  	  | Verbatim           | Term               |
  	  | PENICILLIN V BASIC | Penicillin v basic |
  	  | ADVIL COLD         | Advil cold         | 
   When all task filters are cleared
   When task "JUNIOR ASPRIN" is coded to term "JUNIOR ASPRIN" at search level "Trade Name" with code "000027 01 583" at level "TN" and a synonym is created
   Then no synonym terms require approval
   And the number of synonyms created for list "WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM" is "1"
   And a synonym for verbatim term "JUNIOR ASPRIN" should be created and exist in list "WhoDrugDDEB2 ENG 201503 WhoDrugDDEB2_DDM"
