/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author:	Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND NAME = 'spSynonymMigrationEntryClearForList')
	DROP PROCEDURE spSynonymMigrationEntryClearForList
GO
CREATE PROCEDURE dbo.spSynonymMigrationEntryClearForList
(
	@SynonymMigrationMngmtID INT,
	@ActivatedOnly BIT
)
AS
BEGIN 

	DECLARE @rowNumbers INT = 200
	
	DECLARE @synEntryIds TABLE (Id BIGINT PRIMARY KEY)

	WHILE (1 = 1)
	BEGIN
	
		DELETE @synEntryIds
	
		INSERT INTO @synEntryIds
		SELECT TOP (@rowNumbers) SynonymMigrationEntryID
		FROM SynonymMigrationEntries
		WHERE SynonymMigrationMngmtID = @SynonymMigrationMngmtID
			AND (@ActivatedOnly = 0 OR ActivatedStatus = 1)
		
		IF (@@ROWCOUNT = 0)
			BREAK
		
		-- 1. clear suggestions
		DELETE FROM SynonymMigrationSuggestions
		WHERE SynonymMigrationEntryID IN 
			(SELECT Id FROM @synEntryIds)
		
		-- 2. clear entries
		DELETE FROM SynonymMigrationEntries
		WHERE SynonymMigrationEntryID IN 
			(SELECT Id FROM @synEntryIds)
	
	END			

END