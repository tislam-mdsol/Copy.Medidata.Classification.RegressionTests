@specContextHelpLinks.feature
@CoderCore
Feature: Verify Context Help Links


Background: Basic setup
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
    And coding task "Heart Burn" for dictionary level "LLT"
	When I view task "Heart Burn"

@VAL
@PBMCC177489_01
@Release2015.3.0
Scenario: Verify the Tasks Page Source Tab Help link
	When accessing "Source Terms" help information
    Then the context help header should be "Viewing Coder Transaction Details on the Tasks Page"

@VAL
@PBMCC177489_02
@Release2015.3.0
Scenario: Verify the Tasks Page Properties Tab Help link
	When accessing "Properties" help information
    Then the context help header should be "Viewing Coder Transaction Details on the Tasks Page"

@VAL
@PBMCC177489_03
@Release2015.3.0
Scenario: Verify the Tasks Page Assignments Tab Help link
	When accessing "Assignments" help information
    Then the context help header should be "Viewing Coder Transaction Details on the Tasks Page"

@VAL
@PBMCC177489_04
@Release2015.3.0
Scenario: Verify the Tasks Page Coding History Tab Help link
	When accessing "Coding History" help information
    Then the context help header should be "Viewing Coder Transaction Details on the Tasks Page"

@VAL
@PBMCC177489_05
@Release2015.3.0
Scenario: Verify the Tasks Page Query History Tab Help link
	When accessing "Query History" help information
    Then the context help header should be "Viewing Coder Transaction Details on the Tasks Page"

