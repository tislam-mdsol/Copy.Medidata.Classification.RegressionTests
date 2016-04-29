
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoProjectRegistration')
	DROP PROCEDURE spDoProjectRegistration
GO

-- spDoProjectRegistration 'Mediflexs11', 'Mediflex11', 'MedDRA', '11.0'
-- spDoProjectRegistration 'Mediflexs10', 'Mediflex10', 'WhoDrugB2', '200703'
-- spDoProjectRegistration 'Mediflexs10', 'Mediflex10', 'MedDRA', '11.0'
CREATE PROCEDURE dbo.spDoProjectRegistration  
(  
 @Project NVARCHAR(500),
 @Segment NVARCHAR(500),
 @Dictionary NVARCHAR(100),  
 @Version  NVARCHAR(100),
 @Locale  CHAR(3),
 @SynonymListName NVARCHAR(100)
)  
AS 
BEGIN

	SET XACT_ABORT ON
	
	 --production check
	IF NOT EXISTS (
		SELECT NULL 
		FROM CoderAppConfiguration
		WHERE Active = 1 AND IsProduction = 0)
	BEGIN
		PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
		RETURN
	END

	DECLARE @versionID INT, @segmentID INT, @projectID INT, @synonymListId INT, @Locale_Lower CHAR(3)
	
	SELECT @Locale_Lower = LOWER(@LOCALE)

	SELECT @versionID = dbo.fnGetVersionIdFromOids(@Dictionary, @Version)

	IF @versionID IS NULL  
	BEGIN  
		PRINT N'Cannot find Version'  
		RETURN 1  
	END

	SELECT @segmentID = SegmentId  
	FROM Segments  
	WHERE OID = @Segment 

	IF @segmentID IS NULL  
	BEGIN  
		PRINT N'Cannot find Segment OID'  
		RETURN 1  
	END
	-- 0. verify dictionary is available
	SELECT @synonymListId = SynonymMigrationMngmtID FROM SynonymMigrationMngmt
		WHERE SegmentId = @segmentID
			And DictionaryVersionId = @versionID
			And Locale = @Locale_Lower
			AND SynonymMigrationStatusRID = 6
			AND ListName = @SynonymListName
	
	IF @synonymListId IS NULL
	BEGIN
		PRINT N'Cannot find Synonym Management Entry for dictionary & segment'  
		RETURN 1 			
	END
	
	DECLARE @errorMessage NVARCHAR(500)

	BEGIN TRANSACTION
	BEGIN TRY

		SELECT @projectID = StudyProjectId 
		FROM StudyProjects
		WHERE SegmentId = @segmentID
			AND ProjectName = @Project

		-- 1. StudyProjects
		IF (@projectID IS NULL)
		BEGIN

			INSERT INTO StudyProjects(ProjectName, iMedidataID, SegmentID)
			VALUES(@Project, '', @segmentID)

			SET @projectID = SCOPE_IDENTITY()
		END

		-- 1.1 check for dictionary activity
		IF EXISTS (
				SELECT NULL FROM CodingElements 
				WHERE StudyDictionaryVersionId IN
					(SELECT StudyDictionaryVersionId FROM StudyDictionaryVersion
						WHERE SynonymManagementID = @synonymListId
							  AND StudyID IN (SELECT TrackableObjectId FROM TrackableObjects 
												WHERE StudyProjectId = @projectID))
				)
		BEGIN
			SET @errorMessage = N'There is coding activity for this Study & Dictionary - Cleanup First!'
			PRINT @errorMessage
			ROLLBACK
			RAISERROR (@ErrorMessage,  1, 16);
			RETURN
		END

		-- 2. ProjectRegistration
		IF EXISTS (SELECT NULL FROM ProjectDictionaryRegistrations
		WHERE StudyProjectID = @projectID
			AND SynonymManagementID = @synonymListId
			AND SegmentID = @segmentID)
		BEGIN
			SET @errorMessage = N'Project Registration Already Exists for this Dictionary - Cleanup First'  
			PRINT @errorMessage
			ROLLBACK
			RAISERROR (@ErrorMessage,  1, 16);
			RETURN		
		END

		-- will probably need a non-zero transmission id here
		INSERT INTO ProjectDictionaryRegistrations (StudyProjectID, SegmentID, UserID, InteractionId, ProjectRegistrationTransmissionId, SynonymManagementID)
		VALUES(@projectID, @segmentID, -2, -1, 0, @synonymListId)

		-- 3. Study Registrations
		INSERT INTO StudyDictionaryVersion  
			( SegmentID,   
			StudyID,   
			SynonymManagementID, 
			KeepCurrentVersion,   
			NumberOfMigrations)  
		SELECT  
			@SegmentID,  
			T.TrackableObjectId,
			@synonymListId,
			0,  
			0  
		FROM TrackableObjects T
			LEFT JOIN StudyDictionaryVersion SDV
				ON T.TrackableObjectId = SDV.StudyId
			LEFT JOIN SynonymMigrationMngmt SMM
				ON SMM.SynonymMigrationMngmtID = SDV.SynonymManagementID
				AND SMM.DictionaryVersionId = @versionID
				AND SMM.Locale = @Locale_Lower
		WHERE T.StudyProjectId = @projectID
			AND SMM.SynonymMigrationMngmtID IS NULL

		COMMIT TRANSACTION
		
	END TRY
	BEGIN CATCH
		
		PRINT N'Caught Exception'
		ROLLBACK TRANSACTION
		
		DECLARE	@ErrorSeverity int, 
				@ErrorState int,
				@ErrorLine int,
				@ErrorMessage2 nvarchar(4000),
				@ErrorProc nvarchar(4000)

		SELECT @ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE(),
				@ErrorLine = ERROR_LINE(),
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorProc = ERROR_PROCEDURE()
		SELECT @ErrorMessage = coalesce(@ErrorProc, 'spDoProjectRegistration.sql - Cauught Exception in line(') + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage2 + CONVERT(VARCHAR,GETUTCDATE(),21)
		PRINT @ErrorMessage
		RAISERROR (@ErrorMessage,  @ErrorSeverity, @ErrorState);

	END CATCH
		
END