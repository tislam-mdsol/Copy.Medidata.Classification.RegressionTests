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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrationEntryInsert')
	DROP PROCEDURE dbo.spSynonymMigrationEntryInsert
GO

CREATE PROCEDURE dbo.spSynonymMigrationEntryInsert (
	@SegmentedGroupCodingPatternID BIGINT,
	@PriorTermIdsAndText NVARCHAR(MAX),
	
	@AreSuggestionsGenerated BIT,
	@SuggestionCategoryType INT,
	@SelectedSuggestionId BIGINT,
	@SynonymMigrationStatusRID int,
	@SynonymMigrationMngmtID int ,
	@NumberOfSuggestions int,
	@UserID INT,
	@ActivatedStatus BIT,
	@IsPrimaryPath BIT,
	@SynonymMigrationEntryID bigint output,
	@Created datetime output,
	@Updated datetime output
)
AS

BEGIN
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SELECT @Created = @UtcDate, @Updated = @UtcDate

	INSERT INTO dbo.SynonymMigrationEntries (
		AreSuggestionsGenerated,
		SuggestionCategoryType,
		SelectedSuggestionId,
		
		SegmentedGroupCodingPatternID,
		PriorTermIdsAndText,

		SynonymMigrationStatusRID,
		Created ,
		Updated,
		SynonymMigrationMngmtID,
		NumberOfSuggestions ,
		UserID,
		ActivatedStatus,
		IsPrimaryPath
	) VALUES (
		@AreSuggestionsGenerated,
		@SuggestionCategoryType,
		@SelectedSuggestionId,
		
		@SegmentedGroupCodingPatternID,	
		@PriorTermIdsAndText,
		
		@SynonymMigrationStatusRID ,
		@Created  ,
		@Updated  ,
		@SynonymMigrationMngmtID,
		@NumberOfSuggestions ,
		@UserID,
		@ActivatedStatus,
		@IsPrimaryPath
	)
	
	SET @SynonymMigrationEntryID = SCOPE_IDENTITY()
END

GO 