
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternExist')
	DROP PROCEDURE dbo.spSegmentedGroupCodingPatternExist
GO
CREATE PROCEDURE [dbo].spSegmentedGroupCodingPatternExist
(
	@synonymListId INT,
	@IsAutoApproval BIT,
	@ForcePrimaryPath BIT,
	@terms dbo.TermBase_UDT READONLY
)
AS
BEGIN
	SELECT CP.*
	FROM @terms T
		JOIN CodingPatterns CP
			ON T.LevelKey = CP.MedicalDictionaryLevelKey
			AND T.TermPath = CP.CodingPath
		JOIN SegmentedGroupCodingPatterns S
			ON CP.CodingPatternID = S.CodingPatternID
			AND S.SynonymManagementID = @synonymListId
			AND dbo.fnIsValidForAutoCode(@IsAutoApproval, @ForcePrimaryPath, S.IsExactMatch, S.SynonymStatus, CP.PathCount) = 1

END