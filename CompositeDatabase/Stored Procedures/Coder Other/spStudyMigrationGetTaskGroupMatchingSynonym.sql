IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationGetTaskGroupMatchingSynonym')
	DROP PROCEDURE spStudyMigrationGetTaskGroupMatchingSynonym
GO

CREATE PROCEDURE dbo.spStudyMigrationGetTaskGroupMatchingSynonym 
(
	@StudyDictionaryVersionID INT,
	@ToSynonymMgmtId INT,
	@RowCount INT,
	@LastRowId BIGINT
)
AS  
BEGIN 

	-- find task that belongs to a group that has a synonym in the next version
	SELECT TOP (@RowCount) 
		CE.CodingElementId,
		SGCP.SegmentedGroupCodingPatternID, 
		CP.CodingPath
	FROM CodingElements CE WITH (NOLOCK)
		JOIN StudyMigrationBackup SMB 
			ON CE.CodingElementId        = SMB.CodingElementID 
			AND SMB.MigrationChangeType  = -1
		JOIN SegmentedGroupCodingPatterns SGCP 
			ON SGCP.CodingElementGroupID = CE.CodingElementGroupID
			AND SGCP.SynonymManagementID = @ToSynonymMgmtID
			AND SGCP.SynonymStatus       = 2
		JOIN CodingPatterns CP
			ON CP.CodingPatternID        = SGCP.CodingPatternID
	WHERE CE.StudyDictionaryVersionId    = @StudyDictionaryVersionID
		AND IsInvalidTask                = 0
		AND CE.CodingElementId > @LastRowId
	ORDER BY CodingElementId ASC

END

GO 
 