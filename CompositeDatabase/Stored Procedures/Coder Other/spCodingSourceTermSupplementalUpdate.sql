IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingSourceTermSupplementalUpdate')
	DROP PROCEDURE spCodingSourceTermSupplementalUpdate
GO

CREATE PROCEDURE dbo.spCodingSourceTermSupplementalUpdate 
(
	@SourceTermSupplementalId BIGINT, 
	
	@CodingSourceTermID BIGINT,
	@SupplementalValue NVARCHAR(1000),
	@SupplementTermKey NVARCHAR(100),
	@Ordinal INT,
	@IsComponent BIT,
	
	@SegmentId INT,
	@Created DATETIME,  
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GETUTCDATE()  

	UPDATE CodingSourceTermSupplementals
	SET
		CodingSourceTermID          = @CodingSourceTermID,
		SupplementalValue           = @SupplementalValue,
		SupplementTermKey           = @SupplementTermKey,
		Ordinal                     = @Ordinal,	
		IsComponent                 = @IsComponent,
		--SegmentId                 = @SegmentId,
		Updated                     = @Updated
	 WHERE SourceTermSupplementalId = @SourceTermSupplementalId

END

GO  