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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRuntimeLockIsLocked')
	DROP PROCEDURE dbo.spRuntimeLockIsLocked
GO

CREATE PROCEDURE dbo.spRuntimeLockIsLocked (
	@lockKey VARCHAR(900),
	@expireInSeconds INT,
	@IsLocked BIT OUTPUT
)
AS
BEGIN

	SET @IsLocked = 1

	DECLARE @dateNow DATETIME, @ExpiryTime DATETIME 
	SET @dateNow = GETUTCDATE()
	SET @ExpiryTime = DATEADD(second, @expireInSeconds, @dateNow)

	-- must clear expired before new insertions!
	DELETE FROM dbo.RuntimeLocks
	WHERE LockString = @lockKey
		AND ExpiresOn < @dateNow

	IF NOT EXISTS (SELECT NULL FROM RuntimeLocks
		WHERE LockString = @lockKey)
		SET @IsLocked = 0

END
GO 
 