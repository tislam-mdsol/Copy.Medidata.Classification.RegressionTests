IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spSetupGranularDefaultConfiguration')
DROP PROCEDURE spSetupGranularDefaultConfiguration
GO

CREATE PROCEDURE spSetupGranularDefaultConfiguration
(
    @SegmentOID                         NVARCHAR(100),
    @DefaultLocale                      NVARCHAR(100),
    @CodingSuggestionPageSize           NVARCHAR(100),
    @MaxSuggestionReturn                NVARCHAR(100),
    @CodingTaskPageSize                 NVARCHAR(100),
    @ForcePrimaryPathSelection          NVARCHAR(100),
    @SearchLimitReclassificationResult  NVARCHAR(100), 
    @SynonymCreationPolicyFlag          NVARCHAR(100), 
    @BypassReconsiderUponReclassifyFlag NVARCHAR(100),
    @DictOID                            NVARCHAR(100),
    @IsAutoAddSynonym                   NVARCHAR(100),
    @IsAutoApproval                     NVARCHAR(100),
    @DefaultSuggestThreshold            NVARCHAR(100),
    @MaxNumberofSearchResults           NVARCHAR(100),
    @DefaultSelectThreshold             NVARCHAR(100)
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
    SET ConfigValue = @DefaultLocale
    WHERE SegmentID = @segmentID
        AND Tag = 'DefaultLocale'

    UPDATE Configuration
    SET ConfigValue = @CodingSuggestionPageSize
    WHERE SegmentID = @segmentID
        AND Tag = 'CodingSuggestionPageSize'  

    UPDATE Configuration
    SET ConfigValue = @MaxSuggestionReturn
    WHERE SegmentID = @segmentID
        AND Tag = 'MaxSuggestionReturn'      
      
    UPDATE Configuration
    SET ConfigValue = @CodingTaskPageSize
    WHERE SegmentID = @segmentID
        AND Tag = 'CodingTaskPageSize'  

    UPDATE Configuration
    SET ConfigValue = @ForcePrimaryPathSelection
    WHERE SegmentID = @segmentID
        AND Tag = 'ForcePrimaryPathSelection'  

    UPDATE Configuration
    SET ConfigValue = @SearchLimitReclassificationResult
    WHERE SegmentID = @segmentID
        AND Tag = 'SearchLimitReclassificationResult'

    UPDATE Configuration
    SET ConfigValue = @SynonymCreationPolicyFlag
    WHERE SegmentID = @segmentID
        AND Tag = 'SynonymCreationPolicyFlag'

    UPDATE Configuration
    SET ConfigValue = @BypassReconsiderUponReclassifyFlag
    WHERE SegmentID = @segmentID
        AND Tag = 'BypassReconsiderUponReclassifyFlag'

  
-- TAB 2: dictionary config
    --Dictionaries
    DECLARE @dictID INT

	DECLARE @t TABLE(dictionaryid INT, dictionaryOid VARCHAR(100))

	insert into @t(dictionaryid, dictionaryOid)
	values(	1	, 'MedDRA_Orig')
	insert into @t(dictionaryid, dictionaryOid)
	values(	5	, 'MedDRAMedHistory_Orig')
	insert into @t(dictionaryid, dictionaryOid)
	values(	12	, 'JDrug_Orig')
	insert into @t(dictionaryid, dictionaryOid)
	values(	14	, 'AZDD')
	insert into @t(dictionaryid, dictionaryOid)
	values(	16	, 'WhoDrugDDEB2')
	insert into @t(dictionaryid, dictionaryOid)
	values(	18	, 'WhoDrugDDB2')
	insert into @t(dictionaryid, dictionaryOid)
	values(	20	, 'HD_DDE_B2')
	insert into @t(dictionaryid, dictionaryOid)
	values(	22	, 'WhoDrugDDC')
	insert into @t(dictionaryid, dictionaryOid)
	values(	24	, 'WHODrug_DDE_C')
	insert into @t(dictionaryid, dictionaryOid)
	values(	26	, 'MedDRA')
	insert into @t(dictionaryid, dictionaryOid)
	values(	27	, 'JDrug')
	insert into @t(dictionaryid, dictionaryOid)
	values(	28	, 'MedDRAMedHistory')
	insert into @t(dictionaryid, dictionaryOid)
	values(	29	, 'WhoDrugHDDDEC')

    SELECT @dictID = dictionaryid
	FROM @t
	WHERE dictionaryOid = @DictOID

	IF (@dictID IS NULL)
	BEGIN
		PRINT 'Cannot find dictionary'
		RAISERROR('Cannot find dictionary', 16, 1)
		RETURN 1
	END

	UPDATE DictionarySegmentConfigurations
	SET 
		DefaultSelectThreshold   = @DefaultSelectThreshold,
		MaxNumberofSearchResults = @MaxNumberofSearchResults,
		DefaultSuggestThreshold  = @DefaultSuggestThreshold,
		IsAutoAddSynonym         = @IsAutoAddSynonym,
		IsAutoApproval           = @IsAutoApproval
	WHERE SegmentId              = @segmentID
		AND DictionaryId         = @dictID

   
END
