/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2015, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Eric Grun egrun@mdsol.com
//
// Sync a users login information from iMedidata for situations when a user can not log in to Coder
//
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_SyncUserWithIMedidata')
	DROP PROCEDURE dbo.spCoder_CMP_SyncUserWithIMedidata
GO

CREATE PROCEDURE dbo.spCoder_CMP_SyncUserWithIMedidata
(
	@IMedidataId NVARCHAR(50),
	@Login       NVARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @errorString NVARCHAR(MAX), @successString NVARCHAR(MAX)

	IF (ISNULL(@IMedidataId, '') = '')
	BEGIN
	    SET @errorString = N'ERROR: @IMedidataId is required value!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	IF (ISNULL(@Login, '') = '')
	BEGIN
	    SET @errorString = N'ERROR: @Login is required value!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	IF NOT EXISTS (SELECT NULL
	FROM [Users]
	WHERE [IMedidataId] = @IMedidataId)
		BEGIN
	    SET @errorString = N'ERROR: No user found for that iMedidataId!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	DECLARE @ChangedUser TABLE (OldLogin NVARCHAR(50), NewLogin NVARCHAR(50))

	UPDATE [Users]
	SET [Login] = @Login
	OUTPUT DELETED.[Login],
		INSERTED.[Login]
	INTO @ChangedUser
	WHERE
	[IMedidataId] = @IMedidataId

	SELECT @successString = N'Success! User: '+@IMedidataId+' altered Login from '+OldLogin+' to '+NewLogin
	FROM @ChangedUser

	PRINT @successString
END