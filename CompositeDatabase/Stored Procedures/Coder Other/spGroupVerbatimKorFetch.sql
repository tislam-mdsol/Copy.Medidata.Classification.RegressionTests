IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGroupVerbatimKorFetch')
	DROP PROCEDURE spGroupVerbatimKorFetch
GO
CREATE PROCEDURE dbo.spGroupVerbatimKorFetch
(
	@GroupVerbatimID int
)
AS
	
	SELECT *
	FROM GroupVerbatimKor
	WHERE GroupVerbatimID = @GroupVerbatimID

GO  
  