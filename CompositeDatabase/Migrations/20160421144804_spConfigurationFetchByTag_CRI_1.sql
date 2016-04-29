IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spConfigurationFetchByTag_CRI')
	DROP PROCEDURE spConfigurationFetchByTag_CRI
GO
CREATE PROCEDURE dbo.spConfigurationFetchByTag_CRI
(
	@Tag VARCHAR(64),
	@SegmentID INT
)
AS
	
	SELECT ConfigValue
	FROM Configuration
	WHERE Tag = @Tag
		AND SegmentID = @SegmentID

GO  
  