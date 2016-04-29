IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGroupVerbatimChnFetch')
	DROP PROCEDURE spGroupVerbatimChnFetch
GO
CREATE PROCEDURE dbo.spGroupVerbatimChnFetch
(
	@GroupVerbatimID int
)
AS
	
	SELECT *
	FROM GroupVerbatimChn
	WHERE GroupVerbatimID = @GroupVerbatimID

GO  
  