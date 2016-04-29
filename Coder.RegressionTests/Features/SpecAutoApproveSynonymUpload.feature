@specAutoApproveSynonymUpload.feature
@CoderCore
Feature: In general, uploaded direct dictionary matches will not be available after they have been uploaded into the system when Auto Approve is configured.  
Uploaded direct dictionary matches will be available after they have been uploaded into the system when Auto Approve is not configured. This logic has some 
exceptions based on the type of dictionary and single vs. multiple path synonyms. The following truth table was used to help map the requirements to the cases.

Test Case	        | AutoApprove	| Single/Multi	| MedDRA | Synonyms
PBMCC_196870_001	| On	        |     Single	| Yes	 | Hidden
PBMCC_196870_001	| On	        |     Single	| No	 | Hidden
PBMCC_196870_002	| Off	        |     Single	| Yes	 | Shown
PBMCC_196870_002	| Off	        |     Single	| No	 | Shown
PBMCC_196870_003	| On	        |     Multi	    | Yes	 | Hidden
PBMCC_196870_004	| On	        |     Multi	    | No	 | Shown
PBMCC_196870_005	| Off	        |     Multi	    | Yes	 | Shown
PBMCC_196870_005	| Off	        |     Multi	    | No	 | Shown


These tests can give false positives without confirming that tasks are correctly loaded and synonyms created. MCC-191152 includes a verification that the ODM loads passed successfully.
May want to consider turning the auto coded on and off to ensure synonym exists.

_ The following environment configuration settings were enabled:

   Empty Synonym Lists Registered:
   Synonym List 1: MedDRA             (ENG) 16.0     MedDRA_DDM
   Synonym List 2: WhoDrugDDEB2       (ENG) 201306   WhoDrugDDEB2_DDM
   Synonym List 3: JDrug              (JPN) 2013H1   JDrug_DDM

   Common Configurations:
   Configuration Name       | Declarative Browser Class | 
   Completed Reconsider     | CompletedReconsiderSetup  | 
   Basic                    | BasicSetup                | 

@VAL
@PBMCC_196870_001
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: When the Auto Approve option is "On" and uploading Single path Direct Dictionary Matches; upon completing the upload, the synonyms shall not be available to download and the count shall not change
 
 	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
	| JDrug_DDM                  | JDrug                       | 2013H1                    | JPN    |
	When uploading synonym list file "SynonymUpload_SinglePath_DDM_MedDRA-Eng-160.txt" to "MedDRA ENG 16.0 MedDRA_DDM"
	And uploading synonym list file "SynonymUpload_SinlgePath_DDM_WhoDrugDDEB2-ENG-201306.txt" to "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM"
	And uploading synonym list file "SynonymUpload_SinlgePath_DDM_JDrug-Jpn-2013H1.txt" to "J-Drug JPN 2013H1 JDrug_DDM"
	Then the number of synonyms for list "MedDRA ENG 16.0 MedDRA_DDM" is "0"
	And the number of synonyms for list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" is "0"
	And the number of synonyms for list "J-Drug JPN 2013H1 JDrug_DDM" is "0"
	And the synonym list "MedDRA ENG 16.0 MedDRA_DDM" cannot be downloaded
	And the synonym list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" cannot be downloaded
	And the synonym list "J-Drug JPN 2013H1 JDrug_DDM" cannot be downloaded
    And synonyms for verbatim terms should be created and exist in lists
	| verbatim          | dictionaryLocaleVersionSynonymListName   | exists |
	| HEADACHE          | MedDRA ENG 16.0 MedDRA_DDM               | false  |
	| PAIN FREE         | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | false  |
	| METHANOL          | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | false  |
	| イマジニール３００ | J-Drug JPN 2013H1 JDrug_DDM              | false  |
	
@VAL
@PBMCC_196870_002
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: When the Auto Approve option is "Off" and uploading Single path Direct Dictionary Matches; upon completing the upload, the synonyms shall be available to download and the count shall change
 
 	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
	| JDrug_DDM                  | JDrug                       | 2013H1                    | JPN    |
	When uploading synonym list file "SynonymUpload_SinglePath_DDM_MedDRA-Eng-160.txt" to "MedDRA ENG 16.0 MedDRA_DDM"
	And uploading synonym list file "SynonymUpload_SinlgePath_DDM_WhoDrugDDEB2-ENG-201306.txt" to "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM"
	And uploading synonym list file "SynonymUpload_SinlgePath_DDM_JDrug-Jpn-2013H1.txt" to "J-Drug JPN 2013H1 JDrug_DDM"
	Then the number of synonyms for list "MedDRA ENG 16.0 MedDRA_DDM" is "1"
	And the number of synonyms for list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" is "2"
	And the number of synonyms for list "J-Drug JPN 2013H1 JDrug_DDM" is "1"
	And the synonym list "MedDRA ENG 16.0 MedDRA_DDM" can be downloaded
	And the synonym list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" can be downloaded
	And the synonym list "J-Drug JPN 2013H1 JDrug_DDM" can be downloaded
	
@VAL
@PBMCC_196870_003
@Release2015.3.0
Scenario: When the Auto Approve option is "On" and uploading Multiple path MedDRA Direct Dictionary Matches; upon completing the upload, the synonyms shall not be available to download and the count shall not change
 
 	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
	When uploading synonym list file "SynonymUpload_MultiPath_DDM_MedDRA-Eng-160.txt" to "MedDRA ENG 16.0 MedDRA_DDM"
	Then the number of synonyms for list "MedDRA ENG 16.0 MedDRA_DDM" is "0"
	And the synonym list "MedDRA ENG 16.0 MedDRA_DDM" cannot be downloaded
    And synonyms for verbatim terms should be created and exist in lists
	| verbatim                              | dictionaryLocaleVersionSynonymListName | exists |
	| BROKEN LEG                            | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	| SWELLING ARM                          | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	| PROFOUND VISION IMPAIRMENT, BOTH EYES | MedDRA ENG 16.0 MedDRA_DDM             | false  |

@VAL
@PBMCC_196870_004
@Release2015.3.0
Scenario: When the Auto Approve option is "On" and uploading Multiple path nonMedDRA Direct Dictionary Matches; upon completing the upload, the synonyms shall be available to download and the count shall change
 
 	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
	When uploading synonym list file "SynonymUpload_MultiPath_DDM_WhoDrugDDEB2-ENG-201306.txt" to "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM"
	Then the number of synonyms for list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" is "4"
	And the synonym list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" can be downloaded
 
@VAL
@PBMCC_196870_005
@Release2015.3.0
Scenario: When the Auto Approve option is "Off" and uploading Multiple path Direct Dictionary Matches; upon completing the upload, the synonyms shall be available to download and the count shall change
 
 	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
	When uploading synonym list file "SynonymUpload_MultiPath_DDM_MedDRA-Eng-160.txt" to "MedDRA ENG 16.0 MedDRA_DDM"
	And uploading synonym list file "SynonymUpload_MultiPath_DDM_WhoDrugDDEB2-ENG-201306.txt" to "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM"
	Then the number of synonyms for list "MedDRA ENG 16.0 MedDRA_DDM" is "3"
	And the number of synonyms for list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" is "4"
	And the synonym list "MedDRA ENG 16.0 MedDRA_DDM" can be downloaded
	And the synonym list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" can be downloaded
