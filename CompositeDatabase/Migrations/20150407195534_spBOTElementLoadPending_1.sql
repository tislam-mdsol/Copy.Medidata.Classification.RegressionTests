IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spBOTElementLoadPending')
	DROP PROCEDURE spBOTElementLoadPending
GO

CREATE PROCEDURE dbo.spBOTElementLoadPending
(
	@WorkflowBOTTaskType INT,
    @IsForwardBOT BIT,
    @DictionaryVersionID INT,
    @Locale CHAR(3),
    @SegmentID INT
)
AS

    SELECT BE.*
        FROM BOTElements BE
            JOIN LongAsyncTasks AT 
                ON AT.ReferenceId = BE.BOTElementID
                AND AT.LongAsyncTaskType = @WorkflowBOTTaskType
                AND AT.IsComplete = 0
            JOIN SegmentedGroupCodingPatterns SGCP
                ON BE.SegmentedCodingPatternId = SGCP.SegmentedGroupCodingPatternID
			JOIN SynonymMigrationMngmt SMM
				ON SMM.SynonymMigrationMngmtID = SGCP.SynonymManagementID
                AND SMM.DictionaryVersionId = @DictionaryVersionID
                AND SMM.Locale = @Locale
        WHERE 
            BE.SegmentId = @SegmentID
            AND BE.IsForwardBOT = @IsForwardBOT
	
GO 