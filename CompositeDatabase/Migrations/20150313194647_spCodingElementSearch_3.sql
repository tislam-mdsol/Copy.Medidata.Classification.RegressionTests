IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingElementSearch')
	DROP PROCEDURE dbo.spCodingElementSearch
GO

CREATE PROCEDURE dbo.spCodingElementSearch (
	@IncludeAutoCodedItems bit, -- CodingElements.AutoCodeDate

	@WorkflowActionStartDate datetime, -- WorkflowTaskHistory.Created
	@WorkflowActionEndDate datetime, -- WorkflowTaskHistory.Created

	@StudyIDs VARCHAR(MAX), -- TrackableObjects.ID

	@VerbatimTerm NVARCHAR(1000), -- CodingElements.VerbatimTerm
	@DictionaryLocale CHAR(3), -- 
	@DictionaryVersionID bigint, -- 
	@CurrentWorkflowStateIDs VARCHAR(255), -- comma-delimited WorkflowTasks.WorkflowStateID
	@UserIDs varchar(255), -- WorkflowTaskHistory.UserID

	@PageSize int,
	@SegmentID INT,
	@LastStreamingID INT,
	@TotalRowCount INT OUTPUT
)
AS
BEGIN

	SET @TotalRowCount = 0
	
	DECLARE @currentWorkflowStateTable TABLE(Id INT)
	DECLARE @userIDTable TABLE(Id INT)

	IF (@CurrentWorkflowStateIDs = '')
		SET @CurrentWorkflowStateIDs = NULL

	IF (@CurrentWorkflowStateIDs IS NOT NULL)
		INSERT INTO @currentWorkflowStateTable
		SELECT CAST(Item AS INT) FROM dbo.fnParseDelimitedString(@CurrentWorkflowStateIDs, ',')
	
	IF (@UserIDs IS NOT NULL AND @UserIDs <> '')
		INSERT INTO @userIDTable
		SELECT CAST(Item AS INT) FROM dbo.fnParseDelimitedString(@UserIDs, ',')
	ELSE
		INSERT INTO @userIDTable VALUES(-1)
		
	IF (@IncludeAutoCodedItems = 1)
		INSERT INTO @userIDTable VALUES(-2)

	DECLARE @sdvTable TABLE(Id INT PRIMARY KEY)

	INSERT INTO @sdvTable
	SELECT StudyDictionaryVersionID
	FROM StudyDictionaryVersion
	WHERE DictionaryVersionId = @DictionaryVersionID
		AND DictionaryLocale = @DictionaryLocale
		AND StudyID IN (SELECT * FROM dbo.fnParseDelimitedString(@StudyIDs, ','))

	DECLARE @approveActionId INT = 6

	DECLARE @tmpTable TABLE(
		CodingElementId BIGINT PRIMARY KEY,
		CodingElementGroupId INT,
		SourceSubject NVARCHAR(450),
		StudyDictionaryVersionId INT,
		VerbatimTerm NVARCHAR(450),
		CodeDate DATETIME, 
		CompletionDate DATETIME,
		TotalRowCount INT,
		SGCPId BIGINT,
		WSId INT,
		CodeUser INT,
		IsAutoCoded BIT,
		Priority TINYINT
	)

	;WITH searchQueryCTE 
	AS (
		SELECT 
			e.CodingElementId,
			e.CodingElementGroupId,
			e.SourceSubject,
		 	e.StudyDictionaryVersionId,
			e.VerbatimTerm,
			e.WorkflowStateID,
			e.CompletionDate,
			e.AssignedSegmentedGroupCodingPatternId,
			e.Priority,
			CodeUser,
			CACreated,
			IsAutoCoded
		FROM CodingElements e
			JOIN @sdvTable SDV
				ON e.StudyDictionaryVersionId = SDV.Id
				AND e.CodingElementId > @LastStreamingID
				AND e.SegmentId = @SegmentID
				AND e.AssignedSegmentedGroupCodingPatternId > 0
				-- new check
				AND e.IsInvalidTask = 0
			
				AND (@CurrentWorkflowStateIDs IS NULL OR
					EXISTS (SELECT NULL FROM @currentWorkflowStateTable WHERE Id = e.WorkflowStateID)
					)
				AND (@VerbatimTerm IS NULL or @VerbatimTerm = '' OR e.VerbatimTerm like '%' + @VerbatimTerm + '%')
			-- codedby
			CROSS APPLY
			(
				SELECT TOP 1 
					CodeUser = ca.UserID,
					CACreated = ca.Created,
					CA.IsAutoCoded
				FROM CodingAssignment ca
				WHERE e.CodingElementId = ca.CodingElementID
					AND ca.Active = 1
					AND EXISTS (SELECT NULL FROM @userIDTable WHERE Id IN (-1, ca.UserID) )
					AND CA.IsAutoCoded IN (0, @IncludeAutoCodedItems)
					-- dates check
					AND CA.Created BETWEEN @WorkflowActionStartDate AND @WorkflowActionEndDate
				ORDER BY CodingAssignmentID DESC
			) AS Coder
	)
	
	INSERT INTO @tmpTable(
		CodingElementId,
		CodingElementGroupId,
		SourceSubject,
		StudyDictionaryVersionId,
		VerbatimTerm,
		CodeDate,
		CompletionDate,
		TotalRowCount,
		SGCPId,
		WSId,
		CodeUser,
		IsAutoCoded,
		Priority
	)
	SELECT TOP(@PageSize)
		CodingElementId,
		CodingElementGroupId,
		SourceSubject,
		StudyDictionaryVersionId,
		VerbatimTerm,
		CACreated, 
		CompletionDate,

	    (SELECT COUNT(*) FROM searchQueryCTE) AS TotalRowCount,

		AssignedSegmentedGroupCodingPatternID,
		WorkflowStateId,
		CodeUser,
		ISNULL(IsAutoCoded, 0),
		Priority
	FROM searchQueryCTE
	ORDER BY CodingElementId ASC
	OPTION (RECOMPILE)

	SELECT @TotalRowCount = MAX(TotalRowCount)
	FROM @tmpTable

	SELECT 
		CodingElementId,
		CodingElementGroupId,
		SourceSubject,
		StudyDictionaryVersionId,
		VerbatimTerm,
		IsAutoCoded,
		CodeDate, 
		CompletionDate,

		Coder.Login AS CodedBy,
		Approver.Login AS ApprovedBy, 

		WSId AS WorkflowStateID,

		CD.CodingPath,
		CD.DictionaryLevelID as LevelId, --actual coded dictionary level
		L.Logline,
		Priority
	FROM @tmpTable SCTE
		-- paths
		CROSS APPLY
		(
			SELECT CD_In.DictionaryLevelID,
				CD_In.CodingPath
			FROM SegmentedGroupCodingPatterns SGCP
				CROSS APPLY
				(
					SELECT DictionaryLevelID,
						CodingPath
					FROM CodingPatterns CD_In
					WHERE SGCP.CodingPatternID = CodingPatternID
				) AS CD_In
			WHERE SGCP.SegmentedGroupCodingPatternID = SGCPId
				AND SGCP.Active = 1
		) AS CD
		-- approver
		CROSS APPLY
		(
			SELECT ISNULL(MAX(Login), '') AS Login
			FROM
			(
				SELECT TOP 1 UserId
				FROM WorkflowTaskHistory
				WHERE WorkflowTaskID = CodingElementId
					AND Created > CodeDate
					AND WorkflowActionID = @approveActionId
				ORDER BY WorkflowTaskHistoryID DESC
			) AS X
				CROSS APPLY
				(
					SELECT Login
					FROM Users US
					WHERE US.userId = x.UserId
				) AS ApprovedBy_US
		) AS Approver
		CROSS APPLY
		(
			SELECT Login
			FROM Users US
			WHERE US.userId = CodeUser
		) AS Coder
		CROSS APPLY
		(
			SELECT ReferenceValue AS Logline
			FROM CodingSourceTermReferences
			WHERE CodingSourceTermId = CodingElementId
				AND ReferenceName = 'Line'
		) AS L
END
GO
