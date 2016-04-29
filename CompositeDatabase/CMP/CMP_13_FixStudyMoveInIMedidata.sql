   /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Sneha Saikumar ssaikumar@mdsol.com
//
// Fix for study synching conflict in coder - Due to study move under different StudyGroup in Imedidata
// Stored procedure takes StudyUUID and performs the following:
// 1) Check if study owns a project
// 2) Delete study and Project if and only if Project is solely dependent on this study 
// 3) Will leave Project if more then one 
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_013')
	DROP PROCEDURE spCoder_CMP_013
GO

CREATE PROCEDURE dbo.spCoder_CMP_013
(
	@StudyUUID NVARCHAR(100),
	@IgnoreProjectRegistration BIT = 0
)
AS
BEGIN

	DECLARE @StudyId BIGINT, @StudyProjectId BIGINT, @StudyCount INT, @errorString NVARCHAR(MAX), @StudyProjectHasMoreThenOneStudy BIT
	
	SELECT @StudyId = TrackableObjectID, 
		@StudyProjectId = StudyProjectId
	FROM TrackableObjects 
	WHERE ExternalObjectId=@StudyUUID
	
	IF (@StudyId IS NULL)
	BEGIN
	SET @errorString = N'ERROR: No such study found!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	ElSE
	BEGIN

		-- DEBUG/INFO

		SELECT @StudyId AS 'StudyID', @StudyProjectId AS 'StudyProjectId'

		SELECT 'StudyENTRY', *
		FROM TrackableObjects
		WHERE TrackableObjectID = @StudyId

		SELECT 'ProjectENTRY', *
		FROM StudyProjects 
		WHERE StudyProjectID = @StudyProjectId

	END
	
	-- 2) Check if Study and Project are deletable
	SELECT @StudyCount = count(*) 
	FROM TrackableObjects 
	WHERE StudyProjectId = @StudyProjectId
	
	-- 3) Project not deletable if there are other studies that need it.
	IF (@StudyCount > 1)
	BEGIN
	    SET @StudyProjectHasMoreThenOneStudy = 1
	    SET @errorString = N'WARNING: Will not delete project because there are other studies in the project thats need it'
		PRINT @errorString
	END
	ELSE
	BEGIN
		SET @StudyProjectHasMoreThenOneStudy = 0
	END
	
	-- 4) If coding elements exist for the study, return with error    	
	IF EXISTS(SELECT NULL FROM CodingElements CE
			JOIN StudyDictionaryVersion SDV
				ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
			JOIN TrackableObjects T
				ON T.TrackableObjectID = SDV.StudyID
				AND T.TrackableObjectId = @StudyId)
	BEGIN
	SET @errorString = N'ERROR: Study has coding elements!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END


	IF @IgnoreProjectRegistration = 0 AND EXISTS (SELECT NULL FROM ProjectDictionaryRegistrations
		WHERE StudyProjectID = @StudyProjectId)
	BEGIN
	SET @errorString = N'ERROR: Project has been registered!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	-- 4) Delete study, project and dependent objects  
	BEGIN TRY
	BEGIN TRANSACTION

		-- if ignore project registration, wipe them as well
		IF (@IgnoreProjectRegistration = 1)
		BEGIN

			DELETE FROM ProjectDictionaryRegistrations
			WHERE StudyProjectID = @StudyProjectId

		END
		
		--  Delete StudyDictionaryVersionHistory for the study
		DELETE FROM StudyDictionaryVersionHistory WHERE StudyID = @StudyId
		
		-- Delete dictionary registrations for the study		
		DELETE FROM StudyDictionaryVersion WHERE StudyID = @StudyId
		
		-- Delete ApplicationTrackableObjects for the study
		DELETE FROM ApplicationTrackableObject WHERE TrackableObjectID = @StudyId
				
		-- Delete all study for the project		
		DELETE FROM TrackableObjects WHERE TrackableObjectID = @StudyId
		
		IF (@StudyProjectHasMoreThenOneStudy = 1)
		BEGIN
			-- Delete project		
			DELETE FROM StudyProjects WHERE StudyProjectID = @StudyProjectId
		END

	
	  COMMIT TRANSACTION
	END TRY	
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE	@ErrorMessage NVARCHAR(4000)

		SELECT @ErrorMessage = ERROR_MESSAGE()
				
		SET @errorString = N'ERROR: Transaction Error Message - ' + @ErrorMessage
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH
END