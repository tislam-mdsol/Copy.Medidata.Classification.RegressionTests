/*
*
* MCC-111098 & MCC-178390
* Date: 10 Jun 2014
* Description: 
*  For some reason when terms are queued to be sent back
*   to Rave after a study migration, the codingelement
*   is not saved with the coding assignment when the
*   outqueue picks it up to send.  It then tries
*   5 times quickly thus making it never get sent.
*
* Related Sql Scripts: Stored Procedures\Support Procedures\spPSTermsRequiringRequeueDueToStudyMigrationSendFailure.sql
*/

------------------------------------------------------------------

-- EXEC [dbo].[spCMPTermsRequiringRequeueDueToStudyMigrationSendFailure] 'Sanofi-Cov'
-- EXEC [dbo].[spCMPTermsRequiringRequeueDueToStudyMigrationSendFailure] NULL

IF EXISTS ( SELECT  NULL
            FROM    sys.objects
            WHERE   TYPE = 'p'
                    AND NAME = 'spCMPTermsRequiringRequeueDueToStudyMigrationSendFailure' ) 
    DROP PROCEDURE [dbo].[spCMPTermsRequiringRequeueDueToStudyMigrationSendFailure]
GO

CREATE PROCEDURE [dbo].[spCMPTermsRequiringRequeueDueToStudyMigrationSendFailure]
    (
     @SegmentName NVARCHAR(255) = ''
    )
AS 
    BEGIN

        DECLARE @SegmentId BIGINT
        DECLARE @errorString NVARCHAR(MAX)

        SELECT  @SegmentId  = SegmentId
        FROM    Segments
        WHERE   SegmentName = @SegmentName

        IF ( LEN(@SegmentName) > 0
             AND ISNULL(@SegmentId , 0) < 1
           ) 
            BEGIN
                SET @errorString = 'Cannot find Segment - exiting!'
                PRINT @errorString
                RAISERROR(@errorString, 16, 1)
                RETURN
            END

        IF OBJECT_ID('tempdb..#TermsToRequeue') IS NOT NULL 
            BEGIN
                DROP TABLE #TermsToRequeue ;
            END

        CREATE TABLE #termsToRequeue
            (
             [SegmentId] BIGINT
            ,[TransmissionQueueItemID] BIGINT
            ,[CodingElementID] BIGINT
            ,[WorkflowStateID] BIGINT
            ,[CodingElementGroupId] BIGINT,
            ) ;

        DECLARE @Comment AS NVARCHAR(250) = 'Coding decision requeued due to MCC-111098' 
        
      
        ;WITH  AffectedTerms_CTE
                  AS ( SELECT   TQI.TransmissionQueueItemID
                               ,CE.CodingElementID
                               ,CE.SegmentId
                               ,CE.CodingElementGroupId
                               ,CE.WorkflowStateId
                               ,CA.CodingAssignmentID
                       FROM     dbo.TransmissionQueueItems TQI
                                JOIN dbo.CodingAssignment CA ON CA.CodingAssignmentID = TQI.ObjectID
                                JOIN dbo.CodingElements   CE ON CE.CodingElementId    = CA.CodingElementID
                       WHERE    TQI.ObjectTypeId = 2255
                                AND TQI.IsForUnloadService = 0
                                AND CE.AssignedCodingPath  <> ''
                                AND TQI.SuccessCount       = 0
                                AND TQI.FailureCount       >= 5
                                AND TQI.OutTransmissionId  = 0
                                AND CE.WorkflowStateId     = 5
                                -- and segment agnostic or for a single specific segment
                                AND ( LEN(@SegmentName)    = 0
                                      OR CE.SegmentId      = @SegmentId
                                    )
                     ),
				-- Only let transmission queue items through that
				--  are associated with the active coding assignment
                Only_Active_Coding_Assignments_CTE
                  AS ( SELECT   AT.TransmissionQueueItemID
                               ,AT.CodingElementID
                               ,AT.SegmentId
                               ,AT.CodingElementGroupId
                               ,AT.WorkflowStateId
                       FROM     AffectedTerms_CTE AT
                                JOIN dbo.CodingAssignment CA ON CA.CodingElementId  = AT.CodingElementId
                                                          AND CA.Active             = 1
                                                          AND CA.CodingAssignmentId = AT.CodingAssignmentId
                     )
                         
        INSERT  INTO #TermsToRequeue
                ( SegmentId
                ,TransmissionQueueItemID
                ,CodingElementId
                ,WorkflowStateId
                ,CodingElementGroupId
                )
                SELECT  SegmentId
                        ,TransmissionQueueItemID
                        ,CodingElementId
                        ,WorkflowStateId
                        ,CodingElementGroupId
                FROM    Only_Active_Coding_Assignments_CTE

        UPDATE  TQI
        SET     TQI.CumulativeFailCount        = TQI.CumulativeFailCount + TQI.FailureCount
               ,TQI.FailureCount               = 4
               ,TQI.ServiceWillContinueSending = 1
               ,TQI.Updated                    = GETUTCDATE()
        FROM    TransmissionQueueItems TQI
                JOIN #TermsToRequeue TTR ON TTR.TransmissionQueueItemID = TQI.TransmissionQueueItemID

        INSERT  INTO WorkflowTaskHistory
                ( WorkflowTaskID
                ,WorkflowStateID
                ,WorkflowActionID
                ,WorkflowSystemActionID
                ,UserID
                ,Comment
                ,SegmentId
                ,CodingAssignmentId
                ,CodingElementGroupId
                ,QueryId
                )
                SELECT  TTR.CodingElementId
                       ,TTR.WorkflowStateID
                       ,NULL
                       ,NULL
                       ,-2
                       ,@Comment
                       ,TTR.SegmentId
                       ,-1
                       ,TTR.CodingElementGroupID
                       ,0
                FROM    #TermsToRequeue TTR

        SELECT  S.SegmentName           'Segment'
               ,ST.ExternalObjectName   'Study'
               ,CE.VerbatimTerm         'Verbatim'
               ,CE.AssignedTermText     'Assigned Term'
               ,CE.SourceSubject        'Subject'
               ,CE.SourceForm           'Form'
               ,CE.SourceField          'Field'
               ,TTR.*
               ,SS.ConnectionUri        'Source System'
        FROM    #TermsToRequeue TTR
                JOIN Segments S                 ON S.SegmentId                  = TTR.SegmentId
                JOIN CodingElements CE          ON CE.CodingElementId           = TTR.CodingElementId
                JOIN StudyDictionaryVersion SDV ON SDV.StudyDictionaryVersionID = CE.StudyDictionaryVersionId
                JOIN TrackableObjects ST        ON ST.TrackableObjectId         = SDV.StudyId
                JOIN SourceSystems SS           ON SS.SourceSystemId            = CE.SourceSystemId
        ORDER BY Segment
               ,Study
               ,Subject
               ,Form
               ,Field

        DROP TABLE #TermsToRequeue ;

        -- Setup Comment for Resetting WorkflowState due to mismatching CodingElement & WorkFlowTaskHistory records
        SET @Comment = 'WorkflowState reset due to MCC-178390'
        DECLARE @workflowStartId INT = 1
        DECLARE @updatedCodingTasks TABLE
        (
            [SegmentId] BIGINT
            ,[CodingElementID] BIGINT
            ,[WorkflowStateID] BIGINT
            ,[CodingElementGroupId] BIGINT
        )
		
        -- Get the set of Mismatching Records
        DECLARE @PriorDayDate DATETIME = DATEADD(d, -1, GETUTCDATE())
        ;WITH CurrentWorkflowTaskHistoryIds
        AS (
            SELECT WorkflowTaskId,
                MAX(WorkflowTaskHistoryID) AS CurrentWorkflowTaskHistoryId
            FROM WorkflowTaskHistory
            GROUP BY WorkflowTaskId
        ),
        CMP_MismatchingWorkflowStates
        AS (
            SELECT ce.CodingElementId
            FROM CodingElements ce 
                INNER JOIN WorkflowTaskHistory wth
                    ON ce.CodingElementId = wth.WorkflowTaskID
                INNER JOIN CurrentWorkflowTaskHistoryIds cwth
                    ON wth.WorkflowTaskHistoryID = cwth.CurrentWorkflowTaskHistoryId
            WHERE ce.WorkflowStateId != wth.WorkflowStateId
                AND ce.IsInvalidTask = 0
                AND wth.Created > @PriorDayDate
        )

		-- Reset the CodingElement WorkflowState
        UPDATE ce
        SET ce.WorkflowStateId                        = @workflowStartId
            ,ce.IsClosed                              = 0
            ,ce.IsInvalidTask                         = 0
            ,ce.AutoCodeDate                          = NULL
            ,ce.AssignedSegmentedGroupCodingPatternId = -1
            ,ce.AssignedTermText                      = ''
            ,ce.AssignedTermCode                      = ''
            ,ce.AssignedCodingPath                    = ''
            ,ce.CacheVersion                          = ce.CacheVersion + 2
            ,ce.Updated                               = GETUTCDATE()
        OUTPUT
            INSERTED.[SegmentId],
            INSERTED.[CodingElementId],
            INSERTED.[WorkflowStateID],
            INSERTED.[CodingElementGroupID]
        INTO @updatedCodingTasks
        FROM [CodingElements] ce
            INNER JOIN CMP_MismatchingWorkflowStates tce
                ON ce.[CodingElementId] = tce.[CodingElementId]

        -- Insert Task History record for the change
        INSERT INTO [WorkflowTaskHistory] (
            [WorkflowTaskID]
            ,[WorkflowStateID]
            ,[WorkflowActionID]
            ,[WorkflowSystemActionID]
            ,[UserID]
            ,[Comment]
            ,[SegmentId]
            ,[CodingAssignmentId]
            ,[CodingElementGroupId]
            ,[QueryId]
        )
        SELECT ut.[CodingElementId]
            ,ut.[WorkflowStateID]
            ,NULL
            ,NULL
            ,-2
            ,@Comment
            ,ut.[SegmentId]
            ,-1
            ,ut.[CodingElementGroupID]
            ,0
        FROM @updatedCodingTasks ut

        SELECT  S.SegmentName           'Segment'
               ,ST.ExternalObjectName   'Study'
               ,CE.VerbatimTerm         'Verbatim'
               ,CE.AssignedTermText     'Assigned Term'
               ,CE.SourceSubject        'Subject'
               ,CE.SourceForm           'Form'
               ,CE.SourceField          'Field'
               ,UCT.*
               ,SS.ConnectionUri        'Source System'
        FROM    @updatedCodingTasks UCT
                JOIN Segments S                 ON S.SegmentId                  = UCT.SegmentId
                JOIN CodingElements CE          ON CE.CodingElementId           = UCT.CodingElementId
                JOIN StudyDictionaryVersion SDV ON SDV.StudyDictionaryVersionID = CE.StudyDictionaryVersionId
                JOIN TrackableObjects ST        ON ST.TrackableObjectId         = SDV.StudyId
                JOIN SourceSystems SS           ON SS.SourceSystemId            = CE.SourceSystemId
        ORDER BY Segment
               ,Study
               ,Subject
               ,Form
               ,Field
    END
GO
