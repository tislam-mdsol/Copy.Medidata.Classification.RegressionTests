  /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Sneha Saikumar ssaikumar@mdsol.com
//
// Fix Production MedicalDictionaryOID and MedicalDictionaryName
// How to use: 
// 1) Run the script to create the stored procedure
// 2) Invoke the CMP: EXEC spCoder_CMP_007 with the required parameters (SourceMedicalDictionaryOID, TargetMedicalDictionaryOID) 
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_007')
	DROP PROCEDURE spCoder_CMP_007
GO

CREATE PROCEDURE dbo.spCoder_CMP_007
(
	@SourceMedicalDictionaryOID varchar(50),
	@TargetMedicalDictionaryOID varchar(50)
)
AS
BEGIN

	declare @medicaldictionaryid int, @errorString NVARCHAR(MAX)	

	select @medicaldictionaryid = medicaldictionaryid
	from Medicaldictionary
	where OID = @SourceMedicalDictionaryOID
	
	IF (@MedicalDictionaryID IS NULL)
	BEGIN
		SET @errorString = N'ERROR: No such dictionary!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END	
  
	BEGIN TRY
	BEGIN TRANSACTION
  
	UPDATE MedicalDictionary 
	SET OID = @TargetMedicalDictionaryOID
	WHERE OID = @SourceMedicalDictionaryOID and MedicalDictionaryId = @medicaldictionaryid 
	
	IF NOT EXISTS(SELECT NULL FROM LocalizedStrings WHERE StringName = @TargetMedicalDictionaryOID AND Locale = 'eng')
	BEGIN
	  
	INSERT INTO LocalizedStrings (StringName,String,Locale,StringTypeID,ProductName,TranslationStatus)
	VALUES(@TargetMedicalDictionaryOID,@TargetMedicalDictionaryOID,'eng',4,'CodR',2)
	
	END
	
	IF NOT EXISTS(SELECT NULL FROM LocalizedStrings WHERE StringName = @TargetMedicalDictionaryOID AND Locale = 'jpn')
	BEGIN

	INSERT INTO LocalizedStrings (StringName,String,Locale,StringTypeID,ProductName,TranslationStatus)
	VALUES(@TargetMedicalDictionaryOID,@TargetMedicalDictionaryOID, 'jpn',4,'CodR',2)
	
	END
	
	COMMIT TRANSACTION
	
	END TRY	
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE	@ErrorMessage NVARCHAR(4000)

		SELECT @ErrorMessage = ERROR_MESSAGE()
				
		SET @errorString = N'ERROR: Transaction Error Message - ' + @ErrorMessage
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH
END