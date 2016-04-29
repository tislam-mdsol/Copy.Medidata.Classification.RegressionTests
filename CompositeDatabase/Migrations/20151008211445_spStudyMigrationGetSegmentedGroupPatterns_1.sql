IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationGetSegmentedGroupPatterns')
	DROP PROCEDURE spStudyMigrationGetSegmentedGroupPatterns
GO

CREATE PROCEDURE dbo.spStudyMigrationGetSegmentedGroupPatterns 
(
    @SegmentId INT,
    @StudyDictionaryVersionId INT,
    @ToSynonymMgmtId INT,
    @RowNumbers INT,
	@LastRowId BIGINT
)
AS  
BEGIN  

	;WITH MigrationPage AS
	(
		SELECT TOP (@rowNumbers) 
			CE.CodingElementId, 
			SGCP_Past.CodingPatternID AS CodingPatternID,
			SGCP_Past.CodingElementGroupID AS CodingElementGroupID,
			SGCP_Future.SegmentedGroupCodingPatternID AS Future_SegmentedGroupCodingPatternID,
			SGCP_Future.CodingPatternId AS Future_CodingPatternId
		FROM CodingElements CE
		WITH (NOLOCK)
			JOIN StudyMigrationBackup SMB 
                ON CE.CodingElementId                      = SMB.CodingElementID 
                AND SMB.MigrationChangeType                = -1
			JOIN SegmentedGroupCodingPatterns SGCP_Past
				ON SGCP_Past.SegmentedGroupCodingPatternID = CE.AssignedSegmentedGroupCodingPatternId
				AND SGCP_Past.Active                       = 1
				AND SGCP_Past.SegmentID                    = @SegmentId
			LEFT JOIN SegmentedGroupCodingPatterns SGCP_Future
				ON CE.CodingElementGroupID                 = SGCP_Future.CodingElementGroupID
				AND SGCP_Past.CodingPatternID              = SGCP_Future.CodingPatternID
				AND SGCP_Future.SynonymManagementID        = @ToSynonymMgmtId
				AND SGCP_Future.Active                     = 1
				AND SGCP_Future.SegmentID                  = @SegmentId
			WHERE CE.StudyDictionaryVersionId              = @StudyDictionaryVersionId
				AND CE.IsInvalidTask                       = 0
				AND	CE.CodingElementID > @LastRowId
		ORDER BY CE.CodingElementID ASC
	)

	SELECT 
		CodingElementId, 
		CP.MedicalDictionaryLevelKey,
		MP.CodingPatternID,
		CodingElementGroupID,
		Future_SegmentedGroupCodingPatternID,
		CP.CodingPath AS CodingPath,
		CP_Future.CodingPath AS Future_CodingPath
	FROM MigrationPage MP
		JOIN CodingPatterns CP
			ON MP.CodingPatternID = CP.CodingPatternId
		LEFT JOIN CodingPatterns CP_Future
			ON MP.Future_CodingPatternId = CP.CodingPatternId

END
GO 