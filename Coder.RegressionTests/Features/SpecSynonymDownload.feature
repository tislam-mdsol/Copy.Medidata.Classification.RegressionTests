@specSynonymDownload.feature
@CoderCore
Feature: This feature will demonstrate Coder's functionality on downloading a synonym list.
This feature file contains cases for different sized environments. 
One set, for the lower environments, includes a smaller set of synonyms, approximately 3500. 
A 50K version has been created for production sized environments.

Objective evidence of the runs is kept as the uploaded and downloaded txt files. Their stored location is set in AdminSynonymSteps.cs.

_ The following environment configuration settings were enabled:

   Empty Synonym Lists Registered:
   Synonym List 1: MedDRA              (ENG) 12.0     Primary_List
   Synonym List 2: MedDRA              (ENG) 16.0     Primary_List

   Common Configurations:
   Configuration Name       | Declarative Browser Class | 
   Basic                    | BasicSetup                | 

@VAL
@PBMCC_196257_001
@Release2015.3.0
@IncreaseTimeout_600000
Scenario: Coder will allow a user to be able to download a synonym list file from the Synonym page.

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary_List           | MedDRA                | 12.0                      | ENG    |
	When uploading synonym list file "SynonymUpload_PrimaryList.txt" to "MedDRA ENG 12.0 Primary_List"
	Then the loading of synonym list file "SynonymUpload_PrimaryList.txt" is completed without errors
	When downloading a synonym list file from "MedDRA ENG 12.0 Primary_List" on the Synonym page to "DownloadedSynonymListFile.txt"
	Then the contents of the uploaded "SynonymUpload_PrimaryList.txt" and the downloaded "DownloadedSynonymListFile.txt" synonym list files match

@VAL
@PBMCC_196257_002
@Release2015.3.0
@IncreaseTimeout_600000
Scenario: Coder will allow a user to be able to download a synonym list file from the Synonym List page.

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary_List           | MedDRA                | 12.0                      | ENG    |
	When uploading synonym list file "SynonymUpload_PrimaryList.txt" to "MedDRA ENG 12.0 Primary_List"
	Then the loading of synonym list file "SynonymUpload_PrimaryList.txt" is completed without errors
	When downloading a synonym list file from "MedDRA ENG 12.0 Primary_List" on the Synonym List page to "DownloadedSynonymListFile.txt"
	Then the contents of the uploaded "SynonymUpload_PrimaryList.txt" and the downloaded "DownloadedSynonymListFile.txt" synonym list files match
	
@DFT
@PBMCC_196257_003
@Release2015.3.0
@IncreaseTimeout_1200000
@ignore
#Bug: MCC-205688 - Unable to download 50k synonym list
Scenario: Coder will allow a user to be able to download a large synonym list file from the Synonym page.

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary_List           | MedDRA                | 16.0                      | ENG    |
	When uploading synonym list file "SynonymUpload_PrimaryList_50K_MedDRA-Eng-160.txt" to "MedDRA ENG 16.0 Primary_List"
	Then the loading of synonym list file "SynonymUpload_PrimaryList_50K_MedDRA-Eng-160.txt" is completed without errors
	When downloading a synonym list file from "MedDRA ENG 16.0 Primary_List" on the Synonym page to "DownloadedSynonymListFile.txt"
	Then the contents of the uploaded "SynonymUpload_PrimaryList_50K_MedDRA-Eng-160.txt" and the downloaded "DownloadedSynonymListFile.txt" synonym list files match

@DFT
@PBMCC_196257_004
@Release2015.3.0
@IncreaseTimeout_1200000
@ignore
#Bug: MCC-205688 - Unable to download 50k synonym list
Scenario: Coder will allow a user to be able to download a large synonym list file from the Synonym List page.

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName        | Dictionary            | Version                   | Locale |
	| Primary_List           | MedDRA                | 16.0                      | ENG    |
	When uploading synonym list file "SynonymUpload_PrimaryList_50K_MedDRA-Eng-160.txt" to "MedDRA ENG 16.0 Primary_List"
	Then the loading of synonym list file "SynonymUpload_PrimaryList_50K_MedDRA-Eng-160.txt" is completed without errors
	When downloading a synonym list file from "MedDRA ENG 16.0 Primary_List" on the Synonym List page to "DownloadedSynonymListFile.txt"
	Then the contents of the uploaded "SynonymUpload_PrimaryList_50K_MedDRA-Eng-160.txt" and the downloaded "DownloadedSynonymListFile.txt" synonym list files match



