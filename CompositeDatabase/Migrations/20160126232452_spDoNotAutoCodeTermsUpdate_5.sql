IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeTermsUpdate')
	DROP PROCEDURE spDoNotAutoCodeTermsUpdate
GO
CREATE PROCEDURE dbo.spDoNotAutoCodeTermsUpdate
(
	@DoNotAutoCodeTermId	BIGINT,
	
	-- Term References
	@Term					NVARCHAR(500),
	@MedicalDictionaryLevelKey NVARCHAR(100),
	
    @ListId                 INT,

	-- Term spesific Properties
	@UserId					INT,
	@SegmentId				INT,
	@Updated				DATETIME OUTPUT
)
AS	

BEGIN
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SET @Updated = @UtcDate

	UPDATE DoNotAutoCodeTerms
	SET
		[Term]					          = @Term,
		MedicalDictionaryLevelKey		  = @MedicalDictionaryLevelKey,

        --ListId                            = @ListId,
		
		[Active]				          = 1,
		[UserId]				          = @UserId,
		[SegmentId]				          = @SegmentId,
		[Updated]				          = @UtcDate
	where [DoNotAutoCodeTermId]           = @DoNotAutoCodeTermId
END
GO 