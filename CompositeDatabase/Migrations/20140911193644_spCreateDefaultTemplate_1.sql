IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCreateDefaultTemplate')
	DROP PROCEDURE dbo.[spCreateDefaultTemplate]
GO

CREATE procedure [dbo].[spCreateDefaultTemplate]
(
	@segmentId int,
	@dictionaryRefId int,
	@templateName NVARCHAR(100),
	@reverseTemplateName NVARCHAR(100)
)
as
begin
	SET XACT_ABORT ON

	DECLARE @errorString NVARCHAR(4000)
	declare @templateId INT
	declare @segmentOid varchar(50), @medicalDictionaryOID varchar(50), @isDefault bit = 1
	
	declare  @reverseTemplateId INT
	
	if exists (select null from SegmentMedicalDictionaryTemplates t
		inner join Segments s on t.SegmentId = s.SegmentID 
		where s.SegmentID = @segmentId 
			and MedicalDictionaryId=@dictionaryRefId 
			and t.TokenString = @templateName) 
	begin
		select @segmentOid = OID from Segments where SegmentID = @segmentId
		select @medicalDictionaryOID = OID from DictionaryRef where DictionaryRefId=@dictionaryRefId
		PRINT N'Template: [' + @templateName + N'] already exist for Segment: [' + @segmentOid + N' and Dictionary: [' + @medicalDictionaryOID + N'] in the system.'
		RETURN
	end	
	begin transaction
	begin try
	
		-- Create Forward Template as default
		INSERT INTO [dbo].[SegmentMedicalDictionaryTemplates]([TokenString],[SegmentId],[MedicalDictionaryId],[IsDefault], IsReverse)
			VALUES(@templateName, @segmentId, @dictionaryRefId, @isDefault, 0)
		set @templateId = scope_identity()
		
		INSERT INTO [dbo].[MedicalDictionaryTemplateLevel]([TemplateId],[DictionaryLevelId],[Ordinal])
		select @templateId, l.DictionaryLevelRefID, l.Ordinal 
		from DictionaryLevelRef l
			where l.DictionaryRefID=@dictionaryRefId --and l.MandatoryLevel = 1		-- create template levels only for mandatory levels
			order by l.Ordinal
		-- Create Reverse Template
		INSERT INTO [dbo].[SegmentMedicalDictionaryTemplates]([TokenString],[SegmentId],[MedicalDictionaryId],[IsDefault], IsReverse)
		VALUES(@reverseTemplateName, @segmentId, @dictionaryRefId, 0, 1) -- not default template
		set @reverseTemplateId = scope_identity()
		
		declare @maxOrdinal int
		select @maxOrdinal = MAX(Ordinal) from DictionaryLevelRef where DictionaryRefID = @dictionaryRefId
		
		INSERT INTO [dbo].[MedicalDictionaryTemplateLevel]([TemplateId],[DictionaryLevelId],[Ordinal])
		select @reverseTemplateId, l.DictionaryLevelRefID, (@maxOrdinal - l.Ordinal + 1) 
		from DictionaryLevelRef l
			where l.DictionaryRefID=@dictionaryRefId --and l.MandatoryLevel = 1		-- create template levels only for mandatory levels
			order by l.Ordinal desc
		PRINT N'Template: [' + @templateName + ' for Segment: [' + @segmentOid + N' and Dictionary: [' + @medicalDictionaryOID + ' is being created as ID ' + CAST(@templateId AS NVARCHAR)
		PRINT N'Reverse Template: [' + @reverseTemplateName + ' for Segment: [' + @segmentOid + N' and Dictionary: [' + @medicalDictionaryOID + ' is being created as ID ' + CAST(@reverseTemplateId AS NVARCHAR)
		-- create the additional templates for MedDRA
		IF EXISTS (SELECT NULL
			FROM DictionaryRef 
			WHERE MedicalDictionaryType = 'MedDRA'
				AND DictionaryRefID = @dictionaryRefId)
			EXEC spCreateDefaultTemplateForMedDRA @segmentId, @dictionaryRefId

		commit transaction
	end try
	begin catch
		rollback transaction
		Declare	@ErrorSeverity int, 
				@ErrorState int,
				@ErrorLine int,
				@ErrorMessage nvarchar(4000),
				@ErrorProc nvarchar(4000)
		select @ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE(),
				@ErrorLine = ERROR_LINE(),
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorProc = ERROR_PROCEDURE()
		select @ErrorMessage = coalesce(@ErrorProc, 'spCreateDefaultTemplate.sql') + ' (' + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage
		raiserror (@ErrorMessage,  @ErrorSeverity, @ErrorState);
	end catch
end



GO


