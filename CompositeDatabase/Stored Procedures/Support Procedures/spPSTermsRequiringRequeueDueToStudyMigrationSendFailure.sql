/*
*
* Written by: Connor Ross cross@mdsol.com
* MCC-111098
* Date: 10 Jun 2014
* Description: 
*  For some reason when terms are queued to be sent back
*   to Rave after a study migration, the codingelement
*   is not saved with the coding assignment when the
*   outqueue picks it up to send.  It then tries
*   5 times quickly thus making it never get sent.
*
* Related Sql Scripts: CMP\CMP_RequeueTermsFailedSendingAfterStudyMigrationAssignment.sql
*/

------------------------------------------------------------------


-- EXEC [dbo].[spPSTermsRequiringRequeueDueToStudyMigrationSendFailure] 'Sanofi-Cov'

IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE='p' and NAME = 'spPSTermsRequiringRequeueDueToStudyMigrationSendFailure')
DROP PROCEDURE [dbo].[spPSTermsRequiringRequeueDueToStudyMigrationSendFailure]
GO


CREATE PROCEDURE [dbo].[spPSTermsRequiringRequeueDueToStudyMigrationSendFailure]
(
	@SegmentName NVARCHAR(255)
)
AS 
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @SegmentId BIGINT
DECLARE @errorString NVARCHAR(MAX)

SELECT @SegmentId = SegmentId
FROM Segments
WHERE SegmentName = @SegmentName

IF(ISNULL(@SegmentId, 0) < 1)
BEGIN
	SET @errorString = 'Cannout find Segment - exiting!'
	PRINT @errorString
	RAISERROR(@errorString, 16, 1)
END

;WITH AffectedTerms_CTE AS (
	SELECT TQI.TransmissionQueueItemID, CE.CodingElementID, CE.SegmentId, CE.CodingElementGroupId, CE.WorkflowStateId, CA.CodingAssignmentID
	FROM dbo.TransmissionQueueItems TQI
	JOIN dbo.CodingAssignment CA ON CA.CodingAssignmentID = TQI.ObjectID
	JOIN dbo.CodingElements CE ON CE.CodingElementId = CA.CodingElementID
	WHERE TQI.ObjectTypeId = 2255
	AND TQI.IsForUnloadService = 0
	AND CE.AssignedCodingPath <> ''
	AND TQI.SuccessCount = 0 
	AND TQI.FailureCount >= 5 
	AND TQI.OutTransmissionId = 0
	AND CE.SegmentId = @SegmentId
),
-- Only let transmission queue items through that
--  are associated with the active coding assignment
Only_Active_Coding_Assignments_CTE AS (
	SELECT AT.TransmissionQueueItemID, AT.CodingElementID, AT.SegmentId, AT.CodingElementGroupId, AT.WorkflowStateId
	FROM AffectedTerms_CTE AT
	JOIN dbo.CodingAssignment CA ON 
		CA.CodingElementId = AT.CodingElementId 
		AND CA.Active = 1 
		AND CA.CodingAssignmentId = AT.CodingAssignmentId
),
-- Hydrate Information For Display
Display_Terms_CTE as (
	SELECT
		SS.ConnectionUri      'Source System',
		S.SegmentName         'Segment',
		ST.ExternalObjectName 'Study',
		CE.VerbatimTerm       'Verbatim', 
		CE.AssignedTermText   'Assigned Term',
		CE.SourceSubject      'Subject',
		CE.SourceForm         'Form',
		CE.SourceField        'Field',
		AT.*
	FROM Only_Active_Coding_Assignments_CTE AT
	JOIN Segments S ON S.SegmentId = AT.SegmentId
	JOIN CodingElements CE ON CE.CodingElementId = AT.CodingElementId
	JOIN StudyDictionaryVersion SDV ON SDV.StudyDictionaryVersionID = CE.StudyDictionaryVersionId
	JOIN TrackableObjects ST ON ST.TrackableObjectId = SDV.StudyId
	JOIN SourceSystems SS ON SS.SourceSystemId = CE.SourceSystemId
)
SELECT *
FROM Display_Terms_CTE
ORDER BY Segment, Study, Subject, Form, Field


END
GO
