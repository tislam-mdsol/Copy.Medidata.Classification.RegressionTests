IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationUpdate')
	DROP PROCEDURE spApplicationUpdate
GO

CREATE PROCEDURE dbo.spApplicationUpdate 
(
	@ApplicationID INT,
	@UUID NVARCHAR(255),
	@ApiID NVARCHAR(256),
	@Name NVARCHAR(256),
	@BaseUrl NVARCHAR(2000),
	@PublicKey NVARCHAR(500),
	@ApplicationTypeID INT,
	@IsAlwaysBypassTransmit BIT,
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE Application
	SET
		UUID = @UUID,
		ApiID = @ApiID,  
		Name = @Name,  
		BaseUrl = @BaseUrl,  
		PublicKey = @PublicKey,
		ApplicationTypeID = @ApplicationTypeID,
		Updated = @Updated,
		IsAlwaysBypassTransmit = @IsAlwaysBypassTransmit
	 WHERE ApplicationID = @ApplicationID

END

GO