IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGroupVerbatimChnGetByVerbatimLocale')
	DROP PROCEDURE spGroupVerbatimChnGetByVerbatimLocale
GO
CREATE PROCEDURE dbo.spGroupVerbatimChnGetByVerbatimLocale
(
	@Verbatim NVARCHAR(450)
)
AS

	SELECT TOP 1 * 
	FROM GroupVerbatimChn
	WHERE VerbatimText = @Verbatim
    ORDER BY 1 ASC
	
GO   