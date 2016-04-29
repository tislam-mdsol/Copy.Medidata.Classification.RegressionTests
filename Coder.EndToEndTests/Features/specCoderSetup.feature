@specCoderSetup.feature
@EndToEnd
Feature: specCoderSetupSteps
	Enroll a new segment in Coder
	Roll out a dictionary
	Create and assign workflow role, general role, page study role and dictionary role


@VAL
@Release2016.1.0
@PBMCC211000
Scenario: CoderAdmin enrolls a new segment in Coder and rolls out a new dictionary
	Given a new segment to be enrolled in Coder
	When a dictionary "MedDRA (eng)" is rolled out
	Then Verify dictionary has rolled out

@VAL
@Release2016.1.0
@PBMCC211000
Scenario: Create and assign workflow role, general role, page study role and dictionary role
	Given a new Coder User
	When creating and activating a new workflow role called "Workflow Admin"
	And assigning workflow role "Workflow Admin" for "All" study
	And creating and activating a "Page Study Security" role called "StudyAdmin"
	And assigning "Page Study Security" General Role "StudyAdmin" for "All" type
	And creating and activating a "Page Dictionary Security" role called "DictAdmin"
	And assigning "Page Dictionary Security" General Role "DictAdmin" for "All" type
	#Then logout

