IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spEnableLOCLocalization')
	DROP PROCEDURE spEnableLOCLocalization
GO

CREATE PROCEDURE dbo.spEnableLOCLocalization
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

	-- 2. insert localization strings
	INSERT INTO LocalizedStrings(StringName, String, Locale, StringTypeID, ProductName, TranslationStatus)
	SELECT StringName, 'L'+String, 'loc', StringTypeID, ProductName, TranslationStatus
	FROM LocalizedStrings L1
	WHERE L1.ProductName = 'CodR'
		AND L1.Locale = 'eng'
		AND NOT EXISTS (SELECT NULL FROM LocalizedStrings L2
			WHERE L2.StringName = L1.StringName AND L2.Locale = 'loc')
    
    -- 3. update existing loc strings not matching the correct pattern
    UPDATE L2
	SET L2.String = 'L'+L1.String
	FROM LocalizedStrings L1
		JOIN LocalizedStrings L2
			ON  L1.StringName = L2.StringName 
			AND L1.Locale='eng' 
			AND L2.Locale='loc'
	Where L2.String <> 'L' + L1.String
    
    UPDATE L2
	SET L2.String = 'L'+L1.String
	FROM LocalizedDataStrings L1
		JOIN LocalizedDataStrings L2
			ON  L1.StringID = L2.StringID 
			AND L1.Locale='eng' 
			AND L2.Locale='loc'
			AND L1.SegmentID = L2.SegmentID
	Where L2.String <> 'L' + L1.String
	
	-- 4. insert non-existing loc strings based on eng string for each segment
    INSERT INTO LocalizedDataStrings(StringID, String, Locale,TranslationStatus,SegmentID)
    SELECT StringID, 'L'+String, 'loc', TranslationStatus, SegmentID
    FROM LocalizedDataStrings L1
	WHERE L1.Locale = 'eng'
		  AND NOT EXISTS (SELECT NULL FROM LocalizedDataStrings L2
			  WHERE L2.SegmentID = L1.SegmentID 
			       AND L2.Locale = 'loc'
			       AND L1.StringID = L2.StringID)
			
END  