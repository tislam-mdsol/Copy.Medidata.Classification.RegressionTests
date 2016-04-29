SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'AuthenticationServerTokens'))
BEGIN

	CREATE TABLE [dbo].[AuthenticationServerTokens](
		[TokenKey] [nvarchar](256) NOT NULL,
		[PlainText] [nvarchar](256) NOT NULL,
		[CipherText] [nvarchar](256) NOT NULL,
		[ApiId] [nvarchar](256) NOT NULL,
		[Created] [datetime] NOT NULL,
	 CONSTRAINT [PK_AuthenticationServerTokens] PRIMARY KEY CLUSTERED 
	(
		[TokenKey] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO
