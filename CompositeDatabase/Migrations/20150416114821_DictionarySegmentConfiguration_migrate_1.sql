
;WITH FlattenedAttributes AS
(
	SELECT OS.ObjectId, OS.SegmentId, OSA.*
	FROM ObjectSegments OS
		CROSS APPLY
		(
			SELECT 
					DefaultSelectThreshold,
					MaxNumberofSearchResults,
					CASE WHEN IsAutoAddSynonym IN ('False', 'false') THEN 0 ELSE 1 END IsAutoAddSynonym,
					CASE WHEN Active IN ('False', 'false') THEN 0 ELSE 1 END Active,
					CASE WHEN IsAutoApproval IN ('False', 'false') THEN 0 ELSE 1 END IsAutoApproval,
					DefaultSuggestThreshold
			FROM
			(
				SELECT Tag, Value
				FROM ObjectSegmentAttributes OSA
				WHERE OS.ObjectSegmentID = OSA.ObjectSegmentID
			) AS OSA
			PIVOT
			(
				MIN(OSA.Value)
				FOR OSA.Tag IN 
				(
					DefaultSelectThreshold,
					MaxNumberofSearchResults,
					IsAutoAddSynonym,
					Active,
					IsAutoApproval,
					DefaultSuggestThreshold
				)
			) AS PivotTable
		) AS OSA
	WHERE OS.ObjectTypeId = 2001
		AND OS.Deleted = 0
)
,DistinctAttributes AS
(
	SELECT 
		ObjectId, SegmentId,
		MIN(DefaultSelectThreshold) DefaultSelectThreshold,
		MIN(MaxNumberofSearchResults) MaxNumberofSearchResults,
		MIN(IsAutoAddSynonym) IsAutoAddSynonym,
		MIN(Active) Active,
		MIN(IsAutoApproval) IsAutoApproval,
		MIN(DefaultSuggestThreshold) DefaultSuggestThreshold
	FROM FlattenedAttributes
	GROUP BY ObjectId, SegmentId
)

INSERT INTO DictionarySegmentConfigurations
(
	DictionaryId,
	SegmentId,
	DefaultSelectThreshold,
	MaxNumberofSearchResults,
	IsAutoAddSynonym,
	Active,
	IsAutoApproval,
	DefaultSuggestThreshold
)
SELECT 
	ObjectId,
	SegmentId,
	DefaultSelectThreshold,
	MaxNumberofSearchResults,
	IsAutoAddSynonym,
	Active,
	IsAutoApproval,
	DefaultSuggestThreshold
FROM DistinctAttributes