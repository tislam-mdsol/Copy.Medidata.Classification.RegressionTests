IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationGetTaskGroupVerbatimsForBetterMatch')
	DROP PROCEDURE spStudyMigrationGetTaskGroupVerbatimsForBetterMatch
GO

CREATE PROCEDURE dbo.spStudyMigrationGetTaskGroupVerbatimsForBetterMatch
(
	@StudyDictionaryVersionID INT,
	@Locale CHAR(3),
	@RowCount INT,
	@LastRowId BIGINT
)
AS  
  
BEGIN

	IF (@Locale = 'eng')
	BEGIN			
		SELECT TOP (@RowCount) CE.CodingElementId, CEG.CodingElementGroupID, CEG.DictionaryLevelID,
			ENG.VerbatimText
		FROM CodingElements	CE WITH (NOLOCK)
			JOIN StudyMigrationBackup SMB ON CE.CodingElementId = SMB.CodingElementID AND SMB.MigrationChangeType = -1
			JOIN CodingElementGroups CEG ON CEG.CodingElementGroupID = CE.CodingElementGroupID
				AND CE.StudyDictionaryVersionId = @StudyDictionaryVersionID
				AND CE.CodingElementId > @LastRowId
			JOIN GroupVerbatimEng ENG ON ENG.GroupVerbatimID = CEG.GroupVerbatimID
		WHERE CE.AssignedTermText <> ENG.VerbatimText -- skip already coded to exact matches
		ORDER BY CodingElementId ASC
	END		
	ELSE IF (@Locale = 'jpn')
	BEGIN	
		SELECT TOP (@RowCount) CE.CodingElementId, CEG.CodingElementGroupID, CEG.DictionaryLevelID, 
			JPN.VerbatimText
		FROM CodingElements	CE WITH (NOLOCK)
			JOIN StudyMigrationBackup SMB ON CE.CodingElementId = SMB.CodingElementID AND SMB.MigrationChangeType = -1
			JOIN CodingElementGroups CEG ON CEG.CodingElementGroupID = CE.CodingElementGroupID
				AND CE.StudyDictionaryVersionId = @StudyDictionaryVersionID
				AND CE.CodingElementId > @LastRowId
			JOIN GroupVerbatimJpn JPN ON JPN.GroupVerbatimID = CEG.GroupVerbatimID
		WHERE CE.AssignedTermText <> JPN.VerbatimText -- skip already coded to exact matches
		ORDER BY CodingElementId ASC
	END
	-- No verbatim text table for LOC locale, so nothing to return.

END

GO 
 