@specUMCSearchCases.feature
@CoderCore
Feature: This feature file will verify the dictionary search behavior for WHODrugDDEB2 and WHODrug_DDE_C dictionaries

@VAL
@Release2015.3.0
@PBMCC_177597_001
Scenario Outline: When searching the dictionary with no results returned a message will display explaining no results have been found

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "<Context Dictionary>"
  And I begin a search in dictionary "<Search Dictionary>"
  And I enter "Xyxy" as a "Text" search
  And I select the following levels for the search
        | Level   |
        | <Level> |
  When I execute the above specified search
  Then I verify the results count message indicates "0" results

Examples:
| Search Dictionary             | Level             | Context Dictionary      |
| WHODrug-DDE-B2-201003-English | Trade Name        | WHODrugDDEB2 ENG 201003 |
| WHODrug-DDE-C-201003-English  | Medicinal Product | WHODrug_DDE_C ENG 201003  |


@VAL
@Release2015.3.0
@PBMCC_177597_002
Scenario Outline: When searching the dictionary for a trade name that is not preferred or generic, Coder displays a single match for WHODrugDDEB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "<Search Term>" as a "Text" search
  And I select the following levels for the search
        | Level      |
        | Trade Name |
  When I execute the above specified search
  Then I verify the results count message indicates "1" results
  And I verify the following information is contained in the browser search results
        | Term Path | Code          | Level |
        | AXAL      | 005952 01 291 | TN    |
  And I verify the following Selected Search Result Properties are displayed for term "AXAL" with code "005952 01 291" at level "TN"
        | Property          | Value         |
        | Code              | 005952 01 291 |
        | DESIGNATION       | T             |
        | INGREDIENTS       | Alprazolam    |
        | SEQUENCENUMBER1   | 01            |
        | SEQUENCENUMBER2   | 291           |

Examples:
| Search Term |
| Axal        |
| AXAL        |
| axal        |
| axaL        |


@VAL
@Release2015.3.0
@PBMCC_177597_002b
Scenario Outline: When searching the dictionary for a trade name that is not preferred or generic, Coder displays multiple matches for WHODrug_DDE_C

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "<Search Term>" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
          | Term Path | Code    | Level |
          | AXAL      | 1435993 | MP    |
          | AXAL      | 791822  | MP    |
          | AXAL      | 791821  | MP    |
          | AXAL      | 791823  | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "AXAL" with code "1435993" at level "MP"
        | Property                            | Value                   |
        | Code                                | 1435993                 |
        | Level                               | Medicinal Product       |
        | COUNTRY                             | PAK, Pakistan           |
        | DRUGRECORDNUMBER                    | 005952                  |
        | GENERIC                             | False                   |
        | MARKETINGAUTHORIZATIONHOLDER        | 7157                    |
        | MARKETINGAUTHORIZATIONHOLDERCOUNTRY | UNS, Unspecified        |
        | NUMBEROFINGREDIENTS                 | 1                       |
        | INGREDIENTS                         | Alprazolam              |
        | PRODUCTTYPE                         | 001, Medicinal product  |
        | SEQUENCENUMBER1                     | 01                      |
        | SEQUENCENUMBER2                     | 291                     |
        | SEQUENCENUMBER3                     | 0000000001, Unspecified |
        | SEQUENCENUMBER4                     | 0000000001, Unspecified |
        | SOURCE                              | 237, IMS Health         |
        | SOURCECOUNTRY                       | N/A, Not Applicable     |
        | SOURCEYEAR                          | 05                      |
  And I verify the following Selected Search Result Properties are displayed for term "AXAL" with code "791822" at level "MP"
        | Property                            | Value                   | 
        | Code                                | 791822                  |
        | Level                               | Medicinal Product       |
        | COUNTRY                             | PAK, Pakistan           |
        | DRUGRECORDNUMBER                    | 005952                  |
        | GENERIC                             | False                   |
        | MARKETINGAUTHORIZATIONHOLDER        | 13141                   |
        | MARKETINGAUTHORIZATIONHOLDERCOUNTRY | PAK, Pakistan           |
        | NUMBEROFINGREDIENTS                 | 1                       |
        | INGREDIENTS                         | Alprazolam              |
        | PRODUCTTYPE                         | 001, Medicinal product  |
        | SEQUENCENUMBER1                     | 01                      |
        | SEQUENCENUMBER2                     | 291                     |
        | SEQUENCENUMBER3                     | 0000000001, Unspecified |
        | SEQUENCENUMBER4                     | 0000000001, Unspecified |
        | SOURCE                              | 237, IMS Health         |
        | SOURCECOUNTRY                       | N/A, Not Applicable     |
        | SOURCEYEAR                          | 05                      |
  And I verify the following Selected Search Result Properties are displayed for term "AXAL" with code "791821" at level "MP"
        | Property                            | Value                   |
        | Code                                | 791821                  |
        | Level                               | Medicinal Product       |
        | COUNTRY                             | PAK, Pakistan           |
        | DRUGRECORDNUMBER                    | 005952                  |
        | GENERIC                             | False                   |
        | MARKETINGAUTHORIZATIONHOLDER        | 13141                   |
        | MARKETINGAUTHORIZATIONHOLDERCOUNTRY | PAK, Pakistan           |
        | NUMBEROFINGREDIENTS                 | 1                       |
        | INGREDIENTS                         | Alprazolam              |
        | PRODUCTTYPE                         | 001, Medicinal product  |
        | SEQUENCENUMBER1                     | 01                      |
        | SEQUENCENUMBER2                     | 291                     |
        | SEQUENCENUMBER3                     | 0000000100, TABLETS     |
        | SEQUENCENUMBER4                     | 0000000001, Unspecified |
        | SOURCE                              | 237, IMS Health         |
        | SOURCECOUNTRY                       | N/A, Not Applicable     |
        | SOURCEYEAR                          | 05                      |
  And I verify the following Selected Search Result Properties are displayed for term "AXAL" with code "791823" at level "MP"
        | Property                            | Value                   |
        | Code                                | 791823                  |
        | Level                               | Medicinal Product       |
        | COUNTRY                             | UNS, Unspecified        |
        | DRUGRECORDNUMBER                    | 005952                  |
        | GENERIC                             | False                   |
        | MARKETINGAUTHORIZATIONHOLDER        | 7157                    |
        | MARKETINGAUTHORIZATIONHOLDERCOUNTRY | UNS, Unspecified        |
        | NUMBEROFINGREDIENTS                 | 1                       |
        | INGREDIENTS                         | Alprazolam              |
        | PRODUCTTYPE                         | 001, Medicinal product  |
        | SEQUENCENUMBER1                     | 01                      |
        | SEQUENCENUMBER2                     | 291                     |
        | SEQUENCENUMBER3                     | 0000000001, Unspecified |
        | SEQUENCENUMBER4                     | 0000000001, Unspecified |
        | SOURCE                              | 237, IMS Health         |
        | SOURCECOUNTRY                       | N/A, Not Applicable     |
        | SOURCEYEAR                          | 05                      |

Examples:
| Search Term |
| Axal        |
| AXAL        |
| axal        |
| axaL        |

@VAL
@Release2015.3.0
@PBMCC_177597_003
Scenario: The browser page search results will allow you to view an entry that is preferred but not generic

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "Euphyllin*" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Preferred Name |
        | Trade Name     |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
          | Term Path            | Code          | Level |
          | Euphyllin /06430301/ | 064303 01 001 | PN    |
          | Euphyllin-calcium    | 003647 01 001 | PN    |
          | Euphyllinum          | 000037 01 050 | TN    |
  And I verify the following Selected Search Result Properties are displayed for term "Euphyllin /06430301/" with code "064303 01 001" at level "PN"
        | Property        | Value                                     |
        | Code            | 064303 01 001                             |
        | Level           | Preferred Name                            |
        | DESIGNATION     | M                                         |
        | INGREDIENTS     | ETHYLENEDIAMINE, THEOPHYLLINE MONOHYDRATE |
        | SEQUENCENUMBER1 | 01                                        |
        | SEQUENCENUMBER2 | 001                                       |


@VAL
@Release2015.3.0
@PBMCC_177597_003b
Scenario: The browser page search results will allow you to view firstly exact matches followed then by partial code and partial wild card code searching

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "Euphyllin" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  And I select the following attributes for the search
        | Operator | Attribute   | Text                                      |
        | Has      | INGREDIENTS | Ethylenediamine, Theophylline monohydrate |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code    | Level |
        | Euphyllin | 1706014 | MP    |
        | Euphyllin | 1706015 | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Euphyllin" with code "1706014" at level "MP"
        | Property        | Value                                     |
        | Code            | 1706014                                   |
        | Level           | Medicinal Product                         |
        | INGREDIENTS     | Ethylenediamine, Theophylline monohydrate |
        | PRODUCTTYPE     | 001, Medicinal product                    |
        | SEQUENCENUMBER2 | 001                                       |
    And I verify the following Selected Search Result Properties are displayed for term "Euphyllin" with code "1706015" at level "MP"
        | Property      | Value                                     |
        | Code          | 1706015                                   |
        | Level         | Medicinal Product                         |
        | COUNTRY       | DEU, Germany                              |
        | NAMESPECIFIER | /old form/                                |
        | INGREDIENTS   | Ethylenediamine, Theophylline monohydrate |
    And I verify the following Selected Search Result Properties are displayed for term "Euphyllin" with code "1706013" at level "MP"
        | Property                     | Value                                     |
        | Code                         | 1706013                                   |
        | Level                        | Medicinal Product                         |
        | COUNTRY                      | DEU, Germany                              |
        | NAMESPECIFIER                | For injection /old form/                  |
        | INGREDIENTS                  | Ethylenediamine, Theophylline monohydrate |
        | MARKETINGAUTHORIZATIONHOLDER | 1614                                      |

@VAL
@Release2015.3.0
@PBMCC_177597_004
Scenario: The browser page search results will allow you to view Search for a term that is preferred and generic (single ingredient) for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "Aldes*" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Preferred Name |
  And I select the following attributes for the search
        | Operator | Attribute       | Text |
        | Has      | SEQUENCENUMBER2 | 001  |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path          | Code          | Level |
        | Aldesleukin        | 012246 01 001 | PN    |
        | Aldesulfone        | 002199 01 001 | PN    |
        | Aldesulfone sodium | 002199 02 001 | PN    |
  And I verify the following Selected Search Result Properties are displayed for term "Aldesleukin" with code "012246 01 001" at level "PN"
        | Property        | Value          |
        | Code            | 012246 01 001  |
        | Level           | Preferred Name |
        | DESIGNATION     | N              |
        | INGREDIENTS     | ALDESLEUKIN    |
        | SEQUENCENUMBER1 | 01             |
        | SEQUENCENUMBER2 | 001            |
  And I verify the following Selected Search Result Properties are displayed for term "Aldesulfone" with code "002199 01 001" at level "PN"
        | Property        | Value          |
        | Code            | 002199 01 001  |
        | Level           | Preferred Name |
        | DESIGNATION     | N              |
        | INGREDIENTS     | Aldesulfone    |
        | SEQUENCENUMBER1 | 01             |
        | SEQUENCENUMBER2 | 001            |
  And I verify the following Selected Search Result Properties are displayed for term "Aldesulfone sodium" with code "002199 02 001" at level "PN"
        | Property        | Value              |
        | Code            | 002199 02 001      |
        | Level           | Preferred Name     |
        | DESIGNATION     | N                  |
        | INGREDIENTS     | Aldesulfone sodium |
        | SEQUENCENUMBER1 | 02                 |
        | SEQUENCENUMBER2 | 001                |


@VAL
@Release2015.3.0
@PBMCC_177597_004b
Scenario: The browser page search results will allow you to view Search for a term that is preferred and generic (single ingredient) for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrugDDEC201003English"
  And I enter "Aldes*" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  And I select the following attributes for the search
        | Operator | Attribute       | Text |
        | Has      | SEQUENCENUMBER2 | 001  |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path   | Code    | Level |
        | Aldesleukin | 1492912 | MP    |
        | Aldesleukin | 1046915 | MP    |
        | Aldesleukin | 45423   | MP    |
        | Aldesleukin | 1046914 | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Aldesleukin" with code "1492912" at level "MP"
        | Property                     | Value                                |
        | Code                         | 1492912                              |
        | COUNTRY                      | AUS, Australia                       |
        | DRUGRECORDNUMBER             | 012246                               |
        | GENERIC                      | False                                |
        | MARKETINGAUTHORIZATIONHOLDER | 7157                                 |
        | INGREDIENTS                  | Aldesleukin                          |
        | SEQUENCENUMBER1              | 01                                   |
        | SEQUENCENUMBER2              | 001                                  |
        | SEQUENCENUMBER3              | 0000000001, Unspecified              |
    And I verify the following Selected Search Result Properties are displayed for term "Aldesleukin" with code "1046915" at level "MP"
        | Property                     | Value                                |
        | Code                         | 1046915                              |
        | COUNTRY                      | AUS, Australia                       |
        | DRUGRECORDNUMBER             | 012246                               |
        | GENERIC                      | False                                |
        | MARKETINGAUTHORIZATIONHOLDER | 18243                                |
        | INGREDIENTS                  | Aldesleukin                          |
        | SEQUENCENUMBER1              | 01                                   |
        | SEQUENCENUMBER2              | 001                                  |
        | SEQUENCENUMBER3              | 0000000001, Unspecified              |
    And I verify the following Selected Search Result Properties are displayed for term "Aldesleukin" with code "45423" at level "MP"
        | Property                     | Value                                |
        | Code                         | 45423                                |
        | COUNTRY                      | N/A, Not Applicable                  |
        | DRUGRECORDNUMBER             | 012246                               |
        | GENERIC                      | True                                 |
        | MARKETINGAUTHORIZATIONHOLDER | 0                                    |
        | INGREDIENTS                  | Aldesleukin                          |
        | SEQUENCENUMBER1              | 01                                   |
        | SEQUENCENUMBER2              | 001                                  |
        | SEQUENCENUMBER3              | 0000000001, Unspecified              |
    And I verify the following Selected Search Result Properties are displayed for term "Aldesleukin" with code "1046914" at level "MP"
        | Property                     | Value                                |
        | Code                         | 1046914                              |
        | COUNTRY                      | AUS, Australia                       |
        | DRUGRECORDNUMBER             | 012246                               |
        | GENERIC                      | False                                |
        | MARKETINGAUTHORIZATIONHOLDER | 18243                                |
        | INGREDIENTS                  | Aldesleukin                          |
        | SEQUENCENUMBER1              | 01                                   |
        | SEQUENCENUMBER2              | 001                                  |
        | SEQUENCENUMBER3              | 0000000457, INFUSION AMPOULES, OTHER |


@VAL
@Release2015.3.0
@PBMCC_177597_005
@MCC_187225
Scenario: The browser page search results will allow you to identify that the matching term is a preferred name for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "Dothiepin" as a "Text" search
  And I select the following levels for the search
        | Level         |
        | Trade Name    |
        | Preferred Name |
  When I execute the above specified search
  And I expand the search result for term "DOTHIEPIN /00160401/" with code "001604 01 003" at level "TN"
  Then I verify the following information is contained in the browser search results
        | Term Path | Code          | Level |
        | Dosulepin | 001604 01 001 | PN    |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin /00160401/" with code "001604 01 003" at level "TN"
        | Property    | Value         |
        | Code        | 001604 01 003 |
        | Level       | Trade Name    |
        | INGREDIENTS | Dosulepin     |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin /00160402/" with code "001604 02 007" at level "TN"
        | Property    | Value                   |
        | Code        | 001604 02 007           |
        | Level       | Trade Name              |
        | INGREDIENTS | Dosulepin hydrochloride |


@VAL
@Release2015.3.0
@PBMCC_177597_005b
@IncreaseTimeout_900000
Scenario: The browser page search results will allow you to identify that the matching term is a preferred name for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "Dothiepin" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code    | Level |
        | Dothiepin | 17499   | MP    |
        | Dothiepin | 97401   | MP    |
        | Dothiepin | 1419728 | MP    |
        | Dothiepin | 735833  | MP    |
        | Dothiepin | 736709  | MP    |
        | Dothiepin | 735832  | MP    |
        | Dothiepin | 1258771 | MP    |
        | Dothiepin | 188290  | MP    |
        | Dothiepin | 188538  | MP    |
        | Dothiepin | 188566  | MP    |
        | Dothiepin | 188662  | MP    |
        | Dothiepin | 189056  | MP    |
        | Dothiepin | 189844  | MP    |
        | Dothiepin | 191466  | MP    |
        | Dothiepin | 193712  | MP    |
        | Dothiepin | 50905   | MP    |
        | Dothiepin | 193767  | MP    |
        | Dothiepin | 188537  | MP    |
        | Dothiepin | 188663  | MP    |
        | Dothiepin | 189946  | MP    |
        | Dothiepin | 191465  | MP    |
        | Dothiepin | 188291  | MP    |
        | Dothiepin | 188567  | MP    |
        | Dothiepin | 188289  | MP    |
        | Dothiepin | 188565  | MP    |
        | Dothiepin | 188661  | MP    |
        | Dothiepin | 188969  | MP    |
        | Dothiepin | 189055  | MP    |
        | Dothiepin | 189843  | MP    |
        | Dothiepin | 193711  | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "17499" at level "MP"
        | Property    | Value     |
        | Code        | 17499     |
        | Term        | Dothiepin |
        | INGREDIENTS | Dosulepin |
        | GENERIC     | True      |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "97401" at level "MP"
        | Property    | Value                   |
        | Code        | 97401                   |
        | Term        | Dothiepin               |
        | INGREDIENTS | Dosulepin hydrochloride |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "1419728" at level "MP"
        | Property    | Value                   |
        | Code        | 1419728                 |
        | Term        | Dothiepin               |
        | INGREDIENTS | Dosulepin hydrochloride |
        | COUNTRY     | HKG, Hong Kong          |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "735833" at level "MP"
        | Property                     | Value                   |
        | Code                         | 735833                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | HKG, Hong Kong          |
        | MARKETINGAUTHORIZATIONHOLDER | 64653                   |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "736709" at level "MP"
        | Property                     | Value                   |
        | Code                         | 736709                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | HKG, Hong Kong          |
        | MARKETINGAUTHORIZATIONHOLDER | 64653                   |
        | SEQUENCENUMBER3              | 0000000100, TABLETS     |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "735832" at level "MP"
        | Property                     | Value                   |
        | Code                         | 735832                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | HKG, Hong Kong          |
        | MARKETINGAUTHORIZATIONHOLDER | 64653                   |
        | SEQUENCENUMBER3              | 0000000150, CAPSULES    |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "1258771" at level "MP"
        | Property                     | Value                   |
        | Code                         | 1258771                 |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "188290" at level "MP"
        | Property                     | Value                   |
        | Code                         | 188290                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 12261                   |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "188538" at level "MP"
        | Property                     | Value                   |
        | Code                         | 188538                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 16445                   |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "188566" at level "MP"
        | Property                     | Value                   |
        | Code                         | 188566                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 3849                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "188662" at level "MP"
        | Property                     | Value                   |
        | Code                         | 188662                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 16063                   |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "189056" at level "MP"
        | Property                     | Value                   |
        | Code                         | 189056                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 15757                   |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "189844" at level "MP"
        | Property                     | Value                   |
        | Code                         | 189844                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 16415                   |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "191466" at level "MP"
        | Property                     | Value                   |
        | Code                         | 191466                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 4391                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "193712" at level "MP"
        | Property                     | Value                   |
        | Code                         | 193712                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 16399                   |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "50905" at level "MP"
        | Property                     | Value                   |
        | Code                         | 50905                   |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 2295                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "193767" at level "MP"
        | Property                     | Value                   |
        | Code                         | 193767                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 16399                   |
        | SEQUENCENUMBER3              | 0000000100, TABLETS     |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "188537" at level "MP"
        | Property                     | Value                      |
        | Code                         | 188537                     |
        | Term                         | Dothiepin                  |
        | INGREDIENTS                  | Dosulepin hydrochloride    |
        | COUNTRY                      | GBR, United Kingdom        |
        | MARKETINGAUTHORIZATIONHOLDER | 16445                      |
        | SEQUENCENUMBER3              | 0000000125, COATED TABLETS |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "188663" at level "MP"
        | Property                     | Value                      |
        | Code                         | 188663                     |
        | Term                         | Dothiepin                  |
        | INGREDIENTS                  | Dosulepin hydrochloride    |
        | COUNTRY                      | GBR, United Kingdom        |
        | MARKETINGAUTHORIZATIONHOLDER | 16063                      |
        | SEQUENCENUMBER3              | 0000000125, COATED TABLETS |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "189946" at level "MP"
        | Property                     | Value                      |
        | Code                         | 189946                     |
        | Term                         | Dothiepin                  |
        | INGREDIENTS                  | Dosulepin hydrochloride    |
        | COUNTRY                      | GBR, United Kingdom        |
        | MARKETINGAUTHORIZATIONHOLDER | 16415                      |
        | SEQUENCENUMBER3              | 0000000125, COATED TABLETS |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "191465" at level "MP"
        | Property                     | Value                      |
        | Code                         | 191465                     |
        | Term                         | Dothiepin                  |
        | INGREDIENTS                  | Dosulepin hydrochloride    |
        | COUNTRY                      | GBR, United Kingdom        |
        | MARKETINGAUTHORIZATIONHOLDER | 4391                       |
        | SEQUENCENUMBER3              | 0000000125, COATED TABLETS |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "188291" at level "MP"
        | Property                     | Value                            |
        | Code                         | 188291                           |
        | Term                         | Dothiepin                        |
        | INGREDIENTS                  | Dosulepin hydrochloride          |
        | COUNTRY                      | GBR, United Kingdom              |
        | MARKETINGAUTHORIZATIONHOLDER | 12261                            |
        | SEQUENCENUMBER3              | 0000000127, COATED TABLETS, FILM |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "188567" at level "MP"
        | Property                     | Value                            |
        | Code                         | 188567                           |
        | Term                         | Dothiepin                        |
        | INGREDIENTS                  | Dosulepin hydrochloride          |
        | COUNTRY                      | GBR, United Kingdom              |
        | MARKETINGAUTHORIZATIONHOLDER | 3849                             |
        | SEQUENCENUMBER3              | 0000000127, COATED TABLETS, FILM |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "188289" at level "MP"
        | Property                     | Value                   |
        | Code                         | 188289                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 12261                   |
        | SEQUENCENUMBER3              | 0000000150, CAPSULES    |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "188565" at level "MP"
        | Property                     | Value                   |
        | Code                         | 188565                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 3849                    |
        | SEQUENCENUMBER3              | 0000000150, CAPSULES    |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "188661" at level "MP"
        | Property                     | Value                   |
        | Code                         | 188661                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 16063                   |
        | SEQUENCENUMBER3              | 0000000150, CAPSULES    |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "188969" at level "MP"
        | Property                     | Value                   |
        | Code                         | 188969                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 16445                   |
        | SEQUENCENUMBER3              | 0000000150, CAPSULES    |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "189055" at level "MP"
        | Property                     | Value                   |
        | Code                         | 189055                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 15757                   |
        | SEQUENCENUMBER3              | 0000000150, CAPSULES    |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "189843" at level "MP"
        | Property                     | Value                   |
        | Code                         | 189843                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 16415                   |
        | SEQUENCENUMBER3              | 0000000150, CAPSULES    |
  And I verify the following Selected Search Result Properties are displayed for term "Dothiepin" with code "193711" at level "MP"
        | Property                     | Value                   |
        | Code                         | 193711                  |
        | Term                         | Dothiepin               |
        | INGREDIENTS                  | Dosulepin hydrochloride |
        | COUNTRY                      | GBR, United Kingdom     |
        | MARKETINGAUTHORIZATIONHOLDER | 16399                   |
        | SEQUENCENUMBER3              | 0000000150, CAPSULES    |

@VAL
@Release2015.3.0
@PBMCC_177597_006

Scenario: The browser page search results will allow you to view Search for a preferred name of a synonym substance for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "Dothiepin" as a "Text" search
  And I select the following levels for the search
        | Level      |
        | Trade Name |
  When I execute the above specified search
  And I expand the search result for term "DOTHIEPIN /00160401/" with code "001604 01 003" at level "TN"
  Then I verify the following information is contained in the browser search results
        | Term Path | Code          | Level |
        | Dosulepin | 001604 01 001 | PN    |
  And I verify the following Selected Search Result Properties are displayed for term "Dosulepin" with code "001604 01 001" at level "PN"
        | Property | Value          |
        | Code     | 001604 01 001  |
        | Term     | DOSULEPIN      |
        | Level    | Preferred Name |

@VAL
@Release2015.3.0
@PBMCC_177597_006b
@MCC_187225
Scenario: The browser page search results will allow you to view Search for a preferred name of a synonym substance for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I select Synonym List "Without Synonyms" and Template "High to Low"
  And I enter "Dothiepin" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  And I want only exact match results
  When I execute the above specified search
  And I expand the search result for term "Dothiepin" with code "17499" at level "MP"
  Then I verify the following information is contained in the browser search results
        | Term Path | Code  | Level |
        | Dosulepin | 21806 | ING   |
  And I verify the following Selected Search Result Properties are displayed for term "Dosulepin" with code "21806" at level "ING"
        | Property | Value      |
        | Code     | 21806      |
        | Term     | Dosulepin  |
        | Level    | Ingredient |


@VAL
@Release2015.3.0
@PBMCC_177597_007
Scenario: The browser page search results will allow you to view results for a term without the name specifier for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "Ziga*" as a "Text" search
  And I select the following levels for the search
        | Level      |
        | Trade Name |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code          | Level |
        | Ziga      | 004165 01 273 | TN    |
        | Zigat     | 014661 01 042 | TN    |
  And I verify the following Selected Search Result Properties are displayed for term "Ziga" with code "004165 01 273" at level "TN"
        | Property    | Value                                                |
        | Code        | 004165 01 273                                        |
        | Term        | Ziga                                                 |
        | Ingredients | MAGNESIUM HYDROXIDE, SIMETICONE, ALUMINIUM HYDROXIDE |
  And I verify the following Selected Search Result Properties are displayed for term "Zigat" with code "014661 01 042" at level "TN"
        | Property    | Value         |
        | Code        | 014661 01 042 |
        | Term        | Zigat         |
        | Ingredients | Gatifloxacin  |


@VAL
@Release2015.3.0
@PBMCC_177597_007b
Scenario: The browser page search results will allow you to view results for a term without the name specifier for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "Ziga*" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code    | Level |
        | Ziga      | 1008843 | MP    |
        | Ziga      | 1482611 | MP    |
        | Ziga      | 1008842 | MP    |
        | Ziga      | 1010532 | MP    |
        | Ziga      | 1008841 | MP    |
        | Ziga      | 1010531 | MP    |
        | Zigat     | 635131  | MP    |
        | Zigat     | 1394978 | MP    |
        | Zigat     | 635130  | MP    |
        | Zigat     | 635129  | MP    |
        | Zigat     | 646792  | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Ziga" with code "1008843" at level "MP"
        | Property    | Value                                                |
        | Code        | 1008843                                              |
        | Term        | Ziga                                                 |
        | Ingredients | Aluminium hydroxide, Magnesium hydroxide, Simeticone |
  And I verify the following Selected Search Result Properties are displayed for term "Ziga" with code "1482611" at level "MP"
        | Property    | Value                                                |
        | Code        | 1482611                                              |
        | Term        | Ziga                                                 |
        | Ingredients | Aluminium hydroxide, Magnesium hydroxide, Simeticone |
        | Country     | THA, Thailand                                        |
  And I verify the following Selected Search Result Properties are displayed for term "Ziga" with code "1008842" at level "MP"
        | Property                     | Value                                                |
        | Code                         | 1008842                                              |
        | Term                         | Ziga                                                 |
        | Ingredients                  | Aluminium hydroxide, Magnesium hydroxide, Simeticone |
        | NAMESPECIFIER                | Gel                                                  |
        | Country                      | THA, Thailand                                        |
        | MARKETINGAUTHORIZATIONHOLDER | 57285                                                |
  And I verify the following Selected Search Result Properties are displayed for term "Ziga" with code "1010532" at level "MP"
        | Property                     | Value                                                |
        | Code                         | 1010532                                              |
        | Term                         | Ziga                                                 |
        | Ingredients                  | Aluminium hydroxide, Magnesium hydroxide, Simeticone |
        | NAMESPECIFIER                | Tab                                                  |
        | Country                      | THA, Thailand                                        |
        | MARKETINGAUTHORIZATIONHOLDER | 57285                                                |
  And I verify the following Selected Search Result Properties are displayed for term "Ziga" with code "1008841" at level "MP"
        | Property                     | Value                                                |
        | Code                         | 1008841                                              |
        | Term                         | Ziga                                                 |
        | Ingredients                  | Aluminium hydroxide, Magnesium hydroxide, Simeticone |
        | NAMESPECIFIER                | Gel                                                  |
        | Country                      | THA, Thailand                                        |
        | MARKETINGAUTHORIZATIONHOLDER | 57285                                                |
        | SEQUENCENUMBER3              | 0000000258, LIQUIDS, SUSPENSIONS                     |
  And I verify the following Selected Search Result Properties are displayed for term "Ziga" with code "1010531" at level "MP"
        | Property                     | Value                                                |
        | Code                         | 1010531                                              |
        | Term                         | Ziga                                                 |
        | Ingredients                  | Aluminium hydroxide, Magnesium hydroxide, Simeticone |
        | NAMESPECIFIER                | Tab                                                  |
        | Country                      | THA, Thailand                                        |
        | MARKETINGAUTHORIZATIONHOLDER | 57285                                                |
        | SEQUENCENUMBER3              | 0000000100, TABLETS                                  |
  And I verify the following Selected Search Result Properties are displayed for term "Zigat" with code "635131" at level "MP"
        | Property    | Value        |
        | Code        | 635131       |
        | Term        | Zigat        |
        | Ingredients | Gatifloxacin |
  And I verify the following Selected Search Result Properties are displayed for term "Zigat" with code "1394978" at level "MP"
        | Property    | Value        |
        | Code        | 1394978      |
        | Term        | Zigat        |
        | Ingredients | Gatifloxacin |
        | Country     | IND, India   |
  And I verify the following Selected Search Result Properties are displayed for term "Zigat" with code "635130" at level "MP"
        | Property                     | Value        |
        | Code                         | 635130       |
        | Term                         | Zigat        |
        | Ingredients                  | Gatifloxacin |
        | Country                      | IND, India   |
        | MARKETINGAUTHORIZATIONHOLDER | 13408        |
  And I verify the following Selected Search Result Properties are displayed for term "Zigat" with code "635129" at level "MP"
        | Property                     | Value                            |
        | Code                         | 635129                           |
        | Term                         | Zigat                            |
        | Ingredients                  | Gatifloxacin                     |
        | Country                      | IND, India                       |
        | MARKETINGAUTHORIZATIONHOLDER | 13408                            |
        | SEQUENCENUMBER3              | 0000000127, COATED TABLETS, FILM |
  And I verify the following Selected Search Result Properties are displayed for term "Zigat" with code "646792" at level "MP"
        | Property                     | Value                      |
        | Code                         | 646792                     |
        | Term                         | Zigat                      |
        | Ingredients                  | Gatifloxacin               |
        | Country                      | IND, India                 |
        | MARKETINGAUTHORIZATIONHOLDER | 13408                      |
        | SEQUENCENUMBER3              | 0000000251, LIQUIDS, DROPS |


@VAL
@Release2015.3.0
@PBMCC_177597_007c
@MCC_187601
Scenario: The browser page search results will allow you to view results for a term with the name specifier Gel for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "Ziga*" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  And I select the following attributes for the search
        | Operator | Attribute       | Text |
        | Has      | NAMESPECIFIER     | Gel  |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code    | Level |
        | Ziga      | 1008841 | MP    |
        | Ziga      | 1008842 | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Ziga" with code "1008842" at level "MP"
        | Property                     | Value                                                |
        | Code                         | 1008842                                              |
        | Term                         | Ziga                                                 |
        | Ingredients                  | Aluminium hydroxide, Magnesium hydroxide, Simeticone |
        | NAMESPECIFIER                | Gel                                                  |
        | Country                      | THA, Thailand                                        |
        | MARKETINGAUTHORIZATIONHOLDER | 57285                                                |
  And I verify the following Selected Search Result Properties are displayed for term "Ziga" with code "1008841" at level "MP"
        | Property                     | Value                                                |
        | Code                         | 1008841                                              |
        | Term                         | Ziga                                                 |
        | Ingredients                  | Aluminium hydroxide, Magnesium hydroxide, Simeticone |
        | NAMESPECIFIER                | Gel                                                  |
        | Country                      | THA, Thailand                                        |
        | MARKETINGAUTHORIZATIONHOLDER | 57285                                                |
        | SEQUENCENUMBER3              | 0000000258, LIQUIDS, SUSPENSIONS                     |

@VAL
@Release2015.3.0
@PBMCC_177597_007d
@MCC_187601
Scenario: The browser page search results will allow you to view results for a term with the name specifier Tab for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "Ziga*" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  And I select the following attributes for the search
        | Operator | Attribute         | Text |
        | Has      | NAMESPECIFIER     | Tab  |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code    | Level |
        | Ziga      | 1010532 | MP    |
        | Ziga      | 1010531 | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Ziga" with code "1010532" at level "MP"
        | Property                     | Value                                                |
        | Code                         | 1010532                                              |
        | Term                         | Ziga                                                 |
        | Ingredients                  | Aluminium hydroxide, Magnesium hydroxide, Simeticone |
        | NAMESPECIFIER                | Tab                                                  |
        | Country                      | THA, Thailand                                        |
        | MARKETINGAUTHORIZATIONHOLDER | 57285                                                |
  And I verify the following Selected Search Result Properties are displayed for term "Ziga" with code "1010531" at level "MP"
        | Property                     | Value                                                |
        | Code                         | 1010531                                              |
        | Term                         | Ziga                                                 |
        | Ingredients                  | Aluminium hydroxide, Magnesium hydroxide, Simeticone |
        | NAMESPECIFIER                | Tab                                                  |
        | Country                      | THA, Thailand                                        |
        | MARKETINGAUTHORIZATIONHOLDER | 57285                                                |
        | SEQUENCENUMBER3              | 0000000100, TABLETS                                  |

@VAL
@Release2015.3.0
@PBMCC_177597_008
Scenario: The browser page search results will allow you to view results for a search at both trade name and umbrella for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "Vitamins" as a "Text" search
  And I select the following levels for the search
        | Level      |
        | Trade Name |
        | ATC        |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path           | Code          | Level |
        | Vitamins /00067501/ | 000675 01 017 | TN    |
  And I verify the following Selected Search Result Properties are displayed for term "Vitamins /00067501/" with code "000675 01 017" at level "TN"
        | Property    | Value                                                                                    |
        | Code        | 000675 01 017                                                                            |
        | Term        | Vitamins /00067501/                                                                      |
        | Ingredients | ERGOCALCIFEROL, ASCORBIC ACID, THIAMINE HYDROCHLORIDE, RETINOL, RIBOFLAVIN, NICOTINAMIDE |


@VAL
@Release2015.3.0
@PBMCC_177597_008b
Scenario: The browser page search results will allow you to view results for a search at both trade name and umbrella for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "Vitamins" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
        | ATC               |
  And I want only exact match results
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code    | Level |
        | Vitamins  | 1164550 | MP    |
        | Vitamins  | 1519818 | MP    |
        | Vitamins  | 1164549 | MP    |
        | Vitamins  | 1164548 | MP    |
        | Vitamins  | 49763   | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Vitamins" with code "1164550" at level "MP"
        | Property    | Value                                                                                    |
        | Code        | 1164550                                                                                  |
        | Term        | Vitamins                                                                                 |
        | Ingredients | Ascorbic acid, Ergocalciferol, Nicotinamide, Retinol, Riboflavin, Thiamine hydrochloride |
  And I verify the following Selected Search Result Properties are displayed for term "Vitamins" with code "1519818" at level "MP"
        | Property    | Value                                                                                    |
        | Code        | 1519818                                                                                  |
        | Term        | Vitamins                                                                                 |
        | Country     | THA, Thailand                                                                            |
        | Ingredients | Ascorbic acid, Ergocalciferol, Nicotinamide, Retinol, Riboflavin, Thiamine hydrochloride |
  And I verify the following Selected Search Result Properties are displayed for term "Vitamins" with code "1164549" at level "MP"
        | Property                     | Value                                                                                    |
        | Code                         | 1164549                                                                                  |
        | Term                         | Vitamins                                                                                 |
        | Country                      | THA, Thailand                                                                            |
        | Ingredients                  | Ascorbic acid, Ergocalciferol, Nicotinamide, Retinol, Riboflavin, Thiamine hydrochloride |
        | MARKETINGAUTHORIZATIONHOLDER | 57421                                                                                    |
  And I verify the following Selected Search Result Properties are displayed for term "Vitamins" with code "1164548" at level "MP"
        | Property                     | Value                                                                                    |
        | Code                         | 1164548                                                                                  |
        | Term                         | Vitamins                                                                                 |
        | Country                      | THA, Thailand                                                                            |
        | Ingredients                  | Ascorbic acid, Ergocalciferol, Nicotinamide, Retinol, Riboflavin, Thiamine hydrochloride |
        | MARKETINGAUTHORIZATIONHOLDER | 57421                                                                                    |
        | NameSpecifier                | Capsule                                                                                  |
        | SEQUENCENUMBER3              | 0000000150, CAPSULES                                                                     |
  And I verify the following Selected Search Result Properties are displayed for term "Vitamins" with code "49763" at level "MP"
        | Property        | Value    |
        | Code            | 49763    |
        | Term            | Vitamins |
        | SEQUENCENUMBER2 | 001      |


@VAL
@Release2015.3.0
@PBMCC_177597_009
Scenario: The browser page search results will allow you to view preferred results for a search on multiple ingredients for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "*" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Preferred Name |
        | Trade Name     |
  And I select the following attributes for the search
         | Operator | Attribute   | Text                     |
         | Has      | Ingredients | Ampicillin AND Sulbactam |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path              | Code          | Level |
        | Ampicillin w/sulbactam | 008926 01 007 | TN    |
        | Duocid /00892601/      | 008926 01 001 | PN    |
  And I verify the following Selected Search Result Properties are displayed for term "Ampicillin w/sulbactam" with code "008926 01 007" at level "TN"
        | Property    | Value                  |
        | Code        | 008926 01 007          |
        | Term        | Ampicillin w/sulbactam |
        | Ingredients | AMPICILLIN, SULBACTAM  |
  And I verify the following Selected Search Result Properties are displayed for term "Duocid /00892601/" with code "008926 01 001" at level "PN"
        | Property        | Value                 |
        | Code            | 008926 01 001         |
        | Term            | Duocid /00892601/     |
        | Ingredients     | AMPICILLIN, SULBACTAM |
        | SEQUENCENUMBER2 | 001                   |


@VAL
@Release2015.3.0
@PBMCC_177597_009b
Scenario: The browser page search results will allow you to view generic preferred results for a search on multiple ingredients for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "*" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
 And I select the following attributes for the search
        | Operator | Attribute   | Text                     |
        | Has      | Ingredients | Ampicillin AND Sulbactam |
        | Has      | Generic     | True                     |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path              | Code  | Level |
        | Ampicillin w/sulbactam | 61547 | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Ampicillin w/sulbactam" with code "61547" at level "MP"
        | Property    | Value                  |
        | Code        | 61547                  |
        | Term        | Ampicillin w/sulbactam |
        | Ingredients | AMPICILLIN, SULBACTAM  |
        | Generic     | True                   |

@DFT
@Release2015.3.0
@PBMCC_177597_009c
@MCC_188078
@ignore
Scenario: The browser page search results will allow you to view non generic preferred results for a search on multiple ingredients for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "*" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
 And I select the following attributes for the search
        | Operator | Attribute       | Text                     |
        | Has      | Ingredients     | Ampicillin AND Sulbactam |
        | Has      | SEQUENCENUMBER2 | 001                      |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code   | Level |
        | Duocid    | 114698 | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Duocid" with code "114698" at level "MP"
        | Property        | Value                 |
        | Code            | 114698                |
        | Term            | Duocid                |
        | Ingredients     | AMPICILLIN, SULBACTAM |
        | SEQUENCENUMBER2 | 001                   |


@VAL
@Release2015.3.0
@PBMCC_177597_010
Scenario: The browser page search results will allow you to view preferred names for a search on trade names for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I select Synonym List "Without Synonyms" and Template "High To Low"
  And I enter "Crystepin" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Trade Name     |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path            | Code          | Level |
        | Crystepin /01077501/ | 010775 01 004 | TN    |
        | BRISERIN             | 010775 01 001 | PN    |


@VAL
@Release2015.3.0
@PBMCC_177597_010b
Scenario: The browser page search results will allow you to view preferred names for a search on trade names for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "Crystepin" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code    | Level |
        | Crystepin | 117515  | MP    |
        | Crystepin | 43171   | MP    |
        | Crystepin | 1253888 | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Crystepin" with code "117515" at level "MP"
        | Property    | Value                                              |
        | Code        | 117515                                             |
        | Term        | Crystepin                                          |
        | Ingredients | Clopamide, Dihydroergocristine mesilate, Reserpine |
  And I verify the following Selected Search Result Properties are displayed for term "Crystepin" with code "43171" at level "MP"
        | Property                     | Value                                              |
        | Code                         | 43171                                              |
        | Term                         | Crystepin                                          |
        | Ingredients                  | Clopamide, Dihydroergocristine mesilate, Reserpine |
        | Country                      | CZE, Czech Republic                                |
        | MARKETINGAUTHORIZATIONHOLDER | 5737                                               |
  And I verify the following Selected Search Result Properties are displayed for term "Crystepin" with code "1253888" at level "MP"
        | Property    | Value                                              |
        | Code        | 1253888                                            |
        | Term        | Crystepin                                          |
        | Ingredients | Clopamide, Dihydroergocristine mesilate, Reserpine |
        | Country     | CZE, Czech Republic                                |


@VAL
@Release2015.3.0
@PBMCC_177597_011
Scenario: The browser page search results will allow you to distinguish between entries with the same name by country and ingredients for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "Skelan" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Trade Name     |
        | Preferred Name |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path         | Code          | Level |
        | Skelan /00109201/ | 001092 01 804 | TN    |
        | Skelan /00384801/ | 003848 01 001 | PN    |
        | Skelan /01234301/ | 012343 01 188 | TN    |
        | Skelan /03447801/ | 034478 01 001 | PN    |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan /00109201/" with code "001092 01 804" at level "TN"
       | Property    | Value             |
       | Code        | 001092 01 804     |
       | Term        | Skelan /00109201/ |
       | Ingredients | IBUPROFEN         |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan /00384801/" with code "003848 01 001" at level "PN"
       | Property        | Value                                                                  |
       | Code            | 003848 01 001                                                          |
       | Term            | Skelan /00384801/                                                      |
       | Ingredients     | CARISOPRODOL, DEXTROPROPOXYPHENE HYDROCHLORIDE, PHENYLBUTAZONE CALCIUM |
       | SEQUENCENUMBER2 | 001                                                                    |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan /01234301/" with code "012343 01 188" at level "TN"
       | Property    | Value                  |
       | Code        | 012343 01 188          |
       | Term        | Skelan /01234301/      |
       | Ingredients | PARACETAMOL, IBUPROFEN |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan /03447801/" with code "034478 01 001" at level "PN"
       | Property        | Value                                           |
       | Code            | 034478 01 001                                   |
       | Term            | Skelan /03447801/                               |
       | Ingredients     | CARISOPRODOL, GLAFENINE, PHENYLBUTAZONE CALCIUM |
       | SEQUENCENUMBER2 | 001                                             |



@VAL
@Release2015.3.0
@PBMCC_177597_011b
@IncreaseTimeout_900000
Scenario: The browser page search results will allow you to distinguish between entries with the same name by country and ingredients for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "Skelan" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code    | Level |
        | Skelan    | 808544  | MP    |
        | Skelan    | 1441092 | MP    |
        | Skelan    | 808543  | MP    |
        | Skelan    | 808542  | MP    |
        | Skelan    | 806788  | MP    |
        | Skelan    | 1440559 | MP    |
        | Skelan    | 806787  | MP    |
        | Skelan    | 806786  | MP    |
        | Skelan    | 103694  | MP    |
        | Skelan    | 1240976 | MP    |
        | Skelan    | 25678   | MP    |
        | Skelan    | 1000058 | MP    |
        | Skelan    | 1480279 | MP    |
        | Skelan    | 1000057 | MP    |
        | Skelan    | 1000056 | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "808544" at level "MP"
       | Property    | Value     |
       | Code        | 808544    |
       | Term        | Skelan    |
       | Ingredients | Ibuprofen |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "1441092" at level "MP"
       | Property    | Value            |
       | Code        | 1441092          |
       | Term        | Skelan           |
       | Ingredients | Ibuprofen        |
       | Country     | PHL, Philippines |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "808543" at level "MP"
       | Property    | Value            |
       | Code        | 808543          |
       | Term        | Skelan           |
       | Ingredients | Ibuprofen        |
       | Country     | PHL, Philippines |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "808542" at level "MP"
       | Property    | Value            |
       | Code        | 808542           |
       | Term        | Skelan           |
       | Ingredients | Ibuprofen        |
       | Country     | PHL, Philippines |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "806788" at level "MP"
       | Property    | Value                                           |
       | Code        | 806788                                          |
       | Term        | Skelan                                          |
       | Ingredients | Carisoprodol, Glafenine, Phenylbutazone calcium |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "1440559" at level "MP"
       | Property    | Value                                           |
       | Code        | 1440559                                         |
       | Term        | Skelan                                          |
       | Ingredients | Carisoprodol, Glafenine, Phenylbutazone calcium |
       | Country     | PHL, Philippines                                |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "806787" at level "MP"
       | Property    | Value                                           |
       | Code        | 806787                                          |
       | Term        | Skelan                                          |
       | Ingredients | Carisoprodol, Glafenine, Phenylbutazone calcium |
       | Country     | PHL, Philippines                                |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "806786" at level "MP"
       | Property    | Value                                           |
       | Code        | 806786                                          |
       | Term        | Skelan                                          |
       | Ingredients | Carisoprodol, Glafenine, Phenylbutazone calcium |
       | Country     | PHL, Philippines                                |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "103694" at level "MP"
       | Property    | Value                                                                  |
       | Code        | 103694                                                                 |
       | Term        | Skelan                                                                 |
       | Ingredients | Carisoprodol, Dextropropoxyphene hydrochloride, Phenylbutazone calcium |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "1240976" at level "MP"
       | Property    | Value                                                                  |
       | Code        | 1240976                                                                |
       | Term        | Skelan                                                                 |
       | Ingredients | Carisoprodol, Dextropropoxyphene hydrochloride, Phenylbutazone calcium |
       | Country     | IDN, Indonesia                                                         |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "25678" at level "MP"
       | Property    | Value                                                                  |
       | Code        | 25678                                                                  |
       | Term        | Skelan                                                                 |
       | Ingredients | Carisoprodol, Dextropropoxyphene hydrochloride, Phenylbutazone calcium |
       | Country     | IDN, Indonesia                                                         |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "1000058" at level "MP"
       | Property    | Value                  |
       | Code        | 1000058                |
       | Term        | Skelan                 |
       | Ingredients | Ibuprofen, Paracetamol |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "1480279" at level "MP"
       | Property    | Value                  |
       | Code        | 1480279                |
       | Term        | Skelan                 |
       | Ingredients | Ibuprofen, Paracetamol |
       | Country     | THA, Thailand          |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "1000057" at level "MP"
       | Property    | Value                  |
       | Code        | 1000057                |
       | Term        | Skelan                 |
       | Ingredients | Ibuprofen, Paracetamol |
       | Country     | THA, Thailand          |
  And I verify the following Selected Search Result Properties are displayed for term "Skelan" with code "1000056" at level "MP"
       | Property    | Value                  |
       | Code        | 1000056                |
       | Term        | Skelan                 |
       | Ingredients | Ibuprofen, Paracetamol |
       | Country     | THA, Thailand          |


@VAL
@Release2015.3.0
@PBMCC_177597_012
Scenario: The browser page search results will allow you to distinguish between entries with the same name by dosage and ingredients for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "Dexano" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Trade Name     |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path         | Code          | Level |
        | Dexano /00016001/ | 000160 01 325 | TN    |
        | Dexano /00016002/ | 000160 02 153 | TN    |
  And I verify the following Selected Search Result Properties are displayed for term "Dexano /00016001/" with code "000160 01 325" at level "TN"
       | Property    | Value             |
       | Code        | 000160 01 325     |
       | Term        | Dexano /00016001/ |
       | Ingredients | DEXAMETHASONE     |
  And I verify the following Selected Search Result Properties are displayed for term "Dexano /00016002/" with code "000160 02 153" at level "TN"
       | Property    | Value                          |
       | Code        | 000160 02 153                  |
       | Term        | Dexano /00016002/              |
       | Ingredients | DEXAMETHASONE SODIUM PHOSPHATE |



@VAL
@Release2015.3.0
@PBMCC_177597_012b
Scenario: The browser page search results will allow you to distinguish between entries with the same name by dosage and ingredients for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "Dexano" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code    | Level |
        | Dexano    | 1001938 | MP    |
        | Dexano    | 1480632 | MP    |
        | Dexano    | 1001937 | MP    |
        | Dexano    | 1001936 | MP    |
        | Dexano    | 997932  | MP    |
        | Dexano    | 1479892 | MP    |
        | Dexano    | 997931  | MP    |
        | Dexano    | 997930  | MP    |
        | Dexano    | 1000342 | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Dexano" with code "1001938" at level "MP"
       | Property    | Value         |
       | Code        | 1001938       |
       | Term        | Dexano        |
       | Ingredients | Dexamethasone |
  And I verify the following Selected Search Result Properties are displayed for term "Dexano" with code "1480632" at level "MP"
       | Property    | Value         |
       | Code        | 1480632       |
       | Term        | Dexano        |
       | Ingredients | Dexamethasone |
       | Country     | THA, Thailand |
  And I verify the following Selected Search Result Properties are displayed for term "Dexano" with code "1001937" at level "MP"
       | Property                     | Value         |
       | Code                         | 1001937       |
       | Term                         | Dexano        |
       | Ingredients                  | Dexamethasone |
       | Country                      | THA, Thailand |
       | MARKETINGAUTHORIZATIONHOLDER | 6645          |
  And I verify the following Selected Search Result Properties are displayed for term "Dexano" with code "1001936" at level "MP"
       | Property                     | Value               |
       | Code                         | 1001936             |
       | Term                         | Dexano              |
       | Ingredients                  | Dexamethasone       |
       | Country                      | THA, Thailand       |
       | MARKETINGAUTHORIZATIONHOLDER | 6645                |
       | SEQUENCENUMBER3              | 0000000100, TABLETS |
  And I verify the following Selected Search Result Properties are displayed for term "Dexano" with code "997932" at level "MP"
       | Property    | Value                          |
       | Code        | 997932                         |
       | Term        | Dexano                         |
       | Ingredients | Dexamethasone sodium phosphate |
  And I verify the following Selected Search Result Properties are displayed for term "Dexano" with code "1479892" at level "MP"
       | Property    | Value                          |
       | Code        | 1479892                        |
       | Term        | Dexano                         |
       | Ingredients | Dexamethasone sodium phosphate |
       | Country     | THA, Thailand                  |
  And I verify the following Selected Search Result Properties are displayed for term "Dexano" with code "997931" at level "MP"
       | Property                     | Value                          |
       | Code                         | 997931                         |
       | Term                         | Dexano                         |
       | Ingredients                  | Dexamethasone sodium phosphate |
       | Country                      | THA, Thailand                  |
       | MARKETINGAUTHORIZATIONHOLDER | 6645                           |
  And I verify the following Selected Search Result Properties are displayed for term "Dexano" with code "997930" at level "MP"
       | Property                     | Value                          |
       | Code                         | 997930                         |
       | Term                         | Dexano                         |
       | Ingredients                  | Dexamethasone sodium phosphate |
       | Country                      | THA, Thailand                  |
       | MARKETINGAUTHORIZATIONHOLDER | 6645                           |
       | SEQUENCENUMBER3              | 0000000375, AMPOULES           |
  And I verify the following Selected Search Result Properties are displayed for term "Dexano" with code "1000342" at level "MP"
       | Property                     | Value                          |
       | Code                         | 1000342                        |
       | Term                         | Dexano                         |
       | Ingredients                  | Dexamethasone sodium phosphate |
       | Country                      | THA, Thailand                  |
       | MARKETINGAUTHORIZATIONHOLDER | 6645                           |
       | SEQUENCENUMBER3              | 0000000425, VIALS              |


@VAL
@Release2015.3.0
@PBMCC_177597_013
Scenario: The browser page search results will allow you to distinguish entries as an old form for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "Bradosol" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Trade Name     |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path           | Code          | Level |
        | Bradosol /00088302/ | 000883 02 055 | TN    |
        | Bradosol /00093302/ | 000933 02 002 | TN    |
        | Bradosol /00581401/ | 005814 01 007 | TN    |
  And I verify the following Selected Search Result Properties are displayed for term "Bradosol /00093302/" with code "000933 02 002" at level "TN"
       | Property | Value               |
       | Code     | 000933 02 002       |
       | Term     | Bradosol /00093302/ |



@VAL
@Release2015.3.0
@PBMCC_177597_013b
Scenario: The browser page search results will allow you to distinguish entries as an old form for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "Bradosol" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code    | Level |
        | Bradosol  | 177425  | MP    |
        | Bradosol  | 1283932 | MP    |
        | Bradosol  | 177424  | MP    |
        | Bradosol  | 177423  | MP    |
        | Bradosol  | 94486   | MP    |
        | Bradosol  | 1317621 | MP    |
        | Bradosol  | 292986  | MP    |
        | Bradosol  | 292985  | MP    |
        | Bradosol  | 1231836 | MP    |
        | Bradosol  | 13718   | MP    |
        | Bradosol  | 300448  | MP    |
        | Bradosol  | 1319752 | MP    |
        | Bradosol  | 300447  | MP    |
        | Bradosol  | 300446  | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Bradosol" with code "1231836" at level "MP"
       | Property      | Value      |
       | Code          | 1231836    |
       | Term          | Bradosol   |
       | NAMESPECIFIER | /old form/ |
  And I verify the following Selected Search Result Properties are displayed for term "Bradosol" with code "13718" at level "MP"
       | Property      | Value      |
       | Code          | 13718      |
       | Term          | Bradosol   |
       | NAMESPECIFIER | /old form/ |


@VAL
@Release2015.3.0
@PBMCC_177597_014
Scenario: The browser page search results will allow you to distinguish between entries with multiple countries for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "Dolmen" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Trade Name     |
        | Preferred Name |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path         | Code          | Level |
        | Dolmen /00649901/ | 006499 01 001 | PN    |
        | Dolmen /00685301/ | 006853 01 016 | TN    |
        | Dolmen /01363802/ | 013638 02 008 | TN    |
  And I verify the following Selected Search Result Properties are displayed for term "DOLMEN /00649901/" with code "006499 01 001" at level "PN"
       | Property        | Value                                                  |
       | Code            | 006499 01 001                                          |
       | Term            | Dolmen /00649901/                                      |
       | Ingredients     | ACETYLSALICYLIC ACID, ASCORBIC ACID, CODEINE PHOSPHATE |
       | SEQUENCENUMBER2 | 001                                                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen /00685301/" with code "006853 01 016" at level "TN"
       | Property    | Value             |
       | Code        | 006853 01 016     |
       | Term        | Dolmen /00685301/ |
       | Ingredients | TENOXICAM         |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen /01363802/" with code "013638 02 008" at level "TN"
       | Property    | Value                    |
       | Code        | 013638 02 008            |
       | Term        | Dolmen /01363802/        |
       | Ingredients | DEXKETOPROFEN TROMETAMOL |


@VAL
@Release2015.3.0
@PBMCC_177597_014b
@IncreaseTimeout_900000
Scenario: The browser page search results will allow you to distinguish between entries with multiple countries for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "Dolmen" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  And I want only exact match results
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code    | Level |
        | Dolmen    | 110511  | MP    |
        | Dolmen    | 1247359 | MP    |
        | Dolmen    | 34329   | MP    |
        | Dolmen    | 1170239 | MP    |
        | Dolmen    | 1170241 | MP    |
        | Dolmen    | 1170240 | MP    |
        | Dolmen    | 111194  | MP    |
        | Dolmen    | 1294761 | MP    |
        | Dolmen    | 220460  | MP    |
        | Dolmen    | 220459  | MP    |
        | Dolmen    | 1248026 | MP    |
        | Dolmen    | 35199   | MP    |
        | Dolmen    | 422701  | MP    |
        | Dolmen    | 422700  | MP    |
        | Dolmen    | 422840  | MP    |
        | Dolmen    | 422703  | MP    |
        | Dolmen    | 422702  | MP    |
        | Dolmen    | 216534  | MP    |
        | Dolmen    | 1293469 | MP    |
        | Dolmen    | 216533  | MP    |
        | Dolmen    | 216532  | MP    |
        | Dolmen    | 1303560 | MP    |
        | Dolmen    | 247047  | MP    |
        | Dolmen    | 247046  | MP    |
        | Dolmen    | 1146436 | MP    |
        | Dolmen    | 1515174 | MP    |
        | Dolmen    | 1146435 | MP    |
        | Dolmen    | 1146434 | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "110511" at level "MP"
       | Property        | Value                                                  |
       | Code            | 110511                                                 |
       | Term            | Dolmen                                                 |
       | INGREDIENTS     | Acetylsalicylic acid, Ascorbic acid, Codeine phosphate |
       | SEQUENCENUMBER2 | 001                                                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "1247359" at level "MP"
       | Property        | Value                                                  |
       | Code            | 1247359                                                |
       | Term            | Dolmen                                                 |
       | INGREDIENTS     | Acetylsalicylic acid, Ascorbic acid, Codeine phosphate |
       | Country         | ESP, Spain                                             |
       | SEQUENCENUMBER2 | 001                                                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "34329" at level "MP"
       | Property                     | Value                                                  |
       | Code                         | 34329                                                  |
       | Term                         | Dolmen                                                 |
       | INGREDIENTS                  | Acetylsalicylic acid, Ascorbic acid, Codeine phosphate |
       | Country                      | ESP, Spain                                             |
       | MARKETINGAUTHORIZATIONHOLDER | 10581                                                  |
       | SEQUENCENUMBER2              | 001                                                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "1170239" at level "MP"
       | Property                     | Value                                                  |
       | Code                         | 1170239                                                |
       | Term                         | Dolmen                                                 |
       | INGREDIENTS                  | Acetylsalicylic acid, Ascorbic acid, Codeine phosphate |
       | Country                      | ESP, Spain                                             |
       | MARKETINGAUTHORIZATIONHOLDER | 10581                                                  |
       | SEQUENCENUMBER3              | 0000000105, TABLETS, EFFERVESCENT                      |
       | SEQUENCENUMBER2              | 001                                                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "1170241" at level "MP"
       | Property                     | Value                                                  |
       | Code                         | 1170241                                                |
       | Term                         | Dolmen                                                 |
       | INGREDIENTS                  | Acetylsalicylic acid, Ascorbic acid, Codeine phosphate |
       | Country                      | ESP, Spain                                             |
       | MARKETINGAUTHORIZATIONHOLDER | 10581                                                  |
       | SEQUENCENUMBER3              | 0000000351, SUPPOSITORIES, ADULT                       |
       | SEQUENCENUMBER2              | 001                                                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "1170240" at level "MP"
       | Property                     | Value                                                  |
       | Code                         | 1170240                                                |
       | Term                         | Dolmen                                                 |
       | INGREDIENTS                  | Acetylsalicylic acid, Ascorbic acid, Codeine phosphate |
       | Country                      | ESP, Spain                                             |
       | MARKETINGAUTHORIZATIONHOLDER | 10581                                                  |
       | SEQUENCENUMBER3              | 0000000352, SUPPOSITORIES, PAEDIATRIC                  |
       | SEQUENCENUMBER2              | 001                                                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "111194" at level "MP"
       | Property    | Value     |
       | Code        | 111194    |
       | Term        | Dolmen    |
       | INGREDIENTS | Tenoxicam |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "1294761" at level "MP"
       | Property    | Value               |
       | Code        | 1294761             |
       | Term        | Dolmen              |
       | INGREDIENTS | Tenoxicam           |
       | Country     | CZE, Czech Republic |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "220460" at level "MP"
       | Property                     | Value               |
       | Code                         | 220460              |
       | Term                         | Dolmen              |
       | INGREDIENTS                  | Tenoxicam           |
       | Country                      | CZE, Czech Republic |
       | MARKETINGAUTHORIZATIONHOLDER | 19722               |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "220459" at level "MP"
       | Property                     | Value               |
       | Code                         | 220459              |
       | Term                         | Dolmen              |
       | INGREDIENTS                  | Tenoxicam           |
       | Country                      | CZE, Czech Republic |
       | MARKETINGAUTHORIZATIONHOLDER | 19722               |
       | SEQUENCENUMBER3              | 0000000100, TABLETS |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "1248026" at level "MP"
       | Property    | Value      |
       | Code        | 1248026    |
       | Term        | Dolmen     |
       | INGREDIENTS | Tenoxicam  |
       | Country     | ITA, Italy |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "35199" at level "MP"
       | Property                     | Value      |
       | Code                         | 35199      |
       | Term                         | Dolmen     |
       | INGREDIENTS                  | Tenoxicam  |
       | Country                      | ITA, Italy |
       | MARKETINGAUTHORIZATIONHOLDER | 9501       |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "422701" at level "MP"
       | Property                     | Value      |
       | Code                         | 422701     |
       | Term                         | Dolmen     |
       | INGREDIENTS                  | Tenoxicam  |
       | Country                      | ITA, Italy |
       | MARKETINGAUTHORIZATIONHOLDER | 9505       |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "422700" at level "MP"
       | Property                     | Value                            |
       | Code                         | 422700                           |
       | Term                         | Dolmen                           |
       | INGREDIENTS                  | Tenoxicam                        |
       | Country                      | ITA, Italy                       |
       | MARKETINGAUTHORIZATIONHOLDER | 9505                             |
       | SEQUENCENUMBER3              | 0000000127, COATED TABLETS, FILM |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "422840" at level "MP"
       | Property                     | Value                          |
       | Code                         | 422840                         |
       | Term                         | Dolmen                         |
       | INGREDIENTS                  | Tenoxicam                      |
       | Country                      | ITA, Italy                     |
       | MARKETINGAUTHORIZATIONHOLDER | 9505                           |
       | SEQUENCENUMBER3              | 0000000209, POWDERS, UNIT DOSE |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "422703" at level "MP"
       | Property                     | Value                            |
       | Code                         | 422703                           |
       | Term                         | Dolmen                           |
       | INGREDIENTS                  | Tenoxicam                        |
       | Country                      | ITA, Italy                       |
       | MARKETINGAUTHORIZATIONHOLDER | 9505                             |
       | SEQUENCENUMBER3              | 0000000351, SUPPOSITORIES, ADULT |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "422702" at level "MP"
       | Property                     | Value                               |
       | Code                         | 422702                              |
       | Term                         | Dolmen                              |
       | INGREDIENTS                  | Tenoxicam                           |
       | Country                      | ITA, Italy                          |
       | MARKETINGAUTHORIZATIONHOLDER | 9505                                |
       | SEQUENCENUMBER3              | 0000000378, AMPOULES, INTRAMUSCULAR |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "216534" at level "MP"
       | Property    | Value                    |
       | Code        | 216534                   |
       | Term        | Dolmen                   |
       | INGREDIENTS | Dexketoprofen trometamol |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "1293469" at level "MP"
       | Property    | Value                    |
       | Code        | 1293469                  |
       | Term        | Dolmen                   |
       | INGREDIENTS | Dexketoprofen trometamol |
       | Country     | EST, Estonia             |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "216533" at level "MP"
       | Property                     | Value                    |
       | Code                         | 216533                   |
       | Term                         | Dolmen                   |
       | INGREDIENTS                  | Dexketoprofen trometamol |
       | Country                      | EST, Estonia             |
       | MARKETINGAUTHORIZATIONHOLDER | 20031                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "216532" at level "MP"
       | Property                     | Value                    |
       | Code                         | 216532                   |
       | Term                         | Dolmen                   |
       | INGREDIENTS                  | Dexketoprofen trometamol |
       | Country                      | EST, Estonia             |
       | MARKETINGAUTHORIZATIONHOLDER | 20031                    |
       | SEQUENCENUMBER3              | 0000000100, TABLETS      |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "247047" at level "MP"
       | Property    | Value                    |
       | Code        | 247047                   |
       | Term        | Dolmen                   |
       | INGREDIENTS | Dexketoprofen trometamol |
       | Country     | LVA, Latvia              |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "247047" at level "MP"
       | Property                     | Value                    |
       | Code                         | 247047                   |
       | Term                         | Dolmen                   |
       | INGREDIENTS                  | Dexketoprofen trometamol |
       | Country                      | LVA, Latvia              |
       | MARKETINGAUTHORIZATIONHOLDER | 22889                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "247046" at level "MP"
       | Property                     | Value                            |
       | Code                         | 247046                           |
       | Term                         | Dolmen                           |
       | INGREDIENTS                  | Dexketoprofen trometamol         |
       | Country                      | LVA, Latvia                      |
       | MARKETINGAUTHORIZATIONHOLDER | 22889                            |
       | SEQUENCENUMBER3              | 0000000127, COATED TABLETS, FILM |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "1515174" at level "MP"
       | Property    | Value                    |
       | Code        | 1515174                  |
       | Term        | Dolmen                   |
       | INGREDIENTS | Dexketoprofen trometamol |
       | Country     | LTU, Lithuania           |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "1146436" at level "MP"
       | Property                     | Value                    |
       | Code                         | 1146436                  |
       | Term                         | Dolmen                   |
       | INGREDIENTS                  | Dexketoprofen trometamol |
       | Country                      | LTU, Lithuania           |
       | MARKETINGAUTHORIZATIONHOLDER | 21387                    |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "1146435" at level "MP"
       | Property                     | Value                            |
       | Code                         | 1146435                          |
       | Term                         | Dolmen                           |
       | INGREDIENTS                  | Dexketoprofen trometamol         |
       | Country                      | LTU, Lithuania                   |
       | MARKETINGAUTHORIZATIONHOLDER | 21387                            |
       | SEQUENCENUMBER3              | 0000000127, COATED TABLETS, FILM |
  And I verify the following Selected Search Result Properties are displayed for term "Dolmen" with code "1146434" at level "MP"
       | Property                     | Value                            |
       | Code                         | 1146434                          |
       | Term                         | Dolmen                           |
       | INGREDIENTS                  | Dexketoprofen trometamol         |
       | Country                      | LTU, Lithuania                   |
       | MARKETINGAUTHORIZATIONHOLDER | 21387                            |
       | SEQUENCENUMBER3              | 0000000127, COATED TABLETS, FILM |
       | SEQUENCENUMBER4              | 0000005603, 25.0 mg              |



@VAL
@Release2015.3.0
@PBMCC_177597_017
Scenario: The browser page search results will allow you to distinguish between entries with strength variations for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "Revlimid" as a "Text" search
  And I select the following levels for the search
        | Level      |
        | Trade Name |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code          | Level |
        | Revlimid  | 016801 01 002 | TN    |



@VAL
@Release2015.3.0
@PBMCC_177597_017b
@IncreaseTimeout_900000
Scenario: The browser page search results will allow you to distinguish between entries with strength variations for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I enter "Revlimid" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path | Code    | Level |
        | Revlimid  | 1043914 | MP    |
        | Revlimid  | 1658306 | MP    |
        | Revlimid  | 1658305 | MP    |
        | Revlimid  | 1658304 | MP    |
        | Revlimid  | 1658307 | MP    |
        | Revlimid  | 1658303 | MP    |
        | Revlimid  | 1658308 | MP    |
        | Revlimid  | 1658309 | MP    |
        | Revlimid  | 1674447 | MP    |
        | Revlimid  | 1674448 | MP    |
        | Revlimid  | 1674446 | MP    |
        | Revlimid  | 1674449 | MP    |
        | Revlimid  | 1674445 | MP    |
        | Revlimid  | 1674450 | MP    |
        | Revlimid  | 1674451 | MP    |
        | Revlimid  | 1597168 | MP    |
        | Revlimid  | 1597169 | MP    |
        | Revlimid  | 1597170 | MP    |
        | Revlimid  | 1597167 | MP    |
        | Revlimid  | 1651175 | MP    |
        | Revlimid  | 1651176 | MP    |
        | Revlimid  | 1651174 | MP    |
        | Revlimid  | 1043913 | MP    |
        | Revlimid  | 1492130 | MP    |
        | Revlimid  | 1043912 | MP    |
        | Revlimid  | 1043915 | MP    |
        | Revlimid  | 1043911 | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Revlimid" with code "1658307" at level "MP"
       | Property                     | Value                |
       | Code                         | 1658307              |
       | Term                         | Revlimid             |
       | INGREDIENTS                  | Lenalidomide         |
       | Country                      | AUS, Australia       |
       | MARKETINGAUTHORIZATIONHOLDER | 83872                |
       | SEQUENCENUMBER3              | 0000000150, CAPSULES |
       | SEQUENCENUMBER4              | 0000000005, 10 mg    |
  And I verify the following Selected Search Result Properties are displayed for term "Revlimid" with code "1658303" at level "MP"
       | Property                     | Value                |
       | Code                         | 1658303              |
       | Term                         | Revlimid             |
       | INGREDIENTS                  | Lenalidomide         |
       | Country                      | AUS, Australia       |
       | MARKETINGAUTHORIZATIONHOLDER | 83872                |
       | SEQUENCENUMBER3              | 0000000150, CAPSULES |
       | SEQUENCENUMBER4              | 0000000020, 5 mg     |
  And I verify the following Selected Search Result Properties are displayed for term "Revlimid" with code "1658308" at level "MP"
       | Property                     | Value                |
       | Code                         | 1658308              |
       | Term                         | Revlimid             |
       | INGREDIENTS                  | Lenalidomide         |
       | Country                      | AUS, Australia       |
       | MARKETINGAUTHORIZATIONHOLDER | 83872                |
       | SEQUENCENUMBER3              | 0000000150, CAPSULES |
       | SEQUENCENUMBER4              | 0000000023, 25 mg    |
  And I verify the following Selected Search Result Properties are displayed for term "Revlimid" with code "1658309" at level "MP"
       | Property                     | Value                |
       | Code                         | 1658309              |
       | Term                         | Revlimid             |
       | INGREDIENTS                  | Lenalidomide         |
       | Country                      | AUS, Australia       |
       | MARKETINGAUTHORIZATIONHOLDER | 83872                |
       | SEQUENCENUMBER3              | 0000000150, CAPSULES |
       | SEQUENCENUMBER4              | 0000000093, 15 mg    |
  And I verify the following Selected Search Result Properties are displayed for term "Revlimid" with code "1674449" at level "MP"
       | Property                     | Value                |
       | Code                         | 1674449              |
       | Term                         | Revlimid             |
       | NAMESPECIFIER                | Celgene Europe 10mg  |
       | INGREDIENTS                  | Lenalidomide         |
       | Country                      | NLD, Netherlands     |
       | MARKETINGAUTHORIZATIONHOLDER | 83891                |
       | SEQUENCENUMBER3              | 0000000150, CAPSULES |
       | SEQUENCENUMBER4              | 0000000005, 10 mg    |
  And I verify the following Selected Search Result Properties are displayed for term "Revlimid" with code "1674445" at level "MP"
       | Property                     | Value                |
       | Code                         | 1674445              |
       | Term                         | Revlimid             |
       | NAMESPECIFIER                | Celgene Europe 5mg   |
       | INGREDIENTS                  | Lenalidomide         |
       | Country                      | NLD, Netherlands     |
       | MARKETINGAUTHORIZATIONHOLDER | 83891                |
       | SEQUENCENUMBER3              | 0000000150, CAPSULES |
       | SEQUENCENUMBER4              | 0000000020, 5 mg     |
  And I verify the following Selected Search Result Properties are displayed for term "Revlimid" with code "1674450" at level "MP"
       | Property                     | Value                |
       | Code                         | 1674450              |
       | Term                         | Revlimid             |
       | NAMESPECIFIER                | Celgene Europe 25mg  |
       | INGREDIENTS                  | Lenalidomide         |
       | Country                      | NLD, Netherlands     |
       | MARKETINGAUTHORIZATIONHOLDER | 83891                |
       | SEQUENCENUMBER3              | 0000000150, CAPSULES |
       | SEQUENCENUMBER4              | 0000000023, 25 mg    |
  And I verify the following Selected Search Result Properties are displayed for term "Revlimid" with code "1674451" at level "MP"
       | Property                     | Value                |
       | Code                         | 1674451              |
       | Term                         | Revlimid             |
       | NAMESPECIFIER                | Celgene Europe 15mg  |
       | INGREDIENTS                  | Lenalidomide         |
       | Country                      | NLD, Netherlands     |
       | MARKETINGAUTHORIZATIONHOLDER | 83891                |
       | SEQUENCENUMBER3              | 0000000150, CAPSULES |
       | SEQUENCENUMBER4              | 0000000093, 15 mg    |
  And I verify the following Selected Search Result Properties are displayed for term "Revlimid" with code "1597167" at level "MP"
       | Property                     | Value                |
       | Code                         | 1597167              |
       | Term                         | Revlimid             |
       | INGREDIENTS                  | Lenalidomide         |
       | Country                      | SWE, Sweden          |
       | MARKETINGAUTHORIZATIONHOLDER | 83443                |
       | SEQUENCENUMBER3              | 0000000150, CAPSULES |
       | SEQUENCENUMBER4              | 0000000020, 5 mg     |
  And I verify the following Selected Search Result Properties are displayed for term "Revlimid" with code "1043915" at level "MP"
       | Property                     | Value                |
       | Code                         | 1043915              |
       | Term                         | Revlimid             |
       | INGREDIENTS                  | Lenalidomide         |
       | Country                      | USA, United States   |
       | MARKETINGAUTHORIZATIONHOLDER | 1808                 |
       | SEQUENCENUMBER3              | 0000000150, CAPSULES |
       | SEQUENCENUMBER4              | 0000000005, 10 mg    |
  And I verify the following Selected Search Result Properties are displayed for term "Revlimid" with code "1043911" at level "MP"
       | Property                     | Value                |
       | Code                         | 1043911              |
       | Term                         | Revlimid             |
       | INGREDIENTS                  | Lenalidomide         |
       | Country                      | USA, United States   |
       | MARKETINGAUTHORIZATIONHOLDER | 1808                 |
       | SEQUENCENUMBER3              | 0000000150, CAPSULES |
       | SEQUENCENUMBER4              | 0000000020, 5 mg     |



@VAL
@Release2015.3.0
@PBMCC_177597_018
Scenario: The browser page search results will allow you to distinguish between preferred entries by ATC variations for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I select Synonym List "Without Synonyms" and Template "High To Low"
  And I enter "Timolol" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Preferred Name |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path                           | Code          | Level |
        | Timolol                             | 003712 01 001 | PN    |
        | BETA BLOCKING AGENTS                | S01ED         | ATC   |
        | BETA BLOCKING AGENTS, NON-SELECTIVE | C07AA         | ATC   |
  And I verify the following Selected Search Result Properties are displayed for term "Timolol" with code "003712 01 001" at level "PN"
       | Property        | Value         |
       | Code            | 003712 01 001 |
       | Term            | Timolol       |
       | SEQUENCENUMBER2 | 001           |
       | Ingredients     | TIMOLOL       |

@VAL
@Release2015.3.0
@PBMCC_177597_018b
Scenario: The browser page search results will allow you to distinguish between trade name entries by ATC variations for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I select Synonym List "Without Synonyms" and Template "High To Low"
  And I enter "Timolol" as a "Text" search
  And I select the following levels for the search
        | Level      |
        | Trade Name |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path                           | Code          | Level |
        | BETA BLOCKING AGENTS                | S01ED         | ATC   |
        | BETA BLOCKING AGENTS, NON-SELECTIVE | C07AA         | ATC   |
        | Timolol /00371202/                  | 003712 02 024 | TN    |
  And I verify the following Selected Search Result Properties are displayed for term "Timolol /00371202/" with code "003712 02 024" at level "TN"
       | Property    | Value              |
       | Code        | 003712 02 024      |
       | Term        | Timolol /00371202/ |
       | Ingredients | TIMOLOL MALEATE    |


@VAL
@Release2015.3.0
@PBMCC_177597_018c
@IncreaseTimeout_360000
Scenario: The browser page search results will allow you to distinguish between entries with ATC variations for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I select Synonym List "Without Synonyms" and Template "High To Low"
  And I enter "Timolol" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  And I want only exact match results
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path                           | Code  | Level |
        | Beta blocking agents                | S01ED | ATC   |
        | Beta blocking agents, non-selective | C07AA | ATC   |


@VAL
@Release2015.3.0
@PBMCC_177597_019
Scenario: The browser page search results will allow you to distinguish between preferred or trade name entries by ATC variations for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I select Synonym List "Without Synonyms" and Template "High To Low"
  And I enter "Abalgin" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Preferred Name |
        | Trade Name     |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path                                        | Code          | Level |
        | DIPHENYLPROPYLAMINE DERIVATIVES                  | N02AC         | ATC   |
        | Abalgin /00018802/                               | 000188 02 006 | TN    |
        | PYRAZOLONES                                      | N02BB         | ATC   |
        | Abalgin /01557701/                               | 015577 01 002 | TN    |
        | ANTISPASMODICS IN COMBINATION WITH PSYCHOLEPTICS | A03C          | ATC   |
        | Abalgin /06119301/                               | 061193 01 001 | PN    |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin /00018802/" with code "000188 02 006" at level "TN"
       | Property    | Value                            |
       | Code        | 000188 02 006                    |
       | Term        | Abalgin /00018802/               |
       | Ingredients | DEXTROPROPOXYPHENE HYDROCHLORIDE |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin /01557701/" with code "015577 01 002" at level "TN"
       | Property    | Value                            |
       | Code        | 015577 01 002                    |
       | Term        | Abalgin /01557701/               |
       | Ingredients | ADIPHENINE, PROPYPHENAZONE |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin /06119301/" with code "061193 01 001" at level "PN"
       | Property        | Value                     |
       | Code            | 061193 01 001             |
       | Term            | Abalgin /06119301/        |
       | Ingredients     | PHENOBARBITAL, ADIPHENINE |
       | SEQUENCENUMBER2 | 001                       |


@VAL
@Release2015.3.0
@PBMCC_177597_019b
@IncreaseTimeout_900000
Scenario: The browser page search results will allow you to distinguish between trade name entries with ATC variations for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I select Synonym List "Without Synonyms" and Template "High To Low"
  And I enter "Abalgin" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
  And I want only exact match results
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path                                        | Code    | Level |
        | Diphenylpropylamine derivatives                  | N02AC   | ATC   |
        | Abalgin                                          | 87432   | MP    |
        | Abalgin                                          | 1224752 | MP    |
        | Abalgin                                          | 4609    | MP    |
        | Abalgin                                          | 4615    | MP    |
        | Abalgin                                          | 1270056 | MP    |
        | Abalgin                                          | 129531  | MP    |
        | Abalgin                                          | 129530  | MP    |
        | Pyrazolones                                      | N02BB   | ATC   |
        | Abalgin                                          | 754094  | MP    |
        | Abalgin                                          | 1425333 | MP    |
        | Abalgin                                          | 754093  | MP    |
        | Abalgin                                          | 754092  | MP    |
        | Abalgin                                          | 754095  | MP    |
        | ANTISPASMODICS IN COMBINATION WITH PSYCHOLEPTICS | A03C    | ATC   |
        | Abalgin                                          | 1190443 | MP    |
        | Abalgin                                          | 1524151 | MP    |
        | Abalgin                                          | 1190442 | MP    |
        | Abalgin                                          | 1190441 | MP    |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "87432" at level "MP"
       | Property    | Value                            |
       | Code        | 87432                            |
       | Term        | Abalgin                          |
       | INGREDIENTS | Dextropropoxyphene hydrochloride |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "1224752" at level "MP"
       | Property    | Value                            |
       | Code        | 1224752                          |
       | Term        | Abalgin                          |
       | INGREDIENTS | Dextropropoxyphene hydrochloride |
       | Country     | DNK, Denmark                     |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "4609" at level "MP"
       | Property                     | Value                            |
       | Code                         | 4609                             |
       | Term                         | Abalgin                          |
       | INGREDIENTS                  | Dextropropoxyphene hydrochloride |
       | Country                      | DNK, Denmark                     |
       | NAMESPECIFIER                | Retard                           |
       | MARKETINGAUTHORIZATIONHOLDER | 268                              |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "4615" at level "MP"
       | Property                     | Value                            |
       | Code                         | 4615                             |
       | Term                         | Abalgin                          |
       | INGREDIENTS                  | Dextropropoxyphene hydrochloride |
       | Country                      | DNK, Denmark                     |
       | MARKETINGAUTHORIZATIONHOLDER | 268                              |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "1270056" at level "MP"
       | Property    | Value                            |
       | Code        | 1270056                          |
       | Term        | Abalgin                          |
       | INGREDIENTS | Dextropropoxyphene hydrochloride |
       | Country     | FIN, Finland                     |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "129531" at level "MP"
       | Property                     | Value                            |
       | Code                         | 129531                           |
       | Term                         | Abalgin                          |
       | INGREDIENTS                  | Dextropropoxyphene hydrochloride |
       | Country                      | FIN, Finland                     |
       | MARKETINGAUTHORIZATIONHOLDER | 17691                            |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "129530" at level "MP"
       | Property                     | Value                            |
       | Code                         | 129530                           |
       | Term                         | Abalgin                          |
       | INGREDIENTS                  | Dextropropoxyphene hydrochloride |
       | Country                      | FIN, Finland                     |
       | MARKETINGAUTHORIZATIONHOLDER | 17691                            |
       | SEQUENCENUMBER3              | 0000000150, CAPSULES             |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "754094" at level "MP"
       | Property    | Value                      |
       | Code        | 754094                     |
       | Term        | Abalgin                    |
       | INGREDIENTS | Adiphenine, Propyphenazone |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "1425333" at level "MP"
       | Property    | Value                      |
       | Code        | 1425333                    |
       | Term        | Abalgin                    |
       | INGREDIENTS | Adiphenine, Propyphenazone |
       | Country     | CHL, Chile                 |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "754093" at level "MP"
       | Property                     | Value                      |
       | Code                         | 754093                     |
       | Term                         | Abalgin                    |
       | INGREDIENTS                  | Adiphenine, Propyphenazone |
       | Country                      | CHL, Chile                 |
       | MARKETINGAUTHORIZATIONHOLDER | 1986                       |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "754092" at level "MP"
       | Property                     | Value                            |
       | Code                         | 754092                           |
       | Term                         | Abalgin                          |
       | INGREDIENTS                  | Adiphenine, Propyphenazone       |
       | Country                      | CHL, Chile                       |
       | MARKETINGAUTHORIZATIONHOLDER | 1986                             |
       | SEQUENCENUMBER3              | 0000000351, SUPPOSITORIES, ADULT |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "754095" at level "MP"
       | Property                     | Value                                 |
       | Code                         | 754095                                |
       | Term                         | Abalgin                               |
       | INGREDIENTS                  | Adiphenine, Propyphenazone            |
       | Country                      | CHL, Chile                            |
       | MARKETINGAUTHORIZATIONHOLDER | 1986                                  |
       | SEQUENCENUMBER3              | 0000000352, SUPPOSITORIES, PAEDIATRIC |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "1190443" at level "MP"
       | Property        | Value                     |
       | Code            | 1190443                   |
       | Term            | Abalgin                   |
       | INGREDIENTS     | Adiphenine, Phenobarbital |
       | SEQUENCENUMBER2 | 001                       |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "1524151" at level "MP"
       | Property        | Value                      |
       | Code            | 1524151                    |
       | Term            | Abalgin                    |
       | INGREDIENTS     | Adiphenine, Phenobarbital  |
       | Country         | CHL, Chile                 |
       | SEQUENCENUMBER2 | 001                        |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "1190442" at level "MP"
       | Property                     | Value                      |
       | Code                         | 1190442                    |
       | Term                         | Abalgin                    |
       | INGREDIENTS                  | Adiphenine, Phenobarbital  |
       | Country                      | CHL, Chile                 |
       | MARKETINGAUTHORIZATIONHOLDER | 1986                       |
       | SEQUENCENUMBER2              | 001                        |
  And I verify the following Selected Search Result Properties are displayed for term "Abalgin" with code "1190441" at level "MP"
       | Property                     | Value                      |
       | Code                         | 1190441                    |
       | Term                         | Abalgin                    |
       | INGREDIENTS                  | Adiphenine, Phenobarbital  |
       | Country                      | CHL, Chile                 |
       | MARKETINGAUTHORIZATIONHOLDER | 1986                       |
       | SEQUENCENUMBER3              | 0000000251, LIQUIDS, DROPS |
       | SEQUENCENUMBER2              | 001                        |



@VAL
@Release2015.3.0
@PBMCC_177597_020
Scenario: The browser page search results will allow you to search by partial drug codes using a wildcard for WHODrugB2

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-B2-201003-English"
  And I enter "001604*" as a "Code" search
  And I select the following levels for the search
        | Level          |
        | Preferred Name |
        | Trade Name     |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path               | Code          | Level |
        | Dosulepin               | 001604 01 001 | PN    |
        | Dothiepin /00160401/    | 001604 01 003 | TN    |
        | Prothiedin              | 001604 01 004 | TN    |
        | Depropin                | 001604 01 005 | TN    |
        | Qualiaden               | 001604 01 006 | TN    |
        | Dosulepin hydrochloride | 001604 02 001 | PN    |
        | Idom                    | 001604 02 002 | TN    |
        | Dothep                  | 001604 02 003 | TN    |
        | Protiadene              | 001604 02 004 | TN    |
        | Dosulepin /00160402/    | 001604 02 005 | TN    |
        | Dothapax                | 001604 02 006 | TN    |
        | Dothiepin /00160402/    | 001604 02 007 | TN    |
        | Thaden                  | 001604 02 008 | TN    |
        | Prothiaden              | 001604 02 009 | TN    |
        | Dothiepin kent          | 001604 02 012 | TN    |
        | Dothiepin cox           | 001604 02 013 | TN    |
        | Prepadine               | 001604 02 014 | TN    |
        | Dothiepin Sandoz        | 001604 02 015 | TN    |
        | Dosulepin almus         | 001604 02 016 | TN    |
        | Protiaden               | 001604 02 017 | TN    |
        | Xerenal                 | 001604 02 018 | TN    |
        | Espin /00160402/        | 001604 02 019 | TN    |
        | Dopress                 | 001604 02 020 | TN    |
        | Do-re-me                | 001604 02 021 | TN    |
        | Dothip                  | 001604 02 022 | TN    |
        | Exodep                  | 001604 02 023 | TN    |
        | Dozep                   | 001604 02 024 | TN    |
        | Doth                    | 001604 02 025 | TN    |
        | Dothin                  | 001604 02 026 | TN    |
        | Pindep                  | 001604 02 027 | TN    |
        | Rolab-dothiepin         | 001604 02 028 | TN    |
        | Dopin /00160402/        | 001604 02 029 | TN    |
        | Singsong                | 001604 02 030 | TN    |
        | Dotopine                | 001604 02 031 | TN    |
        | Vick-Thiaden            | 001604 02 032 | TN    |



@DFT
@Release2015.3.0
@PBMCC_177597_020b
@IncreaseTimeout_1800000
@Bug_MCC_209353
Scenario: The browser page search results will allow you to search by partial drug codes using a wildcard for WHODrugC

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrug_DDE_C ENG 201003"
  And I begin a search in dictionary "WHODrug-DDE-C-201003-English"
  And I select Synonym List "Without Synonyms" and Template "Low to High"
  And I enter "*" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Medicinal Product |
 And I select the following attributes for the search
        | Operator | Attribute        | Text   |
        | Has      | DRUGRECORDNUMBER | 001604 |
  When I execute the above specified search
  Then All results returned should have the following properties
  | Property         | Value  |
  | DRUGRECORDNUMBER | 001604 |
