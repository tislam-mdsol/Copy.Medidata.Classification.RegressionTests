/** $Workfile: spCodingElementSearch.sql $
**
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Mark Hwe [mhwe@mdsol.com]
**
** Complete history on bottom of file
**/

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
	@SortColumnName VARCHAR(40)
)
AS
BEGIN
	IF(ISNULL (@LastStreamingID, -1) < 0
	OR ISNULL(@PageSize,0) <= 0)
	BEGIN
		select *, 0 as TotalRowCount from CodingElements where 1 = 0
		return
	END
	
	DECLARE @errorString NVARCHAR(400) 
	IF(@SortColumnName <> 'CodingElementId')
	BEGIN
		SET @errorString = N'Error. Sorting columns other than CodingElementId is not supported.'
		RAISERROR(@errorString, 16, 1)
		RETURN	 
	END
	
	DECLARE @versionOrdinal INT, @IOROffset INT
	
	IF (@WorkflowActionStartDate IS NULL OR @WorkflowActionEndDate IS NULL) 
	BEGIN
		IF (@WorkflowActionStartDate IS NULL)
			SET @WorkflowActionStartDate = '1/1/1753'
		IF (@WorkflowActionEndDate IS NULL)
			SET @WorkflowActionEndDate = '12/31/9999 23:59:59'
	END
	
	IF (@IncludeAutoCodedItems IS NULL) SET @IncludeAutoCodedItems = 0
	
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

	DECLARE @approveActionId INT

	SELECT @approveActionId = 6
	

	DECLARE @tmpTable TABLE(
		CodingElementId BIGINT PRIMARY KEY,
		SourceSubject NVARCHAR(450),
		StudyDictionaryVersionId INT,
		VerbatimTerm NVARCHAR(450),
		AutoCodeDate DATETIME, 
		CompletionDate DATETIME,
		TotalRowCount INT,
		SGCPId BIGINT,
		WSId INT,
		CodeUser INT,
		CACreated DATETIME,
		IsAutoCoded BIT
	)

	;WITH searchQueryCTE 
	as (
		select 
			e.CodingElementId,
			e.SourceSubject,
		 	e.StudyDictionaryVersionId,
			e.VerbatimTerm,
			e.WorkflowStateID,
			e.AutoCodeDate, 
			e.CompletionDate,
			e.AssignedSegmentedGroupCodingPatternId,
			CodeUser,
			CACreated,
			IsAutoCoded
		from CodingElements e
			JOIN @sdvTable SDV
				on e.StudyDictionaryVersionId = SDV.Id
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
		SourceSubject,
		StudyDictionaryVersionId,
		VerbatimTerm,
		AutoCodeDate,
		CompletionDate,
		TotalRowCount,
		SGCPId,
		WSId,
		CodeUser,
		CACreated,
		IsAutoCoded
	)
	SELECT TOP(@PageSize)
		CodingElementId,
		SourceSubject,
		StudyDictionaryVersionId,
		VerbatimTerm,
		AutoCodeDate, 
		CompletionDate,

	    (SELECT COUNT(*) FROM searchQueryCTE) AS TotalRowCount,

		AssignedSegmentedGroupCodingPatternID,
		WorkflowStateId,
		CodeUser,
		CACreated,
		ISNULL(IsAutoCoded, 0)
	FROM searchQueryCTE
	ORDER BY CodingElementId ASC
	OPTION (RECOMPILE)

	SELECT 
		CodingElementId,
		SourceSubject,
		StudyDictionaryVersionId,
		VerbatimTerm,
		IsAutoCoded,
		AutoCodeDate, 
		CompletionDate,

		Coder.Login AS CodedBy,
		Approver.Login AS ApprovedBy, 

		WSId AS WorkflowStateID,

		CD.CodingPath,
		CD.DictionaryLevelID as LevelId --actual coded dictionary level

	    ,TotalRowCount
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
					AND Created > CACreated
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

END
GO

