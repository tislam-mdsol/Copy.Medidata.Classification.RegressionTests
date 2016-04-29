/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Eric Grun egrun@mdsol.com
//
// Moves an StudyEnv from one Project to another with a name change. To be used until Coder supports name changes.
// The destination Project must already exist.
//
// This CMP will need to be run for each study that requires to be moved. Replaces spCoder_CMP_FixStudyRegistration.
//
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_FixStudyRegistration')
	DROP PROCEDURE dbo.spCoder_CMP_FixStudyRegistration
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_MoveStudyRename')
	DROP PROCEDURE dbo.spCoder_CMP_MoveStudyRename
GO

CREATE PROCEDURE dbo.spCoder_CMP_MoveStudyRename
(
	@StudyName NVARCHAR(450),
	@SegmentName NVARCHAR(450),
	@DestinationProjectName NVARCHAR(450),
	@NewStudyName NVARCHAR(450) = NULL
)
AS
BEGIN

	DECLARE @StudyId INT, @OldStudyProjectId INT, @StudyCount INT, @errorString NVARCHAR(MAX),@successString NVARCHAR(MAX)
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

	SELECT @StudyId = TrackableObjectID, 
		   @OldStudyProjectId = StudyProjectId
	FROM TrackableObjects 
	WHERE ExternalObjectName=@StudyName
	      AND @SegmentId=SegmentId

	IF (@StudyId IS NULL)
	BEGIN
	    SET @errorString = N'ERROR: No such study found!'
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

		-- 1a) Rename study if necessary
		IF (LEN(ISNULL(@NewStudyName, '')) > 0)
		BEGIN
			UPDATE dbo.TrackableObjects
			SET ExternalObjectName = @NewStudyName
			WHERE TrackableObjectID = @StudyId
			Print 'Study has been renamed to: -' + @NewStudyName + '-' 
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
    END
	
	 --5) Verify results
	 DECLARE @CreatedCount INT
	 SELECT @CreatedCount = COUNT(*)
	 FROM dbo.TrackableObjects
	 WHERE StudyProjectID = @NewStudyProjectId
	 
	 SET @successString = N'Success! '+CONVERT(VARCHAR,@CreatedCount) +' entries are registered to -'+@DestinationProjectName+'-'
	 PRINT @successString

END