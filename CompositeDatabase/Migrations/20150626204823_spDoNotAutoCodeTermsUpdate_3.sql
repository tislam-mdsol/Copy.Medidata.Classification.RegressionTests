IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDoNotAutoCodeTermsUpdate')
	DROP PROCEDURE spDoNotAutoCodeTermsUpdate
GO
CREATE PROCEDURE dbo.spDoNotAutoCodeTermsUpdate
(
	@DoNotAutoCodeTermId	BIGINT,

	@MedicalDictionaryVersionLocaleKey NVARCHAR(100),
	
	-- Term References
	@Term					NVARCHAR(500),
	@MedicalDictionaryLevelKey NVARCHAR(100),
	
	-- Term spesific Properties
	@UserId					INT,
	@SegmentId				INT,
	@Created				DATETIME,
	@Updated				DATETIME OUTPUT
)
AS	

BEGIN
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SET @Updated = @UtcDate

	UPDATE DoNotAutoCodeTerms
	SET
		MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey,
	
		[Term]					          = @Term,
		MedicalDictionaryLevelKey		  = @MedicalDictionaryLevelKey,
		
		[Active]				          = 1,
		[UserId]				          = @UserId,
		[SegmentId]				          = @SegmentId,
		[Created]				          = [Created],
		[Updated]				          = @UtcDate
	where [DoNotAutoCodeTermId]           = @DoNotAutoCodeTermId
END
GO 