/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
//
// Generate supporting data for study impact analysis term not changed category
// 
//
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_002')
	DROP PROCEDURE spCoder_CMP_002
GO


CREATE PROCEDURE dbo.spCoder_CMP_002
(  
	 @Locale CHAR(3),
	 @DictionaryOID VARCHAR(50),
	 @levelOneOID VARCHAR(50),
	 @levelTwoOID VARCHAR(50)
)  
AS
BEGIN

	DECLARE
		@MedicalDictionaryID INT,
		@ToVersionOrdinal INT,
		@levelIDOne INT,
		@levelIDTwo INT
		
	DECLARE @errorString NVARCHAR(MAX)

	-- 1. get dictionaryid
	SELECT @MedicalDictionaryID = MedicalDictionaryID
	FROM MedicalDictionary
	WHERE OID = @DictionaryOID
	
	IF (@MedicalDictionaryID IS NULL)
	BEGIN
		SET @errorString = N'ERROR: No such dictionary!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END	


	-- 2. get To Version ordinal
	SELECT @ToVersionOrdinal = MAX(NewVersionOrdinal)
	FROM MedicalDictVerLocaleStatus
	WHERE MedicalDictionaryID = @MedicalDictionaryID
		AND OldVersionOrdinal IS NOT NULL
		AND Locale = @Locale
		AND VersionStatus = 10

	-- 3. get level ids
	SELECT @levelIDOne = DictionaryLevelId
	FROM MedicalDictionaryLevel
	WHERE MedicalDictionaryID = @MedicalDictionaryID
		AND OID = @levelOneOID

	SELECT @levelIDTwo = DictionaryLevelId
	FROM MedicalDictionaryLevel
	WHERE MedicalDictionaryID = @MedicalDictionaryID
		AND OID = @levelTwoOID
		
	IF (@levelIDOne IS NULL OR @levelIDTwo IS NULL)
	BEGIN
		SET @errorString = N'ERROR: No such dictionary!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	ELSE
	BEGIN

		EXEC spVersionDifferenceDoMorePostProcessing_ForTerms 
			@Locale,
			@MedicalDictionaryID,
			@ToVersionOrdinal,
			@levelIDOne,
			@levelIDTwo
		
	END

END