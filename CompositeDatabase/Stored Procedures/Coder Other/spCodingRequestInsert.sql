IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingRequestInsert')
	DROP PROCEDURE spCodingRequestInsert
GO
create procedure dbo.spCodingRequestInsert
(
	@RequestState TINYINT,
	@SourceSystemId int,
	@CreationDateTime datetime,
	@ReferenceNumber char(36),
	@FileOID nvarchar(500),
	@XmlContent ntext,
	@BatchOID NVARCHAR(500),
	@IsXmlCompressed BIT,
	@Created datetime output,
	@Updated datetime output,
	@CodingRequestId bigint output,
	@SegmentId int
)
as
begin
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SELECT @Created = @UtcDate, @Updated = @UtcDate

	insert into CodingRequests(RequestState, SourceSystemId, SegmentId, CreationDateTime, ReferenceNumber, FileOID, XmlContent, BatchOID, IsXmlCompressed, Created, Updated)
	Values(@RequestState, @SourceSystemId, @SegmentId, @CreationDateTime, @ReferenceNumber, @FileOID, @XmlContent, @BatchOID, @IsXmlCompressed, @UtcDate, @UtcDate)

	SET @CodingRequestId = SCOPE_IDENTITY()

end
go
 