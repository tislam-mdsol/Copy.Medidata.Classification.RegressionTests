

/* --------------------------------------------------------------------------------------------------

// Copyright(c) 2015, Medidata Solutions, Inc., All Rights Reserved.
/
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 

// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// CMP_SetCodingContextURIByCodingElementID
//
// Created by:	Darshan Mehta, Dan Dapper
// Date:		06 July 2015
// 
// Intended use:	update contexthash on codingelement on contexthash from coder (when proper means fail)
//					so that codindecision will post to Rave.

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


If exists (select * from sys.objects where name ='CMP_SetCodingContextURIByCodingElementID')
	DROP procedure CMP_SetCodingContextURIByCodingElementID
GO
CREATE PROCEDURE CMP_SetCodingContextURIByCodingElementID
(
	 @segmentName VARCHAR(250)
	,@codingElementId INT
	,@oldCodingContextURI NVARCHAR(MAX)
	,@newCodingContextURI NVARCHAR(MAX)
    ,@comment VARCHAR(500)
)
AS 
    BEGIN
        DECLARE 
			 @segmentId INT
			,@currentCodingContextURI NVARCHAR(4000)
			,@errorString NVARCHAR(MAX)
			,@dt DATETIME = GETUTCDATE()

		
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
			@currentCodingContextURI = CE.CodingContextURI
		FROM CodingElements CE
		WHERE
			CE.CodingElementId = @codingElementId AND
			CE.SegmentId = @segmentId

		IF ISNULL(@currentCodingContextURI,'') = ''  
        BEGIN
			SET @errorString = 'Cannot find coding element'
			SELECT @errorString
			RAISERROR(@errorString, 16, 1)
            RETURN -1
        END

		IF @oldCodingContextURI IS NOT NULL AND @oldCodingContextURI <> @currentCodingContextURI
		BEGIN				
			SET @errorString = 'CodingElementId ' + cast(@codingelementid as nvarchar(max)) + ': cannot find context hash ' + @oldCodingContextURI + '.'
			SELECT @errorString
			RAISERROR(@errorString, 16, 1)
			RETURN -1
        END
			
		BEGIN TRY

			--1) UPDATING CODINGCONTEXTURI
				UPDATE CE
				SET 
					CE.CodingContextURI = @newCodingContextURI,
					CE.CacheVersion = CE.CacheVersion + 2
				FROM 
					 CodingElements CE
				WHERE
					CE.CodingElementId = @codingElementId AND
					CE.SegmentId = @segmentId

			SET @comment = 'Reset coding context uri from "' + @currentCodingContextURI+'" to "'+@newCodingContextURI +'". ' + @comment
		
			--2) INSERTING AN AUDIT FOR THE SAME
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
					,0
				FROM 
					CodingElements CE
				WHERE
					CE.CodingElementID = @codingElementId AND
					CE.SegmentId = @segmentId
 

		END TRY

        BEGIN CATCH
		       
            SET @errorString = N'CMP ERROR: Transaction Error Message - '
                + ERROR_MESSAGE()

            RAISERROR(@errorString, 16, 1)

        END CATCH	
    END