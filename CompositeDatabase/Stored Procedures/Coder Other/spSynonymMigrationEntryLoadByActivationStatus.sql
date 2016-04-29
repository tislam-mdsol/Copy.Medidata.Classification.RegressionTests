/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrationEntryLoadByActivationStatus')
	DROP PROCEDURE spSynonymMigrationEntryLoadByActivationStatus
GO

CREATE PROCEDURE dbo.spSynonymMigrationEntryLoadByActivationStatus
(
	@SynonymManagementID BIGINT,
	@ActivationStatus BIT
)  
AS  
BEGIN

	SELECT TOP 200 * 
	FROM SynonymMigrationEntries
	WHERE SynonymMigrationMngmtID = @SynonymManagementID
		AND ActivatedStatus = @ActivationStatus
	ORDER BY SynonymMigrationEntryID ASC

END

GO