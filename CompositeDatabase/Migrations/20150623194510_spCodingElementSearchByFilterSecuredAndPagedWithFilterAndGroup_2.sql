/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND 
			name = 'spCodingElementSearchByFilterSecuredAndPagedWithFilterAndGroup')
	BEGIN
		DROP Procedure dbo.spCodingElementSearchByFilterSecuredAndPagedWithFilterAndGroup
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
*/

-- exec spCodingElementSearchByFilterSecuredAndPagedWithFilterAndGroup -1, 0, '', 0, 'eng', 10, 0, 0, -1, 0, -1, -1, -1, 0, -1, -1, 'VerbatimTerm', 1, '343,344', 65, 0, '-1', 0

CREATE procedure dbo.spCodingElementSearchByFilterSecuredAndPagedWithFilterAndGroup
(
	@userID INT,
	@SourceSystemID INT = 0,		-- 0=All source system, >0=specific source system
	@SearchForText nvarchar(448),	-- search for text based on search for option selected
	@TrackableObjectId bigint = 0,	-- 0=All TrackableObjects, >0=with specific TrackableObjectId, -->> -1=Old TrackableObjects, 
	@Locale CHAR(3),
	@pageSize INT, 
	@pageIndex INT, 
	@TimeElapsed int = 0,			-- 0=All Dates, 
	@QueryStatus int = -1,
	@SynonymListId INT = 0,			-- 0=All Lists, > 0 = specific synonym list
	@Priority INT = -1,				-- -1=All Priorities, >-1=specific priority
	
	-- the following are group related params
	@CodingElementGroupID BIGINT = -1,
	@CodingPatternID BIGINT = -1,
	@IsInsideGroupDisplayMode BIT,
	@GroupWorkflowStateID INT,
	@GroupSynonymListID INT,
	@GroupQueryStatus INT,
	
	@SortExpression VARCHAR(100),
	@IsAscending BIT,

	@SecuredStudyList VARCHAR(MAX),

	@SegmentId INT,
	
	-- View Options
	@InService INT = 0,					-- 0: Not in service, 1: In Service, -1: Either
	@WorkflowStates VARCHAR(MAX),		-- comma seperated list of worflow state ids, '-1': All workflow states
	@InStudyMigration BIT					-- 1: In Study Migration, 0: All others study status
) 
AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL	READ UNCOMMITTED
	
	DECLARE @Today DATETIME
		
	SELECT @Today = GETUTCDATE()
	
	DECLARE @CodingElementsGroupTable TABLE
		(
			RowNum INT PRIMARY KEY,
			CountAll INT, 
			CodingElementGroupID BIGINT,
			CodingElementID BIGINT,
			SegmentedGroupCodingPatternID BIGINT,
			
			CodingPatternID BIGINT,
			
			SynonymListID INT,
			VerbatimTerm NVARCHAR(1000),
			SecondsElapsed INT,
			WorkflowStateID BIGINT,
			IsGroup BIT,
			QueryStatus INT,
			
			CodingPath VARCHAR(300),
			IsValidForAutoCode BIT,
			TermText NVARCHAR(450),
			
			FilterGroupCount INT,
			GroupCount INT,
			IsInGroupExcludedByFilter BIT,
			
			Priority TINYINT
		)	
	
	-- check if group is being asked
	IF (ISNULL(@IsInsideGroupDisplayMode, 0) = 1 AND ISNULL(@CodingElementGroupID, 0) > 0)
	BEGIN
		
		;WITH SQLPaging (
			CodingElementID,
			SegmentedGroupCodingPatternID,
			VerbatimTerm, 
			SecondsElapsed, 
			CodingPatternID,
			TermText,
			IsValidForAutoCode,
			IsInGroupExcludedByFilter,
			Priority,
			QueryStatus)
		AS
		(
			SELECT 	
					CE.CodingElementID,
					CE.AssignedSegmentedGroupCodingPatternId,
					VerbatimTerm = G.VerbatimText,
					DATEDIFF(second, CE.Created, @Today) AS ElapsedFromCreation,
					SGCP.CodingPatternID,
					CE.AssignedTermText,
					CASE WHEN ISNULL(SGCP.SynonymStatus, 0) = 2 THEN 1 ELSE 0 END AS IsValidForAutoCode,
					CASE WHEN 
						(
						@TrackableObjectId = 0 OR
						(@TrackableObjectId > 0 AND tr.TrackableObjectID = @TrackableObjectId) OR
						(@TrackableObjectId = -1 AND tr.IsTestStudy = 0) OR
						(@TrackableObjectId = -2 AND tr.IsTestStudy = 1)
						)						
						AND @SourceSystemID IN (0, CE.SourceSystemID)
						THEN 0
						ELSE 1
					END AS IsInGroupExcludedByFilter,
					CE.Priority,
					CE.QueryStatus
			FROM CodingElements CE
				LEFT JOIN SegmentedGroupCodingPatterns SGCP
					ON CE.AssignedSegmentedGroupCodingPatternID = SGCP.SegmentedGroupCodingPatternID
					AND SGCP.Active = 1
					AND SGCP.CodingPatternID = @CodingPatternID
				JOIN StudyDictionaryVersion SDV
					ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
				JOIN SynonymMigrationMngmt SMM
					ON SMM.SynonymMigrationMngmtID = SDV.SynonymManagementID
				JOIN TrackableObjects tr
					ON tr.TrackableObjectID = SDV.StudyID
				JOIN CodingElementGroups CEG
				    ON CE.CodingElementGroupId = CEG.CodingElementGroupID
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
			WHERE @CodingPatternID IN (0, SGCP.CodingPatternID)
				AND CE.CodingElementGroupId = @CodingElementGroupID
				AND CE.SegmentId = @SegmentId
				AND @InService IN (-1, CE.IsStillInService) -- avoid those still in service
				AND CE.WorkflowStateID = @GroupWorkflowStateID
				AND CE.IsClosed = 0
				AND @GroupSynonymListID = SDV.SynonymManagementID
				AND ((@GroupQueryStatus IS NULL AND CE.QueryStatus IS NULL) OR (@GroupQueryStatus = CE.QueryStatus))
		)
		
		INSERT INTO @CodingElementsGroupTable (
				RowNum,
				CountAll, 
				CodingElementGroupID,
				CodingElementID,
				SegmentedGroupCodingPatternID,
				CodingPatternID,
				SynonymListID,
				VerbatimTerm,
				SecondsElapsed,
				WorkflowStateId,
	
				CodingPath,
				IsValidForAutoCode,
				TermText,
				
				FilterGroupCount,
				GroupCount,
				IsGroup,
				IsInGroupExcludedByFilter,
				Priority,
				QueryStatus)
		SELECT 	Row,
				CountAll,
				@CodingElementGroupID,
				CodingElementID,
				SegmentedGroupCodingPatternID,
				CD.CodingPatternID,
				@GroupSynonymListID,
				VerbatimTerm,
				SecondsElapsed,
				@GroupWorkflowStateID AS WorkflowStateId,
				
				CD.CodingPath,
				IsValidForAutoCode,
				TermText,
				
				1,
				1,
				0,
				IsInGroupExcludedByFilter,
				Priority,
				QueryStatus
		FROM
		(
		SELECT Row,
				CountAll,
				CodingElementID,
				SegmentedGroupCodingPatternID,
				CodingPatternID,
				VerbatimTerm,
				SecondsElapsed,			
				IsValidForAutoCode,
				TermText,
				IsInGroupExcludedByFilter,
				Priority,
				QueryStatus
		FROM
		(SELECT ROW_NUMBER() OVER 
			(ORDER BY CodingElementID DESC
				-- TODO : fix Sorting
				--CASE WHEN @SortExpression='TermLiteral' AND @SortOrder=1 THEN Term_LOC END ASC,
				--CASE WHEN @SortExpression='TermLiteral' AND @SortOrder=2 THEN Term_LOC END DESC,
				--CASE WHEN @SortExpression='TermStatus' AND @SortOrder=1 THEN TermStatus END ASC,
				--CASE WHEN @SortExpression='TermStatus' AND @SortOrder=2 THEN TermStatus END DESC
			)
		AS Row, 0 AS CountAll,
				CodingElementID,
				SegmentedGroupCodingPatternID,
				CodingPatternID,
				VerbatimTerm,
				SecondsElapsed,			
				IsValidForAutoCode,
				TermText,
				IsInGroupExcludedByFilter,
				Priority,
				QueryStatus
		FROM SQLPaging
		) AS SP
		WHERE SP.Row BETWEEN (@pageIndex) * @pageSize + 1 AND (@pageIndex + 1) * @pageSize
		) AS X_Internal
			LEFT JOIN CodingPatterns CD
				ON CD.CodingPatternID = X_Internal.CodingPatternID				
		UNION
		SELECT -1, COUNT(*) AS CountAll,	
			-1, -1, -1, -1, -1, '',
			0, -1, 
			NULL, -- CD.CodingPath 
			0, '', 0, 0, -1, 0, 1, -1
		FROM SQLPaging
		OPTION (RECOMPILE)
		
	END
	
	
	IF (@IsInsideGroupDisplayMode = 0)
	BEGIN

		DECLARE @studyDictionaryIds TABLE (StudyDictionaryVersionId INT PRIMARY KEY, SynonymListID INT)
		DECLARE @workflowStateIds TABLE (WorkflowStateId INT PRIMARY KEY)
		
		INSERT INTO @studyDictionaryIds(StudyDictionaryVersionId, SynonymListID)
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

		-- fix the searchstring	
		DECLARE @SearchForTextLen INT
		
		SELECT @SearchForTextLen = LEN(@SearchForText)
		
		DECLARE @startIndex INT, @endIndex INT
		
		SELECT @startIndex = (@pageIndex) * @pageSize + 1,
			@endIndex = (@pageIndex + 1) * @pageSize
		
		-- fix the times
		DECLARE @MinDateTime DATETIME,
			@MaxDateTime DATETIME,
			@FilterTimeElapsed INT
			
		EXEC spTimeElapsedResolveDateTime
			@TimeElapsed,
			@Today,
			@SegmentId,
			@MinDateTime OUTPUT,
			@MaxDateTime OUTPUT
			
		SELECT @FilterTimeElapsed = DATEDIFF(second, @MinDateTime, @Today)
		

		IF (@SortExpression = 'VerbatimTerm' AND @IsAscending = 1)	
		BEGIN
	
			;WITH SQLPaging (
				CodingElementGroupID,
				WorkflowStateId,
				SegmentedGroupCodingPatternID,
				SynonymListID,
				CodingElementId,
				QueryStatus,
				GroupCount)
			AS
			(
				SELECT 
					CodingElementGroupID,
					WorkflowStateID,
					AssignedSegmentedGroupCodingPatternID,
					SynonymListID,
					MIN(CodingElementId) AS CodingElementId,
					CE.QueryStatus,
					COUNT(*)
				FROM CodingElements CE
					-- SynonymList & Study
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
				GROUP BY 
					CodingElementGroupID,	-- group id
					WorkflowStateId,				-- workflow state
					AssignedSegmentedGroupCodingPatternID,
					SynonymListID,
					QueryStatus
			)
			
			
			INSERT INTO @CodingElementsGroupTable (
					RowNum,
					CountAll, 
					CodingElementGroupID,
					CodingElementID,
					SegmentedGroupCodingPatternID,
					CodingPatternID,
					SynonymListID,
					VerbatimTerm,
					SecondsElapsed,
					WorkflowStateId,
					
					CodingPath,
					IsValidForAutoCode,
					TermText,
					
					FilterGroupCount,
					GroupCount,
					IsGroup,
					IsInGroupExcludedByFilter,
					Priority,
					QueryStatus)
			SELECT 	Row,
					0 AS CountAll,
					X_Internal.CodingElementGroupID,
					X_Internal.CodingElementID,
					X_Internal.SegmentedGroupCodingPatternID,
					ISNULL(SGCP_CD.CodingPatternID, 0) AS CodingPatternID,
					X_Internal.SynonymListID,
					X_Internal.Verbatim,
					CASE WHEN @TimeElapsed = 0 THEN DATEDIFF(second, XX.Created, @Today) ELSE @FilterTimeElapsed END AS SecondsElapsed,
					X_Internal.WorkflowStateID,
					
					SGCP_CD.CodingPath,
					ISNULL(SGCP_CD.IsValidForAutoCode, 0) AS IsValidForAutoCode,
					XX.AssignedTermText,
					
					FilterCount,
					XX.GroupCount AS GroupCount,

					CASE 
						WHEN XX.GroupCount > 1 THEN 1
						ELSE 0
					END AS IsGroup,
					0,
					XX.Priority,
					QueryStatus
			FROM
			(SELECT
					Row,
					CodingElementGroupID,
					SegmentedGroupCodingPatternID,
					SynonymListID,
					WorkflowStateId,
					CodingElementID,
					Verbatim,
					FilterCount,
					QueryStatus
			FROM
			(
				SELECT
					ROW_NUMBER() OVER (ORDER BY G.VerbatimText ASC ) AS Row, 
					SQP.CodingElementGroupID,
					SQP.SegmentedGroupCodingPatternID,
					SQP.SynonymListID,
					SQP.WorkflowStateId,
					SQP.CodingElementID,
					G.VerbatimText AS Verbatim,
					SQP.GroupCount AS FilterCount,
					SQP.QueryStatus
				FROM SQLPaging SQP
					JOIN CodingElementGroups CEG
						ON CEG.CodingElementGroupID = SQP.CodingElementGroupID
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
				) AS SP
				WHERE SP.Row BETWEEN @startIndex AND @endIndex
			) AS X_Internal
				CROSS APPLY
				(
					SELECT 
						GroupCount = COUNT(*),
						AssignedTermText = MAX(AssignedTermText),
						CASE WHEN @Priority = -1 THEN MIN(Priority) ELSE @Priority END AS Priority,
						Created = MIN(Created)
					FROM CodingElements CE
					WHERE CodingElementGroupID = X_Internal.CodingElementGroupID
						AND StudyDictionaryVersionId IN 
							(SELECT StudyDictionaryVersionId FROM @studyDictionaryIds
							WHERE SynonymListID = X_Internal.SynonymListID)
						AND IsClosed = 0
						AND @InService IN (-1, IsStillInService)
						AND WorkflowStateID = X_Internal.WorkflowStateId
						AND X_Internal.SegmentedGroupCodingPatternID = AssignedSegmentedGroupCodingPatternId
						AND ((X_Internal.QueryStatus IS NULL AND CE.QueryStatus IS NULL) OR (X_Internal.QueryStatus = CE.QueryStatus))
				) AS XX
				CROSS APPLY
				( 
					SELECT TOP 1
						MAX(CodingPath) AS CodingPath,
						MAX(IsValidForAutoCode) AS IsValidForAutoCode,
						MAX(CodingPatternID) AS CodingPatternID
					FROM
					(
						SELECT
							CD.CodingPath,
							CASE WHEN SGCP.SynonymStatus = 2 THEN 1 ELSE 0 END AS IsValidForAutoCode,
							SGCP.CodingPatternID
						FROM SegmentedGroupCodingPatterns SGCP
							LEFT JOIN CodingPatterns CD
								ON CD.CodingPatternID = SGCP.CodingPatternID
						WHERE SGCP.SegmentedGroupCodingPatternID = X_Internal.SegmentedGroupCodingPatternID
							AND SGCP.Active = 1
					) AS SC_INT
				) AS SGCP_CD
			UNION
			SELECT -1, COUNT(*) AS CountAll,	
				-1, -1,
				-1, -1,
				-1, '', 0, -1,
				NULL, -- CD.CodingPath
				0, 
				'', 0, 
				0, -1, 
				0, 1, -1
			FROM SQLPaging
			OPTION (RECOMPILE)
			
		END
		ELSE IF (@SortExpression = 'VerbatimTerm' AND @IsAscending = 0)
		BEGIN
		
			;WITH SQLPaging (
				CodingElementGroupID,
				WorkflowStateId,
				SegmentedGroupCodingPatternID,
				SynonymListID,
				CodingElementId,
				QueryStatus,
				GroupCount)
			AS
			(
				SELECT 
					CodingElementGroupID,
					WorkflowStateID,
					AssignedSegmentedGroupCodingPatternID,
					SynonymListID,
					MIN(CodingElementId) AS CodingElementId,
					CE.QueryStatus,
					COUNT(*)
				FROM CodingElements CE
					-- SynonymList & Study
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
				GROUP BY 
					CodingElementGroupID,	-- group id
					WorkflowStateId,				-- workflow state
					AssignedSegmentedGroupCodingPatternID,
					SynonymListID,
					QueryStatus
			)
			
			INSERT INTO @CodingElementsGroupTable (
					RowNum,
					CountAll, 
					CodingElementGroupID,
					CodingElementID,
					SegmentedGroupCodingPatternID,
					CodingPatternID,
					SynonymListID,
					VerbatimTerm,
					SecondsElapsed,
					WorkflowStateId,
					
					CodingPath,
					IsValidForAutoCode,
					TermText,
					
					FilterGroupCount,
					GroupCount,
					IsGroup,
					IsInGroupExcludedByFilter,
					Priority,
					QueryStatus)
			SELECT 	Row,
					0 AS CountAll,
					X_Internal.CodingElementGroupID,
					X_Internal.CodingElementID,
					X_Internal.SegmentedGroupCodingPatternID,
					ISNULL(SGCP_CD.CodingPatternID, 0) AS CodingPatternID,
					X_Internal.SynonymListID,
					X_Internal.Verbatim,
					CASE WHEN @TimeElapsed = 0 THEN DATEDIFF(second, XX.Created, @Today) ELSE @FilterTimeElapsed END AS SecondsElapsed,
					X_Internal.WorkflowStateID,
					
					SGCP_CD.CodingPath,
					ISNULL(SGCP_CD.IsValidForAutoCode, 0) AS IsValidForAutoCode,
					XX.AssignedTermText,
					
					FilterCount,
					XX.GroupCount AS GroupCount,

					CASE 
						WHEN XX.GroupCount > 1 THEN 1
						ELSE 0
					END AS IsGroup,
					0,
					XX.Priority,
					QueryStatus
			FROM
			(SELECT
					Row,
					CodingElementGroupID,
					SegmentedGroupCodingPatternID,
					SynonymListID,
					WorkflowStateId,
					CodingElementID,
					Verbatim,
					FilterCount	,
					QueryStatus
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER (ORDER BY G.VerbatimText DESC ) AS Row, 
					SQP.CodingElementGroupID,
					SQP.SegmentedGroupCodingPatternID,
					SQP.SynonymListID,
					SQP.WorkflowStateId,
					SQP.CodingElementID,
					G.VerbatimText AS Verbatim,
					SQP.GroupCount AS FilterCount,
					SQP.QueryStatus
				FROM SQLPaging SQP
					JOIN CodingElementGroups CEG
						ON CEG.CodingElementGroupID = SQP.CodingElementGroupID
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
				) AS SP
				WHERE SP.Row BETWEEN @startIndex AND @endIndex
			) AS X_Internal
				CROSS APPLY
				(
					SELECT 
						GroupCount = COUNT(*),
						AssignedTermText = MAX(AssignedTermText),
						CASE WHEN @Priority = -1 THEN MIN(Priority) ELSE @Priority END AS Priority,
						Created = MIN(Created)
					FROM CodingElements CE
					WHERE CodingElementGroupID = X_Internal.CodingElementGroupID
						AND StudyDictionaryVersionId IN 
							(SELECT StudyDictionaryVersionId FROM @studyDictionaryIds
							 WHERE SynonymListID = X_Internal.SynonymListID)
						AND IsClosed = 0
						AND @InService IN (-1, IsStillInService)
						AND WorkflowStateID = X_Internal.WorkflowStateId
						AND X_Internal.SegmentedGroupCodingPatternID = AssignedSegmentedGroupCodingPatternId
						AND ((X_Internal.QueryStatus IS NULL AND CE.QueryStatus IS NULL) OR (X_Internal.QueryStatus = CE.QueryStatus))
				) AS XX
				CROSS APPLY
				( 
					SELECT TOP 1
						MAX(CodingPath) AS CodingPath,
						MAX(IsValidForAutoCode) AS IsValidForAutoCode,
						MAX(CodingPatternID) AS CodingPatternID
					FROM
					(
						SELECT
							CD.CodingPath,
							CASE WHEN SGCP.SynonymStatus = 2 THEN 1 ELSE 0 END AS IsValidForAutoCode,
							SGCP.CodingPatternID
						FROM SegmentedGroupCodingPatterns SGCP
							LEFT JOIN CodingPatterns CD
								ON CD.CodingPatternID = SGCP.CodingPatternID
						WHERE SGCP.SegmentedGroupCodingPatternID = X_Internal.SegmentedGroupCodingPatternID
							AND SGCP.Active = 1
					) AS SC_INT
				) AS SGCP_CD
			UNION
			SELECT -1, COUNT(*) AS CountAll,	
				-1, -1,
				-1, -1, 
				-1, '', 0, -1,
				NULL, -- CD.CodingPath
				0, 
				'', 0, 
				0, -1, 
				0, 1, -1
			FROM SQLPaging
			OPTION (RECOMPILE)
						
		END
		IF (@SortExpression = 'AssignedDictionaryTerm' AND @IsAscending = 1)	
		BEGIN
		
			;WITH SQLPaging (
				CodingElementGroupID,
				WorkflowStateId,
				SegmentedGroupCodingPatternID,
				SynonymListID,
				AssignedTermText,
				CodingElementId,
				QueryStatus,
				GroupCount)
			AS
			(
				SELECT 
					CodingElementGroupID,
					WorkflowStateID,
					AssignedSegmentedGroupCodingPatternID,
					SynonymListID,
					MAX(AssignedTermText),
					MIN(CodingElementId) AS CodingElementId,
					CE.QueryStatus,
					COUNT(*)
				FROM CodingElements CE
					-- SynonymList & Study
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
				GROUP BY 
					CodingElementGroupID,	-- group id
					WorkflowStateId,				-- workflow state
					AssignedSegmentedGroupCodingPatternID,
					SynonymListID,
					QueryStatus
			)
			
			INSERT INTO @CodingElementsGroupTable (
					RowNum,
					CountAll, 
					CodingElementGroupID,
					CodingElementID,
					SegmentedGroupCodingPatternID,
					CodingPatternID,
					SynonymListID,
					VerbatimTerm,
					SecondsElapsed,
					WorkflowStateId,
					
					CodingPath,
					IsValidForAutoCode,
					TermText,
					
					FilterGroupCount,
					GroupCount,
					IsGroup,
					IsInGroupExcludedByFilter,
					Priority,
					QueryStatus)
			SELECT 	Row,
					0 AS CountAll,
					X_Internal.CodingElementGroupID,
					X_Internal.CodingElementID,
					X_Internal.SegmentedGroupCodingPatternID,
					ISNULL(SGCP_CD.CodingPatternID, 0) AS CodingPatternID,
					X_Internal.SynonymListID,
					G.VerbatimText,
					CASE WHEN @TimeElapsed = 0 THEN DATEDIFF(second, XX.Created, @Today) ELSE @FilterTimeElapsed END AS SecondsElapsed,
					X_Internal.WorkflowStateID,
					
					SGCP_CD.CodingPath,
					ISNULL(SGCP_CD.IsValidForAutoCode, 0) AS IsValidForAutoCode,
					
					X_Internal.AssignedTermText,
					
					FilterCount,
					XX.GroupCount AS GroupCount,

					CASE 
						WHEN XX.GroupCount > 1 THEN 1
						ELSE 0
					END AS IsGroup,
					0,
					XX.Priority,
					QueryStatus
			FROM
			(
				SELECT
						Row,
						CodingElementGroupID,
						SegmentedGroupCodingPatternID,
						SynonymListID,
						WorkflowStateId,
						AssignedTermText,
						CodingElementId,
						FilterCount,
						QueryStatus
				FROM			
				(
					SELECT 
						ROW_NUMBER() OVER (ORDER BY AssignedTermText ASC ) AS Row, 
						SQP.CodingElementGroupID,
						SQP.SegmentedGroupCodingPatternID,
						SQP.SynonymListID,
						SQP.WorkflowStateId,
						AssignedTermText,
						SQP.CodingElementId,
						SQP.GroupCount AS FilterCount,
						SQP.QueryStatus
					FROM SQLPaging SQP
				) AS SP
				WHERE SP.Row BETWEEN @startIndex AND @endIndex
			) AS X_Internal
				CROSS APPLY
				(
					SELECT 
						GroupCount = COUNT(*),
						CASE WHEN @Priority = -1 THEN MIN(Priority) ELSE @Priority END AS Priority,
						Created = MIN(CE.Created)
					FROM CodingElements CE
					WHERE CE.CodingElementGroupID = X_Internal.CodingElementGroupID
						AND StudyDictionaryVersionId IN 
							(SELECT StudyDictionaryVersionId FROM @studyDictionaryIds
							 WHERE SynonymListID = X_Internal.SynonymListID)
						AND CE.IsClosed = 0
						AND @InService IN (-1, CE.IsStillInService)
						AND CE.WorkflowStateID = X_Internal.WorkflowStateId
						AND X_Internal.SegmentedGroupCodingPatternID = CE.AssignedSegmentedGroupCodingPatternId
						AND ((X_Internal.QueryStatus IS NULL AND CE.QueryStatus IS NULL) OR (X_Internal.QueryStatus = CE.QueryStatus))
				) AS XX
				JOIN CodingElementGroups CEG
					ON CEG.CodingElementGroupID = X_Internal.CodingElementGroupID
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
				CROSS APPLY
				( 
					SELECT TOP 1
						MAX(CodingPath) AS CodingPath,
						MAX(IsValidForAutoCode) AS IsValidForAutoCode,
						MAX(CodingPatternID) AS CodingPatternID
					FROM
					(
						SELECT
							CD.CodingPath,
							CASE WHEN SGCP.SynonymStatus = 2 THEN 1 ELSE 0 END AS IsValidForAutoCode,
							SGCP.CodingPatternID
						FROM SegmentedGroupCodingPatterns SGCP
							LEFT JOIN CodingPatterns CD
								ON CD.CodingPatternID = SGCP.CodingPatternID
						WHERE SGCP.SegmentedGroupCodingPatternID = X_Internal.SegmentedGroupCodingPatternID
							AND SGCP.Active = 1
					) AS SC_INT
				) AS SGCP_CD
				
			UNION
			SELECT -1, COUNT(*) AS CountAll,	
				-1, -1,
				-1, -1,  
				-1, '', 0, -1,
				NULL, -- CD.CodingPath
				0, 
				'', 0, 
				0, -1, 
				0, 1, -1
			FROM SQLPaging
			OPTION (RECOMPILE)
			
		END
		ELSE IF (@SortExpression = 'AssignedDictionaryTerm' AND @IsAscending = 0)
		BEGIN
		
			;WITH SQLPaging (
				CodingElementGroupID,
				WorkflowStateId,
				SegmentedGroupCodingPatternID,
				SynonymListID,
				AssignedTermText,
				CodingElementId,
				QueryStatus,
				GroupCount)
			AS
			(
				SELECT 
					CodingElementGroupID,
					WorkflowStateID,
					AssignedSegmentedGroupCodingPatternID,
					SynonymListID,
					MAX(AssignedTermText),
					MIN(CodingElementId) AS CodingElementId,
					CE.QueryStatus,
					COUNT(*)
				FROM CodingElements CE
					-- SynonymList & Study
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
				GROUP BY 
					CodingElementGroupID,	-- group id
					WorkflowStateId,				-- workflow state
					AssignedSegmentedGroupCodingPatternID,
					SynonymListID,
					QueryStatus
			)
			
			INSERT INTO @CodingElementsGroupTable (
					RowNum,
					CountAll, 
					CodingElementGroupID,
					CodingElementID,
					SegmentedGroupCodingPatternID,
					CodingPatternID,
					SynonymListID,
					VerbatimTerm,
					SecondsElapsed,
					WorkflowStateId,
					
					CodingPath,
					IsValidForAutoCode,
					TermText,
					
					FilterGroupCount,
					GroupCount,
					IsGroup,
					IsInGroupExcludedByFilter,
					Priority,
					QueryStatus)
			SELECT 	Row,
					0 AS CountAll,
					X_Internal.CodingElementGroupID,
					X_Internal.CodingElementID,
					X_Internal.SegmentedGroupCodingPatternID,
					ISNULL(SGCP_CD.CodingPatternID, 0) AS CodingPatternID,
					X_Internal.SynonymListID,
					G.VerbatimText,
					CASE WHEN @TimeElapsed = 0 THEN DATEDIFF(second, XX.Created, @Today) ELSE @FilterTimeElapsed END AS SecondsElapsed,
					X_Internal.WorkflowStateID,
					
					SGCP_CD.CodingPath,
					ISNULL(SGCP_CD.IsValidForAutoCode, 0) AS IsValidForAutoCode,
										
					X_Internal.AssignedTermText,
					
					FilterCount,
					XX.GroupCount AS GroupCount,

					CASE 
						WHEN XX.GroupCount > 1 THEN 1
						ELSE 0
					END AS IsGroup,
					0,
					XX.Priority,
					QueryStatus
			FROM
			(
				SELECT
						Row,
						CodingElementGroupID,
						SegmentedGroupCodingPatternID,
						SynonymListID,
						WorkflowStateId,
						AssignedTermText,
						CodingElementId,
						FilterCount,
						QueryStatus
				FROM			
				(
					SELECT 
						ROW_NUMBER() OVER (ORDER BY SQP.AssignedTermText DESC ) AS Row, 
						SQP.CodingElementGroupID,
						SQP.SegmentedGroupCodingPatternID,
						SQP.SynonymListID,
						SQP.WorkflowStateId,
						SQP.AssignedTermText,
						SQP.CodingElementId,
						SQP.GroupCount AS FilterCount,
						SQP.QueryStatus
					FROM SQLPaging SQP
				) AS SP
				WHERE SP.Row BETWEEN @startIndex AND @endIndex
			) AS X_Internal
				CROSS APPLY
				(
					SELECT 
						GroupCount = COUNT(*),
						CASE WHEN @Priority = -1 THEN MIN(Priority) ELSE @Priority END AS Priority,
						Created = MIN(CE.Created)
					FROM CodingElements CE
					WHERE CE.CodingElementGroupID = X_Internal.CodingElementGroupID
						AND StudyDictionaryVersionId IN 
							(SELECT StudyDictionaryVersionId FROM @studyDictionaryIds
							 WHERE SynonymListID = X_Internal.SynonymListID)
						AND CE.IsClosed = 0
						AND @InService IN (-1, CE.IsStillInService)
						AND CE.WorkflowStateID = X_Internal.WorkflowStateId
						AND X_Internal.SegmentedGroupCodingPatternID = CE.AssignedSegmentedGroupCodingPatternId
						AND ((X_Internal.QueryStatus IS NULL AND CE.QueryStatus IS NULL) OR (X_Internal.QueryStatus = CE.QueryStatus))
				) AS XX
				JOIN CodingElementGroups CEG
					ON CEG.CodingElementGroupID = X_Internal.CodingElementGroupID
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
				CROSS APPLY
				( 
					SELECT TOP 1
						MAX(CodingPath) AS CodingPath,
						MAX(IsValidForAutoCode) AS IsValidForAutoCode,
						MAX(CodingPatternID) AS CodingPatternID
					FROM
					(
						SELECT
							CD.CodingPath,
							CASE WHEN SGCP.SynonymStatus = 2 THEN 1 ELSE 0 END AS IsValidForAutoCode,
							SGCP.CodingPatternID
						FROM SegmentedGroupCodingPatterns SGCP
							LEFT JOIN CodingPatterns CD
								ON CD.CodingPatternID = SGCP.CodingPatternID
						WHERE SGCP.SegmentedGroupCodingPatternID = X_Internal.SegmentedGroupCodingPatternID
							AND SGCP.Active = 1
					) AS SC_INT
				) AS SGCP_CD
				
			UNION
			SELECT -1, COUNT(*) AS CountAll,	
				-1, -1,
				-1, -1, 
				-1, '', 0, -1,
				NULL, -- CD.CodingPath
				0, 
				'', 0, 
				0, -1, 
				0, 1, -1
			FROM SQLPaging
			OPTION (RECOMPILE)
			
		END

	END
	SELECT 	CEGT.CodingElementGroupID,
			CEGT.CodingElementID,
			CEGT.SegmentedGroupCodingPatternID,
			CEGT.CountAll,
			CEGT.SynonymListID,
			CEGT.VerbatimTerm,
			CEGT.IsGroup,
			CEGT.GroupCount,
			CEGT.FilterGroupCount,
			CEGT.IsInGroupExcludedByFilter,
			CEGT.SecondsElapsed AS ElapsedFromCreation,
			CEGT.QueryStatus,

			CEGT.CodingPatternID AS CodingPatternID,
			CEGT.CodingPath AS AssignedTermPath,
			CEGT.IsValidForAutoCode AS IsValidForAutoCode,
			
			CEGT.Priority AS BoundPriority,
			CEGT.WorkflowStateID AS WorkflowStateID,
			
			CEGT.TermText AS BoundAssignedDictionaryTerm,
			
			CEGT.RowNum
	FROM @CodingElementsGroupTable CEGT
	ORDER BY CEGT.RowNum ASC
END