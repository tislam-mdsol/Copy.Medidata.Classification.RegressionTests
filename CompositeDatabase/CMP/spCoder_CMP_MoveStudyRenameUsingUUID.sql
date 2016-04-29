
 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_MoveStudyRenameUsingUUID')
	DROP PROCEDURE dbo.spCoder_CMP_MoveStudyRenameUsingUUID
GO

CREATE PROCEDURE spCoder_CMP_MoveStudyRenameUsingUUID
(
	@ExternalObjectId NVARCHAR(100),
	@StudyName NVARCHAR(450),
	@SegmentName NVARCHAR(450),
	@DestinationProjectName NVARCHAR(450),
	@NewStudyName NVARCHAR(450) = NULL,
	@IsTestStudy bit = NULL
)
AS
BEGIN
	DECLARE @OldStudyProjectId INT, @StudyCount INT, @errorString NVARCHAR(MAX),@successString NVARCHAR(MAX)
	DECLARE @SegmentId INT, @NewStudyProjectId INT
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
	
	SELECT	@OldStudyProjectId = StudyProjectId
	FROM	TrackableObjects 
	WHERE ExternalObjectName=@StudyName AND @SegmentId=SegmentId AND @ExternalObjectId=ExternalObjectId

	IF  @OldStudyProjectId IS NULL
	BEGIN
	    SET @errorString = N'ERROR: No such study found with externalobjectid(UUID) : '+CONVERT(VARCHAR(15),@ExternalObjectId)+'!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	SELECT @NewStudyProjectId = StudyProjectId
	FROM dbo.StudyProjects
	WHERE ProjectName = @DestinationProjectName
	    AND SegmentID = @SegmentId
	
	IF (@NewStudyProjectId IS NULL)
	BEGIN
	    SET @errorString = N'ERROR: Could not find destination project name -' + @DestinationProjectName + '-'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	IF (LEN(ISNULL(@NewStudyName, '')) > 0 AND CHARINDEX(@DestinationProjectName, @NewStudyName) <> 1)
	BEGIN
		SET @errorString = N'ERROR: New study name does not follow study naming convention. Should start with Project name.'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	--- Check if list of registered dictionaries of project of studyname is available in new destination project
	IF exists (	select *
				from TrackableObjects T 
					join studyprojects sp on sp.StudyProjectId = t.StudyProjectId 
					join studydictionaryversion sdv on sdv.StudyID = T.TrackableObjectID  
				where T.ExternalObjectName = @StudyName and T.ExternalObjectId = @ExternalObjectId
					and sdv.RegistrationName not in
						( 
							select distinct sdv.RegistrationName
							from StudyProjects SP 
								join TrackableObjects T on T.StudyProjectId = sp.StudyProjectId 
								join StudyDictionaryVersion SDV on sdv.StudyID = t.TrackableObjectID 
							where sp.ProjectName =  @DestinationProjectName and sp.StudyProjectId = @NewStudyProjectId
						)
				)
	BEGIN
		SET @errorString = N'ERROR: DestinationProject '+@DestinationProjectName+' does not have same set of dictionaries registered as StudyName '+ @StudyName
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END


	IF (@OldStudyProjectId <> @NewStudyProjectId )
	BEGIN
		-- 1) Update study to the correct study project 
		UPDATE dbo.TrackableObjects
		SET StudyProjectId = @NewStudyProjectId
		WHERE ExternalObjectId = @ExternalObjectId

	END
		
	-- 1a) Rename study if argument is specified
	IF (LEN(ISNULL(@NewStudyName, '')) > 0)
	BEGIN
		UPDATE dbo.TrackableObjects
		SET ExternalObjectName = @NewStudyName
		WHERE ExternalObjectId = @ExternalObjectId
		Print 'Study has been renamed to: ' + @NewStudyName
	END

		
	-- 1b) Change IsTestStudy status

		IF @IsTestStudy is not null
	BEGIN
		UPDATE dbo.TrackableObjects
		SET IsTestStudy = @IsTestStudy --- setting IsTestStudy flag here
		WHERE ExternalObjectId = @ExternalObjectId
		Print 'IsTestStudy changed to: ' + cast(@IsTestStudy as varchar(max))
	END
		
		
	-- 2) Check if the old Project is deletable
	SELECT @StudyCount = count(*) 
	FROM TrackableObjects 
	WHERE StudyProjectId = @OldStudyProjectId
	
	-- 3) Delete the old Project if it is no longer associated with any studies
	IF (@StudyCount > 0)
		
		BEGIN
			SET @errorString = N'Cannot delete project because there are other studies that needs it'
			PRINT @errorString
		END
		ELSE
		BEGIN
			DELETE dbo.StudyProjects
			WHERE StudyProjectId = @OldStudyProjectId
		END

	
	 --5) Result message
	 DECLARE @CreatedCount INT
	 SELECT @CreatedCount = COUNT(*)
	 FROM dbo.TrackableObjects
	 WHERE StudyProjectID = @NewStudyProjectId
	 
	 SET @successString = N'Success! '+CONVERT(VARCHAR,@CreatedCount) +' entries are registered to -'+@DestinationProjectName+'-'
	 PRINT @successString
END
