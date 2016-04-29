IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_DeletePriorFailedStudyRegistrations')
	DROP PROCEDURE dbo.spCoder_CMP_DeletePriorFailedStudyRegistrations
GO

CREATE PROCEDURE spCoder_CMP_DeletePriorFailedStudyRegistrations
(
	@StudyName NVARCHAR(450),
	@SegmentName NVARCHAR(450),
	@ExternalObjectId NVARCHAR(100)
)
AS
BEGIN
	SET XACT_ABORT ON

	DECLARE @StudyProjectId INT, @RegistrationsCount INT, @errorString NVARCHAR(MAX), @successString NVARCHAR(MAX)
	DECLARE @SegmentId INT

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
	FROM   TrackableObjects 
	WHERE  ExternalObjectName=@StudyName AND @SegmentId=SegmentId AND @ExternalObjectId=ExternalObjectId

	IF  @StudyProjectId IS NULL
	BEGIN
	    SET @errorString = N'ERROR: No such study found with externalobjectid(UUID) : '+CONVERT(VARCHAR(15),@ExternalObjectId)+'!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	IF NOT EXISTS (SELECT NULL FROM ProjectDictionaryRegistrations
		WHERE SegmentID = @SegmentId AND StudyProjectId = @StudyProjectId)
	BEGIN
	    SET @errorString = N'ERROR: Could not find any registrations for study with externalobjectid(UUID) : '+CONVERT(VARCHAR(15),@ExternalObjectId)+'!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	BEGIN TRANSACTION

	DECLARE @FailedRegistrationIds TABLE (Id INT)
	INSERT INTO @FailedRegistrationIds
	SELECT pdr.ProjectDictionaryRegistrationID 
	FROM ProjectDictionaryRegistrations pdr
	LEFT JOIN ProjectRegistrationTransms pt ON pdr.ProjectRegistrationTransmissionId = pt.ProjectRegistrationTransmissionId	
	WHERE pdr.SegmentID = @SegmentId 
	AND pdr.StudyProjectId = @StudyProjectId
	AND (pt.ProjectRegistrationSucceeded = 0 OR pdr.ProjectRegistrationTransmissionId = 0)

	--Delete Failed Transmissions
	DELETE pt
	FROM ProjectRegistrationTransms pt	
	JOIN ProjectDictionaryRegistrations pdr ON pdr.ProjectRegistrationTransmissionId = pt.ProjectRegistrationTransmissionId
	JOIN @FailedRegistrationIds failed ON pdr.ProjectDictionaryRegistrationID = failed.Id
	
	--Delete Failed Registrations
	DELETE pdr 
	FROM ProjectDictionaryRegistrations pdr
	JOIN @FailedRegistrationIds failed ON pdr.ProjectDictionaryRegistrationID = failed.Id
	SELECT @RegistrationsCount = @@ROWCOUNT
	
	COMMIT TRANSACTION
	 
	SET @successString = N'Success! '+CONVERT(VARCHAR,@RegistrationsCount) +' registrations are deleted from: '+@StudyName+'.'
	PRINT @successString
END
