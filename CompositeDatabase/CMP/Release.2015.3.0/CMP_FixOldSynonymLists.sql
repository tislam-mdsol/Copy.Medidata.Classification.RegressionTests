/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Eric Grun egrun@mdsol.com
//
// Fix for a Value cannot be null. Parameter name: fullKey
//  at Medidata.Coder.LexiconBridge.CodingVersionLocaleKey..ctor(String fullKey)
// aka (MEV issue)
//
// Some old synonym lists were attached to dictionaries that were no longer supported by 2015.3.0
// We are adding a dummy value for the key as certain pages were breaking when the key was empty
//
//  
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_FixOldSynonymLists')
	DROP PROCEDURE dbo.CMP_FixOldSynonymLists
GO

CREATE PROCEDURE dbo.CMP_FixOldSynonymLists
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @trancount INT
	SET @trancount = @@TRANCOUNT

	BEGIN TRY
		IF @trancount = 0
			BEGIN TRANSACTION
		ELSE
			SAVE TRANSACTION XSaveFixOldSynonymLists

		DECLARE @errorString NVARCHAR(MAX),@successString NVARCHAR(MAX)

		UPDATE SynonymMigrationMngmt
		SET MedicalDictionaryVersionLocaleKey = 'UNKNOWNDICTIONARY-UNKNOWNVERSION-English'
		WHERE ISNULL(MedicalDictionaryVersionLocaleKey, '') = ''

		IF @trancount = 0
			COMMIT TRANSACTION

	END TRY
	BEGIN CATCH

		DECLARE
		@XState INT = XACT_STATE(),
		@ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE(),
		@ErrorNumber INT = ERROR_NUMBER(),
		@ErrorSeverity INT = ERROR_SEVERITY(),
		@ErrorState INT = ERROR_STATE(),
		@ErrorLine INT = ERROR_LINE(),
		@ErrorProcedure NVARCHAR(200) = ISNULL(ERROR_PROCEDURE(), 'CMP_FixOldSynonymLists');

		IF @XState = -1
			ROLLBACK TRANSACTION
		IF @XState = 1 and @trancount = 0
			ROLLBACK TRANSACTION
		IF @XState = 1 and @trancount > 1
			ROLLBACK TRANSACTION XSaveFixOldSynonymLists

		SET @errorString = N'CMP ERROR: Transaction Error Message - Error ' + CONVERT(VARCHAR,@ErrorNumber) +
			N', Severity ' + CONVERT(VARCHAR,@ErrorSeverity) + 
			N', State ' + CONVERT(VARCHAR,@ErrorState) + 
			N', Procedure ' + @ErrorProcedure + 
			N', Line '+ CONVERT(VARCHAR,@ErrorLine) +
			N', Message: ' + @ErrorMessage

		PRINT @errorString
		RAISERROR (@errorString, @ErrorSeverity, 1)

	END CATCH
END