Feature: When a Coder query is answered or cancelled, the verbatim will be resent to Coder.


@MCC-207751
@ETE_ENG_Query_workflow
Scenario: Verify after opening a Query in Coder that the Query is Opened in Rave and an Answer for that Closed Query makes it to Coder.
And Coder App Segment is loaded
And a project registration with dictionary "MedDRA 12.0 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE1 | Adverese Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TST"
Then I submit verbatim "sharp pain down leg query" for form "ETE1" to each repeat event  
And I navigate to Coder  
Then I submit coder query "Opening Query, does this make sense?" for task "sharp pain down leg query"  
Then I should see the query status "open" for task "sharp pain down leg query"       #will take a few mins
And I should see the following info for the query history tab for term "sharp pain down leg query"
      |Column		  |Value							                       |
      |User		      |<User>	 					                           |
      |Query Status   |Open               			                           |
      |Verbatim Term  |SHARP PAIN DOWN LEG QUERY                               |
      |Query Text     |Opening Query, does this make sense?                    |
And I navigate to Rave
And I (Answer) query for form "ETE1" for "Subject" with value "Answered Query, yes it makes sense."
And I navigate to Coder
Then I should see the query status "Closed" for task "sharp pain down leg query"
And I should see the following info for the query history tab for term "sharp pain down leg query"
      |Column		  |Value							                       |
      |User	    	  |systemuser    					                       |
      |Query Status	  |Closed      				                               |
      |Verbatim Term  |sharp pain down leg query                               |
      |User	    	  |<User>                                                  |
      |Query Status   |Answered      				                           |
      |Verbatim Term  |sharp pain down leg query                               |
      |Query Response |Answered Query, yes it makes sense.                     |
      |User	    	  |CoderImport   					                       |
      |Query Status	  |Open       				                               |
And I navigate to "Coding History Report"
And I search with the following search criteria
     |data             |location                       |
     |<WHODRUGB2> (ENG)|Report Dictionary Dropdown     |
     |200703           |Dictionary Versions Dropdown   |
And I check the "Include Autocoded Items Checkbox"
And I select Button "Move All To Right Button"
And I bypass select Button "Export Report"
And I select Popup Button "Save" in popup window "File Download"
And I enter text "C:\CodingHistoryReportQMC.csv" in popup window and save with environment "<Save Environment>"
Then I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "5" in column "B" has value "sharp pain down leg query"
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "5" in column "R" has value "Queued"
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "5" in column "S" has value "Opening Query, does this make sense?"
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "6" in column "C" has value "CoderImport"
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "6" in column "R" has value "Open"
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "6" in column "S" has value "Opening Query, does this make sense?"
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "7" in column "R" has value "Answered"
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "7" in column "T" has value "Answered Query, yes it makes sense."
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "8" in column "C" has value "systemuser"
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "8" in column "R" has value "Closed"


@MCC-207751
@ETE_ENG_Query_workflow
Scenario: Verify after opening a Query in Coder that the Query is Opened and then Cancelled in Rave which updates the Query status in Coder.
And Coder App Segment is loaded
And a project registration with dictionary "MedDRA 12.0 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE1 | Adverese Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TST"
Then I submit verbatim "sharp pain down leg query" for form "ETE1" to each repeat event  
And I navigate to Coder  
Then I submit coder query "Opening Query, does this make sense?" for task "sharp pain down leg query"  
Then I should see the query status "open" for task "sharp pain down leg query"       #will take a few mins
And I should see the following info for the query history tab for term "sharp pain down leg query"
      |Column		  |Value							                       |
      |User		      |<User>	 					                           |
      |Query Status   |Open               			                           |
      |Verbatim Term  |SHARP PAIN DOWN LEG QUERY                               |
      |Query Text     |Opening Query, does this make sense?                    |
And I navigate to Rave
And I cancel query for form "ETE1" for "Subject"
And I navigate to Coder
Then I should see the query status "Cancelled" for task "sharp pain down leg query"
And I should see the following info for the query history tab for term "sharp pain down leg query"
      |Column		  |Value							                       |
      |User	    	  |systemuser    					                       |
      |Query Status	  |Cancelled      				                               |
      |Verbatim Term  |sharp pain down leg query                               |  
And I navigate to "Coding History Report"
And I search with the following search criteria
     |data             |location                       |
     |<WHODRUGB2> (ENG)|Report Dictionary Dropdown     |
     |200703           |Dictionary Versions Dropdown   |
When I navigate to "Coding History Report" under Tab "Reports Menu"
And With data below, I set value "<value3>" located in "<location3>" and wait for "2"
      |value3           |location3                      |
      |<WHODRUGB2> (ENG)|Report Dictionary Dropdown     |
      |200703           |Dictionary Versions Dropdown   |
And I check the "Include Autocoded Items Checkbox" 
And I select Button "Move All To Right Button"
And I bypass select Button "Export Report"
And I select Popup Button "Save" in popup window "File Download"
And I enter text "C:\CodingHistoryReportQMC.csv" in popup window and save with environment "<Save Environment>"
Then I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "7" in column "B" has value "sharp pain down leg query"
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "7" in column "R" has value "Cancelled"



@MCC-207751
@ETE_ENG_Query_workflow
Scenario: Verify after opening a Query in Coder that the Query is Opened and then Cancelled in Coder which updates the Query status in Rave.
And Coder App Segment is loaded
And a project registration with dictionary "MedDRA 12.0 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE1 | Adverese Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TST"
Then I submit verbatim "sharp pain down leg query" for form "ETE1" to each repeat event  
And I navigate to Coder  
And I submit coder query "Opening Query, does this make sense?" for task "sharp pain down leg query"  
And I should see the query status "open" for task "sharp pain down leg query"       #will take a few mins
And I cancel coder query "Opening Query, does this make sense?" for task "sharp pain down leg query" 
And I should see the query status "Cancelled" for task "sharp pain down leg query" 
And I should see the following info for the query history tab for term "sharp pain down leg query"
      |Column		  |Value							                       |
      |User	    	  |systemuser    					                       |
      |Query Status	  |Cancelled      				                               |
      |Verbatim Term  |sharp pain down leg query                               |  
And I navigate to "Coding History Report"
And I search with the following search criteria
     |data             |location                       |
     |<WHODRUGB2> (ENG)|Report Dictionary Dropdown     |
     |200703           |Dictionary Versions Dropdown   |
When I navigate to "Coding History Report" under Tab "Reports Menu"
And With data below, I set value "<value3>" located in "<location3>" and wait for "2"
      |value3           |location3                      |
      |<WHODRUGB2> (ENG)|Report Dictionary Dropdown     |
      |200703           |Dictionary Versions Dropdown   |
And I should see the following info for the Coding history tab for term "sharp pain down leg query"
     |Column		    |Value							                           |
     |User		    |<User>     					                           |
     |Action		    |Cancel Query          			                           |
     |Verbatim Term 	|sharp pain down leg query                                 |
And I should see the following info for the query history tab for term "sharp pain down leg query"
      |Column		  |Value							                       |
      |User	    	  |CoderImport    					                       |
      |Query Status	  |Cancelled   				                               |
      |Verbatim Term  |sharp pain down leg query                               |  
When I navigate to "Coding History Report" under Tab "Reports Menu"
And With data below, I set value "<value3>" located in "<location3>" and wait for "2"
      |value3           |location3                      |
      |<WHODRUGB2> (ENG)|Report Dictionary Dropdown     |
      |200703           |Dictionary Versions Dropdown   |
And I check the "Include Autocoded Items Checkbox" 
And I select Button "Move All To Right Button"
And I bypass select Button "Export Report"
And I select Popup Button "Save" in popup window "File Download"
And I enter text "C:\CodingHistoryReportQMC.csv" in popup window and save with environment "<Save Environment>"
Then I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "9" in column "B" has value "sharp pain down leg query"
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "9" in column "K" has value "Cancel Query"
And I navigate to Rave
Then when I view form "ETE1" for "Subject" I should (not) see the following data
     | "Opening Query, does this make sense?"|
     

@MCC-207751
@ETE_ENG_Query_workflow
Scenario: Verify after opening a Query in Coder that the Query is Opened in Rave but then is Closed in Rave when the term has been coded and approved in Coder.
And Coder App Segment is loaded
And a project registration with dictionary "MedDRA 12.0 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE1 | Adverese Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TST"
Then I submit verbatim "sharp pain down leg query" for form "ETE1" to each repeat event  
And I navigate to Coder  
And I submit coder query "Opening Query, does this make sense?" for task "sharp pain down leg query"  
And I should see the query status "open" for task "sharp pain down leg query"       #will take a few mins
And I navigate to Rave
Then when I view form "ETE1" for "Subject" I should see the following data
     | "Opening Query, does this make sense?"|
And I navigate to Coder
And in "Study" I browse and code task "sharp pain down leg query" entering value "Aleve" and selecting "ALEVE FEMINAX" located in Dictionary Tree Table
And I select approve for term "sharp pain down leg query"
And I navigate to "Reclassification"
And I search setting options "Reclassify Dictionary Locale Dropdown with value <WHODRUGB2> (ENG), Dictionary Versions Dropdown with value 200703, Include Autocoded Items Checkbox with value checked"
And I reclassify task "sharp pain down leg query" located in "Reclassification Table" on row "1" coded by "<User>" date coded "current date" and press Button "OK"
And I should see the query status "Cancelled" for task "sharp pain down leg query" 
And I should see the following info for the query history tab for term "sharp pain down leg query"
      |Column		  |Value							                       |
      |User	    	  |CoderImport    					                       |
      |Query Status	  |Cancelled   				                               |
      |Verbatim Term  |sharp pain down leg query                               | 
When I navigate to "Coding History Report" under Tab "Reports Menu"
And With data below, I set value "<value3>" located in "<location3>" and wait for "2"
      |value3           |location3                      |
      |<WHODRUGB2> (ENG)|Report Dictionary Dropdown     |
      |200703           |Dictionary Versions Dropdown   |
And I check the "Include Autocoded Items Checkbox"
And I select Button "Move All To Right Button"
And I bypass select Button "Export Report"
And I select Popup Button "Save" in popup window "File Download"
And I enter text "C:\CodingHistoryReportQMC.csv" in popup window and save with environment "<Save Environment>"
Then I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "8" in column "B" has value "sharp pain down leg query"
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "8" in column "R" has value "Cancelled"
And I should see partial text "Query Cancelled; Queue Number" in file "C:\CodingHistoryReportQMC.csv"




@MCC-207751
@ETE_ENG_Query_workflow
Scenario: Verify after opening a Query in Coder that the Query is Opened in Rave and then is Cancelled in Coder when the term has been auto coded/approved after a study migration changing the query status to Cancelled in Rave.
And Coder App Segment is loaded
And a project registration with dictionary "MedDRA 12.0 ENG"
And Rave Modules App Segment is loaded 
And a Rave Coder setup with the following options
	| Form  | Field           | Dictionary   | Locale   | Coding Level | Priority | IsApprovalRequired | IsAutoApproval |
	| ETE1 | Adverese Event 1 | <Dictionary> | <Locale> | LLT          | 1        | true               | true           |
When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"	
And adding a new subject "TST"
Then I submit verbatim "VERBATIM TERM 01" for form "ETE1" to each repeat event  
And I navigate to Coder  
And I submit coder query "Opening Query on task" for task "VERBATIM TERM 01"  
And I should see the query status "open" for task "VERBATIM TERM 01"       #will take a few mins
And I navigate to Rave
Then when I view form "ETE1" for "Subject" I should see the following data
     | Opening Query on task|
And I navigate to Coder
And I create a new Synonym List with name "Primary" Dictionary "MedDRA" Locale "eng" and Version "16.1"
And I select Link "Upgrade Synonym List" located in "Coder Main Table" row labeled "Primary" column labeled "Details"
 And I enter value "<Path>/MedDRA_16To161_Change.txt" in the "Upload Synonyms From File Textfield"
  And I select Button "Import"
And I navigate to "Study Impact Analysis" under Tab "Admin Menu"
And I generate a report with the data below
      |value	             |dropdown2				  |
      |<RaveCoderETEStudy>   |Register Study Dropdown |
      |MedDRA (ENG)          |IADictionary Dropdown   |
      |16.1   	             |To Ordinal Dropdown	  |
And I complete study migration 
And I navigate to "Reclassification" 
And I search setting options "Reclassify Dictionary Locale Dropdown with value MedDRA (ENG), Dictionary Versions Dropdown with value 16.1, Include Autocoded Items Checkbox with value checked"
And I reclassify task "VERBATIM TERM 01" located in "Reclassification Table" on row "1" coded by "<User>" date coded "current date" and press Button "OK"
And I navigated to "Tasks"
And I should see the query status "Cancelled" for task "VERBATIM TERM 01"
And With data below, I should see value "<Value>" located in "Coder Main Table" on row "1"
      |Value                               |
      |verbatim term 01                    |
      |Acetabular dysplasia                |
      |MedDRA - 16.1 - Primary             |
And I select Tab "Coding History"
And I should see the following info for the query history tab for term "VERBATIM TERM 01"
      |Column		  |Value							                       |
      |User	    	  |CoderImport    					                       |
      |Query Status	  |Cancelled   				                               |
      |Verbatim Term  |VERBATIM TERM 01                                        | 
Then I should see value "VersionChange - From 16.0 To 16.1. Recoded due to synonym change across versions" located in "Coding History Table"
And I should see value "Query Cancelled; Queue Number" located in "Coding History Table"
Then With data below, I should see value "<Value>" located in "Query History Table" on row "<Table Row>" column labeled "<Column>"
       |Table Row	    |Column		    |Value							                           |
       |1 			    |User	    	|CoderImport   					                           |
       |1			    |Query Status	|Cancelled       				                           |
       |1			    |Verbatim Term 	|VERBATIM TERM 01                                          |
When I navigate to "Coding History Report" under Tab "Reports Menu"
And With data below, I set value "<value3>" located in "<location3>" and wait for "2"
      |value3       |location3                      |
      |MedDRA (ENG) |Report Dictionary Dropdown     |
      |16.1         |Dictionary Versions Dropdown   |
And I check the "Include Autocoded Items Checkbox"
And I select Button "Move All To Right Button"
And I bypass select Button "Export Report"
And I wait for "3"
And I select Popup Button "Save" in popup window "File Download"
And I enter text "C:\CodingHistoryReportQMC.csv" in popup window and save with environment "<Save Environment>"
Then I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "8" in column "B" has value "VERBATIM TERM 01"
And I verify in spreadsheet "C:\CodingHistoryReportQMC.csv" on worksheet "CodingHistoryReportQMC" on row "8" in column "R" has value "Cancelled"
And I should see partial text "Query Cancelled; Queue Number" in file "C:\CodingHistoryReportQMC.csv"







     
     
     
     
     
     