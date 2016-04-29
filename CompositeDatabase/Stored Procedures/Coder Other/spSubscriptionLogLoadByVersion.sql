IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSubscriptionLogLoadByVersion')
	DROP PROCEDURE spSubscriptionLogLoadByVersion
GO
CREATE PROCEDURE dbo.spSubscriptionLogLoadByVersion
(
	@VersionId INT,
	@Locale CHAR(3)
)
AS
	
	SELECT TOP 1 *
	FROM SubscriptionLogs
	WHERE
		Deleted = 0
		AND DictionaryVersionID = @VersionId
		AND DictionaryLocale = @Locale
	ORDER BY SubscriptionLogID DESC

	
GO  		

