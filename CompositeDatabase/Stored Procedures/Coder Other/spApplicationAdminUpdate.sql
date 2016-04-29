IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationAdminUpdate')
	DROP PROCEDURE spApplicationAdminUpdate
GO

CREATE PROCEDURE dbo.spApplicationAdminUpdate 
(
	@ApplicationAdminID INT,
	@ApplicationID INT,
	@IsCoderApp BIT,
	@IsCronEnabled BIT,
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE ApplicationAdmin
	SET
		ApplicationID = @ApplicationID,  
		IsCoderApp = @IsCoderApp,
		IsCronEnabled = @IsCronEnabled,
		Updated = @Updated
	 WHERE ApplicationAdminID = @ApplicationAdminID

END

GO