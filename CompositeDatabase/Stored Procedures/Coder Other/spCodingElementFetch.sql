/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Mark Hwe mhwe@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementFetch')
	DROP PROCEDURE spCodingElementFetch
GO

CREATE PROCEDURE dbo.spCodingElementFetch 
(
	@CodingElementId bigint
)
AS

BEGIN
	SELECT *
	FROM dbo.CodingElements
	WHERE CodingElementId = @CodingElementId
END

GO