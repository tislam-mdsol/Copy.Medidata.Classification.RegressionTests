--spSynonymMigrationMgmntBySegmentDictLocaleVersion 'eng', 4, 1, 2, 5, 6, 1, 1, 1


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrationMgmntBySegmentDictLocaleVersion')
	DROP PROCEDURE spSynonymMigrationMgmntBySegmentDictLocaleVersion
GO

CREATE PROCEDURE dbo.spSynonymMigrationMgmntBySegmentDictLocaleVersion(
	@Locale CHAR(3),
	@versionId INT,
	@getCounts BIT,
	@IsAutoApproval BIT,
	@ForcePrimaryPath BIT,
	@SegmentID int
)
AS

	DECLARE @synLists TABLE(Id INT PRIMARY KEY, NumberOfSynonyms INT)
	
	INSERT INTO @synLists (Id)
	SELECT SynonymMigrationMngmtID
	FROM SynonymMigrationMngmt SMM
	WHERE SMM.DictionaryVersionId = @versionId
		AND @Locale = Locale
		AND @SegmentId = SegmentID
	
	-- compute counts	
	IF (@getCounts = 1)
	BEGIN
		
		-- NOTE : may become too slow
		UPDATE SL
		SET SL.NumberOfSynonyms = X.TotalCount
		FROM @synLists SL
			CROSS APPLY
			(
				SELECT TotalCount = COUNT(*)
				FROM SegmentedGroupCodingPatterns SGCP
					LEFT JOIN CodingPatterns CP
						ON SGCP.CodingPatternID = CP.CodingPatternID
						AND SGCP.IsExactMatch = 1
						AND (CP.PathCount = 1 OR @ForcePrimaryPath = 1)
				WHERE SGCP.SynonymManagementID = SL.Id
					AND SynonymStatus > 0
					AND (@IsAutoApproval = 0 OR CP.CodingPatternID IS NULL)
			) AS X

	END
	
	SELECT S.*,
		ISNULL(SL.NumberOfSynonyms, 0) AS NumberOfSynonyms
	FROM @synLists SL
		JOIN SynonymMigrationMngmt S
			ON S.SynonymMigrationMngmtID = SL.Id

GO  