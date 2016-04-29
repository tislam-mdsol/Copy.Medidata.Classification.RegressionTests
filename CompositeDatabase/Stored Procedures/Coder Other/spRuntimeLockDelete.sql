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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRuntimeLockDelete')
	DROP PROCEDURE dbo.spRuntimeLockDelete
GO

CREATE PROCEDURE dbo.spRuntimeLockDelete (
	@lockKey VARCHAR(900)
)
AS
BEGIN

	DELETE FROM dbo.RuntimeLocks
	WHERE LockString = @lockKey

END
GO  