IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingSourceTermSupplementalInsert')
	DROP PROCEDURE spCodingSourceTermSupplementalInsert
GO

CREATE PROCEDURE dbo.spCodingSourceTermSupplementalInsert 
(
	@SourceTermSupplementalId BIGINT OUTPUT,  
	
	@CodingSourceTermID BIGINT,
	@SupplementalValue NVARCHAR(1000),
	@SupplementTermKey NVARCHAR(100),
	@Ordinal INT,
	@IsComponent BIT,
		
	@SegmentId INT,
	
	@Created DATETIME OUTPUT,  
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  
	DECLARE @UtcDate DATETIME  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  

	INSERT INTO dbo.CodingSourceTermSupplementals (
		CodingSourceTermID,
		SupplementalValue,
		SupplementTermKey,
		Ordinal,
		IsComponent,
	
		SegmentId,
		Created,  
		Updated  
	 ) 
	 VALUES ( 
		@CodingSourceTermID,
		@SupplementalValue,
		@SupplementTermKey,
		@Ordinal,
		@IsComponent,
		
		@SegmentId,
		@UtcDate,  
		@UtcDate  
	 )
	 
	 SET @SourceTermSupplementalId = SCOPE_IDENTITY()  
END

GO  