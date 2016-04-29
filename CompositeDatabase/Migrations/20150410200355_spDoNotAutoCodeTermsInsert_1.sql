IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeTermsInsert')
	DROP PROCEDURE spDoNotAutoCodeTermsInsert
GO
CREATE PROCEDURE dbo.spDoNotAutoCodeTermsInsert
(
	@DoNotAutoCodeTermId	BIGINT OUTPUT,

	@Locale					CHAR(3),
	@DictionaryVersionId	INT,
	
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
		[Locale],
		[DictionaryVersionId],
	
		[Term],
		[DictionaryLevelId],
		
		[Active],
		[UserId],
		[SegmentId],
		
		[Created],
		[Updated]
	) VALUES (  
		@Locale,
		@DictionaryVersionId,
		
		@Term,
		@DictionaryLevelId,
		
		1,
		@UserId,
		@SegmentId,
		
		@UtcDate,
		@UtcDate	
	)  
	
	SET @DoNotAutoCodeTermId = SCOPE_IDENTITY()  	

END
GO