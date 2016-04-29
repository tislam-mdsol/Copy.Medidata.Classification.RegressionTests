SET NOCOUNT ON
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spConfigurationClone')
	DROP PROCEDURE spConfigurationClone
GO

-- Copies configuration segment data from another [template] segment
CREATE PROCEDURE spConfigurationClone
(
	@NewSegmentID INT,
	@TemplateSegmentID INT
) AS
BEGIN
	
	IF NOT EXISTS (SELECT NULL FROM Configuration
		WHERE SegmentID = @NewSegmentID)
	BEGIN
		
		INSERT INTO Configuration(Tag, ConfigValue, Created, Updated, SegmentID)
		SELECT Tag, ConfigValue, GETUTCDATE(), GETUTCDATE(), @NewSegmentID
		FROM Configuration
		WHERE SegmentID = @TemplateSegmentID
			AND Deleted = 0

	END
 
END
 
