 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyDictionaryVersionInsert')
	DROP PROCEDURE dbo.spStudyDictionaryVersionInsert
GO

CREATE PROCEDURE dbo.spStudyDictionaryVersionInsert (
	@StudyID BIGINT,
	@KeepCurrentVersion BIT,
	@CacheVersion BIGINT,

	@DictionaryVersionId INT,
	@InitialDictionaryVersionId INT,

	@MedicalDictionaryID INT ,
	@NumberOfMigrations INT,
	@DictionaryLocale CHAR(3),
	@SynonymManagementID INT,	
	@StudyDictionaryVersionID BIGINT output,
	@Created datetime output,  
	@Updated datetime output,
	@SegmentID INT
)
AS

BEGIN

	DECLARE @UtcDate DateTime  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  


	INSERT INTO dbo.StudyDictionaryVersion (
		StudyID,
		KeepCurrentVersion,
		CacheVersion,
		
		DictionaryVersionId,
		InitialDictionaryVersionId,		
		
		MedicalDictionaryID,
		NumberOfMigrations,
		SegmentID,
		DictionaryLocale,
		SynonymManagementID,
		Created,  
		Updated
	) VALUES (
		@StudyID,
		@KeepCurrentVersion,
		@CacheVersion,
		
		@DictionaryVersionId,
		@InitialDictionaryVersionId,
		
		@MedicalDictionaryID,
		@NumberOfMigrations,
		@SegmentID,
		@DictionaryLocale,
		@SynonymManagementID,
		@Created,
		@Updated
	)
	
	SET @StudyDictionaryVersionID = SCOPE_IDENTITY()
END
GO