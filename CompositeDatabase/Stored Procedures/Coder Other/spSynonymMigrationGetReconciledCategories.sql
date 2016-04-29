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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrationGetReconciledCategories')
	DROP PROCEDURE spSynonymMigrationGetReconciledCategories
GO
create procedure dbo.spSynonymMigrationGetReconciledCategories
(
	@SynonymMigrationMngmtID INT
)
AS
	-- temp table needed to get the identity column for databoundobject limitation
	DECLARE @TempTable TABLE(PrograRowNum INT IDENTITY(1,1), CategoryCount BIGINT, SuggestionCategoryType INT, SynonymMigrationStatusRID INT)

	INSERT INTO @TempTable (CategoryCount, SuggestionCategoryType, SynonymMigrationStatusRID)
	SELECT COUNT(SynonymMigrationEntryID) AS CategoryCount, SuggestionCategoryType, SynonymMigrationStatusRID
	FROM SynonymMigrationEntries
	WHERE SynonymMigrationMngmtID = @SynonymMigrationMngmtID
	GROUP BY SuggestionCategoryType, SynonymMigrationStatusRID

	SELECT * FROM @TempTable

GO
