IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCriEdcDataGetByStudy')
	DROP PROCEDURE dbo.spCriEdcDataGetByStudy
GO

CREATE PROCEDURE dbo.spCriEdcDataGetByStudy (  
	@RegistrationName NVARCHAR(100),
	@Locale CHAR(3),
	@StudyID VARCHAR(50)
)  
AS  
BEGIN

	SELECT *
	FROM EDCData
	WHERE RegistrationName = @RegistrationName
		AND Locale         = @Locale
		AND StudyUUID      = @StudyID
 
END  
  
GO
