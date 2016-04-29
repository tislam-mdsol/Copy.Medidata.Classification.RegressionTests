 IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'ParentPath' AND DATA_TYPE = 'varchar')
BEGIN
	ALTER TABLE [dbo].[SynonymLoadStaging] 
	DROP CONSTRAINT [DF_SynonymLoadStaging_ParentPath]

	ALTER TABLE [dbo].[SynonymLoadStaging]
	ALTER COLUMN ParentPath NVARCHAR(500) NOT NULL

	ALTER TABLE [dbo].[SynonymLoadStaging] 
	ADD  CONSTRAINT [DF_SynonymLoadStaging_ParentPath]  DEFAULT ('') FOR [ParentPath]
END
GO  

 IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'Components' AND DATA_TYPE = 'varchar')
BEGIN
	ALTER TABLE [dbo].[SynonymLoadStaging] 
	ALTER COLUMN Components NVARCHAR(MAX)
END
GO  

 IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SynonymLoadStaging'
		 AND COLUMN_NAME = 'Supplements' AND DATA_TYPE = 'varchar')
BEGIN
	ALTER TABLE [dbo].[SynonymLoadStaging]
	ALTER COLUMN Supplements NVARCHAR(MAX)
END
GO  

  