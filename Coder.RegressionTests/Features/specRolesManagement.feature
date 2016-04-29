@specRolesManagement.feature
@CoderCore
Feature: RolesManagement Illustrates the functional behavior of "Action Options" associated with: Create WorkFlow Role, Assign WorkFlow Role, Create General Role and Assign General Role

 Common Configurations:
 Configuration Name | Force Primary Path Selection (MedDRA) | Synonym Creation Policy Flag | Bypass Reconsider Upon Reclassify | Default Select Threshold  | Default Suggest Threshold | Auto Add Synonyms | Auto Approve  | Term Requires Approval (IsApprovalRequired )  | Term Auto Approve with synonym (IsAutoApproval) | Page Study Security| Page Dictionary Security |
 Basic              | TRUE                                  | Always Active                | TRUE                              | 100                       | 70                        | TRUE              | FALSE         | TRUE                                          | TRUE                                            | All                | All                      |
 No Approval        | TRUE                                  | Always Active                | TRUE                              | 100                       | 70                        | TRUE              | FALSE         | FALSE                                         | TRUE                                            | All                | All                      |




@VAL
@PBMCC168582_01
@Release2015.3.0
Scenario: A Coder Admin is able to create a workflow role, activate it and assign all role actions to it. 
   Given an admin user
   When creating and activating a new workflow role called "RolesAdmin" 
   Then the workflow role "RolesAdmin" is active 
   

@VAL
@PBMCC168582_02
@Release2015.3.0
Scenario: A Coder Admin is able to assign workflow role to a user
   Given an admin user
   When creating and activating a new workflow role called "RolesAdmin" 
   And assigning workflow role "RolesAdmin" for "All" study
   Then the workflow role "RolesAdmin" for study "All" is assigned


@VAL
@PBMCC168582_03
@Release2015.3.0
Scenario Outline: A Coder Admin is able remove Role Actions associated with a Workflow Role
   Given an admin user
   When removing the assigned action "<Actions>" from Workflow Role "WorkflowRole" 
   Then the following "<Actions>" are not assigned to "WorkflowRole"
Examples: 
     | Actions         |
     | Add Comment     |
     | Approve         |
     | Browse And Code |
     | ReCode          |


@VAL
@PBMCC168582_04
@Release2015.3.0
Scenario: A Coder Admin is able to deactivate a Workflow Role
   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "Adverse Event 1" for dictionary level "LLT"
   When deactivating Workflow Role "WorkflowRole"
   Then The task count is "0"


@VAL
@PBMCC168582_05
@Release2015.3.0
@IncreaseTimeout
Scenario: A coder user's ability to perform the following actions on a task, can be restricted: "Approve, RecCode or Open Query" 
   Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "Headache" for dictionary level "LLT"
   When removing the assigned Actions from workflow role "WorkflowRole"
     | Actions    |
     | Approve    |
     | ReCode     |
     | Open Query |
   Then the user is unable to perform the following Task Actions for the task "Headache"
     | Actions    |
     | Approve    |
     | ReCode     |
     | Open Query |


@VAL
@PBMCC168582_06
@Release2015.3.0
Scenario: A coder user's ability to perform the following actions on a task, can be restricted: "Code and Add Comment"
   Given a "Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "Heart Burn" for dictionary level "LLT"
   When removing the assigned Actions from workflow role "WorkflowRole"
     | Actions         |
     | Add Comment     |
     | Browse And Code |
   Then the user is unable to perform the following Task Actions for the task "Heart Burn"
     | Actions     |
     | Add Comment |
     | Code        |


@VAL
@PBMCC168582_07
@Release2015.3.0
@IncreaseTimeout
Scenario: A coder user's ability to perform the following actions on a task, can be restricted: "Leave As Is or Reject Coding Decision"
   Given a "Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "Headache" for dictionary level "LLT"
   When reclassifying task "Headache" with Include Autocoded Items set to "True"
   And removing the assigned Actions from workflow role "WorkflowRole"
     | Actions                |
     | Leave As Is            |
     | Reject Coding Decision |
   Then the user is unable to perform the following Task Actions for the task "Headache"
     | Actions                |
     | Leave As Is            |
     | Reject Coding Decision |

@VAL
@PBMCC168582_08
@Release2015.3.0
   Scenario: A Coder Admin can revoke a user's access to a workflow role
   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "Adverse Event 1" for dictionary level "LLT"
   When denying access to Workflow Role "WorkflowRole" for "All" study
   Then The task count is "0"


@VAL
@PBMCC168582_09
@Release2015.3.0
   Scenario: A Study Admin can remove a workflow role from a study
   Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
   And coding task "Adverse Event 1" for dictionary level "LLT"
   When removing Workflow Role "WorkflowRole" for "All" study
   Then The task count is "0"


@VAL
@PBMCC168593_01
@Release2015.3.0
Scenario: A CoderAmin is able to create and activate "Page Study Security" role
   Given an admin user
   When creating and activating a "Page Study Security" role called "GeneralRole"
   Then the "Page Study Security" role "StudyAdmin" is active


@VAL
@PBMCC168593_02
@Release2015.3.0
Scenario: A CoderAmin is able to create and activate "Page Dictionary Security" role
   Given an admin user
   When creating and activating a "Page Dictionary Security" role called "GeneralRole"
   Then the "Page Dictionary Security" role "DictionaryAdmin" is active


@VAL
@PBMCC168593_03
@Release2015.3.0
Scenario: A CoderAmin is able assign General role "Page Study Security" a Coder User
   Given an admin user
   When creating and activating a "Page Study Security" role called "GeneralRole"
   And assigning "Page Study Security" General Role "GeneralRole" for "All" type
   Then the "Page Study Security" General Role "GeneralRole" for type "All" is assigned


@VAL
@PBMCC168593_04
@Release2015.3.0
Scenario: A CoderAmin is able assign General role "Page Dictionary Security" a Coder User
   Given an admin user
   When creating and activating a "Page Dictionary Security" role called "GeneralRole"
   And assigning "Page Dictionary Security" General Role "GeneralRole" for "All" type
   Then the "Page Dictionary Security" General Role "GeneralRole" for type "All" is assigned


@VAL
@PBMCC168593_05
@Release2015.3.0
Scenario: A CoderAdmin is able to restrict access to the following Coder reports "Coding History Report, Ingredient Report, Study Report"
   Given an admin user
   When removing the assigned Actions from "Page Study Security" Role "StudyAdmin"
       | Actions               |
       | Coding History Report |
       | Study Report          |
   Then the user will not have access to the following reports
       | Reports               |
       | Coding History Report |
       | Ingredient Report     |
       | Study Report          |


@VAL
@PBMCC168593_06
@Release2015.3.0
Scenario: A CoderAdmin is able to restrict access to the following functions: "Reclassification and View Impact Analysis"
   Given an admin user
   When removing the assigned Actions from "Page Dictionary Security" Role "DictionaryAdmin"
       | Actions              |
       | Reclassification     |
       | View Impact Analysis |
   Then the user will not have access to the following functions
       | Functions             |
       | Reclassification      |
       | Study Impact Analysis |   

@DFT
@PBMCC168593_08
@Release2015.3.0
@ignore
#TODO: This is now an end-to-end test. Move to that project once merging is complete
Scenario: A CoderAdmin is able to deny access to general role "SegmentAdmin" options
   Given an admin user
   When assigning "Segment Security" General Role "SegmentAdmin"
   When I deny "Segment Security" access to "All" segments for general role "SegmentAdmin"
   Then the user will not have access to the following functions 
      | Function             |
      | Assign General Role  |
      | Assign Workflow Role |
      | Configuration        |
      | Create Workflow Role |
      | Create General Role  |
      | Project Registration |
      | Do Not Auto Code     |


@VAL
@PBMCC_195032_001
@Release2015.3.0
Scenario: A Study Impact Analysis Report can be generated by a user without access to Edit Study Migration Report
	Given a "Waiting Approval" Coder setup with registered synonym list "MedDRA ENG 11.0 Roles_Managment" containing entry ""
	And coding task "Great toe fracture" for dictionary level "LLT"
	And an activated synonym list "MedDRA ENG 12.0 Primary_List"
	When removing the assigned Actions from "Page Study Security" Role "StudyAdmin"
         | Actions               |
         | Edit StudyIncludeKeep |
    And performing Study Impact Analysis
	Then the following study impact analyis actions will be available
		| Generate Report | Migrate Study | Edit Study Analysis | Export Report |
		| True            | True          | False               | True          |
		

@VAL
@PBMCC_195032_002
@Release2015.3.0
Scenario: A Study Impact Analysis Report can be generated by a user without access to Migrate Study
	Given a "Waiting Approval" Coder setup with registered synonym list "MedDRA ENG 11.0 Roles_Managment" containing entry ""
	And coding task "Great toe fracture" for dictionary level "LLT"
	And an activated synonym list "MedDRA ENG 12.0 Primary_List"
	When removing the assigned Actions from "Page Study Security" Role "StudyAdmin"
         | Actions       |
         | Migrate Study |
    And performing Study Impact Analysis
	Then the following study impact analyis actions will be available
		| Generate Report | Migrate Study | Edit Study Analysis | Export Report |
		| True            | False         | True                | True          |
		

@VAL
@PBMCC_195032_003
@Release2015.3.0
Scenario: A Study Impact Analysis Report can be generated by a user without access to Edit Study Migration Report or Migrate Study
	Given a "Waiting Approval" Coder setup with registered synonym list "MedDRA ENG 11.0 Roles_Managment" containing entry ""
	And coding task "Great toe fracture" for dictionary level "LLT"
	And an activated synonym list "MedDRA ENG 12.0 Primary_List"
	When removing the assigned Actions from "Page Study Security" Role "StudyAdmin"
         | Actions               |
         | Edit StudyIncludeKeep |
         | Migrate Study         |
    And performing Study Impact Analysis
	Then the following study impact analyis actions will be available
		| Generate Report | Migrate Study | Edit Study Analysis | Export Report |
		| True            | False         | False               | True          |