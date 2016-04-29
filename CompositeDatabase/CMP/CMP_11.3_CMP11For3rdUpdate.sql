﻿/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
// Corrects version difference entries for nodepath type changes
// Will only correct the english changes - the non-english dictionaries are not affected
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_011_3')
	DROP PROCEDURE spCoder_CMP_011_3
GO

--spCoder_CMP_011_3 'AZ_WhoDrugB2'

CREATE PROCEDURE dbo.spCoder_CMP_011_3
(  
	@DictionaryOID VARCHAR(50)
)  
AS
BEGIN

	DECLARE @errorString NVARCHAR(500), @idxName VARCHAR(200)
	
	-- verify indices - exit if they don't exist
	SET @idxName = 'IX_MedDictTermUpdates_DROPAFTER'
	IF NOT EXISTS (SELECT NULL FROM sys.indexes
		WHERE name = @idxName)
	BEGIN
		SET @errorString = 'Performance index does not exist - please create before running this stored procedure: ' + @idxName
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	SET @idxName = 'IX_ImpactAnalysisVersionDifference_DROPAFTER'
	IF NOT EXISTS (SELECT NULL FROM sys.indexes
		WHERE name = @idxName)
	BEGIN
		SET @errorString = 'Performance index does not exist - please create before running this stored procedure: ' + @idxName
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	--1. validate parameters
	DECLARE @medicalDictionaryID INT, @versionOrdinal INT
	
	SELECT @medicalDictionaryID = MedicalDictionaryID
	FROM MedicalDictionary
	WHERE OID = @DictionaryOID
	
	IF (@medicalDictionaryID IS NULL)
	BEGIN
		SET @errorString = 'Invalid Dictionary: ' + @DictionaryOID
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	DECLARE @NODEPATHCHANGE INT, @REINSTATED INT, @OBSOLETED INT, @OldNodepathChange INT
	SELECT @NODEPATHCHANGE = 4,
		@REINSTATED = 3,
		@OBSOLETED = 2,
		@OldNodepathChange = 3
	
	
	-- 3. Do the work
	BEGIN TRANSACTION
	BEGIN TRY
	
		-- 2. ImpactAnalysisVersionDifference
		UPDATE IAVD
		SET IAVD.ImpactAnalysisChangeTypeId = @NODEPATHCHANGE
		FROM ImpactAnalysisVersionDifference IAVD
			JOIN MedDictTermUpdates TU
				ON IAVD.ImpactAnalysisChangeTypeId IN (@OBSOLETED, @REINSTATED)
				AND TU.ChangeTypeID = @OldNodepathChange
				AND IAVD.MedicalDictionaryID = @MedicalDictionaryID
				AND TU.MedicalDictionaryID = @MedicalDictionaryID
				AND IAVD.FromVersionOrdinal = TU.FromVersionOrdinal
				AND IAVD.ToVersionOrdinal = TU.ToVersionOrdinal
				AND IAVD.Locale = TU.Locale
				AND IAVD.OldTermId = TU.PriorTermId
		OPTION (RECOMPILE)
					
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