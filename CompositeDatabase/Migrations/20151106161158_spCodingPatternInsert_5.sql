
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
	SELECT
		@CodingPath,
		@MedicalDictionaryLevelKey,
		@PathCount,
		@UtcDate,  

		-- TODO: remove
		'', 0, ''
	 WHERE
		NOT EXISTS
		(SELECT NULL FROM dbo.CodingPatterns WITH (UPDLOCK, HOLDLOCK)
		WHERE CodingPath=@CodingPath
		AND MedicalDictionaryLevelKey = @MedicalDictionaryLevelKey)
	 
	 SELECT @CodingPatternID = cp.CodingPatternID
		, @Created = cp.Created
	 FROM dbo.CodingPatterns as cp
		WHERE CodingPath=@CodingPath
		AND MedicalDictionaryLevelKey = @MedicalDictionaryLevelKey
 
END

GO