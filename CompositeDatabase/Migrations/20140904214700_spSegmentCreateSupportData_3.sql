SET NOCOUNT ON
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentCreateSupportData')
	DROP PROCEDURE spSegmentCreateSupportData
GO

-- Copies supporting segment data from another [template] segment
CREATE PROCEDURE spSegmentCreateSupportData
(
	@NewSegmentID INT,
	@TemplateSegmentID INT,
	@SourceWorkflowOID VARCHAR(50),
	@SegmentTypeId INT
) AS
BEGIN

	DECLARE @canProceed BIT

	SET @canProceed = 1

 -- Check if segments EXIST
	IF ((SELECT COUNT(*) FROM Segments
		WHERE SegmentID IN (@NewSegmentID, @TemplateSegmentID) ) <> 2)
	BEGIN
		PRINT N'Incorrect number of segments [' + CAST(@NewSegmentID AS NVARCHAR) + N',' +CAST(@TemplateSegmentID AS NVARCHAR) + N']'
		SET @canProceed = 0
	END
	
	IF (@canProceed = 0)
	BEGIN
		RETURN 0
	END
  
 -- 1. Localization Support
	IF NOT EXISTS (SELECT NULL FROM Localizations
		WHERE SegmentID = @NewSegmentID)
	BEGIN	
 
		INSERT Localizations (Locale, HelpFolder, NameFormat, NumberFormat, DateFormat, SubmitOnEnter, DescriptionID, DateTimeFormat, Culture, SegmentID) 
		SELECT Locale, HelpFolder, NameFormat, NumberFormat, DateFormat, SubmitOnEnter, DescriptionID, DateTimeFormat, Culture, @NewSegmentID
		FROM Localizations
		WHERE SegmentID = ISNULL(@TemplateSegmentID, 1)
	
	END
  
 -- 6. Configuration Setup
	-- Insert into Configuration those entries 
	-- from [#Configuration] that are missing from Configuration
	IF NOT EXISTS (SELECT NULL FROM Configuration
		WHERE SegmentID = @NewSegmentID)
	BEGIN
		
		INSERT INTO Configuration(Tag, ConfigValue, Created, Updated, SegmentID)
		SELECT Tag, ConfigValue, GETUTCDATE(), GETUTCDATE(), @NewSegmentID
		FROM Configuration
		WHERE SegmentID = @TemplateSegmentID
			AND Deleted = 0

	END
 
	-- 8. New Role (assigned to no one)
	EXECUTE spSetupExternalVerbatimSecurity @NewSegmentID, @SegmentTypeId
 
END
 
