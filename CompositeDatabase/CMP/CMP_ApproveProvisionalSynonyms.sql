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
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_ApproveProvisionalSynonyms')
	DROP PROCEDURE CMP_ApproveProvisionalSynonyms
GO

CREATE PROCEDURE dbo.CMP_ApproveProvisionalSynonyms
(
	@dictionaryOID VARCHAR(100),
	@versionOID VARCHAR(100),
	@listName VARCHAR(250),
	@segmentName VARCHAR(250)
)
AS
BEGIN

	DECLARE @dictionaryID INT,
		@dictionaryVersionID INT,
		@listId INT,
		@segmentId INT

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

	SELECT @listId = SynonymMigrationMngmtID
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

	UPDATE SGCP
	SET SGCP.SynonymStatus = 2
	FROM SegmentedGroupCodingPatterns SGCP
	WHERE SGCP.SynonymStatus = 1
		AND SGCP.SegmentID = @segmentId
		AND SGCP.SynonymManagementID = @listId


END
