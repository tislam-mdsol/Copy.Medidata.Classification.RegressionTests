 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Bonnie Pan bpan@mdsol.com
// Fix Production Category Term Code instead 
// Must be run before running cmp related store procedures
// To Execuate:
// exec spCoder_CMP_009 'JDrug'
// ------------------------------------------------------------------------------------------------------*/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_009')
	DROP PROCEDURE spCoder_CMP_009
GO

CREATE PROCEDURE dbo.spCoder_CMP_009
(
	@MedicalDictionaryOID varchar(50)
)
AS
BEGIN
DECLARE @DictionaryID INT, @DictionaryLevel INT, @CategoryJpnName NVARCHAR(20)
DECLARE	@ErrorMessage NVARCHAR(4000),@errorString NVARCHAR(MAX)

	SELECT @DictionaryID= MedicalDictionaryId 
	FROM medicalDictionary 
	WHERE OID=@MedicalDictionaryOID

	IF (@DictionaryID IS NULL)
	BEGIN
		SET @errorString = 'Dictionary with OID: ' + @MedicalDictionaryOID + ' does not exist.'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END
	
	SELECT @DictionaryLevel = DictionaryLevelId 
	FROM MedicalDictionaryLevel 
	WHERE OID='Category' 
	AND MedicalDictionaryID = @DictionaryID
	
	IF (@DictionaryLevel IS NULL)
	BEGIN
		SET @errorString = 'Dictionary Level: Category does not exist.'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END

BEGIN TRY
	BEGIN TRANSACTION
	DECLARE @rowsToUpdate INT, @rowsUpdatedTerms INT
	--1. Update MedicalDictVerTerm Table
	SET @rowsToUpdate =  (
						    SELECT Count(*) FROM MedicalDictVerTerm 
						    WHERE DictionaryLevelId=@DictionaryLevel 
								AND MedicalDictionaryId = @DictionaryID
						 ) 
	UPDATE MedicalDictVerTerm
		SET MedicalDictVerTerm.Code= dbo.fnGetCodeFromCategoryCode(VT.Code)+N' '+ C.Name +N' '+RIGHT(VT.Code,1)
		FROM MedicalDictVerTerm VT
		CROSS APPLY 
		( 
		SELECT Name FROM ComponentJpnStrings WHERE Id =  dbo.fnGetJPNStringIDFromCategoryCode(VT.Code) 
		)C
		WHERE DictionaryLevelId=@DictionaryLevel 
		    AND MedicalDictionaryId = @DictionaryID
			AND C.Name IS NOT NULL
			
	SET @rowsUpdatedTerms = @@ROWCOUNT
	
	IF (@rowsToUpdate <> @rowsUpdatedTerms)
	BEGIN
		SET @errorString = N'ERROR: Rows Updated in MedicalDictVerTerm['+CAST(@rowsUpdatedTerms AS VARCHAR)+'] not the same with the expectation ['+CAST(@rowsToUpdate AS VARCHAR)+']'
		PRINT @errorString
	END
	
	--2. Update MedicalDictionaryTerm Table 
	SET @rowsToUpdate =  (
						    SELECT Count(*) FROM MedicalDictionaryTerm
						    WHERE DictionaryLevelId=@DictionaryLevel 
								AND MedicalDictionaryId = @DictionaryID
						 ) 

		UPDATE MedicalDictionaryTerm
		SET MedicalDictionaryTerm.Code= dbo.fnGetCodeFromCategoryCode(T.Code)+N' '+ C.Name +N' '+RIGHT(T.Code,1)
		FROM MedicalDictionaryTerm T
		CROSS APPLY 
		( 
		SELECT Name FROM ComponentJpnStrings WHERE Id =  dbo.fnGetJPNStringIDFromCategoryCode(T.Code) 
		)C
		WHERE DictionaryLevelId=@DictionaryLevel 
		    AND MedicalDictionaryId = @DictionaryID
			AND C.Name IS NOT NULL
			
	SET @rowsUpdatedTerms = @@ROWCOUNT
	
	IF (@rowsToUpdate <> @rowsUpdatedTerms)
	BEGIN
		SET @errorString = N'ERROR: Rows Updated in MedicalDictionaryTerm['+CAST(@rowsUpdatedTerms AS VARCHAR)+'] not the same with the expectation ['+CAST(@rowsToUpdate AS VARCHAR)+']'
		PRINT @errorString
	END
	
	

	COMMIT TRANSACTION
END TRY	
BEGIN CATCH
	ROLLBACK TRANSACTION

	SELECT @ErrorMessage = ERROR_MESSAGE()
			
	SET @errorString = N'ERROR: Transaction Error Message - ' + @ErrorMessage
	PRINT @errorString
	RAISERROR(@errorString, 16, 1)
END CATCH


END

