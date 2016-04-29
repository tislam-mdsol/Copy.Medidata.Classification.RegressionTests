/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
//
// Fills in the missing codeandtermnotfound category differences for targeted dictionaries & versions
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_010')
	DROP PROCEDURE spCoder_CMP_010
GO

--spCoder_CMP_010 'AZ_WhoDrugB2', '201103', 'eng'

CREATE PROCEDURE dbo.spCoder_CMP_010 
(  
 @DictionaryOID VARCHAR(50),
 @ToVersionOID VARCHAR(50),
 @Locale CHAR(3)
)  
AS
BEGIN

	--1. validate parameters
	DECLARE @medicalDictionaryID INT, @toVersionOrdinal INT, @localeID INT
	DECLARE @errorString NVARCHAR(500)
	
	SELECT @medicalDictionaryID = MedicalDictionaryID
	FROM MedicalDictionary
	WHERE OID = @DictionaryOID
	
	IF (@medicalDictionaryID IS NULL)
	BEGIN
		SET @errorString = 'Invalid Dictionary: ' + @DictionaryOID
		PRINT @errorString
		RAISERROR(@errorString, 16, 11)
		RETURN 1
	END
	
	SELECT @toVersionOrdinal = Ordinal
	FROM MedicalDictionaryVersion
	WHERE OID = @ToVersionOID
		AND @medicalDictionaryID = MedicalDictionaryID
	
	IF (@toVersionOrdinal IS NULL)
	BEGIN
		SET @errorString = 'Invalid (to) DictionaryVersion: ' + @ToVersionOID
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END	 
 
 	SELECT @localeID = ID
	FROM CoderLocaleAddlInfo
	WHERE Locale = @Locale
	
	IF (@localeID IS NULL)
	BEGIN
		SET @errorString = 'Invalid Locale: ' + @Locale
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END	 
 

	BEGIN TRANSACTION
	BEGIN TRY
	
		-- prior Version terms that are not matched at all in the new version....
		;WITH oldVersionCTE (OldVersionTermID, ImpactAnalysisChangeTypeId, SuggestionNextTermID, VersionOrdinal )
		AS
		(
			SELECT 
				Past_V.FinalTermID,
				CASE 
					WHEN V.FinalTermID IS NULL THEN 7 -- Term[text] and Code not found
					ELSE 
						CASE 
							WHEN
								(@Locale = 'eng' AND V.Term_ENG = Past_V.Term_ENG)
								OR
								(@Locale = 'jpn' AND V.Term_JPN = Past_V.Term_JPN)
								OR
								(@Locale = 'loc' AND V.Term_LOC = Past_V.Term_LOC)
							 THEN
								CASE
									WHEN Past_V.Code = V.Code THEN
										CASE 
											WHEN V.IsCurrent = 0 THEN 2  --Obsolete (IsCurrent set to false from true)
											ELSE 3							--ReInstated (IsCurrent set to true from false)
										END
									ELSE 6 -- Code not found
								END
							ELSE	5	-- Term[text] not found 
						END
				END AS ImpactAnalysisChangeTypeId,
				-- for non-English cases, reset the FinalTermID to -1 if non-existent term in the future version
				CASE WHEN @Locale = 'jpn' AND V.Term_JPN = '' THEN -1
					WHEN @Locale = 'loc' AND V.Term_LOC = '' THEN -1
					ELSE ISNULL(V.FinalTermID, -1)
				END,
				Past_V.DictionaryVersionOrdinal
			FROM MedicalDictVerTerm Past_V
				LEFT JOIN MedDictTermUpdates U
					ON U.PriorTermID = Past_V.FinalTermID
					AND U.FromVersionOrdinal = Past_V.DictionaryVersionOrdinal
					AND U.ToVersionOrdinal = @ToVersionOrdinal
					AND U.MedicalDictionaryID = Past_V.MedicalDictionaryID
					AND U.Locale = @LocaleID
					AND U.ImpactAnalysisChangeTypeId IN (1, 2, 3, 4)
				LEFT JOIN ImpactAnalysisVersionDifference IAVD
					ON IAVD.OldTermID = Past_V.FinalTermID
					AND IAVD.MedicalDictionaryID = Past_V.MedicalDictionaryID
					AND IAVD.FromVersionOrdinal = Past_V.DictionaryVersionOrdinal
					AND IAVD.ToVersionOrdinal = @ToVersionOrdinal
					AND IAVD.Locale = @LocaleID
				LEFT JOIN MedicalDictVerTerm V
					ON V.DictionaryVersionOrdinal = @ToVersionOrdinal
					AND V.DictionaryLevelId = Past_V.DictionaryLevelId
					AND V.MedicalDictionaryID = Past_V.MedicalDictionaryID
					AND V.Code = Past_V.Code
			WHERE U.TermUpdateId IS NULL
				AND IAVD.MedicalDictionaryID IS NULL
				AND Past_V.DictionaryVersionOrdinal < @ToVersionOrdinal
				AND Past_V.MedicalDictionaryID = @MedicalDictionaryId
				-- past must be present
				AND 
					(
						(@Locale = 'eng' AND Past_V.Term_ENG <> '')
						OR
						(@Locale = 'jpn' AND Past_V.Term_JPN <> '')
						OR
						(@Locale = 'loc' AND Past_V.Term_LOC <> '')
					)
				-- exclude false positives introduced due to IOR
				AND NOT 
					(
						ISNULL(V.FinalTermID, -1) = Past_V.FinalTermID
						AND
						(
							@Locale = 'eng'
							OR
							(
								V.IsCurrent = Past_V.IsCurrent
								AND
									-- IOR check
									(
										(@Locale = 'jpn' AND V.Term_JPN = Past_V.Term_JPN)
										OR
										(@Locale = 'loc' AND V.Term_LOC = Past_V.Term_LOC)
									)
								)
							)
					)
		)
		
		-- Multiples allowed
		INSERT INTO ImpactAnalysisVersionDifference
		(MedicalDictionaryID, FromVersionOrdinal, ToVersionOrdinal, Locale, 
			OldTermID, ImpactAnalysisChangeTypeId, FinalTermID)
		SELECT @MedicalDictionaryID, VersionOrdinal, @ToVersionOrdinal, @LocaleID, 
			OldVersionTermID, ImpactAnalysisChangeTypeId, SuggestionNextTermID
		FROM oldVersionCTE
		OPTION (RECOMPILE)
		
		PRINT N'inserted: '+ CAST( @@ROWCOUNT as nvarchar)

		COMMIT TRANSACTION
			
	END TRY
	BEGIN CATCH
		
		ROLLBACK TRANSACTION
		
		DECLARE @ErrorLine NVARCHAR(500), @ErrorMessage NVARCHAR(500)
		SELECT @ErrorLine = ERROR_LINE(),
			@ErrorMessage = ERROR_MESSAGE()
		
		SET @errorString = N'Caught Exception, Exiting! **** '+cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage + CONVERT(VARCHAR,GETUTCDATE(),21)
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)

	END CATCH


END 