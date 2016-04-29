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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAutomationAnalysis')
	DROP PROCEDURE spAutomationAnalysis
GO

CREATE PROCEDURE dbo.spAutomationAnalysis
(
	@CheckSynonymOnly BIT = 1
)
AS
BEGIN

	IF (@CheckSynonymOnly = 1)
	BEGIN

		;WITH xCTE AS
		(		
			SELECT SGCP.SynonymManagementID, AG.TargetId,
				MIN(SGCP.SegmentedGroupCodingPatternID) AS MinSegmentedGroupCodingPatternID
			FROM AffectedGroups AG
				JOIN SegmentedGroupCodingPatterns SGCP
					ON AG.Id = SGCP.CodingElementGroupID
					AND Active = 1
					AND SynonymStatus > 0
			GROUP BY SGCP.SynonymManagementID, AG.TargetId
			HAVING COUNT(*) > 1
		)

		INSERT INTO AffectedSynonyms (ListId, SGCPId, TargetId)
		SELECT x.SynonymManagementID, SGCP.SegmentedGroupCodingPatternID, MIN(x.MinSegmentedGroupCodingPatternID)
		FROM xCTE x
			JOIN AffectedGroups AG
				ON x.TargetId = AG.TargetId
			JOIN SegmentedGroupCodingPatterns SGCP
				ON x.SynonymManagementID = SGCP.SynonymManagementID
				AND SGCP.Active = 1
				AND SGCP.SynonymStatus > 0
				AND SGCP.CodingElementGroupID = AG.Id
		GROUP BY x.SynonymManagementID, SGCP.SegmentedGroupCodingPatternID

		-- Delete resolvable ones
		;WITH xCheck AS
		(
			SELECT AFS.ListId, AFS.TargetId, MIN(SGCP.CodingPatternID) AS MinSGCPId, MAX(SGCP.CodingPatternID) AS MaxSGCPId
			FROM AffectedSynonyms AFS
				JOIN SegmentedGroupCodingPatterns SGCP
					ON AFS.SGCPId = SGCP.SegmentedGroupCodingPatternID
			GROUP BY AFS.ListId, AFS.TargetId
		)

		--SELECT *
		--FROM xCheck
		--WHERE MinSGCPId <> MaxSGCPId

		DELETE AFS
		FROM AffectedSynonyms AFS
			JOIN SegmentedGroupCodingPatterns SGCP
				ON AFS.SGCPId = SGCP.SegmentedGroupCodingPatternID
			JOIN xCheck
				ON AFS.ListId = xCheck.ListId
				AND AFS.TargetId = xCheck.TargetId
				-- MinSGCPId = MaxSGCPId
				AND SGCP.CodingPatternID = xCheck.MinSGCPId
				AND SGCP.CodingPatternID = xCheck.MaxSGCPId
	END
	ELSE
	BEGIN

		;WITH xCTE AS
		(		
			SELECT SGCP.SynonymManagementID, AG.TargetId, SGCP.CodingPatternID, 
			 ISNULL(MIN(SGCP_Syn.MinSyn), MIN(SGCP.SegmentedGroupCodingPatternID)) AS MinSegmentedGroupCodingPatternID
			FROM AffectedGroups AG
				JOIN SegmentedGroupCodingPatterns SGCP
					ON AG.Id = SGCP.CodingElementGroupID
					AND SGCP.Active = 1
				CROSS APPLY
				(
					SELECT MIN(SegmentedGroupCodingPatternID) AS MinSyn
					FROM SegmentedGroupCodingPatterns
					WHERE AG.Id = CodingElementGroupID
						AND SynonymStatus > 0
						AND Active = 1
				) SGCP_Syn
			GROUP BY SGCP.SynonymManagementID, AG.TargetId, SGCP.CodingPatternID
		)

		INSERT INTO AffectedSynonyms (ListId, SGCPId, TargetId)
		SELECT x.SynonymManagementID, SGCP.SegmentedGroupCodingPatternID, MIN(x.MinSegmentedGroupCodingPatternID)
		FROM xCTE x
			JOIN AffectedGroups AG
				ON x.TargetId = AG.TargetId
			JOIN SegmentedGroupCodingPatterns SGCP
				ON x.SynonymManagementID = SGCP.SynonymManagementID
				AND SGCP.Active = 1
				AND SGCP.CodingElementGroupID = AG.Id
				AND SGCP.CodingPatternID = x.CodingPatternID
		GROUP BY x.SynonymManagementID, SGCP.SegmentedGroupCodingPatternID

	END

	SELECT COUNT(*), 'SegmentedGroupCodingPattern entries found'
	FROM AffectedSynonyms

END