IF EXISTS (SELECT null FROM sys.tables WHERE name='MedicalDictionaryTemplateLevels')
EXEC sp_rename 'dbo.MedicalDictionaryTemplateLevels', 'MedicalDictionaryTemplateLevel'; 