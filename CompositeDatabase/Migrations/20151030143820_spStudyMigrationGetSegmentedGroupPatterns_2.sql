IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationGetSegmentedGroupPatterns')
	DROP PROCEDURE spStudyMigrationGetSegmentedGroupPatterns
GO

-- EXEC spStudyMigrationGetSegmentedGroupPatterns 14, 105177, 60588, 'MedDRA-12_1-English', 'MedDRA-13_0-English', 10, -1

CREATE PROCEDURE dbo.spStudyMigrationGetSegmentedGroupPatterns 
(
    @SegmentId INT,
    @StudyDictionaryVersionId INT,
    @ToSynonymMgmtId INT,
    @FromDictionary NVARCHAR(200),
    @ToDictionary NVARCHAR(200),
    @RowNumbers INT,
	@LastRowId BIGINT
)
AS  
BEGIN  

	;WITH MigrationPage AS
	(
		SELECT TOP (@rowNumbers) 
			CE.CodingElementId, 
			SGCP_Past.CodingPatternID,
			CP_Past.CodingPath,
			CP_Past.MedicalDictionaryLevelKey,
			SGCP_Past.CodingElementGroupID,
			SGCP_Future.SegmentedGroupCodingPatternID AS Future_SegmentedGroupCodingPatternID,
			SGCP_Future.CodingPatternId               AS Future_CodingPatternId,
			SGCP_Future.CodingPath                    AS Future_CodingPath
		FROM CodingElements CE
		WITH (NOLOCK)
			JOIN StudyMigrationBackup SMB 
                ON CE.CodingElementId                      = SMB.CodingElementID 
                AND SMB.MigrationChangeType                = -1
			JOIN SegmentedGroupCodingPatterns SGCP_Past
				ON SGCP_Past.SegmentedGroupCodingPatternID = CE.AssignedSegmentedGroupCodingPatternId
				AND SGCP_Past.Active                       = 1
				AND SGCP_Past.SegmentID                    = @SegmentId
			JOIN CodingPatterns CP_Past
				ON CP_Past.CodingPatternId = SGCP_Past.CodingPatternID
			CROSS APPLY
			(
				SELECT 
					MAX(SGCP_Future.SegmentedGroupCodingPatternID) AS SegmentedGroupCodingPatternID,
					MAX(SGCP_Future.CodingPatternId)               AS CodingPatternId,
					MAX(CP_Future.CodingPath)                      AS CodingPath
				FROM SegmentedGroupCodingPatterns SGCP_Future
					JOIN CodingPatterns CP_Future
						ON SGCP_Future.CodingPatternID                              = CP_Future.CodingPatternId
				WHERE CE.CodingElementGroupID                                       = SGCP_Future.CodingElementGroupID
					AND SGCP_Future.SynonymManagementID                             = @ToSynonymMgmtId
					AND SGCP_Future.Active                                          = 1
					AND SGCP_Future.SegmentID                                       = @SegmentId
					AND SGCP_Future.SynonymStatus                                   = 2
					AND REPLACE(CP_Past.CodingPath, @FromDictionary, @ToDictionary) = CP_Future.CodingPath
			) AS SGCP_Future
		WHERE CE.StudyDictionaryVersionId                  = @StudyDictionaryVersionId
				AND CE.IsInvalidTask                       = 0
				AND	CE.CodingElementID > @LastRowId
		ORDER BY CE.CodingElementID ASC
	)

	SELECT 
		CodingElementId, 
		MedicalDictionaryLevelKey,
		CodingPatternID,
		CodingElementGroupID,
		Future_SegmentedGroupCodingPatternID,
		CodingPath,
		Future_CodingPath AS Future_CodingPath
	FROM MigrationPage

END
GO 
