DECLARE @t TABLE(
	versionId INT PRIMARY KEY, 
	dictionaryid INT, 
	dictionaryOid VARCHAR(50), 
	versionOid VARCHAR(50), 
	dictionaryKey NVARCHAR(100),
	dictionaryVersionKey NVARCHAR(100))

INSERT INTO @t (versionId, dictionaryid, dictionaryOid, versionOid, dictionaryKey, dictionaryVersionKey)
EXECUTE spGetDictionaryAndVersions

UPDATE DSC
SET DSC.MedicalDictionaryKey = t.dictionaryKey
FROM DictionarySegmentConfigurations DSC
	JOIN @t t
		ON t.dictionaryid = DSC.DictionaryId_Backup

UPDATE DLI
SET DLI.MedicalDictionaryKey = t.dictionaryKey
FROM DictionaryLicenceInformations DLI
	JOIN @t t
		ON t.dictionaryid = DLI.DictionaryId_Backup

UPDATE CEG
SET CEG.MedicalDictionaryKey = t.dictionaryKey
FROM CodingElementGroups CEG
	JOIN @t t
		ON t.dictionaryid = CEG.DictionaryId_Backup

UPDATE UOR
SET		
	UOR.GrantOnObjectKey = CASE WHEN R.ModuleId = 3 THEN ISNULL(t.dictionaryKey, X.IdAsText)
								ELSE X.IdAsText
							END
FROM UserObjectRole UOR
	JOIN Roles R
		ON UOR.RoleId = R.RoleId
	LEFT JOIN @t t
		ON t.dictionaryid = UOR.GrantOnObjectId_Backup
	CROSS APPLY
	(
		SELECT IdAsText = CAST(UOR.GrantOnObjectId_Backup AS NVARCHAR(100))
	) AS X
