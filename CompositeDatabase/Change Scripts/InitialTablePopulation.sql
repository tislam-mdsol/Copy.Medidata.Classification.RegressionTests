-- reserve the first 10 segmentIds for development purposes

IF NOT EXISTS (SELECT NULL FROM Segments)
BEGIN
	DECLARE @IndexSeg INT
	
	SET @IndexSeg = 1
	
	DECLARE @SegmentBase VARCHAR(50), @SegmentReal VARCHAR(100), @SegmentIndex VARCHAR(5)
	SET @SegmentBase = 'MedidataReserved'

	SET IDENTITY_INSERT Segments ON
	
	WHILE (@IndexSeg <= 10)
	BEGIN

		SET @SegmentIndex = CAST(@IndexSeg AS VARCHAR)
		SET @SegmentReal = @SegmentBase + @SegmentIndex

		INSERT INTO Segments (SegmentID, SegmentName, OID, Active, Deleted, IMedidataId) 
		VALUES(@IndexSeg, @SegmentReal, @SegmentReal, 1, 0, @SegmentIndex)
	
		SET @IndexSeg = @IndexSeg + 1
	END
	
	SET IDENTITY_INSERT Segments OFF
END
GO

IF NOT EXISTS (SELECT NULL FROM Configuration
	WHERE Tag = 'DatabaseVersion' )
	INSERT INTO Configuration (Tag, ConfigValue, SegmentId)
	VALUES('DatabaseVersion', '1.0.0', 1)
GO

