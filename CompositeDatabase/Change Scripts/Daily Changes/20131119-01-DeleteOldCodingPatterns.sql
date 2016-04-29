DECLARE @cpTypeID INT

SELECT @cpTypeID = ObjectTypeID 
FROM ObjectTypeR
WHERE ObjectTypeName = 'CodingPattern'

IF (@cpTypeID IS NOT NULL)
BEGIN

	BEGIN TRANSACTION
	BEGIN TRY

		-- delete already noted migration details
		DELETE dmd
		FROM CodingPatterns cp
			LEFT JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.CodingPatternID = cp.CodingPatternID
			JOIN DataMigrationDetails dmd
				ON dmd.ObjectID = cp.CodingPatternID
				AND dmd.ObjectTypeID = @cpTypeID
		WHERE SGCP.CodingPatternID IS NULL

		-- DELETE unreferenced CodingPatterns
		DELETE cp
		FROM CodingPatterns cp
			LEFT JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.CodingPatternID = cp.CodingPatternID
		WHERE SGCP.CodingPatternID IS NULL

		COMMIT TRANSACTION
	
	END TRY
	BEGIN CATCH

		ROLLBACK TRANSACTION
		RAISERROR('Failed to delete unreferenced CodingPatterns', 1, 16)
	
	END CATCH

END
ELSE
BEGIN
		RAISERROR('Could not resolve ObjectTypeID for CodingPattern', 1, 16)
END