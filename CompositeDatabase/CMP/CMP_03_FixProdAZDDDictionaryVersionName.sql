 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Sneha Saikumar ssaikumar@mdsol.com
//
// Fix Production AZDD dictionary version name
// How to use: 
// 1) Run the script to create the stored procedure
// 2) Invoke the CMP: EXEC spCoder_CMP_003 'AZDD', '201109', '11.2'
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_003')
	DROP PROCEDURE spCoder_CMP_003
GO

CREATE PROCEDURE dbo.spCoder_CMP_003
(
	@MedicalDictionaryOID varchar(50),
	@SourceMedicalDictionaryVersionOID varchar(50),
	@TargetMedicalDictionaryVersionOID varchar(50)
)
AS
BEGIN

	declare @medicaldictionaryid int, @versionordinal int, @errorString NVARCHAR(MAX)	

	select @medicaldictionaryid = medicaldictionaryid
	from Medicaldictionary
	where OID = @MedicalDictionaryOID
	
	IF (@MedicalDictionaryID IS NULL)
	BEGIN
		SET @errorString = N'ERROR: No such dictionary!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END	
  
	select @versionordinal = ordinal
	from MedicalDictionaryVersion
	where OID = @SourceMedicalDictionaryVersionOID
		and MedicalDictionaryId = @medicaldictionaryid
		
	IF (@versionordinal IS NULL)
	BEGIN
		SET @errorString = N'ERROR: No such version!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	BEGIN TRY
	BEGIN TRANSACTION
  
	UPDATE MedicalDictionaryVersion 
	SET OID = @TargetMedicalDictionaryVersionOID
	WHERE OID = @SourceMedicalDictionaryVersionOID and MedicalDictionaryId = @medicaldictionaryid 
	
	IF NOT EXISTS(SELECT NULL FROM LocalizedStrings WHERE StringName = @TargetMedicalDictionaryVersionOID AND Locale = 'eng')
	BEGIN
	  
	INSERT INTO LocalizedStrings (StringName,String,Locale,StringTypeID,ProductName,TranslationStatus)
	VALUES(@TargetMedicalDictionaryVersionOID,@TargetMedicalDictionaryVersionOID,'eng',4,'CodR',2)
	
	END
	
	IF NOT EXISTS(SELECT NULL FROM LocalizedStrings WHERE StringName = @TargetMedicalDictionaryVersionOID AND Locale = 'jpn')
	BEGIN

	INSERT INTO LocalizedStrings (StringName,String,Locale,StringTypeID,ProductName,TranslationStatus)
	VALUES(@TargetMedicalDictionaryVersionOID,@TargetMedicalDictionaryVersionOID, 'jpn',4,'CodR',2)
	
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