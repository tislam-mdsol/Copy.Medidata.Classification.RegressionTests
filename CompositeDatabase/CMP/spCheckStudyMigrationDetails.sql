/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Bonnie Pan bpan@mdsol.com
//
// ------------------------------------------------------------------------------------------------------*/

-- EXEC spCheckStudyMigrationDetails 'AZ1_CODER_CVGI'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCheckStudyMigrationDetails')
	DROP PROCEDURE spCheckStudyMigrationDetails
GO

CREATE PROCEDURE dbo.spCheckStudyMigrationDetails
(
	@SegmentName NVARCHAR(50)
)
AS 
BEGIN

	DECLARE @SegmentID INT

	SELECT @SegmentID = SegmentID
	FROM Segments
	WHERE SegmentName = @SegmentName
	
	IF (@SegmentID IS NULL)
	BEGIN
		PRINT N'Segment not found: ' + @SegmentName
		RETURN
	END

    SELECT @SegmentName as SegmentName, T.ExternalObjectName as StudyName, DR.OID as Dictionary, FromVersion.OID as FromVersion, ToVersion.OID as ToVersion,SDVH.MigrationStarted, SDVH.MigrationEnded,
	 SDVH.FutureVersionAutomation, 
	 SDVH.BetterDictionaryMatch, 
	 SDVH.ImpactAnalysis0 as Unspecified, 
	 SDVH.ImpactAnalysis1 as NotAffected,
	 SDVH.ImpactAnalysis2 as Obosolete,
	 SDVH.ImpactAnalysis3 as ReInstated,
	 SDVH.ImpactAnalysis4 as NodePathChanged,
	 SDVH.ImpactAnalysis5 as TermNotFound,
	 SDVH.ImpactAnalysis6 as CodeNotFound,
	 SDVH.ImpactAnalysis7 as TermAndCodeNotFound

	FROM StudyDictionaryVersionHistory SDVH
	JOIN DictionaryRef DR ON DR.DictionaryRefID = SDVH.MedicalDictionaryID
	JOIN TrackableObjects T ON T.TrackableObjectID = SDVH.StudyID AND T.SegmentId = SDVH.SegmentID
	CROSS APPLY 
    (
       SELECT OID 
       FROM DictionaryVersionRef DVR
       WHERE DictionaryRefID = SDVH.MedicalDictionaryID AND DVR.Ordinal = SDVH.FromVersionOrdinal
	 ) AS FromVersion
	CROSS APPLY 
    (
       SELECT OID 
       FROM DictionaryVersionRef DVR
       WHERE DictionaryRefID = SDVH.MedicalDictionaryID AND DVR.Ordinal = SDVH.ToVersionOrdinal
	 ) AS ToVersion
	WHERE SDVH.SegmentId = @SegmentID
	ORDER BY StudyName
END
