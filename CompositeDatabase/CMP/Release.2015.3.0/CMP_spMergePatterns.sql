IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCMPMergePatterns')
	DROP PROCEDURE dbo.spCMPMergePatterns
GO

CREATE PROCEDURE dbo.spCMPMergePatterns
AS
BEGIN

	DECLARE @mergePatterns TABLE(NewCodingPatternId INT, OldCodingPatternId INT)

	;WITH newCodingPatterns AS
	(
		SELECT medicaldictionarylevelkey, codingpath, MIN(CodingPatternId) AS CodingPatternId -- pick this as the winner!
		FROM codingpatterns
		GROUP BY medicaldictionarylevelkey, codingpath
		HAVING COUNT(1) > 1
	),
	convergingPatterns AS
	(
		SELECT New_CP.CodingPatternId AS NewCodingPatternId, Old_CP.CodingPatternId AS OldCodingPatternId
		FROM newCodingPatterns New_CP
			JOIN CodingPatterns Old_CP
				ON Old_CP.Codingpath = New_CP.codingpath
				AND Old_CP.Medicaldictionarylevelkey = New_CP.medicaldictionarylevelkey
				AND Old_CP.CodingPatternId <> New_CP.CodingPatternId
	)

	INSERT INTO @mergePatterns(NewCodingPatternId, OldCodingPatternId)
	SELECT NewCodingPatternId, OldCodingPatternId
	FROM convergingPatterns

	UPDATE SGCP
	SET SGCP.CodingPatternID = MP.NewCodingPatternId
	FROM @mergePatterns MP
		JOIN SegmentedGroupCodingPatterns SGCP
			ON MP.OldCodingPatternId = SGCP.CodingPatternID

	DELETE CP
	FROM @mergePatterns MP
		JOIN CodingPatterns CP
			ON MP.OldCodingPatternId = CP.CodingPatternID


	IF EXISTS (SELECT NULL FROM sys.indexes
		WHERE name = 'UIX_NewCodingPatterns_Multi')
	BEGIN

		DROP INDEX [CodingPatterns].[UIX_NewCodingPatterns_Multi]

		CREATE UNIQUE NONCLUSTERED INDEX [UIX_NewCodingPatterns_Multi] ON [dbo].[CodingPatterns] 
		(
			CodingPath ASC,
			MedicalDictionaryLevelKey ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	END
END

GO  
