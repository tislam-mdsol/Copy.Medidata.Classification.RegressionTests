IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCheckAutoCodingCrossLevelMiss')
	DROP PROCEDURE spCheckAutoCodingCrossLevelMiss
GO

CREATE PROCEDURE dbo.spCheckAutoCodingCrossLevelMiss
(
	@dictionaryOID VARCHAR(100),
	@versionOID VARCHAR(100),
	@listName VARCHAR(250),
	@segmentName VARCHAR(250)
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @dictionaryID INT,
		@dictionaryVersionID INT,
		@listId INT,
		@segmentId INT,
		@waitingManualCodeId INT

	SELECT @segmentId = SegmentId 
	FROM Segments
	WHERE SegmentName = @segmentName

	IF (@segmentId IS NULL)
	BEGIN
		SELECT 'Cannot find Segment'
		RETURN 0
	END

	SELECT @dictionaryID = DictionaryRefID
	FROM DictionaryRef
	WHERE OID = @dictionaryOID

	IF (@dictionaryID IS NULL)
	BEGIN
		SELECT 'Cannot find dictionary'
		RETURN 0
	END

	SELECT @dictionaryVersionID = DictionaryVersionRefID
	FROM DictionaryVersionRef
	WHERE OID = @versionOID
		AND DictionaryRefID = @dictionaryID

	IF (@dictionaryVersionID IS NULL)
	BEGIN
		SELECT 'Cannot find dictionary version'
		RETURN 0
	END

	SELECT @waitingManualCodeId = WorkflowStateID
	FROM WorkflowStates
	WHERE SegmentId = @segmentId
		AND dbo.fnLDS(WorkflowStateNameID, 'eng') = 'Waiting Manual Code'

	IF (@waitingManualCodeId IS NULL)
	BEGIN
		SELECT 'Cannot find waiting manual code state'
		RETURN 0
	END

	SELECT @listId = SynonymMigrationMngmtID
	FROM SynonymMigrationMngmt
	WHERE SegmentID = @segmentId
		AND ListName = @listName
		AND DictionaryVersionId = @dictionaryVersionID
		AND Deleted = 0

	IF (@listId IS NULL)
	BEGIN
		SELECT 'Cannot find synonym list'
		RETURN 0
	END

	;WITH xCTE
	AS
	(
		SELECT SDV.StudyID, COUNT(*) AS TaskCountToAutoCode
		FROM StudyDictionaryVersion SDV
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SynonymManagementID = SDV.SynonymManagementID
				AND SGCP.SynonymStatus = 2
			JOIN CodingElements CE
				ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
				AND CE.WorkflowStateID = @waitingManualCodeId
				AND CE.SegmentId = @segmentId
			JOIN CodingElementGroups CEG_Synonyms
				ON CEG_Synonyms.CodingElementGroupID = SGCP.CodingElementGroupID
			JOIN CodingElementGroups CEG_Tasks
				ON CEG_Tasks.CodingElementGroupID = CE.CodingElementGroupID
				-- conditions
				AND CEG_Tasks.GroupVerbatimId = CEG_Synonyms.GroupVerbatimId
				AND CEG_Tasks.CompSuppCount = CEG_Synonyms.CompSuppCount
				AND CEG_Tasks.DictionaryLevelID <> CEG_Synonyms.DictionaryLevelID
				AND CEG_Tasks.CompSuppCount = 
				(
					SELECT COUNT(*)
					FROM CodingElementGroupComponents CEGC_Synonyms
						JOIN CodingElementGroupComponents CEGC_Tasks
							ON CEGC_Synonyms.ComponentTypeID = CEGC_Tasks.ComponentTypeID
							AND CEGC_Synonyms.NameTextId = CEGC_Tasks.NameTextId
							AND CEGC_Synonyms.IsSupplement = CEGC_Tasks.IsSupplement
							AND CEGC_Synonyms.CodingElementGroupID = CEG_Synonyms.CodingElementGroupID
							AND CEGC_Tasks.CodingElementGroupID = CEG_Tasks.CodingElementGroupID			
				)
		WHERE SDV.SynonymManagementID = @listId
		GROUP BY SDV.StudyID
	)

	SELECT 'TaskCount to be autocoded upon cross level synonyms update', TOS.ExternalObjectName AS StudyName, xCTE.*
	FROM xCTE
		JOIN TrackableObjects TOS
			ON TOS.TrackableObjectID = xCTE.StudyID


END
