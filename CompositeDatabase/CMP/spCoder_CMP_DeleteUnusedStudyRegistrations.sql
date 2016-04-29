/* ------------------------------------------------------------------------------------------------------
//
// Author: Eric Grun egrun@mdsol.com
//
// Deletes a Project Registration from a Project that has not been used for any Coding Requests
//
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_DeleteUnusedStudyRegistration')
	DROP PROCEDURE dbo.spCoder_CMP_DeleteUnusedStudyRegistration
GO

CREATE PROCEDURE spCoder_CMP_DeleteUnusedStudyRegistration
(
	@ProjectName NVARCHAR(450),
	@SegmentName NVARCHAR(450),
	@RegistrationName NVARCHAR(100)
)
AS
BEGIN
	SET XACT_ABORT ON

	DECLARE @StudyProjectId INT, @errorString NVARCHAR(MAX), @successString NVARCHAR(MAX)
	DECLARE @SegmentId INT, @RegistrationsCount INT

	SELECT @SegmentId = SegmentId
	FROM Segments 
	WHERE SegmentName = @SegmentName
	IF (@SegmentId IS NULL)
	BEGIN
	    SET @errorString = N'ERROR: No such segment found!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	SELECT @StudyProjectId = StudyProjectId
	FROM   StudyProjects 
	WHERE  ProjectName=@ProjectName AND @SegmentId=SegmentId
	IF  (@StudyProjectId IS NULL)
	BEGIN
	    SET @errorString = N'ERROR: No such project found with name : '+@ProjectName+'!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	IF NOT EXISTS (SELECT NULL FROM ProjectDictionaryRegistrations
		WHERE SegmentID = @SegmentId AND StudyProjectId = @StudyProjectId AND RegistrationName = @RegistrationName)
	BEGIN
	    SET @errorString = N'ERROR: Could not find any registrations for '+@RegistrationName+' on '+@ProjectName+'!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	--check for usage
	IF EXISTS (	SELECT NULL FROM StudyDictionaryVersion sdv
		JOIN TrackableObjects tos 
			ON sdv.StudyID = tos.TrackableObjectID
			AND tos.StudyProjectID = @StudyProjectId
			AND sdv.RegistrationName = @RegistrationName
		WHERE EXISTS (SELECT NULL FROM CodingElements ce
					  WHERE ce.StudyDictionaryVersionId = sdv.StudyDictionaryVersionId
						 ))
	BEGIN
	    SET @errorString = N'ERROR: Can not delete this registration as it has been Used for Coding: '+@RegistrationName+' on '+@ProjectName+'!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END


	
	BEGIN TRANSACTION

	DECLARE @ToDeleteRegistrationIds TABLE (ProjectDictionaryRegistrationID INT, ProjectRegistrationTransmissionID INT)
	INSERT INTO @ToDeleteRegistrationIds
	SELECT pdr.ProjectDictionaryRegistrationID, pdr.ProjectRegistrationTransmissionID
	FROM ProjectDictionaryRegistrations pdr
	WHERE pdr.SegmentID = @SegmentId 
	AND pdr.StudyProjectId = @StudyProjectId
	AND pdr.RegistrationName = @RegistrationName

	--Delete Sdv's
	Delete sdv
	FROM StudyDictionaryVersion sdv
	JOIN TrackableObjects tos 
	ON sdv.StudyID = tos.TrackableObjectID
	AND tos.StudyProjectID = @StudyProjectId
	AND sdv.RegistrationName = @RegistrationName
	SELECT @RegistrationsCount = @@ROWCOUNT

	--Delete Transmissions
	DELETE pt
	FROM ProjectRegistrationTransms pt
	JOIN @ToDeleteRegistrationIds toDelete ON pt.ProjectRegistrationTransmissionID = toDelete.ProjectRegistrationTransmissionID
	--guard to prevent deleting transmissions in use by other registrations
	WHERE NOT EXISTS 
	(
		SELECT NULL FROM ProjectDictionaryRegistrations pdr
		WHERE pdr.ProjectRegistrationTransmissionID = pt.ProjectRegistrationTransmissionID
		AND pdr.ProjectDictionaryRegistrationID NOT IN (SELECT ProjectDictionaryRegistrationID FROM @ToDeleteRegistrationIds)
	)
	
	--Delete Registrations
	DELETE pdr 
	FROM ProjectDictionaryRegistrations pdr
	JOIN @ToDeleteRegistrationIds toDelete ON pdr.ProjectDictionaryRegistrationID = toDelete.ProjectDictionaryRegistrationID
	
	COMMIT TRANSACTION
	 
	SET @successString = N'Success! '+CONVERT(VARCHAR,@RegistrationsCount) +' registrations are deleted from: '+@ProjectName+'.'
	PRINT @successString
END
