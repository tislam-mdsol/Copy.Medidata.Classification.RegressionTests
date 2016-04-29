
DECLARE @errorString NVARCHAR(MAX), @UtcDate DateTime

-- DICTIONARY COMPONENT TYPES TABLE
IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'DictionaryComponentTypeRef'))
BEGIN
		-- Create client db reference table
		CREATE TABLE [dbo].[DictionaryComponentTypeRef](	
			[DictionaryComponentTypeRefID] [int] IDENTITY(1,1) NOT NULL,	
			[ExternalUUID] [nvarchar](50) NOT NULL,
			[OID] [varchar](50) NOT NULL,
			[DictionaryRefID] [int] NOT NULL,
			[Created] [datetime] NOT NULL,
			[Updated] [datetime] NOT NULL
		CONSTRAINT [PK_DictionaryComponentTypeRef] PRIMARY KEY CLUSTERED 
		(
			[DictionaryComponentTypeRefID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
END
