IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationClearOldBackup')
    DROP PROCEDURE spStudyMigrationClearOldBackup
GO

CREATE PROCEDURE dbo.spStudyMigrationClearOldBackup 
    (
     @StudyDictionaryVersionID INT
    ,@RowNumbers INT
    ,@CountCleared INT OUT
    )
AS 
    BEGIN  

    -- *** CLEANUP : REMOVE OLD Backup

        DELETE TOP ( @RowNumbers )
        FROM    StudyMigrationBackup
        WHERE   StudyDictionaryVersionID = @StudyDictionaryVersionID

        SELECT  @CountCleared = @@ROWCOUNT

    END
GO 