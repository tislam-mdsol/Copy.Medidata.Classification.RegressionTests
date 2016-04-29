IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGroupVerbatimKorGetByVerbatimLocale')
	DROP PROCEDURE spGroupVerbatimKorGetByVerbatimLocale
GO
CREATE PROCEDURE dbo.spGroupVerbatimKorGetByVerbatimLocale
(
	@Verbatim NVARCHAR(450)
)
AS

	SELECT TOP 1 * 
	FROM GroupVerbatimKor
	WHERE VerbatimText = @Verbatim
    ORDER BY 1 ASC
	
GO   