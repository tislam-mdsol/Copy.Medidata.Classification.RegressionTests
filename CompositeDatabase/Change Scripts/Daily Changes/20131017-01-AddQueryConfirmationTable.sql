IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'QueryConfirmations'))
BEGIN
		CREATE TABLE [dbo].[QueryConfirmations](
		QueryConfirmationId INT IDENTITY(1,1) NOT NULL,

		QueryHistoryId INT NOT NULL CONSTRAINT DF_QueryConfirmations_QueryHistoryId DEFAULT (0),
		SegmentId INT NOT NULL CONSTRAINT DF_QueryConfirmations_SegmentId DEFAULT (0),
		SystemActionId TINYINT NOT NULL CONSTRAINT DF_QueryConfirmations_SystemActionId DEFAULT (0),
		FailureCount INT NOT NULL CONSTRAINT DF_QueryConfirmations_FailureCount DEFAULT (0),
		Succeeded BIT NOT NULL CONSTRAINT DF_QueryConfirmations_Succeeded DEFAULT (0),

		Created DATETIME NOT NULL CONSTRAINT DF_QueryConfirmations_Created DEFAULT (GETUTCDATE()),
		Updated DATETIME NOT NULL CONSTRAINT DF_QueryConfirmations_Updated DEFAULT (GETUTCDATE())

	CONSTRAINT [PK_QueryConfirmations] PRIMARY KEY CLUSTERED 
	(
		[QueryConfirmationId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CoderQueryHistory'
			AND COLUMN_NAME = 'PriorQueryStatus')
	ALTER TABLE CoderQueryHistory
	ADD PriorQueryStatus TINYINT NOT NULL CONSTRAINT DF_CoderQueryHistory_PriorQueryStatus DEFAULT (0)
