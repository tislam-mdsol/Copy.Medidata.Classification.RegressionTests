IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCreateDefaultTemplateForMedDRA')
	DROP PROCEDURE dbo.[spCreateDefaultTemplateForMedDRA]
GO

CREATE PROCEDURE [dbo].spCreateDefaultTemplateForMedDRA
(
	@segmentId INT,
	@dictionaryRefId INT
)
AS
BEGIN

	SET XACT_ABORT ON

	DECLARE
		@templateName NVARCHAR(100),
		@reverseTemplateName NVARCHAR(100)

	SELECT
		@templateName = 'SOC-PT-LLT',
		@reverseTemplateName = 'LLT-PT-SOC'

	DECLARE @errorString NVARCHAR(4000)
	DECLARE @templateId INT, @reverseTemplateId INT
	DECLARE @isDefault BIT = 1


	-- Insert reverse template name for other locales

	IF EXISTS (
		SELECT NULL 
		FROM SegmentMedicalDictionaryTemplates t
			JOIN Segments s 
				ON t.SegmentId = s.SegmentID 
		WHERE T.SegmentID = @segmentId 
			AND MedicalDictionaryId=@dictionaryRefId 
			AND t.TokenString IN (@templateName, @reverseTemplateName)
			) 
	BEGIN
		PRINT N'Template: [' + @templateName + N'] already exist for Segment: [' + CAST(@segmentId AS NVARCHAR) + N' and Dictionary: [' + CAST(@dictionaryRefId AS NVARCHAR) + N'] in the system.'
		RETURN
	END	

	DECLARE @levelsForTemplate TABLE(Ordinal INT, DictionaryLevelId INT)

	-- make sure we can find LLT, PT & SOC
	INSERT INTO @levelsForTemplate (Ordinal, DictionaryLevelId)
	SELECT Ordinal, DictionaryLevelRefID
	FROM DictionaryLevelRef
	WHERE DictionaryRefID = @dictionaryRefId
		AND OID IN ('SOC', 'PT', 'LLT')

	IF (3 <> (SELECT COUNT(*) FROM @levelsForTemplate))
	BEGIN
		PRINT N'Could not find (LLT, PT, SOC) levels for Dictionary: [' + CAST(@dictionaryRefId AS NVARCHAR) + N'].'
		RETURN
	END

	BEGIN TRANSACTION
	BEGIN TRY

		-- Create Forward Template as default
		INSERT INTO [dbo].[SegmentMedicalDictionaryTemplates]([TokenString],[SegmentId],[MedicalDictionaryId],[IsDefault],IsReverse)
		VALUES(@templateName, @segmentId, @dictionaryRefId, @isDefault, 0)

		SET @templateId = scope_identity()

		INSERT INTO [dbo].[MedicalDictionaryTemplateLevel]([TemplateId],[DictionaryLevelId],[Ordinal])
		SELECT @templateId, DictionaryLevelId, Ordinal 
		FROM @levelsForTemplate	

		INSERT INTO [dbo].[SegmentMedicalDictionaryTemplates]([TokenString],[SegmentId],[MedicalDictionaryId],[IsDefault],IsReverse)
		VALUES(@reverseTemplateName, @segmentId, @dictionaryRefId, 0, 1) -- not default template

		SET @reverseTemplateId = scope_identity()

		DECLARE @maxOrdinal INT

		SELECT @maxOrdinal = MAX(Ordinal) 
		FROM @levelsForTemplate 
	
		INSERT INTO [dbo].[MedicalDictionaryTemplateLevel]([TemplateId],[DictionaryLevelId],[Ordinal])
		SELECT @reverseTemplateId, DictionaryLevelId, (@maxOrdinal - Ordinal + 1) 
		FROM @levelsForTemplate

		COMMIT TRANSACTION

	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION

		DECLARE	@ErrorSeverity int, 
				@ErrorState int,
				@ErrorLine int,
				@ErrorMessage nvarchar(4000),
				@ErrorProc nvarchar(4000)

		SELECT @ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE(),
				@ErrorLine = ERROR_LINE(),
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorProc = ERROR_PROCEDURE()

		SELECT @ErrorMessage = coalesce(@ErrorProc, 'spCreateDefaultTemplate.sql') + ' (' + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage
		raiserror (@ErrorMessage,  @ErrorSeverity, @ErrorState);
	END catch

END
GO