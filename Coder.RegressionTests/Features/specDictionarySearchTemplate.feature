@specDictionarySearchTemplate.feature
@CoderCore
Feature: This feature will verify that the dictionary search functionality appropriately displays search templates

@VAL
@Release2015.3.0
@PBMCC_185577_001
Scenario: When searching for preferred names low to high the search should only display preferred names in AZDD_15.1

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "AZDD ENG 15.1"
  And I begin a search in dictionary "AZDD-15.1-English"
  And I select Synonym List "Without Synonyms" and Template "Low to High"
  And I enter "blood" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Preferred Name |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path             | Code          | Level |
        | BLOOD, WHOLE          | 003003 01 001 | PN    |
        | HUMAN RED BLOOD CELLS | 005041 01 001 | PN    |
  And I verify the search results do not contain any terms at the following levels
        | Level      |
        | Trade Name |
        | ATC        |
        | Ingredient |


@VAL
@Release2015.3.0
@PBMCC_185577_002
Scenario: When searching for preferred names high to low the search should display higher level terms in AZDD_15.1

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "AZDD ENG 15.1"
  And I begin a search in dictionary "AZDD-15.1-English"
  And I select Synonym List "Without Synonyms" and Template "High to low"
  And I enter "blood" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Preferred Name |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path                                 | Code          | Level |
        | BLOOD AND BLOOD FORMING ORGANS            | B             | ATC   |
        | BLOOD SUBSTITUTES AND PERFUSION SOLUTIONS | B05           | ATC   |
        | BLOOD AND RELATED PRODUCTS                | B05A          | ATC   |
        | Other blood products                      | B05AX         | ATC   |
        | BLOOD, WHOLE                              | 003003 01 001 | PN    |
        | HUMAN RED BLOOD CELLS                     | 005041 01 001 | PN    |
  And I verify the search results do not contain any terms at the following levels
        | Level      |
        | Trade Name |
        | Ingredient |


@VAL
@Release2015.3.0
@PBMCC_185577_003
Scenario: When searching for ingredients low to high the search should only display preferred names in AZDD_15.1

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "AZDD ENG 15.1"
  And I begin a search in dictionary "AZDD-15.1-English"
  And I select Synonym List "Without Synonyms" and Template "Low to High"
  And I enter "blood" as a "Text" search
  And I select the following levels for the search
        | Level      |
        | Ingredient |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path    | Code                     | Level |
        | BLOOD, WHOLE | 014668 01 001 0000007645 | ING   |
        | BLOOD, WHOLE | 003003 01 001 0000007645 | ING   |
  And I verify the search results do not contain any terms at the following levels
        | Level          |
        | Trade Name     |
        | ATC            |
        | Preferred Name |

@VAL
@Release2015.3.0
@PBMCC_185577_004
Scenario: When searching for ingredients high to low the search should display higher level terms in AZDD_15.1

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "AZDD ENG 15.1"
  And I begin a search in dictionary "AZDD-15.1-English"
  And I select Synonym List "Without Synonyms" and Template "High to low"
  And I enter "blood" as a "Text" search
  And I select the following levels for the search
        | Level      |
        | Ingredient |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path                                 | Code                     | Level |
        | BLOOD, WHOLE                              | 003003 01 001            | PN    |
        | BLOOD AND BLOOD FORMING ORGANS            | B                        | ATC   |
        | BLOOD SUBSTITUTES AND PERFUSION SOLUTIONS | B05                      | ATC   |
        | BLOOD AND RELATED PRODUCTS                | B05A                     | ATC   |
        | Other blood products                      | B05AX                    | ATC   |
        | BLOOD, WHOLE                              | 003003 01 001 0000007645 | ING   |


@VAL
@Release2015.3.0
@PBMCC_185577_005
Scenario: When searching for low level terms low to high the search should only display preferred names in MedDRA 15.0

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And I begin a search in dictionary "MedDRA-15.0-English"
  And I select Synonym List "Without Synonyms" and Template "Low to High"
  And I enter "burn" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Low Level Term |
  And I want only primary path results
  And I want only exact match results
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path    | Code     | Level |
        | Burn         | 10006634 | LLT   |
  And I verify the search results do not contain any terms at the following levels
        | Level |
        | SOC   |
        | HLGT  |
        | HLT   |
        | PT    |

@VAL
@Release2015.3.0
@PBMCC_185577_006
Scenario: When searching for low level terms high to low the search should only display preferred names in MedDRA 15.0

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And I begin a search in dictionary "MedDRA-15.0-English"
  And I select Synonym List "Without Synonyms" and Template "High to Low"
  And I enter "burn" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Low Level Term |
  And I want only primary path results
  And I want only exact match results
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path                                      | Code     | Level |
        | Burn                                           | 10006634 | LLT   |
        | Thermal burn                                   | 10053615 | PT    |
        | Thermal burns                                  | 10043418 | HLT   |
        | Injuries by physical agents                    | 10022119 | HLGT  |
        | Injury, poisoning and procedural complications | 10022117 | SOC   |



@VAL
@Release2015.3.0
@PBMCC_185577_007
Scenario: When searching for low level terms SOC to PT to LLT the search should only display preferred names in MedDRA 15.0

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And I begin a search in dictionary "MedDRA-15.0-English"
  And I select Synonym List "Without Synonyms" and Template "SOC-PT-LLT"
  And I enter "burn" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Low Level Term |
  And I want only primary path results
  And I want only exact match results
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path                                      | Code     | Level |
        | Injury, poisoning and procedural complications | 10022117 | SOC   |
        | Thermal burn                                   | 10053615 | PT    |
        | Burn                                           | 10006634 | LLT   |
  And I verify the search results do not contain any terms at the following levels
        | Level |
        | HLGT  |
        | HLT   |


@VAL
@Release2015.3.0
@PBMCC_185577_008
Scenario: When searching for low level terms LLT to PT to SOC the search should only display preferred names in MedDRA 15.0

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And I begin a search in dictionary "MedDRA-15.0-English"
  And I select Synonym List "Without Synonyms" and Template "LLT-PT-SOC"
  And I enter "burn" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Low Level Term |
  And I want only primary path results
  And I want only exact match results
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path                                      | Code     | Level |
        | Injury, poisoning and procedural complications | 10022117 | SOC   |
        | Thermal burn                                   | 10053615 | PT    |
        | Burn                                           | 10006634 | LLT   |
  And I verify the search results do not contain any terms at the following levels
        | Level |
        | HLGT  |
        | HLT   |