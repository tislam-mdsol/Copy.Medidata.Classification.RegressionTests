@specRaveModulesIntegration.feature
#@author: smalik
Feature: The following scenarios will serve as a coder setup script

@DFT
@Deployment
@Release2016.1.0
@PBMCC211000
 Scenario: Successfully upload a configuration file in Rave Modules
	Given a configuration file to be uploaded in Rave Modules
	When the configuration file "RaveCoreConfig_eng.xls" is uploaded in Rave Modules
	Then a verification message "Save successful" is displayed

@DDF
@Deployment
@Release2016.1.0
@PBMCC211000
 Scenario: Assign Roles to Users in Rave
	Given a new user "coderimport" that needs to be assigned roles
	

@DFT
@Release2016.1.0
@PBMCC_216333_001
@EndToEnd
@IncreaseTimeout_180000
Scenario: Upload a Rave Draft CRF template

Given Rave Modules App Segment "<Segment>" is loaded
When uploading a rave architect draft template "RaveDraft_Template.xml" to "RaveCoderDraft" for study "<SourceSystemStudyName>"
