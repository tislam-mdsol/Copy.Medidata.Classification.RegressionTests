@specHelpCenterLinks.feature
@CoderCore
Feature: Verify user is able to view Help Center content from all Coder pages


Background: Basic setup
Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"

@VAL
@PBMCC177584_01
@Release2015.3.0
Scenario: Verify Help Center Content is viewable from Coder Tasks Page
    When accessing help center content "Help Center" for Tasks
    Then the help center header should be "Submit A Request"

@VAL
@PBMCC177584_02
@Release2015.3.0
Scenario Outline: Verify Help Center Content is viewable from Coder Administration Pages
    When accessing help center content "Help Center" for "<AdminPage>"
    Then the help center header should be "Submit A Request"
	
	Examples:
        | AdminPage             |
        | Reclassification      |
        | Synonym               |
        | Synonym List          |
        | Synonym Approval      |
        | Study Impact Analysis |
        | Configuration         |
        | Create Workflow Role  |
        | Assign Workflow Role  |
        | Create General Role   |
        | Assign General Role   |
        | Project Registration  |


@VAL
@PBMCC177584_03
@Release2015.3.0
Scenario Outline: Verify Help Center Content is viewable from Coder Report Pages
    When accessing help center content "Help Center" for "<ReportPage>" report
    Then the help center header should be "Submit A Request"
	
	Examples:
        | ReportPage              |
        | Coding Decisions Report |
        | Study Report            |
        | Coding History Report   |
        | Ingredient Report       |
       
