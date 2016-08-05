@specIngredientReport.feature
@CoderCore
Feature: This feature will demonstrate Coder's functionality on generating Ingredient reports, which contains task information about terms that have gone through coding for WhoDrug dictionaries.

@VAL
@PBMCC_189290_001
@Release2015.3.0
Scenario: Coder will allow a user to be able to export a Ingredient Report, which contains task coding and ingredient information.
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 201503"
    When the following externally managed verbatim requests are made
      | Verbatim Term | Dictionary Level |
      | blood         | PRODUCTSYNONYM   |
	Then the appropriate ingredient report is generated