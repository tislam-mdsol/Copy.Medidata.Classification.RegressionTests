DECLARE @IsProduction BIT
SET @IsProduction = (SELECT TOP 1 IsProduction 
					FROM CoderAppConfiguration 
					WHERE ACTIVE=1)
--production check					
IF (@IsProduction = 1)
BEGIN 
	 DECLARE @errorString NVARCHAR(MAX), @UtcDate DateTime
	 IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'DictionaryRef'))
	 BEGIN
		SET @errorString = N'ERROR DictionaryRef Table does not exist'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	 END
	 	 
	 IF (NOT EXISTS(SELECT NULL FROM dbo.DictionaryRef))
	 BEGIN
		BEGIN TRY
		BEGIN TRANSACTION
		-- Copy data from MedicalDictionary table, maintaining the same primary key
			SET IDENTITY_INSERT dbo.DictionaryRef ON

			SET @UtcDate = GetUtcDate()  
			INSERT INTO dbo.DictionaryRef (DictionaryRefID, ExternalUUID,
				OID, SupportsPrimaryPath, MedicalDictionaryType, Created, Updated)
			SELECT MedicalDictionaryId, Convert(nvarchar(50), MedicalDictionaryId),
				OID, SupportsPrimaryPath, MedicalDictionaryType, @UtcDate, @UtcDate
			FROM dbo.MedicalDictionary

			SET IDENTITY_INSERT dbo.DictionaryRef OFF

		COMMIT TRANSACTION
		
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION

			SET @errorString = N'ERROR DictionaryRef: Transaction Error Message - ' + ERROR_MESSAGE()
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
		END CATCH
	END
	
	-- DICTIONARY LEVEL TABLE
	IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'DictionaryLevelRef'))
	BEGIN
		SET @errorString = N'ERROR DictionaryLevelRef Table does not exist'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END
		
	IF (NOT EXISTS (SELECT NULL FROM dbo.DictionaryLevelRef))	
	BEGIN
		BEGIN TRY
		BEGIN TRANSACTION
		-- Copy data from MedicalDictionaryLevel table, maintaining the same primary key
			SET IDENTITY_INSERT dbo.DictionaryLevelRef ON

			SET @UtcDate = GetUtcDate()  
			INSERT INTO dbo.DictionaryLevelRef (DictionaryLevelRefID, ExternalUUID,
				OID, DictionaryRefID, Ordinal, CodingLevel, DefaultLevel, SourceOrdinal, ImageUrl,
				Created, Updated)
			SELECT DictionaryLevelId, Convert(nvarchar(50), DictionaryLevelId),
				OID, MedicalDictionaryID, Ordinal, CodingLevel, DefaultLevel, SourceOrdinal, ImageUrl,
				@UtcDate, @UtcDate
			FROM dbo.MedicalDictionaryLevel

			SET IDENTITY_INSERT dbo.DictionaryLevelRef OFF

		COMMIT TRANSACTION
		
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION

			SET @errorString = N'ERROR DictionaryLevelRef: Transaction Error Message - ' + ERROR_MESSAGE()
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
		END CATCH
	END
	
	

	-- DICTIONARY VERSION TABLE
	IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'DictionaryVersionRef'))
	BEGIN
		SET @errorString = N'ERROR DictionaryVersionRef Table does not exist'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END	
	IF (NOT EXISTS (SELECT NULL FROM dbo.DictionaryVersionRef))	
	BEGIN
		BEGIN TRY
		BEGIN TRANSACTION
			-- Copy data from MedicalDictionaryVersion table, maintaining the same primary key
			SET IDENTITY_INSERT dbo.DictionaryVersionRef ON

			SET @UtcDate = GetUtcDate()  
			INSERT INTO dbo.DictionaryVersionRef (DictionaryVersionRefID, ExternalUUID,
				OID, DictionaryRefID, Ordinal,
				Created, Updated)
			SELECT DictionaryVersionId, Convert(nvarchar(50), DictionaryVersionId),
				OID, MedicalDictionaryID, Ordinal,
				@UtcDate, @UtcDate
			FROM dbo.MedicalDictionaryVersion

			SET IDENTITY_INSERT dbo.DictionaryVersionRef OFF

		COMMIT TRANSACTION

		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION

			SET @errorString = N'ERROR DictionaryVersionRef: Transaction Error Message - ' + ERROR_MESSAGE()
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
		END CATCH
	END


	-- DICTIONARY VERSION LOCALE TABLE
	IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'DictionaryVersionLocaleRef'))
	BEGIN
		SET @errorString = N'ERROR DictionaryVersionLocaleRef Table does not exist'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END	
	IF (NOT EXISTS (SELECT NULL FROM dbo.DictionaryVersionLocaleRef))
	BEGIN
		BEGIN TRY
		BEGIN TRANSACTION
		-- Copy data from MedicalDictVerLocaleStatus table, maintaining the same primary key
			SET IDENTITY_INSERT dbo.DictionaryVersionLocaleRef ON

			SET @UtcDate = GetUtcDate()  
			INSERT INTO dbo.DictionaryVersionLocaleRef (DictionaryVersionLocaleRefID, ExternalUUID,
				DictionaryRefID, NewVersionOrdinal, OldVersionOrdinal, Locale, VersionStatus, ReleaseDate, NewVersionId, OldVersionId,
				Created, Updated)
			SELECT MedicalDictVerLocaleStatusID, Convert(nvarchar(50), MedicalDictVerLocaleStatusID),
				MedicalDictionaryID, NewVersionOrdinal, OldVersionOrdinal, Locale, VersionStatus, ReleaseDate, NewVersionId, OldVersionId,
				@UtcDate, @UtcDate
			FROM dbo.MedicalDictVerLocaleStatus

			SET IDENTITY_INSERT dbo.DictionaryVersionLocaleRef OFF

		COMMIT TRANSACTION
		
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION

			SET @errorString = N'ERROR DictionaryVersionLocaleRef Transaction Error Message - ' + ERROR_MESSAGE()
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
		END CATCH
	END
	

	-- DICTIONARY COMPONENT TYPES TABLE
	IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'DictionaryComponentTypeRef'))
	BEGIN
		SET @errorString = N'ERROR DictionaryComponentTypeRef Table does not exist'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END	
	IF (NOT EXISTS (SELECT NULL FROM dbo.DictionaryComponentTypeRef))	
	BEGIN
		BEGIN TRY
		BEGIN TRANSACTION
		-- Copy data from MedicalDictComponentTypes table, maintaining the same primary key
			SET IDENTITY_INSERT dbo.DictionaryComponentTypeRef ON

			SET @UtcDate = GetUtcDate()  
			INSERT INTO dbo.DictionaryComponentTypeRef (DictionaryComponentTypeRefID, ExternalUUID,
				OID, DictionaryRefID, Created, Updated)
			SELECT ComponentTypeID, Convert(nvarchar(50), ComponentTypeID),
				OID, MedicalDictionaryID, @UtcDate, @UtcDate
			FROM dbo.MedicalDictComponentTypes

			SET IDENTITY_INSERT dbo.DictionaryComponentTypeRef OFF

		COMMIT TRANSACTION
		
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION

			SET @errorString = N'ERROR DictionaryComponentTypeRef: Transaction Error Message - ' + ERROR_MESSAGE()
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
		END CATCH
	END

END
