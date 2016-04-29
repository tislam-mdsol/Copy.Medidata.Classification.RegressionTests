
/*
	spCoder_CMP_ChangeSegmentNameAndOID

	unique constraints on SegmentName and OID prevent the creation of duplicate values for these columns

*/

/*
begin transaction
EXEC spCoder_CMP_ChangeSegmentNameAndOID 'CHUGAI-PMS_BCK', 'CHUGAI-PMS_BCK'
select * from segments where segmentname = 'CHUGAI-PMS_BCK'
rollback

begin transaction
EXEC spCoder_CMP_ChangeSegmentNameAndOID 'Cubist2-Inc', 'CHUGAI-PMS_BCK''
EXEC spCoder_CMP_ChangeSegmentNameAndOID 'CHUGAI-PMS_BCK', 'CHUGAI-PMS_BCK'
select * from segments where segmentname = 'CHUGAI-PMS_BCK'
rollback
 
*/

if OBJECT_ID('dbo.spCoder_CMP_ChangeSegmentNameAndOID') is not null
	DROP PROCEDURE dbo.spCoder_CMP_ChangeSegmentNameAndOID
go
CREATE PROCEDURE dbo.spCoder_CMP_ChangeSegmentNameAndOID
(
	@OriginalSegmentName NVARCHAR(255),
	@UpdatedSegmentName NVARCHAR(255)
)
AS
BEGIN

    DECLARE @SegmentId INT
	DECLARE @errorString NVARCHAR(MAX)

	IF (1 < (SELECT COUNT(*)
		FROM Segments
		WHERE SegmentName = @OriginalSegmentName))
	BEGIN
		SET @errorString = N'ERROR: More than one segment found!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	SELECT  @SegmentId = SegmentId
	FROM    Segments
	WHERE   SegmentName = @OriginalSegmentName
  
	IF (@segmentId IS NULL)
	BEGIN
		SET @errorString = N'ERROR: No such segment found!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	UPDATE Segments SET 
		SegmentName = @UpdatedSegmentName,
		OID = replace(upper(@UpdatedSegmentName), ' ', '_')
	WHERE  SegmentId   = @SegmentId

	SELECT SegmentName, OID
	FROM   Segments
	WHERE  SegmentId   = @SegmentId

END