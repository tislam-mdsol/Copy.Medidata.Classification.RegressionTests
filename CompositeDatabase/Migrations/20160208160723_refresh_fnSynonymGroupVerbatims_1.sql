IF EXISTS (SELECT * FROM sysobjects WHERE name = 'fnSynonymGroupVerbatims')
	EXEC sys.sp_refreshsqlmodule 'dbo.fnSynonymGroupVerbatims'
GO