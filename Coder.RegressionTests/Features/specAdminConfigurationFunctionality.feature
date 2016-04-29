@specAdminConfigurationFunctionality.feature
@CoderCore
Feature: ConfigurationsFunctionality verifies the behaviour of Coder configurations options  

 Common Configurations:
 Configuration Name | Force Primary Path Selection (MedDRA) | Synonym Creation Policy Flag | Bypass Reconsider Upon Reclassify | Default Select Threshold  | Default Suggest Threshold | Auto Add Synonyms | Auto Approve  | Term Requires Approval (IsApprovalRequired )  | Term Auto Approve with synonym (IsAutoApproval) |
 Basic              | TRUE                                  | Always Active                | TRUE                              | 100                       | 70                        | TRUE              | FALSE         | TRUE                                          | TRUE                                            |
 No Approval        | TRUE                                  | Always Active                | TRUE                              | 100                       | 70                        | TRUE              | FALSE         | FALSE                                         | TRUE                                            |
 Reconsider         | TRUE                                  | Always Active                | FALSE                             | 100                       | 70                        | TRUE              | FALSE         | TRUE                                          | TRUE                                            |
 Approval           | TRUE                                  | Always Active                | FALSE                             | 100                       | 70                        | FALSE             | FALSE         | TRUE                                          | FALSE                                           |


@VAL
@PBMCC166013_05
@Release2015.3.0
Scenario Outline: Coder prevents setting configuration values outside of configuration option's limits

   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When entering value "<Entry Value>" for Configuration "<Text Box Name>" and save
   Then I should see a warning message of "Invalid Entries"
   And I should see a limit value of "<Limit Value>" for "<Text Box Name>"

Examples:
   | Entry Value | Text Box Name                         | Limit Value |
   | 101         | Coding Task Page Size                 | [10 - 100]  |
   | 9           | Coding Task Page Size                 | [10 - 100]  |
   | 1001        | Search Limit Reclassification Results | [10 - 1000] |
   | 9           | Search Limit Reclassification Results | [10 - 1000] |
 
  
@VAL
@PBMCC166013_06
@Release2015.3.0
Scenario: Coder configuration "Search Limit Reclassification Results" allows user to control the number of results displayed on the Reclassification Page  
   Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When uploading "30" MedDRA direct dictionary matches
   And entering value "15" for Configuration "Search Limit Reclassification Results" and save
   And setting reclassification search value "True" for "IncludeAutocodedItems"
   And performing reclassification search
   Then the reclassification results page summary should contain
   | Paging Label           | Results Label            |
   | Page 1 of 2 (15 Items) | Showing 15 of 30 Results |
 
@VAL
@PBMCC166013_07
@Release2015.3.0
Scenario: Coder configuration "Coding Task Page Size Text field" allows user to control the number of tasks displayed on the Coder Task Page 
   Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   When uploading "30" MedDRA direct dictionary matches
   And entering value "10" for Configuration "Coding Task Page Size" and save
   Then The task count is "30"
   And the tasks results should contain page summary "Page 1 of 3 (30 Items)"


@VAL
@PBMCC166013_08
@Release2015.3.0
@IncreaseTimeout_360000
Scenario: Coder allows users to code non-primary paths when "Force Primary Path Selection" is set to "False"
   Given a "No Enforced Primary Path" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "Adverse Event 1" for dictionary level "LLT"
   When a browse and code for task "Adverse Event 1" is performed
   And including non primary paths in the dictionary search criteria
   And the browse and code search is done for "Heart attack" against "Text" at Level "Low Level Term"
   And selecting the primary path "false" dictionary result for term "Heart attack" code "10019250" level "LLT"
   Then the task should be able to be coded to the following terms
		| Term Path    | Code     | Level |
		| Heart attack | 10019250 | LLT   |
   
@DFT
@PBMCC166013_09
@Release2015.3.0
@IncreaseTimeout_360000
@ignore
#Bug: MCC-205296
Scenario: Coder does not allow users to code non-primary paths when "Force Primary Path Selection" is set to "True" 
   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "Adverse Event 1" for dictionary level "LLT"
   When a browse and code for task "Adverse Event 1" is performed
   And the browse and code search is done for "Heart attack" against "Text" at Level "Low Level Term"
   And selecting the primary path "false" dictionary result for term "Heart attack" code "10019250" level "LLT"
   Then the task should not be able to be coded to the following terms
		| Term Path    | Code     | Level |
		| Heart attack | 10019250 | LLT   |
   
@VAL
@PBMCC166013_10
@Release2015.3.0
@IncreaseTimeout_360000
Scenario: Coder allows users to code primary paths when "Force Primary Path Selection" is set to "False"
   Given a "No Enforced Primary Path" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "Adverse Event 1" for dictionary level "LLT"
   When a browse and code for task "Adverse Event 1" is performed
   And including non primary paths in the dictionary search criteria
   And the browse and code search is done for "Heart attack" against "Text" at Level "Low Level Term"
   And selecting the primary path "true" dictionary result for term "Heart attack" code "10019250" level "LLT"
   Then the task should be able to be coded to the following terms
		| Term Path    | Code     | Level |
		| Heart attack | 10019250 | LLT   |
   
   
@VAL
@PBMCC166013_11
@Release2015.3.0
@IncreaseTimeout_360000
Scenario: Coder allows users to code primary paths when "Force Primary Path Selection" is set to "True"
   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "Adverse Event 1" for dictionary level "LLT"
   When a browse and code for task "Adverse Event 1" is performed
   And the browse and code search is done for "Heart attack" against "Text" at Level "Low Level Term"
   And selecting the primary path "true" dictionary result for term "Heart attack" code "10019250" level "LLT"
   Then the task should be able to be coded to the following terms
		| Term Path    | Code     | Level |
		| Heart attack | 10019250 | LLT   |

@VAL
@PBMCC166013_12
@Release2015.3.0
Scenario: Coder does not allow auto-coding when "Force Primary Path Selection" is set to "False" 
   Given a "No Enforced Primary Path" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "Heart Attack" for dictionary level "LLT"
   Then the task "Heart Attack" should have a status of "Waiting Manual Code"
   