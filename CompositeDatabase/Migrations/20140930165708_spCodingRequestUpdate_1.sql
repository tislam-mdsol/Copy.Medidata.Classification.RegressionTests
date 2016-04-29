IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingRequestUpdate')
	DROP PROCEDURE spCodingRequestUpdate
GO
create procedure dbo.spCodingRequestUpdate
(
	@CodingRequestId bigint,

	@RequestState TINYINT,
	@SourceSystemId int,
	@CreationDateTime datetime,
	@ReferenceNumber char(36),
	@FileOID nvarchar(500),
	@XmlContent ntext,
	@BatchOID NVARCHAR(500),
	@IsXmlCompressed BIT,
	@Created datetime,
	@SegmentId int,

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
		--SourceSystemId = @SourceSystemId, 
		--SegmentId = @SegmentId, 
		--CreationDateTime = @CreationDateTime, 
		--ReferenceNumber = @ReferenceNumber, 
		--FileOID = @FileOID, 
		--XmlContent = @XmlContent, 
		--BatchOID = @BatchOID, 
		--Created = @UtcDate
	WHERE CodingRequestId = @CodingRequestId

end
go
 