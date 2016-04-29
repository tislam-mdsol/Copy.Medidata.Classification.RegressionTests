/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAuthenticationServerTokenConsume')
	DROP PROCEDURE spAuthenticationServerTokenConsume
GO
CREATE PROCEDURE dbo.spAuthenticationServerTokenConsume
(
	@TokenKey NVARCHAR(256)
)
AS

	-- return token values
	SELECT TokenKey, PlainText,	CipherText,	ApiID,	Created
	FROM AuthenticationServerTokens
	WHERE TokenKey = @TokenKey

	IF (@@Rowcount <> 0)
	BEGIN
		-- expire token by removing it
		DELETE FROM AuthenticationServerTokens
		WHERE TokenKey = @TokenKey
	END	
	
GO
