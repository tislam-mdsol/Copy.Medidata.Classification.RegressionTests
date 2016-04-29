IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMedicalDictVerLocaleSegmentAssociationUpdate')
	DROP PROCEDURE dbo.spMedicalDictVerLocaleSegmentAssociationUpdate
GO

CREATE PROCEDURE dbo.spMedicalDictVerLocaleSegmentAssociationUpdate
(
	@IsProdValue NVARCHAR(4000),
	@ActiveValue NVARCHAR(4000),

	@ObjectSegmentId INT
)
AS
BEGIN

	DECLARE @IsProdTag VARCHAR(50) = 'IsProd',
		@ActiveTag VARCHAR(50) = 'Active'

	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  

	UPDATE ObjectSegmentAttributes
	SET Value = CASE 
				WHEN Tag = @IsProdTag THEN @IsProdValue
				WHEN Tag = @ActiveTag THEN @ActiveValue
				ELSE ''
			END,
			Updated = @UtcDate
	WHERE ObjectSegmentId = @ObjectSegmentId
		AND Tag IN (@IsProdTag, @ActiveTag)
	
END
GO
 