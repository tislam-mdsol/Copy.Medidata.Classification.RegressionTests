 if not exists(select null from INFORMATION_SCHEMA.TABLES where TABLE_NAME='CoderSegmentTypeR') begin

	CREATE TABLE [dbo].[CoderSegmentTypeR](
		[CoderSegmentTypeID] [int] IDENTITY(1,1) NOT NULL,
		[CoderSegmentTypeName] [varchar](500) NOT NULL,
	 CONSTRAINT [PK_CoderSegmentTypeR] PRIMARY KEY CLUSTERED 
	(
		[CoderSegmentTypeID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
	 CONSTRAINT [UQ_CoderSegmentTypeR_Name] UNIQUE NONCLUSTERED 
	(
		[CoderSegmentTypeName] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

end
GO

if not exists(select null from INFORMATION_SCHEMA.TABLES where TABLE_NAME='CoderSegments') begin

	CREATE TABLE [dbo].[CoderSegments](
		[CoderSegmentId] [int] IDENTITY(1,1) NOT NULL,
		[SegmentId] int NOT NULL,
		[CoderSegmentOID] [varchar](50) NOT NULL,
		[CoderSegmentName] [varchar](500) NOT NULL,
		[CoderSegmentTypeId] int not null,
		[Deleted] [bit] NOT NULL,
		[Active] [bit] NOT NULL,
		[Created] [datetime] NOT NULL,
		[Updated] [datetime] NOT NULL,
		CONSTRAINT [PK_CoderSegments] PRIMARY KEY CLUSTERED 
		(
			[CoderSegmentId] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
		 CONSTRAINT [UQ_CoderSegments] UNIQUE NONCLUSTERED 
		(
			[CoderSegmentOID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]


	ALTER TABLE [dbo].[CoderSegments] ADD  CONSTRAINT [DF_CoderSegments_Deleted]  DEFAULT ((0)) FOR [Deleted]

	ALTER TABLE [dbo].[CoderSegments] ADD  CONSTRAINT [DF_CoderSegments_Active]  DEFAULT ((1)) FOR [Active]

	ALTER TABLE [dbo].[CoderSegments] ADD  CONSTRAINT [DF_CoderSegments_Created]  DEFAULT (getutcdate()) FOR [Created]

	ALTER TABLE [dbo].[CoderSegments] ADD  CONSTRAINT [DF_CoderSegments_Updated]  DEFAULT (getutcdate()) FOR [Updated]

	ALTER TABLE [dbo].[CoderSegments]  WITH CHECK ADD  CONSTRAINT [FK_CoderSegments_CoderSegmentTypeR] FOREIGN KEY([CoderSegmentTypeId])
	REFERENCES [dbo].[CoderSegmentTypeR] ([CoderSegmentTypeId])

	ALTER TABLE [dbo].[CoderSegments] CHECK CONSTRAINT [FK_CoderSegments_CoderSegmentTypeR]


	ALTER TABLE [dbo].[CoderSegments]  WITH CHECK ADD  CONSTRAINT [FK_CoderSegments_Segments] FOREIGN KEY([SegmentId])
	REFERENCES [dbo].[Segments] ([SegmentId])

	ALTER TABLE [dbo].[CoderSegments] CHECK CONSTRAINT [FK_CoderSegments_Segments]

end
go
