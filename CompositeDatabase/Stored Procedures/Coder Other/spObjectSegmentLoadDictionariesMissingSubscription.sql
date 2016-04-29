/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

--EXEC spObjectSegmentLoadDictionariesMissingSubscription 2001, 2002

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spObjectSegmentLoadDictionariesMissingSubscription')
	DROP PROCEDURE spObjectSegmentLoadDictionariesMissingSubscription
GO
CREATE PROCEDURE dbo.spObjectSegmentLoadDictionariesMissingSubscription
(
	@MedicalDictionaryTypeID INT,
	@VersionLocaleTypeID INT
)
AS
	
	;WITH SomeDeletedVersionsCTE (DictionaryId, SegmentID)
	AS
	(
		SELECT DVLR.DictionaryRefId, OS.SegmentID
		FROM DictionaryVersionSubscriptions DVS
			JOIN DictionaryVersionLocaleRef DVLR
				ON DVS.HistoricalVersionLocaleStatusID = DVLR.DictionaryVersionLocaleRefID	
			JOIN ObjectSegments OS
				ON OS.ObjectSegmentID = DVS.ObjectSegmentID
				AND OS.Deleted = 1
		GROUP BY DVLR.DictionaryRefId, OS.SegmentID
	)

	SELECT OSD.*
	FROM ObjectSegments OSD
		JOIN SomeDeletedVersionsCTE CTE
			ON OSD.ObjectId = CTE.DictionaryId
			AND OSD.SegmentId = CTE.SegmentID
			AND OSD.Deleted = 0
			AND OSD.ObjectTypeID = @MedicalDictionaryTypeID
	WHERE NOT EXISTS (SELECT NULL FROM ObjectSegments OSV
			WHERE OSV.SegmentId = CTE.SegmentID
				AND OSV.Deleted = 0
				AND OSV.ObjectTypeID = @VersionLocaleTypeID
				AND OSV.ObjectId IN (SELECT DictionaryVersionLocaleRefID 
					FROM DictionaryVersionLocaleRef DVLR
					WHERE DVLR.DictionaryRefID = CTE.DictionaryId)
			)
	
GO    