IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingRequestUpdate')
	DROP PROCEDURE spCodingRequestUpdate
GO
create procedure dbo.spCodingRequestUpdate
(
	@CodingRequestId bigint,
	@RequestState TINYINT,
	@XmlContent ntext,
	@IsXmlCompressed BIT,
	@Updated DATETIME OUTPUT
)
as
begin
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SELECT @Updated = @UtcDate

	UPDATE CodingRequests
	SET 
		RequestState	= @RequestState, 
		Updated			= @UtcDate,
		IsXmlCompressed = @IsXmlCompressed,
		XmlContent		= @XmlContent
	WHERE CodingRequestId = @CodingRequestId

end
go
 