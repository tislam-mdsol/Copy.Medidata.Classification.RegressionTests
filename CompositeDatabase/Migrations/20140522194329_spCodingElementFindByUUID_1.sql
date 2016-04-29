/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Connor Ross cross@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementFindByUUID')
	DROP PROCEDURE spCodingElementFindByUUID
GO

CREATE PROCEDURE dbo.spCodingElementFindByUUID (
	@SourceSystemId INT,
	@UUID NVARCHAR(100))
AS

BEGIN
	SELECT *
	FROM dbo.CodingElements
	WHERE 
	SourceSystemId = @SourceSystemId
	AND UUID = @UUID
END

GO