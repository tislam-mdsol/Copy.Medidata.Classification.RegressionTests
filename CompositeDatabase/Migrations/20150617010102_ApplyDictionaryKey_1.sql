DECLARE @t TABLE(versionId INT PRIMARY KEY, dictionaryid INT, dictionaryOid VARCHAR(50), versionOid VARCHAR(50))

INSERT INTO @t (versionId, dictionaryid, dictionaryOid, versionOid)
EXECUTE spGetDictionaryAndVersions

UPDATE DSC
SET DSC.MedicalDictionaryKey = t.dictionaryOid
FROM DictionarySegmentConfigurations DSC
	JOIN @t t
		ON t.dictionaryid = DSC.DictionaryId

UPDATE DLI
SET DLI.MedicalDictionaryKey = t.dictionaryOid
FROM DictionaryLicenceInformations DLI
	JOIN @t t
		ON t.dictionaryid = DLI.MedicalDictionaryID

UPDATE CEG
SET CEG.MedicalDictionaryKey = t.dictionaryOid
FROM CodingElementGroups CEG
	JOIN @t t
		ON t.dictionaryid = CEG.MedicalDictionaryID

UPDATE UOR
SET		
	UOR.GrantOnObjectKey = CASE WHEN R.ModuleId = 3 THEN ISNULL(t.dictionaryOid, X.IdAsText)
								ELSE X.IdAsText
							END
FROM UserObjectRole UOR
	JOIN Roles R
		ON UOR.RoleId = R.RoleId
	LEFT JOIN @t t
		ON t.dictionaryid = UOR.GrantOnObjectId
	CROSS APPLY
	(
		SELECT IdAsText = CAST(UOR.GrantOnObjectId AS NVARCHAR(100))
	) AS X
