IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingJobErrorInsert')
	DROP PROCEDURE spCodingJobErrorInsert
GO

CREATE PROCEDURE dbo.spCodingJobErrorInsert 
(
	@CodingJobErrorId BIGINT OUTPUT,  
	@CodingRequestId INT,
	@JobString NVARCHAR(MAX),
	@ErrorString NVARCHAR(MAX),
	@Created DATETIME OUTPUT
)  
AS  
  
BEGIN  
	DECLARE @UtcDate DATETIME  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate

	INSERT INTO dbo.CodingJobErrors (  
		CodingRequestId,
		JobString,
		ErrorString,
		Created
	 ) 
	 VALUES (  
		@CodingRequestId,
		@JobString,
		@ErrorString,
		@UtcDate
	 )

	 SET @CodingJobErrorId = SCOPE_IDENTITY()  
END

GO