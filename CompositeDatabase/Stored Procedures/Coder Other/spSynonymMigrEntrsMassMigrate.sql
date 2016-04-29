/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrEntrsMassMigrate')
	DROP PROCEDURE dbo.spSynonymMigrEntrsMassMigrate
GO
Create PROCEDURE [dbo].[spSynonymMigrEntrsMassMigrate]
(	
	@SynonymMigrationMngmtID INT,
	@categoryTypeID INT,
	@userID INT,
	@allowPrimaryPaths BIT
)
AS

	IF (@SynonymMigrationMngmtID IS NULL OR @SynonymMigrationMngmtID < 1)
		RETURN

	DECLARE @NotMigratedStateId INT, @MigratedStateID INT
	
	SELECT @NotMigratedStateId = 1, -- nonmigrated yet
		@MigratedStateID = 4

	--1.  only update those that have a single suggestion	
	UPDATE E
	SET E.SynonymMigrationStatusRID = @MigratedStateID,
		E.UserId = @userID,
		E.SelectedSuggestionId = S.SynonymMigrationSuggestionID
	FROM SynonymMigrationEntries E
		JOIN SynonymMigrationSuggestions S
			ON E.SynonymMigrationEntryID = S.SynonymMigrationEntryID
	WHERE E.SynonymMigrationMngmtID = @SynonymMigrationMngmtID
		AND E.SuggestionCategoryType = @categoryTypeID
		AND E.SynonymMigrationStatusRID = @NotMigratedStateId
		AND E.NumberOfSuggestions = 1

	-- 2. update those that have suggestion from primary path
	IF (@allowPrimaryPaths = 1)
	BEGIN
	
		UPDATE E
		SET E.SynonymMigrationStatusRID = @MigratedStateID,
			E.UserId = @userID,
			E.SelectedSuggestionId = S.SynonymMigrationSuggestionID
		FROM SynonymMigrationEntries E
			JOIN SynonymMigrationSuggestions S
				ON E.SynonymMigrationEntryID = S.SynonymMigrationEntryID
				-- TODO : what if more than 1 primary?
				AND S.IsPrimaryPath = 1
		WHERE E.SynonymMigrationMngmtID = @SynonymMigrationMngmtID
			AND E.SuggestionCategoryType = @categoryTypeID
			AND E.SynonymMigrationStatusRID = @NotMigratedStateId
	
	END
	
GO
