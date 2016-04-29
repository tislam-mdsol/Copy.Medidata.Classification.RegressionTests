DECLARE @nonMigratedVersions TABLE(VersionId INT PRIMARY KEY)
INSERT INTO @nonMigratedVersions
VALUES  (	1	),
		(	2	),
		(	3	),
		(	4	),
		(	5	),
		(	6	),
		(	7	),
		(	8	),
		(	9	),
		(	10	),
		(	11	),
		(	66	),
		(	67	),
		(	68	),
		(	69	),
		(	70	),
		(	71	),
		(	72	),
		(	73	),
		(	74	),
		(	75	),
		(	76	),
		(	102	),
		(	107	),
		(	161	),
		(	162	),
		(	163	),
		(	314	),
		(	316	),
		(	317	)


DELETE sms
FROM SynonymMigrationSuggestions sms
	JOIN SynonymMigrationEntries sme
		ON sme.SynonymMigrationEntryID = sms.SynonymMigrationEntryID
	JOIN SynonymMigrationMngmt smm
		ON sme.SynonymMigrationMngmtID = smm.SynonymMigrationMngmtID
	JOIN @nonMigratedVersions nmv
		ON smm.DictionaryVersionId = nmv.VersionId

DELETE sme
FROM SynonymMigrationEntries sme
	JOIN SynonymMigrationMngmt smm
		ON sme.SynonymMigrationMngmtID = smm.SynonymMigrationMngmtID
	JOIN @nonMigratedVersions nmv
		ON smm.DictionaryVersionId = nmv.VersionId

DELETE smm
FROM SynonymMigrationMngmt smm
	JOIN @nonMigratedVersions nmv
		ON smm.DictionaryVersionId = nmv.VersionId

DELETE DictionaryLicenceInformations
WHERE MedicalDictionaryID IN (1, 5, 12)

DELETE dvs
FROM DictionaryVersionSubscriptions dvs
	JOIN @nonMigratedVersions nmv
		ON dvs.DictionaryVersionId = nmv.VersionId

-- remove zombie tasks
-- these are all invalid
DECLARE @nonMigratedLevels TABLE(LevelId INT PRIMARY KEY)
INSERT INTO @nonMigratedLevels
VALUES  (	1	),
		(	2	),
		(	3	),
		(	4	),
		(	5	),
		(	18	),
		(	19	),
		(	20	),
		(	21	),
		(	22	),
		(	36	),
		(	37	),
		(	38	),
		(	39	),
		(	40	),
		(	41	),
		(	42	),
		(	43	)

DECLARE @zombieTasks TABLE(Id INT PRIMARY KEY)

INSERT INTO @zombieTasks
SELECT ce.CodingElementId
FROM CodingElements ce
	JOIN @nonMigratedLevels nml
		ON ce.DictionaryLevelId = nml.LevelId

DELETE ca
FROM CodingAssignment ca
	JOIN @zombieTasks ce
		ON ca.CodingElementId = ce.Id

DELETE wth
FROM WorkflowTaskHistory wth
	JOIN @zombieTasks ce
		ON wth.WorkflowTaskId = ce.Id

DELETE x
FROM CodingElements x
	JOIN @zombieTasks ce
		ON x.CodingElementId = ce.Id
