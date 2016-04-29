IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGetNextTaskToCodeWithFilterSort')
	BEGIN
		DROP Procedure dbo.spCodingElementGetNextTaskToCodeWithFilterSort
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
//			5. spCodingElementSearchByFilterSecuredAndPagedWithFilterAndGroup.sql
*/

CREATE procedure [dbo].spCodingElementGetNextTaskToCodeWithFilterSort
(
	@userID bigint,					 
	@TrackableObjectId bigint = 0,	 -- 0=All TrackableObjects, >0=with specific TrackableObjectId, -->> -1=Old TrackableObjects, 
	@SourceSystemId bigint = 0,
	@TimeElapsed int = 0,			 -- 0=All Dates
	@QueryStatus int = -1,			-- -1=All Statuses
	@SynonymListId INT = 0,			-- 0=All Lists, >0=specific list
	@Priority INT = -1,				 -- -1=All Priorities, >-1=specific priority
	@SearchForText nvarchar(200),	 -- search for text based on search for option selected
	@CodingElementID bigint,		 
	@SortExpression VARCHAR(100), 
	@SortOrder BIT,					 -- 1=ASC 2=DESC
	
	@SecuredStudyList VARCHAR(MAX),
	
	-- View Options
	@InService INT = 0,					-- 0: Not in service, 1: In Service, -1: Either
	@WorkflowStates NVARChAR(MAX),		-- comma seperated list of worflow state ids, '-1': All workflow states
	@InStudyMigration BIT,					-- 1: In Study Migration, 0: All others study status
	
	@IsInsideGroupDisplayMode BIT,		-- 0 : not inside group

	@SegmentId bigint				 -- added by Framework
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


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
	DECLARE @TrackableObjects TABLE(TrackableObjectId INT PRIMARY KEY)
	
	INSERT INTO @workflowStateIds(WorkflowStateId)
	SELECT * FROM dbo.fnParseDelimitedString(@WorkflowStates,',')
		
	INSERT INTO @TrackableObjects(TrackableObjectId) 
	SELECT item
	FROM dbo.fnParseDelimitedString(@SecuredStudyList,',')

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
	FROM StudyDictionaryVersion sdv
		-- join on the secured list
		JOIN @TrackableObjects tko ON sdv.StudyId = tko.TrackableObjectId
	WHERE SegmentID = @SegmentId
		AND ((@InStudyMigration = 0 AND StudyLock <> 3) OR (@InStudyMigration = 1 AND StudyLock = 3))
		AND @SynonymListId IN (0, SynonymManagementID)
		AND				
		--  studysec
		(
			@TrackableObjectID IN (0, StudyID) OR
			EXISTS (SELECT NULL FROM TrackableObjects tr
				WHERE @TrackableObjectId = -1 - tr.IsTestStudy
					AND StudyID = tr.TrackableObjectID)
		)

	DECLARE @codingElementGroupId INT

	IF (ISNULL(@IsInsideGroupDisplayMode, 0) = 1)
		SELECT @codingElementGroupId = CodingElementGroupID
		FROM CodingElements
		WHERE CodingElementId = @CodingElementID

	-- check if group is being asked
	IF (ISNULL(@CodingElementGroupId, 0) > 0)
	BEGIN

		;WITH SQLPaging (CodingElementId, Row)
		AS
		(
			SELECT XInternal.LastCodingElementID,
				ROW_NUMBER() OVER 
				(ORDER BY LastCodingElementID ASC
				) AS Row
			FROM 
			(
				SELECT 					
					CE.CodingElementId AS LastCodingElementID
				FROM CodingElements CE
					JOIN @studyDictionaryIds SDV
						ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
				WHERE CE.CodingElementGroupId = @codingElementGroupId
					AND CE.SegmentId = @SegmentId
					-- SourceSystem
					AND @SourceSystemID IN (0, SourceSystemId)
					AND @InService IN (-1, IsStillInService) -- avoid those still in service
					AND IsClosed = 0
					AND
					--Time Elapsed
					(@TimeElapsed = 0 OR 
						CE.Created BETWEEN @MinDateTime AND @MaxDateTime
					) AND
					-- Priority
					@Priority IN (-1, Priority) AND
					-- WorkflowState
					(@SkipWorkflowStates = 1 OR WorkflowStateId IN (SELECT WorkFlowStateId FROM @workflowStateIds))
					AND @QueryStatus in (-1, CE.QueryStatus)
				) AS XInternal
		)
				
		INSERT INTO @codingElementIDs (CodingElementID, RowNum)
		SELECT SP.CodingElementID, SP.Row
		FROM SQLPaging SP
			CROSS APPLY
			(
				SELECT TaskNumber = ISNULL(MAX(Row), -1)
				FROM SQLPaging
				WHERE CodingElementId = @CodingElementID
			) AS SP_TaskNum
		WHERE SP.Row = TaskNumber + 1 -- only get next (if any)
            OR SP.Row = 1 -- include the very first for circling back
		OPTION (RECOMPILE)
	END	
	ELSE IF (@SortExpression = 'VerbatimTerm' AND @SortOrder = 1)	
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
		
		INSERT INTO @codingElementIDs (CodingElementID, RowNum)
		SELECT SP.CodingElementID, SP.Row
		FROM SQLPaging SP
			CROSS APPLY
			(
				SELECT TaskNumber = ISNULL(MAX(Row), -1)
				FROM SQLPaging
				WHERE CodingElementId = @CodingElementID
			) AS SP_TaskNum
		WHERE SP.Row = TaskNumber + 1 -- only get next (if any)
            OR SP.Row = 1 -- include the very first for circling back
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
				SELECT TaskNumber = ISNULL(MAX(Row), -1)
				FROM SQLPaging
				WHERE CodingElementId = @CodingElementID
			) AS SP_TaskNum
		WHERE SP.Row = TaskNumber + 1 -- only get next (if any)
            OR SP.Row = 1 -- include the very first for circling back
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
				SELECT TaskNumber = ISNULL(MAX(Row), -1)
				FROM SQLPaging
				WHERE CodingElementId = @CodingElementID
			) AS SP_TaskNum
		WHERE SP.Row = TaskNumber + 1 -- only get next (if any)
            OR SP.Row = 1 -- include the very first for circling back
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
				SELECT TaskNumber = ISNULL(MAX(Row), -1)
				FROM SQLPaging
				WHERE CodingElementId = @CodingElementID
			) AS SP_TaskNum
		WHERE SP.Row = TaskNumber + 1 -- only get next (if any)
            OR SP.Row = 1 -- include the very first for circling back
		OPTION (RECOMPILE)

	END
	
	;WITH FinalResults AS
	(
		SELECT TOP 1 CE.*
		FROM CodingElements CE
			JOIN @codingElementIDs CEID
				ON CE.CodingElementId = CEID.CodingElementId
		ORDER BY CEID.RowNum DESC
	)

	SELECT *
	FROM FinalResults
	WHERE CodingElementId <> @CodingElementID -- do not return self

END 