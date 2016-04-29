/* --------------------------------------------------------------------------------------------------

// Copyright(c) 2015, Medidata Solutions, Inc., All Rights Reserved.

//

// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 

// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author:		Bonnie Pan
// Created:		26 Jun 2014 
// Updated by:	Dan Dapper
// Update date:	17 Feb 2015
// Updated by:	Harisudhan Sivasubramanian
// Update date:	02 Mar 2015
//
//
// Invalidate task(s) by UUID.  @comment argument should be '(WR #)'.
// 02 Mar 2015 - Updated WorkFlow state 2015.1
-----------------------------------------------------------------------------------------------------*/


IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   type = 'P'
                    AND name = 'CMP_ResetCodingElementsToStart' ) 
    DROP  PROCEDURE  CMP_ResetCodingElementsToStart

GO

CREATE PROCEDURE dbo.CMP_ResetCodingElementsToStart
    (
     @segmentName VARCHAR(250)
    ,@commaDelimitedUUIDs NVARCHAR(MAX)
    ,@comment VARCHAR(500)
    )
AS 
    BEGIN

        DECLARE @segmentId INT
           ,@startId INT = 1
           ,@errorString NVARCHAR(MAX)

        SELECT  @segmentId = SegmentId
        FROM    Segments
        WHERE   SegmentName = @segmentName

        IF ( @segmentId IS NULL ) 
            BEGIN

                SELECT  'Cannot find Segment'

                RETURN 0

            END

        DECLARE @UUIDs TABLE
            (
             UUID NVARCHAR(100) PRIMARY KEY
            ,CodingElementId INT
            ,SegmentId INT
            )

        INSERT  INTO @UUIDs
                ( 
                 UUID
                ,CodingElementId
                ,SegmentId

              )
                SELECT  item
                       ,-1
                       ,-1
                FROM    dbo.fnParseDelimitedString(@commaDelimitedUUIDs , ',')

        UPDATE  @UUIDs
        SET     CodingElementId = CE.CodingElementId
               ,SegmentId = CE.SegmentId
        FROM    @UUIDs t
                INNER JOIN CodingElements CE ON CE.SegmentId = @SegmentId
                                                AND CE.UUID = t.UUID


        IF EXISTS ( SELECT  NULL
                    FROM    @UUIDs
                    WHERE   SegmentId <> @SegmentID ) 
            BEGIN

                SET @errorString = N'ERROR: UUIDs are not in segment or do not exist!'

                SELECT  *
                FROM    @UUIDs
                WHERE   SegmentId <> @SegmentID

                RAISERROR(@errorString, 16, 1)

                RETURN 1

            END


        DECLARE @taskIds TABLE
            (
             CodingElementId BIGINT PRIMARY KEY
            ,CodingElementGroupID BIGINT
            )

        BEGIN TRY

            BEGIN TRANSACTION

            UPDATE  CE
            SET     CE.WorkflowStateId = @startId
                   ,CE.IsClosed = 0
                   ,CE.IsInvalidTask = 0
                   ,CE.AutoCodeDate = NULL
                   ,CE.AssignedSegmentedGroupCodingPatternId = -1
                   ,CE.AssignedTermText = ''
                   ,CE.AssignedTermCode = ''
                   ,CE.AssignedCodingPath = ''
                   ,CE.CacheVersion = CE.CacheVersion + 2
            OUTPUT  inserted.CodingElementId
                   ,inserted.CodingElementGroupID
                    INTO @taskIds ( CodingElementId , CodingElementGroupID )
            FROM    CODINGELEMENTS CE
                    JOIN @UUIDS T ON T.SEGMENTID = CE.SEGMENTID
                                     AND T.UUID = CE.UUID

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
                    SELECT  T.CodingElementId
                           ,@startId
                           ,NULL
                           ,NULL
                           ,-2
                           ,@comment
                           ,@segmentId
                           ,-1
                           ,T.CodingElementGroupID
                           ,0
                    FROM    @taskIds T

            COMMIT TRANSACTION

        END TRY

        BEGIN CATCH

            ROLLBACK TRANSACTION

            SET @errorString = N'CMP ERROR: Transaction Error Message - '
                + ERROR_MESSAGE()

            RAISERROR(@errorString, 16, 1)

        END CATCH	
        
    END