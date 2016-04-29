IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternLoadChunkBySynonymList')
	DROP PROCEDURE spSegmentedGroupCodingPatternLoadChunkBySynonymList
GO

CREATE PROCEDURE dbo.spSegmentedGroupCodingPatternLoadChunkBySynonymList
(
	@SynonymManagementID BIGINT,
	@maxId BIGINT,
	@minId BIGINT,
	@IsAutoApproval BIT,
	@ForcePrimaryPath BIT
)  
AS  
BEGIN

	SELECT  SegmentedGroupCodingPatternID
	       ,CodingElementGroupID
	       ,SGCP.CodingPatternID
	       ,SegmentID
	       ,MatchPercent
	       ,Active
	       ,SGCP.Created SegmentedGroupCodingPatternCreated
	       ,SGCP.Updated SegmentedGroupCodingPatternUpdated
	       ,SynonymManagementID
	       ,CacheVersion
	       ,UserID
	       ,SynonymStatus
	       ,IsExactMatch
	       ,CodingPath
	       ,CP.Created CodingPatternCreated
	       ,CP.Created CodingPatternUpdated
	       ,PathCount 
	FROM SegmentedGroupCodingPatterns SGCP
		LEFT JOIN CodingPatterns CP
			ON SGCP.CodingPatternID = CP.CodingPatternID
			AND SGCP.IsExactMatch = 1
			AND (CP.PathCount = 1 OR @ForcePrimaryPath = 1)
	WHERE SynonymManagementID = @SynonymManagementID
		AND SegmentedGroupCodingPatternID > @minId
		AND SegmentedGroupCodingPatternID <= @maxId
		AND Active = 1
		AND SynonymStatus > 0
		AND (@IsAutoApproval = 0 OR CP.CodingPatternID IS NULL)

END

GO