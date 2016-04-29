/* ------------------------------------------------------------------------------------------------------
//
// Author: Eric Grun egrun@mdsol.com
//
// Moves Project Registrations from one project to another
//
// This is intended to fix a bug with name change syncing that does not account for existing project registrations
// when moving a production study
//
// Will not work if Destination Study Project has existing duplicate registrations
//
// CurrentStudyProjectId must be in the Segment 1 - this guard is in place to prevent misuse of the cmp
//
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_MoveProjectRegistrationsForSyncError')
	DROP PROCEDURE dbo.spCoder_CMP_MoveProjectRegistrationsForSyncError
GO

CREATE PROCEDURE spCoder_CMP_MoveProjectRegistrationsForSyncError
(
	@CurrentStudyProjectID INT,
	@DestinationStudyProjectID INT
)
AS
BEGIN
	SET XACT_ABORT ON

	DECLARE @errorString NVARCHAR(MAX), @successString NVARCHAR(MAX)
	DECLARE @CurrentProjectSegmentID INT, @DestinationProjectSegmentID INT

	DECLARE @CurrentProjectRegistrations TABLE (ProjectDictionaryRegistrationID INT, ProjectRegistrationTransmissionID INT, SegmentID INT, SynonymManagementID INT, RegistrationName NVARCHAR(100))
	DECLARE @DestinationProjectRegistrations TABLE (ProjectDictionaryRegistrationID INT, ProjectRegistrationTransmissionID INT, SegmentID INT, SynonymManagementID INT, RegistrationName NVARCHAR(100))

	SELECT @CurrentProjectSegmentID = SegmentID
	FROM StudyProjects
	WHERE StudyProjectId = @CurrentStudyProjectID
	IF (@CurrentProjectSegmentID <> 1)
	BEGIN
	    SET @errorString = N'ERROR: Current Project must be in the standby segment!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	SELECT @DestinationProjectSegmentID = SegmentID
	FROM StudyProjects
	WHERE StudyProjectId = @DestinationStudyProjectID
	
	INSERT INTO @CurrentProjectRegistrations
	SELECT ProjectDictionaryRegistrationID, ProjectRegistrationTransmissionID, SegmentID, SynonymManagementID, RegistrationName
	FROM ProjectDictionaryRegistrations
	WHERE StudyProjectId = @CurrentStudyProjectID
	
	INSERT INTO @DestinationProjectRegistrations
	SELECT ProjectDictionaryRegistrationID, ProjectRegistrationTransmissionID, SegmentID, SynonymManagementID, RegistrationName
	FROM ProjectDictionaryRegistrations
	WHERE StudyProjectId = @DestinationStudyProjectID
	
	IF EXISTS (SELECT NULL FROM
	@CurrentProjectRegistrations cpr
	INNER JOIN @DestinationProjectRegistrations dpr ON cpr.RegistrationName = dpr.RegistrationName)
	BEGIN
		SET @errorString = N'ERROR: Destination Project has conflicting registrations!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	IF EXISTS (SELECT NULL FROM
	@CurrentProjectRegistrations cpr
	WHERE SegmentID <> @DestinationProjectSegmentID)
		BEGIN
		SET @errorString = N'ERROR: Current Project segment does not match Destination!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	BEGIN TRANSACTION

	UPDATE pdr
	SET pdr.StudyProjectID = @DestinationStudyProjectID
	FROM ProjectDictionaryRegistrations pdr
	JOIN @CurrentProjectRegistrations cpr
	ON pdr.ProjectDictionaryRegistrationID = cpr.ProjectDictionaryRegistrationID

	UPDATE prt
	SET prt.StudyProjectID = @DestinationStudyProjectID
	FROM ProjectRegistrationTransms prt	
	JOIN @CurrentProjectRegistrations cpr
	ON prt.ProjectRegistrationTransmissionID = cpr.ProjectRegistrationTransmissionID
	
	COMMIT TRANSACTION
	 
	SET @successString = N'Success! Registrations were successfully moved.'
	PRINT @successString
END
