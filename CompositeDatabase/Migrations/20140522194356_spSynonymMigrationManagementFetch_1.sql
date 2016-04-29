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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrationManagementFetch')
	DROP PROCEDURE spSynonymMigrationManagementFetch
GO
create procedure dbo.spSynonymMigrationManagementFetch
(
	@SynonymMigrationMnmgtId int
)
AS

	-- need to be able to read dirty
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @IsVersionInvolvedInMigration BIT
	
	SET @IsVersionInvolvedInMigration = 0
	
	
	SELECT *, @IsVersionInvolvedInMigration AS IsVersionInvolvedInMigration
	FROM SynonymMigrationMngmt
	WHERE SynonymMigrationMngmtID = @SynonymMigrationMnmgtId	
