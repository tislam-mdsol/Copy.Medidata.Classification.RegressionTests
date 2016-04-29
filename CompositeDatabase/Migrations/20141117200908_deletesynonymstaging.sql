IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStagedSynonymInsert')
	DROP PROCEDURE spStagedSynonymInsert
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStagedSynonymLoadBySynonymList')
	DROP PROCEDURE spStagedSynonymLoadBySynonymList
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND NAME = 'spStagedSynonymResetActivation')
	DROP PROCEDURE spStagedSynonymResetActivation
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStagedSynonymUpdate')
	DROP PROCEDURE spStagedSynonymUpdate
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND NAME = 'spSynonymMigrationMngmntClearLoadedSynonyms')
	DROP PROCEDURE spSynonymMigrationMngmntClearLoadedSynonyms
GO

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'SynonymLoadStaging'))
BEGIN
DROP TABLE SynonymLoadStaging
END

