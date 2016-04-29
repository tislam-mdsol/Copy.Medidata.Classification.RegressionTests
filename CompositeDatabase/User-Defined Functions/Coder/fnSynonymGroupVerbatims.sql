IF EXISTS (SELECT * FROM sysobjects WHERE name = 'fnSynonymGroupVerbatims')
	DROP FUNCTION dbo.fnSynonymGroupVerbatims
GO
CREATE FUNCTION dbo.fnSynonymGroupVerbatims
(
	@synonymListId INT,
	@statusId INT,
	@IsAutoApproval BIT,
	@ForcePrimaryPath BIT
)
RETURNS table
AS
RETURN
(

	SELECT 
		S.*,
		G.GroupVerbatimId
	FROM SegmentedGroupCodingPatterns S
		JOIN CodingElementGroups G
			ON S.CodingElementGroupID = G.CodingElementGroupID
			AND S.SynonymManagementID = @synonymListId
			AND (
				--status dropdown All(-1), Provisional(0), Synonym(1)
					(@statusId in (-1, 1) AND S.SynonymStatus = 2)
				OR
					(@statusId in (-1, 0) AND S.SynonymStatus = 1)
				)
		JOIN CodingPatterns CP
			ON S.CodingPatternID = CP.CodingPatternID
			AND (
						(@IsAutoApproval = 1 AND CP.PathCount <> 1 AND @ForcePrimaryPath=0 )
						OR 
						@IsAutoApproval = 0
						OR 
						S.IsExactMatch = 0
					)
)
GO