IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementSearchForUnload')
	DROP PROCEDURE spCodingElementSearchForUnload
GO
CREATE PROCEDURE dbo.spCodingElementSearchForUnload
(
	@StudyContextId int,
	@CodedState nvarchar(50), -- { Completed, CodedButNotCompleted, NotCoded, Rejected }
	@PageIndex int,
	@PageSize int, --value set in object layer
	@SegmentID int,
	@LastStreamingID INT,
	@SortColumnName VARCHAR(40),
	@QueryStatus TINYINT,
	@TotalRowCount INT OUTPUT
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @errorString NVARCHAR(400) 

	IF(@SortColumnName <> 'CodingElementId')
	BEGIN
		SET @errorString = N'Error. Sorting columns other than CodingElementId is not supported.'
		RAISERROR(@errorString, 16, 1)
		RETURN	 
	END

	DECLARE @startRowNumber int

	IF (@PageIndex >= 0)
		SET @startRowNumber = (@PageIndex * @PageSize) + 1
	ELSE
		SET @startRowNumber = 1

	DECLARE @tempTable TABLE(CodingElementId INT, 
			StudyID INT, 
			VerbatimTerm NVARCHAR(450),
			MedicalDictionaryLevelKey NVARCHAR(100),
			CodingPathVersionKey NVARCHAR(100),
			DictionaryLevelId INT, 
			WorkflowStateID INT, 
			CodingRequestId INT,
			Code VARCHAR(50), 
			Term NVARCHAR(450),
			CodingPath VARCHAR(450),
			DictionaryLocale CHAR(3),
			TotalRowCount INT)
	
	
	;WITH searchQueryCTE (
		CodingElementId, 
		CodingRequestId, 
		VerbatimTerm,
		CodingPathVersionKey,
		MedicalDictionaryLevelKey, 
		WorkflowStateID,
		CodingPath, 
		Code, 
		Term,
		RowNumber
	) AS (
		SELECT E.CodingElementId, 
			 E.CodingRequestId,
			 E.VerbatimTerm,
			 AllAssignments.CodingPathVersionKey,
			 E.MedicalDictionaryLevelKey,
	 		 E.WorkflowStateID,
			 E.AssignedCodingPath,
			 E.AssignedTermCode,
			 E.AssignedTermText,
			 ROW_NUMBER() OVER(ORDER BY
				E.CodingElementId
			)
		FROM CodingElements E
			-- Rejections
			LEFT JOIN CodingRejections CRJ 
				ON CRJ.CodingElementID = E.CodingElementId 
		    CROSS APPLY
		    (
		        SELECT ISNULL(MAX(SMM.MedicalDictionaryVersionLocaleKey), '') AS CodingPathVersionKey
		        FROM SegmentedGroupCodingPatterns SGCP
					JOIN SynonymMigrationMngmt SMM
						ON SGCP.SynonymManagementID = SMM.SynonymMigrationMngmtID
						AND SGCP.SegmentedGroupCodingPatternID = E.AssignedSegmentedGroupCodingPatternId
		        WHERE E.AssignedSegmentedGroupCodingPatternId > 0
		    )AS AllAssignments
		WHERE E.StudyDictionaryVersionId = @StudyContextId AND
			(
				( @CodedState = 'OpenQuery' 
					And
				  ((CRJ.CodingRejectionID IS NOT NULL AND E.IsClosed = 1 AND E.IsInvalidTask= 1)
					OR
					E.QueryStatus = @QueryStatus )
				) 
				OR   
				@CodedState = -- determine the category based on workflow state
				CASE
					WHEN E.IsClosed = 1 AND E.IsInvalidTask =0
						AND CRJ.CodingRejectionID IS NULL THEN 'Completed'
					WHEN E.IsClosed = 0
						AND E.AssignedSegmentedGroupCodingPatternId > 0 THEN 'CodedButNotCompleted'
					WHEN E.IsClosed = 0
						AND E.AssignedSegmentedGroupCodingPatternId < 1 THEN 'NotCoded'
					ELSE NULL
				END
			)
	)

	INSERT INTO @tempTable
		(
		CodingElementId, 
		VerbatimTerm,
		CodingPathVersionKey,
		MedicalDictionaryLevelKey, 
		WorkflowStateID, 
		CodingRequestId,
		Code, 
		Term,
		CodingPath,
		TotalRowCount
		)
	SELECT 
		CodingElementId, 
		VerbatimTerm,
		CodingPathVersionKey,
		MedicalDictionaryLevelKey, 
		WorkflowStateID, 
		CodingRequestId,
		Code, 
		Term,
		CodingPath,
		(SELECT COUNT(*) FROM searchQueryCTE) as TotalRowCount
	FROM searchQueryCTE
	WHERE 
		RowNumber >= @startRowNumber
		AND 
		CodingElementId > @LastStreamingID

	SELECT @TotalRowCount = MAX(TotalRowCount)
	FROM @tempTable
	
	SELECT TOP (@PageSize)
		CodingElementId,
		VerbatimTerm,
		CodingPathVersionKey,
		MedicalDictionaryLevelKey,
		WorkflowStateID AS CurrentWorkflowStateID,
		CRQ.BatchOID,
		Code, 
		Term,
		CodingPath
	FROM
	(
		SELECT 
			CodingElementId, 
			VerbatimTerm,
			CodingPathVersionKey,
			MedicalDictionaryLevelKey, 
			WorkflowStateID, 
			CodingRequestId,
			Code, 
			Term,
			CodingPath
		FROM @tempTable
	) AS XI
		JOIN CodingRequests CRQ 
			ON CRQ.CodingRequestId = XI.CodingRequestId
		
END


GO  
