@specBrowseAndCode.feature
@CoderCore
Feature: These scenarios will validate the behavior of the coding system during a manual browse of the dictionary and coding of a task

@VAL
@Release2015.3.0
@PBMCC_185768_008
Scenario: The initial dictionary search for a browse and code should be using the synonym list of the task
	Given a "Synonyms Need Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
    When the following externally managed verbatim requests are made
      | Verbatim Term | Dictionary Level |
      | A-FIB         | LLT              |
	When a browse and code for task "A-FIB" is performed
	Then the current dictionary search criteria should be using a synonym list

@VAL
@Release2015.3.1
@PBMCC_193843_001
@IncreaseTimeout_360000
Scenario: A browse and code using JDrug should allow expansion of search result levels and coding to any selected term
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "JDrug JPN 2014H2"
    When the following externally managed verbatim requests are made
      | Verbatim Term					   | Dictionary Level |
      | アデノシン三リン酸二ナトリウム水和物 | DrugName         |
	And I want only exact match results
	When a browse and code for task "アデノシン三リン酸二ナトリウム水和物" is performed
	And the browse and code search is done for "アデノシン三リン酸二ナトリウム水和物" against "Text" at Level "Drug Name"
	And I expand the following search result terms
		| Term Path							| Code    | Level |
		| アデノシン三リン酸二ナトリウム水和物 | 3992001 | 薬     |
	Then the task should be able to be coded to the following terms
		| Term Path						    | Code    | Level |
		| アデノシン三リン酸二ナトリウム水和物 | 3992001 | 薬     |
		| アデノシン製剤                     | 3992    |    細  |

@VAL
@Release2015.3.0
@PBMCC_197227_001
@IncreaseTimeout
Scenario:  A user can continuously code to the next available task within a group until all the items of that group are coded
    Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	When the following externally managed verbatim requests are made "Tasks_6_CodeAndNext.json"
	And a browse and code for task "Burning" is performed
	When I code next available task
	| Verbatim     | SearchText                | SearchLevel    | Code     | Level | CreateSynonym |
	| Burning      | Gastroesophageal burning  | Low Level Term | 10066998 | LLT   | False         |
	| Congestion   | Congestion nasal          | Low Level Term | 10010676 | LLT   | False         |
	| Heart Burn   | Reflux gastritis          | Low Level Term | 10057969 | LLT   | False         |
	| Nasal Drip   | Postnasal drip            | Low Level Term | 10036402 | LLT   | False         |
	| Reflux       | Gastritis alkaline reflux | Low Level Term | 10017858 | LLT   | False         |
	| Stiff Joints | Stiff joint               | Low Level Term | 10042041 | LLT   | False         |
	Then The task count is "0"

@DFT
@Release2015.3.0
@PBMCC_197227_02
@IncreaseTimeout
@ignore
Scenario:  A user can code to the next available task that is waiting to be coded if though there are tasks in other states than waiting manual code
    Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	And a browse and code for task "Burning" is performed
	When I code next available task
	| Verbatim     | SearchText                | SearchLevel    | Code     | Level | CreateSynonym |
	| Burning      | Gastroesophageal burning  | Low Level Term | 10066998 | LLT   | False         |
	| Congestion   | Congestion nasal          | Low Level Term | 10010676 | LLT   | False         |
	| Heart Burn   | Reflux gastritis          | Low Level Term | 10057969 | LLT   | False         |
	| Nasal Drip   | Postnasal drip            | Low Level Term | 10036402 | LLT   | False         |
	| Reflux       | Gastritis alkaline reflux | Low Level Term | 10017858 | LLT   | False         |
	And I reclassify tasks "<Verbatim>" with Include Autocoded Items set to "True"	 
	| Verbatim     | 
	| Burning      |
	| Congestion   | 
	| Heart Burn   | 
	| Nasal Drip   | 
	| Reflux       | 
	Then The task count is "0"

@VAL
@Release2015.3.0
@PBMCC_197227_003
@IncreaseTimeout
Scenario:  A user can continuously code and create synonym for the next available task within a group until all the items of that group are coded and the empty tasks list is provided
    Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0" 
	When the following externally managed verbatim requests are made "Tasks_6_CodeAndNext.json"
	And a browse and code for task "Burning" is performed
	When I code next available task
	| Verbatim     | SearchText                | SearchLevel    | Code     | Level | CreateSynonym |
	| Burning      | Gastroesophageal burning  | Low Level Term | 10066998 | LLT   | True          |
	| Congestion   | Congestion nasal          | Low Level Term | 10010676 | LLT   | True          |
	| Heart Burn   | Reflux gastritis          | Low Level Term | 10057969 | LLT   | True          |
	| Nasal Drip   | Postnasal drip            | Low Level Term | 10036402 | LLT   | True          |
	| Reflux       | Gastritis alkaline reflux | Low Level Term | 10017858 | LLT   | True          |
	| Stiff Joints | Stiff joint               | Low Level Term | 10042041 | LLT   | True          |
	Then The task count is "0"


@VAL
@Release2015.3.2
@PBMCC_204358_003
@IncreaseTimeout_360000
Scenario: Terms on all pages of browse and code dictionary search results should be able to be coded to a task
	Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
    When the following externally managed verbatim requests are made
      | Verbatim Term | Dictionary Level |
      | A-FIB         | LLT              |
	When a browse and code for task "A-FIB" is performed
	And the browse and code search is done for "atrial fibrillation" against "Text" at Level "Low Level Term"
	Then the task should be able to be coded to the following terms
		| Term Path                                 | Code     | Level |
		| Atrial fibrillation                       | 10003658 | LLT   |
		| Paroxysmal atrial flutter                 | 10050376 | LLT   |
		| Ostium secundum type atrial septal defect | 10031303 | LLT   |

@Rerun
@PBMCC_204440_002
@Release2015.3.2
Scenario: MedDRA Browse and Code Search Results should contain only terms for current paths
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA JPN 18.0"
    When the following externally managed verbatim requests are made
      | Verbatim Term    | Dictionary Level |
      | Adverse Event 17 | LLT              |
	And I want only exact match results
	And I want only primary path results
	When a browse and code for task "Adverse Event 17" is performed
	And the browse and code search is done for "高脂血症" against "Text" at Level "Low Level Term"
	Then the dictionary search results should contain only the following terms
	     | Term Path | Code     | Level |
	     | 高脂血症   | 10062060 | LLT   |

@VAL
@Release2015.3.3
@PBMCC_202079_001
@IncreaseTimeout_360000
Scenario Outline: Cross level browse and code is performed on MedDRA, JDrug, WhoDrugDDEB2 and AZDD
  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "<Context Dictionary>"
  When the following externally managed verbatim requests are made
      | Verbatim Term | Dictionary Level   |
      | <Task>        | <Dictionary Level> |
  When a browse and code for task "<Task>" is performed
  And I want only exact match results
  And the browse and code search is done for "<Term>" against "Text" at Level "<Search Level>"
  And the task is coded to term "<Term>" at level "<Code Level>" with code "<Code>" and a synonym is created
  And I view task "<Task>"
  Then I verify the following Coding history selected term path information is displayed in row "1"
		| Level        | Term Path   | Code   |
		| <Code Level> | <Term Path> | <Code> |

Examples:
| Search Dictionary   | Dictionary Level | Search Level              | Code Level | Context Dictionary      | Task               | Term                                 | Code          | Term Path                                  |
| MedDRA-18.0-English | LLT              | Preferred Term            | PT         | MedDRA ENG 18.0         | ADVERSE EVENT 1    | Musculoskeletal discomfort           | 10053156      | Musculoskeletal discomfort: 10053156       |
| MedDRA-18.0-English | LLT              | Low Level Term            | LLT        | MedDRA ENG 18.0         | ADVERSE EVENT 2    | Cardiac index                        | 10007575      | Cardiac index: 10007575                    |
| JDrug               | DrugName         | High Level Classification | 大          | JDrug JPN 2014H2        | アデノシン三リン酸二ナトリウム水和物 | 代謝性医薬品                               | 3             | 代謝性医薬品: 3                                  |
| JDrug               | DrugName         | Mid Level Classification  | 中          | JDrug JPN 2014H2        | アデノシン三リン酸二ナトリウム水和物 | 体外診断用医薬品                             | 74            | 体外診断用医薬品: 74                               |
| JDrug               | DrugName         | Low Level Classification  | 小          | JDrug JPN 2014H2        | アデノシン三リン酸二ナトリウム水和物 | 総合代謝性製剤                              | 397           | 総合代謝性製剤: 397                               |
| JDrug               | DrugName         | Detailed Classification   | 細          | JDrug ENG 2014H2        | ADVERSE EVENT 3    | SYNTHETIC VITAMIN A AND PREPARATIONS | 3111          | SYNTHETIC VITAMIN A AND PREPARATIONS: 3111 |
| WhoDrugDDEB2        | PRODUCT          | Preferred Name            | PN         | WhoDrugDDEB2 ENG 201212 | ADVERSE EVENT 4    | CARBOPHAGIX                          | 076577 01 001 | CARBOPHAGIX: 076577 01 001                 |
| WhoDrugDDEB2        | PRODUCT          | Trade Name                | TN         | WhoDrugDDEB2 ENG 201212 | ADVERSE EVENT 5    | AZTOR ASP                            | 031934 01 002 | AZTOR ASP: 031934 01 002                   |
| AZDD                | PRODUCT          | Preferred Name            | PN         | AZDD ENG 15.1           | ADVERSE EVENT 6    | OTHER NERVOUS SYSTEM DRUGS           | 900592 01 001 | OTHER NERVOUS SYSTEM DRUGS: 900592 01 001  |
| AZDD                | PRODUCT          | Trade Name                | TN         | AZDD ENG 15.1           | ADVERSE EVENT 7    | JALEA REAL                           | 007887 01 002 | JALEA REAL: 007887 01 002                  |
