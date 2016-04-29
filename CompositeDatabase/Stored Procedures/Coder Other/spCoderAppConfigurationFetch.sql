/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoderAppConfigurationFetch')
	DROP PROCEDURE spCoderAppConfigurationFetch
GO
CREATE PROCEDURE dbo.spCoderAppConfigurationFetch
AS
	
	-- ignore the id here
	SELECT TOP 1 *
	FROM CoderAppConfiguration
	WHERE Active = 1
	ORDER BY Created DESC
	
GO  
  