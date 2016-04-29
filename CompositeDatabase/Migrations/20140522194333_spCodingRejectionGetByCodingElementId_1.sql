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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingRejectionGetByCodingElementId')
	DROP PROCEDURE spCodingRejectionGetByCodingElementId
GO
CREATE PROCEDURE dbo.spCodingRejectionGetByCodingElementId(
	@CodingElementId bigint
)
AS
	SELECT TOP 1 * FROM CodingRejections WHERE CodingElementID = @CodingElementId ORDER BY CodingRejectionID DESC
GO
