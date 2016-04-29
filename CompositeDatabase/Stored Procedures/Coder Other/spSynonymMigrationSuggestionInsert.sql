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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrationSuggestionInsert')
	DROP PROCEDURE spSynonymMigrationSuggestionInsert
GO

CREATE PROCEDURE spSynonymMigrationSuggestionInsert (
	--@TermId int,
    @NextTermIdsAndText NVARCHAR(MAX),
	@SuggestedNodePath VARCHAR(MAX),
	@SynonymSuggestionReasonRID int,
	@SynonymMigrationEntryID int,
	@IsPrimaryPath bit,
	@Created datetime output,
	@Updated datetime output,
	@SynonymMigrationSuggestionID int output
)
AS

BEGIN
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SELECT @Created = @UtcDate, @Updated = @UtcDate

	INSERT INTO dbo.SynonymMigrationSuggestions (
		--TermId ,
		NextTermIdsAndText,
		SuggestedNodePath,
			
		SynonymSuggestionReasonRID,
		IsPrimaryPath,
		Created ,
		Updated,
		SynonymMigrationEntryID
	) VALUES (
		--@TermId ,
		@NextTermIdsAndText,
		@SuggestedNodePath,
				
		@SynonymSuggestionReasonRID ,
		@IsPrimaryPath,
		@Created  ,
		@Updated  ,
		@SynonymMigrationEntryID
	)
	
	SET @SynonymMigrationSuggestionID = SCOPE_IDENTITY()
END

GO  