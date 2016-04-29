IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingResourceTransmissionUpdate')
	DROP PROCEDURE spCodingResourceTransmissionUpdate
GO

CREATE PROCEDURE dbo.spCodingResourceTransmissionUpdate 
(
	@CodingResourceTransmissionID INT,
	@Content NVARCHAR(max),
	@SourceSystemID INT,
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE CodingResourceTransmission
	SET
		Content = @Content,  
		SourceSystemID = @SourceSystemID,  
		Updated = @Updated
	 WHERE CodingResourceTransmissionID = @CodingResourceTransmissionID

END

GO
 