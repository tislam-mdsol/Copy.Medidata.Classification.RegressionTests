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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAuthenticationServerTokenStore')
	DROP PROCEDURE spAuthenticationServerTokenStore
GO
CREATE PROCEDURE dbo.spAuthenticationServerTokenStore
(
	@TokenKey NVARCHAR(256),
	@PlainText NVARCHAR(256),
	@CipherText NVARCHAR(256),
	@ApiID NVARCHAR(256),
	@Created DATETIME
)
AS

INSERT INTO AuthenticationServerTokens (  
		TokenKey,
		PlainText,
		CipherText,
		ApiID,
		Created
	) VALUES (  
		@TokenKey,
		@PlainText,
		@CipherText,
		@ApiID,
		@Created
	)  
	
GO
