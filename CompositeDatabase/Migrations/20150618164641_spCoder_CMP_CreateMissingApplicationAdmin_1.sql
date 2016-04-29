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
// Fix for a missing application admin entry due to error at initial application sync.
// Symptoms for this condition will be a failure of the segment to synchronize study changes.
// This exception will be in the Coder logs when a user logs in: 'no application admin exists with applicationid=##'
//
// Use the application id ## as input for this cmp
//  
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_CreateMissingApplicationAdmin')
	DROP PROCEDURE dbo.spCoder_CMP_CreateMissingApplicationAdmin
GO

CREATE PROCEDURE dbo.spCoder_CMP_CreateMissingApplicationAdmin
(
	@ApplicationID INT
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @trancount INT
	SET @trancount = @@TRANCOUNT

	BEGIN TRY
		IF @trancount = 0
			BEGIN TRANSACTION
		ELSE
			SAVE TRANSACTION XSaveCMPMissingApplicationAdmin

		DECLARE @errorString NVARCHAR(MAX),@successString NVARCHAR(MAX)

		IF NOT EXISTS ( SELECT NULL FROM [Application]
			WHERE ApplicationID = @ApplicationID)
		BEGIN
			SET @errorString = N'ERROR: No such application found!'
			RAISERROR(@errorString, 16, 1)
			RETURN 1
		END

		IF EXISTS( SELECT NULL FROM ApplicationAdmin
			WITH (TABLOCKX) --table lock to prevent insertion of duplicate application id
			WHERE ApplicationID=@ApplicationID)
		BEGIN
			SET @errorString = N'ERROR: The application admin entry for this application already exists!'
			RAISERROR(@errorString, 16, 1)
			RETURN 1
		END

		DECLARE
		@IsCoderApp BIT = 0,
		@IsCronEnabled BIT = 0,
		@Active BIT = 1,
		@Deleted BIT = 0,
		@Created DATETIME,
		@Updated DATETIME,
		@ApplicationAdminID INT

		EXEC spApplicationAdminInsert
		@ApplicationID,
		@IsCoderApp,
		@IsCronEnabled,
		@Active,
		@Deleted,
		@Created OUTPUT,
		@Updated OUTPUT,
		@ApplicationAdminID OUTPUT
	
		--Verify results
		DECLARE @VerifyApplicationAdminID INT
		SELECT @VerifyApplicationAdminID = ApplicationAdminID
		FROM ApplicationAdmin
		WHERE ApplicationID = @ApplicationID
	 
		IF (@VerifyApplicationAdminID <> @ApplicationAdminID)
		BEGIN
			SET @errorString = N'ERROR: Could not verify the results of the CMP, contact author of cmp! '
			RAISERROR(@errorString, 16, 1)
			RETURN 1
		END

		SET @successString = N'Success! Application Admin entry successfully created for Application: '+ CONVERT(VARCHAR,@ApplicationID)
		PRINT @successString

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
		@ErrorProcedure NVARCHAR(200) = ISNULL(ERROR_PROCEDURE(), 'spCoder_CMP_CreateMissingApplicationAdmin');

		IF @XState = -1
			ROLLBACK TRANSACTION
		IF @XState = 1 and @trancount = 0
			ROLLBACK TRANSACTION
		IF @XState = 1 and @trancount > 1
			ROLLBACK TRANSACTION XSaveCMPMissingApplicationAdmin

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