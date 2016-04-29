/* ------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of
// this file may not be disclosed to third parties, copied or duplicated in
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jose De Jesus jdejesus@mdsol.com
// coAuthor: Altin Vardhami avardhami@mdsol.com
// required by automation
// ------------------------------------------------------------------------------------------------------*/

-- Store procedure to age a Task Item's Creation  Date
-- Takes 3 parameters being verbatim Term, Segment OID, and the number of days you want to be subtracted from the current date.

--EXEC spCreationDateAging 'Aspirin Plus C', 'Mediflex1', 1


IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCreationDateAging')
	DROP PROCEDURE spCreationDateAging
GO

CREATE PROCEDURE spCreationDateAging
(
    @VerbatimTerm NVARCHAR(100),
    @SegmentOID NVARCHAR(450),
    @DictionaryName NVARCHAR(450),
    @VersionName NVARCHAR(450),
    @LevelName NVARCHAR(450),
    @dateOffSet DECIMAL(10,2),
    @groupOffSet INT
)
AS

BEGIN

 --production check
 IF NOT EXISTS (
		SELECT NULL 
		FROM CoderAppConfiguration
		WHERE Active = 1 AND IsProduction = 0)
BEGIN
	PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
	RETURN
END

	SET @groupOffSet = ISNULL(@groupOffSet, 1)

	DECLARE @codingElementIDs TABLE(Id INT IDENTITY(1,1), CodingElementID BIGINT)
	DECLARE @medicalDictionaryID INT
	
	SELECT @medicalDictionaryID = DictionaryRefID 
	FROM DictionaryRef    
	WHERE OID = @DictionaryName
	
	INSERT INTO @codingElementIDs   
	SELECT CodingElementId   
	FROM CodingElements CE 
	JOIN StudyDictionaryVersion SDV ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID  
	WHERE VerbatimTerm = @VerbatimTerm       
		AND CE.SegmentId = (SELECT SegmentId FROM Segments    
						WHERE OID = @SegmentOID)
		AND SDV.DictionaryVersionId = (SELECT DictionaryVersionRefID   
									FROM DictionaryVersionRef   
									WHERE DictionaryRefID = @medicalDictionaryID
										AND OID = @VersionName
								)
		AND CE.DictionaryLevelID = (SELECT DictionaryLevelRefID   
									FROM DictionaryLevelRef
									WHERE OID = @LevelName
										AND DictionaryRefID = @medicalDictionaryID
								)
		-- also - test this only for english locales
		AND SDV.DictionaryLocale = 'eng'
		
			
	SELECT * 
	FROM CodingElements CE        
		JOIN @codingElementIDs TempCE    
			ON CE.CodingElementId = TempCE.CodingElementID   
	WHERE TempCE.Id = @groupOffSet
	
	UPDATE CE    
	SET CE.Created = CE.Created - @dateOffSet   
	FROM CodingElements CE    
		JOIN @codingElementIDs TempCE    
			ON CE.CodingElementId = TempCE.CodingElementID   
	WHERE TempCE.Id = @groupOffSet


END 