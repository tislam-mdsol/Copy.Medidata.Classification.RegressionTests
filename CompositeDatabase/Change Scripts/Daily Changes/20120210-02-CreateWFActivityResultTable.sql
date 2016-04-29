IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'WorkflowActivityResult'))
BEGIN
	CREATE TABLE [dbo].[WorkflowActivityResult](	
		[WorkflowActivityResultID] [bigint] IDENTITY(1,1) NOT NULL,	
		[SegmentID] [int] NOT NULL,
		[UserID] [int] NOT NULL,
		[WorkflowActionID] [int] NOT NULL,
		[WorkflowTaskID] [int] NOT NULL,
		[ResultMessage] [nvarchar](512) NULL,
		[IsTaskChangePersisted] [bit] NOT NULL,
		[Created] [datetime] NOT NULL,
		[Updated] [datetime] NOT NULL		
	 CONSTRAINT [PK_WorkflowActivityResult] PRIMARY KEY CLUSTERED 
	(
		[WorkflowActivityResultID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO
