Feature: Architect CRF download will contain Coder settings and Architect upload will save Coder settings

@DFT
@PBMCC42701_10
@ETE_RaveCoderCore
@Release2016.1.0
Scenario: When downloading an architect CRF spreadsheet containing Coder information on a project that has registered to a Coding Dictionary, Coding configuration data will be present upon selection

    Given a Rave project registration with dictionary "WhoDrug_DDE_B2 ENG 201509"
    And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
		| Form | Field          | Dictionary   | Locale   | Coding Level     | Priority | IsApprovalRequired | IsAutoApproval |
		| ETE2 | Coding Field   | <Dictionary> | <Locale> | PRODUCTSYNONYM   | 1        | true               | true           |	
	And supplemental terms for the following fields
		| Form | Field             | Supplemental Field |
		| ETE2 | Log Supp Field1   | LOGSUPPFIELD1      |
		| ETE2 | Std Supp Field 4  | LOGSUPPFIELD2      |
	When downloading Rave Architect CRF named "ETE_Study_Draft.zip" located to "C:\Temp"
	Then verify file "ETE_Study_Draft.zip" located in "C:\Temp" has the following Rave Architect CRF Coder Configuration information
        | Form | Field        | Dictionary   | Locale   | Coding Level   | Priority | IsApprovalRequired | IsAutoApproval |
        | ETE2 | Coding Field | <Dictionary> | <Locale> | PRODUCTSYNONYM | 1        | true               | true           |	
	And verify file "ETE_Study_Draft.zip" located in "C:\Temp" has the following Rave Architect CRF Coder Supplemental Terms information
		| Form | Field        | Supplemental Field |
		| ETE2 | Coding Field | LOGSUPPFIELD2      |
		| ETE2 | Coding Field | LOGSUPPFIELD4      |

	
@DFT
@PBMCC42701_40
@ETE_RaveCoderCore
@Release2016.1.0
Scenario: When uploading an architect spreadsheet to a project that is not registered to a Coding Dictionary, then the upload should fail.

	Given Rave Modules App Segment is loaded
	When uploading a rave architect draft template "MCC42701_40.xls" to "Draft 1" for study "<Study>"
	Then I verify the following CRF upload message "Error while reading row 5. Field OID 'CODERTERM1' in form OID 'ETE1' : Coding dictionary 'MedDRAMedHistory (Coder)' not found in the target database."
