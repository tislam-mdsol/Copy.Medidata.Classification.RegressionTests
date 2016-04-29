IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGroupComponentUpdate')
	DROP PROCEDURE spCodingElementGroupComponentUpdate
GO

CREATE PROCEDURE dbo.spCodingElementGroupComponentUpdate 
(
	@CodingElementGroupComponentID BIGINT,
	@CodingElementGroupID BIGINT,
	@SupplementFieldKeyId INT, 
	@IsSupplement BIT, 
	@NameTextId INT,
	@CodeText NVARCHAR(50),
	@SearchType INT,
	@SearchOperator INT,
	
	@Created DATETIME,  
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE CodingElementGroupComponents
	SET
		CodingElementGroupID             = @CodingElementGroupID,  
		SupplementFieldKeyId             = @SupplementFieldKeyId,
		IsSupplement                     = @IsSupplement,
		NameTextId                       = @NameTextId,  
		CodeText                         = @CodeText,  
		SearchType                       = @SearchType,
		SearchOperator                   = @SearchOperator,
		Updated                          = @Updated
	 WHERE CodingElementGroupComponentID = @CodingElementGroupComponentID

END

GO