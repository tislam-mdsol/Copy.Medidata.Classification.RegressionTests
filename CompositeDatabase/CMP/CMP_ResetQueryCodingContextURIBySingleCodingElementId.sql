/* --------------------------------------------------------------------------------------------------

// Copyright(c) 2015, Medidata Solutions, Inc., All Rights Reserved.
/
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 

// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// CMP_ResetQueryCodingContextURIBySingleCodingElementId
//
// Created by:	Dan Dapper
// Date:		31 May 2015

// When coderqueries.codingcontextURI is out of date with respect to Rave, queries cannot be transmitted
// Sometimess it is appropriate to resolve such queries, sometimes it is appropriate to transmit them.
// This CMP allows them to be transmitted.
//
// @codingElementId can be obtained from Coding History Report or from Coder database copy
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
-----------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE   type = 'P' AND name = 'CMP_ResetQueryCodingContextURIBySingleCodingElementId') 
    DROP PROCEDURE CMP_ResetQueryCodingContextURIBySingleCodingElementId
GO

CREATE PROCEDURE dbo.CMP_ResetQueryCodingContextURIBySingleCodingElementId
(
	 @segmentName VARCHAR(250)
	,@codingElementId INT
    ,@comment VARCHAR(500)
)
AS 
    BEGIN
        DECLARE 
			 @segmentId INT
			,@queryId INT
			,@currentQueryURI NVARCHAR(4000)
			,@currentCeURI NVARCHAR(4000)
			,@errorString NVARCHAR(MAX)
			,@dt DATETIME = GETUTCDATE()

		SET @comment = 'Reset query context ' + @comment

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
			 @queryId = CQ.queryId 
			,@currentQueryURI = CQ.CodingContextURI
			,@currentCEURI = CE.CodingContextURI
		FROM CodingElements CE
		JOIN (select codingelementid, MAX(queryid) queryId  FROM CoderQueries GROUP BY codingElementId) CQMAX  on CQMAX.codingelementid = CE.codingelementid
		JOIN CoderQueries CQ on CQ.queryid = CQMAX.queryId
		WHERE
			CE.CodingElementId = @codingElementId


		IF @queryId IS NULL 
            BEGIN
				SET @errorString = 'codingElementId ' + cast(@codingelementid as nvarchar(max)) + ': cannot find queryId'
				SELECT @errorString
				RAISERROR(@errorString, 16, 1)
                RETURN -1
            END

		
		IF @currentQueryURI = @currentCeURI
			BEGIN
				SET @errorString = 'Query codingcontextURI equals codingelement codingcontextURI'
				SELECT @errorString
				RAISERROR(@errorString, 16, 1)
                RETURN -1
            END	

        BEGIN TRY
		BEGIN TRANSACTION

			UPDATE CQ
			SET 
				CodingContextURI = @currentCEURI,
				Updated = @dt
			FROM 
				 CoderQueries CQ
			WHERE
				CQ.QueryId = @queryId


			/*

			EXEC dbo.spCoderQueryHistoryInsert  
				 @QueryRepeatKey = ''
				,@QueryStatus = @queryStatus 
				,@PriorQueryStatus = @queryStatus
				,@Recipient = ''
				,@QueryText = ''
				,@QueryResponse = @comment
				,@UserRef = 'support'
				,@DateTimeStamp = @dt
				,@QueryId = @queryId
				,@Created  = NULL
				,@QueryHistoryId = NULL

			*/


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