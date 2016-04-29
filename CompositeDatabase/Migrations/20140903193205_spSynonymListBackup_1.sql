/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymListBackup')
    DROP PROCEDURE spSynonymListBackup
GO

CREATE PROCEDURE dbo.spSynonymListBackup 
(
     @FromSynonymListID INT
    ,@SynonymListID INT
    ,@UserId INT
    ,@SynonymEntryMigrationStatus INT
    ,@RowNumbers INT
    ,@MinID BIGINT OUTPUT
    ,@ActionCount INT OUTPUT
    )
AS 
    BEGIN  

        DECLARE @NewIds TABLE ( Id BIGINT ) 
        
        ;WITH    xCTE
                      AS ( SELECT TOP ( @RowNumbers )
                                    SegmentedGroupCodingPatternID
                           FROM     SegmentedGroupCodingPatterns
                           WHERE    SynonymManagementID = @FromSynonymListID
                                    AND SegmentedGroupCodingPatternID > @MinID
                                    AND Active = 1
                                    AND SynonymStatus > 0
                           ORDER BY SegmentedGroupCodingPatternID ASC
                         )
            INSERT  INTO SynonymMigrationEntries
                    ( 
                     SegmentedGroupCodingPatternID
                    ,SynonymMigrationMngmtID
                    ,AreSuggestionsGenerated
                    ,SynonymMigrationStatusRID
                    ,SelectedSuggestionId
                    ,UserID
                    )
            OUTPUT  inserted.SegmentedGroupCodingPatternID
                    INTO @NewIds
                    SELECT  SegmentedGroupCodingPatternID
                           ,@SynonymListID
                           ,0
                           ,@SynonymEntryMigrationStatus
                           ,-1
                           ,@UserId
                    FROM    xCTE
    
        SELECT  @MinID = MAX(Id)
        FROM    @NewIds
        
        SELECT @ActionCount = @@ROWCOUNT

    END

GO
