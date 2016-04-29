IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyVersionObjectLoadByDictionaryStudy')
	DROP PROCEDURE spStudyVersionObjectLoadByDictionaryStudy
GO
CREATE PROCEDURE dbo.spStudyVersionObjectLoadByDictionaryStudy
(
	@StudyVersionIDs varchar(MAX), -- List of Ids (StudyDictionaryVersion.ID)
	@QueryStatus TINYINT,
	@SegmentID INT
)
AS
BEGIN

	-- parse study ids into a table
	DECLARE @sdvTable TABLE(SdvId INT PRIMARY KEY)
	
	INSERT INTO @sdvTable
	SELECT sdv.StudyDictionaryVersionID 
	FROM dbo.fnParseDelimitedString(@StudyVersionIDs, ',') ST
		JOIN StudyDictionaryVersion sdv
			ON ST.item = sdv.StudyDictionaryVersionId
			AND sdv.SegmentID = @SegmentID

	;WITH xCTE(StudyDictionaryVersionID, Completed, CodedButNotCompleted, NotCoded, [OpenQuery])
	AS
	(
		SELECT 
			sdv.SdvId,
			SUM(CASE 
				WHEN CE.IsClosed = 1 AND CE.IsInvalidTask=0 AND CR.CodingRejectionID IS NULL THEN 1 
				ELSE 0
			END),
			SUM(CASE 
				WHEN CE.IsClosed = 0
					AND CE.AssignedSegmentedGroupCodingPatternId > 0
				THEN 1 
				ELSE 0
			END),
			SUM(CASE 
				WHEN CE.IsClosed = 0
					AND CE.AssignedSegmentedGroupCodingPatternId < 1 THEN 1 
				ELSE 0
			END),
			---TBD: do we still need to persist to coding rejection table after-QM
			SUM(CASE
				WHEN  (CR.CodingRejectionID IS NOT NULL AND CE.IsClosed = 1 AND CE.IsInvalidTask= 1)
				OR
				CE.QueryStatus = @QueryStatus
				THEN 1 
				ELSE 0
			END)
		FROM @sdvTable SDV
			JOIN CodingElements CE
			WITH (NOLOCK)
				ON sdv.SdvId = CE.StudyDictionaryVersionID
				AND CE.SegmentId = @SegmentID
			-- Rejections
			LEFT JOIN CodingRejections CR
			WITH (NOLOCK)
				ON CR.CodingElementID = CE.CodingElementId
		GROUP BY sdv.SdvId
	)
	
	SELECT 
		sdv.*,
		CAST(Completed AS VARCHAR) AS Completed,
		CAST(CodedButNotCompleted AS VARCHAR) AS CodedButNotCompleted,
		CAST(NotCoded AS VARCHAR) AS NotCoded,
		CAST([OpenQuery] AS VARCHAR) AS [OpenQuery]
	FROM StudyDictionaryVersion sdv
		JOIN xCTE
			ON xCTE.StudyDictionaryVersionID = sdv.StudyDictionaryVersionID

END

GO