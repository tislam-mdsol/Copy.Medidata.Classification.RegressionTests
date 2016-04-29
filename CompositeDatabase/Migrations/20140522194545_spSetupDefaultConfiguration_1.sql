/* ------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of
// this file may not be disclosed to third parties, copied or duplicated in
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jose De Jesus jdejesus@mdsol.com
// coAuthor: Altin Vardhami avardhami@mdsol.com
// required by automation
// ------------------------------------------------------------------------------------------------------*/


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
    --Declare @SegmentOID NVARCHAR(100)

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
	-- hard coded
    DECLARE @dictionaryObjectId INT = 2001

    --Dictionaries
    DECLARE @jdrugID INT

    SELECT @jdrugID = DictionaryRefID
    FROM DictionaryRef
    WHERE OID = @JDrugOID

    DECLARE @jdrugObjSegmentID INT -- , @meddraObjSegmentID INT, @whob2ObjSegmentID INT, @whocObjSegmentID INT
	
	DECLARE @DictionaryObjSegmentIds TABLE (ObjSegmentId INT PRIMARY KEY)
	
	INSERT INTO @DictionaryObjSegmentIds(ObjSegmentId)
	SELECT ObjectSegmentId
	FROM ObjectSegments
    WHERE ObjectTypeID = @dictionaryObjectId
        AND SegmentId = @segmentID

    SELECT @jdrugObjSegmentID = ObjectSegmentId
    FROM ObjectSegments
    WHERE ObjectTypeID = @dictionaryObjectId
        AND SegmentId = @segmentID
        AND ObjectId = @jdrugID
 
    UPDATE ObjectSegmentAttributes
    SET Value = 'False'
    WHERE ObjectSegmentID IN (SELECT ObjSegmentId FROM @DictionaryObjSegmentIds)
        AND Tag = 'IsAutoAddSynonym'

	UPDATE ObjectSegmentAttributes
    SET Value = 'False'
    WHERE ObjectSegmentID IN (SELECT ObjSegmentId FROM @DictionaryObjSegmentIds)
        AND Tag = 'IsAutoApproval'

    UPDATE ObjectSegmentAttributes
    SET Value = '70'
    WHERE ObjectSegmentID IN (SELECT ObjSegmentId FROM @DictionaryObjSegmentIds)
        AND Tag = 'DefaultSuggestThreshold'
  
    UPDATE ObjectSegmentAttributes
    SET Value = '90'
    WHERE ObjectSegmentID IN (SELECT ObjSegmentId FROM @DictionaryObjSegmentIds)
        AND Tag = 'DefaultSelectThreshold'  
  
    UPDATE ObjectSegmentAttributes
    SET Value = '25'
    WHERE ObjectSegmentID IN (SELECT ObjSegmentId FROM @DictionaryObjSegmentIds)
        AND Tag = 'MaxNumberofSearchResults'  

    UPDATE ObjectSegmentAttributes
    SET Value = '100'
    WHERE ObjectSegmentID = @jdrugObjSegmentID
        AND Tag = 'DefaultSelectThreshold'  



END

