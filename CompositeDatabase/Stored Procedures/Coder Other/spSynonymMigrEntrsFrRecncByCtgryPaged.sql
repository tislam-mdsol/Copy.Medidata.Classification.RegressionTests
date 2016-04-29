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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrEntrsFrRecncByCtgryPaged')
	DROP PROCEDURE dbo.spSynonymMigrEntrsFrRecncByCtgryPaged
GO
Create PROCEDURE [dbo].[spSynonymMigrEntrsFrRecncByCtgryPaged]
(	
	@SynonymMigrationMngmtID INT,
	@categoryTypeID INT,
	@migrationStateId INT,
	@pageSize INT, 
	@pageNumber INT, 
	@Count int output --Return the total count for first time execution, and then use the same for the subsequent executions
)
AS

	DECLARE @rowBase INT = @pageSize * @pageNumber

	-- Select the count
	SELECT @Count = COUNT(*)
	FROM SynonymMigrationEntries
	WHERE SynonymMigrationMngmtID = @SynonymMigrationMngmtID
		AND SuggestionCategoryType = @categoryTypeID
		AND SynonymMigrationStatusRID = @migrationStateId
	
	-- check whether the page requested is valid for the count
	IF (@Count < @pageSize * @pageNumber) 
		SET @pageNumber = @Count / @pageSize;
	
	WITH SQLPaging
	AS
	(
		SELECT SME.*
		FROM SynonymMigrationEntries SME
		WHERE SynonymMigrationMngmtID = @SynonymMigrationMngmtID
			AND SuggestionCategoryType = @categoryTypeID
			AND SynonymMigrationStatusRID = @migrationStateId
	)
	
	SELECT SR.*
	FROM 
	(SELECT  ROW_NUMBER() OVER (ORDER BY SynonymMigrationEntryID) 
		AS Row,  TS.*  FROM SQLPaging TS) 
	AS SR
	WHERE SR.Row BETWEEN @rowBase + 1 AND @rowBase + @PageSize
	
GO