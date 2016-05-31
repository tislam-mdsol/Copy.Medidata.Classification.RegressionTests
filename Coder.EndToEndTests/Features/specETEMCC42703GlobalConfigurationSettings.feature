Feature: Configuration download will contain Global Coder settings and Configuration upload will save Global Coder settings.

@EndToEndDynamicSegment
#@EndToEndDynamicStudy
#@EndToEndStaticSegment
#@DebugEndToEndDynamicSegment
	
@DFT
@PBMCC42703_10
@ETE_STANDALONE
@Release2016.1.0
Scenario: When downloading an configuration spreadsheet for a URL that has Coder active, the Coder settings will be included.

	Given a Rave project registration with dictionary "MedDRA ENG 15.0"
    And Rave Modules App Segment is loaded
	When global Rave-Coder Configuration settings with Review Marking Group are set to "Data Management" and Requires Response are set to "false"
    Then Verify Rave Coder Global Configuration download located "c:\Temp" worksheet "Coder Configuration" Review Marking Group "Data Management" Requires Response "false"
	When global Rave-Coder Configuration settings with Review Marking Group are set to "site from system" and Requires Response are set to "true"
    Then Verify Rave Coder Global Configuration download located "c:\Temp" worksheet "Coder Configuration" Review Marking Group "site from system" Requires Response "true"
