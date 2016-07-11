@ETE_ENG_CoderConfigQuerySettings.feature

@EndToEndDynamicSegment
Feature: When selecting a requires response option for Coder configuration, when a Coder query is open they will respect the configuration settings. Remove requires manual close and option for Coder configuration

@DFT
@MCC_207751_005
@Release2016.1.0
Scenario: Verify the requires manual close option is not available on Coder Configuration Settings page and when the requires response option is checked  in Coder Configuration, Coder Configuration will be respected when a Coder query is opened.

Given a Rave project registration with dictionary "WhoDrug-DDE-B2 ENG 200703"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form | Field        | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms                                       |
| ETE2 | Coding Field | <Dictionary> |        | PRODUCTSYNONYM | 1        | true               | true           | LOGSUPPFIELD2,LOGSUPPFIELD4,LOGCOMPFIELD1,LOGCOMPFIELD3 |
When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
And global Rave-Coder Configuration settings with Review Marking Group are set to "Site from system" and Requires Response are set to "true"
When adding a new subject "TST"
And adding a new verbatim term to form "ETE2"
| Field                    | Value                    | ControlType |
| Coding Field             | child advil cold extreme | LongText    |
| Log Supplemental Field A | 33                       |             |
| Std Supplemental Field A | New Jersey               |             |
| Log Supplemental Field B | United States            |             |
| Std Supplemental Field B | Lost in Translation      |             |
And adding a new verbatim term to form "ETE2"
| Field                    | Value                            | ControlType |
| Coding Field             | extremely cold children medicine | LongText    |
| Log Supplemental Field A | 22                               |             |
| Log Supplemental Field B | New York                         |             |
And Coder App Segment is loaded
And task "child advil cold extreme" is coded to term "CHILDRENS ADVIL COLD" at search level "Trade Name" with code "010502 01 015" at level "TN" and a synonym is created
And reclassifying task "child advil cold extreme" with Include Autocoded Items set to "True"
And rejecting coding decision for the task "child advil cold extreme"
And I open a query for task "child advil cold extreme" with comment "Open query due to bad term"
And task "extremely cold children medicine" is coded to term "CHILDRENS ADVIL COLD" at search level "Trade Name" with code "010502 01 015" at level "TN" and a synonym is created
And Rave Modules App Segment is loaded
Then the coder query "Open query due to bad term" is available to the Rave form "ETE2" field "Coding Field" with verbatim term "child advil cold extreme"
Then the coding decision for verbatim "extremely cold children medicine" on form "ETE2" for field "Coding Field" contains the following data
 | Level          | Code          | Term Path                                         |
 | ATC            | M             | MUSCULO-SKELETAL SYSTEM                           |
 | ATC            | M01           | ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS       |
 | ATC            | M01A          | ANTIINFLAMMATORY/ANTIRHEUMATIC PROD.,NON-STEROIDS |
 | ATC            | M01AE         | PROPIONIC ACID DERIVATIVES                        |
 | PRODUCT        | 010502 01 001 | CO-ADVIL                                          |
 | PRODUCTSYNONYM | 010502 01 015 | CHILDRENS ADVIL COLD                              |
#Then when I view task "Sharp pain down leg" on form "ETE2" for "Subject" I should see the following data
#|data                       |
#|ATC                                                |
#|M                                                  |
#|MUSCULO-SKELETAL SYSTEM                            |
#|M02                                                |
#|TOPICAL PRODUCTS FOR JOINT AND MUSCULAR PAIN       |
#|M02A                                               |
#|M02AA                                              |
#|ANTIINFL. PREP., NON-STEROIDS FOR TOPICAL USE      |
#|PRODUCT                                            |
#|001092 01 001 4                                    |
#|IBUPROFEN                                          |
#|PRODUCTSYNONYM                                     |
#|001092 01 110 3                                    |
#|ACHES-N-PAIN                                       |


@DFT
@MCC-207751-006
@Release2016.1.0
Scenario: Verify when the requires response option is unchecked in Coder Configuration, Coder Configuration will be respected when a Coder query is opened.
Given a Rave project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form        | Field          | Dictionary   | Locale | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms													  |
| ETE2        | Coding Field   | <Dictionary> |        | LLT            | 1        | true               | true           | LOGSUPPFIELD2,LOGSUPPFIELD4,LOGCOMPFIELD1,COMPANY,LOGCOMPFIELD3,SOURCE |
When a Rave Draft is published and pushed using draft "<DraftName>" for Project "<StudyName>" to environment "Prod"
And edit global Rave-Coder Configuration settings with Review Marking Group set to "Site from system" and Requires Response set to "false"
When adding a new subject "TST"
And adding a new verbatim term to form "ETE2"
| Field                    | Value               | ControlType |
| Coding Field             | Sharp pain down leg | LongText    |
| Log Supplemental Field A | 33                  |             |
| Std Supplemental Field B | New Jersey          |             |
| Log Supplemental Field A | United States       |             |
| Log Supplemental Field A | Lost in Translation |             |
And adding a new verbatim term to form "ETE2"
| Field                    | Value                  | ControlType |
| Coding Field             | Sharp pain down nerves | LongText    |
| Log Supplemental Field A | 22                  |             |
| Std Supplemental Field B | New York          |             |
And Coder App Segment is loaded
And task "sharp pain down leg" is coded to term "ACHES-N-PAIN" at search level "Low Level Term" with code "??????????????" at level "LLT"
And reclassifying task "sharp pain down leg" with Include Autocoded Items set to "True"
And rejecting coding decision for the task "sharp pain down leg"
And I open a query for task "sharp pain down leg" with comment "Open query due to bad term"
And task "sharp pain in nerves" is coded to term "ACHES-N-PAIN" at search level "Low Level Term" with code "??????????????" at level "LLT"
And Rave Modules App Segment is loaded
Then the coder query "Open query due to bad term" is available to the Rave form "ETE1" field "Coding Field" with verbatim term "Adverse Event 1"
Then the coding decision for verbatim "Headachery" on form "ETE2" for field "Coding Field" contains the following data
| Level | Code     | Term Path                    |
| SOC   | 10007541 | Cardiac disorders            |
| HLGT  | 10007521 | Cardiac arrhythmias          |
| HLT   | 10042600 | Supraventricular arrhythmias |
| PT    | 10003658 | Atrial fibrillation          |
| LLT   | 10003658 | Atrial fibrillation          |
Then when I view task "Sharp pain down leg" on form "ETE2" for "Subject" I should see the following data
|data                       |
|ATC                                                |
|M                                                  |
|MUSCULO-SKELETAL SYSTEM                            |
|M02                                                |
|TOPICAL PRODUCTS FOR JOINT AND MUSCULAR PAIN       |
|M02A                                               |
|M02AA                                              |
|ANTIINFL. PREP., NON-STEROIDS FOR TOPICAL USE      |
|PRODUCT                                            |
|001092 01 001 4                                    |
|IBUPROFEN                                          |
|PRODUCTSYNONYM                                     |
|001092 01 110 3                                    |
|ACHES-N-PAIN                                       |