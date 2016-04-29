 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

--EXEC [spPSCodingTaskReport] '2013-1-1', '2013-2-1'

IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spPSCodingTaskReport')
	DROP PROCEDURE dbo.spPSCodingTaskReport
GO

CREATE PROCEDURE [dbo].[spPSCodingTaskReport]
(
	@BeginUTCDate DATETIME,
	@EndUTCDate DATETIME
)
AS
 BEGIN

	-- Reports the total coding activity between the given dates (inclusive).
	-- Returns the number of tasks received, coded, autocoded, and rejected (rolled-up by study)
	;with 
	InComing (StudyDictionaryVersionId, Total) as (
		Select CE.StudyDictionaryVersionId, COUNT(1)
		FROM CodingElements CE
		WHERE CE.Created BETWEEN @BeginUTCDate AND @EndUTCDate
		GROUP BY CE.StudyDictionaryVersionId
	),
	NonRejected as (
		SELECT CE.*
		FROM CodingElements CE
		LEFT JOIN CodingRejections CR on CR.CodingElementId = CE.CodingElementId
		WHERE CR.CodingElementId is null
	),
	Rejected (StudyDictionaryVersionId, Total) as (
		SELECT CE.StudyDictionaryVersionId, COUNT(1)
		FROM CodingElements CE
		JOIN CodingRejections CR on CR.CodingElementId = CE.CodingElementId
		WHERE CR.Updated BETWEEN @BeginUTCDate AND @EndUTCDate
		GROUP BY CE.StudyDictionaryVersionId
	),
	AutoCoding (StudyDictionaryVersionId, Total) as (
		SELECT CE.StudyDictionaryVersionId, Count(1)
		FROM CodingElements CE
		LEFT JOIN NonRejected NR ON CE.CodingElementId = NR.CodingElementId
		JOIN CodingAssignment CA ON CA.CodingElementID = CE.CodingElementId
        WHERE CA.Active = 1
			AND  CE.AssignedSegmentedGroupCodingPatternId > 0
            AND NR.CodingElementId > 0
            AND CE.AutoCodeDate BETWEEN @BeginUTCDate AND @EndUTCDate
            AND CA.IsAutoCoded = 1
		GROUP BY CE.StudyDictionaryVersionId
	),
	OutgoingTotal (StudyDictionaryVersionId, Total) as (
		SELECT CE.StudyDictionaryVersionId, Count(1)
		FROM CodingElements CE
		LEFT JOIN NonRejected NR ON CE.CodingElementId = NR.CodingElementId
		JOIN CodingAssignment CA ON CA.CodingElementID = CE.CodingElementId
		JOIN TransmissionQueueItems TQI ON TQI.ObjectTypeId in (2251,2255) AND TQI.ObjectId = CA.CodingAssignmentId
        WHERE 
			TQI.Created BETWEEN @BeginUTCDate AND @EndUTCDate
            AND NR.CodingElementId > 0
		GROUP BY CE.StudyDictionaryVersionId
	),
	OutgoingOnePer (StudyDictionaryVersionId, Total) as (
		SELECT CE.StudyDictionaryVersionId, Count(1)
		FROM CodingElements CE
        WHERE 
			EXISTS (
				SELECT 1 
				FROM TransmissionQueueItems TQI
				JOIN CodingAssignment CA ON 
					TQI.ObjectTypeId in (2251,2255) 
					AND TQI.ObjectId = CA.CodingAssignmentId
					AND CA.CodingElementID = CE.CodingElementId
					AND TQI.Created BETWEEN @BeginUTCDate AND @EndUTCDate
				JOIN NonRejected NR ON CE.CodingElementId = NR.CodingElementId
			)
		Group By CE.StudyDictionaryVersionId
	),
	StudyDictVersions as
	(
		SELECT DISTINCT [all].StudyDictionaryVersionId
		FROM (
			SELECT StudyDictionaryVersionId
			FROM InComing
			UNION
			SELECT StudyDictionaryVersionId
			FROM OutgoingTotal
			UNION
			SELECT StudyDictionaryVersionId
			FROM OutgoingOnePer
			UNION
			SELECT StudyDictionaryVersionId
			FROM AutoCoding
			UNION
			SELECT StudyDictionaryVersionId
			FROM Rejected
		) [all]
	),
	Metrics as (
		SELECT 
		StudyDictVersions.StudyDictionaryVersionId,
		COALESCE(InComing.Total, 0) 'IN', 
		COALESCE(OutgoingTotal.Total, 0) 'Out', 
		COALESCE(OutgoingOnePer.Total, 0) 'Out One Per', 
		COALESCE(AutoCoding.Total, 0) 'Auto Coded', 
		COALESCE(Rejected.Total, 0) 'Rejected'
		FROM StudyDictVersions
		LEFT JOIN InComing ON StudyDictVersions.StudyDictionaryVersionId = InComing.StudyDictionaryVersionId
		LEFT JOIN OutgoingOnePer ON StudyDictVersions.StudyDictionaryVersionId = OutgoingOnePer.StudyDictionaryVersionId 
		LEFT JOIN OutgoingTotal ON StudyDictVersions.StudyDictionaryVersionId = OutgoingTotal.StudyDictionaryVersionId
		LEFT JOIN AutoCoding ON StudyDictVersions.StudyDictionaryVersionId = AutoCoding.StudyDictionaryVersionId
		LEFT JOIN Rejected ON StudyDictVersions.StudyDictionaryVersionId = Rejected.StudyDictionaryVersionId
	)
    SELECT  COALESCE(S.SegmentName, ' Unknown') AS Segment ,
            COALESCE(T.ExternalObjectName, ' Unknown') AS Study ,
            COALESCE(~T.IsTestStudy, 0) AS IsProdStudy ,
            COALESCE(DR.MedicalDictionaryType, ' Unknown') AS 'Dictionary Type' ,
            Metrics.[IN] AS 'Total Tasks' ,
            Metrics.[Out One Per] AS 'Total Coded' ,
            Metrics.[Auto Coded] AS 'Auto Coded' ,
            Metrics.[Rejected],
			Metrics.[Out] AS 'Total Outgoing'
    FROM    Metrics
            LEFT JOIN StudyDictionaryVersion SDV ON SDV.StudyDictionaryVersionID = Metrics.StudyDictionaryVersionId
            LEFT JOIN TrackableObjects T ON T.TrackableObjectId = SDV.StudyID
            LEFT JOIN DictionaryVersionRef DV ON DV.DictionaryVersionRefID = SDV.DictionaryVersionId
            LEFT JOIN DictionaryRef DR ON DR.DictionaryRefID = DV.DictionaryRefID
            LEFT JOIN Segments S ON S.SegmentId = T.SegmentId
	WHERE	Metrics.StudyDictionaryVersionId <> 0 -- Lost in sauce why CodingElements.StudyDictionaryVersionId is 0
    ORDER BY Segment , Study


 END
GO