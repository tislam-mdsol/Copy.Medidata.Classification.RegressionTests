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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGroupVerbatimJpnGetByVerbatimLocale')
	DROP PROCEDURE spGroupVerbatimJpnGetByVerbatimLocale
GO
CREATE PROCEDURE dbo.spGroupVerbatimJpnGetByVerbatimLocale
(
	@Verbatim NVARCHAR(450)
)
AS

	SELECT TOP 1 * 
	FROM GroupVerbatimJpn
	WHERE VerbatimText = @Verbatim
	
GO   