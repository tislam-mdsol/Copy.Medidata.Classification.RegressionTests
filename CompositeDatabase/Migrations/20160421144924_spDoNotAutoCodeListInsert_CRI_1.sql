IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeListInsert_CRI')
	DROP PROCEDURE spDoNotAutoCodeListInsert_CRI
GO
CREATE PROCEDURE dbo.spDoNotAutoCodeListInsert_CRI
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
	
	--from http://stackoverflow.com/questions/3407857/only-inserting-a-row-if-its-not-already-there
	INSERT INTO DoNotAutoCodeLists 
	SELECT
		@MedicalDictionaryVersionLocaleKey,
		@ListName,
		@SegmentId,
		@Created
	 WHERE
		NOT EXISTS
		(SELECT NULL FROM DoNotAutoCodeLists WITH (UPDLOCK, HOLDLOCK)
		WHERE MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey
		AND ListName = @ListName
		And SegmentId = @SegmentId)
	 
	 SELECT @ListId = dnal.ListId
		, @Created = dnal.Created
	 FROM DoNotAutoCodeLists as dnal
	 WHERE MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey
		AND ListName = @ListName
		And SegmentId = @SegmentId
	
END
GO