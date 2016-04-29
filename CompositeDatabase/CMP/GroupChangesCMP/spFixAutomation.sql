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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spFixAutomation')
	DROP PROCEDURE spFixAutomation
GO

CREATE PROCEDURE dbo.spFixAutomation
AS
BEGIN

	-- populate AffectedSynonyms with any segmentedpattern entries
	TRUNCATE TABLE AffectedSynonyms

	EXEC spAutomationAnalysis 0

	-- if no data, bail
	IF NOT EXISTS (SELECT NULL FROM AffectedSynonyms)
		RETURN

	-- 1. relink CodingAssignment
	UPDATE CA
	SET CA.SegmentedGroupCodingPatternID = AFS.TargetID
	FROM CodingAssignment CA
		JOIN AffectedSynonyms AFS
			ON CA.SegmentedGroupCodingPatternID = AFS.SGCPId

	-- 2. relink CodingElements
	UPDATE CE
	SET CE.AssignedSegmentedGroupCodingPatternId = AFS.TargetID
	FROM CodingElements CE
		JOIN AffectedSynonyms AFS
			ON CE.AssignedSegmentedGroupCodingPatternId = AFS.SGCPId

	-- 3. relink StudyMigrationBackup(OldSegmentedGroupCodingPatternID)
	UPDATE SMB
	SET SMB.OldSegmentedGroupCodingPatternID = AFS.TargetID
	FROM StudyMigrationBackup SMB
		JOIN AffectedSynonyms AFS
			ON SMB.OldSegmentedGroupCodingPatternID = AFS.SGCPId

	-- 4. relink SynonymMigrationEntries
	UPDATE SME
	SET SME.SegmentedGroupCodingPatternID = AFS.TargetID
	FROM SynonymMigrationEntries SME
		JOIN AffectedSynonyms AFS
			ON SME.SegmentedGroupCodingPatternID = AFS.SGCPId

	-- TODO : other tables?

	-- 5. remove unreferenced SegmentedGroupCodingPatterns
	DELETE SGCP
	FROM SegmentedGroupCodingPatterns SGCP
		JOIN AffectedSynonyms AFS
			ON SGCP.SegmentedGroupCodingPatternID = AFS.SGCPId
			-- except for the entries to keep!
			AND AFS.SGCPId <> AFS.TargetID

	-- last. reset SegmentedGroupCodingPatterns.CodingElementGroupID
	UPDATE SGCP
	SET SGCP.CodingElementGroupID = AG.TargetId
	FROM SegmentedGroupCodingPatterns SGCP
		JOIN AffectedSynonyms AFS
			-- only update the entry to keep
			ON SGCP.SegmentedGroupCodingPatternID = AFS.TargetID
		JOIN AffectedGroups AG
			ON AG.Id = SGCP.CodingElementGroupID

END 

