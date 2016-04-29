/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spFixConflicts')
	DROP PROCEDURE spFixConflicts
GO

CREATE PROCEDURE dbo.spFixConflicts
AS
BEGIN

	-- abort if already executed
	-- if need to retry, rerun CreateTables
	IF EXISTS (SELECT NULL FROM VerbatimIdsJpn)
		OR EXISTS (SELECT NULL FROM VerbatimIdsEng)
	BEGIN
		RAISERROR('CMP has already executed', 1, 16)
		RETURN
	END

	BEGIN TRY

		BEGIN TRANSACTION

		DECLARE @Success BIT
	
		EXEC spGroupConflicts @Success OUTPUT
		IF (@Success = 0)
		BEGIN
			RAISERROR('Cannot proceed with merge operation - complexity beyond scope', 1, 16)
			ROLLBACK TRANSACTION
			RETURN
		END

		-- 1. *** SegmentedGroupCodingPatterns
		EXEC spFixAutomation

		-- 2. *** CodingElementGroups
		EXEC spFixGroups

		-- 3. *** GroupVerbatim
		EXEC spFixGroupVerbatims

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('some msg', 1, 16)
		RETURN
	END CATCH

END 
