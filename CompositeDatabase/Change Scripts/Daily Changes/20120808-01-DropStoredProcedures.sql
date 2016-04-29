IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrationMngmntGetPrimaryByVersion')
	DROP PROCEDURE dbo.spSynonymMigrationMngmntGetPrimaryByVersion
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrationMgmntBySegmentDictLocale')
	DROP PROCEDURE dbo.spSynonymMigrationMgmntBySegmentDictLocale
GO

IF EXISTS (select null from sysobjects where type = 'P' and name = 'spMedicalDictionarySearchMultiIngredient')
	DROP PROCEDURE dbo.spMedicalDictionarySearchMultiIngredient
GO
