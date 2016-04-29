
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoProjectRegistration')
	DROP PROCEDURE spDoProjectRegistration
GO

-- spDoProjectRegistration 'Mediflexs11', 'Mediflex11', 'MedDRA-11.0-English'
CREATE PROCEDURE dbo.spDoProjectRegistration  
(  
 @Project NVARCHAR(500),
 @Segment NVARCHAR(500),
 @MedicalDictionaryVersionLocaleKey NVARCHAR(100),
 @SynonymListName NVARCHAR(100),
 @DictionaryRegistration NVARCHAR(100)
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

	IF (ISNULL(@DictionaryRegistration, '') = '')
	BEGIN
		PRINT N'Empty Dictionary registration not allowed'  
		RETURN 1  
	END

	DECLARE @segmentID INT, @projectID INT, @synonymListId INT

	SELECT @segmentID = SegmentId  
	FROM Segments  
	WHERE OID = @Segment 

	IF @segmentID IS NULL  
	BEGIN  
		PRINT N'Cannot find Segment OID'  
		RETURN 1  
	END
	-- 0. verify dictionary is available
	SELECT @synonymListId                     = SynonymMigrationMngmtID 
	FROM SynonymMigrationMngmt
	WHERE SegmentId                           = @segmentID
		And MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey
		AND SynonymMigrationStatusRID         = 6
		AND ListName                          = @SynonymListName
	
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
		INSERT INTO ProjectDictionaryRegistrations (StudyProjectID, SegmentID, UserID, InteractionId, ProjectRegistrationTransmissionId, SynonymManagementID, RegistrationName)
		VALUES(@projectID, @segmentID, -2, -1, 0, @synonymListId, @DictionaryRegistration)

		-- 3. Study Registrations
		INSERT INTO StudyDictionaryVersion  
			( SegmentID,   
			StudyID,   
			SynonymManagementID, 
			KeepCurrentVersion,   
			NumberOfMigrations, 
			RegistrationName)  
		SELECT  
			@SegmentID,  
			T.TrackableObjectId,
			@synonymListId,
			0,  
			0,
			@DictionaryRegistration  
		FROM TrackableObjects T
			LEFT JOIN StudyDictionaryVersion SDV
				ON T.TrackableObjectId = SDV.StudyId
			LEFT JOIN SynonymMigrationMngmt SMM
				ON SMM.SynonymMigrationMngmtID = SDV.SynonymManagementID
				AND SMM.MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey
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