@specImedidataIntegration.feature
@EndToEnd
Feature: The following scenarions will validate the behavior of the integration between the coding system and iMedidata

@VAL
@Release2015.3.0
@PBMCC_182173_001
Scenario: Changes to a study name in iMedidata should be reflected in existing tasks in the coding system
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
	And a new study is created in the current study group
	And coding task "Adverse Event 4" for dictionary level "LLT"
	When the study name is changed
	Then task "Adverse Event 4" should contain the following source term information
       | Source System  | Study                          | Dictionary    | Locale | Term            | Level          | Priority |
       | <SourceSystem> | <SourceSystemStudyDisplayName> | MedDRA - 15.0 | ENG    | Adverse Event 4 | Low Level Term | 1        |
