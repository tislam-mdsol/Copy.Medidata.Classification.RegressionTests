@specReclassifyWorkFlow.feature
@CoderCore
Feature: Illustrate the work flow when Reclassifying a term
  
   Common Configurations:
   Configuration Name	| Force Primary Path Selection (MedDRA) | Synonym Creation Policy Flag	| Bypass Reconsider Upon Reclassify 	| Default Select Threshold 	| Default Suggest Threshold	| Auto Add Synonyms 	| Auto Approve 	| Term Requires Approval (IsApprovalRequired )  | Term Auto Approve with synonym (IsAutoApproval)	|
   Basic		        | TRUE					| Always Active			| TRUE					| 100				| 70				| TRUE			| FALSE		| TRUE						| TRUE							|							
   Reconsider		| TRUE					| Always Active			| FALSE					| 100				| 70				| TRUE 			| FALSE		| TRUE						| TRUE							|
   


@VAL
@PBMCC_168609_01
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: Coder users are able to Reclassify a coded term without removing the synonym for that term
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	And coding task "Heart Burn" for dictionary level "LLT"
	When task "Heart Burn" is coded to term "Reflux gastritis" at search level "Low Level Term" with code "10057969" at level "LLT" and a synonym is created
	And reclassifying task "Heart Burn" with Include Autocoded Items set to "True"
	Then the synonym for verbatim "HEART BURN" and code "10057969" should be active


@VAL
@PBMCC_168609_02
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: Coder users are able to Reclassify a term and retire the mapped synonym 
    Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 Clear_Match" containing entry "HEADACHE|10019211|LLT|LLT:10019211;PT:10019211;HLT:10019233;HLGT:10019231;SOC:10029205|True|AE.AECAT:OTHER|Approved|Headache"
	And coding task "Heart Burn" for dictionary level "LLT"
	When task "Heart Burn" is coded to term "Reflux gastritis" at search level "Low Level Term" with code "10057969" at level "LLT" and a synonym is created
	And reclassifying and retiring synonym task "Heart Burn" with Include Autocoded Items set to "True"
	Then the synonym for verbatim "HEART BURN" and code "10057969" should not exist

@VAL
@PBMCC_168609_03
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: A Coder user can reject a coding decision of a reclassified term
	Given a "Reconsider" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And coding task "Heart Burn" for dictionary level "LLT"
	When task "Heart Burn" is coded to term "Reflux gastritis" at search level "Low Level Term" with code "10057969" at level "LLT" and a synonym is created
	And reclassifying task "Heart Burn" with Include Autocoded Items set to "True"
	And rejecting coding decision for the task "Heart Burn"
	Then the task "Heart Burn" should have a status of "Waiting Manual Code"


@VAL
@PBMCC_168609_04
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: User has the option to reject the coding decision of reclassified term
	Given a "Reconsider" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And coding task "Heart Burn" for dictionary level "LLT"
	When task "Heart Burn" is coded to term "Reflux gastritis" at search level "Low Level Term" with code "10057969" at level "LLT" and a synonym is created
	And reclassifying task "Heart Burn" with Include Autocoded Items set to "True"
	And rejecting coding decision for the task "Heart Burn"
	Then the task "Heart Burn" should have a status of "Waiting Manual Code"
	

@VAL
@PBMCC_168609_05
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: A Coder user can Reclassify a group and place it in the "Reconsider" state
	Given a "Reconsider" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	When the following externally managed verbatim requests are made
		| Verbatim Term | Dictionary Level |
		| Heart Burn    | LLT              |
		| Heart Burn    | LLT              |
	And task "Heart Burn" is coded to term "Reflux gastritis" at search level "Low Level Term" with code "10057969" at level "LLT" 
	And approving task "HEART BURN"
	And reclassifying group for the task "HEART BURN" with Include Autocoded Items set to "True"
	Then the task "Heart Burn" should have a status of "Reconsider"

@VAL
@PBMCC_168609_06
@Release2015.3.0
@IncreaseTimeout_300000
Scenario: A Coder user can Reclassify group and retire the mapped synonym
	Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 Clear_Match" containing entry "HEADACHE|10019211|LLT|LLT:10019211;PT:10019211;HLT:10019233;HLGT:10019231;SOC:10029205|True|AE.AECAT:OTHER|Approved|Headache"
	When the following externally managed verbatim requests are made
		| Verbatim Term | Dictionary Level |
		| Heart Burn    | LLT              |
		| Heart Burn    | LLT              |
	And task "Heart Burn" is coded to term "Reflux gastritis" at search level "Low Level Term" with code "10057969" at level "LLT" and a synonym is created
	And reclassifying and retiring group for the task "HEART BURN" with Include Autocoded Items set to "True"
	Then the synonym for verbatim "HEART BURN" and code "10057969" should not exist
	
@VAL
@PBMCC_193388_002
@Release2015.3.0
@IncreaseTimeout_600000
Scenario: A Coder user shall not be able to reclassify a task while the task's study is being migrated
  
    Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 14.0 Empty_List" containing entry ""
    And an activated synonym list "MedDRA ENG 15.0 New_Primary_List"
    When the following externally managed verbatim requests are made "Tasks_1000_MedDRA_Match_Upload.json"
    When performing study migration without waiting
    Then reclassification of coding task "ABRASIONS" cannot occur while the study migration is in progress
    And study migration is complete for the latest version
    When reclassifying task "ABRASIONS" with comment "Reclassified After Study Migration"
    And I view task "ABRASIONS"
    Then the task "ABRASIONS" should have a status of "Waiting Manual Code"
