
--Store Procedure to enable our scenario configuration defaults; takes 1 parameters being SegmentOID.
--EXEC spSetupDefaultConfiguration 'Mediflex2'
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spSetupDefaultConfiguration')
	DROP PROCEDURE spSetupDefaultConfiguration
GO

CREATE PROCEDURE spSetupDefaultConfiguration
(
    @SegmentOID NVARCHAR(100),
    @JDrugOID NVARCHAR(100)
)
AS
BEGIN

	--production check
	IF NOT EXISTS (
		SELECT NULL 
		FROM CoderAppConfiguration
		WHERE Active = 1 AND IsProduction = 0)
	BEGIN
	  PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
	  RETURN
	END

    Declare @segmentID INT

    select @segmentID = SegmentId
    FROM Segments
    WHERE OID = @SegmentOID

    IF @segmentID IS NULL
    BEGIN
        PRINT N'cant find segment'+@SegmentOID
    End

	-- TAB 1: Basic config
    UPDATE Configuration
    SET ConfigValue = 'eng'
    WHERE SegmentID = @segmentID
        AND Tag = 'DefaultLocale'

    UPDATE Configuration
    SET ConfigValue = '10'
    WHERE SegmentID = @segmentID
        AND Tag = 'CodingSuggestionPageSize'  

    UPDATE Configuration
    SET ConfigValue = '20'
    WHERE SegmentID = @segmentID
        AND Tag = 'MaxSuggestionReturn'      
      
    UPDATE Configuration
    SET ConfigValue = '10'
    WHERE SegmentID = @segmentID
        AND Tag = 'CodingTaskPageSize'  

    UPDATE Configuration
    SET ConfigValue = 'No'
    WHERE SegmentID = @segmentID
        AND Tag = 'ForcePrimaryPathSelection'  

    UPDATE Configuration
    SET ConfigValue = '100'
    WHERE SegmentID = @segmentID
        AND Tag = 'SearchLimitReclassificationResult'

    UPDATE Configuration
    SET ConfigValue = '1'
    WHERE SegmentID = @segmentID
        AND Tag = 'SynonymCreationPolicyFlag'

    UPDATE Configuration
    SET ConfigValue = 'No'
    WHERE SegmentID = @segmentID
        AND Tag = 'BypassReconsiderUponReclassifyFlag'

  
	-- TAB 2: dictionary config
    --Dictionaries
    DECLARE @jdrug NVARCHAR = 'JDrug' -- hard coded only 1 JDrug

	-- NOTE : this sproc will not insert entries - only update existing

	UPDATE DictionarySegmentConfigurations
	SET DefaultSelectThreshold  = CASE WHEN MedicalDictionaryKey = @jdrug THEN 100 ELSE 90 END,
		IsAutoAddSynonym        = 0,
		IsAutoApproval          = 0,
		DefaultSuggestThreshold = 70
	WHERE SegmentId = @segmentID
	

END
