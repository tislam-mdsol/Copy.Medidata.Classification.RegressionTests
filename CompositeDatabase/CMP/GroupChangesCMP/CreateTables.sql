IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'VerbatimIdsEng')
	DROP TABLE VerbatimIdsEng

CREATE TABLE VerbatimIdsEng
(
	Id INT PRIMARY KEY, 
	Verbatim NVARCHAR(450), 
	TargetId INT DEFAULT (-1)
)

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'VerbatimIdsJpn')
	DROP TABLE VerbatimIdsJpn

CREATE TABLE VerbatimIdsJpn
(
	Id INT PRIMARY KEY, 
	Verbatim NVARCHAR(450), 
	TargetId INT DEFAULT (-1)
)

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AffectedGroups')
	DROP TABLE AffectedGroups

CREATE TABLE AffectedGroups
(
	Id INT PRIMARY KEY, 
	MassiveKey VARCHAR(MAX), 
	TargetId INT DEFAULT (-1),
	NumberAffected INT
)

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AffectedSynonyms')
	DROP TABLE AffectedSynonyms
CREATE TABLE AffectedSynonyms
(
	ListId INT,
	SGCPId BIGINT, 
	TargetId BIGINT DEFAULT (-1)
)

-- remove old CMP synonyms
DELETE
FROM SegmentedGroupCodingPatterns
WHERE SynonymStatus = 3

-- remove meddra_orig synonyms
DELETE SGCP
FROM SegmentedGroupCodingPatterns SGCP
	JOIN SynonymMigrationMngmt SMM
		ON SGCP.SynonymManagementID = SMM.SynonymMigrationMngmtID
WHERE MedicalDictionaryID = 1

-- remove MedDRAMedHistory_Orig synonyms
DELETE SGCP
FROM SegmentedGroupCodingPatterns SGCP
	JOIN SynonymMigrationMngmt SMM
		ON SGCP.SynonymManagementID = SMM.SynonymMigrationMngmtID
WHERE MedicalDictionaryID = 5

-- remove JDrug_Orig synonyms
DELETE SGCP
FROM SegmentedGroupCodingPatterns SGCP
	JOIN SynonymMigrationMngmt SMM
		ON SGCP.SynonymManagementID = SMM.SynonymMigrationMngmtID
WHERE MedicalDictionaryID = 12
