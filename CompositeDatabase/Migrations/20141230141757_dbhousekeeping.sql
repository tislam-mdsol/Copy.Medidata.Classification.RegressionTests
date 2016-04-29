IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'FK_ModuleActions_ActionGroup'
		 AND type = 'F')
	ALTER TABLE ModuleActions
	DROP CONSTRAINT FK_ModuleActions_ActionGroup
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ActionGroup')
	DROP TABLE ActionGroup
GO

IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'FK_ImpliedActionTypes_ActionTypeR'
		 AND type = 'F')
	ALTER TABLE ImpliedActionTypes
	DROP CONSTRAINT FK_ImpliedActionTypes_ActionTypeR
GO

IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'FK_ImpliedActionTypes_ActionTypeR1'
		 AND type = 'F')
	ALTER TABLE ImpliedActionTypes
	DROP CONSTRAINT FK_ImpliedActionTypes_ActionTypeR1
GO
IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'FK_ModuleActions_ActionTypeR'
		 AND type = 'F')
	ALTER TABLE ModuleActions
	DROP CONSTRAINT FK_ModuleActions_ActionTypeR
GO
IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ActionTypeR')
	DROP TABLE ActionTypeR
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ImpliedActionTypes')
	DROP TABLE ImpliedActionTypes
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Activations')
	DROP TABLE Activations
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ActivationStatusR')
	DROP TABLE ActivationStatusR
GO


IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AffectedGroups')
	DROP TABLE AffectedGroups
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AffectedSynonyms')
	DROP TABLE AffectedSynonyms
GO

IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'FK_Authenticators_ApiClients'
		 AND type = 'F')
	ALTER TABLE Authenticators
	DROP CONSTRAINT FK_Authenticators_ApiClients
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ApiClients')
	DROP TABLE ApiClients
GO

IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'FK_Authenticators_Segments'
		 AND type = 'F')
	ALTER TABLE Authenticators
	DROP CONSTRAINT FK_Authenticators_Segments
GO
IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'FK_Users_Authenticators'
		 AND type = 'F')
	ALTER TABLE Users
	DROP CONSTRAINT FK_Users_Authenticators
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Authenticators')
	DROP TABLE Authenticators
GO

IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'FK_AppSourceSystems_ApplicationId'
		 AND type = 'F')
	ALTER TABLE ApplicationSourceSystems
	DROP CONSTRAINT FK_AppSourceSystems_ApplicationId
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ApplicationSourceSystems')
	DROP TABLE ApplicationSourceSystems
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ApplicationR')
	DROP TABLE ApplicationR
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditTags')
	DROP TABLE AuditTags
GO
IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditDetailTypes')
	DROP TABLE AuditDetailTypes
GO
IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditTypeR')
	DROP TABLE AuditTypeR
GO

IF EXISTS 
	(SELECT NULL FROM sys.objects WHERE name = 'FK_AuditTags_AuditCategories'
		 AND type = 'F')
	ALTER TABLE AuditTags
	DROP CONSTRAINT FK_AuditTags_AuditCategories
GO
IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditCategories')
	DROP TABLE AuditCategories
GO



IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditProcesses')
	DROP TABLE AuditProcesses
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Audits')
	DROP TABLE Audits
GO

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AuditSources')
	DROP TABLE AuditSources
GO



IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationRFetch')
	DROP PROCEDURE spApplicationRFetch
GO
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationRInsert')
	DROP PROCEDURE dbo.spApplicationRInsert
GO
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationRLoadAll')
	DROP PROCEDURE dbo.spApplicationRLoadAll
GO

