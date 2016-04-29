/**
** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami avardhami@mdsol.com
**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingElementLoadAllForBOTByRule')
	DROP PROCEDURE dbo.spCodingElementLoadAllForBOTByRule
GO

CREATE PROCEDURE [dbo].spCodingElementLoadAllForBOTByRule
(
	@SegmentedGroupCodingPatternID BIGINT,
	@CodingElementGroupID BIGINT,
	@SynonymManagementID INT,
	@LastID BIGINT,
	@manualCodeStateId INT,
	@waitingApprovalStateId INT,
	@isAutoCodeVariableId INT,
	@isAutoApprovalVariableId INT
)
AS
BEGIN

	DECLARE @minID BIGINT = @LastID

	DECLARE @studyDictionaryVersionIDs TABLE (Id INT PRIMARY KEY)
	
	INSERT INTO @studyDictionaryVersionIDs
	SELECT StudyDictionaryVersionId
	FROM StudyDictionaryVersion SDV
	-- NOTE: ignore locked studies
	WHERE SDV.StudyLock = 1
		AND SDV.SynonymManagementID = @SynonymManagementID

	DECLARE @Ids TABLE(CodingElementId INT PRIMARY KEY,
		IsManualCodeState BIT, IsWaitingApprovalState BIT)
	DECLARE @OKIds TABLE(CodingElementId INT PRIMARY KEY)
	
	WHILE (1 = 1)
	BEGIN
	
		DELETE @Ids
		DELETE @OKIds

		INSERT INTO @Ids (CodingElementId, IsManualCodeState, IsWaitingApprovalState)		
		SELECT CE.CodingElementId,
			CASE WHEN CE.WorkflowStateID = @manualCodeStateId THEN 1 ELSE 0 END,
			CASE WHEN CE.WorkflowStateID = @waitingApprovalStateId THEN 1 ELSE 0 END
		FROM 
		(
			SELECT TOP(100) CodingElementId, WorkflowStateID
			FROM CodingElements
			WHERE @CodingElementGroupID = CodingElementGroupID
				AND IsInvalidTask = 0
				AND IsCompleted = 0
				AND AssignedSegmentedGroupCodingPatternID IN (-1, @SegmentedGroupCodingPatternID)
				AND CodingElementId > @minID
				AND StudyDictionaryVersionId IN (SELECT Id FROM @studyDictionaryVersionIDs)
			ORDER BY CodingElementId ASC
		) AS CE
		
		-- 1a. find the waiting manual code with autocode enabled
		INSERT INTO @OKIds(CodingElementId)
		SELECT I.CodingElementId 
		FROM @Ids I
			JOIN WorkflowTaskData WTD
				ON WTD.WorkflowTaskID = I.CodingElementId
				AND WTD.WorkflowVariableID = @isAutoCodeVariableId
				AND WTD.Data = 'True'
		WHERE I.IsManualCodeState = 1
		-- 1b. get the waiting approval with autoapprove enabled
		UNION
		SELECT I.CodingElementId 
		FROM @Ids I
			JOIN WorkflowTaskData WTD
				ON WTD.WorkflowTaskID = I.CodingElementId
				AND WTD.WorkflowVariableID = @isAutoApprovalVariableId
				AND WTD.Data = 'True'
		WHERE I.IsWaitingApprovalState = 1
				
		IF NOT EXISTS (SELECT NULL FROM @Ids)
			OR EXISTS (SELECT NULL FROM @OKIds)
			BREAK
			
		SELECT @minID = MAX(CodingElementId)
		FROM @Ids
		
	END
		
	SELECT CE.*
	FROM CodingElements CE
		JOIN @OKIds O
			ON CE.CodingElementId = O.CodingElementId

END
GO
  