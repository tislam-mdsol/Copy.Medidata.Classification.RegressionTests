 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spReportUCodeCandidateTermPaths')
	DROP PROCEDURE spReportUCodeCandidateTermPaths
GO
 
 CREATE PROCEDURE [dbo].[spReportUCodeCandidateTermPaths]
(
	@DictionaryVersionID INT,
	@StudyID BIGINT, -- value of -1 indicates ALL Studies
	@Locale CHAR(3), 
	@SegmentID int,
	@PageSize INT,
	@LastStreamingID INT,
	@SortColumnName VARCHAR(40)
)
AS
	
BEGIN
-- Report terms that have been coded to U-Code.
-- Note: this report is currently only supported for English locale.
	IF (ISNULL (@LastStreamingID, -1) < 0 OR ISNULL(@PageSize,0) <= 0) 
		RETURN
	DECLARE @errorString NVARCHAR(400) 
	IF(@SortColumnName <> 'CodingElementId')
	BEGIN
		SET @errorString = N'Error. Sorting columns other than CodingElementId is not supported.'
		RAISERROR(@errorString, 16, 1)
		RETURN	 
	END

	-- get coding decisions
	;WITH decisionsCTE (CodingElementId, StudyName, VerbatimTerm, CodingPath) 
	AS (
		SELECT CE.CodingElementId, STUDY.ExternalObjectName, CE.VerbatimTerm, CE.AssignedCodingPath
		FROM CodingElements CE
			JOIN StudyDictionaryVersion SDV 
				ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
				AND (@StudyId = -1 OR SDV.StudyID = @StudyId)
				AND SDV.SynonymManagementID IN (SELECT SMM.SynonymMigrationMngmtID
					FROM SynonymMigrationMngmt SMM
					WHERE SMM.DictionaryVersionId = @DictionaryVersionID
						AND SMM.SegmentId = SDV.SegmentId
						AND SMM.Locale = @Locale)
			INNER JOIN TrackableObjects STUDY ON STUDY.TrackableObjectId = SDV.StudyID
			INNER JOIN SegmentedGroupCodingPatterns SGCP ON SGCP.SegmentedGroupCodingPatternID = CE.AssignedSegmentedGroupCodingPatternId
			INNER JOIN CodingPatterns CP ON CP.CodingPatternID = SGCP.CodingPatternID
			LEFT JOIN CodingRejections REJ ON REJ.CodingElementID = CE.CodingElementId
		WHERE
			CE.SegmentId = @SegmentID 
			AND SGCP.Active = 1
			AND CE.IsInvalidTask = 0
			AND REJ.CodingRejectionID IS NULL 
	)

	-- join with u-code dictionary terms
	SELECT TOP(@PageSize)
	    CodingElementId,
	    decisionsCTE.StudyName AS 'Study', 
		decisionsCTE.VerbatimTerm,
		decisionsCTE.CodingPath
	FROM decisionsCTE 
	WHERE 
		CodingElementId > @LastStreamingID
	ORDER BY CodingElementId ASC

END


GO