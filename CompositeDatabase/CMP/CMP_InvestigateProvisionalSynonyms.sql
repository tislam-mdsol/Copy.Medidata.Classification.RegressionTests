/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
// Ad-hoc audit of a synonym list
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_InvestigateProvisionalSynonyms')
	DROP PROCEDURE CMP_InvestigateProvisionalSynonyms
GO

CREATE PROCEDURE dbo.CMP_InvestigateProvisionalSynonyms
(
	@dictionaryOID VARCHAR(100),
	@versionOID VARCHAR(100),
	@listName VARCHAR(250),
	@segmentName VARCHAR(250)
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @dictionaryID INT,
		@dictionaryVersionID INT,
		@listId INT,
		@segmentId INT,
		@waitingManualCodeId INT

	SELECT @segmentId = SegmentId 
	FROM Segments
	WHERE SegmentName = @segmentName

	IF (@segmentId IS NULL)
	BEGIN
		SELECT 'Cannot find Segment'
		RETURN 0
	END

	SELECT @dictionaryID = DictionaryRefID
	FROM DictionaryRef
	WHERE OID = @dictionaryOID

	IF (@dictionaryID IS NULL)
	BEGIN
		SELECT 'Cannot find dictionary'
		RETURN 0
	END

	SELECT @dictionaryVersionID = DictionaryVersionRefID
	FROM DictionaryVersionRef
	WHERE OID = @versionOID
		AND DictionaryRefID = @dictionaryID

	IF (@dictionaryVersionID IS NULL)
	BEGIN
		SELECT 'Cannot find dictionary version'
		RETURN 0
	END

	SELECT @waitingManualCodeId = WorkflowStateID
	FROM WorkflowStates
	WHERE SegmentId = @segmentId
		AND dbo.fnLDS(WorkflowStateNameID, 'eng') = 'Waiting Manual Code'

	IF (@waitingManualCodeId IS NULL)
	BEGIN
		SELECT 'Cannot find waiting manual code state'
		RETURN 0
	END

	DECLARE @isLoadedFromFile BIT,
		@fromListID INT

	SELECT @listId = SynonymMigrationMngmtID,
		@isLoadedFromFile = IsSynonymListLoadedFromFile,
		@fromListID = FromSynonymListID
	FROM SynonymMigrationMngmt
	WHERE SegmentID = @segmentId
		AND ListName = @listName
		AND DictionaryVersionId = @dictionaryVersionID
		AND Deleted = 0

	IF (@listId IS NULL)
	BEGIN
		SELECT 'Cannot find synonym list'
		RETURN 0
	END

	-- 1. See if it's loaded from file
	SELECT 'IsLoadedFromFile', @isLoadedFromFile

	SELECT 'FromListId', @listId, ListName, DictionaryVersionId
	FROM SynonymMigrationMngmt
	WHERE SynonymMigrationMngmtID = @listId

	SELECT 'Total Synonyms in provisional status', COUNT(*)
	FROM SegmentedGroupCodingPatterns
	WHERE SynonymManagementID = @listId
		AND SynonymStatus = 1

	;WITH xCTE
	AS
	(
		SELECT SDV.StudyID, COUNT(*) AS TaskCountToAutoCode
		FROM StudyDictionaryVersion SDV
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SynonymManagementID = SDV.SynonymManagementID
				AND SGCP.SynonymStatus = 1
			JOIN CodingElements CE
				ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
				AND CE.CodingElementGroupID = SGCP.CodingElementGroupID
				AND CE.WorkflowStateID = @waitingManualCodeId
				AND CE.SegmentId = @segmentId
		WHERE SDV.SynonymManagementID = @listId
		GROUP BY SDV.StudyID
	)

	SELECT 'TaskCount to be autocoded upon synonym approval by study', TOS.ExternalObjectName AS StudyName, xCTE.*
	FROM xCTE
		JOIN TrackableObjects TOS
			ON TOS.TrackableObjectID = xCTE.StudyID


END
