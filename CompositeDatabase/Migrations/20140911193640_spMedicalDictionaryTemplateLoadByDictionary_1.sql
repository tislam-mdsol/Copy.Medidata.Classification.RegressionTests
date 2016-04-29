IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMedicalDictionaryTemplateLoadByDictionary')
	DROP  PROCEDURE dbo.spMedicalDictionaryTemplateLoadByDictionary
GO
CREATE PROCEDURE dbo.spMedicalDictionaryTemplateLoadByDictionary
(
	@MedicalDictionaryId int,
	@SegmentID INT
)
AS

	select * 
	from SegmentMedicalDictionaryTemplates 
	where MedicalDictionaryId=@MedicalDictionaryId
		AND SegmentID = @SegmentID
	
GO 