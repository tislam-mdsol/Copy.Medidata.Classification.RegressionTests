IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementSearchForUnload')
	DROP PROCEDURE spCodingElementSearchForUnload
GO
CREATE PROCEDURE dbo.spCodingElementSearchForUnload
(
	@MedicalDictionaryID int,
	@DictLocale char(3),
	@StudyID bigint, -- TrackableObjects.ID
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
			DictionaryVersionId INT,
			CodingPathVersionId INT,
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
		StudyID, 
		VerbatimTerm,
		DictionaryVersionId, 
		CodingPathVersionId,
		DictionaryLevelId, 
		DictionaryLocale,
		WorkflowStateID,
		CodingPath, 
		Code, 
		Term,
		RowNumber
	) AS (
		SELECT E.CodingElementId, 
			 E.CodingRequestId,
			 SDV.StudyID,
			 E.VerbatimTerm,
			 SMM.DictionaryVersionId,
			 AllAssignments.CodingPathVersionId,
			 E.DictionaryLevelId,
			 @DictLocale,
	 		 E.WorkflowStateID,
			 E.AssignedCodingPath,
			 E.AssignedTermCode,
			 E.AssignedTermText,
			 ROW_NUMBER() OVER(ORDER BY
				E.CodingElementId
			)
		FROM CodingElements E
			JOIN StudyDictionaryVersion SDV
				ON E.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
				AND SDV.StudyID = @StudyID
				AND E.SegmentId = @SegmentID
			JOIN SynonymMigrationMngmt SMM
				ON SMM.SynonymMigrationMngmtID = SDV.SynonymManagementID
				AND SMM.Locale = @DictLocale
			JOIN DictionaryVersionRef DVR
				ON DVR.DictionaryVersionRefID = SMM.DictionaryVersionId
				AND DVR.DictionaryRefID = @MedicalDictionaryID
			-- Rejections
			LEFT JOIN CodingRejections CRJ 
				ON CRJ.CodingElementID = E.CodingElementId 
		    CROSS APPLY
		    (
		        SELECT ISNULL(MAX(SMM.DictionaryVersionId), -1) AS CodingPathVersionId
		        FROM SegmentedGroupCodingPatterns SGCP
					JOIN SynonymMigrationMngmt SMM
						ON SGCP.SynonymManagementID = SMM.SynonymMigrationMngmtID
						AND SGCP.SegmentedGroupCodingPatternID = E.AssignedSegmentedGroupCodingPatternId
		        WHERE E.AssignedSegmentedGroupCodingPatternId > 0
		    )AS AllAssignments
		WHERE
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

	INSERT INTO @tempTable
		(
		CodingElementId, 
		StudyID, 
		VerbatimTerm,
		DictionaryVersionId,
		CodingPathVersionId,
		DictionaryLevelId, 
		WorkflowStateID, 
		CodingRequestId,
		Code, 
		Term,
		CodingPath,
		DictionaryLocale,
		TotalRowCount
		)
	SELECT 
		CodingElementId, 
		StudyID, 
		VerbatimTerm,
		DictionaryVersionId,
		CodingPathVersionId,
		DictionaryLevelId, 
		WorkflowStateID, 
		CodingRequestId,
		Code, 
		Term,
		CodingPath,
		DictionaryLocale,
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
		T.ExternalObjectOID AS StudyOID, 
		VerbatimTerm,
		DictionaryVersionId,
		CodingPathVersionId,
		DLR.OID AS DictionaryLevelOID,
		WorkflowStateID AS CurrentWorkflowStateID,
		CRQ.BatchOID,
		Code, Term,
		CodingPath,
		DictionaryLocale,
		DVR.Ordinal
	FROM
	(
		SELECT 
			CodingElementId, 
			StudyID, 
			VerbatimTerm,
			DictionaryVersionId,
			CodingPathVersionId,
			DictionaryLevelId, 
			WorkflowStateID, 
			CodingRequestId,
			Code, 
			Term,
			CodingPath,
			DictionaryLocale
		FROM @tempTable
	) AS XI
		join TrackableObjects T on T.TrackableObjectID = XI.StudyID
		join DictionaryLevelRef DLR on DLR.DictionaryLevelRefID = XI.DictionaryLevelId
		join DictionaryVersionRef DVR 
			ON DVR.DictionaryVersionRefID = XI.DictionaryVersionId
		JOIN CoderLocaleAddlInfo CLAI
			ON CLAI.Locale = DictionaryLocale
		JOIN CodingRequests CRQ 
			ON CRQ.CodingRequestId = XI.CodingRequestId
		
END


GO  
