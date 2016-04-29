IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spMedicalDictVerLocaleSegmentAssociationLoad')
	DROP PROCEDURE dbo.spMedicalDictVerLocaleSegmentAssociationLoad
GO

CREATE PROCEDURE dbo.spMedicalDictVerLocaleSegmentAssociationLoad 
(
	@ObjectSegmentID INT
)
AS
BEGIN

	DECLARE @isProd NVARCHAR(4000), @active NVARCHAR(4000)
	DECLARE @isProdTag VARCHAR(50) = 'IsProd',
		@activeTag VARCHAR(50) = 'Active'

                                                                    
	SELECT @isProd = MAX(CASE WHEN Tag = @isProdTag THEN VALUE ELSE '' END),
		@active = MAX(CASE WHEN Tag = @activeTag THEN VALUE ELSE '' END)
	FROM ObjectSegmentAttributes 
	WHERE ObjectSegmentID = @ObjectSegmentID 
		AND Tag IN (@isProdTag, @activeTag )


	SELECT @isProd AS IsProd,
		@active AS Active,
		@ObjectSegmentID AS ObjectSegmentId

END
GO 



