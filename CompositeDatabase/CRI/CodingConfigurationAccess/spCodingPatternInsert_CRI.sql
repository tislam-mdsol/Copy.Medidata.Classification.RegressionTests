
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingPatternInsert_CRI')
	DROP PROCEDURE spCodingPatternInsert_CRI
GO

CREATE PROCEDURE dbo.spCodingPatternInsert_CRI 
(
	@CodingPatternID INT OUTPUT,  
	@CodingPath VARCHAR(MAX),
	@PathCount INT,
	@Created DATETIME OUTPUT
)  
AS  
BEGIN 
 
	SET NOCOUNT ON

	DECLARE @UtcDate DATETIME

    DECLARE @fixedCodingPath VARCHAR(MAX) = REPLACE(@CodingPath, '%20', ' ')
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate
	 
	INSERT INTO dbo.CodingPatterns (  
		CodingPath,
		PathCount,
		Created
	 ) 
	SELECT
		@fixedCodingPath,
		@PathCount,
		@UtcDate
	 WHERE
		NOT EXISTS
		(
            SELECT NULL FROM dbo.CodingPatterns WITH (UPDLOCK, HOLDLOCK)
		    WHERE (CodingPath = @fixedCodingPath
	            OR CodingPath = @CodingPath)
        )

	 
	 SELECT @CodingPatternID = cp.CodingPatternID
		, @Created = cp.Created
	 FROM dbo.CodingPatterns as cp
     WHERE (CodingPath = @fixedCodingPath
	    OR CodingPath = @CodingPath)
 
END

GO