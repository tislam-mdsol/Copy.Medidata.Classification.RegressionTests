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
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGroupAnalysis')
	DROP PROCEDURE spGroupAnalysis
GO

CREATE PROCEDURE dbo.spGroupAnalysis  
AS
BEGIN

	-- *** Find affected CodingElementGroupComponents ***
	;WITH xCEG
	AS
	(
		SELECT 
			CEG.CodingElementGroupId,
			-- massive key
			'|' + CAST(CEG_Fin.TextId AS VARCHAR) + '|' +
			CAST(MedicalDictionaryID AS VARCHAR) + '|' + 
			CAST(DictionaryLevelID AS VARCHAR) + '|' +
			CAST(DictionaryLocale AS VARCHAR) + '|' +
			CAST(SegmentID AS VARCHAR) + '|' +
			ISNULL(M.list, '') AS MassiveKey,
			SUM(1) OVER 
			(PARTITION BY 

				-- Unique Keys
				CEG_Fin.TextId,
				MedicalDictionaryID, DictionaryLevelID, DictionaryLocale, SegmentID,
				ISNULL(M.list, '')
			) AS SUMTotal
		FROM CodingElementGroups CEG
			CROSS APPLY 
			(
				SELECT 
					'|' + CAST(CEGC.IsSupplement AS VARCHAR) + '|' +
					CAST(CEGC.ComponentTypeID AS VARCHAR) + '|' +
					CAST(CEGC_Fin.TextId AS VARCHAR)
				FROM CodingElementGroupComponents CEGC
					-- CEGC problematic ones
					CROSS APPLY
					(
						SELECT ISNULL(MIN(TargetId), CEGC.NameTextID) AS TextId
						FROM VerbatimIdsEng
						WHERE CEG.DictionaryLocale = 'eng'
							AND Id = CEGC.NameTextID
					) AS CEGC_ENG
					CROSS APPLY
					(
						SELECT ISNULL(MIN(TargetId), CEGC.NameTextID) AS TextId
						FROM VerbatimIdsJpn
						WHERE CEG.DictionaryLocale = 'jpn'
							AND Id = CEGC.NameTextID
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
				WHERE CEGC.CodingElementGroupID = CEG.CodingElementGroupID
					--AND CEG.CompSuppCount > 0
				ORDER BY CEGC.IsSupplement, CEGC.ComponentTypeID, CEGC.NameTextID
				FOR XML PATH('')
			) M (list)
			-- find the new target verbatim id (if any) for eng
			CROSS APPLY
			(
				SELECT ISNULL(MIN(TargetId), CEG.GroupVerbatimID) AS TextId
				FROM VerbatimIdsEng
				WHERE CEG.DictionaryLocale = 'eng'
					AND CEG.GroupVerbatimID = Id
			) AS CEG_ENG
			-- find the new target verbatim id (if any) for jpn
			CROSS APPLY
			(
				SELECT ISNULL(MIN(TargetId), CEG.GroupVerbatimID) AS TextId
				FROM VerbatimIdsJpn
				WHERE CEG.DictionaryLocale = 'jpn'
					AND CEG.GroupVerbatimID = Id
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
	)

	INSERT INTO AffectedGroups(Id, MassiveKey, NumberAffected)
	SELECT CodingElementGroupId, MassiveKey, SUMTotal 
	FROM xCEG

	-- In place update where NumberAffected is 1
	UPDATE CEG
	SET CEG.GroupVerbatimID = CEG_Fin.TextId
	FROM CodingElementGroups CEG
		JOIN AffectedGroups AG
			ON CEG.CodingElementGroupId = AG.Id
			AND AG.NumberAffected = 1
		-- find the new target verbatim id (if any) for eng
		CROSS APPLY
		(
			SELECT ISNULL(MIN(TargetId), CEG.GroupVerbatimID) AS TextId
			FROM VerbatimIdsEng
			WHERE CEG.DictionaryLocale = 'eng'
				AND CEG.GroupVerbatimID = Id
		) AS CEG_ENG
		-- find the new target verbatim id (if any) for jpn
		CROSS APPLY
		(
			SELECT ISNULL(MIN(TargetId), CEG.GroupVerbatimID) AS TextId
			FROM VerbatimIdsJpn
			WHERE CEG.DictionaryLocale = 'jpn'
				AND CEG.GroupVerbatimID = Id
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
	
	UPDATE CEGC
	SET CEGC.NameTextID = CEGC_Fin.TextId
	FROM CodingElementGroupComponents CEGC
		JOIN AffectedGroups AG
			ON CEGC.CodingElementGroupId = AG.Id
			AND AG.NumberAffected = 1
		JOIN CodingElementGroups CEG
			ON CEG.CodingElementGroupId = AG.Id
		-- CEGC problematic ones
		CROSS APPLY
		(
			SELECT ISNULL(MIN(TargetId), CEGC.NameTextID) AS TextId
			FROM VerbatimIdsEng
			WHERE CEG.DictionaryLocale = 'eng'
				AND Id = CEGC.NameTextID
		) AS CEGC_ENG
		CROSS APPLY
		(
			SELECT ISNULL(MIN(TargetId), CEGC.NameTextID) AS TextId
			FROM VerbatimIdsJpn
			WHERE CEG.DictionaryLocale = 'jpn'
				AND Id = CEGC.NameTextID
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

	-- remove entries where NumberAffected is 1
	DELETE AG
	FROM AffectedGroups AG
	WHERE AG.NumberAffected = 1

	;WITH xCTE
	AS
	(
		SELECT MassiveKey, MIN(Id) AS minId
		FROM AffectedGroups
		GROUP BY MassiveKey
	)

	UPDATE AG
	SET TargetId = x.minId
	FROM AffectedGroups AG
		JOIN xCTE x
			ON AG.MassiveKey = x.MassiveKey

	SELECT COUNT(*), 'CodingElementGroup entries found'
	FROM AffectedGroups

END 

