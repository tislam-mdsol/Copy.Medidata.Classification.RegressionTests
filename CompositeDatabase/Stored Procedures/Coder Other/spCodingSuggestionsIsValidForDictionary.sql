-- spCodingSuggestionsIsValidForDictionary 6, 10, '48971', null
if exists (select null from sysobjects where type = 'P' and name = 'spCodingSuggestionsIsValidForDictionary')
	drop procedure dbo.spCodingSuggestionsIsValidForDictionary
GO
create procedure dbo.spCodingSuggestionsIsValidForDictionary
(
	@DictionaryVersionId int,
	@CodingElementId bigint,
	@SuggestedTermIds varchar(255),
	@IsValidSuggestion bit output
)
as
begin
	declare @DictionaryId int
	select @DictionaryId=MedicalDictionaryId from MedicalDictionaryVersion where DictionaryVersionId=@DictionaryVersionId
	-- no suggestion - valid
	set @IsValidSuggestion=1

	declare @SuggestTermIdsCount int, @IsSuggestedTermExist bit
	declare @SuggestTermIds table(Id int identity(1,1), TermId NVARCHAR(50))
	insert into @SuggestTermIds(TermId) select * from dbo.fnParseDelimitedString(@SuggestedTermIds,',')
	select @SuggestTermIdsCount = count(*) from @SuggestTermIds
	if(@SuggestTermIdsCount>0 and @CodingElementId is not null) set @IsSuggestedTermExist=1
	else set @IsSuggestedTermExist=0

	if(@IsSuggestedTermExist=1) 
	begin
		if NOT EXISTS (
			SELECT null  FROM MedicalDictionaryTerm dt
				inner join MedicalDictionaryLevel dl on dl.DictionaryLevelId = dt.DictionarylevelId
				INNER JOIN @SuggestTermIds st ON st.TermId = dt.TermId
				INNER JOIN CodingSuggestions cs on cs.MedicalDictionaryTermId = dt.TermId
			WHERE cs.CodingElementId = @CodingElementId
				and dl.MedicalDictionaryId = @DictionaryId
			)
			set @IsValidSuggestion=0
	end

	select @IsValidSuggestion
	return 0;
end
GO

 