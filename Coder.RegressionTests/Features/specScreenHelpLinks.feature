@specScreenHelpLinks.feature
@CoderCore
Feature: Verify Coder Pages Screen Help interfaces

Background: Basic setup
Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"

@VAL
@PBMCC177507_01
@Release2015.3.0
Scenario: Verify help section for Tasks
    When acessing help content "Help On This Page" for Tasks
    Then the help header should be "Selecting and Coding Verbatim Terms"
	
	 
@VAL
@PBMCC177507_02
@Release2015.3.0
Scenario: Verify help section for Reclassify
    When accessing help content "Help On This Page" for "Reclassification"
    Then the help header should be "About Reclassifying Terms"

@VAL
@PBMCC177507_03
@Release2015.3.0
Scenario: Verify help section for Synonyms
    When accessing help content "Help On This Page" for "Synonym"
    Then the help header should be "Migrating and Managing Medidata Coder Synonym Lists"

@VAL
@PBMCC177507_04
@Release2015.3.0
Scenario: Verify help section for Synonym Lists
    When accessing help content "Help On This Page" for "Synonym List"
    Then the help header should be "Uploading and Downloading Synonyms"

@VAL
@PBMCC177507_05
@Release2015.3.0
Scenario: Verify help section for Synonym Approvals
    When accessing help content "Help On This Page" for "Synonym Approval"
    Then the help header should be "Managing, Approving, and Retiring Synonyms in Medidata Coder"

@VAL
@PBMCC177507_06
@Release2015.3.0
Scenario: Verify help section for Study Impact Analysis
    When accessing help content "Help On This Page" for "Study Impact Analysis"
    Then the help header should be "Migrating Coder Studies"

@VAL
@PBMCC177507_07
@Release2015.3.0
Scenario: Verify help section for Configurations
    When accessing help content "Help On This Page" for "Configuration"
    Then the help header should be "Configuring Medidata Coder"

@VAL
@PBMCC177507_08
@Release2015.3.0
Scenario: Verify help section for Create Workflow Roles
    When accessing help content "Help On This Page" for "Create Workflow Role"
    Then the help header should be "Creating and Assigning Medidata Coder Workflow Roles"


@VAL
@PBMCC177507_09
@Release2015.3.0
Scenario: Verify help section for Assign Workflow Roles
    When accessing help content "Help On This Page" for "Assign Workflow Role"
    Then the help header should be "Creating and Assigning Medidata Coder Workflow Roles"

@VAL
@PBMCC177507_10
@Release2015.3.0
Scenario: Verify help section for Create General Role Pages
    When accessing help content "Help On This Page" for "Create General Role"
    Then the help header should be "Creating and Assigning Medidata Coder General Roles"

@VAL
@PBMCC177507_11
@Release2015.3.0
Scenario: Verify help section for Assign General Roles
    When accessing help content "Help On This Page" for "Assign General Role"
    Then the help header should be "Creating and Assigning Medidata Coder General Roles"


@VAL
@PBMCC177507_12
@Release2015.3.0
Scenario: Verify help section for Project Registration
    When accessing help content "Help On This Page" for "Project Registration"
    Then the help header should be "Registering a Medidata Coder Project"

@VAL
@PBMCC177507_13
@Release2015.3.0
Scenario: Verify help section for Coding Decisions Report
    When accessing help content "Help On This Page" for "Coding Decisions Report" report
    Then the help header should be "Medidata Coder Coding Decisions Report"

@VAL
@PBMCC177507_14
@Release2015.3.0
Scenario: Verify help section for Study Report
    When accessing help content "Help On This Page" for "Study Report" report
    Then the help header should be "Medidata Coder Study Report"

@VAL
@PBMCC177507_15
@Release2015.3.0
Scenario: Verify help section for Coding History Report
    When accessing help content "Help On This Page" for "Coding History Report" report
    Then the help header should be "Medidata Coder Coding History Report"

@VAL
@PBMCC177507_16
@Release2015.3.0
Scenario: Verify help section for Ingredient Report
    When accessing help content "Help On This Page" for "Ingredient Report" report
    Then the help header should be "Medidata Coder Ingredient Report"


