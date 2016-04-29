/** 
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami [avardhami@mdsol.com]
**
**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spStudyTaskHistoryAudit')
	DROP PROCEDURE dbo.spStudyTaskHistoryAudit
GO

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
	@LastStreamingID INT,
	@SortColumnName VARCHAR(40)
)
AS
BEGIN

	IF (ISNULL (@LastStreamingID, -1) < 0 OR ISNULL(@PageSize,0) <= 0) 
		RETURN
    DECLARE @errorString NVARCHAR(400) 
	IF(@SortColumnName <> 'CodingElementId')
	BEGIN
		SET @errorString = N'Error. Sorting columns other than CodingElementId is not supported.'
		RAISERROR(@errorString, 16, 1)
		RETURN	 
	END
		
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

	;WITH SearchQueryCTE
	AS
	(
		SELECT TOP(@PageSize)
			CE.CodingElementId,
			CE.UUID,
			SourceSubject AS SubjectKey,
			VerbatimTerm,
			CodingRequestID,
			SourceField AS ItemOID,
			SourceForm AS FormOID,
			CA.IsAutoCoded
		FROM CodingElements CE
			LEFT JOIN CodingAssignment CA 
				ON CE.CodingElementId = CA.CodingElementID
				AND CA.Active =1
		WHERE CE.StudyDictionaryVersionId = @studyDictionaryVersionId
			AND CE.CodingElementId > @LastStreamingID
			AND CE.SegmentId = @SegmentID
			-- current state check
			AND EXISTS (SELECT NULL FROM @currentWorkflowStateTable WHERE Id IN (-1, WorkflowStateID) )
			AND (@Verbatim = '' OR VerbatimTerm LIKE '%' + @Verbatim + '%')
			AND @Code IN ('', AssignedTermCode)
			AND @Term IN ('', AssignedTermText)
			AND ( CA.IsAutoCoded in (0, @IncludeAutoCodedItems) OR CA.CodingAssignmentID IS NULL )
		ORDER BY CE.CodingElementId ASC
	 )
	 
	 SELECT
		E.CodingElementId,
		E.UUID,
		SubjectKey,
		VerbatimTerm,
		APP.Name AS SourceSystemName,
		ItemOID,
		CR.FileOID,
		FormOID,
		CR.ReferenceNumber,
		WorkflowTaskHistoryId,
		WTH.CodingElementGroupId,
		WTH.QueryId,

		WTH.WorkflowStateID,
		ISNULL(WTH.WorkflowActionID, 0) AS WorkflowActionID,
		ISNULL(WTH.WorkflowSystemActionID, 0) AS WorkflowSystemActionID,

		UH.Login AS UserLogin,
		Comment,
		WTH.Created,
		CP.CodingPath,
		ISNULL(CA.DictionaryVersionId, 0) AS CodingPathVersionId,
		E.IsAutoCoded
	 FROM SearchQueryCTE E
		-- NOTE: this sproc performance may vary slightly if lengthy histories
		CROSS APPLY
		( 
			SELECT *
			FROM WorkflowTaskHistory
			WHERE WorkflowTaskID = E.CodingElementId
				-- dates check
				AND Created BETWEEN @WorkflowActionStartDate AND @WorkflowActionEndDate
				-- user check
				AND EXISTS (SELECT NULL FROM @userIDTable WHERE Id IN (-1, UserID) )
		) AS WTH
		CROSS APPLY
		(
			SELECT FileOID,
				ReferenceNumber,
				SourceSystemID
			FROM CodingRequests CRI
			WHERE CRI.CodingRequestID = E.CodingRequestID
		) AS CR
		JOIN Application APP
			ON APP.SourceSystemID = CR.SourceSystemID
		LEFT JOIN CodingAssignment CA
			ON CA.CodingAssignmentID = WTH.CodingAssignmentId
		LEFT JOIN SegmentedGroupCodingPatterns SGCP
			ON SGCP.SegmentedGroupCodingPatternID = CA.SegmentedGroupCodingPatternID
		LEFT JOIN CodingPatterns CP
			ON CP.CodingPatternID = SGCP.CodingPatternID
		LEFT JOIN Users UH
			ON UH.UserID = WTH.UserID
	 OPTION (RECOMPILE)
	
END
GO

SET NOCOUNT OFF
GO