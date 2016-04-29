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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRuntimeLockInsert')
	DROP PROCEDURE dbo.spRuntimeLockInsert
GO

CREATE PROCEDURE dbo.spRuntimeLockInsert (
	@lockKey VARCHAR(900),
	@expireInSeconds INT,
	@LockSuccess BIT OUTPUT
)
AS
BEGIN

	SET @LockSuccess = 0

	DECLARE @Created DATETIME, @ExpiryTime DATETIME  
	SET @Created = GETUTCDATE()
	SET @ExpiryTime = DATEADD(second, @expireInSeconds, @Created)

	-- must clear expired before new insertions!
	DELETE FROM dbo.RuntimeLocks
	WHERE LockString = @lockKey
		AND ExpiresOn < @Created
		
	IF NOT EXISTS (SELECT NULL FROM RuntimeLocks
		WHERE LockString = @lockKey)
	BEGIN
	
		BEGIN TRY

			INSERT INTO dbo.RuntimeLocks (
				LockString,
				Created,
				ExpiresOn
			) VALUES (
				@lockKey,
				@Created,
				@ExpiryTime
			)
			
			IF (@@ROWCOUNT = 1)
				SET @LockSuccess = 1
				
		END TRY
		BEGIN CATCH
			-- consume the error
		END CATCH
	
	END

END
GO 
