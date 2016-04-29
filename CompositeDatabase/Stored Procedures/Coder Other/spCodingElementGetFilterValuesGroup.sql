IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGetFilterValuesGroup')
	BEGIN
		DROP Procedure spCodingElementGetFilterValuesGroup
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

CREATE procedure [dbo].spCodingElementGetFilterValuesGroup
(
	@SearchForText nvarchar(200),	-- search for text based on search for option selected
	@TrackableObjectId bigint = 0,	-- 0=All TrackableObjects, >0=with specific TrackableObjectId, -->> -1=Old TrackableObjects, 
	@SourceSystemId bigint = 0,
	@SetPriority INT,
	@SetSynonymListId INT,
	@SetTimeElapsed INT,
	@SetQueryStatus INT,
	@SegmentId INT,
	
	-- View Options
	@InService INT = 0,					-- 0: Not in service, 1: In Service, -1: Either
	@WorkflowStates NVARChAR(MAX),		-- comma seperated list of worflow state ids, '-1': All workflow states
	@InStudyMigration BIT					-- 1: In Study Migration, 0: All others study status
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL	READ UNCOMMITTED
	
	DECLARE @Today DATETIME
		
	SELECT @Today = GETUTCDATE()
	
	-- fix the times
	DECLARE @MinDateTime DATETIME,
		@MaxDateTime DATETIME
		
	EXEC spTimeElapsedResolveDateTime
		@SetTimeElapsed,
		@Today,
		@SegmentId,
		@MinDateTime OUTPUT,
		@MaxDateTime OUTPUT
	
	-- fix the searchstring	
	DECLARE @SearchForTextLike NVARCHAR(450)
	
	SET @SearchForTextLike = '%' + @SearchForText + '%'


	DECLARE @PriorityColumnName VARCHAR(20),
		@DictionaryVersionColumnName VARCHAR(20),
		@StatusColumnName VARCHAR(20),
		@TimeElapsedColumnName VARCHAR(20),
		@QueryStatusColumnName VARCHAR(21)
		
	SELECT @PriorityColumnName = 'PRIORITY',
		@DictionaryVersionColumnName = 'DICTIONARYNAME',
		@StatusColumnName = 'CODINGSTATUS',
		@TimeElapsedColumnName = 'TIMEELAPSED',
		@QueryStatusColumnName = 'QUERYSTATUS_LOCALIZED'
		
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
		AND @SetSynonymListId IN (0, SynonymManagementID)
		AND				
		--  studysec
		(
			@TrackableObjectID IN (0, StudyID) OR
			EXISTS (SELECT NULL FROM TrackableObjects tr
				WHERE @TrackableObjectId = -1 - tr.IsTestStudy
					AND StudyID = tr.TrackableObjectID)
		)		

	DECLARE @date1 DATETIME = DATEADD(second, -43200, @Today),
		@date2 DATETIME = DATEADD(second, -86400, @Today),
		@date3 DATETIME = DATEADD(second, -172800, @Today), 
		@date4 DATETIME = DATEADD(second, -432000, @Today)
	

	;WITH aggregatedCTE 
		(Priority, ElapsedInterval, WorkflowStateID, SynonymListId, QueryStatus) --, WorkflowStateNameID)
	AS
	(
	SELECT 
		Priority,
		CASE WHEN Created > @date1 THEN 1
			WHEN Created > @date2 THEN 2
			WHEN Created > @date3 THEN 3
			WHEN Created > @date4 THEN 4
			ELSE 5
		END AS ElapsedInterval,				
		WorkflowStateId,
		SynonymListId,
		CE.QueryStatus
	FROM CodingElements CE
		JOIN @studyDictionaryIds SDV
			ON SDV.StudyDictionaryVersionId = CE.StudyDictionaryVersionId
	WHERE 
			CE.SegmentId = @SegmentId
			AND @SetPriority IN (-1, Priority)
			AND @SourceSystemId IN (0, SourceSystemId)
			AND @InService IN (-1, IsStillInService) -- avoid those still in service
			AND CE.Created BETWEEN @MinDateTime AND @MaxDateTime
			AND IsClosed = 0
			AND (LEN(@SearchForText) = 0 OR VerbatimTerm LIKE @SearchForTextLike)
			AND (@SkipWorkflowStates = 1 OR WorkflowStateId IN (SELECT WorkFlowStateId FROM @workflowStateIds))
			AND @SetQueryStatus in (-1, CE.QueryStatus)
	)

	SELECT GridColumn, ID, Name
	FROM
	(
	-- 1. Priorities
	SELECT @PriorityColumnName AS GridColumn, Priority AS ID, CAST(Priority AS NVARCHAR) AS Name
	FROM
	(
		SELECT DISTINCT(Priority) AS Priority
		FROM aggregatedCTE
	) AS P_Internal
	UNION
	SELECT @StatusColumnName AS GridColumn, W_Internal.WorkflowStateID AS ID, '' AS Name -- deferred
	FROM
	(
		SELECT DISTINCT(WorkflowStateID) AS WorkflowStateID
		FROM aggregatedCTE
	) AS W_Internal
	UNION
	SELECT @DictionaryVersionColumnName AS GridColumn, D_Internal.SynonymListId AS ID, 
		CAST(D_Internal.SynonymListId AS NVARCHAR) AS Name
	FROM
	(	
		SELECT DISTINCT(SynonymListId) AS SynonymListId
		FROM aggregatedCTE
	) AS D_Internal
	UNION
	SELECT @TimeElapsedColumnName AS GridColumn, ElapsedInterval AS ID, CAST(ElapsedInterval AS NVARCHAR) AS Name
	FROM
	(	
		SELECT DISTINCT(ElapsedInterval) AS ElapsedInterval
		FROM aggregatedCTE
	) AS E_Internal
	UNION
	SELECT @QueryStatusColumnName AS GridColumn, QueryStatus AS ID, CAST(F_Internal.QueryStatus AS NVARCHAR) AS Name
	FROM
	(	
		SELECT DISTINCT(QueryStatus) AS QueryStatus
		FROM aggregatedCTE
	) AS F_Internal
	) AS Composite
	ORDER BY Composite.Name
	OPTION (RECOMPILE)
		
END
  

