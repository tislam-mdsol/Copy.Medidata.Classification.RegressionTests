IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingDataForReclassify')
	DROP PROCEDURE dbo.spCodingDataForReclassify
GO

--EXEC spCodingDataForReclassify '5707', 436, 'eng', null, null, null, null, null, 1, 1, '','','','',	100, 10, 0, 162, 1, 0, 1, null--, @cnt output

CREATE PROCEDURE dbo.spCodingDataForReclassify (
	@StudyIDs varchar(max), -- comma delimited trackableobjectid's
	
    @DictionaryVersionID INT, 
    @Locale CHAR(3),
	@WorkflowActionStartDate datetime, -- WorkflowTaskHistory.Created
	@WorkflowActionEndDate datetime, -- WorkflowTaskHistory.Created

	@Verbatim nvarchar(1000), -- CodingElements.VerbatimTerm
	@Term nvarchar(1000), -- CodingAssignement.MedicalDictionaryTerm.Term
	@Code nvarchar(100), -- CodingAssignement.MedicalDictionaryTerm.Code
	
	@WithSynonyms bit, -- check for synonyms

	@IncludeAutoCodedItems bit, -- CodingElements.AutoCodeDate

	@PriorWorkflowStateIDs varchar(255), -- comma-delimited WorkflowTaskHistory.WorkflowStateID
	@UserIDs varchar(255), -- WorkflowTaskHistory.UserID
	@PriorWorkflowActionIDs varchar(255), -- comma-delimited WorkflowAction.ID
	@SkipSegGroupCodingPatternIDs VARCHAR(MAX), -- comma delimited segmented group coding pattern ids to filter out

	@SearchLimit int,
	@PageSize int,
	@PageIndex int,
	@SegmentID INT, 
	@IsAutoApproval BIT,
	@ForcePrimaryPath BIT,
	@reconsiderState INT,
	@count int output
)
AS
BEGIN

	-- validate parameters
	if (ISNULL(@PageIndex         , -1) < 0)
	BEGIN
		RAISERROR('@PageIndex must be non-negative', 16, 1)
		RETURN
	END
	if (ISNULL(@PageSize           , 0) < 1)
	BEGIN
		RAISERROR('@PageSize must be positive', 16, 1)
		RETURN
	END
	if (ISNULL(@DictionaryVersionID, 0) < 1)
	BEGIN
		RAISERROR('@DictionaryVersionID must be positive', 16, 1)
		RETURN
	END
	if (ISNULL(@SearchLimit        , 0) < 1)
	BEGIN
		RAISERROR('@SearchLimit must be positive', 16, 1)
		RETURN
	END

	-- set the count
	SET @count = 0

	-- Allow reclassify to read without aquiring locks (same behavior as task page sql);
	-- long running transactions (like study migration) will lock these same tables.
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED		

	DECLARE @StudyIDTable TABLE (StudyID INT)
	
	INSERT INTO @StudyIDTable
	SELECT * FROM dbo.fnParseDelimitedString(@StudyIDs, ',')

	declare @startRowNumber bigint, @endRowNumber int
	set @startRowNumber = (@PageIndex * @PageSize) + 1
	IF (@startRowNumber > @SearchLimit)
		SET @startRowNumber = @SearchLimit
	set @endRowNumber = @startRowNumber + @PageSize - 1
	IF (@endRowNumber > @SearchLimit)
		SET @endRowNumber = @SearchLimit
	

	DECLARE @gridData TABLE(
		CodingElementId BIGINT,
		SegmentedGroupCodingPatternID BIGINT,
		TrackableObjectId INT, 
		SubjectOID NVARCHAR(1000),
		Term NVARCHAR(1000), 
		Code NVARCHAR(100), 
		MaxCount INT)

	DECLARE @minWorkflowTime DATETIME = '1/1/1900'
	DECLARE @maxWorkflowTime DATETIME = '1/1/9900'
		-- ratify the inputs
		SET @PriorWorkflowStateIDs   = ISNULL(@PriorWorkflowStateIDs  , '')
		SET @PriorWorkflowActionIDs  = ISNULL(@PriorWorkflowActionIDs , '')
		SET @WorkflowActionStartDate = ISNULL(@WorkflowActionStartDate, @minWorkflowTime)
		SET @WorkflowActionEndDate   = ISNULL(@WorkflowActionEndDate  , @maxWorkflowTime)
		SET @IncludeAutoCodedItems   = ISNULL(@IncludeAutoCodedItems  , 0)
		SET @UserIDs                 = ISNULL(@UserIDs                , '')
		SET @Term                    = ISNULL(@Term                   , '')
		SET @Verbatim                = ISNULL(@Verbatim               , '')
		SET @Code                    = ISNULL(@Code                   , '')
		SET @SkipSegGroupCodingPatternIDs = ISNULL(@SkipSegGroupCodingPatternIDs, '')

	DECLARE @applyAssignmentFilter BIT = CASE WHEN @IncludeAutoCodedItems = 1 AND @UserIDs = '' THEN 0 ELSE 1 END
	DECLARE @applyHistoryFilter BIT = CASE 
		WHEN @WorkflowActionStartDate <= @minWorkflowTime AND
			 @WorkflowActionEndDate >= @maxWorkflowTime AND
			 @PriorWorkflowStateIDs = '' AND 
			 @PriorWorkflowActionIDs = '' THEN 0 ELSE 1 END

	IF (@applyAssignmentFilter = 1)
	BEGIN
		IF (@IncludeAutoCodedItems = 1)
			IF (@UserIDs <> '')
				SET @UserIDs = @UserIDs + '-2,'
	END

	;WITH tasksOnly (
		CodingElementId, 
		SegmentedGroupCodingPatternID, 
		TrackableObjectId,
		Term,
		Code,
		SourceSubject,
		VerbatimTerm
	) AS (
		SELECT 
			e.CodingElementId, 
			e.AssignedSegmentedGroupCodingPatternId,
			SDV.StudyID,
			e.AssignedTermText,
			e.AssignedTermCode,
			e.SourceSubject,
			e.VerbatimTerm
		FROM @StudyIDTable STD
			JOIN StudyDictionaryVersion SDV
				ON STD.StudyID = SDV.StudyID
				AND @DictionaryVersionID = SDV.DictionaryVersionID
				AND @Locale = SDV.DictionaryLocale	
				AND SDV.StudyLock = 1 -- study is not locked  		
			JOIN CodingElements e 
				ON e.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
				AND e.SegmentId = @SegmentID
				AND e.IsStillInService = 0
				AND e.IsClosed = 1
				AND e.IsInvalidTask = 0
				AND	@Term IN ('', e.AssignedTermText)
				AND (@Verbatim = '' OR e.VerbatimTerm like '%' + @Verbatim + '%')
				AND @Code IN ('', e.AssignedTermCode)
				AND e.AssignedSegmentedGroupCodingPatternId > 0
	)
	, withTaskFilters AS
	(
		SELECT
			e.*,
			passesTaskFilter = CASE 
				WHEN @SkipSegGroupCodingPatternIDs = '' THEN 1 
				WHEN CHARINDEX(CAST(e.SegmentedGroupCodingPatternID AS VARCHAR)+',', @SkipSegGroupCodingPatternIDs) > 0 THEN 0
				ELSE 1
			END
		FROM tasksOnly e
	)
	, withAssigmentFilters AS(
		SELECT 
			e.*,
			passesAssignmentFilter = CASE 
				WHEN @applyAssignmentFilter = 0 THEN 1
				ELSE dbo.fnPassesReclassifyAssignmentFilter(@IncludeAutoCodedItems, @UserIDs, e.CodingElementId)
			END
		FROM withTaskFilters e
		WHERE passesTaskFilter = 1
	)
	, withHistoryFilters AS(
		SELECT
			e.*,
			passesHistoryFilter = CASE 
				WHEN @applyHistoryFilter = 0 THEN 1
				ELSE dbo.fnPassesReclassifyHistoryFilter(@WorkflowActionStartDate, @WorkflowActionEndDate, @PriorWorkflowStateIDs, @PriorWorkflowActionIDs, e.CodingElementId)
			END
		FROM withAssigmentFilters e
		WHERE passesAssignmentFilter = 1
	)
	, withAppliedFilters AS
	(
		SELECT *,
			ROW_NUMBER() OVER(
				ORDER BY VerbatimTerm
			) AS RowNumber
		FROM withHistoryFilters
		WHERE passesHistoryFilter = 1
	)

	INSERT INTO @gridData (
		CodingElementId,
		SegmentedGroupCodingPatternID,
		TrackableObjectId, 
		Term, 
		Code, 
		SubjectOID,
		MaxCount)
	SELECT 	
		CodingElementId, 
		SegmentedGroupCodingPatternID,
		TrackableObjectId,
		Term,
		Code,
		SourceSubject,
		0 AS MaxCount
	FROM withAppliedFilters
	WHERE RowNumber BETWEEN @startRowNumber AND @endRowNumber
		AND RowNumber <= @SearchLimit
	UNION 
	SELECT 
		-1, NULL, NULL, NULL, NULL, NULL,
		(SELECT COUNT(1) FROM withAppliedFilters)
	OPTION (RECOMPILE)
	
	SELECT @count = MaxCount FROM @gridData
	WHERE CodingElementId = -1

	SELECT 
		GD.CodingElementId,
		GD.SegmentedGroupCodingPatternID,
		TR.ExternalObjectName AS StudyName, 
		SubjectOID,
		SGCP.CodingElementGroupID, 
		Term, 
		Code, 
		UH.Login AS CodedBy,
		CA.IsAutoCoded,
		dbo.fnIsValidForAutoCode(@IsAutoApproval, @ForcePrimaryPath, SGCP.IsExactMatch, SGCP.SynonymStatus, CP.PathCount) AS IsValidAutoCodePattern,
		CA.Created AS DateCoded,
		CP.CodingPath,
		DependantCount,
		L.ReferenceValue AS LogLine
	FROM @gridData GD
		CROSS APPLY
		(
			SELECT 
				DependantCount = ISNULL(COUNT(1), 0)
			FROM CodingElements CE
			WHERE CE.AssignedSegmentedGroupCodingPatternID = GD.SegmentedGroupCodingPatternID
				AND CE.IsInvalidTask = 0
				AND CE.WorkflowStateID <> @reconsiderState
		) AS X
		JOIN SegmentedGroupCodingPatterns SGCP
			ON SGCP.SegmentedGroupCodingPatternID = GD.SegmentedGroupCodingPatternID
			AND SGCP.Active = 1
		JOIN CodingPatterns CP
			ON SGCP.CodingPatternID = CP.CodingPatternID
		CROSS APPLY
		(
			SELECT TOP 1 *
			FROM CodingAssignment CA 
			WHERE CA.CodingElementID = GD.CodingElementID 
				AND CA.Active = 1
			ORDER BY CA.CodingAssignmentID DESC
		) AS CA
		JOIN Users UH
			ON CA.UserID = UH.UserId
		JOIN TrackableObjects TR 
			ON GD.TrackableObjectId = TR.TrackableObjectID
		CROSS APPLY
		(
			SELECT ReferenceValue
			FROM CodingSourceTermReferences
			WHERE CodingSourceTermId = GD.CodingElementId
				AND ReferenceName = 'Line'
		) AS L
	WHERE GD.CodingElementId > 0	   

END
GO

SET NOCOUNT OFF
GO

