IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymLoadBySynonymList_CRI')
	DROP PROCEDURE spSynonymLoadBySynonymList_CRI
GO

CREATE PROCEDURE dbo.spSynonymLoadBySynonymList_CRI
(
	@SynonymListId INT
)  
AS  
BEGIN

    SELECT CP.CodingPath, SGCP.CodingElementGroupID,SGCP.IsExactMatch, 
	SGCP.SegmentID,SGCP.SynonymStatus,SGCP.UserId, SGCP.SegmentedGroupCodingPatternID,
	SGCP.SynonymManagementId


	FROM SegmentedGroupCodingPatterns SGCP
	JOIN CodingPatterns CP On SGCP.CodingPatternID =CP.CodingPatternId
	WHERE SynonymManagementID = @SynonymListId		
		AND Active = 1
		AND SynonymStatus > 0
	ORDER BY SegmentedGroupCodingPatternID ASC
END

GO   