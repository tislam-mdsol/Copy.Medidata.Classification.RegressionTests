﻿IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeTermsInsert')
	DROP PROCEDURE spDoNotAutoCodeTermsInsert
GO
CREATE PROCEDURE dbo.spDoNotAutoCodeTermsInsert
(
	@DoNotAutoCodeTermId	BIGINT OUTPUT,

	@MedicalDictionaryVersionLocaleKey NVARCHAR(100),
	
	-- Term References
	@Term					NVARCHAR(500),
	@DictionaryLevelId		INT,
	
	-- Term spesific Properties
	@UserId					INT,
	@SegmentId				INT,
	@Created				DATETIME OUTPUT,  
	@Updated				DATETIME OUTPUT
)
AS	

BEGIN
	DECLARE @UtcDate DATETIME  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
	-- 2. It is a new term, then insert a new row into the table.
	INSERT INTO [DoNotAutoCodeTerms] (  
		MedicalDictionaryVersionLocaleKey,
	
		[Term],
		[DictionaryLevelId],
		
		[Active],
		[UserId],
		[SegmentId],
		
		[Created],
		[Updated],

		-- TODO : remove
		DictionaryVersionId_Backup,
		DictionaryLocale_Backup
	) VALUES (  
		@MedicalDictionaryVersionLocaleKey,
		
		@Term,
		@DictionaryLevelId,
		
		1,
		@UserId,
		@SegmentId,
		
		@UtcDate,
		@UtcDate,
		
		0, ''	
	)  
	
	SET @DoNotAutoCodeTermId = SCOPE_IDENTITY()  	

END
GO