
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingPatternInsert')
	DROP PROCEDURE spCodingPatternInsert
GO

CREATE PROCEDURE dbo.spCodingPatternInsert 
(
	@CodingPatternID INT OUTPUT,  
	@CodingPath VARCHAR(MAX),
	@MedicalDictionaryLevelKey NVARCHAR(100),
	@PathCount INT,
	@Created DATETIME OUTPUT
)  
AS  
  
BEGIN  
	DECLARE @UtcDate DATETIME  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate

	INSERT INTO dbo.CodingPatterns (  
		CodingPath,
		MedicalDictionaryLevelKey,
		PathCount,
		Created,  

		-- TODO : remove
		MedicalDictionaryVersionLocaleKey,
		DictionaryVersionId_Backup,
		DictionaryLocale_Backup
	 ) 
	 VALUES (  
		@CodingPath,
		@MedicalDictionaryLevelKey,
		@PathCount,
		@UtcDate,  

		-- TODO: remove
		'', 0, ''
	 )
	 
	 SET @CodingPatternID = SCOPE_IDENTITY()  
END

GO