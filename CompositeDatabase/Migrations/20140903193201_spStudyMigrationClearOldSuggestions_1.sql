/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationClearOldSuggestions')
    DROP PROCEDURE spStudyMigrationClearOldSuggestions
GO

CREATE PROCEDURE dbo.spStudyMigrationClearOldSuggestions 
    (
     @SegmentID INT
    ,@StudyDictionaryVersionID INT
    ,@VersionID INT
    ,@RowNumbers INT
    ,@DeleteCount INT OUTPUT
    )
AS 
    BEGIN  

        -- *** CLEANUP : REMOVE OLD Suggestions
        DELETE TOP ( @RowNumbers )
        FROM    CodingSuggestions
        WHERE   SegmentID = @SegmentID
                AND DictionaryVersionID = @VersionID
                AND CodingElementID IN (
                SELECT  CodingElementID
                FROM    CodingElements
                WHERE   SegmentID = @SegmentID
                        AND StudyDictionaryVersionID = @StudyDictionaryVersionID )
                            
        SELECT  @DeleteCount = @@ROWCOUNT	
    END
GO 
 