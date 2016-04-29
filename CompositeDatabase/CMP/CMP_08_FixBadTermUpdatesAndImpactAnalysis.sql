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
// Fix version difference matches for bad nodepath change types
// How to use: 
// 1) Run the script to create the stored procedure
// 2) Invoke the CMP: EXEC spCoder_CMP_008 with the required parameters (TargetMedicalDictionaryOID) 
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_008')
	DROP PROCEDURE spCoder_CMP_008
GO

CREATE PROCEDURE dbo.spCoder_CMP_008
(
	@MedicalDictionaryOID varchar(50)
)
AS
BEGIN

	-- 1. resolve dictionary
	DECLARE @medicaldictionaryId INT, @errorString NVARCHAR(MAX)	
	DECLARE	@ErrorMessage NVARCHAR(4000)

	SELECT @medicaldictionaryId = MedicalDictionaryId
	FROM Medicaldictionary
	WHERE OID = @MedicalDictionaryOID
	
	IF (@MedicalDictionaryID IS NULL)
	BEGIN
		SET @errorString = N'ERROR: No such dictionary!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END	
	
	-- 2. make sure that there are only english dictionaries loaded
	IF EXISTS (SELECT NULL
		FROM MedicalDictVerLocaleStatus
		WHERE MedicalDictionaryID = @medicaldictionaryId
			AND VersionStatus = 8
			AND Locale <> 'eng')
	BEGIN
		SET @errorString = N'ERROR: This dictionary has non-english versions activated - please update this CMP!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	-- SET THE RECOVERY TO SIMPLE
	DECLARE @dbName NVARCHAR(128)
	
	SELECT @dbName = db_name()
	
	EXEC('ALTER DATABASE '+@dbName+' SET RECOVERY SIMPLE')
	
	-- SHRINK DB
	EXECUTE spShrinkDB 1
	
	DECLARE @rowsAffectedTerms INT,
		@rowsAffectedDeletes INT,
		@rowsAffectedUpdates INT
		
	BEGIN TRY
	BEGIN TRANSACTION
	
		-- update MedDictTermUpdates
		UPDATE U
		SET U.PriorTermID = T.TermID
		FROM MedDictTermUpdates U
			JOIN MedicalDictVerTerm V
				ON U.VersionTermID = V.TermID
				AND U.PriorTermID = -1
				AND U.ImpactAnalysisChangeTypeId = 4
				--AND U.ToVersionOrdinal = @ToVersionOrdinal
				AND U.MedicalDictionaryID = @MedicalDictionaryId
				AND U.Locale = 1
			JOIN MedicalDictionaryTerm T
				ON U.FromVersionOrdinal BETWEEN T.FromVersionOrdinal AND T.ToVersionOrdinal
				AND T.MedicalDictionaryId = @MedicalDictionaryId
				AND T.SegmentId = -1 -- vendor terms only
				AND V.DictionaryLevelId = T.DictionaryLevelId
				AND V.Code = T.Code
				-- skip this for non-english dictionaries (due to performance)
				--AND dbo.fnIsValidForVersionLocale(T.FromVersionOrdinal, T.ToVersionOrdinal, 0, U.FromVersionOrdinal, T.IORVersionLocaleValidity) = 1
		
		SET @rowsAffectedTerms = @@ROWCOUNT
		
		COMMIT TRANSACTION
  
  	END TRY	
	BEGIN CATCH
		ROLLBACK TRANSACTION

		SELECT @ErrorMessage = ERROR_MESSAGE()
				
		SET @errorString = N'ERROR: Transaction Error Message - ' + @ErrorMessage
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH
	
	IF (LEN(ISNULL(@errorString, '')) > 0)
	BEGIN
		RETURN 1
	END
	
	-- SHRINK DB
	EXECUTE spShrinkDB 1
	
	-- update statistics on MedDictTermUpdates
	UPDATE STATISTICS MedDictTermUpdates
  
	BEGIN TRY
	BEGIN TRANSACTION
						
		-- clean up ImpactAnalysisVersionDifference (there should be only 1 chain for nodepath change type)
		DELETE IAVD
		FROM ImpactAnalysisVersionDifference IAVD
			JOIN ImpactAnalysisVersionDifference IAVD2
				ON IAVD.FinalTermID = IAVD2.FinalTermID
				AND IAVD2.ImpactAnalysisChangeTypeId = 4
				AND IAVD.ImpactAnalysisChangeTypeId <> 4
				AND IAVD.MedicalDictionaryID = @medicaldictionaryId
				AND IAVD2.MedicalDictionaryID = @medicaldictionaryId
				AND IAVD.FromVersionOrdinal = IAVD2.FromVersionOrdinal
				AND IAVD.ToVersionOrdinal = IAVD2.ToVersionOrdinal
				AND IAVD.Locale = IAVD2.Locale
		
		SET @rowsAffectedDeletes = @@ROWCOUNT
		
		COMMIT TRANSACTION
	
	END TRY	
	BEGIN CATCH
		ROLLBACK TRANSACTION

		SELECT @ErrorMessage = ERROR_MESSAGE()
				
		SET @errorString = N'ERROR: Transaction Error Message - ' + @ErrorMessage
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH

	IF (@rowsAffectedDeletes <> @rowsAffectedTerms)
	BEGIN
		SET @errorString = N'WARNING: Rows Deleted in ImpactAnalysisVersionDifference['+CAST(@rowsAffectedDeletes AS VARCHAR)+'] not the same with those updated in MedDictTermUpdates ['+CAST(@rowsAffectedTerms AS VARCHAR)+']'
		PRINT @errorString
	END
	
	IF (LEN(ISNULL(@errorString, '')) > 0)
	BEGIN
		RETURN 1
	END
		
	-- SHRINK DB
	EXECUTE spShrinkDB 1
	
	-- update statistics on ImpactAnalysisVersionDifference
	UPDATE STATISTICS ImpactAnalysisVersionDifference
	
	
	BEGIN TRY
	BEGIN TRANSACTION
  
		-- update ImpactAnalysisVersionDifference
		UPDATE IAVD
		SET IAVD.OldTermID = U.PriorTermID,
			IAVD.ImpactAnalysisChangeTypeId = 4
		FROM ImpactAnalysisVersionDifference IAVD
			JOIN MedDictTermUpdates U
				ON IAVD.MedicalDictionaryID = @medicaldictionaryId
				AND IAVD.FromVersionOrdinal = U.FromVersionOrdinal
				AND IAVD.ToVersionOrdinal = U.ToVersionOrdinal
				AND IAVD.Locale = U.Locale
				AND U.ImpactAnalysisChangeTypeId = 4
				AND IAVD.OldTermID = -1
				AND IAVD.FinalTermID = U.FinalTermId
		
		SET @rowsAffectedUpdates = @@ROWCOUNT
				
		COMMIT TRANSACTION

  	END TRY	
	BEGIN CATCH
		ROLLBACK TRANSACTION

		SELECT @ErrorMessage = ERROR_MESSAGE()
				
		SET @errorString = N'ERROR: Transaction Error Message - ' + @ErrorMessage
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH
	
	IF (@rowsAffectedUpdates <> @rowsAffectedTerms)
	BEGIN
		SET @errorString = N'ERROR: Rows Updated in ImpactAnalysisVersionDifference['+CAST(@rowsAffectedUpdates AS VARCHAR)+'] not the same with those updated in MedDictTermUpdates ['+CAST(@rowsAffectedTerms AS VARCHAR)+']'
		PRINT @errorString
	END
	
	IF (LEN(ISNULL(@errorString, '')) > 0)
	BEGIN
		RETURN 1
	END
	
	-- SHRINK DB fully here
	EXECUTE spShrinkDB 0
	
	-- update statistics on ImpactAnalysisVersionDifference
	UPDATE STATISTICS ImpactAnalysisVersionDifference	
	
	-- perform a verification for potential duplicates (shouldn't be any!)
	IF EXISTS (SELECT NULL 
		FROM ImpactAnalysisVersionDifference
		WHERE ImpactAnalysisChangeTypeId = 4
			AND MedicalDictionaryID = @medicaldictionaryId
		GROUP BY FromVersionOrdinal, ToVersionOrdinal, FinalTermID
		HAVING COUNT(*) > 1 )
	BEGIN
		SET @errorString = N'ERROR: Found duplicates in ImpactAnalysisVersionDifference!'
		PRINT @errorString	
	END
	
	EXEC('ALTER DATABASE '+@dbName+' SET RECOVERY FULL')
		
END 