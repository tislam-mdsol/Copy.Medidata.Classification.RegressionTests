    IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentVersionLoadWaitingSubscription')
	DROP PROCEDURE spSegmentVersionLoadWaitingSubscription

    IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spObjectSegmentLoadMissingSubscription')
	DROP PROCEDURE spObjectSegmentLoadMissingSubscription
	
	IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMedicalDictionaryTemplateDelete')
	DROP PROCEDURE dbo.spMedicalDictionaryTemplateDelete

	IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMedicalDictionaryTemplateFetch')
	DROP PROCEDURE dbo.spMedicalDictionaryTemplateFetch

	IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMedicalDictionaryTemplateInsert')
	DROP PROCEDURE dbo.spMedicalDictionaryTemplateInsert

	IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMedicalDictionaryTemplateLoadAll')
	DROP PROCEDURE dbo.spMedicalDictionaryTemplateLoadAll

	IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMedicalDictionaryTemplateUpdate')
	DROP PROCEDURE dbo.spMedicalDictionaryTemplateUpdate

	IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'MedicalDictionaryTemplates'))
	BEGIN
	ALTER TABLE MedicalDictionaryTemplateLevel DROP CONSTRAINT FK_MedicalDictionaryTemplateLevels_TemplateId
	DROP TABLE MedicalDictionaryTemplates
	END
