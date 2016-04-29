DECLARE @IsProduction BIT
SET @IsProduction = (SELECT TOP 1 IsProduction 
					FROM CoderAppConfiguration 
					WHERE ACTIVE=1)
--production check					
IF (@IsProduction = 0)
BEGIN
BEGIN TRY
	DECLARE @SegmentOID VARCHAR(50)
	DECLARE segment_cursor CURSOR FOR
	SELECT OID from Segments

	OPEN segment_cursor 
	FETCH NEXT FROM segment_cursor into @SegmentOID

	WHILE @@FETCH_STATUS =0
	BEGIN
		exec spCodingElementsCleanup @SegmentOID, 1,1,0
		exec spDictionarySubscriptionCleanup @SegmentOID
		FETCH NEXT FROM segment_cursor into @SegmentOID 
	END

	CLOSE segment_cursor
	DEALLOCATE segment_cursor 
END TRY
BEGIN CATCH
    IF CURSOR_STATUS('global','segment_cursor')>=-1
	BEGIN
		CLOSE segment_cursor
		DEALLOCATE segment_cursor
	END
	DECLARE @errorString NVARCHAR(MAX)
	SET @errorString = N'ERROR Segments Cleanup: Transaction Error Message - ' + ERROR_MESSAGE()
	PRINT @errorString
	RAISERROR(@errorString, 16, 1)
END CATCH
END