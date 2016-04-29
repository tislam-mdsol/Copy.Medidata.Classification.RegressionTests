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
// Fixes ImpactAnalysis category for Japanese from 5 to 7 - meaning no future match known
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_012')
	DROP PROCEDURE spCoder_CMP_012
GO

--spCoder_CMP_012 'MedDRA'

CREATE PROCEDURE dbo.spCoder_CMP_012
(  
 @DictionaryOID VARCHAR(50)
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
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	BEGIN TRANSACTION
	BEGIN TRY
	
		UPDATE ImpactAnalysisVersionDifference
		SET ImpactAnalysisChangeTypeId = 7
		WHERE ImpactAnalysisChangeTypeId = 5
			AND MedicalDictionaryID = @medicalDictionaryID
			AND Locale = 2
			AND FinalTermID < 1
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