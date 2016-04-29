IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternGetByGroup_CRI')
	DROP PROCEDURE spSegmentedGroupCodingPatternGetByGroup_CRI
GO

CREATE PROCEDURE dbo.spSegmentedGroupCodingPatternGetByGroup_CRI 
(
	@SynonymListID BIGINT,
	@CodingElementGroupId BIGINT,
	@CodingPatternID BIGINT
)  
AS  
BEGIN

	SELECT * 
	FROM SegmentedGroupCodingPatterns
	WHERE CodingElementGroupId = @CodingElementGroupId
		AND SynonymManagementID = @SynonymListID
		AND CodingPatternID = @CodingPatternID
		AND Active = 1

END

GO   
