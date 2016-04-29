IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationClearOldSuggestions')
    DROP PROCEDURE spStudyMigrationClearOldSuggestions
GO

CREATE PROCEDURE dbo.spStudyMigrationClearOldSuggestions 
    (
     @SegmentID INT
    ,@StudyDictionaryVersionID INT
	,@TargetMigrationTraceId INT
    ,@RowNumbers INT
    ,@DeleteCount INT OUTPUT
    )
AS 
    BEGIN  

        -- *** CLEANUP : REMOVE Suggestions
        DELETE TOP ( @RowNumbers )
        FROM    CodingSuggestions
        WHERE   SegmentID = @SegmentID
				AND MigrationTraceId = @TargetMigrationTraceId
                AND CodingElementID IN (
                SELECT  CodingElementID
                FROM    CodingElements
                WHERE   SegmentID = @SegmentID
                        AND StudyDictionaryVersionID = @StudyDictionaryVersionID )
                            
        SELECT  @DeleteCount = @@ROWCOUNT	
    END
GO 

