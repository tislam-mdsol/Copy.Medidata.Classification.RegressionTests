/* --------------------------------------------------------------------------------------------------

// Copyright(c) 2015, Medidata Solutions, Inc., All Rights Reserved.
/
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 

// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// CMP_UpdateQueryStatusBySingleCodingElementId_And_Dt
//
// Created by:	Dan Dapper
// Date:		31 May 2015

// Written to be flexible, but intended to cancel queries, or close queries closed in Rave,
// depending on scenario.

// Query status codes
//		0 'None'
//		1 'Queued'
//		2 'Open'
//		3 'Answered'
//		4 'Cancelled'
//		5 'Closed'
//
//
// Sample @comment formats: 
//
// If MCC available:
//		'(WR # MCC #)'
//		'(WR # MCC #)'
//  If MCC not available:
//		'(WR #)'
//		'(WR #)'
//
//  To obtain datetime from query histoory in UI
//
//	declare @dt datetime
//	set @dt = cast('13 May 2015 03:33:51 PM' as datetime)


-----------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE   type = 'P' AND name = 'CMP_UpdateQueryStatusBySingleCodingElementId_And_Dt') 
    DROP PROCEDURE CMP_UpdateQueryStatusBySingleCodingElementId_And_Dt
GO

CREATE PROCEDURE dbo.CMP_UpdateQueryStatusBySingleCodingElementId_And_Dt
(
	 @segmentName VARCHAR(250)
	,@codingElementId INT
	,@checkDt DATETIME
	,@newQueryStatus TINYINT
    ,@comment VARCHAR(500)
)
AS 
    BEGIN
        DECLARE 
			 @segmentId INT
			,@queryId INT
			,@oldQueryStatus TINYINT
			,@latestUpdate DATETIME
			,@errorString NVARCHAR(MAX)
			,@dt DATETIME = GETUTCDATE()
			
		SET @comment = dbo.fnQueryStatus(@newQueryStatus) + ' query ' + @comment

	
        SELECT  @segmentId = SegmentId
        FROM    Segments
        WHERE   SegmentName = @segmentName

		IF @segmentId IS NULL 
            BEGIN
				SET @errorString = 'Cannot find segment'
				SELECT @errorString
				RAISERROR(@errorString, 16, 1)
                RETURN -1
            END

													
		SELECT 
			@queryId = MAX(CQ.queryId)
		FROM CoderQueries CQ
		WHERE CQ.CodingElementId = @codingElementId


		IF @queryId IS NULL 
            BEGIN
				SET @errorString = 'codingElementId ' + cast(@codingelementid as nvarchar(max)) + ': cannot find queryId'
				SELECT @errorString
				RAISERROR(@errorString, 16, 1)
                RETURN -1
            END


		SELECT
			@latestUpdate = MAX(CQH.Created)
		FROM
			CoderQueryHistory CQH
		WHERE 
			CQH.QueryId = @queryId


		IF @latestUpdate > @checkDt
			BEGIN
				SET @errorString = 'codingElementId ' + cast(@codingelementid as nvarchar(max)) + ': most recent cqh.created > checkDt'
				SELECT @errorString
				RAISERROR(@errorString, 16, 1)
                RETURN -1
            END		


		SELECT @oldQueryStatus = CE.queryStatus
		FROM CodingElements CE
		WHERE
			CE.CodingElementId = @codingElementId


        BEGIN TRY
		BEGIN TRANSACTION

			UPDATE CE
			SET 
				QueryStatus = @newQueryStatus
				,CE.CacheVersion = CE.CacheVersion + 2
			FROM 
				CodingElements CE 
			WHERE 
				CE.CodingElementId = @codingElementId

			-- audit change in both coderqueryhistory and workflowtaskhistory

			EXEC dbo.spCoderQueryHistoryInsert  
				 @QueryRepeatKey = ''
				,@QueryStatus = @newQueryStatus 
				,@PriorQueryStatus = @oldQueryStatus
				,@Recipient = ''
				,@QueryText = ''
				,@QueryResponse = @comment
				,@UserRef = 'support'
				,@DateTimeStamp = @dt
				,@QueryId = @queryId
				,@Created  = NULL
				,@QueryHistoryId = NULL


			INSERT  INTO WorkflowTaskHistory
			( 
				 WorkflowTaskID
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
			SELECT  
				 CE.codingElementId
				,CE.workflowStateId
				,NULL
				,NULL
				,-2
				,@comment
				,@segmentId
				,-1
				,CE.codingElementGroupID
				,@queryId
			FROM 
				CodingElements CE
			WHERE
				CE.CodingElementID = @codingElementId
 

		COMMIT TRANSACTION
        END TRY

        BEGIN CATCH

            ROLLBACK TRANSACTION

            SET @errorString = N'CMP ERROR: Transaction Error Message - '
                + ERROR_MESSAGE()

            RAISERROR(@errorString, 16, 1)

        END CATCH	

    END

