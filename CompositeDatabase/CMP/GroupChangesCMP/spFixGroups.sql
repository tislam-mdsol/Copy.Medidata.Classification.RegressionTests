/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spFixGroups')
	DROP PROCEDURE spFixGroups
GO

CREATE PROCEDURE dbo.spFixGroups
AS
BEGIN

	-- 1. reset GroupVerbatimId
	UPDATE CEG
	SET CEG.GroupVerbatimID = 
		CASE WHEN CEG.DictionaryLocale = 'eng' THEN E.TargetId
			ELSE J.TargetId
		END
	FROM CodingElementGroups CEG
		JOIN AffectedGroups AG
			ON CEG.CodingElementGroupID = AG.TargetID
		CROSS APPLY
		(
			SELECT ISNULL(MIN(TargetId), CEG.GroupVerbatimID) AS TargetId
			FROM VerbatimIdsEng
			WHERE CEG.DictionaryLocale = 'eng'
				AND Id = CEG.GroupVerbatimID
		) AS E
		CROSS APPLY
		(
			SELECT ISNULL(MIN(TargetId), CEG.GroupVerbatimID) AS TargetId
			FROM VerbatimIdsJpn
			WHERE CEG.DictionaryLocale = 'jpn'
				AND Id = CEG.GroupVerbatimID
		) AS J

	-- reset CodingElementGroupComponents
	UPDATE CEGC
	SET CEGC.NameTextId =
		CASE WHEN CEG.DictionaryLocale = 'eng' THEN E.TextId
			ELSE J.TextId
		END
	FROM CodingElementGroupComponents CEGC
		JOIN AffectedGroups AG
			ON CEGC.CodingElementGroupID = AG.TargetID
		JOIN CodingElementGroups CEG
			ON CEG.CodingElementGroupID = CEGC.CodingElementGroupID
				-- CEGC problematic ones
				CROSS APPLY
				(
					SELECT ISNULL(MIN(TargetId), CEGC.NameTextID) AS TextId
					FROM VerbatimIdsEng
					WHERE CEG.DictionaryLocale = 'eng'
						AND Id = CEGC.NameTextID
				) AS E
				CROSS APPLY
				(
					SELECT ISNULL(MIN(TargetId), CEGC.NameTextID) AS TextId
					FROM VerbatimIdsJpn
					WHERE CEG.DictionaryLocale = 'jpn'
						AND Id = CEGC.NameTextID
				) AS J				

	-- CodingElements
	UPDATE CE
	SET CE.CodingElementGroupID = AG.TargetID
	FROM CodingElements CE
		JOIN AffectedGroups AG
			ON CE.CodingElementGroupID = AG.ID

	-- SegmentedGroupCodingPatterns
	UPDATE SGCP
	SET SGCP.CodingElementGroupID = AG.TargetId
	FROM SegmentedGroupCodingPatterns SGCP
		JOIN AffectedGroups AG
			ON AG.Id = SGCP.CodingElementGroupID

	-- TODO : other tables?

	-- remove unreferenced Groups
	DELETE CEGC
	FROM CodingElementGroupComponents CEGC
		JOIN AffectedGroups AG
			ON CEGC.CodingElementGroupID = AG.ID
			-- except for the entries to keep!
			AND AG.ID <> AG.TargetID

	DELETE CEG
	FROM CodingElementGroups CEG
		JOIN AffectedGroups AG
			ON CEG.CodingElementGroupID = AG.ID
			-- except for the entries to keep!
			AND AG.ID <> AG.TargetID

END