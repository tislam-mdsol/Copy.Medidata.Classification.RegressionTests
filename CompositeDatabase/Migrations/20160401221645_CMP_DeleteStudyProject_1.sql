
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_DeleteStudyProject')
	DROP PROCEDURE spCoder_CMP_DeleteStudyProject
GO

CREATE PROCEDURE [dbo].[spCoder_CMP_DeleteStudyProject]
(
	@StudyProjectId BIGINT,
	@IgnoreProjectRegistration BIT = 0
)
AS
BEGIN

	DECLARE @errorString NVARCHAR(MAX)
	
	DECLARE @StudyIds TABLE (Id INT)

	Insert into @StudyIds
	Select TrackableObjectId from TrackableObjects
	where StudyProjectId = @StudyProjectId
	
	IF Not Exists(SELECT null from StudyProjects where StudyProjectId = @StudyProjectId)
	BEGIN
	SET @errorString = N'ERROR: No such study project found!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	ElSE
	BEGIN

		-- DEBUG/INFO

		SELECT 'ProjectENTRY', *
		FROM StudyProjects 
		WHERE StudyProjectID = @StudyProjectId

		SELECT 'StudyENTRY', *
		FROM TrackableObjects
		WHERE StudyProjectID = @StudyProjectId

		Select 'ApplicationTrackableObject',ato.* 
		FROM ApplicationTrackableObject ato
		Join @StudyIds s 
		On ato.TrackableObjectID = s.Id
	
		Select 'StudyDictionaryVersion', sdv.*
	    FROM StudyDictionaryVersion  sdv
		Join @StudyIds s
		on s.Id = sdv.StudyId

		Select 'StudyDictionaryVersionHistory',sdvh.* 
		FROM StudyDictionaryVersionHistory sdvh
		 Join StudyDictionaryVersion  sdv
		on sdv.StudyDictionaryVersionID = sdvh.StudyDictionaryVersionID
		Join @StudyIds s
		on s.Id = sdv.StudyId
		

	END
	
	-- If coding elements exist for the study, return with error    	
	IF EXISTS(SELECT NULL FROM CodingElements CE
			JOIN StudyDictionaryVersion SDV
				ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
			JOIN TrackableObjects T
				ON T.TrackableObjectID = SDV.StudyID
				AND T.StudyProjectId = @StudyProjectId)
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
		Delete sdvh 
		FROM StudyDictionaryVersionHistory sdvh
		Join StudyDictionaryVersion  sdv
		ON sdv.StudyDictionaryVersionID = sdvh.StudyDictionaryVersionID
		Join @StudyIds s
		ON s.Id = sdv.StudyId
		
		---- Delete dictionary registrations for the study		
		DELETE sdv
	    FROM StudyDictionaryVersion  sdv
		Join @StudyIds s
		ON s.Id = sdv.StudyId
		
		---- Delete ApplicationTrackableObjects for the study
		DELETE ato
		FROM ApplicationTrackableObject ato
		Join @StudyIds s 
		ON ato.TrackableObjectID = s.Id
				
		---- Delete all study for the project		
		DELETE
		FROM TrackableObjects
		WHERE StudyProjectID = @StudyProjectId

		-- Delete project		
		DELETE FROM StudyProjects WHERE StudyProjectID = @StudyProjectId
	
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
