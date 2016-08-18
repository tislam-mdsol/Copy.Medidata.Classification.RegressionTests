@specKnowledgeSpaceLinks.feature
@CoderCore
Feature: Verify User Is Able to View Knowledge Space Content From All Coder Pages


Background: Basic setup
Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"

@VAL
@PBMCC1177593_01
@Release2015.3.0
@IncreaseTimeout_360000
Scenario: Verify Knowledge Space Content is viewable from Coder Tasks Page
    When acessing help content "Knowledge Space Home" for Tasks
    Then the help header should be "Medidata Coder Home"

@VAL
@PBMCC177593_02
@Release2015.3.0
@IncreaseTimeout_420000
Scenario Outline: Verify Knowledge Space Content is viewable from Coder Administration Pages
    When accessing help content "Knowledge Space Home" for "<AdminPage>"
    Then the help header should be "Medidata Coder Home"
	
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
@PBMCC177593_03
@Release2015.3.0
@IncreaseTimeout_360000
Scenario Outline: Verify Knowledge Space Content is viewable from Coder Reports Pages
    When accessing help content "Knowledge Space Home" for "<ReportPage>" report
    Then the help header should be "Medidata Coder Home"
	
	Examples:
        | ReportPage              |
        | Coding Decisions Report |
        | Study Report            |
        | Coding History Report   |
        | Ingredient Report       |

       