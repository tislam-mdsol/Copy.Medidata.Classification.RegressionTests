IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGroupInsert')
	DROP PROCEDURE spCodingElementGroupInsert
GO

CREATE PROCEDURE dbo.spCodingElementGroupInsert 
(
	@CodingElementGroupId BIGINT OUTPUT,  
	@MedicalDictionaryKey NVARCHAR(100),
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
		MedicalDictionaryKey,  
		MedicalDictionaryLevelKey,  
		DictionaryLocale,
		CompSuppCount,
		GroupVerbatimId,
		SegmentId,
		Created,  
		Updated,
		
		DictionaryId_BackUp --  Legacy, to remove
	 ) 
	 VALUES (  
		@MedicalDictionaryKey,  
		@MedicalDictionaryLevelKey,  
		@DictionaryLocale,
		@CompSuppCount,
		@GroupVerbatimId,
		@SegmentId, 
		@UtcDate,  
		@UtcDate,

		-1
	 )
	 
	 SET @CodingElementGroupId = SCOPE_IDENTITY()  
END

GO