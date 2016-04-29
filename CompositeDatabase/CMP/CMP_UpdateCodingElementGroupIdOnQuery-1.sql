
 

/* --------------------------------------------------------------------------------------------------

// Copyright(c) 2015, Medidata Solutions, Inc., All Rights Reserved.
/
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 

// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// CMP_UpdateCodingElementGroupIdOnQuery
//
// Created by:	Darshan Mehta
// Date:		05 June 2015

// Written to sync CodingElementGroupId on Queries with CodingElements FOR specific segments OR for all segments


// @segmentName : '' (Empty String if need to execute for all segments OR ELSE segment name)
// @comment		: comment format should be 'CodingElementGroupId updated on Query (WR XXXXXX)'


-----------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE   type = 'P' AND name = 'CMP_UpdateCodingElementGroupIdOnQuery') 
    DROP PROCEDURE CMP_UpdateCodingElementGroupIdOnQuery
GO


CREATE PROCEDURE dbo.CMP_UpdateCodingElementGroupIdOnQuery
(
	@segmentName VARCHAR(250),
	@comment VARCHAR(500) 
)
AS 
BEGIN

	DECLARE 
		@segmentId SMALLINT,
		@dt DATETIME = GETUTCDATE(),
		@errorString NVARCHAR(MAX)

	 IF ISNULL(LTRIM(RTRIM(@segmentName)),'') <> ''
		 BEGIN
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
		END
	ELSE
		BEGIN
			set @segmentId = -1 --can be executed for all segments
		END

	

	DECLARE @Temp_WFTaskHistory TABLE (CodingelementId INT, WorkflowStateID INT, SegmentId INT, CodingElementGroupId BIGINT, QueryId INT)
		
	BEGIN TRY
	BEGIN TRANSACTION

		UPDATE CQ
		SET CQ.CodingElementGroupId = CE.CodingElementGroupID
		OUTPUT
			CE.CodingElementId,
			CE.WorkflowStateID,
			CE.SegmentId,
			CE.CodingElementGroupID,
			INSERTED.QueryId --QueryId
		INTO
			@Temp_WFTaskHistory
		FROM 
			CodingElements CE 
		JOIN 
			CoderQueries CQ ON CQ.CodingElementId = CE.CodingElementId 
		WHERE 
			CQ.CodingElementGroupId 
			NOT IN (SELECT CodingElementGroupId FROM CodingElementGroups)
			AND ( CE.SegmentId = @segmentId OR @segmentId = -1 )  --- can be executed for all segments
				

			
		INSERT INTO WorkflowTaskHistory
		(
			WorkflowTaskID
			,WorkflowStateID
			,WorkflowActionID
			,WorkflowSystemActionID
			,UserID
			,Comment
			,Created   ---ADDED 
			,SegmentId
			,CodingAssignmentId
			,CodingElementGroupId
			,QueryId
		)
		SELECT 
			CE.CodingElementId,
			CE.WorkflowStateID,
			NULL,
			NULL,
			-2,
			@comment,
			@dt,
			CE.SegmentId,
			-1,
			CE.CodingElementGroupID,
			T.QueryId
		FROM 
			CodingElements CE JOIN @Temp_WFTaskHistory T ON T.CodingelementId = CE.CodingElementId
		WHERE
			CE.CodingElementId = T.CodingelementId


	ROLLBACK TRANSACTION
    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION

        SET @errorString = N'CMP ERROR: Transaction Error Message - '
            + ERROR_MESSAGE()

        RAISERROR(@errorString, 16, 1)

    END CATCH	
END