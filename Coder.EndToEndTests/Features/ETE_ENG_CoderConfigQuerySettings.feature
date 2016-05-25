Feature: When selecting a requires response option for Coder configuration, when a Coder query is open they will respect the configuration settings. Remove requires manual close and option for Coder configuration

@MCC-207751
@ETE_ENG_Query_workflow
Scenario: Verify the requires manual close option is not available on Coder Configuration Settings page and when the requires response option is checked  in Coder Configuration, Coder Configuration will be respected when a Coder query is opened.
And Coder App Segment is loaded
And a project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2  | ETE2            | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
And I add the following linked fields
    |LOGSUPPFIELD2 |	
    |LOGSUPPFIELD4 |
    |LOGCOMPFIELD1 |
    |COMPANY       |
    |LOGCOMPFIELD3 |
    |SOURCE        |  	
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And I edit the Coder Configuration settings 
|Field                                              | Value                         | status|
|Rave Configuration Coder Marking Group Dropdown    | site from system              | true  |
|Rave Configuration Coder Requires Response Checkbox| Requires Manual Close Checkbox| false |
And adding a new subject "TST"
Then I submit verbatim "sharp pain down leg" with the following supplementals for form "ETE2"
  |Supp               |
  |33                 |
  |New Jersey         |
  |United States      |
  |Lost in translation|
Then I submit verbatim "sharp pain down nerves" with the following supplementals for form "ETE2"
  |Supp               |
  |22                 |
  |New York           |
  |United States      | 
And I navigate to Coder 
And in "Study" I browse and code task "sharp pain down leg" entering value "ACHES-N-PAIN" and selecting "ACHES-N-PAIN" located in Dictionary Tree Table	
And I navigate to Relcassification 
And I reclassify task "ACHES-N-PAIN"
And I navigate to "tasks"
And I reject the Coding decision
Then I submit coder query "Open query due to bad term" for task "sharp pain down leg"  
Then I should see the query status "open" for task "sharp pain down leg query"       #will take a few mins
And in "Study" I browse and code task "sharp pain in nerves" entering value "ACHES-N-PAIN" and selecting "ACHES-N-PAIN" located in Dictionary Tree Table	
And I navigate to Rave
Then when I view task "Sharp pain down leg" on form "ETE2" for "Subject" I should see the following data
   |data                       |
   |Open query due to bad term |
And I close the Rave query   
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

   
@MCC-207751
@ETE_ENG_Query_workflow
Scenario: Verify when the requires response option is unchecked in Coder Configuration, Coder Configuration will be respected when a Coder query is opened. 
And Coder App Segment is loaded
And a project registration with dictionary "WHODRUGB2 200703 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2  | ETE2            | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
And I add the following linked fields
    |LOGSUPPFIELD2 |	
    |LOGSUPPFIELD4 |
    |LOGCOMPFIELD1 |
    |COMPANY       |
    |LOGCOMPFIELD3 |
    |SOURCE        |  	
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And I edit the Coder Configuration settings 
    |Field                                              | Value                         | status|
    |Rave Configuration Coder Marking Group Dropdown    | site from system              | true  |
    |Rave Configuration Coder Requires Response Checkbox| Requires Manual Close Checkbox| true  |
And adding a new subject "TST"
Then I submit verbatim "sharp pain down leg" with the following supplementals for form "ETE2"
    |Supp               |
    |33                 |
    |New Jersey         |
    |United States      |
    |Lost in translation|
Then I submit verbatim "sharp pain down nerves" with the following supplementals for form "ETE2"
    |Supp               |
    |22                 |
    |New York           |
    |United States      | 
And I navigate to Coder 
And in "Study" I browse and code task "sharp pain down leg" entering value "ACHES-N-PAIN" and selecting "ACHES-N-PAIN" located in Dictionary Tree Table	
And I navigate to Relcassification 
And I reclassify task "ACHES-N-PAIN"
And I navigate to "tasks"
And I reject the Coding decision
Then I submit coder query "Open query due to bad term" for task "sharp pain down leg"  
Then I should see the query status "open" for task "sharp pain down leg query"       #will take a few mins
And in "Study" I browse and code task "sharp pain in nerves" entering value "ACHES-N-PAIN" and selecting "ACHES-N-PAIN" located in Dictionary Tree Table	
And I navigate to Rave
Then when I view task "Sharp pain down leg" on form "ETE2" for "Subject" I should see the following data
   |data                       |
   |Open query due to bad term |
And I close the Rave query   
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
   
   
  