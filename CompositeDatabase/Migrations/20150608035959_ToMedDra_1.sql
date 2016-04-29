-- GIVEN MedDraMedHistory - migrate to MedDra
DECLARE @versionCorrespondence TABLE(MedDraId INT, MedHistoryId INT)
DECLARE @levelCorrespondence TABLE(MedDraId INT, MedHistoryId INT)
DECLARE @medDraDictionaryId INT = 26
DECLARE @medHistoryDictionaryId INT = 28

DECLARE @t TABLE(versionId INT PRIMARY KEY, dictionaryid INT, dictionaryOid VARCHAR(50), versionOid VARCHAR(50))

INSERT INTO @t (versionId, dictionaryid, dictionaryOid, versionOid)
EXECUTE spGetDictionaryAndVersions

INSERT INTO @versionCorrespondence(MedDraId, MedHistoryId)
SELECT MedDra.versionId, MedHistory.versionId
FROM
	(
		SELECT *
		FROM @t
		WHERE dictionaryid = @medDraDictionaryId
	) AS MedDra
		JOIN
		(
			SELECT *
			FROM @t
			WHERE dictionaryid = @medHistoryDictionaryId
		) AS MedHistory
		ON MedDra.versionOid = MedHistory.versionOid

INSERT INTO @levelCorrespondence(MedDraId, MedHistoryId)
VALUES 
(	77	,	90	),
(	78	,	91	),
(	79	,	92	),
(	80	,	93	),
(	81	,	94	)

-- [ In place update ]
-- 1. synonymLists (versionIds)
-- 2. codingelements.DictionaryLevelId

UPDATE SMM
SET SMM.DictionaryVersionId = VC.MedDraId,
	SMM.ListName = SMM.ListName + N'_MH' -- Needed to discriminate the old meddra lists vs meddramedhistory lists with the same name
FROM SynonymMigrationMngmt SMM
	JOIN @versionCorrespondence VC
		ON SMM.DictionaryVersionId = VC.MedHistoryId

UPDATE CE
SET CE.DictionaryLevelId = LC.MedDraId
FROM CodingElements CE
	JOIN @levelCorrespondence LC
		ON CE.DictionaryLevelId = LC.MedHistoryId

-- [ Merge both Dictionary data into one ]
-- 3. DictionaryLicenceInformations.DictionaryId
-- 4. DictionaryVersionSubscription.DictionaryVersion
-- 5. DoNotAutoCodeTerms.DictionaryVersion+DictionaryLevelId
-- 6. DictionarySegmentConfigurations.DictionaryId

-- remove existing
;WITH duplicateLicences AS
(
 SELECT DLI_MedHistory.DictionaryLicenceInformationID, DLI_MedDra.DictionaryLicenceInformationID AS MedDraId
 FROM DictionaryLicenceInformations DLI_MedHistory
	JOIN DictionaryLicenceInformations DLI_MedDra
		ON DLI_MedHistory.SegmentID            = DLI_MedDra.SegmentID
		AND DLI_MedHistory.MedicalDictionaryID = @medHistoryDictionaryId
		AND DLI_MedDra.MedicalDictionaryID     = @medDraDictionaryId
		AND DLI_MedHistory.DictionaryLocale    = DLI_MedDra.DictionaryLocale
		AND DLI_MedHistory.StartLicenceDate    = DLI_MedDra.StartLicenceDate
		AND DLI_MedHistory.EndLicenceDate      = DLI_MedDra.EndLicenceDate
 WHERE DLI_MedHistory.Deleted = 0
	AND DLI_MedDra.Deleted = 0
)

UPDATE DVS
SET DVS.Deleted = 1
FROM DictionaryVersionSubscriptions DVS
	JOIN duplicateLicences dl
		ON DVS.DictionaryLicenceInformationId = dl.DictionaryLicenceInformationID

UPDATE DLI_MedHistory
SET DLI_MedHistory.Deleted = 1
FROM DictionaryLicenceInformations DLI_MedHistory
	JOIN DictionaryLicenceInformations DLI_MedDra
		ON DLI_MedHistory.SegmentID            = DLI_MedDra.SegmentID
		AND DLI_MedHistory.MedicalDictionaryID = @medHistoryDictionaryId
		AND DLI_MedDra.MedicalDictionaryID     = @medDraDictionaryId
		AND DLI_MedHistory.DictionaryLocale    = DLI_MedDra.DictionaryLocale
		AND DLI_MedHistory.StartLicenceDate    = DLI_MedDra.StartLicenceDate
		AND DLI_MedHistory.EndLicenceDate      = DLI_MedDra.EndLicenceDate
 WHERE DLI_MedHistory.Deleted = 0
	AND DLI_MedDra.Deleted = 0

-- update others
;WITH duplicateLicences AS
(
	SELECT DLI_MedHistory.DictionaryLicenceInformationID
	FROM DictionaryLicenceInformations DLI_MedHistory
	WHERE DLI_MedHistory.MedicalDictionaryID = @medHistoryDictionaryId
)

UPDATE DVS
SET DVS.DictionaryVersionId = VC.MedDraId
FROM DictionaryVersionSubscriptions DVS
	JOIN duplicateLicences dl
		ON DVS.DictionaryLicenceInformationId = dl.DictionaryLicenceInformationID
	JOIN @versionCorrespondence VC
		ON DVS.DictionaryVersionId = VC.MedHistoryId

UPDATE DLI_MedHistory
SET DLI_MedHistory.MedicalDictionaryID = @medDraDictionaryId
FROM DictionaryLicenceInformations DLI_MedHistory
WHERE DLI_MedHistory.MedicalDictionaryID = @medHistoryDictionaryId

DELETE DA_MedHistory
FROM DoNotAutoCodeTerms DA_MedHistory
	JOIN @versionCorrespondence VC
		ON DA_MedHistory.DictionaryVersionId = VC.MedHistoryId
	JOIN @levelCorrespondence LC
		ON DA_MedHistory.DictionaryLevelId   = LC.MedHistoryId
	JOIN DoNotAutoCodeTerms DA_MedDra
		ON DA_MedHistory.SegmentID           = DA_MedDra.SegmentID
		AND DA_MedDra.DictionaryVersionId    = VC.MedDraId
		AND DA_MedHistory.Locale             = DA_MedDra.Locale
		AND DA_MedDra.DictionaryLevelId      = LC.MedDraId
		AND DA_MedDra.Term                   = DA_MedHistory.Term

UPDATE DA_MedHistory
SET DA_MedHistory.DictionaryVersionId = VC.MedDraId,
	DA_MedHistory.DictionaryLevelId = LC.MedDraId
FROM DoNotAutoCodeTerms DA_MedHistory
	JOIN @versionCorrespondence VC
		ON DA_MedHistory.DictionaryVersionId = VC.MedHistoryId
	JOIN @levelCorrespondence LC
		ON DA_MedHistory.DictionaryLevelId = LC.MedHistoryId

DELETE DSC_MedHistory
FROM DictionarySegmentConfigurations DSC_MedHistory
	JOIN DictionarySegmentConfigurations DSC_MedDra
		ON DSC_MedHistory.SegmentID = DSC_MedDra.SegmentID
WHERE DSC_MedHistory.DictionaryId = @medHistoryDictionaryId
	AND DSC_MedDra.DictionaryId = @medDraDictionaryId

UPDATE DSC_MedHistory
SET DSC_MedHistory.DictionaryId = @medDraDictionaryId
FROM DictionarySegmentConfigurations DSC_MedHistory
WHERE DSC_MedHistory.DictionaryId = @medHistoryDictionaryId

