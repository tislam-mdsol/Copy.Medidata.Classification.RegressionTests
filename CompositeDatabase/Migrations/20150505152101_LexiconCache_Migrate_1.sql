BEGIN TRY
BEGIN TRANSACTION

	-- CodingElement
	UPDATE X
	SET X.DictionaryLevelId = CAST(Y.ExternalUUID AS INT)
	FROM CodingElements X
		JOIN DictionaryLevelRef Y
			ON X.DictionaryLevelId = Y.DictionaryLevelRefID

	-- CodingSourceTermComponents
	UPDATE X
	SET X.ComponentTypeId = CAST(Y.ExternalUUID AS INT)
	FROM CodingSourceTermComponents X
		JOIN DictionaryComponentTypeRef Y
			ON X.ComponentTypeId = Y.DictionaryComponentTypeRefID

	--CodingElementGroups
	UPDATE X
	SET X.DictionaryLevelId = CAST(Y1.ExternalUUID AS INT),
		X.MedicalDictionaryID = CAST(Y2.ExternalUUID AS INT)
	FROM CodingElementGroups X
		JOIN DictionaryLevelRef Y1
			ON X.DictionaryLevelId = Y1.DictionaryLevelRefID
		JOIN DictionaryRef Y2
			ON X.MedicalDictionaryId = Y2.DictionaryRefId

	--CodingElementGroupComponents
	UPDATE X
	SET X.ComponentTypeId = CAST(Y.ExternalUUID AS INT)
	FROM CodingElementGroupComponents X
		JOIN DictionaryComponentTypeRef Y
			ON X.ComponentTypeId = Y.DictionaryComponentTypeRefID
	WHERE X.IsSupplement = 0

	--DoNotAutoCodeTerms
	UPDATE X
	SET X.DictionaryLevelID = CAST(Y1.ExternalUUID AS INT),
		X.DictionaryVersionId = CAST(Y2.ExternalUUID AS INT)
	FROM DoNotAutoCodeTerms X
		JOIN DictionaryLevelRef Y1
			ON X.DictionaryLevelID = Y1.DictionaryLevelRefID
		JOIN DictionaryVersionRef Y2
			ON X.DictionaryVersionId = Y2.DictionaryVersionRefID

	-- UserObjectRole
	UPDATE X
	SET X.GrantOnObjectId = CAST(Y.ExternalUUID AS INT)
	FROM UserObjectRole X
		JOIN Roles R
			ON R.RoleId = X.RoleID
		JOIN DictionaryRef Y
			ON X.GrantOnObjectId = Y.DictionaryRefID
	WHERE R.ModuleId = 3

	-- CodingPatterns
	UPDATE X
	SET X.DictionaryLevelID = CAST(Y.ExternalUUID AS INT)
	FROM CodingPatterns X
		JOIN DictionaryLevelRef Y
			ON X.DictionaryLevelID = Y.DictionaryLevelRefID

	--SynonymMigrationMngmt
	UPDATE X
	SET X.DictionaryVersionId = CAST(Y.ExternalUUID AS INT)
	FROM SynonymMigrationMngmt X
		JOIN DictionaryVersionRef Y
			ON X.DictionaryVersionId = Y.DictionaryVersionRefID

	--SynonymMigrationMngmt
	UPDATE X
	SET X.DictionaryVersionId = CAST(Y.ExternalUUID AS INT)
	FROM DictionaryVersionSubscriptions X
		JOIN DictionaryVersionRef Y
			ON X.DictionaryVersionId = Y.DictionaryVersionRefID

	-- MedicalDictionaryTemplateLevel
	UPDATE X
	SET X.DictionaryLevelID = CAST(Y.ExternalUUID AS INT)
	FROM MedicalDictionaryTemplateLevel X
		JOIN DictionaryLevelRef Y
			ON X.DictionaryLevelID = Y.DictionaryLevelRefID

	-- DictionarySegmentConfigurations
	UPDATE X
	SET X.DictionaryId = CAST(Y.ExternalUUID AS INT)
	FROM DictionarySegmentConfigurations X
		JOIN DictionaryRef Y
			ON X.DictionaryId = Y.DictionaryRefId

	-- DictionaryLicenceInformations
	UPDATE X
	SET X.MedicalDictionaryID = CAST(Y.ExternalUUID AS INT)
	FROM DictionaryLicenceInformations X
		JOIN DictionaryRef Y
			ON X.MedicalDictionaryID = Y.DictionaryRefId

	UPDATE X
	SET X.MedicalDictionaryId = CAST(Y.ExternalUUID AS INT)
	FROM SegmentMedicalDictionaryTemplates X
		JOIN DictionaryRef Y
			ON X.MedicalDictionaryId = Y.DictionaryRefID

	-- Rename THE *Ref tables (cleanup defered)

	EXEC sp_rename 'DictionaryRef', 'DictionaryRef_Backup'
	EXEC sp_rename 'DictionaryVersionRef', 'DictionaryVersionRef_Backup'
	EXEC sp_rename 'DictionaryLevelRef', 'DictionaryLevelRef_Backup'
	EXEC sp_rename 'DictionaryComponentTypeRef', 'DictionaryComponentTypeRef_Backup'
	EXEC sp_rename 'DictionaryVersionLocaleRef', 'DictionaryVersionLocaleRef_Backup'
	EXEC sp_rename 'DictionaryVersionDiffDepth', 'DictionaryVersionDiffDepth_Backup'

	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION

	DECLARE @errorString NVARCHAR(1000) = N'ERROR Lexicon Cache reduction transaction Error Message - ' + ERROR_MESSAGE()
	PRINT @errorString
	RAISERROR(@errorString, 16, 1)
END CATCH