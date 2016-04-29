/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
//
// Stop-gap measure to address project registration failures
//
// How to use the CMP
// 1. Build the DictionaryVersionList in the following manner
// Dictionary1OID : CorrespondingVersionOID , Dictionary2OID : CorrespondingVersionOID
// (caveat : make sure to pick different delimiters if those ,; are already in the version/dictionary names)
// 2. Get the @SegmentUUID from segment admin page (imedidataID property)
// 3. invoke the CMP
// EXEC spCoder_CMP_001 @DictionaryVersionList, ',', ':', @StudyName, @SegmentUUID
//
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_001')
	DROP PROCEDURE spCoder_CMP_001
GO

--spCoder_CMP_001 'Meddra:12.0, WhoDRUGB2:200806', ',', ':', 'MedidataRsrvd1', '5b79f236-9da0-11e0-bb5d-1231380ffd08'

CREATE PROCEDURE dbo.spCoder_CMP_001  
(  
 @DictionaryVersionList NVARCHAR(MAX),
 @DVCoupleDelimiter NCHAR(1),
 @DVDelimiter NCHAR(1),
 @StudyName NVARCHAR(MAX),
 @SegmentUUID NVARCHAR(MAX)
)  
AS
BEGIN

	DECLARE @errorString NVARCHAR(MAX)

	-- 1. segment check
	IF 1 < (SELECT COUNT(*) FROM Segments
				WHERE ImedidataID = @SegmentUUID
			)
	BEGIN
		SET @errorString = N'ERROR: More than 1 segment with the same UUID!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1	
	END
	
	DECLARE @segmentID INT  

	SELECT @segmentID = SegmentID
	FROM Segments
	WHERE ImedidataID = @SegmentUUID

	IF (@segmentID IS NULL)
	BEGIN
		SET @errorString = N'ERROR: No such segment!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	-- 2. Dictionary & Version Check
	DECLARE @dictionaryVersion TABLE (DictionaryID INT PRIMARY KEY, VersionOrdinal INT)
	DECLARE @dictionaryNames TABLE(ID INT IDENTITY(1,1), DictionaryAndVersionName NVARCHAR(1000))
	DECLARE @versionObjectTypeID INT
	
	SELECT @versionObjectTypeID = ObjectTypeId
	FROM ObjectTypeR
	WHERE ObjectTypeName = 'MedicalDictionaryVersionLocale'


	-- 2.a resolve the dictionary & version names
	INSERT INTO @dictionaryNames
	SELECT * FROM dbo.fnParseDelimitedString(@DictionaryVersionList, @DVCoupleDelimiter)

	DECLARE @idx INT, @DVName NVARCHAR(1000), @DName NVARCHAR(500), @VName NVARCHAR(500),
		@delim INT, @dId INT, @vId INT, @vOrdinal INT
	
	SET @idx = 1
	WHILE (1 = 1)
	BEGIN
 
		SELECT @DVName = DictionaryAndVersionName
		FROM @dictionaryNames
		WHERE ID = @idx
		
		IF (@DVName IS NULL)
			BREAK
		
		SET @delim = CHARINDEX(@DVDelimiter, @DVName)
		SELECT @DName = RTRIM(LTRIM(SUBSTRING(@DVName, 1, @delim-1))),
			@VName = RTRIM(LTRIM(SUBSTRING(@DVName, @delim+1, LEN(@DVName))))
		
		-- Resolve dictionary
		IF 1 < (SELECT COUNT(*) FROM MedicalDictionary
					WHERE OID = @DName
				)
		BEGIN
			SET @errorString = N'ERROR: More than 1 dictionary with the same OID - ' + @DName
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
			RETURN 1	
		END		
		
		SELECT @dId = MedicalDictionaryID
		FROM MedicalDictionary
		WHERE OID = @DName
		
		IF (@dId IS NULL)
		BEGIN
			SET @errorString = N'ERROR: No such dictionary - ' + @DName
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
			RETURN 1
		END

		-- Resolve version
		IF 1 < (SELECT COUNT(*) FROM MedicalDictionaryVersion
					WHERE OID = @VName
						AND MedicalDictionaryId = @dId
				)
		BEGIN
			SET @errorString = N'ERROR: More than 1 version with the same OID - ' + @vName + N' - for dictionary - ' + @DName
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
			RETURN 1	
		END	
		
		SELECT 
			@vOrdinal = Ordinal
		FROM MedicalDictionaryVersion
		WHERE OID = @VName
			AND MedicalDictionaryId = @dId
		
		IF (@vOrdinal IS NULL)
		BEGIN
			SET @errorString = N'ERROR: No such version - ' + @vName + N' - for dictionary - ' + @DName
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
			RETURN 1
		END	

		-- verify dictionary version is subscribed to the segment
		IF NOT EXISTS (SELECT NULL FROM ObjectSegments OS
				JOIN MedicalDictVerLocaleStatus VLS
					ON OS.ObjectId = VLS.MedicalDictVerLocaleStatusID
					AND VLS.MedicalDictionaryID = @dId
					AND VLS.OldVersionOrdinal IS NULL
					AND VLS.NewVersionOrdinal = @vOrdinal
					AND OS.ObjectTypeId = @versionObjectTypeID
					AND OS.Deleted = 0
					AND OS.SegmentId = @segmentID)
		BEGIN
			SET @errorString = N'ERROR: Version - ' + @vName + N' - for dictionary - ' + @DName + N' - is not subscribed to this segment!'
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
			RETURN 1
		END	
		
		-- verify dictionary version synonym is set
		IF NOT EXISTS (SELECT NULL FROM SynonymMigrationMngmt
				WHERE MedicalDictionaryID = @dId
					AND ToVersionOrdinal = @vOrdinal
					AND SegmentId = @segmentID
					AND SynonymMigrationStatusRID = 6)
		BEGIN
			SET @errorString = N'ERROR: Synonym is not started for version - ' + @vName + N' - for dictionary - ' + @DName
			PRINT @errorString
			RAISERROR(@errorString, 16, 1)
			RETURN 1
		END			
		
		INSERT INTO @dictionaryVersion (DictionaryID, VersionOrdinal)
		VALUES(@dId, @vOrdinal)
		
		-- increment & reset variables
		SELECT @idx = @idx + 1,
			@DVName = NULL,
			@delim = NULL,
			@dId = NULL,
			@vOrdinal = NULL
	 
	END
 
	 --3. verify study
	 DECLARE @studyID INT, @projectID INT
	 
	IF 1 < (SELECT COUNT(*) FROM TrackableObjects
			 WHERE ExternalObjectName = @StudyName
				AND SegmentId = @segmentID
			)
	BEGIN
		SET @errorString = N'ERROR: More than 1 study - ' + @StudyName + N' - for segmentUUID - ' + @SegmentUUID
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1	
	END	
			 
	 SELECT @studyID = TrackableObjectID,
		@projectID = StudyProjectId
	 FROM TrackableObjects
	 WHERE ExternalObjectName = @StudyName
		AND SegmentId = @segmentID
 
	IF (@studyID IS NULL)
	BEGIN
		SET @errorString = N'ERROR: No such study - ' + @StudyName + N' - for segmentUUID - ' + @SegmentUUID
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END	  
  
	DECLARE @UserID INT, @ProjectRegistrationTransmissionID INT
	
	-- set the user to be the admin user
	SET @UserID = -2
	
	BEGIN TRY
	BEGIN TRANSACTION
  
		-- 4. fake ProjectRegistrationTransms
		INSERT INTO ProjectRegistrationTransms (UserID, StudyProjectID, TransmissionResponses, ProjectRegistrationSucceeded, SegmentId)
		VALUES(@UserID, @projectID, 'CMP update to work around Project Registration failure', 1, @segmentID)
		
		SET @ProjectRegistrationTransmissionID = SCOPE_IDENTITY()

		-- 5. fake ProjectDictionaryRegistrations
		INSERT INTO ProjectDictionaryRegistrations (UserID, InteractionID, DictionaryID, VersionOrdinal, StudyProjectID, ProjectRegistrationTransmissionID, SegmentId)
		SELECT @UserID, -1, DictionaryID, VersionOrdinal, @projectID, @ProjectRegistrationTransmissionID, @segmentID
		FROM @dictionaryVersion
		
		-- 6. fake StudyDictionaryVersion (new inserts)
		INSERT INTO StudyDictionaryVersion (StudyID, KeepCurrentVersion, VersionOrdinal, MedicalDictionaryID, InitialVersionOrdinal, NumberOfMigrations, StudyLock, SegmentID)
		SELECT @studyID, 0, DV.VersionOrdinal, DV.DictionaryID, DV.VersionOrdinal, 0, 1, @segmentID
		FROM @dictionaryVersion	DV
		WHERE NOT EXISTS (SELECT NULL FROM StudyDictionaryVersion SDV
				WHERE DV.DictionaryID = SDV.MedicalDictionaryID
					AND SDV.StudyID = @studyID)
		
		-- 7. fake StudyDictionaryVersion (version changes)
		UPDATE SDV
		SET SDV.VersionOrdinal = DV.VersionOrdinal
		FROM @dictionaryVersion	DV
			JOIN StudyDictionaryVersion SDV
				ON DV.DictionaryID = SDV.MedicalDictionaryID
				AND SDV.StudyID = @studyID
				
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

