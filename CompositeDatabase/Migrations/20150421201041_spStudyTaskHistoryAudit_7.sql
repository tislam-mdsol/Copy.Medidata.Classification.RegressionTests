IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spStudyTaskHistoryAudit')
	DROP PROCEDURE dbo.spStudyTaskHistoryAudit
GO

--exec spStudyTaskHistoryAudit 60032, null, null, '', '', '', 1, '', '', 60, 450, 0

CREATE PROCEDURE dbo.spStudyTaskHistoryAudit
(
	@studyDictionaryVersionId INT,

	@WorkflowActionStartDate DATETIME, -- WorkflowTaskHistory.Created
	@WorkflowActionEndDate DATETIME, -- WorkflowTaskHistory.Created

	@Verbatim NVARCHAR(1000), -- CodingElements.VerbatimTerm
	@Term NVARCHAR(1000), -- CodingAssignement.MedicalDictionaryTerm.Term
	@Code NVARCHAR(100), -- CodingAssignement.MedicalDictionaryTerm.Code
	@IncludeAutoCodedItems BIT, -- CodingElements.AutoCodeDate

	@CurrentWorkflowStateIDs VARCHAR(255), -- comma-delimited WorkflowTaskHistory.WorkflowStateID
	@UserIDs VARCHAR(255), -- WorkflowTaskHistory.UserID
	@SegmentID INT, -- CodingElements.SegmentID,
	@PageSize INT,
	@LastStreamingID INT
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF (ISNULL (@LastStreamingID, -1) < 0 OR ISNULL(@PageSize,0) <= 0) 
		RETURN
    DECLARE @errorString NVARCHAR(400) 
		
	IF (@WorkflowActionStartDate IS NULL OR @WorkflowActionStartDate = '')
		SET @WorkflowActionStartDate = '1/1/1753'
	IF (@WorkflowActionEndDate IS NULL OR @WorkflowActionEndDate = '')
		SET @WorkflowActionEndDate = '12/31/9999 23:59:59'
	IF (@IncludeAutoCodedItems IS NULL) SET @IncludeAutoCodedItems = 0

	DECLARE @currentWorkflowStateTable TABLE(Id INT)
	DECLARE @userIDTable TABLE(Id INT)

	IF (@CurrentWorkflowStateIDs IS NOT NULL AND @CurrentWorkflowStateIDs <> '')
		INSERT INTO @currentWorkflowStateTable
		SELECT CAST(Item AS INT) FROM dbo.fnParseDelimitedString(@CurrentWorkflowStateIDs, ',')
	ELSE
		INSERT INTO @currentWorkflowStateTable VALUES(-1)

	IF (@UserIDs IS NOT NULL AND @UserIDs <> '')
		INSERT INTO @userIDTable
		SELECT CAST(Item AS INT) FROM dbo.fnParseDelimitedString(@UserIDs, ',')
	ELSE
		INSERT INTO @userIDTable VALUES(-1)
	IF (@IncludeAutoCodedItems = 1)
		INSERT INTO @userIDTable VALUES(-2)

	DECLARE @studyVersionHistory TABLE(DictionaryVersionRefId INT, ToVersionId INT, Created DATETIME)

	INSERT INTO @studyVersionHistory(DictionaryVersionRefId, ToVersionId, Created)
	SELECT SMM_From.DictionaryVersionId,
		SMM_To.DictionaryVersionId, 
		SDVH.Created
	FROM StudyDictionaryVersion SDV
		JOIN StudyDictionaryVersionHistory SDVH
			ON SDVH.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
		JOIN SynonymMigrationMngmt SMM_From
			ON SMM_From.SynonymMigrationMngmtID = SDVH.FromSynonymListId
		JOIN SynonymMigrationMngmt SMM_To
			ON SMM_To.SynonymMigrationMngmtID = SDVH.ToSynonymListId
	WHERE SDV.StudyDictionaryVersionId = @studyDictionaryVersionId

	DECLARE @maxVersionId INT

	SELECT @maxVersionId = ISNULL(MAX(ToVersionId), 0) + 1
	FROM @studyVersionHistory

	-- insert the current history
	INSERT INTO @studyVersionHistory(DictionaryVersionRefId, ToVersionId, Created)
	SELECT SMM.DictionaryVersionId,
		@maxVersionId, 
		GETUTCDATE()
	FROM StudyDictionaryVersion SDV
		JOIN SynonymMigrationMngmt SMM
			ON SDV.SynonymManagementID = SMM.SynonymMigrationMngmtID
	WHERE StudyDictionaryVersionId = @studyDictionaryVersionId

	;WITH tasks AS
	(
		SELECT TOP(@PageSize)
			CE.CodingElementId,
			CE.UUID,
			SourceSubject AS SubjectKey,
			VerbatimTerm,
			CodingRequestID,
			SourceField AS ItemOID,
			SourceForm AS FormOID,
			ISNULL(CA.IsAutoCoded, 0) AS IsAutoCoded,
			CE.SourceSystemId
		FROM CodingElements CE
			LEFT JOIN CodingAssignment CA 
				ON CE.CodingElementId = CA.CodingElementID
				AND CA.Active = 1
		WHERE CE.StudyDictionaryVersionId = @studyDictionaryVersionId
			AND CE.CodingElementId > @LastStreamingID
			AND CE.SegmentId = @SegmentID
			-- current state check
			AND EXISTS (SELECT NULL FROM @currentWorkflowStateTable WHERE Id IN (-1, WorkflowStateID) )
			AND (@Verbatim = '' OR VerbatimTerm LIKE '%' + @Verbatim + '%')
			AND @Code IN ('', AssignedTermCode)
			AND @Term IN ('', AssignedTermText)
			AND ( CA.IsAutoCoded IN (0, @IncludeAutoCodedItems) OR CA.CodingAssignmentID IS NULL )
		ORDER BY CE.CodingElementId ASC
	)
	, taskHistories AS
	(
	 SELECT
		E.CodingElementId,
		E.UUID,
		SubjectKey,
		VerbatimTerm,
		ItemOID,
		FormOID,
		WorkflowTaskHistoryId,
		WTH.CodingElementGroupId,
		WTH.QueryId,
		WTH.WorkflowStateID,
		ISNULL(WTH.WorkflowActionID, 0) AS WorkflowActionID,
		ISNULL(WTH.WorkflowSystemActionID, 0) AS WorkflowSystemActionID,
		WTH.Login AS UserLogin,
		Comment,
		WTH.Created,
		WTH.CodingPath,
		ISNULL(WTH.DictionaryVersionId, 0) AS CodingPathVersionId,
		E.IsAutoCoded,
		APP.Name AS SourceSystemName,
		SVH.DictionaryVersionRefId
	 FROM tasks E
		-- NOTE: this sproc performance may vary slightly if lengthy histories
		CROSS APPLY
		( 
			SELECT WTH.*
				,CP.CodingPath, 
				SMM.DictionaryVersionId, 
				UH.Login
			FROM WorkflowTaskHistory WTH
				LEFT JOIN CodingAssignment CA
					ON CA.CodingAssignmentID = WTH.CodingAssignmentId
				LEFT JOIN SegmentedGroupCodingPatterns SGCP
					ON SGCP.SegmentedGroupCodingPatternID = CA.SegmentedGroupCodingPatternID
				LEFT JOIN SynonymMigrationMngmt SMM
					ON SMM.SynonymMigrationMngmtID = SGCP.SynonymManagementID
				LEFT JOIN CodingPatterns CP
					ON CP.CodingPatternID = SGCP.CodingPatternID
				LEFT JOIN Users UH
					ON UH.UserID = WTH.UserID
			WHERE WTH.WorkflowTaskID = E.CodingElementId
				-- dates check
				AND WTH.Created BETWEEN @WorkflowActionStartDate AND @WorkflowActionEndDate
				-- user check
				AND EXISTS (SELECT NULL FROM @userIDTable WHERE Id IN (-1, WTH.UserID) )
		) AS WTH
		JOIN Application APP
			ON APP.SourceSystemID = E.SourceSystemId
		CROSS APPLY
		(
			SELECT TOP 1 DictionaryVersionRefId
			FROM @studyVersionHistory SVH
			WHERE WTH.Created < SVH.Created
			ORDER BY ToVersionId ASC
		) AS SVH
	)

	SELECT *
	FROM taskHistories E
	OPTION (RECOMPILE)
	
END
GO

SET NOCOUNT OFF
GO
