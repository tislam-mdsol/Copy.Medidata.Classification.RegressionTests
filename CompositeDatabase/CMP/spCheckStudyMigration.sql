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

-- EXEC spCheckStudyMigration 'Sanofi-Cov', 'SA_LTS11717', 'MedDRA'
-- EXEC spCheckStudyMigration 'MedidataReserved1', 'MedidataRsrvd1', 'MedDRA'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCheckStudyMigration')
	DROP PROCEDURE spCheckStudyMigration
GO

CREATE PROCEDURE dbo.spCheckStudyMigration
(
	@SegmentName NVARCHAR(50),
	@StudyName NVARCHAR(50),
	@dictionaryOID VARCHAR(50)
)
AS 
BEGIN

	DECLARE @segmentID INT,
		@studyId INT,
		@dictionaryID INT,
		@dictionaryVersionID INT,
		@studyDictionaryVersionID INT

	SELECT @SegmentID = SegmentID
	FROM Segments
	WHERE SegmentName = @SegmentName
	
	IF (@SegmentID IS NULL)
	BEGIN
		PRINT N'Segment not found: ' + @SegmentName
		RETURN
	END

	SELECT @StudyID = TrackableObjectID
	FROM TrackableObjects
	WHERE ExternalObjectName = @StudyName AND SegmentId = @SegmentID

	IF (@StudyID IS NULL)
	BEGIN
		PRINT N'Study not found: ' + @StudyName
		RETURN
	END

	SELECT @dictionaryID = DictionaryRefId
	FROM DictionaryRef
	WHERE OID = @dictionaryOID

	IF (@dictionaryID IS NULL)
	BEGIN
		PRINT N'Dictionary not found: ' + @dictionaryOID
		RETURN
	END

	SELECT @studyDictionaryVersionID = StudyDictionaryVersionId,
		@dictionaryVersionID = DictionaryVersionID
	FROM StudyDictionaryVersion
	WHERE StudyId = @StudyID AND MedicalDictionaryId = @dictionaryID

	IF (@studyDictionaryVersionID IS NULL)
	BEGIN
		PRINT 'Cannot Find StudyDictionaryVersion'
	END
	ELSE
	BEGIN

		SELECT * 
		FROM DictionaryVersionRef
		WHERE DictionaryVersionRefID = @dictionaryVersionID

		EXEC spStudyMigrationTaskCount @studyDictionaryVersionID
	END

END
