IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationTypeUpdate')
	DROP PROCEDURE spApplicationTypeUpdate
GO

CREATE PROCEDURE dbo.spApplicationTypeUpdate 
(
	@ApplicationTypeID INT,
	@IMedidataId NVARCHAR(50),
	@Name NVARCHAR(256),
	@IsCoderAppType BIT,
	@IsAlwaysBypassTransmit BIT,
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE ApplicationType
	SET
		IMedidataId = @IMedidataId,  
		Name = @Name,
		IsCoderAppType = @IsCoderAppType,
		IsAlwaysBypassTransmit = @IsAlwaysBypassTransmit,
		Updated = @Updated
	 WHERE ApplicationTypeID = @ApplicationTypeID

END

GO