CREATE PROCEDURE dbo.spCoder_CMP_MoveStudyRenameUsingStudyId
(
	@StudyId INT,
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
	WHERE ExternalObjectName=@StudyName AND @SegmentId=SegmentId AND @StudyId=TrackableObjectID

	IF  @OldStudyProjectId IS NULL
	BEGIN
	    SET @errorString = N'ERROR: No such study found with study id : '+CONVERT(VARCHAR(15),@StudyId)+'!'
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
	
	IF (@OldStudyProjectId <> @NewStudyProjectId )
	BEGIN
		-- 1) Update study to the correct study project 
		UPDATE dbo.TrackableObjects
		SET StudyProjectId = @NewStudyProjectId
		WHERE TrackableObjectID = @StudyId

	END
		
	-- 1a) Rename study if argument is specified
	IF (LEN(ISNULL(@NewStudyName, '')) > 0)
	BEGIN
		UPDATE dbo.TrackableObjects
		SET ExternalObjectName = @NewStudyName,
		IsTestStudy = @IsTestStudy --- setting IsTestStudy flag here
		WHERE TrackableObjectID = @StudyId
		Print 'Study has been renamed to: -' + @NewStudyName
	END

		
	-- 1b) Change IsTestStudy status if 

		IF @IsTestStudy is not null
	BEGIN
		UPDATE dbo.TrackableObjects
		SET ExternalObjectName = @NewStudyName,
		IsTestStudy = @IsTestStudy --- setting IsTestStudy flag here
		WHERE TrackableObjectID = @StudyId
		Print 'Study has been renamed to: -' + @NewStudyName
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