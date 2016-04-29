/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
// 1. Find the affected Verbatims (ENG, JPN)
// 2. Find whether (when fixed) they merge with existing Verbatims or the ones merge within themselves
// 3. If single VerbatimText generated - do an inplace update and ignore the rest
// 4. If multiple, proceed into CodingGroupElement analysis
// 5. Find if because of multiple Verbatims merge, then multiple CodingElementGroups would have to merge
// 6. If yes, note them down
// 7. Find if because of multiple CodingElementGroups then multiple SegmentGroupCodingPatterns would have to merge
// 8. If yes, note them down
// 9. Find if because of multiple SegmentGroupCodingPatterns then conflicts exist in the CodingPatterns they target
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGroupConflicts')
	DROP PROCEDURE spGroupConflicts
GO

CREATE PROCEDURE dbo.spGroupConflicts
(
	@Success BIT OUTPUT
)
AS
BEGIN

	SET @Success = 0

	-- do the group verbatim analysis
	EXEC spGroupVerbatimAnalysis

	IF NOT EXISTS (SELECT NULL FROM VerbatimIdsEng)
		AND NOT EXISTS (SELECT NULL FROM VerbatimIdsJpn)
	BEGIN
		PRINT N'No merge need found at the GroupVerbatim Level - in place updates (or nothing) is all that is necessary'
		RETURN
	END

	-- do the group analysis
	EXEC spGroupAnalysis

	IF NOT EXISTS (SELECT NULL FROM AffectedGroups)
	BEGIN
		PRINT N'No merge need found at the CodingElementGroups Level - in place updates (or nothing) is all that is necessary'
		RETURN
	END
	
	-- do the automation analysis
	EXEC spAutomationAnalysis

	IF NOT EXISTS (SELECT NULL FROM AffectedSynonyms)
	BEGIN
		PRINT N'No merge need found at the SegmentedGroupCodingPatterns Level - in place updates (or nothing) is all that is necessary'
		SET @Success = 1
		RETURN
	END

	PRINT N'Automation Merge Conflicts found - data dump follows'

	SELECT sg.OID, smm.ListName, dr.OID, dvr.OID, ceg.DictionaryLocale, CEG_Fin.TextId, ISNULL(M.list, '') AS ComponentSupplements
	FROM AffectedSynonyms afs
		JOIN SynonymMigrationMngmt smm
			ON afs.ListId = smm.SynonymMigrationMngmtID
		JOIN segments sg
			ON smm.SegmentID = sg.SegmentId
		JOIN DictionaryVersionRef dvr
			ON dvr.DictionaryVersionRefID = smm.DictionaryVersionId
		JOIN DictionaryRef dr
			ON dr.DictionaryRefID = dvr.DictionaryRefID
		JOIN SegmentedGroupCodingPatterns sgcp
			ON sgcp.SegmentedGroupCodingPatternID = afs.SGCPId
		JOIN CodingElementGroups ceg
			ON sgcp.CodingElementGroupID = ceg.CodingElementGroupID
		CROSS APPLY
		(
			SELECT MIN(ISNULL(VerbatimText, '')) AS TextId
			FROM GroupVerbatimEng
			WHERE CEG.DictionaryLocale = 'eng'
				AND GroupVerbatimID = CEG.GroupVerbatimID
		) AS CEG_ENG
		CROSS APPLY
		(
			SELECT MIN(ISNULL(VerbatimText, '')) AS TextId
			FROM GroupVerbatimJpn
			WHERE CEG.DictionaryLocale = 'jpn'
				AND GroupVerbatimID = CEG.GroupVerbatimID
		) AS CEG_JPN
		-- find the correct (new or existing) verbatim id
		CROSS APPLY
		(
			SELECT
				CASE WHEN CEG.DictionaryLocale = 'jpn' THEN 
					CEG_JPN.TextId
					ELSE 
					CEG_ENG.TextId
				END AS TextId
		) AS CEG_Fin
		CROSS APPLY 
		(
			SELECT 
				'|' + CAST(CEGC.IsSupplement AS VARCHAR) + '|' +
				CAST(FType.TextKey AS VARCHAR) + '|' +
				CAST(CEGC_Fin.TextId AS VARCHAR)
			FROM CodingElementGroupComponents CEGC
				-- CEGC problematic ones
				CROSS APPLY
				(
					SELECT MIN(ISNULL(VerbatimText, '')) AS TextId
					FROM GroupVerbatimEng
					WHERE CEG.DictionaryLocale = 'eng'
						AND GroupVerbatimID = CEGC.NameTextID
				) AS CEGC_ENG
				CROSS APPLY
				(
					SELECT MIN(ISNULL(VerbatimText, '')) AS TextId
					FROM GroupVerbatimJpn
					WHERE CEG.DictionaryLocale = 'jpn'
						AND GroupVerbatimID = CEGC.NameTextID
				) AS CEGC_JPN
				-- find the correct (new or existing) verbatim id
				CROSS APPLY
				(
					SELECT
						CASE WHEN CEG.DictionaryLocale = 'jpn' THEN 
							CEGC_JPN.TextId
							ELSE 
							CEGC_ENG.TextId
						END AS TextId
				) AS CEGC_Fin								
				CROSS APPLY
				(
					SELECT MIN(OID) AS OID
					FROM DictionaryComponentTypeRef DCTR
					WHERE DCTR.DictionaryComponentTypeRefID = CEGC.ComponentTypeID
						AND CEGC.IsSupplement = 0
				) CType
				CROSS APPLY
				(
					SELECT MIN(SFK.KeyField) AS KeyField
					FROM SupplementFieldKeys SFK
					WHERE SFK.SupplementFieldKeyId = CEGC.ComponentTypeID
						AND CEGC.IsSupplement = 1
				) SType
				CROSS APPLY
				(
					SELECT
						CASE WHEN CEGC.IsSupplement = 1 THEN SType.KeyField
							ELSE CType.OID
						END AS TextKey				
				) FType
			WHERE CEGC.CodingElementGroupID = CEG.CodingElementGroupID
				--AND CEG.CompSuppCount > 0
			ORDER BY CEGC.IsSupplement, CEGC.ComponentTypeID, CEGC.NameTextID
			FOR XML PATH('')
		) M (list)
	ORDER BY sg.SegmentId, dr.DictionaryRefID, dvr.DictionaryVersionRefID, afs.listid, afs.targetid

	SELECT ListId, COUNT(*) AS ConflictingSynonymPairs
	FROM AffectedSynonyms
	GROUP BY ListId

END 

