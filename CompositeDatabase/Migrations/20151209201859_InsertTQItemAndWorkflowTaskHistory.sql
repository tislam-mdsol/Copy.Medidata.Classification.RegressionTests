IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   type = 'P'
                    AND name = 'CMP_FixMissingTQItem' ) 
    DROP PROCEDURE CMP_FixMissingTQItem

GO

CREATE PROCEDURE dbo.CMP_FixMissingTQItem 
(
 @SegmentName VARCHAR(250),
 @CommaDelimitedCodingElementIds varchar(max)
)
AS 
    BEGIN

		DECLARE @SegmentId INT
			   ,@errorString NVARCHAR(MAX), @False bit = 0, @True bit = 1,  @UtcDate DateTime = GetUtcDate()

        SELECT  @SegmentId = SegmentId
        FROM    Segments
        WHERE   SegmentName = @SegmentName
		DECLARE @CodingElementIds TABLE (CodingElementId BIGINT PRIMARY KEY, SegmentId int)
		DECLARE @OutputTransmissionQueueItem TABLE (TransmissionQueueItemId BIGINT PRIMARY KEY, CodingAssignmentId bigint)
		DECLARE @OutputWorkflowTaskHistory TABLE (WorkflowTaskHistoryId BIGINT PRIMARY KEY, CodingElementId bigint)

		INSERT INTO @CodingElementIds(CodingElementId, SegmentId)
		
		SELECT distinct *, -1 FROM dbo.fnParseDelimitedString(@CommaDelimitedCodingElementIds,',')
	
		BEGIN TRY

			BEGIN TRANSACTION

			UPDATE
				@CodingElementIds
			SET
				SegmentId = CodingElements.SegmentId
			FROM
				@CodingElementIds t
			INNER JOIN
				CodingElements
			ON
				t.CodingElementId = CodingElements.CodingElementId
		
			IF EXISTS (SELECT NULL FROM @CodingElementIds WHERE SegmentId <> @SegmentID)
			BEGIN
			
				Select @errorString = Coalesce(@errorString+', ','ERROR: CodingElementIds are not in segment or do not exist: ')+ Convert(varchar,CodingElementId)
				FROM @CodingElementIds WHERE SegmentId <> @SegmentID 
			
				PRINT @errorString
				RAISERROR(@errorString, 16, 1)
				RETURN 1
			END

			Insert into TransmissionQueueItems
			(ObjectTypeId,  
			 ObjectID,
			 StudyOID,
			 FailureCount,
			 SuccessCount,
			 SourceSystemId,
			 SegmentId,
			 CumulativeFailCount,
			 OutTransmissionId,
			 ServiceWillContinueSending,
			 IsForUnloadService,
			 Created,
			 Updated)
			Output inserted.[TransmissionQueueItemID],inserted.ObjectId into @OutputTransmissionQueueItem
			Select 
				   Case when UUID is null then 2251 --partial coding decision
				   else 2255 end as ObjectTypeId,   --full coding decision
				   wth1.CodingAssignmentId as ObjectID,
				   obj.ExternalObjectId as StudyOID,
				   0 as FailureCount,
				   0 as SuccessCount,
				   ce.SourceSystemId,
				   ce.SegmentId,
				   0 as CumulativeFailCount,
				   0 as OutTransmissionId,
				   @True as ServiceWillContinueSending,
				   @False as IsForUnloadService,
				   @UtcDate as Created,
				   @UtcDate as Updated
			from codingElements ce
			inner join @CodingElementIds t
			on ce.CodingElementId = t.CodingElementId
			inner join studydictionaryversion sdv
			on ce.StudyDictionaryVersionID = sdv.StudyDictionaryVersionID
			inner join TrackableObjects obj
			on sdv.StudyID = obj.TrackableObjectID
			inner join WorkflowTaskHistory wth1
			on ce.CodingElementId = wth1.WorkflowTaskId 
			--take the most current history record
			LEFT OUTER JOIN WorkflowTaskHistory wth2 ON (ce.CodingElementId = wth2.WorkflowTaskId AND 
			(wth1.Created < wth2.Created  OR wth1.Created = wth2.Created  AND wth1.WorkflowTaskHistoryId < wth2.WorkflowTaskHistoryId ))
			-- prevent from inserting tqi when it already exists
			LEFT OUTER JOIN [dbo].[TransmissionQueueItems] tqi 
			on wth1.CodingAssignmentId = tqi.ObjectId
			WHERE wth2.WorkflowTaskHistoryId IS NULL and wth1.WorkflowStateId = 5 and wth1.CodingAssignmentId is not null and tqi.[TransmissionQueueItemID] is null

			--create workflow task history
			INSERT INTO dbo.WorkflowTaskHistory (
				WorkflowTaskID,
				WorkflowStateID,
				WorkflowActionID,
				WorkflowSystemActionID,
				UserID,
				CodingAssignmentId,
				Comment,
				Created,
				SegmentID,
				CodingElementGroupId,
				QueryId
			)
			Output inserted.WorkflowTaskHistoryID, inserted.WorkflowTaskID into @OutputWorkflowTaskHistory
			Select 
    		ce.CodingElementId,
    		ce.WorkflowStateId,
    		null as WorkflowActionId,
    		9 as WorkflowSystemActionId, --TransmitCoding
    		wth1.UserId,
    		ca.CodingAssignmentId as ObjectID,
    		'Transmission Queue Number:' + Convert(varchar, o.TransmissionQueueItemID) as Comment,
    		@UtcDate as Created,
    		ce.SegmentId,
    		ce.CodingElementGroupID,
    		0 as QueryId
			from @OutputTransmissionQueueItem o
			inner join CodingAssignment ca
			on o.CodingAssignmentId = ca.CodingAssignmentID
			inner join codingElements ce
			on ce.CodingElementId = ca.CodingElementId
			inner join WorkflowTaskHistory wth1
			on ce.CodingElementId = wth1.WorkflowTaskId 
			--take the most current history record
			LEFT OUTER JOIN WorkflowTaskHistory wth2 ON (ce.CodingElementId = wth2.WorkflowTaskId AND 
			(wth1.Created < wth2.Created  OR wth1.Created = wth2.Created  AND wth1.WorkflowTaskHistoryId < wth2.WorkflowTaskHistoryId ))
			WHERE wth2.WorkflowTaskHistoryId IS NULL and wth1.WorkflowStateId = 5 and wth1.CodingAssignmentId is not null

			Declare @OutputString1 varchar(max), @OutputString2 varchar(max)

			Select  @OutputString1 = Coalesce(@OutputString1+', ','Transmission Queue Items created - (CodingElementId:TransmissionQueueItemId)')
				+ Convert(varchar,ca.CodingElementId)+':'+Convert(varchar,tqi.TransmissionQueueItemId)
				from @OutputTransmissionQueueItem tqi
				inner join CodingAssignment ca
				on tqi.CodingAssignmentId = ca.CodingAssignmentId
		
			Select  @OutputString2 = Coalesce(@OutputString2+', ','Workflow Task History created - (CodingElementId:WorkflowTaskHistoryId)')
				+ Convert(varchar,CodingElementId)+':'+Convert(varchar,WorkflowTaskHistoryId)
				from @OutputWorkflowTaskHistory

			Print @OutputString1;
			Print @OutputString2;
			COMMIT TRANSACTION

		END TRY

        BEGIN CATCH

            ROLLBACK TRANSACTION

            SET @errorString = N'CMP ERROR: Transaction Error Message - '
                + ERROR_MESSAGE()

            PRINT @errorString

            RAISERROR(@errorString, 16, 1)

        END CATCH	
End