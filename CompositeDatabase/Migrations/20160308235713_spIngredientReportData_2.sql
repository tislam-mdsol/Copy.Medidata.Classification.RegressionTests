IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spIngredientReportData')
	DROP PROCEDURE spIngredientReportData
GO

 -- spIngredientReportData 695, 12, 1, 8, 8, 7,'eng'
 CREATE PROCEDURE [dbo].spIngredientReportData
(
	@StudyDictionaryVersionID INT,
	@PageSize INT,
	@LastStreamingID INT
)
AS
BEGIN
	
	-- verify paging data
	IF(ISNULL (@LastStreamingID, -1) < 0
	OR ISNULL(@PageSize,0) <= 0)
	BEGIN
		RETURN
	END
	
	-- Report terms ingredients

	-- get coding decisions
	;WITH decisionsCTE (CodingElementId, VerbatimTerm, CodingPath, SourceSite, SourceSubject) 
	AS (
		SELECT CE.CodingElementId, CE.VerbatimTerm, CE.AssignedCodingPath,
            CE.SourceSite, CE.SourceSubject
		FROM CodingElements CE
			JOIN SegmentedGroupCodingPatterns SGCP ON SGCP.SegmentedGroupCodingPatternID = CE.AssignedSegmentedGroupCodingPatternId
			JOIN CodingPatterns CP ON CP.CodingPatternID = SGCP.CodingPatternID
			LEFT JOIN CodingRejections REJ ON REJ.CodingElementID = CE.CodingElementId
		WHERE
			CE.StudyDictionaryVersionID = @StudyDictionaryVersionID
			AND CE.AssignedSegmentedGroupCodingPatternId > 0
			AND CE.IsInvalidTask = 0
			AND REJ.CodingRejectionID IS NULL 
	)

	SELECT TOP(@PageSize)
		decisionsCTE.CodingElementId,
		decisionsCTE.VerbatimTerm,
		decisionsCTE.CodingPath,
		decisionsCTE.SourceSubject AS SubjectValue,
		decisionsCTE.SourceSite AS SiteValue,
		SUPPLS.Value AS SupplementalData
	FROM decisionsCTE 
		CROSS APPLY
		(
			SELECT ISNULL(SupplementTermKey, '') +';'+ISNULL(SupplementalValue, '')+'|'-- AS [text()] 
			FROM CodingSourceTermSupplementals
			WHERE CodingSourceTermID = decisionsCTE.CodingElementId
			ORDER BY SupplementTermKey
			FOR XML PATH('')
		) SUPPLS (Value)
	WHERE
		decisionsCTE.CodingElementId > @LastStreamingID
	ORDER BY decisionsCTE.CodingElementId ASC
	OPTION (RECOMPILE)	
		


END
GO