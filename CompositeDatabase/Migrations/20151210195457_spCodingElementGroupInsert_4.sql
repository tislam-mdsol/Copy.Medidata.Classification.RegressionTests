IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGroupInsert')
	DROP PROCEDURE spCodingElementGroupInsert
GO

CREATE PROCEDURE dbo.spCodingElementGroupInsert 
(
	@CodingElementGroupId BIGINT OUTPUT,  
	@MedicalDictionaryLevelKey NVARCHAR(100),
	@DictionaryLocale CHAR(3),  
	@CompSuppCount INT,
	@GroupVerbatimId INT,
	@Created DATETIME OUTPUT,  
	@Updated DATETIME OUTPUT,
	@SegmentId INT
)  
AS  
  
BEGIN  
	DECLARE @UtcDate DATETIME  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  

	INSERT INTO dbo.CodingElementGroups (  
		MedicalDictionaryLevelKey,  
		DictionaryLocale,
		CompSuppCount,
		GroupVerbatimId,
		SegmentId,
		Created,  
		Updated) 
	 VALUES (  
		@MedicalDictionaryLevelKey,  
		@DictionaryLocale,
		@CompSuppCount,
		@GroupVerbatimId,
		@SegmentId, 
		@UtcDate,  
		@UtcDate)
	 
	 SET @CodingElementGroupId = SCOPE_IDENTITY()  
END

GO