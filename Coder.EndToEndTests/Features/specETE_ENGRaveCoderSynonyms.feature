Feature: Verify Integration between Rave Coder Synonyms

@DFT
@PB11147_001ETE
@Release2012.2.0
@DE2089
Scenario: Verify in Rave that Verbatim terms with a synonym that have been accepted during the synonym upversioning process, will ReCode automatically during study upversioning to new accepted synonym and be sent back to Rave with the new path
	Given a Rave project registration with dictionary "MedDRA ENG 15.0"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form | Field       | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE5 | CoderField5 | <Dictionary> | <Locale> | LLT         | 1        | true               | false          |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE5"
	| Field         | Value           | ControlType |
	| AdverseEvent1 | Adverse Event 1 |             |
	When task "Adverse Event 1" is coded to term "Infusion site bruising" at search level "Lower Level Term" with code "10059203" at level "LLT" and a synonym is created
	Then Rave should contain the following coding decision information for subject "CoderSubject" on field "Coding Field"
		| Level | Code     | Term                           |
		| SOC   | 10022891 | Investigations                 |
		| HLGT  | 10040879 | Skin investigations            |
		| HLT   | 10040862 | Skin histopathology procedures |
		| PT    | 10004873 | Biopsy skin                    |
		| LLT   | 10004873 | Biopsy skin                    |
	And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
	And starting synonym list migration
	And accepting the reconciliation suggestion for the synonym "Adverse Event 1" under the category "Path Does Not Exist"	
	And completing synonym migration																							  
	And performing Study Impact Analysis																						  
	Then the verbatim term "Adverse Event 1" exists under Path Changed															  														  
    When performing study migration
	Then study migration is complete for the latest version
	And the following study report information exists
		| Verbatim        | Category                | Workflow Status     |
		| Adverse Event 1 | Coded but not Completed | Waiting Approval    |
	And the term has the following coding history comments
		| Verbatim        | Comment                                                                                                         | Workflow Status     |
		| Adverse Event 1 | Version Change - From MedDRA-15_0-English To MedDRA-18_0-English. Recoded due to synonym change across versions | Waiting Approval    |

	
@DFT
@PB11147_001bETE
@Release2012.2.0
@DE1655
Scenario: Verify in Rave that Verbatim terms with a synonym that have been accepted during the synonym upversioning process, while in a reclassified state will ReCode automatically during study upversioning
	Given a Rave project registration with dictionary "MedDRA ENG 11.0"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form | Field       | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE5 | CoderField5 | <Dictionary> | <Locale> | LLT         | 1        | false              | true           |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE5"
	| Field         | Value           | ControlType |
	| AdverseEvent1 | Adverse Event 1 |             |
	When task "Adverse Event 1" is coded to term "Infusion site bruising" at search level "Lower Level Term" with code "10059203" at level "LLT" and a synonym is created
	Then Rave should contain the following coding decision information for subject "CoderSubject" on field "Coding Field"
		| Level | Code     | Term                           |
		| SOC   | 10022891 | Investigations                 |
		| HLGT  | 10040879 | Skin investigations            |
		| HLT   | 10040862 | Skin histopathology procedures |
		| PT    | 10004873 | Biopsy skin                    |
		| LLT   | 10004873 | Biopsy skin                    |
	And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
	And starting synonym list migration
	And accepting the reconciliation suggestion for the synonym "Adverse Event 1" under the category "Path Does Not Exist"	
	And completing synonym migration																							  
	And reclassifying task "Adverse Event 1" with Include Autocoded Items set to "True"
	And performing Study Impact Analysis																						  
	Then the verbatim term "Adverse Event 1" exists under Path Changed															  														  
    When performing study migration
	Then study migration is complete for the latest version
	And the following study report information exists
		| Verbatim        | Category                | Workflow Status  |
		| Adverse Event 1 | Coded but not Completed | Waiting Approval |
	And the term has the following coding history comments
		| Verbatim        | Comment                                                                                                         | Workflow Status  |
		| Adverse Event 1 | Version Change - From MedDRA-15_0-English To MedDRA-18_0-English. Recoded due to synonym change across versions | Waiting Approval |

@DFT
@PB11147_001cETE
@Release2012.2.0
@DE1655
Scenario: Verify in Rave that a new exact match should re-code automatically upon study upversioning completing, while in a reclassified state the term will ReCode automatically during study upversioning to new accepted synonym and be sent back to Rave with the new path
	Given a Rave project registration with dictionary "MedDRA ENG 13.1"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form | Field       | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE1 | CoderField1 | <Dictionary> | <Locale> | LLT         | 1        | false              | true           |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE1"
	| Field         | Value           | ControlType |
	| AdverseEvent1 | Adverse Event 1 |             |
	And adding a new verbatim term to form "ETE1"
	| Field         | Value                    | ControlType |
	| AdverseEvent1 | CARBOHYDRATE INTOLERANCE |             |
	When task "Adverse Event 1" is coded to term "Infusion site bruising" at search level "Lower Level Term" with code "10059203" at level "LLT" and a synonym is created
	And a Rave submitted coding task "CARBOHYDRATE INTOLERANCE" for subject "CoderSubject" on field "Coding Field"
    When task "CARBOHYDRATE INTOLERANCE" is coded to term "Carbohydrate tolerance decreased" at search level "Lower Level Term" with code "10007218" at level "LLT" and a synonym is created
	Then Rave should contain the following coding decision information for subject "CoderSubject" on field "Coding Field"
		| Level | Code     | Term                                                |
		| SOC   | 10022891 | Investigations                                      |
		| HLGT  | 10027432 | Metabolic, nutritional and blood gas investigations |
		| HLT   | 10007217 | Carbohydrate tolerance analyses (incl diabetes)     |
		| PT    | 10007218 | Carbohydrate tolerance decreased                    |
		| LLT   | 10007218 | Carbohydrate tolerance decreased                    |
	And a new synonym list is created for "MedDRA ENG 14.0"
	And a reconcile synonym and study impact analysis migration is performed between "MedDRA ENG 13.1" to "MedDRA ENG 14.0"
	And term "CARBOHYDRATE INTOLERANCE" for "MedDRA 14.0" with Include Autocode Items "checked" is reclassified
	Then Rave Adverse Events form "ETE1" should display 
		| Level | Code     | Term                                         |
		| SOC   | 10027433 | Metabolism and nutrition disorders           |
		| HLGT  | 10016950 | Food intolerance syndromes                   |
		| HLT   | 10042454 | Sugar intolerance (excl glucose intolerance) |
		| PT    | 10071200 | Carbohydrate intolerance                     |
		| LLT   | 10071200 | Carbohydrate intolerance                     |

	
@DFT
@PB11130_001ETE
@Release2012.2.0
Scenario: Verify in Rave that a new exact match should re-code automatically upon study upversioning completing.
	Given a Rave project registration with dictionary "AZDD ENG 6.1"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form | Field       | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE1 | CoderField1 | <Dictionary> | <Locale> | TN          | 1        | false              | true           |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE1"
	| Field         | Value     | ControlType |
	| AdverseEvent1 | APO-TAMIS |             |
	When task "APO-TAMIS" is coded to to term "APO-K" at search level "Trade Name" with code "000314 02 046" at level "TN" and a synonym is created
	Then Rave should contain the following coding decision information for subject "CoderSubject" on field "Coding Field"
		| Level | Code          | Term                                      |
		| ATC   | A             | ALIMENTARY TRACT AND METABOLISM           |
		| ATC   | G             | BLOOD AND BLOOD FORMING ORGANS            |
		| ATC   | G04           | BLOOD SUBSTITUTES AND PERFUSION SOLUTIONS |
		| ATC   | G04C          | I.V. SOLUTION ADDITIVES                   |
		| ATC   | G04CA         | Electrolyte solutions                     |
		| PN    | 012803 02 001 | POTASSIUM CHLORIDE                        |
		| TN    | 012803 02 519 | APO-K                                     |	
	And a new synonym list is created for "AZDD ENG 11.1"
	And a reconcile synonym and study impact analysis migration is performed between "AZDD ENG 6.1" to "AZDD ENG 11.1"
	And term "CARBOHYDRATE INTOLERANCE" for "AZDD 11.1" with Include Autocode Items "checked" is reclassified
	Then Rave Adverse Events form "ETE1" should display 
		| Level | Code          | Term                                       |
		| ATC   | G             | GENITO URINARY SYSTEM AND SEX HORMONES     |
		| ATC   | G04           | UROLOGICALS                                |
		| ATC   | G04C          | DRUGS USED IN BENIGN PROSTATIC HYPERTROPHY |
		| ATC   | G04CA         | Alpha-adrenoreceptor antagonists           |
		| PN    | 012803 02 001 | TAMSULOSIN HYDROCHLORIDE                   |
		| TN    | 012803 02 519 | APO-TAMIS                                  |	
	And the rave audit trail contains the following message "APO-TAMIS - version 11.1"
	
	
@DFT
@PB11130_002ETE
@Release2012.2.0
Scenario: Verify in Rave a new exact match should re-code automatically upon study upversioning completing. 
	Given a Rave project registration with dictionary "AZDD ENG 6.1"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form | Field       | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE1 | CoderField1 | <Dictionary> | <Locale> | TN          | 1        | false              | true           |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE1"
	| Field         | Value  | ControlType |
	| AdverseEvent1 | LOVAZA |             |
	When task "LOVAZA" is coded to to term "LOVASTATIN" at search level "PREFERRED NAME" with code "008967 01 001" at level "PN" and a synonym is created
	Then Rave should contain the following coding decision information for subject "CoderSubject" on field "Coding Field"
		| Level | Code          | Term                          |
		| ATC   | C             | CARDIOVASCULAR SYSTEM         |
		| ATC   | C10           | LIPID MODIFYING AGENTS        |
		| ATC   | C10A          | LIPID MODIFYING AGENTS, PLAIN |
		| ATC   | C10AA         | HMG CoA reductase inhibitors  |
		| PN    | 008967 01 001 | LOVASTATIN                    |	
	And a new synonym list is created for "AZDD ENG 11.1"
	And a reconcile synonym and study impact analysis migration is performed between "AZDD ENG 6.1" to "AZDD ENG 11.1"
	And term "CARBOHYDRATE INTOLERANCE" for "AZDD 11.1" with Include Autocode Items "checked" is reclassified
	Then Rave Adverse Events form "ETE1" should display 
		| Level | Code          | Term                          |
		| ATC   | C             | CARDIOVASCULAR SYSTEM         |
		| ATC   | C10           | LIPID MODIFYING AGENTS        |
		| ATC   | C10A          | LIPID MODIFYING AGENTS, PLAIN |
		| ATC   | C10AX         | Other lipid modifying agents  |
		| PN    | 014037 01 001 | OMEGA-3 MARINE TRIGLYCERIDES  |	
	And the rave audit trail contains the following message "LOVAZA - version 11.1"
	
@DFT
@PB11130_003ETE
@Release2012.2.0
@DE2193
Scenario: An exact match should remain coded upon study upversioning completing when matching the same exact match with the same term path in the new dictionary version and not be re-submitted to rave given just the update of a new dictionary version.
	Given a Rave project registration with dictionary "MedDRA ENG 11.0"
	And Rave Modules App Segment is loaded
 	And a Rave Coder setup with the following options
  	 | Form | Field       | Dictionary   | Locale   | CodingLevel | Priority | IsApprovalRequired | IsAutoApproval | SupplementalTerms |
  	 | ETE1 | CoderField1 | <Dictionary> | <Locale> | LLT         | 1        | false              | true           |                   |
	When a Rave Draft is published and pushed using draft "<Draft>" for Project "<SourceSystemStudyName>" to environment "Production"
	And adding a new subject "TST"
	And adding a new verbatim term to form "ETE1"
	| Field         | Value         | ControlType |
	| AdverseEvent1 | Vision yellow |             |
	Then Rave should contain the following coding decision information for subject "CoderSubject" on field "Coding Field"
		| Level | Code     | Term                      |
		| SOC   | 10015919 | Eye disorders             |
		| HLGT  | 10047518 | Vision disorders          |
		| HLT   | 10047538 | Visual colour distortions |
		| PT    | 10048216 | Xanthopsia                |
		| LLT   | 10047527 | Vision yellow             |
	And a new synonym list is created for "MedDRA ENG 11.1"
	And a reconcile synonym and study impact analysis migration are performed between "MedDRA ENG 11.0" to "MedDRA ENG 11.1"
	And term "Adverse Event 1" for "MedDRA 12.0" with Include Autocode Items "checked" is reclassified
	Then Rave Adverse Events form "ETE1" should display 
		| Level | Code     | Term                                           |
		| SOC   | 10022117 | Injury, poisoning and procedural complications |
		| HLGT  | 10001316 | Administration site reactions                  |
		| HLT   | 10068753 | Infusion site reactions                        |
		| PT    | 10065463 | Infusion site haematoma                        |
		| LLT   | 10059203 | Infusion site bruising                         |
	And the rave audit trail should not contain the following message "- version 11.1"