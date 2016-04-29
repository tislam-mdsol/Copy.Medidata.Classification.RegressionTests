IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentUpdate')
	DROP PROCEDURE spSegmentUpdate
GO

CREATE PROCEDURE dbo.spSegmentUpdate 
(
	@SegmentID INT,
	@OID VARCHAR(50),
	@Deleted BIT,
	@Active BIT,
	@SegmentName NVARCHAR(510),
	@UserDeactivated BIT,
	@IMedidataId NVARCHAR(100),

	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE Segments
	SET
		OID = @OID,
		Deleted = @Deleted,
		Active = @Active,
		SegmentName = @SegmentName,
		UserDeactivated = @UserDeactivated,
		IMedidataId = @IMedidataId,
		Updated = @Updated
	 WHERE SegmentID = @SegmentID

END

GO  