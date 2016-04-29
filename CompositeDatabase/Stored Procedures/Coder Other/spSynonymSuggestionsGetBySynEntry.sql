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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymSuggestionsGetBySynEntry')
	DROP PROCEDURE spSynonymSuggestionsGetBySynEntry
GO
CREATE PROCEDURE dbo.spSynonymSuggestionsGetBySynEntry(@SynonymMigrationEntryID int)
AS

	SELECT * 
	FROM SynonymMigrationSuggestions
	WHERE SynonymMigrationEntryID = @SynonymMigrationEntryID

GO 