/** 
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Mark Hwe [mhwe@mdsol.com] - reused by Altin Vardhami [avardhami@mdsol.com]
**
** Complete history on bottom of file
**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingDataForReclassify')
	DROP PROCEDURE dbo.spCodingDataForReclassify
GO

-- spCodingDataForReclassify_sm '487', 4, 'eng', null, null, null, null, null, 1,	0, null, null, 1, '','','',	'',	100, 10, 0, 59, null--, @cnt output

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

	-- set the count
	SET @count = 0

	-- Allow reclassify to read without aquiring locks (same behavior as task page sql);
	-- long running transactions (like study migration) will lock these same tables.
	SET TRANSACTION ISOLATION LEVEL  READ UNCOMMITTED

	-- If page index is invalid, just return empty set.
	if (@PageIndex is null or @PageIndex < 0 or @PageSize is null or @PageSize <= 0)
		RETURN
		
	if (@SearchLimit IS NULL OR @SearchLimit <= 0)
		SET @SearchLimit = 1

	DECLARE @StudyIDTable TABLE (StudyID INT)
	
	INSERT INTO @StudyIDTable
	SELECT * FROM dbo.fnParseDelimitedString(@StudyIDs, ',')

	DECLARE @SGCPIDTable TABLE (SegmentedGroupCodingPatternID INT)
	INSERT INTO @SGCPIDTable
	SELECT * FROM dbo.fnParseDelimitedString(@SkipSegGroupCodingPatternIDs, ',')

	declare @startRowNumber bigint, @endRowNumber int
	set @startRowNumber = (@PageIndex * @PageSize) + 1
	IF (@startRowNumber > @SearchLimit)
		SET @startRowNumber = @SearchLimit
	set @endRowNumber = @startRowNumber + @PageSize - 1
	IF (@endRowNumber > @SearchLimit)
		SET @endRowNumber = @SearchLimit

	IF (@WorkflowActionStartDate = '')
		SET @WorkflowActionStartDate = NULL
	IF (@WorkflowActionEndDate = '')
		SET @WorkflowActionEndDate = NULL
	
	IF (@WorkflowActionStartDate IS NULL OR @WorkflowActionEndDate IS NULL)
	BEGIN
		IF (@WorkflowActionStartDate IS NULL)
			SET @WorkflowActionStartDate = '1/1/1753'
		IF (@WorkflowActionEndDate IS NULL)
			SET @WorkflowActionEndDate = '12/31/9999 23:59:59'
	END
	
	PRINT @WorkflowActionStartDate
	PRINT @WorkflowActionEndDate
	
	IF (@IncludeAutoCodedItems IS NULL) SET @IncludeAutoCodedItems = 0
	IF (@DictionaryVersionID IS NULL OR @DictionaryVersionID <= 0) SET @DictionaryVersionID = 0

	DECLARE @priorWorkflowStateTable TABLE(Id INT)
	DECLARE @priorWorkflowActionTable TABLE(Id INT)	
	DECLARE @userIDTable TABLE(Id INT)

	SET @PriorWorkflowStateIDs = ISNULL(@PriorWorkflowStateIDs, '')
	IF (@PriorWorkflowStateIDs <> '')
		INSERT INTO @priorWorkflowStateTable
		SELECT CAST(Item AS INT) FROM dbo.fnParseDelimitedString(@PriorWorkflowStateIDs, ',')
	--ELSE
	--	INSERT INTO @priorWorkflowStateTable VALUES(-1)
	
	SET @PriorWorkflowActionIDs = ISNULL(@PriorWorkflowActionIDs, '')
	IF (@PriorWorkflowActionIDs <> '')
		INSERT INTO @priorWorkflowActionTable
		SELECT CAST(Item AS INT) FROM dbo.fnParseDelimitedString(@PriorWorkflowActionIDs, ',')
	--ELSE
	--	INSERT INTO @priorWorkflowActionTable VALUES(-1)

	IF (@UserIDs = '')
		SET @UserIDs = NULL

	IF (@UserIDs IS NOT NULL)
		INSERT INTO @userIDTable
		SELECT CAST(Item AS INT) FROM dbo.fnParseDelimitedString(@UserIDs, ',')
	--ELSE
	--	INSERT INTO @userIDTable VALUES(-1)
		
	IF (@IncludeAutoCodedItems = 1)
		INSERT INTO @userIDTable VALUES(-2)


	DECLARE @gridData TABLE(
		CodingElementId BIGINT,
		SegmentedGroupCodingPatternID BIGINT,
		StudyName NVARCHAR(100), 
		SubjectOID NVARCHAR(1000),
		CodingElementGroupID BIGINT,
		Term NVARCHAR(1000), 
		Code NVARCHAR(100), 
		CodingPath VARCHAR(1000), 
		CodedBy NVARCHAR(100),
		IsAutoCoded BIT,
		IsValidAutoCodePattern BIT,
		DateCoded DATETIME,
		MaxCount INT
		)

	;WITH searchQueryCTE (
		CodingElementId, 
		SegmentedGroupCodingPatternID, 
		TrackableObjectId, 
		CodingElementGroupID,
		Term,
		Code,
		CodingPath,
		SourceSubject,
		Locale, 
		DictionaryVersionId,
		WorkflowStateID,
		UserID,
		IsAutoCoded, IsValidAutoCodePattern, DateCoded,
		RowNumber
	) AS (
		SELECT e.CodingElementId, 
			e.AssignedSegmentedGroupCodingPatternId,
			SDV.StudyID, 
			SGCP.CodingElementGroupID,
			e.AssignedTermText,
			e.AssignedTermCode,
			e.AssignedCodingPath,
			e.SourceSubject,
			@Locale, 
			@DictionaryVersionID,
			e.WorkflowStateID,
			ca.UserID, 
			ca.IsAutoCoded, 
			dbo.fnIsValidForAutoCode(@IsAutoApproval, @ForcePrimaryPath, SGCP.IsExactMatch, SGCP.SynonymStatus, CP.PathCount) AS IsValidForAutoCode,
			ca.Created, --e.CompletionDate, e.AutoCodeDate, 
			ROW_NUMBER() OVER(ORDER BY
				STD.StudyID, e.VerbatimTerm
			) -- end of orderby
		from @StudyIDTable STD
			JOIN StudyDictionaryVersion SDV
				ON STD.StudyID = SDV.StudyID
				AND @DictionaryVersionID = SDV.DictionaryVersionID
				AND @Locale = SDV.DictionaryLocale	
				AND SDV.StudyLock = 1 -- study is not locked  		
			JOIN CodingElements e 
				ON e.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
				AND e.SegmentId = @SegmentID
				AND e.IsStillInService = 0
				AND	(@Term IS NULL OR @Term = '' OR @Term = e.AssignedTermText)
				AND (@Verbatim IS NULL OR @Verbatim = '' OR e.VerbatimTerm like '%' + @Verbatim + '%')
				AND e.IsClosed = 1
				AND e.IsInvalidTask = 0
				AND (@Code IS NULL OR @Code = '' OR @Code = e.AssignedTermCode)
			JOIN CodingAssignment CA 
				ON CA.CodingElementID = e.CodingElementID 
				AND CA.Active = 1
				AND CA.IsAutoCoded IN (0, @IncludeAutoCodedItems)
				-- user check
				AND (@UserIDs IS NULL OR
					 EXISTS (SELECT NULL FROM @userIDTable WHERE Id IN (-1, ca.UserID) )
					 )
			JOIN SegmentedGroupCodingPatterns SGCP
				ON SGCP.SegmentedGroupCodingPatternID = e.AssignedSegmentedGroupCodingPatternId
				AND SGCP.Active = 1
			JOIN CodingPatterns CP
			    ON SGCP.CodingPatternID = CP.CodingPatternID
		WHERE 
			(
				(@WorkflowActionStartDate IS NULL AND @WorkflowActionEndDate IS NULL AND
				@PriorWorkflowStateIDs = '' AND @PriorWorkflowActionIDs = '')
				OR
				EXISTS (
					SELECT NULL
					FROM WorkflowTaskHistory WTH
					WHERE WTH.WorkflowTaskId = e.CodingElementID AND
						-- dates check
						WTH.Created BETWEEN @WorkflowActionStartDate AND @WorkflowActionEndDate
						-- 2. priorstateid check
						AND
						( 
						    @PriorWorkflowStateIDs = '' OR
							EXISTS (SELECT NULL FROM @priorWorkflowStateTable WHERE Id = WTH.WorkflowStateID)
						)
						-- 3. prioraction check
						AND 
						(
						    @PriorWorkflowActionIDs = '' OR
							EXISTS (SELECT NULL FROM @priorWorkflowActionTable WHERE Id = WTH.WorkflowActionID)
						)
				 )
			 )
			 AND NOT EXISTS 
			 (SELECT NULL FROM @SGCPIDTable SGCP_Skip WHERE SGCP.SegmentedGroupCodingPatternID = SGCP_Skip.SegmentedGroupCodingPatternID
			 )
	)
	
	INSERT INTO @gridData (
		CodingElementId,
		SegmentedGroupCodingPatternID,
		StudyName, 
		SubjectOID,
		CodingElementGroupID, 
		Term, 
		Code, 
		CodingPath,
		CodedBy,
		IsAutoCoded,
		IsValidAutoCodePattern,
		DateCoded,
		MaxCount)
	SELECT
		XI.CodingElementId, 
		XI.SegmentedGroupCodingPatternID,
		TR.ExternalObjectName, 
		XI.SourceSubject,
		XI.CodingElementGroupID, 
		XI.Term, 
		XI.Code, 
		XI.CodingPath,
		uh.Login,
		XI.IsAutoCoded, XI.IsValidAutoCodePattern, XI.DateCoded,
		0	
	FROM
	(
	SELECT 	
		CodingElementId, 
		SegmentedGroupCodingPatternID,
		TrackableObjectId,
		CodingElementGroupID, 
		Term,
		Code,
		CodingPath,
		SourceSubject,
		DictionaryVersionId,
		WorkflowStateID,
		UserID,
		IsAutoCoded, 
		IsValidAutoCodePattern, 
		DateCoded
	FROM searchQueryCTE
	WHERE RowNumber BETWEEN @startRowNumber AND @endRowNumber
		AND RowNumber <= @SearchLimit
	) AS XI
		JOIN TrackableObjects TR 
			ON XI.TrackableObjectId = TR.TrackableObjectID	
		JOIN Users uh
			ON XI.UserID = uh.UserId
	UNION 
	SELECT 
		-1, NULL, NULL, NULL, NULL, NULL, NULL, 
		NULL, NULL, NULL, NULL,	NULL,
		(SELECT COUNT(*) FROM searchQueryCTE)
	OPTION (RECOMPILE)
	
	SELECT @count = MaxCount FROM @gridData
	WHERE CodingElementId = -1
	
	-- process the nodepath
	SELECT 
		CodingElementId,
		SegmentedGroupCodingPatternID,
		StudyName, 
		SubjectOID,
		CodingElementGroupID, 
		Term, 
		Code, 
		CodedBy,
		IsAutoCoded,
		IsValidAutoCodePattern,
		DateCoded,
		CodingPath,
		X.DependantCount AS DependantCount
	FROM @gridData GD
		CROSS APPLY
		(
			SELECT 
				DependantCount = ISNULL(COUNT(*), 0)
			FROM CodingElements CE
			WHERE CE.AssignedSegmentedGroupCodingPatternID = GD.SegmentedGroupCodingPatternID
				AND CE.IsInvalidTask = 0
				AND CE.WorkflowStateID <> @reconsiderState
		) AS X
		WHERE CodingElementId > 0
	   


END
GO

SET NOCOUNT OFF
GO
 
