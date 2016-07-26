Feature: When supplemental and terms are edited and updated, the verbatim term with updated information is sent back to Coder.

@DFT
@ETE_ENG_Update_sup
@PB8.8.8-001
@Release2016.1.0

Scenario: Verify a standard supplemental field is edited and updated, the standard field verbatim with updated supplemental information is resent to Coder

Given Coder App Segment is loaded
And a project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form  | Field          | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
| ETE13 | ETE131         | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
And the following supplementals fields for following forms
| Form  | Field         | Supplemental  |
| ETE13 | CodingField13 | SUPP          |
| ETE13 | CodingField13 | SUPP2         |
And I edit the following forrm designer fields
| Form                     | Row       | checked    |
| Log data entry Checkbox  | Supp      | False      |
| Log data entry Checkbox  | Supp2     | False      |
| Log data entry Checkbox  | coded2    | False      |
| Log data entry Checkbox  | coded     | False      |
And I set value "SUPP" located in "Coder Config Supplemental Terms Dropdown"
And I select Button "Coder Config Supplemental Add Linked Field Button"
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
And adding a new subject "TEST"
And adding a new verbatim term to form "ETE13"
| Field  	    | Value              | ControlType | Control Value |
| ETE13 	    | Head Pain          |             |               |
| SUPP          | supp1              | text        | Other         |
And I navigate to Coder
And in Coder I should see the following information for the source terms tab for term "Head Pain"
|Value				        |Column				  |Table				    |
|supp1               		|Supplemental Value   |Supplements Table		|
When I browse and code Term "head pain" located in "Coder Main Table" entering value "BAYER CHILDREN'S COLD" and selecting "BAYER CHILDREN'S COLD" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
And I navigate to Rave
And when I view form "ETE13" for "TEST" I should see the following data
|data                       |
|BAYER CHILDREN'S COLD      |
|005581 01 001 3            |
And Edit verbatim term to form "ETE13"
| Field  	    | Value              | ControlType | Control Value |
| SUPP2         | supp2              | text        | Other         |
And I navigate to Coder
And in Coder I should see the following information for the source terms tab for term "Head Pain"
|Value				        |Column				  |Table				    |
|supp2               		|Supplemental Value   |Supplements Table		|
When I browse and code Term "head pain" located in "Coder Main Table" entering value "ASPIRIN W/OXYCODONE" and selecting "ASPIRIN W/OXYCODONE" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
And I navigate to Rave
And when I view form "ETE13" for "TEST" I should see the following data
|data                       |
|ASPIRIN W/OXYCODONE        |
|009533 01 001 4            |


@DFT
@ETE_ENG_Update_sup
@PB8.8.8-002
@Release2016.1.0

Scenario: When a standard supplemental field is edited and updated, the log field verbatim with updated supplemental information is resent to Coder

Given Coder App Segment is loaded
And a project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form  | Field          | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
| ETE13 | ETE131         | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
And the following supplementals fields for following forms
| Form  | Field         | Supplemental  |
| ETE13 | CodingField13 | SUPP          |
| ETE13 | CodingField13 | SUPP2         |
And I edit the following forrm designer fields
| Form                     | Row       | checked    |
| Log data entry Checkbox  | Supp      | False      |
| Log data entry Checkbox  | Supp2     | False      |
| Log data entry Checkbox  | coded2    | False      |
| Log data entry Checkbox  | coded     | True       |
And I set value "SUPP" located in "Coder Config Supplemental Terms Dropdown"
And I select Button "Coder Config Supplemental Add Linked Field Button"
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
And adding a new subject "TEST"
And adding a new verbatim term to form "ETE13"
| Field  	    | Value              | ControlType | Control Value |
| ETE13 	    | Head Pain          |             |               |
| SUPP          | supp1              | text        | Other         |
And I navigate to Coder
And in Coder I should see the following information for the source terms tab for term "Head Pain"
|Value				        |Column				  |Table				    |
|supp1               		|Supplemental Value   |Supplements Table		|
When I browse and code Term "head pain" located in "Coder Main Table" entering value "BAYER CHILDREN'S COLD" and selecting "BAYER CHILDREN'S COLD" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
And I navigate to Rave
And when I view form "ETE13" for "TEST" I should see the following data
|data                       |
|BAYER CHILDREN'S COLD      |
|005581 01 001 3            |
And Edit verbatim term to form "ETE13"
| Field  	    | Value              | ControlType | Control Value |
| SUPP2         | supp2              | text        | Other         |
And I navigate to Coder
And in Coder I should see the following information for the source terms tab for term "Head Pain"
|Value				        |Column				  |Table				    |
|supp2               		|Supplemental Value   |Supplements Table		|
When I browse and code Term "head pain" located in "Coder Main Table" entering value "ASPIRIN W/OXYCODONE" and selecting "ASPIRIN W/OXYCODONE" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
And I navigate to Rave
And when I view form "ETE13" for "TEST" I should see the following data
|data                       |
|ASPIRIN W/OXYCODONE        |
|009533 01 001 4            |


@DFT
@ETE_ENG_Update_sup
@PB8.8.8-003
@Release2016.1.0

Scenario: When a standard supplemental field is linked to a standard coding fields and a log coding field and the standard supplemental field is edited and updated, both standard field verbatim and log field verbatim with updated supplemental information are resent to Coder

Given Coder App Segment is loaded
And a project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form  | Field          | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
| ETE13 | ETE131         | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
And the following supplementals fields for following forms
| Form  | Field         | Supplemental  |
| ETE13 | CodingField13 | SUPP          |
| ETE13 | CodingField13 | SUPP2         |
And I edit the following forrm designer fields
| Form                     | Row       | checked    |
| Log data entry Checkbox  | Supp      | False      |
| Log data entry Checkbox  | Supp2     | False      |
| Log data entry Checkbox  | coded2    | True       |
| Log data entry Checkbox  | coded     | True       |
And I set value "SUPP" located in "Coder Config Supplemental Terms Dropdown"
And I select Button "Coder Config Supplemental Add Linked Field Button"
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
And adding a new subject "TEST"
And adding a new verbatim term to form "ETE13"
| Field  	    | Value              | ControlType | Control Value |
| ETE13 	    | Head Pain          |             |               |
| SUP1          | Concussion         | text        | Other         |
| SUPP2         | Supp1              | text        | Other         |
And I navigate to Coder
And in Coder I should see the following information for the source terms tab for term "Head Pain"
|Value				        |Column				  |Table				    |
|supp1               		|Supplemental Value   |Supplements Table		|
And in Coder I should see the following information for the source terms tab for term "Concussion"
|Value				        |Column				  |Table				    |
|supp1               		|Supplemental Value   |Supplements Table		|
When I browse and code Term "head pain" located in "Coder Main Table" entering value "BAYER CHILDREN'S COLD" and selecting "BAYER CHILDREN'S COLD" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
When I browse and code Term "Concussion" located in "Coder Main Table" entering value "BRAIN AND MEMORY" and selecting "BRAIN AND MEMORY" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
And I navigate to Rave
And when I view form "ETE13" for "TEST" I should see the following data
|data                       |
|BAYER CHILDREN'S COLD      |
|005581 01 001 3            |
|BRAIN AND MEMORY           |
|020502 01 001 8            |
And Edit verbatim term to form "ETE13"
| Field  	    | Value              | ControlType | Control Value |
| SUPP2         | supp2              | text        | Other         |
And I navigate to Coder
And in Coder I should see the following information for the source terms tab for term "Head Pain"
|Value				        |Column				  |Table				    |
|supp2               		|Supplemental Value   |Supplements Table		|
And in Coder I should see the following information for the source terms tab for term "Concussion"
|Value				        |Column				  |Table				    |
|supp2               		|Supplemental Value   |Supplements Table		|
When I browse and code Term "head pain" located in "Coder Main Table" entering value "ASPIRIN W/OXYCODONE" and selecting "ASPIRIN W/OXYCODONE" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
When I browse and code Term "Concussion" located in "Coder Main Table" entering value "SWINE BRAIN HYDROLYSATE" and selecting "SWINE BRAIN HYDROLYSATE" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
And I navigate to Rave
And when I view form "ETE13" for "TEST" I should see the following data
|data                       |
|value                                              |
|ASPIRIN W/OXYCODONE                                |
|009533 01 001 4                                    |
|SWINE BRAIN HYDROLYSATE                            |
|015423 01 001 4                                    |


@DFT
@ETE_ENG_Update_sup
@PB8.8.8-004
@Release2016.1.0

Scenario: When a standard supplemental field is linked to two log coding fields and the standard supplemental field is edited and updated, both log field verbatim with updated supplemental information are resent to Coder

Given Coder App Segment is loaded
And a project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form  | Field          | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
| ETE13 | ETE131         | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
And the following supplementals fields for following forms
| Form  | Field         | Supplemental  |
| ETE13 | CodingField13 | SUPP          |
| ETE13 | CodingField13 | SUPP2         |
| ETE13 | CodingField13 | coded2        |
And I edit the following forrm designer fields
| Form                     | Row       | checked    |
| Log data entry Checkbox  | Supp      | False      |
| Log data entry Checkbox  | Supp2     | False      |
| Log data entry Checkbox  | coded2    | False      |
| Log data entry Checkbox  | coded     | False      |
And I set value "SUPP" located in "Coder Config Supplemental Terms Dropdown"
And I select Button "Coder Config Supplemental Add Linked Field Button"
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
And adding a new subject "TEST"
And adding a new verbatim term to form "ETE13"
| Field  	    | Value              | ControlType | Control Value |
| ETE13 	    | Head Pain          |             |               |
| SUP1          | Concussion         | text        | Other         |
| SUPP2         | Supp1              | text        | Other         |
And I navigate to Coder
And in Coder I should see the following information for the source terms tab for term "Head Pain"
|Value				        |Column				  |Table				    |
|supp1               		|Supplemental Value   |Supplements Table		|
And in Coder I should see the following information for the source terms tab for term "Concussion"
|Value				        |Column				  |Table				    |
|supp1               		|Supplemental Value   |Supplements Table		|
When I browse and code Term "head pain" located in "Coder Main Table" entering value "BAYER CHILDREN'S COLD" and selecting "BAYER CHILDREN'S COLD" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
When I browse and code Term "Concussion" located in "Coder Main Table" entering value "BRAIN AND MEMORY" and selecting "BRAIN AND MEMORY" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
And I navigate to Rave
And when I view form "ETE13" for "TEST" I should see the following data
|data                       |
|BAYER CHILDREN'S COLD      |
|005581 01 001 3            |
|BRAIN AND MEMORY           |
|020502 01 001 8            |
And Edit verbatim term to form "ETE13"
| Field  	    | Value              | ControlType | Control Value |
| SUPP2         | supp2              | text        | Other         |
And I navigate to Coder
And in Coder I should see the following information for the source terms tab for term "Head Pain"
|Value				        |Column				  |Table				    |
|supp2               		|Supplemental Value   |Supplements Table		|
And in Coder I should see the following information for the source terms tab for term "Concussion"
|Value				        |Column				  |Table				    |
|supp2               		|Supplemental Value   |Supplements Table		|
When I browse and code Term "head pain" located in "Coder Main Table" entering value "ASPIRIN W/OXYCODONE" and selecting "ASPIRIN W/OXYCODONE" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
When I browse and code Term "Concussion" located in "Coder Main Table" entering value "SWINE BRAIN HYDROLYSATE" and selecting "SWINE BRAIN HYDROLYSATE" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
And I navigate to Rave
And when I view form "ETE13" for "TEST" I should see the following data
|data                       |
|value                                              |
|ASPIRIN W/OXYCODONE                                |
|009533 01 001 4                                    |
|SWINE BRAIN HYDROLYSATE                            |
|015423 01 001 4                                    |


@DFT
@ETE_ENG_Update_sup
@PB8.8.8-005
@Release2016.1.0

Scenario: When two standard supplemental fields are linked to a standard coding field and both standard supplemental fields are edited and updated, only one standard field verbatim with updated supplemental information is resent to Coder
Given Coder App Segment is loaded
And a project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form  | Field          | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
| ETE13 | ETE131         | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
And the following supplementals fields for following forms
| Form  | Field         | Supplemental  |
| ETE13 | CodingField13 | SUPP          |
| ETE13 | CodingField13 | SUPP2         |
And I edit the following forrm designer fields
| Form                     | Row       | checked    |
| Log data entry Checkbox  | Supp      | False      |
| Log data entry Checkbox  | Supp2     | False      |
| Log data entry Checkbox  | coded2    | False      |
| Log data entry Checkbox  | coded     | False      |
And I set value "SUPP" located in "Coder Config Supplemental Terms Dropdown"
And I select Button "Coder Config Supplemental Add Linked Field Button"
And I set value "SUPP2" located in "Coder Config Supplemental Terms Dropdown"
And I select Button "Coder Config Supplemental Add Linked Field Button"
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
And adding a new subject "TEST"
And adding a new verbatim term to form "ETE13"
| Field  	    | Value              | ControlType | Control Value |
| ETE13 	    | Head Pain          |             |               |
| SUPP1         | Supp1              | text        | Other         |
| SUPP2         | Supp2              | text        | Other         |
And I navigate to Coder
And in Coder I should see the following information for the source terms tab for term "Head Pain"
|Value				        |Column				  |Table				    |
|supp1               		|Supplemental Value   |Supplements Table		|
|supp2               		|Supplemental Value   |Supplements Table		|
When I browse and code Term "head pain" located in "Coder Main Table" entering value "BAYER CHILDREN'S COLD" and selecting "BAYER CHILDREN'S COLD" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
And I navigate to Rave
And when I view form "ETE13" for "TEST" I should see the following data
|data                       |
|BAYER CHILDREN'S COLD      |
|005581 01 001 3            |
And Edit verbatim term to form "ETE13"
| Field  	    | Value              | ControlType | Control Value |
| SUPP1         | supp3              | text        | Other         |
| SUPP2         | supp4              | text        | Other         |
And I navigate to Coder
And in Coder I should see the following information for the source terms tab for term "Head Pain"
|Value				        |Column				  |Table				    |
|supp3               		|Supplemental Value   |Supplements Table		|
|supp4               		|Supplemental Value   |Supplements Table		|
When I browse and code Term "head pain" located in "Coder Main Table" entering value "ASPIRIN W/OXYCODONE" and selecting "ASPIRIN W/OXYCODONE" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
And I navigate to Rave
And when I view form "ETE13" for "TEST" I should see the following data
|data                       |
|value                                              |
|ASPIRIN W/OXYCODONE                                |
|009533 01 001 4                                    |


@DFT
@ETE_ENG_Update_sup
@PB8.8.8-006
@Release2016.1.0

Scenario: When two standard supplemental fields are linked to a log coding field and both standard supplemental fields are edited and updated, only one log field verbatim with updated supplemental information is resent to Coder

Given Coder App Segment is loaded
And a project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded
And a Rave Coder setup with the following options
| Form  | Field          | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
| ETE13 | ETE131         | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
And the following supplementals fields for following forms
| Form  | Field         | Supplemental  |
| ETE13 | CodingField13 | SUPP          |
| ETE13 | CodingField13 | SUPP2         |
And I edit the following forrm designer fields
| Form                     | Row       | checked    |
| Log data entry Checkbox  | Supp      | False      |
| Log data entry Checkbox  | Supp2     | False      |
| Log data entry Checkbox  | coded2    | False      |
| Log data entry Checkbox  | coded     | False      |
And I set value "SUPP" located in "Coder Config Supplemental Terms Dropdown"
And I select Button "Coder Config Supplemental Add Linked Field Button"
And I set value "SUPP2" located in "Coder Config Supplemental Terms Dropdown"
And I select Button "Coder Config Supplemental Add Linked Field Button"
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
And adding a new subject "TEST"
And adding a new verbatim term to form "ETE13"
| Field  	    | Value              | ControlType | Control Value |
| ETE13 	    | Head Pain          |             |               |
| SUPP1         | Supp1              | text        | Other         |
| SUPP2         | Supp2              | text        | Other         |
And I navigate to Coder
And in Coder I should see the following information for the source terms tab for term "Head Pain"
|Value				        |Column				  |Table				    |
|supp1               		|Supplemental Value   |Supplements Table		|
|supp2               		|Supplemental Value   |Supplements Table		|
When I browse and code Term "head pain" located in "Coder Main Table" entering value "BAYER CHILDREN'S COLD" and selecting "BAYER CHILDREN'S COLD" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
And I navigate to Rave
And when I view form "ETE13" for "TEST" I should see the following data
|data                       |
|BAYER CHILDREN'S COLD      |
|005581 01 001 3            |
And Edit verbatim term to form "ETE13"
| Field  	    | Value              | ControlType | Control Value |
| SUPP1         | supp3              | text        | Other         |
| SUPP2         | supp4              | text        | Other         |
And I navigate to Coder
And in Coder I should see the following information for the source terms tab for term "Head Pain"
|Value				        |Column				  |Table				    |
|supp3               		|Supplemental Value   |Supplements Table		|
|supp4               		|Supplemental Value   |Supplements Table		|
When I browse and code Term "head pain" located in "Coder Main Table" entering value "ASPIRIN W/OXYCODONE" and selecting "ASPIRIN W/OXYCODONE" located in "Dictionary Tree Table" on row "5" and uncheck "Create Synonym"
And I navigate to Rave
And when I view form "ETE13" for "TEST" I should see the following data
|data                       |
|value                                              |
|ASPIRIN W/OXYCODONE                                |
|009533 01 001 4                                    |