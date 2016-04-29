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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMOTDAuditGetLastByLocale')
	DROP PROCEDURE spMOTDAuditGetLastByLocale
GO

CREATE PROCEDURE dbo.spMOTDAuditGetLastByLocale 
(
	@Locale CHAR(3)
)  
AS  
BEGIN  

	SELECT TOP 1 *
	FROM MOTDAudits
	WHERE Locale = @Locale
	ORDER BY MOTDAuditID DESC

END

GO
  