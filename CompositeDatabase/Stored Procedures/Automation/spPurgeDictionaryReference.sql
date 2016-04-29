--/* ------------------------------------------------------------------------------------------------------
--// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
--//
--// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
--// this file may not be disclosed to third parties, copied or duplicated in 
--// any form, in whole or in part, without the prior written permission of
--// Medidata Solutions Worldwide.
--//
--// Author: Altin Vardhami avardhami@mdsol.com
--// ------------------------------------------------------------------------------------------------------*/

--IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spPurgeDictionaryReference')
--	DROP PROCEDURE spPurgeDictionaryReference
--GO
--CREATE PROCEDURE dbo.spPurgeDictionaryReference
--(
--	@dictionaryOID VARCHAR(50)
--)
--AS
--BEGIN

--	-- production check
--	IF NOT EXISTS (
--			SELECT NULL 
--			FROM CoderAppConfiguration
--			WHERE Active = 1 AND IsProduction = 0)
--	BEGIN
--		PRINT N'THIS IS A PRODUCTION ENVIRONMENT - cannot proceed!'
--		RETURN
--	END
	
--	--  validate dictionary reference
--	DECLARE @dictionaryRefId INT
	
--	SELECT @dictionaryRefId = DictionaryRefID
--	FROM DictionaryRef
--	WHERE OID = @dictionaryOID
	
--	IF (@dictionaryRefId IS NULL)
--	BEGIN
--		RAISERROR (N'spPurgeDictionaryReference.sql - No such dictionary',  16, 1)
--		RETURN 1
--	END	
	
--	DECLARE	@segmentOID VARCHAR(50)

--	-- 1. purge all segment data to make sure we leave no dangling refs
--	DECLARE segmentCursor CURSOR FORWARD_ONLY FOR
--	SELECT OID
--	FROM Segments

--	OPEN segmentCursor
--	FETCH segmentCursor INTO @segmentOID

--	WHILE (@@fetch_status = 0)
--	BEGIN

--		EXEC spCodingElementsCleanup @segmentOID, 1, 1, 0
--		FETCH segmentCursor INTO @segmentOID

--	END
--	CLOSE segmentCursor
--	DEALLOCATE segmentCursor
	
--	-- also purge these other references
--	DELETE FROM LongAsyncTaskHistory
--	DELETE FROM LongAsyncTasks
--	DELETE FROM StudyMigrationTraces
--	DELETE FROM ProjectRegistrationTransms
	
--	-- 2. Purge segment references
--	-- a. find all references
--	DECLARE @ObjectSegmentDictionaryIds TABLE (Id INT PRIMARY KEY)
--	DECLARE @ObjectSegmentVerLocaleIds TABLE (Id INT PRIMARY KEY)
	
--	INSERT INTO @ObjectSegmentDictionaryIds (Id)
--	SELECT ObjectSegmentId
--	FROM ObjectSegments
--	WHERE ObjectTypeId = 2001
--		AND ObjectId = @dictionaryRefId

--	INSERT INTO @ObjectSegmentVerLocaleIds (Id)
--	SELECT ObjectSegmentId
--	FROM ObjectSegments
--	WHERE ObjectTypeId = 2002
--		AND ObjectId IN 
--		(	SELECT DictionaryVersionLocaleRefID  
--			FROM DictionaryVersionLocaleRef
--			WHERE DictionaryRefID = @dictionaryRefId
--		)

--	-- b. purge them
--	DELETE FROM MedicalDictionaryTemplateLevel  
--	WHERE DictionaryLevelId IN 
--		(SELECT DictionaryLevelRefId FROM DictionaryLevelRef 
--		WHERE DictionaryRefID = @dictionaryRefId)
	
--	DELETE MedicalDictionaryTemplates
--	WHERE MedicalDictionaryID = @dictionaryRefId

--	DELETE FROM SubscriptionLogs
--	WHERE SubscriptionLogID IN 
--		(SELECT SubscriptionLogID FROM DictionaryVersionSubscriptions
--		WHERE ObjectSegmentID IN (SELECT Id FROM @ObjectSegmentVerLocaleIds))				
	
--	DELETE FROM DictionaryVersionSubscriptions
--	WHERE ObjectSegmentID IN (SELECT Id FROM @ObjectSegmentVerLocaleIds)
	
--	DELETE FROM DictionaryLicenceInformations
--	WHERE MedicalDictionaryID = @dictionaryRefId

--	DELETE FROM ObjectSegmentAttributes
--	WHERE ObjectSegmentID IN (SELECT Id FROM @ObjectSegmentVerLocaleIds)
--	DELETE FROM ObjectSegmentAttributes
--	WHERE ObjectSegmentID IN (SELECT Id FROM @ObjectSegmentDictionaryIds)

--	DELETE FROM ObjectSegments
--	WHERE ObjectSegmentID IN (SELECT Id FROM @ObjectSegmentVerLocaleIds)
--	DELETE FROM ObjectSegments
--	WHERE ObjectSegmentID IN (SELECT Id FROM @ObjectSegmentDictionaryIds)	

--	-- 3. Purge cache dictionary references
--	DELETE FROM DictionaryComponentTypeRef
--	WHERE DictionaryRefID = @dictionaryRefId
	
--	DELETE FROM DictionaryVersionLocaleRef
--	WHERE DictionaryRefID = @dictionaryRefId

--	DELETE FROM DictionaryVersionRef
--	WHERE DictionaryRefID = @dictionaryRefId
	
--	DELETE FROM DictionaryVersionDiffDepth
--	WHERE DictionaryOID = @dictionaryOID

--	DELETE FROM DictionaryLevelRef
--	WHERE DictionaryRefID = @dictionaryRefId

--	DELETE FROM DictionaryRef
--	WHERE DictionaryRefID = @dictionaryRefId
	
--	DELETE FROM LocalizedStrings
--	WHERE StringName = @dictionaryOID

--END 