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
// Fills in the missing codenotfound category differences for targeted dictionaries & versions
// *** Only processes changed entries for which no other good change category has been found ***
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_005')
	DROP PROCEDURE spCoder_CMP_005
GO

--spCoder_CMP_005 'AZ_WhoDrugB2', '201103', 'eng'

CREATE PROCEDURE dbo.spCoder_CMP_005  
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
		RAISERROR(@errorString, 1, 16)
	END
	
	SELECT @toVersionOrdinal = Ordinal
	FROM MedicalDictionaryVersion
	WHERE OID = @ToVersionOID
		AND @medicalDictionaryID = MedicalDictionaryID
	
	IF (@toVersionOrdinal IS NULL)
	BEGIN
		SET @errorString = 'Invalid (to) DictionaryVersion: ' + @ToVersionOID
		PRINT @errorString
		RAISERROR(@errorString, 1, 16)
	END	 
 
 	SELECT @localeID = ID
	FROM CoderLocaleAddlInfo
	WHERE Locale = @Locale
	
	IF (@localeID IS NULL)
	BEGIN
		SET @errorString = 'Invalid Locale: ' + @Locale
		PRINT @errorString
		RAISERROR(@errorString, 1, 16)
	END	 
 
	-- TODO : currently hardcoded for ENGLISH ONLY
	IF (@Locale <> 'eng')
	BEGIN
		SET @errorString = 'This code is only developed for ENGLISH (eng) - exiting!'
		PRINT @errorString
		RAISERROR(@errorString, 1, 16)
	END
	
	DECLARE @categoryCodeNotFoundID INT, @categoryTermAndCodeNotFoundID INT

	SELECT @categoryCodeNotFoundID = ImpactAnalysisChangeTypeID
	FROM ImpactAnalysisChangeTypeR
	WHERE OID = 'CodeNotFound'
	
	SELECT @categoryTermAndCodeNotFoundID = ImpactAnalysisChangeTypeID
	FROM ImpactAnalysisChangeTypeR
	WHERE OID = 'TermAndCodeNotFound'	
	
	IF (@categoryCodeNotFoundID IS NULL OR @categoryTermAndCodeNotFoundID IS NULL)
	BEGIN
		SET @errorString = 'Cannot find the category for CodeNotFound or TermAndCodeNotFound!'
		PRINT @errorString
		RAISERROR(@errorString, 1, 16)
	END	
	
	DECLARE @CodableLevels TABLE(LevelId INT PRIMARY KEY)
	
	INSERT INTO @CodableLevels
	SELECT DictionaryLevelId
	FROM MedicalDictionaryLevel
	WHERE MedicalDictionaryID = @medicalDictionaryID
		AND CodingLevel = 1
	
	
	-- NOTE : put them in a loop so as not to lock
	DECLARE @tLockBypass TABLE(ID BIGINT PRIMARY KEY, OldVersionTermID BIGINT, SuggestionNextTermID BIGINT, VersionOrdinal INT)
	DECLARE @ErrorLine NVARCHAR(500), @ErrorMessage NVARCHAR(500)
	
	DECLARE @startRowId INT, @rowNumbers INT
	SELECT @startRowId = -1,
		@rowNumbers = 500
	
	WHILE (1 = 1)
	BEGIN
	
		DELETE @tLockBypass

		INSERT INTO @tLockBypass (ID, OldVersionTermID, SuggestionNextTermID, VersionOrdinal)
		SELECT TOP (@rowNumbers) 
			Past_V.TermId,
			Past_V.FinalTermID,
			ISNULL(V.FinalTermID, -1),
			Past_V.DictionaryVersionOrdinal
		FROM MedicalDictVerTerm Past_V
			-- only check entries which do not have any target suggestion
			JOIN ImpactAnalysisVersionDifference IAVD
				ON IAVD.OldTermID = Past_V.FinalTermID
				AND IAVD.MedicalDictionaryID = Past_V.MedicalDictionaryID
				AND IAVD.FromVersionOrdinal = Past_V.DictionaryVersionOrdinal
				AND IAVD.ToVersionOrdinal = @ToVersionOrdinal
				AND IAVD.Locale = @LocaleID
				AND IAVD.ImpactAnalysisChangeTypeId = @categoryTermAndCodeNotFoundID
			-- TODO : pick max items here?
			JOIN MedicalDictVerTerm V
				ON V.DictionaryVersionOrdinal = @ToVersionOrdinal
				AND V.DictionaryLevelId = Past_V.DictionaryLevelId
				AND V.MedicalDictionaryID = Past_V.MedicalDictionaryID
				AND V.LevelRecursiveDepth = Past_V.LevelRecursiveDepth
				AND V.Term_ENG = Past_V.Term_ENG
		WHERE Past_V.DictionaryVersionOrdinal < @ToVersionOrdinal
			AND Past_V.MedicalDictionaryID = @MedicalDictionaryId
			AND Past_V.DictionaryLevelId IN (SELECT LevelID FROM @CodableLevels)

			AND Past_V.TermId >= @startRowId
		ORDER BY Past_V.TermId ASC
			
		-- break from loop if we have no more 
		IF (@@ROWCOUNT = 0)	BREAK

		BEGIN TRANSACTION
		BEGIN TRY
		
			-- 1. insert the new entries
			INSERT INTO ImpactAnalysisVersionDifference
			(MedicalDictionaryID, FromVersionOrdinal, ToVersionOrdinal, Locale, 
				OldTermID, ImpactAnalysisChangeTypeId, FinalTermID)
			SELECT TOP (@rowNumbers) 
				@MedicalDictionaryID, VersionOrdinal, @ToVersionOrdinal, @LocaleID, 
				OldVersionTermID, @categoryCodeNotFoundID, SuggestionNextTermID
			FROM @tLockBypass
			
			PRINT N'inserted: '+ CAST( @@ROWCOUNT as nvarchar)
			
			-- 2. Delete the old entries from ImpactAnalysisVersionDifference
			DELETE IAVD
			FROM ImpactAnalysisVersionDifference IAVD
				JOIN @tLockBypass LB
					ON IAVD.OldTermID = LB.OldVersionTermID
					AND IAVD.MedicalDictionaryID = @MedicalDictionaryId
					AND IAVD.FromVersionOrdinal = LB.VersionOrdinal
					AND IAVD.ToVersionOrdinal = @ToVersionOrdinal
					AND IAVD.Locale = @LocaleID
					AND IAVD.ImpactAnalysisChangeTypeId = @categoryTermAndCodeNotFoundID
					
			PRINT N'deleted: '+ CAST( @@ROWCOUNT as nvarchar)

			COMMIT TRANSACTION
				
		END TRY
		BEGIN CATCH
			
			ROLLBACK TRANSACTION
			
			SELECT @ErrorLine = ERROR_LINE(),
				@ErrorMessage = ERROR_MESSAGE()
			
			SET @errorString = N'Caught Exception, Exiting! **** '+cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage + CONVERT(VARCHAR,GETUTCDATE(),21)
			PRINT @errorString
			RAISERROR(@errorString, 1, 16)

		END CATCH
		
		SELECT @startRowId = MAX(ID) + 1
		FROM @tLockBypass

	END	

END