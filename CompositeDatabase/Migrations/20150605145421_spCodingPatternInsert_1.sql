
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingPatternInsert')
	DROP PROCEDURE spCodingPatternInsert
GO

CREATE PROCEDURE dbo.spCodingPatternInsert 
(
	@CodingPatternID INT OUTPUT,  
	
	@CodingPath VARCHAR(MAX),
	@DictionaryLevelID SMALLINT,
	@PathCount INT,
	@VersionId INT,
	@Locale CHAR(3),
	@Created DATETIME OUTPUT
)  
AS  
  
BEGIN  
	DECLARE @UtcDate DATETIME  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate

	INSERT INTO dbo.CodingPatterns (  
		CodingPath,
		LevelID,
		PathCount,
		Created,  
		VersionId,
		Locale  
	 ) 
	 VALUES (  
		@CodingPath,
		@DictionaryLevelID,
		@PathCount,
		@UtcDate,  
		@VersionId,
		@Locale
	 )
	 
	 SET @CodingPatternID = SCOPE_IDENTITY()  
END

GO