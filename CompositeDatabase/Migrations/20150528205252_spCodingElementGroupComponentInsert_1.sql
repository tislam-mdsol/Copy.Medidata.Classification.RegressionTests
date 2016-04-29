IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGroupComponentInsert')
	DROP PROCEDURE spCodingElementGroupComponentInsert
GO

CREATE PROCEDURE dbo.spCodingElementGroupComponentInsert 
(
	@CodingElementGroupComponentID BIGINT OUTPUT,  
	@CodingElementGroupID BIGINT,  
	@SupplementFieldKeyId INT, 
	@IsSupplement BIT, 
	@NameTextId INT,
	@CodeText NVARCHAR(50),  
	@SearchType INT,
	@SearchOperator INT,	
	
	@Created DATETIME OUTPUT,  
	@Updated DATETIME OUTPUT
)  
AS  
BEGIN

	DECLARE @UtcDate DATETIME  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, 
		@Updated = @UtcDate  

	INSERT INTO dbo.CodingElementGroupComponents (  
		CodingElementGroupID,
		SupplementFieldKeyId,
		IsSupplement,
		NameTextId,
		CodeText,
		SearchType,
		SearchOperator,

		Created,  
		Updated  
	 ) 
	 VALUES (  
		@CodingElementGroupID,
		@SupplementFieldKeyId,
		@IsSupplement,
		@NameTextId,
		@CodeText,
		@SearchType,
		@SearchOperator,

		@UtcDate,  
		@UtcDate  
	 )
	 
	 SET @CodingElementGroupComponentId = SCOPE_IDENTITY()
	 
END

GO