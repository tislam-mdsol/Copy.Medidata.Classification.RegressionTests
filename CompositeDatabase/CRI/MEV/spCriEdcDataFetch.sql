IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCriEdcDataFetch')
	DROP PROCEDURE dbo.spCriEdcDataFetch
GO
  
CREATE PROCEDURE dbo.spCriEdcDataFetch (  
 @EdcDataId bigint
)  
AS  
BEGIN

	SELECT *
	FROM EDCData
	WHERE EDCDataID = @EdcDataId
 
END  
  
GO
