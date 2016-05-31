@specETEMCC42701ArchitectCRFHandling.feature

@EndToEndDynamicSegment
#@EndToEndDynamicStudy
#@EndToEndStaticSegment
#@DebugEndToEndDynamicSegment

Feature: Architect CRF download will contain Coder settings and Architect upload will save Coder settings

@DFT
@PBMCC42701_10
@ETE_RaveCoderCore
@Release2016.1.0
Scenario: When downloading an architect CRF spreadsheet containing Coder information on a project that has registered to a Coding Dictionary, Coding configuration data will be present upon selection
    
	Given a Rave project registration with dictionary "MedDRA ENG 15.0"
    And Rave Modules App Segment is loaded
	And a Rave Coder setup with the following options
		| Form | Field          | Dictionary   | Locale   | Coding Level  | Priority | IsApprovalRequired | IsAutoApproval |SupplementalTerms            |
		| ETE2 | Coding Field   | <Dictionary> | <Locale> | LLT           | 1        | true               | true           |LOGSUPPFIELD2, LOGSUPPFIELD4 |	
	When downloading Rave Architect CRF
	Then verify the following Rave Architect CRF Download Coder Configuration information
        | Form    | Field        | Coding Level   | Priority | Locale | IsApprovalRequired | IsAutoApproval |
        | ETE2    | CoderField2  | LLT            | 1        | eng    | true               | true           |
	And verify the following Rave Architect CRF Download Coder Supplemental Terms information
		| Form    | Field        | Supplemental Term  |
		| ETE2    | CODERFIELD2  | LOGSUPPFIELD2      |
		| ETE2    | CODERFIELD2  | LOGSUPPFIELD4      |

	
@DFT
@PBMCC42701_40
@ETE_RaveCoderCore
@Release2016.1.0
Scenario: When uploading an architect spreadsheet to a project that is not registered to a Coding Dictionary, then the upload should fail.

	Given a Rave project registration with dictionary "MedDRA ENG 15.0"
    And Rave Modules App Segment is loaded
	When uploading a rave architect draft error template
	Then verify the following CRF upload error message "Error while reading row 5. Field OID 'CODERTERM1' in form OID 'ETE1' : Coding dictionary 'MedDRAMedHistory (Coder)' not found in the target database."
