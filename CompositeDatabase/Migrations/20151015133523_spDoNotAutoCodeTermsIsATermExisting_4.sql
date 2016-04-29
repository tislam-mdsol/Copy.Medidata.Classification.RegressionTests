
-- AV: TODO : eval index option for this one

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeTermsIsATermExisting')
	DROP PROCEDURE spDoNotAutoCodeTermsIsATermExisting
GO
CREATE PROCEDURE dbo.spDoNotAutoCodeTermsIsATermExisting
(
	@ListId                 INT,
	
	-- Term References
	@Term					NVARCHAR(500),
	
	-- Term spesific Properties
	@SegmentId				INT,
	@MedicalDictionaryLevelKey NVARCHAR(100),
	
	-- Output parameters
	@IsExistingAndActive	BIT OUTPUT
)
AS	
BEGIN
	SELECT @IsExistingAndActive = 0

	IF EXISTS (
		SELECT NULL
		FROM [DoNotAutoCodeTerms]
		WHERE	[SegmentId]			                  = @SegmentId
			AND		ListId                            = @ListId
			AND		[Term]				              = @Term
			AND		MedicalDictionaryLevelKey	      = @MedicalDictionaryLevelKey
			AND		Active                            = 1
		)
		SET @IsExistingAndActive = 1

END
GO 