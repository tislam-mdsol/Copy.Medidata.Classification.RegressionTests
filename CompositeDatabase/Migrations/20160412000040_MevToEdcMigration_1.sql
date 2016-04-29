
INSERT INTO EDCData(
	CodingRequestId,
	StudyUUID,
	BatchOID,
	Locale,
	Subject,
	Field,
	Form,
	VerbatimTerm,
	Event,
	Line,
	Site,
	Priority,

	RegistrationName,
	MedicalDictionaryLevelKey,
	AssignedCodingPath,
	QueryComment,
	UserUUID,
	Created,

	SupplementFieldKey0,
	SupplementFieldKey1,
	SupplementFieldKey2,
	SupplementFieldKey3,
	SupplementFieldKey4,
                    
	SupplementFieldVal0,
	SupplementFieldVal1,
	SupplementFieldVal2,
	SupplementFieldVal3,
	SupplementFieldVal4,

	AuxiliaryID,
	
	TimeStamp)

SELECT 
	CE.CodingRequestId,
	T.ExternalObjectOID,
	CE.BatchOID,
	X.ShortLocale,
	CE.SourceSubject,
	CE.SourceField,
	CE.SourceForm,
	CE.VerbatimTerm,
	CE.SourceEvent,
	CE.SourceLine,
	CE.SourceSITE,
	CE.Priority,

	SDV.RegistrationName,
	CE.MedicalDictionaryLevelKey,
	CE.AssignedCodingPath,
	CQ.QueryText,
	UserData.IMedidataId,
	CE.Created,

	ISNULL(SupplementKeys.[1], ''),
	ISNULL(SupplementKeys.[2], ''),
	ISNULL(SupplementKeys.[3], ''),
	ISNULL(SupplementKeys.[4], ''),
	ISNULL(SupplementKeys.[5], ''),
                    
	ISNULL(SupplementValues.[1], ''),
	ISNULL(SupplementValues.[2], ''),
	ISNULL(SupplementValues.[3], ''),
	ISNULL(SupplementValues.[4], ''),
	ISNULL(SupplementValues.[5], ''),

	CE.CodingElementId,
	CE.Updated

FROM CodingElements CE (NOLOCK)
    JOIN StudyDictionaryVersion SDV (NOLOCK) ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
	JOIN SynonymMigrationMngmt SMM (NOLOCK) ON SDV.SynonymManagementID = SMM.SynonymMigrationMngmtID
    JOIN TrackableObjects T (NOLOCK) ON T.TrackableObjectID = SDV.StudyID
	CROSS APPLY
	(
		SELECT LongLocale = dbo.fnGetLocaleFromDictionaryVersionLocaleKey(SMM.MedicalDictionaryVersionLocaleKey)
	) AS L
	CROSS APPLY
	(
		SELECT ShortLocale = SUBSTRING(LongLocale, 1, 3)
	) AS X
    JOIN dbo.CodingRequestCsvData CSV (NOLOCK) ON CE.CodingRequestId = CSV.CodingRequestId
	OUTER APPLY ( SELECT    TOP  1 UserId, Created
                    FROM      dbo.CodingAssignment (NOLOCK)
                    WHERE     CodingElementID = CE.CodingElementId
					ORDER BY CodingAssignmentID DESC
                ) AS CA
    OUTER APPLY ( SELECT TOP 1
                            Comment AS QueryText, UserId, Created
					FROM      CodingRejections (NOLOCK)
					WHERE     CodingElementID = CE.CodingElementId
					ORDER BY CodingRejectionID DESC
				) AS CQ
	OUTER APPLY
	(
		SELECT Login, FirstName, IMedidataId
		FROM Users
		WHERE UserID = (SELECT 
			CASE WHEN CA.UserId IS NULL THEN CQ.UserID 
			ELSE CASE WHEN CQ.UserId IS NULL THEN CA.UserID
				ELSE CASE WHEN CA.Created > CQ.Created THEN CA.UserID ELSE CQ.UserID END
				END
			END)
	) AS UserData

	CROSS APPLY
	(
		SELECT [1],[2],[3],[4],[5]
		FROM 
		(
			SELECT SupplementTermKey, Ordinal
			FROM CodingSourceTermSupplementals csts
			WHERE csts.CodingSourceTermID = ce.CodingElementId
		) AS sd
		pivot
		(
			MIN(sd.SupplementTermKey)
			FOR sd.Ordinal IN ([1],[2],[3],[4],[5])
		) AS x
	) AS SupplementKeys

	CROSS APPLY
	(
		SELECT [1],[2],[3],[4],[5]
		FROM 
		(
			SELECT SupplementalValue, Ordinal
			FROM CodingSourceTermSupplementals csts
			WHERE csts.CodingSourceTermID = ce.CodingElementId
		) AS sd
		pivot
		(
			MIN(sd.SupplementalValue)
			FOR sd.Ordinal IN ([1],[2],[3],[4],[5])
		) AS x
	) AS SupplementValues


