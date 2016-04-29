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

	DECLARE @IsEnglish BIT
	
	IF EXISTS (SELECT NULL
		FROM SynonymMigrationMngmt 
		WHERE SynonymMigrationMngmtID = @SynonymManagementID
			AND CHARINDEX('English', MedicalDictionaryVersionLocaleKey) > 0) -- TODO : AV feed this as parameter - remove the logic from here
		SET @IsEnglish = 1
	ELSE
		SET @IsEnglish = 0
		

	IF (@IsEnglish = 1)
	BEGIN	
		SELECT S.*, L.VerbatimText AS Literal
		FROM SegmentedGroupCodingPatterns S
			JOIN CodingElementGroups G ON G.CodingElementGroupID = S.CodingElementGroupID
			JOIN GroupVerbatimEng L ON L.GroupVerbatimID = G.GroupVerbatimID
			JOIN CodingPatterns CP ON S.CodingPatternID = CP.CodingPatternID
		WHERE S.CodingPatternID = @CodingPatternID
			AND SynonymManagementID = @SynonymManagementID
			AND S.SegmentID = @SegmentID
			AND S.Active = 1
			AND dbo.fnIsValidForAutoCodeIncludingProvisional(@IsAutoApproval, @ForcePrimaryPath, S.IsExactMatch, S.SynonymStatus, CP.PathCount) = 1
			
	END
	ELSE
	BEGIN
		SELECT S.*, L.VerbatimText AS Literal
		FROM SegmentedGroupCodingPatterns S
			JOIN CodingElementGroups G ON G.CodingElementGroupID = S.CodingElementGroupID
			JOIN GroupVerbatimJpn L ON L.GroupVerbatimID = G.GroupVerbatimID
			JOIN CodingPatterns CP ON S.CodingPatternID = CP.CodingPatternID
		WHERE S.CodingPatternID = @CodingPatternID
			AND SynonymManagementID = @SynonymManagementID
			AND S.SegmentID = @SegmentID
			AND S.Active = 1
			AND dbo.fnIsValidForAutoCodeIncludingProvisional(@IsAutoApproval, @ForcePrimaryPath, S.IsExactMatch, S.SynonymStatus, CP.PathCount) = 1
	END

END

GO   
