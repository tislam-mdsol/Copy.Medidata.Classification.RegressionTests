/* --------------------------------------------------------------------------------------------------

// Copyright(c) 2015, Medidata Solutions, Inc., All Rights Reserved.

//

// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 

// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// This will reset coding elements to the initial state
// This will be used to resolve MCC-165514 'Term not found'
// In combination with the results from Diagnose 
//
// Invalidate task(s) by Coding Element ID  @comment argument should be '(WR #)'.
-----------------------------------------------------------------------------------------------------*/

IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   type = 'P'
                    AND name = 'CMP_ResetCodingElementsToStartByCodingElementID' ) 
    DROP PROCEDURE CMP_ResetCodingElementsToStartByCodingElementID

GO

CREATE PROCEDURE dbo.CMP_ResetCodingElementsToStartByCodingElementID
    (
     @segmentName VARCHAR(250)
    ,@commaDelimitedCodingElementIDs NVARCHAR(MAX)
	,@comment VARCHAR(500)
	,@workflowstateid  INT = NULL    
    )
AS 
    BEGIN
    
        DECLARE @segmentId INT
           ,@startId INT
           ,@errorString NVARCHAR(MAX)

        SELECT  @segmentId = SegmentId
        FROM    Segments
        WHERE   SegmentName = @segmentName


        IF ( @segmentId IS NULL ) 
            BEGIN

                SELECT  'Cannot find Segment'

                RETURN 0

            END
     

        DECLARE @codingElementIDs TABLE
            (
				CodingElementId INT
				,SegmentId INT
            )	

        INSERT  INTO @codingElementIDs
            ( 
                CodingElementId
				,SegmentId
            )
            SELECT  item
                    ,@segmentId
            FROM    dbo.fnParseDelimitedString(@commaDelimitedCodingElementIDs , ',')
        
		--set startId to initial state      
        SELECT  @startId = 1

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
                    JOIN @codingElementIDs T ON T.SEGMENTID = CE.SEGMENTID
                    AND T.CodingElementId = CE.CodingElementId
		
			WHERE (	@workflowstateid is NULL) 
					OR 
				  ( (@workflowstateid between 1 and 6)  and CE.WorkflowStateID = @workflowstateid )  --Added parameter



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

        --PRINT @errorString

            RAISERROR(@errorString, 16, 1)

        END CATCH	

    END