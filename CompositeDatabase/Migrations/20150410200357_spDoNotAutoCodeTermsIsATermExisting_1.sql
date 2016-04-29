
-- AV: TODO : eval index option for this one

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeTermsIsATermExisting')
	DROP PROCEDURE spDoNotAutoCodeTermsIsATermExisting
GO
CREATE PROCEDURE dbo.spDoNotAutoCodeTermsIsATermExisting
(
	@DictionaryVersionId	INT,
	@Locale					CHAR(3),
	
	-- Term References
	@Term					NVARCHAR(500),
	
	-- Term spesific Properties
	@SegmentId				INT,
	@DictionaryLevelId		INT,
	
	-- Output parameters
	@IsExistingAndActive	BIT OUTPUT
)
AS	

BEGIN
	SELECT @IsExistingAndActive = 0

	IF EXISTS (
		SELECT NULL
		FROM [DoNotAutoCodeTerms]
		WHERE	[Locale]			  = @Locale
			AND		[SegmentId]			  = @SegmentId
			AND		[DictionaryVersionId] = @DictionaryVersionId
			AND		[Term]				  = @Term
			AND		[DictionaryLevelId]	  = @DictionaryLevelId
			AND		Active = 1
		)
		SET @IsExistingAndActive = 1

END
GO 