SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'ApplicationType'))
BEGIN
	/****** Object:  Table [dbo].[ApplicationType]    Script Date: 09/01/2010 11:32:35 ******/
	CREATE TABLE [dbo].[ApplicationType](
		[ApplicationTypeID] [int] IDENTITY(1,1) NOT NULL,
		[IMedidataId] [nvarchar](50) NOT NULL,
		[Name] [nvarchar](256) NOT NULL,
		[IsCoderAppType] [bit] NOT NULL,
		[Active] [bit] NOT NULL,
		[Deleted] [bit] NOT NULL,
		[Created] [datetime] NOT NULL,
		[Updated] [datetime] NOT NULL,
	 CONSTRAINT [PK_ApplicationType] PRIMARY KEY CLUSTERED 
	(
		[ApplicationTypeID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'Application'))
BEGIN
	/****** Object:  Table [dbo].[Application]    Script Date: 08/20/2010 11:41:49 ******/
	CREATE TABLE [dbo].[Application](
		[ApplicationID] [int] IDENTITY(1,1) NOT NULL,
		[ApiID] [nvarchar](256) NOT NULL,
		[Name] [nvarchar](256) NOT NULL,
		[BaseUrl] [nvarchar](2000) NOT NULL,
		[PublicKey] [nvarchar](500) NOT NULL,
		[ApplicationTypeID] [int] NOT NULL,
		[Active] [bit] NOT NULL,
		[Deleted] [bit] NOT NULL,
		[Created] [datetime] NOT NULL,
		[Updated] [datetime] NOT NULL,
	 CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED 
	(
		[ApplicationID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[Application]  WITH CHECK ADD  CONSTRAINT [FK_Application_ApplicationType] FOREIGN KEY([ApplicationTypeID])
	REFERENCES [dbo].[ApplicationType] ([ApplicationTypeID])

END
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'ApplicationTrackableObject'))
BEGIN
	/****** Object:  Table [dbo].[ApplicationTrackableObject]    Script Date: 08/20/2010 11:42:03 ******/
	CREATE TABLE [dbo].[ApplicationTrackableObject](
		[ApplicationTrackableObjectID] [bigint] IDENTITY(1,1) NOT NULL,
		[ApplicationID] [int] NOT NULL,
		[TrackableObjectID] [bigint] NOT NULL,
		[Status] [nvarchar](256) NOT NULL,
		[Active] [bit] NOT NULL,
		[Deleted] [bit] NOT NULL,
		[Created] [datetime] NOT NULL,
		[Updated] [datetime] NOT NULL,
	 CONSTRAINT [PK_ApplicationTrackableObject] PRIMARY KEY CLUSTERED 
	(
		[ApplicationTrackableObjectID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[ApplicationTrackableObject]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationTrackableObject_Application] FOREIGN KEY([ApplicationID])
	REFERENCES [dbo].[Application] ([ApplicationID])

	ALTER TABLE [dbo].[ApplicationTrackableObject] CHECK CONSTRAINT [FK_ApplicationTrackableObject_Application]

	ALTER TABLE [dbo].[ApplicationTrackableObject]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationTrackableObject_TrackableObjects] FOREIGN KEY([TrackableObjectID])
	REFERENCES [dbo].[TrackableObjects] ([TrackableObjectID])

	ALTER TABLE [dbo].[ApplicationTrackableObject] CHECK CONSTRAINT [FK_ApplicationTrackableObject_TrackableObjects]
END
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'ApplicationAdmin'))
BEGIN
	/****** Object:  Table [dbo].[ApplicationAdmin]    Script Date: 08/20/2010 11:44:46 ******/
	CREATE TABLE [dbo].[ApplicationAdmin](
		[ApplicationAdminID] [int] IDENTITY(1,1) NOT NULL,
		[ApplicationID] [int] NOT NULL,
		[IsCoderApp] [bit] NOT NULL,
		[Active] [bit] NOT NULL,
		[Deleted] [bit] NOT NULL,
		IsCronEnabled BIT NOT NULL,
		[Created] [datetime] NOT NULL,
		[Updated] [datetime] NOT NULL,
	 CONSTRAINT [PK_ApplicationAdmin] PRIMARY KEY CLUSTERED 
	(
		[ApplicationAdminID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[ApplicationAdmin]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationAdmin_Application] FOREIGN KEY([ApplicationID])
	REFERENCES [dbo].[Application] ([ApplicationID])

	ALTER TABLE [dbo].[ApplicationAdmin] CHECK CONSTRAINT [FK_ApplicationAdmin_Application]
END
GO
