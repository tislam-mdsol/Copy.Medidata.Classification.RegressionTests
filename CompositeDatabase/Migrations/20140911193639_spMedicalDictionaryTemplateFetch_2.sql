IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMedicalDictionaryTemplateFetch')
	DROP PROCEDURE dbo.spMedicalDictionaryTemplateFetch
GO
create procedure dbo.spMedicalDictionaryTemplateFetch(@TemplateId int)
as
BEGIN

	select *
	from SegmentMedicalDictionaryTemplates 
	where TemplateId=@TemplateId

END
GO 