--Drop Dictionary Licence Information for dictionaries
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDictionarySubscriptionCleanup')
	DROP PROCEDURE [dbo].[spDictionarySubscriptionCleanup]
GO
CREATE PROCEDURE [dbo].[spDictionarySubscriptionCleanup]
(
	@SegmentOID VARCHAR(50)
)
AS
BEGIN 

	DECLARE @SegmentID INT
	
	SELECT @SegmentID = SegmentID
	FROM Segments
	WHERE OID = @SegmentOID
	
	IF (@SegmentID IS NULL)
		RETURN

	PRINT 'DictionaryLicenceInformations'	
	DELETE DictionaryLicenceInformations
	WHERE SegmentID=@SegmentID
				
	PRINT 'DictionaryVersionSubscriptions'			
	DELETE DictionaryVersionSubscriptions
    FROM DictionaryVersionSubscriptions DVS
    WHERE SegmentID = @SegmentID

END