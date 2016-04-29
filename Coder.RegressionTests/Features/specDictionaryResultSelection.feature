@specDictionaryResultSelection.feature
@CoderCore
Feature: This feature will validate the behavior of the coding system when a dictionary search result is selected

@VAL
@PBMCC_199894_001
@Release2015.3.1
Scenario Outline: A single dictionary search result should be associated to distinct synonym verbatims
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "<Context Dictionary>"
  And a synonym list file named "<Synonym File>" is uploaded
  And I begin a search in dictionary "<Search Dictionary>"
  And I select Synonym List "Primary List" and Template "Low to High"
  And I enter "<Code>" as a "Code" search
  And I select the following levels for the search
         | Level          |
         | <Search Level> |
  And I want only primary path results
  When I execute the above specified search
  Then the synonyms for term "<Term>" with code "<Code>" at level "<Level>" are distinct

Examples: 
| Context Dictionary      | Synonym File             | Search Dictionary           | Search Level   | Code          | Term                                         | Level |
| MedDRA ENG 15.0         | MedDRA_150_ENG_20.txt    | MedDRA 15.0 English         | Low Level Term | 10009388      | Closed dislocation, fourth cervical vertebra | LLT   |
| WHODrugDDEB2 ENG 201206 | WHODrug_201206_ENG_2.txt | WHODrugDDEB2 201206 English | Preferred Name | 075350 02 001 | DIFENOXIN HYDROCHLORIDE                      | PN    |
| JDrug ENG 2015H1        | JDrug_2015H1_ENG_2.txt   | JDrug 2015H1 English        | Drug Name      | 399100102     | CHONDRON                                     | 薬     |
| AZDD ENG 15.1           | AZDD_151_ENG_2.txt       | AZDD 15.1 English           | Preferred Name | 001670 01 001 | TYPHOID VACCINE                              | PN    |