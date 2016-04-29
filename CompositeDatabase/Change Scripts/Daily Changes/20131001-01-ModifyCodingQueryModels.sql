IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingQueries'
			AND COLUMN_NAME = 'CodingElementGroupId')
BEGIN
	ALTER TABLE CodingQueries
	DROP CONSTRAINT DF_CodingQueries_CodingElementGroupId
	ALTER TABLE CodingQueries
	DROP COLUMN CodingElementGroupId
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingQueries'
			AND COLUMN_NAME = 'QueryUUID')
BEGIN
	ALTER TABLE CodingQueries
	DROP CONSTRAINT DF_CodingQueries_QueryUUID
	ALTER TABLE CodingQueries
	DROP COLUMN QueryUUID
END
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingQueries'
			AND COLUMN_NAME = 'CodingElementId')
BEGIN
    ALTER TABLE CodingQueries
	DROP CONSTRAINT DF_CodingQueries_CodingElementId
	DROP INDEX CodingQueries.IX_CodingQueries_CodingElementId
	ALTER TABLE CodingQueries
	DROP COLUMN CodingElementId
END

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingQueries'
		AND COLUMN_NAME = 'QueryNote')
	ALTER TABLE CodingQueries
	DROP COLUMN QueryNote

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingQueries'
			AND COLUMN_NAME = 'QueryId')
BEGIN
	exec sp_rename 'CodingQueries.QueryId', 'QueryHistoryId', 'COLUMN'
END	

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'CodingQueries'))
BEGIN
    DROP PROCEDURE spCodingQueryFetch
    DROP PROCEDURE spCodingQueryInsert
    DROP PROCEDURE spCodingQueryUpdate
    DROP PROCEDURE spCodingQueryLoadByTask
    DROP PROCEDURE spCodingQueryGetByUUIDAndRepeatKey

	exec sp_rename 'CodingQueries', 'CoderQueryHistory'
	exec sp_rename 'PK_CodingQueries', 'PK_CoderQueryHistory', N'OBJECT'
	exec sp_rename 'DF_CodingQueries_DateTimeStamp', 'DF_CoderQueryHistory_DateTimeStamp', N'OBJECT'
	exec sp_rename 'DF_CodingQueries_QueryRepeatKey', 'DF_CoderQueryHistory_QueryRepeatKey', N'OBJECT'
	exec sp_rename 'DF_CodingQueries_UserRef', 'DF_CoderQueryHistory_UserRef', N'OBJECT'
	exec sp_rename 'DF_CodingQueries_QueryStatus', 'DF_CoderQueryHistory_QueryStatus', N'OBJECT'
	exec sp_rename 'DF_CodingQueries_Created', 'DF_CoderQueryHistory_Created', N'OBJECT'
	
END

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CoderQueryHistory'
			AND COLUMN_NAME = 'QueryId')
	ALTER TABLE CoderQueryHistory
	ADD QueryId INT NOT NULL CONSTRAINT DF_CoderQueryHistory_QueryId DEFAULT (-1)

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'CoderQueries'))
BEGIN
		CREATE TABLE [dbo].[CoderQueries](
		QueryId INT IDENTITY(1,1) NOT NULL,
		CodingElementId INT NOT NULL CONSTRAINT DF_CoderQueries_CodingElementId DEFAULT (-1),
		CodingElementGroupId INT NOT NULL CONSTRAINT DF_CoderQueries_CodingElementGroupId DEFAULT (-1),
		QueryUUID NVARCHAR(50) NOT NULL CONSTRAINT DF_CoderQueries_QueryUUID DEFAULT (N''),
		QueryText NVARCHAR(1800),
		CodingContextURI NVARCHAR(4000) NOT NULL CONSTRAINT DF_CoderQueries_CodingContextURI DEFAULT (N''),
		CancelURI NVARCHAR(4000),
		CancelVerb NVARCHAR(10),
		Created DATETIME NOT NULL CONSTRAINT DF_CoderQueries_Created DEFAULT (GETUTCDATE()),
		Updated DATETIME NOT NULL CONSTRAINT DF_CoderQueries_Updated DEFAULT (GETUTCDATE())

	CONSTRAINT [PK_CoderQueries] PRIMARY KEY CLUSTERED 
	(
		[QueryId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CoderQueries_CodingElementId')
BEGIN
	CREATE NONCLUSTERED INDEX [IX_CoderQueries_CodingElementId] ON [dbo].[CoderQueries] 
	(
		[CodingElementId] ASC
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO