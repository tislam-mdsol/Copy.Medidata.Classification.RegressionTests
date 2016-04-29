IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymNumbersGetByListId')
	DROP PROCEDURE spSynonymNumbersGetByListId
GO

CREATE PROCEDURE dbo.spSynonymNumbersGetByListId(
	@SynonymListId INT,
	@ForcePrimaryPath BIT,
	@IsAutoApproval BIT
)
AS
BEGIN 

    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT TotalCount = COUNT(1)
	FROM SegmentedGroupCodingPatterns SGCP
		LEFT JOIN CodingPatterns CP
			ON SGCP.CodingPatternID = CP.CodingPatternID
			AND SGCP.IsExactMatch = 1
			AND (CP.PathCount = 1 OR @ForcePrimaryPath = 1)
	WHERE SGCP.SynonymManagementID = @SynonymListId
		AND SynonymStatus > 0
		AND (@IsAutoApproval = 0 OR CP.CodingPatternID IS NULL)	

END
GO
