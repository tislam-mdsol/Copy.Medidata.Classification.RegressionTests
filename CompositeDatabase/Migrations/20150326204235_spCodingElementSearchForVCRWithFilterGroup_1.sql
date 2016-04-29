IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementSearchForVCRWithFilterGroup')
	BEGIN
		DROP Procedure spCodingElementSearchForVCRWithFilterGroup
	END
GO	

/* 1/15/2013 - CONNOR ROSS cross@mdsol.com
//
// TECH-DEBT: Study Lock number is not being passed in for study migration enum
// TECH-DEBT: UDT is not being used for @studyDictionaryIds
//
// NOTE: If you update this file you must review:
//			1. spCodingElementGetFilterValuesGroup.sql
//			2. spCodingElementGetNextTaskToCodeWithFilterSort.sql
//			3. spCodingElementLoadTaskFilters.sql
//			4. spCodingElementSearchForVCRWithFilterGroup.sql
//			5. spCodingElementSearchByFilterSecuredAndPagedWithFilterAndGroup.sql
*/

CREATE procedure [dbo].spCodingElementSearchForVCRWithFilterGroup
(
	@userID INT,
	@TrackableObjectId bigint = 0,	-- 0=All TrackableObjects, >0=with specific TrackableObjectId, -->> -1=Old TrackableObjects, 
	@SourceSystemId int = 0, 
	@SynonymListId int = 0,
	@Priority int = -1, 
	@TimeElapsed int = 0, 
	@QueryStatus int = -1,
	@SearchForText nvarchar(200),	-- search for text based on search for option selected
	@currentCodingElementID INT,
	@taskNumber INT OUTPUT,
	@totalTaskCount INT OUTPUT,
	@SortExpression VARCHAR(50),
	@SortOrder BIT,
	
	@SecuredStudyList VARCHAR(MAX),	
	
	-- View Options
	@InService INT = 0,					-- 0: Not in service, 1: In Service, -1: Either
	@WorkflowStates NVARChAR(MAX),		-- comma seperated list of worflow state ids, '-1': All workflow states
	@InStudyMigration BIT,					-- 1: In Study Migration, 0: All others study status
	
	@SegmentId INT
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	IF @SearchForText IS NULL
		SET @SearchForText = ''
	
	DECLARE @Today DATETIME, @MaxAllowedSecondsElapsed INT,
		@MinAllowedSecondsElapsed INT

	SELECT @Today = getutcdate()
	
	-- fix the times
	DECLARE @MinDateTime DATETIME,
		@MaxDateTime DATETIME
		
	EXEC spTimeElapsedResolveDateTime
		@TimeElapsed,
		@Today,
		@SegmentId,
		@MinDateTime OUTPUT,
		@MaxDateTime OUTPUT
	
	
	DECLARE @SearchForTextLen INT
	
	SELECT @SearchForTextLen = LEN(@SearchForText)

		
	DECLARE @codingElementIDs TABLE (CodingElementID BIGINT, RowNum INT)
	DECLARE @studyDictionaryIds TABLE (StudyDictionaryVersionId INT PRIMARY KEY, SynonymListId INT)
	DECLARE @workflowStateIds TABLE (WorkflowStateId INT PRIMARY KEY)
	
	INSERT INTO @workflowStateIds(WorkflowStateId)
	SELECT * FROM dbo.fnParseDelimitedString(@WorkflowStates,',')
		
	DECLARE @SkipWorkflowStates BIT
	IF EXISTS(SELECT NULL FROM @workflowStateIds WHERE WorkflowStateId > 0)
	BEGIN
		SET @SkipWorkflowStates = 0
	END
	ELSE
	BEGIN
		SET @SkipWorkflowStates = 1
	END
	
	INSERT INTO @studyDictionaryIds(StudyDictionaryVersionId, SynonymListId)
	SELECT StudyDictionaryVersionId, SynonymManagementID
	FROM StudyDictionaryVersion
	WHERE SegmentID = @SegmentId
		AND ((@InStudyMigration = 0 AND StudyLock <> 3) OR (@InStudyMigration = 1 AND StudyLock = 3))
		AND @SynonymListId IN (0, SynonymManagementID)
		AND				
		--  studysec
		CHARINDEX(CAST(StudyID AS VARCHAR)+',', @SecuredStudyList) > 0 AND
		(
			@TrackableObjectID IN (0, StudyID) OR
			EXISTS (SELECT NULL FROM TrackableObjects tr
				WHERE @TrackableObjectId = -1 - tr.IsTestStudy
					AND StudyID = tr.TrackableObjectID)
		)
		
	IF (@SortExpression = 'VerbatimTerm' AND @SortOrder = 1)	
	BEGIN

		;WITH SQLPaging (CodingElementId, Row)
		AS
		(
			SELECT XInternal.LastCodingElementID,
				ROW_NUMBER() OVER 
				(ORDER BY XInternal.Verbatim ASC
				) AS Row
			FROM 
			(
				SELECT 
					CE.CodingElementGroupID,
					MAX(G.VerbatimText) AS Verbatim,
					WorkflowStateId,
					MIN(CodingElementId) AS LastCodingElementID,
					AssignedSegmentedGroupCodingPatternId,
					SynonymListId
				FROM CodingElements CE
					JOIN @studyDictionaryIds SDV
						ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
					JOIN CodingElementGroups CEG
					    ON CEG.CodingElementGroupID = CE.CodingElementGroupID
					CROSS APPLY
					(
						SELECT MAX(VerbatimText) AS VerbatimText
						FROM GroupVerbatimEng
						WHERE GroupVerbatimID = CEG.GroupVerbatimID
					) AS GVE
					CROSS APPLY
					(
						SELECT MAX(VerbatimText) AS VerbatimText
						FROM GroupVerbatimJPN
						WHERE GroupVerbatimID = CEG.GroupVerbatimID
					) AS GVJ
					CROSS APPLY
					(
						SELECT VerbatimText = 
							CASE WHEN CEG.DictionaryLocale = 'eng' THEN GVE.VerbatimText
								WHEN CEG.DictionaryLocale = 'jpn' THEN GVJ.VerbatimText
							END
					) AS G
				WHERE
					CE.SegmentId = @SegmentId
					-- SourceSystem
					AND @SourceSystemID IN (0, SourceSystemId)
					AND @InService IN (-1, IsStillInService) -- avoid those still in service
					AND IsClosed = 0
					AND
					--Time Elapsed
					(@TimeElapsed = 0 OR 
						CE.Created BETWEEN @MinDateTime AND @MaxDateTime
					) AND
					--VerbatimTerm
					(@SearchForTextLen = 0 OR VerbatimTerm LIKE @SearchForText) AND
					-- Priority
					@Priority IN (-1, Priority) AND
					-- WorkflowState
					(@SkipWorkflowStates = 1 OR WorkflowStateId IN (SELECT WorkFlowStateId FROM @workflowStateIds))
					AND @QueryStatus in (-1, CE.QueryStatus)
				GROUP BY CE.CodingElementGroupID,	-- group id
					WorkflowStateId,				-- workflow state
					AssignedSegmentedGroupCodingPatternId,
					SynonymListId
				) AS XInternal
		)
		
		INSERT INTO @codingElementIDs(CodingElementID, RowNum)
		SELECT SP.CodingElementID, SP.Row
		FROM SQLPaging SP
			CROSS APPLY
			(
				SELECT TaskNumber = Row
				FROM SQLPaging
				WHERE CodingElementId = @currentCodingElementID
			) AS SP_TaskNum
		WHERE SP.Row BETWEEN TaskNumber - 1 AND TaskNumber + 1
		UNION
		SELECT -1, Max(Row)
		FROM SQLPaging
		OPTION (RECOMPILE)

	END
	ELSE IF (@SortExpression = 'VerbatimTerm' AND @SortOrder = 0)	
	BEGIN

		;WITH SQLPaging (CodingElementId, Row)
		AS
		(
			SELECT XInternal.LastCodingElementID,
				ROW_NUMBER() OVER 
				(ORDER BY XInternal.Verbatim DESC
				) AS Row
			FROM 
			(
				SELECT 
					CE.CodingElementGroupID,
					MAX(G.VerbatimText) AS Verbatim,
					WorkflowStateId,
					MIN(CodingElementId) AS LastCodingElementID,
					AssignedSegmentedGroupCodingPatternId,
					SynonymListId
				FROM CodingElements CE
					JOIN @studyDictionaryIds SDV
						ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
					JOIN CodingElementGroups CEG
					    ON CEG.CodingElementGroupID = CE.CodingElementGroupID
					CROSS APPLY
					(
						SELECT MAX(VerbatimText) AS VerbatimText
						FROM GroupVerbatimEng
						WHERE GroupVerbatimID = CEG.GroupVerbatimID
					) AS GVE
					CROSS APPLY
					(
						SELECT MAX(VerbatimText) AS VerbatimText
						FROM GroupVerbatimJPN
						WHERE GroupVerbatimID = CEG.GroupVerbatimID
					) AS GVJ
					CROSS APPLY
					(
						SELECT VerbatimText = 
							CASE WHEN CEG.DictionaryLocale = 'eng' THEN GVE.VerbatimText
								WHEN CEG.DictionaryLocale = 'jpn' THEN GVJ.VerbatimText
							END
					) AS G
				WHERE
					CE.SegmentId = @SegmentId
					-- SourceSystem
					AND @SourceSystemID IN (0, SourceSystemId)
					AND @InService IN (-1, IsStillInService) -- avoid those still in service
					AND IsClosed = 0
					AND
					--Time Elapsed
					(@TimeElapsed = 0 OR 
						CE.Created BETWEEN @MinDateTime AND @MaxDateTime
					) AND
					--VerbatimTerm
					(@SearchForTextLen = 0 OR VerbatimTerm LIKE @SearchForText) AND
					-- Priority
					@Priority IN (-1, Priority) AND
					-- WorkflowState
					(@SkipWorkflowStates = 1 OR WorkflowStateId IN (SELECT WorkFlowStateId FROM @workflowStateIds))
					AND @QueryStatus in (-1, CE.QueryStatus)
				GROUP BY CE.CodingElementGroupID,	-- group id
					WorkflowStateId,				-- workflow state
					AssignedSegmentedGroupCodingPatternId,
					SynonymListId
				) AS XInternal
		)
		
		INSERT INTO @codingElementIDs(CodingElementID, RowNum)
		SELECT SP.CodingElementID, SP.Row
		FROM SQLPaging SP
			CROSS APPLY
			(
				SELECT TaskNumber = Row
				FROM SQLPaging
				WHERE CodingElementId = @currentCodingElementID
			) AS SP_TaskNum
		WHERE SP.Row BETWEEN TaskNumber - 1 AND TaskNumber + 1
		UNION
		SELECT -1, Max(Row)
		FROM SQLPaging
		OPTION (RECOMPILE)

	END
	ELSE IF (@SortExpression = 'AssignedDictionaryTerm' AND @SortOrder = 1)	
	BEGIN

		;WITH SQLPaging (CodingElementId, Row)
		AS
		(
			SELECT XInternal.LastCodingElementID,
				ROW_NUMBER() OVER 
				(ORDER BY XInternal.TermText ASC
				) AS Row
			FROM 
			(
				SELECT 
					CE.CodingElementGroupID,
					WorkflowStateId,
					MIN(CodingElementId) AS LastCodingElementID,
					AssignedSegmentedGroupCodingPatternId,
					SynonymListId,
					MAX(AssignedTermText) AS TermText
				FROM CodingElements CE
					JOIN @studyDictionaryIds SDV
						ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
				WHERE
					CE.SegmentId = @SegmentId
					-- SourceSystem
					AND @SourceSystemID IN (0, SourceSystemId)
					AND @InService IN (-1, IsStillInService) -- avoid those still in service
					AND IsClosed = 0
					AND				
					--Time Elapsed
					(@TimeElapsed = 0 OR 
						CE.Created BETWEEN @MinDateTime AND @MaxDateTime
					) AND
					--VerbatimTerm
					(@SearchForTextLen = 0 OR VerbatimTerm LIKE @SearchForText) AND
					-- Priority
					@Priority IN (-1, Priority) AND
					-- WorkflowState
					(@SkipWorkflowStates = 1 OR WorkflowStateId IN (SELECT WorkFlowStateId FROM @workflowStateIds))
					AND @QueryStatus in (-1, CE.QueryStatus)
				GROUP BY CodingElementGroupID,	-- group id
					WorkflowStateId,				-- workflow state
					AssignedSegmentedGroupCodingPatternId,
					SynonymListId
				) AS XInternal
		)
		
		INSERT INTO @codingElementIDs(CodingElementID, RowNum)
		SELECT SP.CodingElementID, SP.Row
		FROM SQLPaging SP
			CROSS APPLY
			(
				SELECT TaskNumber = Row
				FROM SQLPaging
				WHERE CodingElementId = @currentCodingElementID
			) AS SP_TaskNum
		WHERE SP.Row BETWEEN TaskNumber - 1 AND TaskNumber + 1
		UNION
		SELECT -1, Max(Row)
		FROM SQLPaging
		OPTION (RECOMPILE)

	END
	ELSE IF (@SortExpression = 'AssignedDictionaryTerm' AND @SortOrder = 0)	
	BEGIN

		;WITH SQLPaging (CodingElementId, Row)
		AS
		(
			SELECT XInternal.LastCodingElementID,
				ROW_NUMBER() OVER 
				(ORDER BY XInternal.TermText DESC
				) AS Row
			FROM 
			(
				SELECT 
					CodingElementGroupID,
					WorkflowStateId,
					MIN(CodingElementId) AS LastCodingElementID,
					AssignedSegmentedGroupCodingPatternId,
					SynonymListId,
					MAX(AssignedTermText) AS TermText
				FROM CodingElements CE
					JOIN @studyDictionaryIds SDV
						ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
				WHERE
					CE.SegmentId = @SegmentId
					-- SourceSystem
					AND @SourceSystemID IN (0, SourceSystemId)
					AND @InService IN (-1, IsStillInService) -- avoid those still in service
					AND IsClosed = 0
					AND				
					--Time Elapsed
					(@TimeElapsed = 0 OR 
						CE.Created BETWEEN @MinDateTime AND @MaxDateTime
					) AND
					--VerbatimTerm
					(@SearchForTextLen = 0 OR VerbatimTerm LIKE @SearchForText) AND
					-- Priority
					@Priority IN (-1, Priority) AND
					-- WorkflowState
					(@SkipWorkflowStates = 1 OR WorkflowStateId IN (SELECT WorkFlowStateId FROM @workflowStateIds))
					AND @QueryStatus in (-1, CE.QueryStatus)
				GROUP BY CodingElementGroupID,	-- group id
					WorkflowStateId,				-- workflow state
					AssignedSegmentedGroupCodingPatternId,
					SynonymListId
				) AS XInternal
		)
		
		INSERT INTO @codingElementIDs(CodingElementID, RowNum)
		SELECT SP.CodingElementID, SP.Row
		FROM SQLPaging SP
			CROSS APPLY
			(
				SELECT TaskNumber = Row
				FROM SQLPaging
				WHERE CodingElementId = @currentCodingElementID
			) AS SP_TaskNum
		WHERE SP.Row BETWEEN TaskNumber - 1 AND TaskNumber + 1
		UNION
		SELECT -1, Max(Row)
		FROM SQLPaging
		OPTION (RECOMPILE)

	END
	
	SELECT @taskNumber = RowNum
	FROM @codingElementIDs
	WHERE CodingElementId = @currentCodingElementID
	
	IF (@taskNumber IS NULL)
		SET @taskNumber = -1
	
	SELECT @totalTaskCount = RowNum
	FROM @codingElementIDs
	WHERE CodingElementId = -1
	
	IF (@totalTaskCount IS NULL)
		SET @totalTaskCount = 0
	
	SELECT CE.CodingElementId,
		CodingRequestId,
		SourceSystemId,
		CE.SegmentId,
		CodingSourceAlgorithmID,
		CE.DictionaryLevelId,
		VerbatimTerm =
		 CASE WHEN CEG.DictionaryLocale='eng' 
			 THEN 
			 (SELECT GVE.VerbatimText
				  FROM GroupVerbatimEng GVE
				  WHERE GVE.GroupVerbatimID = CEG.GroupVerbatimID
			  )
			 WHEN CEG.DictionaryLocale='jpn'
			 THEN 
			 (SELECT GVJ.VerbatimText
				  FROM GroupVerbatimJPN GVJ
				  WHERE GVJ.GroupVerbatimID = CEG.GroupVerbatimID
			  )
		END,
		IsClosed,
		IsCompleted,
		IsAutoCodeRequired,
		AutoCodeDate,
		CompletionDate,
		CE.Created,
		CE.Updated,
		SearchType,
		CE.CodingElementGroupID,
		SourceIdentifier,
		IsStillInService,
		WorkflowStateID,
		AssignedSegmentedGroupCodingPatternId,
		Priority,
		AssignedTermText,
		AssignedTermCode,
		AssignedCodingPath,
		SourceField,
		SourceForm,
		SourceSubject,
		IsInvalidTask,
		AssignedTermKey,
		CE.StudyDictionaryVersionId,
		QueryStatus
	FROM CodingElements CE
		JOIN @codingElementIDs CEID
			ON CE.CodingElementId = CEID.CodingElementId
			AND CEID.CodingElementID > 0
		JOIN CodingElementGroups CEG
		    ON CEG.CodingElementGroupID = CE.CodingElementGroupID
	ORDER BY CEID.RowNum ASC

END