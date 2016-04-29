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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationClearAllAssignments')
    DROP PROCEDURE spStudyMigrationClearAllAssignments
GO

CREATE PROCEDURE dbo.spStudyMigrationClearAllAssignments 
(
     @StudyDictionaryVersionId INT
    ,@RowNumbers INT
    ,@ClearedCount INT OUTPUT
    )
AS 
    BEGIN  

        -- *** CLEAR ALL OLD Assignments
        UPDATE TOP ( @RowNumbers )
                CA
        SET     CA.Active = 0
        FROM    CodingAssignment CA
                JOIN CodingElements (NOLOCK) CE ON CA.CodingElementID = CE.CodingElementId
                                                   AND CA.Active = 1
        WHERE   CE.StudyDictionaryVersionId = @StudyDictionaryVersionId
                AND CE.IsInvalidTask = 0
                
        SELECT  @ClearedCount = @@ROWCOUNT
    

    END
GO 
