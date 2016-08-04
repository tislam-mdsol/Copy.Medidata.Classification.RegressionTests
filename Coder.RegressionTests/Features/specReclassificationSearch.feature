@specReclassificationSearch.feature
@CoderCore
Feature: Verify the reclassification search section display and functionality   


@VAL
@PBMCC166003_01
@Release2015.3.0
Scenario Outline: A Coder User is able to search via the following criteria: Subject, Verbatim Term, Term, Code

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
    When the following externally managed verbatim requests are made
      | Verbatim Term | Dictionary Level |
      | HEADACHE      | LLT              |
	When setting reclassification search value "<Value>" for "<Field>"
	And setting reclassification search value "True" for "IncludeAutocodedItems"
	And performing reclassification search
	Then the reclassification search should contain
	   | Study       | Subject   | Verbatim | Term     | Code     | Priority | Form   |
	   | <StudyName> | Subject 1 | HEADACHE | Headache | 10019211 | 1        | Form 1 |
    Examples:
        | Field    | Value     |
        | Verbatim | HEADACHE  |
        | Term     | Headache  |
        | Code     | 10019211  |
        | Subject  | Subject 1 |


@VAL
@PBMCC166003_02
@Release2015.3.0
Scenario Outline: A user can review a coding decision's EDC Form. Enables an easy way to differentiate Adverse Event vs Medical History related terms by their form names.

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	When the following externally managed verbatim requests are made
		| Verbatim Term | Dictionary Level | Form        |
		| Headache      | LLT              | <FormValue> |
	And setting reclassification search value "<Value>" for "<Field>"
	And setting reclassification search value "True" for "IncludeAutocodedItems"
	And performing reclassification search
	Then the reclassification search should contain
	   | Study       | Subject   | Verbatim | Term     | Code     | Priority | Form        |
	   | <StudyName> | Subject 1 | HEADACHE | Headache | 10019211 | 1        | <FormValue> |
    Examples:
        | Field    | Value    | FormValue       |
        | Verbatim | Headache | Adverse Event   |
        | Verbatim | Headache | Medical History |


@VAL
@PBMCC166003_03
@Release2015.3.0
Scenario Outline: A Coder User is able to do a partial term search using the following criteria: Verbatim, Subject

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
    When the following externally managed verbatim requests are made
      | Verbatim Term | Dictionary Level |
      | HEADACHE      | LLT              |
	When setting reclassification search value "<Value>" for "<Field>"
	And setting reclassification search value "True" for "IncludeAutocodedItems"
	And performing reclassification search
	Then the reclassification search should contain
	   | Study       | Subject   | Verbatim | Term     | Code     | Priority | Form   |
	   | <StudyName> | Subject 1 | HEADACHE | Headache | 10019211 | 1        | Form 1 |
    Examples:
        | Field    | Value   |
        | Verbatim | Head    |
        | Subject  | Subject |


@VAL
@PBMCC166003_04
@Release2015.3.0
Scenario Outline: A Coder User is able to conduct a search using the following Prior Action: Browse And Code, Approve

	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
    When the following externally managed verbatim requests are made
      | Verbatim Term | Dictionary Level |
      | Heart Burn    | LLT              |
	When task "Heart Burn" is coded to term "Reflux gastritis" at search level "Low Level Term" with code "10057969" at level "LLT" and a synonym is created
	And approving task "HEART BURN"
	And setting reclassification search value "<Value>" for "<Field>"
	And performing reclassification search
	Then the reclassification search should contain
	    | Study       | Subject   | Verbatim   | Term             | Code     | Priority | Form   |
	    | <StudyName> | Subject 1 | HEART BURN | Reflux gastritis | 10057969 | 1        | Form 1 |
	Examples:
        | Field        | Value           |
        | PriorActions | Browse And Code |
        | PriorActions | Approve         |
		

@VAL
@PBMCC166003_05
@Release2015.3.0
Scenario Outline: A Coder User is able to conduct a search using the following Prior Action: Complete Without Transmission, Auto Approve Internal

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
    When the following externally managed verbatim requests are made
      | Verbatim Term | Dictionary Level |
      | HEADACHE      | LLT              |
	When setting reclassification search value "<Value>" for "<Field>"
	And setting reclassification search value "True" for "IncludeAutocodedItems"
	And performing reclassification search
	Then the reclassification search should contain
	    | Study       | Subject   | Verbatim | Term     | Code     | Priority | Form   |
	    | <StudyName> | Subject 1 | HEADACHE | Headache | 10019211 | 1        | Form 1 |
	Examples:
        | Field        | Value                         |
        | PriorActions | Complete Without Transmission |
        | PriorActions | Auto Approve Internal         |


@VAL
@PBMCC166003_06
@Release2015.3.0
Scenario Outline: A Coder User is able to conduct a search using the following Prior Status: Completed, Start

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
    When the following externally managed verbatim requests are made
      | Verbatim Term | Dictionary Level |
      | HEADACHE      | LLT              |
	When setting reclassification search value "<Value>" for "<Field>"
	And setting reclassification search value "True" for "IncludeAutocodedItems"
	And performing reclassification search
	Then the reclassification search should contain
	    | Study       | Subject   | Verbatim | Term     | Code     | Priority | Form   |
	    | <StudyName> | Subject 1 | HEADACHE | Headache | 10019211 | 1        | Form 1 |
	Examples:
        | Field       | Value     |
        | PriorStatus | Completed |
        | PriorStatus | Start     |


@VAL
@PBMCC166003_07
@Release2015.3.0
Scenario Outline: A Coder User is able to conduct a search using the following Prior Status: Waiting Approval, Waiting Manual Code

	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
    When the following externally managed verbatim requests are made
      | Verbatim Term | Dictionary Level |
      | Heart Burn    | LLT              |
	When task "Heart Burn" is coded to term "Reflux gastritis" at search level "Low Level Term" with code "10057969" at level "LLT" and a synonym is created
	And approving task "HEART BURN"
	And setting reclassification search value "<Value>" for "<Field>"
	And performing reclassification search
	Then the reclassification search should contain
	    | Study       | Subject   | Verbatim   | Term             | Code     | Priority | Form   |
	    | <StudyName> | Subject 1 | HEART BURN | Reflux gastritis | 10057969 | 1        | Form 1 |
	Examples:
        | Field       | Value               |
        | PriorStatus | Waiting Approval    |
        | PriorStatus | Waiting Manual Code |

