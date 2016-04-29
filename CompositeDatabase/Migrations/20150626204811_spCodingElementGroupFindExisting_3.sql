IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGroupFindExisting')
	DROP PROCEDURE spCodingElementGroupFindExisting
GO

CREATE PROCEDURE dbo.spCodingElementGroupFindExisting
(
	@GroupVerbatimId INT, 
	@MedicalDictionaryLevelKey NVARCHAR(100), 
	@DictionaryLocale CHAR(3), 
	@MedicalDictionaryKey NVARCHAR(100),
	@CompAndSupps BasicTermComponent_UDT READONLY,
	@SegmentID INT
)  
AS  
BEGIN  
	
	DECLARE @count INT
	
	SELECT @count = COUNT(*)
	FROM @CompAndSupps
	
	SELECT CEG.*
	FROM CodingElementGroups CEG

		-- TODO : investigate potentially faster ways to test existence
		CROSS APPLY 
		(
			SELECT MatchedCount = COUNT(*)
			FROM CodingElementGroupComponents CEGC
				JOIN @CompAndSupps TCT
					ON TCT.KeyID                  = CEGC.SupplementFieldKeyId
					AND TCT.StringId              = CEGC.NameTextId
					AND TCT.IsSupplement          = CEGC.IsSupplement
					AND CEGC.CodingElementGroupID = CEG.CodingElementGroupID
		) AS X

	WHERE 
		-- 1. match term values
		CEG.GroupVerbatimID               = @groupVerbatimId
		AND CEG.MedicalDictionaryKey      = @MedicalDictionaryKey
		AND CEG.MedicalDictionaryLevelKey = @MedicalDictionaryLevelKey
		AND CEG.DictionaryLocale          = @DictionaryLocale
		AND CEG.SegmentID                 = @SegmentId
		AND CEG.CompSuppCount             = @count
		-- 2. match counts
		AND @count                        = X.MatchedCount

END

GO
   