@specDictionarySearchResults.feature
@CoderCore
Feature: This feature will verify the behavior of the coding system's Dictionary Search and Results Content

@VAL
@PBMCC_154852_002
@Release2015.3.0
@IncreaseTimeout_360000
Scenario: A dictionary search for MedDRA (JPN) with template high to low will provide dictionary levels in the following order: SOC, HLGT, HLT, PT, and LLT

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA JPN 15.0"
  And I begin a search in dictionary "MedDRA 15.0 Japanese"
  And I select Synonym List "Without Synonyms" and Template "High To Low"
  And I enter "ウィップル病" as a "Text" search
  And I select the following levels for the search
        | Level             |
        | Low Level Term    |
  And I want only exact match results
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
         | Term Path     | Code     | Level |
         | 胃腸障害      | 10017947  | SOC  |
         | 吸収不良性疾患 | 10025477 | HLGT |
         | 吸収不良症候群 | 10025480 | HLT  |
         | ホイップル病   | 10047931 | PT   |
         | ウィップル病   | 10047933 | LLT  |


@VAL
@PBMCC_154852_008
@Release2015.3.0
Scenario: A dictionary search for J-Drug (JPN) will provide correct dictionary levels in the following order: (大) High-Level, (中) Mid-Level, (小) Low-Level, and (細) Detailed Classifications

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "JDrug JPN 2014h2"
  And I begin a search in dictionary "J-Drug 2014h2 Japanese"
  And I select Synonym List "Without Synonyms" and Template "High To Low"
  And I enter "プロタミン製剤" as a "Text" search
  And I select the following levels for the search
        | Level                   |
        | Detailed Classification |
  And I want only exact match results
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
        | Term Path             | Code | Level |
        | 代謝性医薬品           | 3    | 大     |
        | 血液・体液用薬         | 33   | 中     |
        | その他の血液・体液用薬  | 339  | 小     |
        | プロタミン製剤         | 3391 | 細     |


@VAL
@PBMCC_154852_009
@Release2015.3.0
Scenario: A dictionary search for J-Drug (JPN) will provide correct dictionary levels in the following order: (大) High-Level, (中) Mid-Level, (小) Low-Level, (細) Detailed, (般) Preferred Name, (区) Category, (薬) Drug Name, (英) English Name

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "JDrug JPN 2014h2"
  And I begin a search in dictionary "J-Drug 2014h2 Japanese"
  And I select Synonym List "Without Synonyms" and Template "High To Low"
  And I enter "コカイン塩酸塩" as a "Text" search
  And I select the following levels for the search
        | Level     |
        | Drug Name |
  And I want only exact match results
  When I execute the above specified search
  And I expand the search result for term "コカイン塩酸塩" with code "8121700" at level "薬"
  Then I verify the following information is contained in the browser search results
       | Term Path                   | Code    | Level |
       | 麻薬                        | 8       | 大     |
       | アルカロイド系麻薬（天然麻薬）| 81      | 中     |
       | コカアルカロイド系製剤        | 812     | 小     |
       | コカイン系製剤               | 8121    | 細     |
       | コカイン塩酸塩               | 8121700 | 般     |
       | 外                          | 6       | 区     |
       | コカイン塩酸塩               | 8121700 | 薬     |
       | COCAINE HYDROCHLORIDE       | 8121700 | 英     |


@VAL
@PBMCC_124197_001
@Release2015.3.0
Scenario: Consecutive searches against WHODrug Dictionaries against term code should respond within several seconds
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201003"
  And the following dictionary searches
	  | Dictionary Name               | Search Text   | Text Target | Levels         |
	  | WHODrug-DDE-B2-201003-English | 003467 01 001 | Code        | Preferred Name |
	  | WHODrug-DDE-B2-201003-English | 005542 01 001 | Code        | Preferred Name |
	  | WHODrug-DDE-B2-201003-English | 009012 01 001 | Code        | Preferred Name |
  When the above specified dictionary searches are executed
  Then all searches executed should have completed within "5" seconds

@VAL
@PBMCC_199327_001a
@Release2015.3.1
Scenario: An open dictionary search result that is associated to a previously created synonym should be positively identified in MedDRA
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And a synonym list file named "MedDRA_150_ENG_20.txt" is uploaded
  And I begin a search in dictionary "MedDRA 15.0 English"
  And I select Synonym List "Primary List" and Template "Low to High"
  And I enter "10030617" as a "Code" search
  And I select the following levels for the search
        | Level          |
        | Low Level Term |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
	    | Term Path                                  | Code     | Level | Has Synonym |
	    | Open fracture of second cervical vertebra  | 10030617 | LLT   | True        |

@VAL
@PBMCC_199327_001b
@Release2015.3.1
Scenario: An open dictionary search result that is associated to a previously created synonym should be positively identified in WHODrugDDEB2
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201206"
  And a synonym list file named "WHODrug_201206_ENG_2.txt" is uploaded
  And I begin a search in dictionary "WHODrugDDEB2 201206 English"
  And I select Synonym List "Primary List" and Template "Low to High"
  And I enter "000039 02 063" as a "Code" search
  And I select the following levels for the search
        | Level      |
        | Trade Name |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
	    | Term Path               | Code          | Level | Has Synonym |
	    | ADRENALIN HYDROCHLORIDE | 000039 02 063 | TN    | True        |


@VAL
@PBMCC_199327_001c
@Release2015.3.1
Scenario: An open dictionary search result that is associated to a previously created synonym should be positively identified in JDrug
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "JDrug ENG 2015H1"
  And a synonym list file named "JDrug_2015H1_ENG_2.txt" is uploaded
  And I begin a search in dictionary "JDrug 2015H1 English"
  And I select Synonym List "Primary List" and Template "Low to High"
  And I enter "CHONDRON" as a "Text" search
  And I select the following levels for the search
        | Level      |
        | Drug Name |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
	    | Term Path | Code      | Level  | Has Synonym |
	    | CHONDRON  | 399100102 | 薬     | True       |
	    | CHONDRON  | 131970902 | 薬     | True       |


@VAL
@PBMCC_199327_001d
@Release2015.3.1
Scenario: An open dictionary search result that is associated to a previously created synonym should be positively identified in AZDD
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "AZDD ENG 15.1"
  And a synonym list file named "AZDD_151_ENG_2.txt" is uploaded
  And I begin a search in dictionary "AZDD 15.1 English"
  And I select Synonym List "Primary List" and Template "Low to High"
  And I enter "Typhoid" as a "Text" search
  And I select the following levels for the search
        | Level          |
        | Preferred Name |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
	    | Term Path                       | Code          | Level | Has Synonym |
	    | TYPHOID VACCINE                 | 001670 01 001 | PN    | True        |
	    | CHOLERA VACCINE+TYPHOID VACCINE | 003886 01 001 | PN    | True        |

@VAL
@PBMCC_199327_002
@Release2015.3.1
@IncreaseTimeout_360000
Scenario: An open dictionary search with multiple synonyms should positively identify all results associated to a synonym
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And a synonym list file named "MedDRA_150_ENG_20.txt" is uploaded
  And I begin a search in dictionary "MedDRA 15.0 English"
  And I select Synonym List "Primary List" and Template "Low to High"
  And I enter "Closed fracture of second cervical vertebra" as a "Text" search
  And I select the following levels for the search
         | Level          |
         | Low Level Term |
  And I select the following higher level terms for the search
	     | Operator | Attribute       | Text                              |
	     | Has      | High Level Term | Spinal fractures and dislocations |
  And I want only primary path results
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
         | Term Path                                               | Code     | Level | Has Synonym |
         | Closed fracture of second cervical vertebra             | 10009589 | LLT   | True        |
         | Closed dislocation, second cervical vertebra            | 10009394 | LLT   | True        |
         | Open fracture of second cervical vertebra               | 10030617 | LLT   | True        |
         | Closed fracture of cervical vertebra, unspecified level | 10009534 | LLT   | True        |
         | Closed fracture of fifth cervical vertebra              | 10009544 | LLT   | True        |
         | Closed fracture of seventh cervical vertebra            | 10009591 | LLT   | True        |
         | Closed fracture of sixth cervical vertebra              | 10009599 | LLT   | True        |
         | Closed fracture of first cervical vertebra              | 10009545 | LLT   | True        |
         | Closed fracture of fourth cervical vertebra             | 10009548 | LLT   | True        |
         | Closed fracture of third cervical vertebra              | 10009612 | LLT   | True        |
         | Closed dislocation, cervical vertebra                   | 10009383 | LLT   | True        |
         | Open dislocation, second cervical vertebra              | 10030396 | LLT   | True        |
         | Fracture of vertebra                                    | 10017266 | LLT   | True        |
         | Closed dislocation, first cervical vertebra             | 10009387 | LLT   | True        |
         | Closed dislocation, fourth cervical vertebra            | 10009388 | LLT   | True        |
         | Closed dislocation, seventh cervical vertebra           | 10009395 | LLT   | True        |
         | Closed dislocation, third cervical vertebra             | 10009398 | LLT   | True        |
         | Closed dislocation, cervical vertebra, unspecified      | 10009384 | LLT   | True        |
         | Closed dislocation, fifth cervical vertebra             | 10009386 | LLT   | True        |
         | Closed dislocation, sixth cervical vertebra             | 10009396 | LLT   | True        |
         | Closed dislocation, sixth cervical vertebra             | 10009396 | LLT   | True        |
         | Open fracture of multiple cervical vertebrae            | 10030589 | LLT   | True        |
         | Lumbar vertebral fracture L3                            | 10049959 | LLT   | True        |
         | Thoracic vertebral fracture T10                         | 10049963 | LLT   | True        |

@VAL
@PBMCC_199327_003a
@Release2015.3.1
Scenario: A browse and code for a term that is associated to a previously created synonym should be positively identified in MedDRA
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And coding task "Adverse Event 4" for dictionary level "LLT"
  And a synonym list file named "MedDRA_150_ENG_20.txt" is uploaded
  When a browse and code for task "Adverse Event 4" is performed
  And the browse and code search is done for "10009589" against "Code" at Level "Low Level Term"
  Then I verify the following information is contained in the browser search results
	    | Term Path                                   | Code     | Level | Has Synonym |
	    | Closed fracture of second cervical vertebra | 10009589 | LLT   | True        |


@VAL
@PBMCC_199327_003b
@Release2015.3.1
Scenario: A browse and code for a term that is associated to a previously created synonym should be positively identified in WHODrugDDEB2
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201206"
    And coding task "Adverse Event 4" for dictionary level "PRODUCTSYNONYM"
  And a synonym list file named "WHODrug_201206_ENG_2.txt" is uploaded
  When a browse and code for task "Adverse Event 4" is performed
  And the browse and code search is done for "000039 02 063" against "Code" at Level "Trade Name"
  Then I verify the following information is contained in the browser search results
	    | Term Path               | Code          | Level | Has Synonym |
	    | ADRENALIN HYDROCHLORIDE | 000039 02 063 | TN    | True        |



@VAL
@PBMCC_199327_003c
@Release2015.3.1
Scenario: A browse and code for a term that is associated to a previously created synonym should be positively identified in JDrug
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "JDrug ENG 2015H1"
  And coding task "Adverse Event 4" for dictionary level "DrugName"
  And a synonym list file named "JDrug_2015H1_ENG_2.txt" is uploaded
  When a browse and code for task "Adverse Event 4" is performed
  And the browse and code search is done for "CHONDRON" against "Text" at Level "Drug Name"
  Then I verify the following information is contained in the browser search results
	    | Term Path | Code      | Level | Has Synonym |
	    | CHONDRON  | 399100102 | 薬     | True       |
	    | CHONDRON  | 131970902 | 薬     | True       |


@VAL
@PBMCC_199327_003d
@Release2015.3.1
Scenario: A browse and code for a term that is associated to a previously created synonym should be positively identified in AZDD
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "AZDD ENG 15.1"
  And coding task "Adverse Event 4" for dictionary level "PRODUCT"
  And a synonym list file named "AZDD_151_ENG_2.txt" is uploaded
  When a browse and code for task "Adverse Event 4" is performed
  And the browse and code search is done for "Typhoid" against "Text" at Level "Preferred Name"
  Then I verify the following information is contained in the browser search results
	    | Term Path                       | Code          | Level | Has Synonym |
	    | TYPHOID VACCINE                 | 001670 01 001 | PN    | True        |
	    | CHOLERA VACCINE+TYPHOID VACCINE | 003886 01 001 | PN    | True        |


@VAL
@PBMCC_199327_004
@Release2015.3.1
Scenario: An open dictionary search with no synonyoms should not contain any results positively identified as associated to a synonym
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And I begin a search in dictionary "MedDRA 15.0 English"
  And I select Synonym List "Primary List" and Template "Low to High"
  And I enter "10058730" as a "Code" search
  And I select the following levels for the search
        | Level          |
        | Low Level Term |
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
	    | Term Path                                  | Code     | Level | Has Synonym |
	    | Application site photosensitivity reaction | 10058730 | LLT   | False       |
  
@VAL
@PBMCC_199327_005
@Release2015.3.1
Scenario: A browse and code for a term that is not associated to a synonym should not be positively identified as associated to a synonym
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And coding task "Adverse Event 4" for dictionary level "LLT"
  When a browse and code for task "Adverse Event 4" is performed
  And the browse and code search is done for "10009589" against "Code" at Level "Low Level Term"
  Then I verify the following information is contained in the browser search results
	    | Term Path                                   | Code     | Level | Has Synonym |
	    | Closed fracture of second cervical vertebra | 10009589 | LLT   | False       |

@VAL
@PBMCC_204358_001
@Release2015.3.2
@UITest
Scenario: A dictionary search with over 100 results should display results on multiple pages
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And I begin a search in dictionary "MedDRA 15.0 English"
  And I enter "pain" as a "Text" search
  And I select the following levels for the search
		| Level          |
		| Preferred Term |
  And I do not want primary path results
  When I execute the above specified search
  Then I verify the following information is contained in the browser search results
         | Term Path                     | Code     | Level |
         | Loin pain haematuria syndrome | 10071137 | PT    |
         | Musculoskeletal chest pain    | 10050819 | PT    |
         | Paradoxical pain              | 10067055 | PT    |

@VAL
@PBMCC_204358_002
@Release2015.3.2
@UITest
@IncreaseTimeout_360000
Scenario: Multiple pages of dictionary search results should provide access to term properties for all results
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WHODrugDDEB2 ENG 201503"
  And I begin a search in dictionary "WHODrugDDEB2 201503 English"
  And I enter "betacarotene" as a "Text" search
  And I select the following levels for the search
		| Level          |
		| Preferred Name |
  When I execute the above specified search
  Then I verify the following Selected Search Result Properties are displayed for term "BETACAROTENE W/HISTIDINE/IRON/ISOLEUCINE/LEUC" with code "076980 01 001" at level "PN"
		| Property            | Value  |
		| DRUGRECORDNUMBER    | 076980 |
		| NUMBEROFINGREDIENTS | 15     |
  Then I verify the following Selected Search Result Properties are displayed for term "BETACAROTENE W/BIOFLAVONOIDS/CALCIU/07442701/" with code "074427 01 001" at level "PN"
		| Property            | Value  |
		| DRUGRECORDNUMBER    | 074427 |
		| NUMBEROFINGREDIENTS | 23     |
  Then I verify the following Selected Search Result Properties are displayed for term "ASCORBIC ACID W/BETACAROTENE/BIOTIN/08292501/" with code "082925 01 001" at level "PN"
		| Property            | Value  |
		| DRUGRECORDNUMBER    | 082925 |
		| NUMBEROFINGREDIENTS | 28     |
  Then I verify the following Selected Search Result Properties are displayed for term "ASCORBIC ACID W/BETACAROTENE/VITAMIN E NOS" with code "081113 01 001" at level "PN"
		| Property            | Value  |
		| DRUGRECORDNUMBER    | 081113 |
		| NUMBEROFINGREDIENTS | 3      |


@VAL
@PBMCC_204440_001
@Release2015.3.2
Scenario: MedDRA Dictionary Search Results should contain only terms for current paths
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA JPN 18.0"
	And I begin a search in dictionary "MedDRA 18.0 Japanese"
	And I select Synonym List "Without Synonyms" and Template "Low to High"
	And I enter "高脂血症" as a "Text" search
	And I select the following levels for the search
         | Level          |
         | Low Level Term |
	And I want only exact match results
	And I want only primary path results
	When I execute the above specified search
	Then the dictionary search results should contain only the following terms
	     | Term Path | Code     | Level |
	     | 高脂血症   | 10062060 | LLT   |

@DFT
@PBMCC_154852_003
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, a dictionary browse for WhoDrugDDEB2 (ENG) you will see the correct dictionary levels in the following order: ATC, ATC, ATC, ATC, PT, and TN

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "WhoDrugDDEB2" locale "ENG" version "201409"
  Then I verify a browse for "MEPIVACAINUM" where the following dictionary information is traversable and displayed,
       |Image Icon Level   |Term                 |Code              |
       |ATC                |NERVOUS SYSTEM       |N                 |
       |ATC                |ANESTHETICS          |N01               |
       |ATC                |ANESTHETICS, LOCAL   |N01B              |
       |ATC                |AMIDES               |N01BB             |
       |PT                 |MEPIVACAINE          |000103 01 001 3   |
       |TN                 |MEPIVACAINUM         |000103 01 007 0   |


@DFT
@PBMCC_154852_004
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, a dictionary browse for WhoDrugDDEB2 (ENG) you will see the correct dictionary levels in the following order: ATC, PT, and ING

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "WhoDrugDDEB2" locale "ENG" version "201409"
  Then I verify a browse for "ZATOSETRON" where the following dictionary information is traversable and displayed,
       |Image Icon Level   |Term             |Code                         |
       |ATC                |NERVOUS SYSTEM   |N                            |
       |PT                 |ZATOSETRON       |015179 01 001 0              |
       |ING                |ZATOSETRON       |015179 01 001 0 0123482224   |


@DFT
@PBMCC_154852_005
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, a dictionary browse for WHODrug_DDE_C (ENG) you will see the correct dictionary levels in the following order: ATC, MP, and ING

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "WHODrug_DDE_C" locale "ENG" version "201409"
  Then I verify a browse for "ZATOSETRON" where the following dictionary information is traversable and displayed,
       |Image Icon Level   |Term             |Code    |
       |ATC                |NERVOUS SYSTEM   |N       |
       |MP                 |ZATOSETRON       |49650   |
       |ING                |ZATOSETRON       |81707   |


@DFT
@PBMCC_154852_006
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, a dictionary browse for WHODrug_DDE_C (ENG) you will see the correct dictionary levels in the following order: ATC, ATC, and MP

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "WHODrug_DDE_C" locale "ENG" version "201409"
  Then I verify a browse for "Antiprotozoals" where the following dictionary information is traversable and displayed,
       |Image Icon Level   |Term                                                 |Code    |
       |ATC                |ANTIPARASITIC PRODUCTS,INSECTICIDES AND REPELLENTS   |P       |
       |ATC                |ANTIPROTOZOALS                                       |P01     |
       |MP                 |Antiprotozoals                                       |50067   |


@DFT
@PBMCC_154852_007
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, a dictionary browse for J-Drug (ENG) you will see the correct dictionary levels in the following order: (大) High-Level, (中) Mid-Level, (小) Low-Level, (細) Detailed, (般) Preferred Name, (区) Category, (薬) Drug Name, (英) English Name

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "J-Drug" locale "ENG" version "201409"
  Then I verify a browse for "COCAINE HYDROCHLORIDE" where the following dictionary information is traversable and displayed,
       |Image Icon Level   |Term                                      |Code      |
       |大                 |NARCOTICS                                 |8         |
       |中                 |ALKALOIDAL NARCOTICS(NATURAL NARCOTICS)   |81        |
       |小                 |COCA ALKALOIDS PREPARATIONS               |812       |
       |細                 |COCAINE, DERIVATIVES AND PREPARATIONS     |8121      |
       |般                 |COCAINE HYDROCHLORIDE                     |8121700   |
       |区                 |EXTERNAL MEDICATION                       |6         |
       |薬                 |COCAINE HYDROCHLORIDE                     |8121700   |
       |英                 |COCAINE HYDROCHLORIDE                     |8121700   |





@DFT
@PBMCC_57406_010
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, a dictionary browse for MedDRA (ENG) you will see the correct dictionary PRIMARY levels in the following order: SOC, HLGT, HLT, PT, and LLT

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "MedDRA" locale "ENG" version "15.0"
  Then I verify a browse for "Chronic headaches" where the following dictionary information is traversable and displayed,
       |Image Icon Level   |Term                       |Code       |
       |Primary SOC        |Nervous system disorders   |10029205   |
       |Primary HLGT       |Headaches                  |10019231   |
       |Primary HLT        |Headaches NEC              |10019233   |
       |Primary PT         |Headache                   |10019211   |
       |Primary LLT        |Chronic headaches          |10053850   |


@DFT
@PBMCC_57406_011
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, a dictionary browse for MedDRA (JPN) you will see the correct dictionary PRIMARY levels in the following order: SOC, HLGT, HLT, PT, and LLT

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "MedDRA" locale "JPN" version "15.0"
  Then I verify a browse for "Chronic headaches" where the following dictionary information is traversable and displayed,
       |Image Icon Level   |Term        |Code       |
       |Primary SOC        |神経系障害   |10029205   |
       |Primary HLGT       |頭痛        |10019231   |
       |Primary HLT        |頭痛ＮＥＣ   |10019233   |
       |Primary PT         |頭痛        |10019211   |
       |Primary LLT        |慢性頭痛     |10053850   |


@DFT
@PBMCC_154852_012
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, when performing a dictionary search for any level in MedDRA (ENG) you will see the following Term Properties: Code, Term, Dictionary Level, Term Status

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "MedDRA" locale "ENG" version "15.0"
  And I search for and select the term "Blood alcohol excessive"
  Then I verify the following selected term properties:
       |Property           |Property Value            |
       |Code               |10005290                  |
       |Term               |Blood alcohol excessive   |
       |Dictionary Level   |Low Level Term            |
       |Term Status        |Active                    |


@DFT
@PBMCC_154852_013
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, when performing a dictionary search for a Trade Name level in WhoDrugDDEB2 (ENG) you will see the following Term Properties: Code, Term, Dictionary Level, Drug Record, Sequence Number 1, Sequence Number 2, Check Digit, Source Year, Source, Source Country,Designation, Company, Company Country, Number of Ingredients, Year Quarter, Ingredients

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "WhoDrugDDEB2" locale "ENG" version "201409"
  And I search on level "Trade Name" and select the term "BLOOD BUILDER"
  Then I verify the following selected term properties:
       |Property                |Property Value                     |
       |Code                    |014934 01 006 8                    |
       |Term                    |BLOOD BUILDER                      |
       |Dictionary Level        |Trade Name                         |
       |Drug Record Number      |014934                             |
       |Sequence Number 1       |01                                 |
       |Sequence Number 2       |006                                |
       |Check Digit             |8                                  |
       |Source Year             |05                                 |
       |Source                  |237, IMS Health                    |
       |Source Country          |N/A, Not Applicable                |
       |Designation             |M                                  |
       |Company                 |UNS, NOT SPECIFIED                 |
       |Company Country         |UNS, Unspecified                   |
       |Number of Ingredients   |03                                 |
       |Year Quarter            |061                                |
       |Ingredients (3)         |CYANOCOBALAMIN, FOLIC ACID, IRON   |


@DFT
@PBMCC_154852_014
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, when performing a dictionary search for a Preferred Name level in WhoDrugDDEB2 (ENG) you will see the following Term Properties: Coder, Term, Dictionary Level, Drug Record, Sequence Number 1, Sequence Number 2, Check Digit, Source Year, Source, Source Country, Designation, Number of Ingredients, Year Quarter, Ingredients

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "WhoDrugDDEB2" locale "ENG" version "201409"
  And I search on level "Preferred Name" and select the term "FERRANIN COMPLEX"
  Then I verify the following selected term properties:
       |Property                |Property Value                     |
       |Code                    |014934 01 001 9                    |
       |Term                    |FERRANIN COMPLEX                   |
       |Dictionary Level        |Preferred Name                     |
       |Drug Record Number      |014934                             |
       |Sequence Number 1       |01                                 |
       |Sequence Number 2       |001                                |
       |Check Digit             |9                                  |
       |Source Year             |00                                 |
       |Source                  |139, Manual Farmaceutico           |
       |Source Country          |ARG, Argentina                     |
       |Designation             |M                                  |
       |Number of Ingredients   |03                                 |
       |Year Quarter            |044                                |
       |Ingredients (3)         |CYANOCOBALAMIN, FOLIC ACID, IRON   |


@DFT
@PBMCC_154852_015
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, when performing a dictionary search for an ATC level in WhoDrugDDEB2 (ENG) you will see the following Term Properties: Code, Term, Dictionary Level

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "WhoDrugDDEB2" locale "ENG" version "201409"
  And I search on level "ATC" and select the term "IRON IN OTHER COMBINATIONS"
  Then I verify the following selected term properties:
       |Property                |Property Value               |
       |Code                    |B03AE                        |
       |Term                    |IRON IN OTHER COMBINATIONS   |
       |Dictionary Level        |ATC                          |


@DFT
@PBMCC_154852_016
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, when performing a dictionary search for a Medicinal Product Level in WHODrug_DDE_C (ENG) you will see the following Term Properties: Code, Term, Dictionary Level, Drug Record, Sequence Number 1, Sequence Number 2, Sequence 3, Sequence 4, Generic, Country, Company, Marketing authorization holder, Source Year, Source, Source Country, Product type, Product group, Product group, Create date, Date changed, Ingredients

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "WHODrug_DDE_C" locale "ENG" version "201409"
  And I search on level "Medicinal Product" and select the term "Scorpion venom"
  Then I verify the following selected term properties:
       |Property                         |Property Value            |
       |Code                             |129431                    |
       |Term                             |Scorpion venom            |
       |Dictionary Level                 |Medicinal Product         |
       |Drug Record Number               |018707                    |
       |Sequence Number 1                |01                        |
       |Sequence Number 2                |001                       |
       |Sequence Number 3                |0000000001, Unspecified   |
       |Sequence Number 4                |0000000001, Unspecified   |
       |Generic                          |Y                         |
       |Country                          |N/A, Not Applicable       |
       |Company                          |0                         |
       |Marketing authorization holder   |0                         |
       |Source Year                      |05                        |
       |Source                           |CHE, NC Switzerland       |
       |Source Country                   |CHE, Switzerland          |
       |Product type                     |001, Medicinal product    |
       |Product group                    |0, None                   |
       |Product group                    |20020701                  |
       |Create date                      |20050331                  |
       |Date changed                     |20050331                  |
       |Ingredients (1)                  |Scorpion venom            |


@DFT
@PBMCC_154852_017
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, when performing a dictionary search for an Ingredient level in WHODrug_DDE_C (ENG) you will see the following Term Properties: Coder, Term, Dictionary Level, Source Year, Source, Source Country, Ingredient create date, Unit, Pharmaceutical form, Number of Ingredients, Pharmaceutical form create date, Substance, CAS Number, Language Code

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "WHODrug_DDE_C" locale "ENG" version "201409"
  And I search on level "Ingredient" and select the term "Scorpion venom"
  Then I verify the following selected term properties:
       |Property                          |Property Value          |
       |Code                              |212382                  |
       |Term                              |Scorpion venom          |
       |Dictionary Level                  |Ingredient              |
       |Source Year                       |05                      |
       |Source                            |CHE, NC Switzerland     |
       |Source Country                    |CHE, Switzerland        |
       |Ingredient create date            |20050331                |
       |Unit                              |38, unspec              |
       |Pharmaceutical form               |1, Unspecified          |
       |Number of Ingredients             |01                      |
       |Pharmaceutical form create date   |20050331                |
       |Substance                         |14116, Scorpion venom   |
       |CAS Number                        |8000060368              |
       |Language Code                     |En                      |


@DFT
@PBMCC_154852_018
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, when performing a dictionary search for J-Drug (JPN) on a Drug Name Level you will see the following Term Properties: Code, Term, Dictionary Level, Usage Classification, Drug Name Kana, Manufacturer, Dosage Form, Drug Code Class 1, Maintain Flag Jpn, Maintain Date Jpn, Drug Coder Class 2, English Name

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "J-Drug" locale "JPN" version "2014H1"
  And I search on level "Drug Name" and select the term "パーキン糖衣錠"
  Then I verify the following selected term properties:
       |Property                         |Property Value            |
       |Code                             |116300101                 |
       |Term                             |パーキン糖衣錠              |
       |Dictionary Level                 |Drug Name                 |
       |Usage Classification             |1, 内                     |
       |Drug Name Kana                   |ﾊﾟ-ｷﾝﾄｳｲｼﾞﾖｳ                |
       |Preferred Name Kana              |ﾌﾟﾛﾌｴﾅﾐﾝｴﾝｻﾝｴﾝ              |
       |Manufacturer                     |393, 田辺三菱              |
       |Dosage Form                      |21000000000000000000      |
       |Drug Code Class 1                |0                         |
       |Maintain Flag Jpn                |B                         |
       |Maintain Date Jpn                |1008                      |
       |Drug Code Class 2                |4                         |
       |English Name                     |116300101, PARKIN         |


@DFT
@PBMCC_154852_019
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, when performing a dictionary search for J-Drug (JPN) on a Preferred Name Level you will see the following Term Properties: Code, Term, Dictionary Level, Usage Classification, Drug Name Kana, Preferred Name Kana, Dosage Form, Drug Code Class 1, Maintain Flag Jpn, Maintain Date Jpn, Drug Coder Class 2, JAN Flag, Maintain Date Eng, Maintain Flag Eng, English Name

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "J-Drug" locale "JPN" version "2014H1"
  And I search on level "Preferred Name" and select the term "プロフェナミン塩酸塩"
  Then I verify the following selected term properties:
       |Property                         |Property Value                       |
       |Code                             |1163001                              |
       |Term                             |プロフェナミン塩酸塩                    |
       |Dictionary Level                 |Preferred Name                       |
       |Usage Classification             |1, 内                                |
       |Drug Name Kana                   |ﾌﾟﾛﾌｴﾅﾐﾝｴﾝｻﾝｴﾝ                         |
       |Preferred Name Kana              |ﾌﾟﾛﾌｴﾅﾐﾝｴﾝｻﾝｴﾝ                         |
       |Dosage Form                      |21000000000000000000                 |
       |Drug Code Class 1                |0                                    |
       |Maintain Flag Jpn                |B                                    |
       |Maintain Date Jpn                |1008                                 |
       |Drug Code Class 2                |3                                    |
       |JAN Flag                         |1                                    |
       |Maintain Date Eng                |9806                                 |
       |Maintain Flag Eng                |B                                    |
       |English Name                     |1163001, PROFENAMINE HYDROCHLORIDE   |


@DFT
@PBMCC_154852_020
@Release2015.2.0
@ignore
Scenario: When navigating to the Browser page and performing, within Dictionary Term Search, when performing a dictionary search for J-Drug (JPN) on a Classification Level you will see the following Term Properties: Coder, Term, Dictionary Level, Drug Name Kana, Dosage Form, Drug Code Class 1, Maintain Flag Jpn, Maintain Date Jpn, Drug Code Class 2, English Name

  Given a "Basic" Coder setup with no tasks and no synonyms
  When I set dictionary term search for dictionary "J-Drug" locale "JPN" version "2014H1"
  And I search on level "Detailed Classification" and select the term "プロフェナミン製剤"
  Then I verify the following selected term properties:
       |Property                         |Property Value                        |
       |Code                             |1163                                  |
       |Term                             |プロフェナミン製剤                      |
       |Dictionary Level                 |Detailed Classification              |
       |Drug Name Kana                   |ﾌﾟﾛﾌｴﾅﾐﾝｾｲｻﾞｲ                          |
       |Dosage Form                      |00000000000000000000                 |
       |Drug Code Class 1                |0                                    |
       |Maintain Flag Jpn                |B                                    |
       |Maintain Date Jpn                |9108                                 |
       |Drug Code Class 2                |2                                    |
       |English Name                     |1163, PROFENAMINE AND PREPARATIONS   |


