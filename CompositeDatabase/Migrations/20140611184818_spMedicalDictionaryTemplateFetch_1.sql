/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMedicalDictionaryTemplateFetch')
	DROP PROCEDURE dbo.spMedicalDictionaryTemplateFetch
GO
create procedure dbo.spMedicalDictionaryTemplateFetch(@TemplateId int)
as
BEGIN

	DECLARE @isReverse BIT

	declare @minLevelId int, @maxLevelId int, @minLevelOrdinal int, @maxLevelOrdinal int,
		@minTemplateLevelOrdinal int, @maxTemplateLevelOrdinal int,
		@minOrdinal int, @maxOrdinal int

	select @minTemplateLevelOrdinal = min(Ordinal), 
		@maxTemplateLevelOrdinal = max(Ordinal) 
		from MedicalDictionaryTemplateLevel where templateId=@templateId

	if(@minTemplateLevelOrdinal is null or @maxTemplateLevelOrdinal is null)
	begin
		SET @isReverse = 0
	end
	ELSE
	BEGIN

		select @minLevelId = DictionaryLevelId 
			from MedicalDictionaryTemplateLevel tl
			where templateId = @templateId and Ordinal = @minTemplateLevelOrdinal

		select @maxLevelId = DictionaryLevelId 
			from MedicalDictionaryTemplateLevel
			where templateId = @templateId and Ordinal = @maxTemplateLevelOrdinal

		select @minLevelOrdinal = Ordinal from DictionaryLevelRef where DictionaryLevelRefId = @minLevelId
		select @maxLevelOrdinal = Ordinal from DictionaryLevelRef where DictionaryLevelRefId = @maxLevelId

		if (@minLevelOrdinal < @maxLevelOrdinal) SET @isReverse = 0 -- forward hierarchy
		else SET @isReverse = 1 -- reverse hierarchy
	END

	select *, @isReverse AS IsReverseDirection
	from MedicalDictionaryTemplates 
	where TemplateId=@TemplateId


END
GO 