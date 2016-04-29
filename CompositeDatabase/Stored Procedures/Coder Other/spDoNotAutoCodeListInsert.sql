IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeListInsert')
	DROP PROCEDURE spDoNotAutoCodeListInsert
GO
CREATE PROCEDURE dbo.spDoNotAutoCodeListInsert
(
	@ListId	INT OUTPUT,
	@MedicalDictionaryVersionLocaleKey NVARCHAR(100),	
	@ListName				NVARCHAR(200),
	@SegmentId				INT,
	@Created				DATETIME OUTPUT
)
AS	
BEGIN

	SELECT @Created = GetUtcDate() 
	
	-- 2. It is a new term, then insert a new row into the table.
	INSERT INTO [DoNotAutoCodeLists] (  
		MedicalDictionaryVersionLocaleKey,
		ListName,
		[SegmentId],
		[Created]
	) VALUES (  
		@MedicalDictionaryVersionLocaleKey,
        @ListName,
		@SegmentId,
		@Created
	)  
	
	SET @ListId = SCOPE_IDENTITY()  	

END
GO