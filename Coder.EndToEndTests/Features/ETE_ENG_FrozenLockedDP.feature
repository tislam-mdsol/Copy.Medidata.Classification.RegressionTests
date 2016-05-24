Feature: EDC will still be able to receive coding decisions even when the field has been locked or frozen.

@MCC-207752
@ETE_ENG_Frozen_Lock
Scenario: A coding decision will still be processed even if the data point has been frozen
And Coder App Segment is loaded
And a project registration with dictionary "Medra 11 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2  | ETE2            | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TST"
Then I submit verbatim "terrible head pain" with the entry locked checkbox active
And I navigate to Coder  
When I browse and code Term "terrible head pain" located in "Coder Main Table" on row "1", entering value "Headache" and selecting "Headache" located in "Dictionary Tree Table"
And I navigate to Rave
When when I view form "ETE1" for "Subject" I should see the following data
   |data                      |
   |terrible head pain         |
   |SOC                        |
   |Nervous system disorders   |
   |10029205                   |
   |HLGT                       |
   |Headaches                  |
   |10019231                   |
   |HLT                        |
   |Headaches NEC              |
   |10019233                   |
   |PT                         |
   |Headache                   |
   |10019211                   |
   
@MCC-207752
@ETE_ENG_Frozen_Lock
Scenario: A coding decision will still be processed even if the data point has been locked
And Coder App Segment is loaded
And a project registration with dictionary "Medra 11 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE2  | ETE2            | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TST"
Then I submit verbatim "terrible head pain" with the hardlock checkbox active
And I navigate to Coder  
When I browse and code Term "terrible head pain" located in "Coder Main Table" on row "1", entering value "Headache" and selecting "Headache" located in "Dictionary Tree Table"
And I navigate to Rave
When when I view form "ETE1" for "Subject" I should see the following data
   |data                      |
   |terrible head pain         |
   |SOC                        |
   |Nervous system disorders   |
   |10029205                   |
   |HLGT                       |
   |Headaches                  |
   |10019231                   |
   |HLT                        |
   |Headaches NEC              |
   |10019233                   |
   |PT                         |
   |Headache                   |
   |10019211                   |
   
   
@MCC-207752
@ETE_ENG_Frozen_Lock
Scenario:  A coding decision will still be processed even if the forms have been locked
And Coder App Segment is loaded
And a project registration with dictionary "Medra 11 ENG"
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
And I select the form Hardlock checkbox  
And I navigate to Coder 
Then I submit coder query "Open query due to bad term" for task "sharp pain down leg"  
Then I should see the query status "open" for task "sharp pain down leg query"       #will take a few mins
When I browse and code Term "sharp pain in nerves" located in "Coder Main Table" entering value "BAYER CHILDREN'S COUGH" and selecting "BAYER CHILDREN'S COUGH" located in "Dictionary Tree Table"
And I navigate to Rave
Then when I view task "Sharp pain down nerves" on form "Subject" I should see the following data
    |data                      |
    |ATC                                                |
    |RESPIRATORY SYSTEM                                 |
    |R                                                  |
    |ATC                                                |
    |COUGH AND COLD PREPARATIONS                        |
    |R05                                                |
    |ATC                                                |
    |COUGH SUPPRESSANTS EXCL. COMB. WITH EXPECTORANTS   |
    |R05D                                               |
    |ATC                                                |
    |OPIUM ALKALOIDS AND DERIVATIVES                    |
    |R05DA                                              |
    |PRODUCT                                            |
    |BAYER CHILDREN'S COUGH                             |
    |007574 01 001 8                                    |
    
    
@MCC-207752
@ETE_ENG_Frozen_Lock
Scenario: A coding decision will still be processed even if the data page has been frozen
And Coder App Segment is loaded
And a project registration with dictionary "Medra 11.0 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE1  | Adverse Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TST"
When adding a new verbatim term to form "ETE5"
	| Field         | Value                | ControlType | Control Value |
	| AdverseEvent1 | terrible head pain   |             |               |
And I select the Header Entrylock Checkbox  
And I navigate to Coder 
When I browse and code Term "terrible head pain" located in "Coder Main Table" entering value "Headache" and selecting "Headache" located in "Dictionary Tree Table"
And I navigate to Rave
Then when I view task "terrible head pain" on form "Subject" I should see the following data
    |data                       |
    |terrible head pain         |
    |SOC                        |
    |Nervous system disorders   |
    |10029205                   |
    |HLGT                       |
    |Headaches                  |
    |10019231                   |
    |HLT                        |
    |Headaches NEC              |
    |10019233                   |
    |PT                         |
    |Headache                   |
    |10019211                   |
    
    
@MCC-207752
@ETE_ENG_Frozen_Lock 
Scenario: Query must be opened on rejecting a term even if the data point has been hard locked
And Coder App Segment is loaded
And a project registration with dictionary "Medra 11.0 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE1  | Adverse Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TST"
When adding a new verbatim term to form "ETE5"
	| Field         | Value                | ControlType | Control Value |
	| AdverseEvent1 | terrible head pain   |             |               |
And I select the Header Entrylock Checkbox  
And I navigate to Coder 
Then I submit coder query "Rejecting Decision due to bad term" for task "sharp pain down leg"  
Then I should see the query status "open" for task "sharp pain down leg query"       #will take a few mins
And I navigate to Rave
Then when I view task "terrible head pain" on form "Subject" I should see the following data
    |data                               |
    |Rejecting Decision due to bad term |
    
    
  