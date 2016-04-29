
DECLARE @errorString NVARCHAR(MAX)

-- DICTIONARY TABLE
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'DictionaryRef'))
BEGIN
		-- Create client db reference table
		CREATE TABLE [dbo].[DictionaryRef](	
			[DictionaryRefID] [int] IDENTITY(1,1) NOT NULL,	
			[ExternalUUID] [nvarchar](50) NOT NULL,
			[OID] [varchar](50) NOT NULL,
			[SupportsPrimaryPath] [bit] NOT NULL,
			[MedicalDictionaryType] [varchar](50) NULL, -- allow nulls
			[Created] [datetime] NOT NULL,
			[Updated] [datetime] NOT NULL
		CONSTRAINT [PK_DictionaryRef] PRIMARY KEY CLUSTERED 
		(
			[DictionaryRefID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
END		


-- DICTIONARY LEVEL TABLE
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'DictionaryLevelRef'))
BEGIN
		-- Create client db reference table
		CREATE TABLE [dbo].[DictionaryLevelRef](	
			[DictionaryLevelRefID] [int] IDENTITY(1,1) NOT NULL,	
			[ExternalUUID] [nvarchar](50) NOT NULL,
			[OID] [varchar](50) NOT NULL,
			[DictionaryRefID] [int] NOT NULL,
			[Ordinal] [int] NOT NULL,
			[CodingLevel] [bit] NOT NULL,
			[DefaultLevel] [bit] NOT NULL,
			[SourceOrdinal] [int] NOT NULL,
			[ImageUrl] [varchar](50) NULL,
			[Created] [datetime] NOT NULL,
			[Updated] [datetime] NOT NULL
		CONSTRAINT [PK_DictionaryLevelRef] PRIMARY KEY CLUSTERED 
		(
			[DictionaryLevelRefID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
END


-- DICTIONARY VERSION TABLE
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'DictionaryVersionRef'))
BEGIN
		-- Create client db reference table
		CREATE TABLE [dbo].[DictionaryVersionRef](	
			[DictionaryVersionRefID] [int] IDENTITY(1,1) NOT NULL,	
			[ExternalUUID] [nvarchar](50) NOT NULL,
			[OID] [varchar](50) NOT NULL,
			[DictionaryRefID] [int] NOT NULL,
			[Ordinal] [int] NOT NULL,
			[Created] [datetime] NOT NULL,
			[Updated] [datetime] NOT NULL			
		CONSTRAINT [PK_DictionaryVersionRef] PRIMARY KEY CLUSTERED 
		(
			[DictionaryVersionRefID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
END


-- DICTIONARY VERSION LOCALE TABLE
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'DictionaryVersionLocaleRef'))
BEGIN
		-- Create client db reference table
		CREATE TABLE [dbo].[DictionaryVersionLocaleRef](	
			[DictionaryVersionLocaleRefID] [int] IDENTITY(1,1) NOT NULL,	
			[ExternalUUID] [nvarchar](50) NOT NULL,
			[DictionaryRefID] [int] NOT NULL,		
			[NewVersionOrdinal] [int] NOT NULL,
			[OldVersionOrdinal] [int] NULL,
			[Locale] [char](3) NOT NULL,
			[VersionStatus] [int] NOT NULL,
			[ReleaseDate] [datetime] NOT NULL,
			[NewVersionId] [int] NOT NULL,
			[OldVersionId] [int] NOT NULL,			
			[Created] [datetime] NOT NULL,
			[Updated] [datetime] NOT NULL			
		CONSTRAINT [PK_DictionaryVersionLocaleRef] PRIMARY KEY CLUSTERED 
		(
			[DictionaryVersionLocaleRefID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
END


-- To maintain permissions and subscriptions with existing dictionary tables,
-- ObjectTypeID is reused for DictionaryRef and DictionaryVersionLocaleRef.
-- Solves ObjectTypeID reference problems in the following tables:
-- 1) dbo.UserObjectRole (General Role permission assignments to dictionary)
-- 2) dbo.ObjectSegment (subscriptions to dictionary)
-- 3) dbo.ModulesR (Security Module)
BEGIN TRY
BEGIN TRANSACTION

	IF EXISTS (SELECT NULL FROM sys.foreign_keys 
	   WHERE object_id = OBJECT_ID(N'dbo.FK_ModulesR_ObjectTypeR')
			AND parent_object_id = OBJECT_ID(N'dbo.ModulesR'))
	BEGIN
		PRINT 'Drop FK_ModulesR_ObjectTypeR'
		ALTER TABLE dbo.ModulesR DROP CONSTRAINT FK_ModulesR_ObjectTypeR
	END

	IF (NOT EXISTS (SELECT NULL FROM dbo.ObjectTypeR
		WHERE ObjectTypeID = 2001 AND HostTableName = 'DictionaryRef'))
	BEGIN
		PRINT 'Remove MedicalDictionary from ObjectTypeR'
		DELETE FROM dbo.ObjectTypeR WHERE ObjectTypeID = 2001
	END

	IF (NOT EXISTS (SELECT NULL FROM dbo.ObjectTypeR
		WHERE ObjectTypeID = 2002 AND HostTableName = 'DictionaryVersionLocaleRef'))
	BEGIN
		PRINT 'Remove MedicalDictionaryVersionLocale from ObjectTypeR'
		DELETE FROM dbo.ObjectTypeR WHERE ObjectTypeID = 2002
	END

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION

	SET @errorString = N'ERROR Removing ObjectTypeR rows Transaction Error Message - ' + ERROR_MESSAGE()
	PRINT @errorString
	RAISERROR(@errorString, 16, 1)
END CATCH

