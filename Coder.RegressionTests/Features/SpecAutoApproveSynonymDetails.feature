@specAutoApproveSynonymDetails.feature
@CoderCore
Feature: In general, synonyms created from direct dictionary matches will not be available when Auto Approve is configured.  
Synonyms created from direct dictionary matches will be available when Auto Approve is not configured. This logic has some 
exceptions based on the type of dictionary and single vs. multiple path synonyms. The following truth table was used to help map the requirements to the cases.

Test Case	            | AutoApprove	| Single/Multi	| Dictionary	| Synonyms
PBMCC_197253_001/011	| On	        |     Single	| MedDRA	    | Hidden
PBMCC_197253_002/012	| On	        |     Single	| WhoDrug	    | Hidden
PBMCC_197253_003/013	| On	        |     Single	| JDrug	        | Hidden
PBMCC_197253_004/014	| Off	        |     Single	| MedDRA	    | Shown
PBMCC_197253_005/015	| Off	        |     Single	| WhoDrug	    | Shown
PBMCC_197253_006/016	| Off	        |     Single	| JDrug	        | Shown
PBMCC_197253_007/017	| On	        |     Multi	    | MedDRA	    | Hidden
PBMCC_197253_008/018	| On	        |     Multi	    | WhoDrug	    | Shown
PBMCC_197253_009/019	| Off	        |     Multi	    | MedDRA	    | Shown
PBMCC_197253_010/020	| Off	        |     Multi	    | WhoDrug	    | Shown

_ The following environment configuration settings were enabled:

   Empty Synonym Lists Registered:
   Synonym List 1: MedDRA             (ENG) 16.0     MedDRA_DDM
   Synonym List 2: WhoDrugDDEB2       (ENG) 201306   WhoDrugDDEB2_DDM
   Synonym List 3: JDrug              (JPN) 2013H1   JDrug_DDM

   Common Configurations:
   Configuration Name       | Declarative Browser Class | 
   Completed Reconsider     | CompletedReconsiderSetup  | 
   Basic                    | BasicSetup                | 

@VAL
@PBMCC_197253_001
@Release2015.3.0
Scenario: When the Auto Approve option is "On" and autocoding Single path MedDRA Direct Dictionary Matches; upon creation of the synonyms, they shall not be available to download and the count shall not change
 	
	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
    And coding task "HEADACHE" for dictionary level "LLT"
	Then the number of synonyms for list "MedDRA ENG 16.0 MedDRA_DDM" is "0"
	And the synonym list "MedDRA ENG 16.0 MedDRA_DDM" cannot be downloaded
    Then a synonym for verbatim term "HEADACHE" should be created and not exist in list "MedDRA ENG 16.0 MedDRA_DDM"

@VAL
@PBMCC_197253_002
@Release2015.3.0
Scenario: When the Auto Approve option is "On" and autocoding Single path WhoDrug Direct Dictionary Matches; upon creation of the synonyms, they shall not be available to download and the count shall not change
 
 	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
    And coding task "PAIN FREE" for dictionary level "PRODUCT"
    And coding task "METHANOL" for dictionary level "PRODUCT"
	Then the number of synonyms for list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" is "0"
	And the synonym list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" cannot be downloaded
    And synonyms for verbatim terms should be created and exist in lists
	| verbatim  | dictionaryLocaleVersionSynonymListName   | exists |
	| PAIN FREE | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | false  |
	| METHANOL  | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | false  |

@VAL
@PBMCC_197253_003
@Release2015.3.0
Scenario: When the Auto Approve option is "On" and autocoding Single path JDrug Direct Dictionary Matches; upon creation of the synonyms, they shall not be available to download and the count shall not change

 	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| JDrug_DDM                  | JDrug                       | 2013H1                    | JPN    |
    And coding task "イマジニール３００" for dictionary level "DrugName"
	Then the number of synonyms for list "J-Drug JPN 2013H1 JDrug_DDM" is "0"
	And the synonym list "J-Drug JPN 2013H1 JDrug_DDM" cannot be downloaded
    And a synonym for verbatim term "イマジニール３００" should be created and not exist in list "J-Drug JPN 2013H1 JDrug_DDM"

@VAL
@PBMCC_197253_004
@Release2015.3.0
Scenario: When the Auto Approve option is "Off" and autocoding Single path MedDRA Direct Dictionary Matches; upon creation of the synonyms, they shall be available to download and the count shall change

 	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
    And coding task "HEADACHE" for dictionary level "LLT"
	Then the number of synonyms for list "MedDRA ENG 16.0 MedDRA_DDM" is "1"
	And the synonym list "MedDRA ENG 16.0 MedDRA_DDM" can be downloaded

@VAL
@PBMCC_197253_005
@Release2015.3.0
Scenario: When the Auto Approve option is "Off" and autocoding Single path WhoDrug Direct Dictionary Matches; upon creation of the synonyms, they shall be available to download and the count shall change

 	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
    And coding task "PAIN FREE" for dictionary level "PRODUCT"
	And coding task "METHANOL" for dictionary level "PRODUCT"
	Then the number of synonyms for list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" is "2"
	And the synonym list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" can be downloaded

@VAL
@PBMCC_197253_006
@Release2015.3.0
Scenario: When the Auto Approve option is "Off" and autocoding Single path JDrug Direct Dictionary Matches; upon creation of the synonyms, they shall be available to download and the count shall change
 
 	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| JDrug_DDM                  | JDrug                       | 2013H1                    | JPN    |
    And coding task "イマジニール３００" for dictionary level "DrugName"
	Then the number of synonyms for list "J-Drug JPN 2013H1 JDrug_DDM" is "1"
	And the synonym list "J-Drug JPN 2013H1 JDrug_DDM" can be downloaded

@VAL
@PBMCC_197253_007
@Release2015.3.0
Scenario: When the Auto Approve option is "On" and autocoding Multiple path MedDRA Direct Dictionary Matches; upon creation of the synonyms, they shall not be available to download and the count shall not change
 
  	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
    And coding task "BROKEN LEG" for dictionary level "LLT"
    And coding task "SWELLING ARM" for dictionary level "LLT"
    And coding task "PROFOUND VISION IMPAIRMENT, BOTH EYES" for dictionary level "LLT"
	Then the number of synonyms for list "MedDRA ENG 16.0 MedDRA_DDM" is "0"
	And the synonym list "MedDRA ENG 16.0 MedDRA_DDM" cannot be downloaded
    And synonyms for verbatim terms should be created and exist in lists
	| verbatim                              | dictionaryLocaleVersionSynonymListName | exists |
	| BROKEN LEG                            | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	| SWELLING ARM                          | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	| PROFOUND VISION IMPAIRMENT, BOTH EYES | MedDRA ENG 16.0 MedDRA_DDM             | false  |
 
@VAL
@PBMCC_197253_008
@Release2015.3.0
@IncreaseTimeout_360000
Scenario: When the Auto Approve option is "On" and manual coding Multiple path WhoDrug Direct Dictionary Matches; upon creation of the synonyms, they shall be available to download and the count shall change
 
 	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
    And coding task "PAIN" for dictionary level "PRODUCT"
    And coding task "ADVIL COLD AND SINUS PLUS" for dictionary level "PRODUCT"
    And coding task "KANA" for dictionary level "PRODUCT"
    And coding task "STRONG PAIN" for dictionary level "PRODUCT"
    When task "PAIN" is coded to term "PAIN" at search level "Trade Name" with code "000277 04 191" at level "TN" and a synonym is created
    And task "ADVIL COLD AND SINUS PLUS" is coded to term "ADVIL COLD AND SINUS PLUS" at search level "Trade Name" with code "017171 01 003" at level "TN" and a synonym is created
    And task "KANA" is coded to term "KANA" at search level "Trade Name" with code "003910 02 227" at level "TN" and a synonym is created
    And task "STRONG PAIN" is coded to term "STRONG PAIN" at search level "Trade Name" with code "001164 01 143" at level "TN" and a synonym is created
	Then the number of synonyms for list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" is "4"
	And the synonym list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" can be downloaded

@VAL
@PBMCC_197253_009
@Release2015.3.0
Scenario: When the Auto Approve option is "Off" and autocoding Multiple path MedDRA Direct Dictionary Matches; upon creation of the synonyms, they shall be available to download and the count shall change
 
 	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
    And coding task "BROKEN LEG" for dictionary level "LLT"
    And coding task "SWELLING ARM" for dictionary level "LLT"
    And coding task "PROFOUND VISION IMPAIRMENT, BOTH EYES" for dictionary level "LLT"
	Then the number of synonyms for list "MedDRA ENG 16.0 MedDRA_DDM" is "3"
	And the synonym list "MedDRA ENG 16.0 MedDRA_DDM" can be downloaded

@VAL
@PBMCC_197253_010
@Release2015.3.0
Scenario: When the Auto Approve option is "Off" and manual coding Multiple path WhoDrug Direct Dictionary Matches; upon creation of the synonyms, they shall be available to download and the count shall change

 	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
    And coding task "PAIN" for dictionary level "PRODUCT"
    And coding task "ADVIL COLD AND SINUS PLUS" for dictionary level "PRODUCT"
    And coding task "KANA" for dictionary level "PRODUCT"
    And coding task "STRONG PAIN" for dictionary level "PRODUCT"
    When task "PAIN" is coded to term "PAIN" at search level "Trade Name" with code "000277 04 191" at level "TN" and a synonym is created
    And task "ADVIL COLD AND SINUS PLUS" is coded to term "ADVIL COLD AND SINUS PLUS" at search level "Trade Name" with code "017171 01 003" at level "TN" and a synonym is created
    And task "KANA" is coded to term "KANA" at search level "Trade Name" with code "003910 02 227" at level "TN" and a synonym is created
    And task "STRONG PAIN" is coded to term "STRONG PAIN" at search level "Trade Name" with code "001164 01 143" at level "TN" and a synonym is created
	Then the number of synonyms for list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" is "4"
	And the synonym list "WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM" can be downloaded


	
@VAL
@PBMCC_197253_011
@Release2015.3.0
@IncreaseTimeout_300000 
Scenario: When the Auto Approve option is "On" and autocoding Single path MedDRA Direct Dictionary Matches; upon creation of the synonyms, they shall not be be displayed in the Synonym Details page
 	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
    And coding task "HEADACHE" for dictionary level "LLT"
    And coding task "FAKE TERM" for dictionary level "LLT"
    When task "FAKE TERM" is coded to term "Short-term memory loss" at search level "Low Level Term" with code "10040602" at level "LLT" and a synonym is created
	Then The task count is "0"
    And synonyms for verbatim terms should be created and exist in lists
	| verbatim  | dictionaryLocaleVersionSynonymListName | exists |
	| HEADACHE  | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	| FAKE TERM | MedDRA ENG 16.0 MedDRA_DDM             | true   |

@VAL
@PBMCC_197253_012
@Release2015.3.0
@IncreaseTimeout_300000 
Scenario: When the Auto Approve option is "On" and autocoding Single path WhoDrug Direct Dictionary Matches; upon creation of the synonyms, they shall not be be displayed in the Synonym Details page
 
 	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
    And coding task "PAIN FREE" for dictionary level "PRODUCT"
    And coding task "METHANOL" for dictionary level "PRODUCT"
    And coding task "FAKE TERM" for dictionary level "PRODUCT"
    When task "FAKE TERM" is coded to term "PLACEBO" at search level "Preferred Name" with code "900468 01 001" at level "PN" and a synonym is created
	Then The task count is "0"
    And synonyms for verbatim terms should be created and exist in lists
	| verbatim  | dictionaryLocaleVersionSynonymListName   | exists |
	| PAIN FREE | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | false  |
	| METHANOL  | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | false  |
	| FAKE TERM | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | true   |

@VAL
@PBMCC_197253_013
@Release2015.3.0
Scenario: When the Auto Approve option is "On" and autocoding Single path JDrug Direct Dictionary Matches; upon creation of the synonyms, they shall not be be displayed in the Synonym Details page

 	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| JDrug_DDM                  | JDrug                       | 2013H1                    | JPN    |
    And coding task "イマジニール３００" for dictionary level "DrugName"
    And coding task "FAKE TERM" for dictionary level "DrugName"
    When task "FAKE TERM" is coded to term "イマジニール３５０" at search level "DrugName" with code "721941902" at level "薬" and a synonym is created
	Then The task count is "0"
    And synonyms for verbatim terms should be created and exist in lists
	| verbatim          | dictionaryLocaleVersionSynonymListName | exists |
	| イマジニール３００ | J-Drug JPN 2013H1 JDrug_DDM            | false  |
	| FAKE TERM         | J-Drug JPN 2013H1 JDrug_DDM            | true   |

@VAL
@PBMCC_197253_014
@Release2015.3.0
Scenario: When the Auto Approve option is "Off" and autocoding Single path MedDRA Direct Dictionary Matches; upon creation of the synonyms, they shall be be displayed in the Synonym Details page

 	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
    And coding task "HEADACHE" for dictionary level "LLT"
    Then a synonym for verbatim term "HEADACHE" should be created and exist in list "MedDRA ENG 16.0 MedDRA_DDM"

@VAL
@PBMCC_197253_015
@Release2015.3.0
Scenario: When the Auto Approve option is "Off" and autocoding Single path WhoDrug Direct Dictionary Matches; upon creation of the synonyms, they shall be be displayed in the Synonym Details page

 	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
    And coding task "PAIN FREE" for dictionary level "PRODUCT"
	And coding task "METHANOL" for dictionary level "PRODUCT"
    Then synonyms for verbatim terms should be created and exist in lists
	| verbatim  | dictionaryLocaleVersionSynonymListName   | exists |
	| PAIN FREE | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | true   |
	| METHANOL  | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | true   |

@VAL
@PBMCC_197253_016
@Release2015.3.0
Scenario: When the Auto Approve option is "Off" and autocoding Single path JDrug Direct Dictionary Matches; upon creation of the synonyms, they shall be be displayed in the Synonym Details page
 
 	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| JDrug_DDM                  | JDrug                       | 2013H1                    | JPN    |
    And coding task "イマジニール３００" for dictionary level "DrugName"
    Then a synonym for verbatim term "イマジニール３００" should be created and exist in list "J-Drug JPN 2013H1 JDrug_DDM"

@VAL
@PBMCC_197253_017
@Release2015.3.0
@IncreaseTimeout_300000 
Scenario: When the Auto Approve option is "On" and autocoding Multiple path MedDRA Direct Dictionary Matches; upon creation of the synonyms, they shall not be be displayed in the Synonym Details page
 
  	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
    And coding task "BROKEN LEG" for dictionary level "LLT"
    And coding task "SWELLING ARM" for dictionary level "LLT"
    And coding task "PROFOUND VISION IMPAIRMENT, BOTH EYES" for dictionary level "LLT"
    And coding task "FAKE TERM" for dictionary level "LLT"
    When task "FAKE TERM" is coded to term "Short-term memory loss" at search level "Low Level Term" with code "10040602" at level "LLT" and a synonym is created
	Then The task count is "0"
    And synonyms for verbatim terms should be created and exist in lists
	| verbatim                              | dictionaryLocaleVersionSynonymListName | exists |
	| BROKEN LEG                            | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	| SWELLING ARM                          | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	| PROFOUND VISION IMPAIRMENT, BOTH EYES | MedDRA ENG 16.0 MedDRA_DDM             | false  |
	| FAKE TERM                             | MedDRA ENG 16.0 MedDRA_DDM             | true   |
 
@VAL
@PBMCC_197253_018
@Release2015.3.0
@IncreaseTimeout_300000 
Scenario: When the Auto Approve option is "On" and manual coding Multiple path WhoDrug Direct Dictionary Matches; upon creation of the synonyms, they shall be be displayed in the Synonym Details page
 
 	Given a "Completed Reconsider" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
    And coding task "PAIN" for dictionary level "PRODUCT"
    And coding task "ADVIL COLD AND SINUS PLUS" for dictionary level "PRODUCT"
    And coding task "KANA" for dictionary level "PRODUCT"
    And coding task "STRONG PAIN" for dictionary level "PRODUCT"
    When task "PAIN" is coded to term "PAIN" at search level "Trade Name" with code "000277 04 191" at level "TN" and a synonym is created
    And task "ADVIL COLD AND SINUS PLUS" is coded to term "ADVIL COLD AND SINUS PLUS" at search level "Trade Name" with code "017171 01 003" at level "TN" and a synonym is created
    And task "KANA" is coded to term "KANA" at search level "Trade Name" with code "003910 02 227" at level "TN" and a synonym is created
    And task "STRONG PAIN" is coded to term "STRONG PAIN" at search level "Trade Name" with code "001164 01 143" at level "TN" and a synonym is created
    Then synonyms for verbatim terms should be created and exist in lists
	| verbatim                  | dictionaryLocaleVersionSynonymListName   | exists |
	| PAIN                      | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | true   |
	| ADVIL COLD AND SINUS PLUS | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | true   |
	| KANA                      | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | true   |
	| STRONG PAIN               | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | true   |

@VAL
@PBMCC_197253_019
@Release2015.3.0
Scenario: When the Auto Approve option is "Off" and autocoding Multiple path MedDRA Direct Dictionary Matches; upon creation of the synonyms, they shall be be displayed in the Synonym Details page
 
 	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| MedDRA_DDM                 | MedDRA                      | 16.0                      | ENG    |
    And coding task "BROKEN LEG" for dictionary level "LLT"
    And coding task "SWELLING ARM" for dictionary level "LLT"
    And coding task "PROFOUND VISION IMPAIRMENT, BOTH EYES" for dictionary level "LLT"
    Then synonyms for verbatim terms should be created and exist in lists
	| verbatim                              | dictionaryLocaleVersionSynonymListName | exists |
	| BROKEN LEG                            | MedDRA ENG 16.0 MedDRA_DDM             | true   |
	| SWELLING ARM                          | MedDRA ENG 16.0 MedDRA_DDM             | true   |
	| PROFOUND VISION IMPAIRMENT, BOTH EYES | MedDRA ENG 16.0 MedDRA_DDM             | true   |

@VAL
@PBMCC_197253_020
@Release2015.3.0
@IncreaseTimeout_300000 
Scenario: When the Auto Approve option is "Off" and manual coding Multiple path WhoDrug Direct Dictionary Matches; upon creation of the synonyms, they shall be be displayed in the Synonym Details page

 	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
	| SynonymListName            | Dictionary                  | Version                   | Locale |
	| WhoDrugDDEB2_DDM           | WhoDrugDDEB2                | 201306                    | ENG    |
    And coding task "PAIN" for dictionary level "PRODUCT"
    And coding task "ADVIL COLD AND SINUS PLUS" for dictionary level "PRODUCT"
    And coding task "KANA" for dictionary level "PRODUCT"
    And coding task "STRONG PAIN" for dictionary level "PRODUCT"
    When task "PAIN" is coded to term "PAIN" at search level "Trade Name" with code "000277 04 191" at level "TN" and a synonym is created
    And task "ADVIL COLD AND SINUS PLUS" is coded to term "ADVIL COLD AND SINUS PLUS" at search level "Trade Name" with code "017171 01 003" at level "TN" and a synonym is created
    And task "KANA" is coded to term "KANA" at search level "Trade Name" with code "003910 02 227" at level "TN" and a synonym is created
    And task "STRONG PAIN" is coded to term "STRONG PAIN" at search level "Trade Name" with code "001164 01 143" at level "TN" and a synonym is created
    Then synonyms for verbatim terms should be created and exist in lists
	| verbatim                  | dictionaryLocaleVersionSynonymListName   | exists |
	| PAIN                      | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | true   |
	| ADVIL COLD AND SINUS PLUS | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | true   |
	| KANA                      | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | true   |
	| STRONG PAIN               | WhoDrugDDEB2 ENG 201306 WhoDrugDDEB2_DDM | true   |
