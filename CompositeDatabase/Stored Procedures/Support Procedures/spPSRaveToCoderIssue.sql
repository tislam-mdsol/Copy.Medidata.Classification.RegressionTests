  /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Sneha Saikumar ssaikumar@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE='p' and NAME = 'spPSRaveToCoderIssue')
DROP PROCEDURE [dbo].[spPSRaveToCoderIssue]
GO


CREATE PROCEDURE [dbo].[spPSRaveToCoderIssue]

@SegmentName NVARCHAR(255),
@StudyName NVARCHAR(2000)

AS 
BEGIN
-- show coding requests from Rave apps, with Study and Verbatim info
 
SELECT TOP 100 AP.Name as App, 
STUDY.ExternalObjectName as StudyName, 
STUDY.ExternalObjectId as StudyUUID, 
CR.CodingRequestId,	
CR.FileOID, 
CR.CreationDateTime,	
CR.ReferenceNumber,	
CR.BatchOID,	
CE.CodingElementId,	
CE.SourceSystemId,	
CE.SegmentId,
SG.SegmentName,	
STUDY.TrackableObjectId,	
CE.CodingSourceAlgorithmID,	
SDV.DictionaryVersionId,	
CE.DictionaryLevelId,	
SDV.DictionaryLocale,	
CE.VerbatimTerm,	
CE.IsClosed,	
CE.IsCompleted,	
CE.IsAutoCodeRequired,	
CE.AutoCodeDate,	
CE.CompletionDate,	
CE.Created,	
CE.Updated,	
CE.SearchType,	
CE.CodingElementGroupID,	
CE.SourceIdentifier,	
CE.IsStillInService,	
CE.WorkflowStateID,	
CE.AssignedSegmentedGroupCodingPatternId,	
CE.AssignedTermText,	
CE.Priority,	
CE.AssignedTermCode,
CE.AssignedCodingPath,	
CE.SourceSubject,	
CE.SourceField,	
CE.SourceForm,	
CE.IsInvalidTask,	
CE.AssignedTermKey
FROM CodingRequests CR
LEFT JOIN CodingElements CE ON CR.CodingRequestId = CE.CodingRequestId
INNER JOIN Segments SG ON SG.SegmentId = CE.SegmentId
INNER JOIN Application AP ON AP.SourceSystemID = CR.SourceSystemID
JOIN StudyDictionaryVersion SDV ON SDV.StudyDictionaryVersionID = CE.StudyDictionaryVersionId
INNER JOIN TrackableObjects STUDY ON STUDY.TrackableObjectId = SDV.StudyID
WHERE SG.SegmentName = @SegmentName and STUDY.ExternalObjectName = @StudyName
ORDER BY CR.CodingRequestId DESC
 
END
GO


