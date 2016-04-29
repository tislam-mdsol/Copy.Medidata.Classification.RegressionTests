--spStudyVersionObjectLoadByDictionaryStudyBatch 10, '183', '', 'eng', 2, 1

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyVersionObjectLoadByDictionaryStudyBatch')
	DROP PROCEDURE spStudyVersionObjectLoadByDictionaryStudyBatch
GO
CREATE PROCEDURE dbo.spStudyVersionObjectLoadByDictionaryStudyBatch
(
	@MedicalDictionaryID INT,
	@StudyIDs varchar(MAX), -- List of Ids (TrackableObjects.ID)
	@BatchOID nvarchar(500), -- CodingRequests.BatchOID
	@DictLocale char(3),
	@QueryStatus TINYINT,
	@SegmentID INT
	
)
AS
BEGIN

	-- format batchID for comparison
	IF (@BatchOID IS NULL) SET @BatchOID = ''

	-- parse study ids into a table
	DECLARE @sdvTable TABLE(SdvId INT PRIMARY KEY)
	
	INSERT INTO @sdvTable
	SELECT sdv.StudyDictionaryVersionID 
	FROM dbo.fnParseDelimitedString(@StudyIDs, ',') ST
		JOIN StudyDictionaryVersion sdv
			ON ST.item = sdv.StudyID
			AND sdv.SegmentID = @SegmentID
		JOIN SynonymMigrationMngmt SMM
			ON sdv.SynonymManagementID = SMM.SynonymMigrationMngmtID
			AND SMM.Locale = @DictLocale
		JOIN DictionaryVersionRef DVR
			ON DVR.DictionaryRefID = @MedicalDictionaryID
			AND SMM.DictionaryVersionId = DVR.DictionaryVersionRefID

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
		WHERE @BatchOID = '' OR 
			EXISTS (SELECT NULL FROM CodingRequests CRQ
				WHERE CRQ.CodingRequestId = CE.CodingRequestId
					AND CRQ.BatchOID = @BatchOID) -- By Batch
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