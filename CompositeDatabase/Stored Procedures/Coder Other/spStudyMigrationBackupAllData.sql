IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationBackupAllData')
    DROP PROCEDURE spStudyMigrationBackupAllData
GO

CREATE PROCEDURE dbo.spStudyMigrationBackupAllData 
    (
     @FromVersionLocaleKey NVARCHAR(100)
    ,@StudyDictionaryVersionId INT
    ,@RowNumbers INT
    ,@MinCodingElementId BIGINT OUTPUT
    ,@CountBackedUp INT OUTPUT
    )
AS 
    BEGIN

        -- **** BACKUP ALL OLD TASK DATA
        DECLARE @AuxTT2 TABLE ( Id BIGINT ) ;
            WITH    xCTE
                      AS ( SELECT TOP ( @RowNumbers )
                                    *
                           FROM     CodingElements
                           WHERE    StudyDictionaryVersionId = @StudyDictionaryVersionId
                                    AND IsInvalidTask = 0
                                    AND CodingElementId > @MinCodingElementId
                           ORDER BY CodingElementId ASC
                         )
            INSERT  INTO StudyMigrationBackup
                    ( 
                     CodingElementID
                    ,StudyDictionaryVersionID
                    ,OldState
                    ,OldIsClosed
                    ,OldCodingAssignment
                    ,OldSegmentedGroupCodingPatternID
                    ,OldCodingPath
                    ,OldTermCode
                    ,OldText
                    ,MedicalDictionaryVersionLocaleKey
                    ,OldQueryStatus
                )
            OUTPUT  inserted.CodingElementID
                    INTO @AuxTT2
                    SELECT  CE.CodingElementId
                           ,@StudyDictionaryVersionID
                           ,CE.WorkflowStateID
                           ,CE.IsClosed
                           ,CA.CodingAssignmentID
                           ,CE.AssignedSegmentedGroupCodingPatternId
                           ,CE.AssignedCodingPath
                           ,CE.AssignedTermCode
                           ,CE.AssignedTermText
                           ,@FromVersionLocaleKey
                           ,CE.QueryStatus
                    FROM    xCTE CE
                            CROSS APPLY ( SELECT    CodingAssignmentID = ISNULL(MAX(C.CodingAssignmentID) ,
                                                              -1)
                                          FROM      ( SELECT TOP 1
                                                              CodingAssignmentID
                                                      FROM    CodingAssignment
                                                      WHERE   CodingElementId = CE.CodingElementId
                                                              AND Active = 1
                                                      ORDER BY Created DESC
                                                    ) AS C
                                        ) AS CA

		SELECT @CountBackedUp = @@ROWCOUNT
        SELECT  @MinCodingElementId = ISNULL(MAX(Id),-1)
        FROM    @AuxTT2
        
        

    END

GO 
 