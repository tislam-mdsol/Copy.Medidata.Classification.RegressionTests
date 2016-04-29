IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_DeleteUnusedProjectRegistration')
	DROP PROCEDURE spCoder_CMP_DeleteUnusedProjectRegistration
GO

CREATE PROCEDURE [dbo].[spCoder_CMP_DeleteUnusedProjectRegistration]
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

	BEGIN TRANSACTION

	--get registration Ids which do not have study dictionary version
	DECLARE @ToDeleteRegistrationIds TABLE (ProjectDictionaryRegistrationID INT, ProjectRegistrationTransmissionID INT)
	INSERT INTO @ToDeleteRegistrationIds
	SELECT pdr.ProjectDictionaryRegistrationID, pdr.ProjectRegistrationTransmissionID
	FROM ProjectDictionaryRegistrations pdr
	WHERE pdr.SegmentID = @SegmentId 
	AND pdr.StudyProjectId = @StudyProjectId
	AND pdr.RegistrationName = @RegistrationName
	AND pdr.SynonymManagementID NOT IN (
		SELECT sdv.SynonymManagementID FROM StudyDictionaryVersion sdv
		JOIN TrackableObjects tos 
			ON sdv.StudyID = tos.TrackableObjectID
		WHERE sdv.SegmentId = @SegmentId
		AND tos.StudyProjectID = @StudyProjectId)

	--check for usage
	IF((SELECT Count(*) FROM @ToDeleteRegistrationIds)=0)
	BEGIN
	    SET @errorString = N'ERROR: Can not delete this registration as it doesn''t exist or it has been Used for Coding: '+@RegistrationName+' on '+@ProjectName+'!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	--Delete Transmissions only when all project dictionary registrations in the transmission are deleted 
	DELETE pt
	FROM ProjectRegistrationTransms pt
	JOIN @ToDeleteRegistrationIds toDelete ON pt.ProjectRegistrationTransmissionID = toDelete.ProjectRegistrationTransmissionID
	WHERE toDelete.ProjectRegistrationTransmissionID not in (SELECT pdr.ProjectRegistrationTransmissionID FROM ProjectDictionaryRegistrations pdr)

	--Delete Registrations
	DELETE pdr 
	FROM ProjectDictionaryRegistrations pdr
	JOIN @ToDeleteRegistrationIds toDelete ON pdr.ProjectDictionaryRegistrationID = toDelete.ProjectDictionaryRegistrationID
	
	COMMIT TRANSACTION
	
	DECLARE @DeletedRegistrationIds VARCHAR(MAX),@DeletedTransmissionIds VARCHAR(MAX)

	SELECT @DeletedRegistrationIds = COALESCE(@DeletedRegistrationIds+',','')+ProjectDictionaryRegistrationID FROM @ToDeleteRegistrationIds

	SELECT @DeletedTransmissionIds = Coalesce(@DeletedTransmissionIds+',','')+ProjectRegistrationTransmissionID FROM @ToDeleteRegistrationIds toDelete
	WHERE toDelete.ProjectRegistrationTransmissionID not in 
		(SELECT pdr.ProjectRegistrationTransmissionID 
		 FROM ProjectDictionaryRegistrations pdr)

	SET @successString = N'Success! Projects registrations('+@DeletedRegistrationIds+') are deleted from: '+@ProjectName+'.'

	If(len(@DeletedTransmissionIds)>0)
		SET @successString = @successString + N' Projects registration transmission('+@DeletedTransmissionIds+') are deleted from: '+@ProjectName+'.'
	PRINT @successString
END
