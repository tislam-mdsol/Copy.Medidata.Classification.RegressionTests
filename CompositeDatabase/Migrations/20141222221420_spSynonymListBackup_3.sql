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
    
        SELECT @ActionCount = ISNULL(@@ROWCOUNT, 0)

        SELECT  @MinID = ISNULL(MAX(Id), 0)
        FROM    @NewIds
        

    END

GO
