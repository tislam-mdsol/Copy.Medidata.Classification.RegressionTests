IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternLoadByCodingPatternAndList')
	DROP PROCEDURE spSegmentedGroupCodingPatternLoadByCodingPatternAndList
GO

CREATE PROCEDURE dbo.spSegmentedGroupCodingPatternLoadByCodingPatternAndList
(
	@CodingPatternID BIGINT,
	@SynonymManagementID INT,
	@IsAutoApproval BIT,
	@ForcePrimaryPath BIT,
	@SegmentID INT
)  
AS  
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    DECLARE @codingPathCount INT

    SELECT @codingPathCount = PathCount
    FROM CodingPatterns
    WHERE CodingPatternID = @CodingPatternID

	SELECT S.*
	FROM SegmentedGroupCodingPatterns S
	WHERE S.CodingPatternID = @CodingPatternID
		AND SynonymManagementID = @SynonymManagementID
        AND S.SegmentID = @SegmentID
		AND S.Active = 1
		AND dbo.fnIsValidForAutoCodeIncludingProvisional(@IsAutoApproval, @ForcePrimaryPath, S.IsExactMatch, S.SynonymStatus, @codingPathCount) = 1

END

GO   
