IF EXISTS (SELECT * 
		FROM sysobjects WHERE type = 'P' AND name = 'spCodingSourceTermSupplementalLoadByCodingSourceTermId')
	BEGIN
		DROP Procedure spCodingSourceTermSupplementalLoadByCodingSourceTermId
	END
GO

CREATE PROCEDURE dbo.spCodingSourceTermSupplementalLoadByCodingSourceTermId
(
	@CodingSourceTermId INT
)  
AS  
BEGIN  

	SELECT *
	FROM CodingSourceTermSupplementals
	WHERE CodingSourceTermId = @CodingSourceTermId 

END

GO  