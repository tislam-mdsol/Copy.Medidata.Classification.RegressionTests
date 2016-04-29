@specAdminConfigurationManagement.feature
@CoderCore
Feature: ConfigurationsManagement is for verifying the different configurations models used for Coder testing scenarios are working as expected.  The following is a list of current configuration models used for Coder testing

 Configuration Name  | Force Primary Path Selection (MedDRA) | Synonym Creation Policy Flag | Bypass Reconsider Upon Reclassify | Default Select Threshold | Default Suggest Threshold | Auto Add Synonyms | Auto Approve | Term Requires Approval (IsApprovalRequired )  | Term Auto Approve with synonym (IsAutoApproval)
   Basic          | TRUE                                  | Always Active                   | TRUE                              | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE  |          
   No Approval    | TRUE                                  | Always Active                   | TRUE                              | 100                      | 70                        | TRUE              | FALSE        | FALSE                                         | TRUE  |
   Reconsider     | TRUE                                  | Always Active                   | FALSE                             | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE  |
   Approval       | TRUE                                  | Always Active                   | FALSE                             | 100                      | 70                        | FALSE             | FALSE        | TRUE                                          | FALSE |

   

@VAL
@PBMCC_166013_01
@Release2015.3.0
Scenario: The Coder Configuration allows user to set Coder configuration values for a Basic Coder setup

 Given Coder Configurations
 When setting up a "Basic" configuration for "MedDRA"
 Then the following Coder Configuration should exist
	 | Force Primary Path Selection | Synonym Creation Policy Flag | Bypass Reconsider Upon Reclassify | Auto Add Synonyms | Auto Approve |
	 | True                         | Always Active                | True                              | True              | False        |        


@VAL
@PBMCC_166013_02
@Release2015.3.0
Scenario: The Coder Configuration allows user to set Coder configuration values for a No Approval Coder setup
 Given Coder Configurations
 When setting up a "No Approval" configuration for "WhoDrugDDEB2"
 Then the following Coder Configuration should exist
 | Force Primary Path Selection | Synonym Creation Policy Flag | Bypass Reconsider Upon Reclassify | Auto Add Synonyms | Auto Approve |
 | True                         | Always Active                | True                              | True              | False        |
 

@VAL
@PBMCC_166013_03
@Release2015.3.0
Scenario: The Coder Configuration allows user to set Coder configuration values for a Reconsider Coder setup
 Given Coder Configurations
 When setting up a "Reconsider" configuration for "J-Drug"
 Then the following Coder Configuration should exist
 | Force Primary Path Selection | Synonym Creation Policy Flag | Bypass Reconsider Upon Reclassify | Auto Add Synonyms | Auto Approve |
 | True                         | Always Active                | False                             | True              | False        |
 

@VAL
@PBMCC_166013_04
@Release2015.3.0
Scenario: The Coder Configuration allows user to set Coder configuration values an Approval Coder setup
 Given Coder Configurations
 When setting up a "Approval" configuration for "AZDD"
 Then the following Coder Configuration should exist
 | Force Primary Path Selection | Synonym Creation Policy Flag | Bypass Reconsider Upon Reclassify | Auto Add Synonyms | Auto Approve |
 | True                         | Always Active                | False                             | False             | False        |