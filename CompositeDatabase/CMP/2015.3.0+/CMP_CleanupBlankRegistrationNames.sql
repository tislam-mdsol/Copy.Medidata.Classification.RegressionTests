/* ------------------------------------------------------------------------------------------------------
//-- Background : https://jira.mdsol.com/browse/MCC-211991
//-- These are project registrations for dictionaries that are no longer supported by Coder after the Lexicon move to S3.
//-- During the migration these study dictionary version entries were migrated with a blank RegistrationName. This causes an error in the ODM parser that is requiring a non-blank RegistrationName.
//-- Fix: Update RegistrationName from blank to 'UNKNOWNDICTIONARY'
------------------------------------------------------------------------------------------------------*/ 

IF EXISTS ( SELECT  *  FROM    sysobjects WHERE   type = 'P' AND name = 'CMP_CleanupBlankRegistrationNames' ) 
    DROP PROCEDURE dbo.CMP_CleanupBlankRegistrationNames
GO

CREATE PROCEDURE dbo.CMP_CleanupBlankRegistrationNames
AS 
    BEGIN
    
        DECLARE  @rowsCount INT, @errorString NVARCHAR(MAX)        

		IF(Not(Exists(SELECT * FROM StudyDictionaryVersion 
					  WHERE RegistrationName = '')))
		BEGIN
				SELECT  'Cannot find blank Registration names in StduyDictionaryVersion'
                RETURN 0
		End

        BEGIN TRY
            BEGIN TRANSACTION
				UPDATE StudyDictionaryVersion
				SET
					  RegistrationName = 'UNKNOWNDICTIONARY', Updated = GETUTCDATE()
				WHERE RegistrationName = '';

				SELECT @rowsCount = @@ROWCOUNT;

				IF(@rowsCount > 0)
					PRINT  'Updated '+ Convert(varchar, @rowsCount) + ' records with blank registration names'
				ELSE
					PRINT  'Cannot update blank registration names'
            COMMIT TRANSACTION
        END TRY

        BEGIN CATCH
            ROLLBACK TRANSACTION
            SET @errorString = N'CMP ERROR: Transaction Error Message - '
                + ERROR_MESSAGE()
            RAISERROR(@errorString, 16, 1)
        END CATCH	
	END
GO
