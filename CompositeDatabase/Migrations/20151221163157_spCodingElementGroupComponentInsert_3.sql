IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGroupComponentInsert')
	DROP PROCEDURE spCodingElementGroupComponentInsert
GO

CREATE PROCEDURE dbo.spCodingElementGroupComponentInsert 
(
	@CodingElementGroupComponentID BIGINT OUTPUT,  
	@CodingElementGroupID BIGINT,  
	@SupplementFieldKeyId INT, 
	@NameTextId INT,
	
	@Created DATETIME OUTPUT
)  
AS  
BEGIN

	SELECT @Created = GETUTCDATE()

	INSERT INTO dbo.CodingElementGroupComponents (  
		CodingElementGroupID,
		SupplementFieldKeyId,
		NameTextId,
		Created 
	 ) 
	 VALUES (  
		@CodingElementGroupID,
		@SupplementFieldKeyId,
		@NameTextId,
		@Created  
	 )
	 
	 SET @CodingElementGroupComponentId = SCOPE_IDENTITY()
	 
END

GO