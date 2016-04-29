IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionarySegmentConfigurations'
		 AND COLUMN_NAME = 'DictionaryId')
BEGIN

	EXEC sys.sp_rename 
		@objname = N'dbo.DictionarySegmentConfigurations.DictionaryId', 
		@newname = 'DictionaryId_Backup', 
		@objtype = 'COLUMN'

END

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DictionaryLicenceInformations'
		 AND COLUMN_NAME = 'MedicalDictionaryID')
BEGIN

	EXEC sys.sp_rename 
		@objname = N'dbo.DictionaryLicenceInformations.MedicalDictionaryID', 
		@newname = 'DictionaryId_Backup', 
		@objtype = 'COLUMN'

END

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElementGroups'
		 AND COLUMN_NAME = 'MedicalDictionaryID')
BEGIN

	EXEC sys.sp_rename 
		@objname = N'dbo.CodingElementGroups.MedicalDictionaryID', 
		@newname = 'DictionaryId_Backup', 
		@objtype = 'COLUMN'

END

IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserObjectRole'
		 AND COLUMN_NAME = 'GrantOnObjectId')
BEGIN

	EXEC sys.sp_rename 
		@objname = N'dbo.UserObjectRole.GrantOnObjectId', 
		@newname = 'GrantOnObjectId_Backup', 
		@objtype = 'COLUMN'

END