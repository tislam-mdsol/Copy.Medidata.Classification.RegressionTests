/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingRequestExistsForSourceSystem')
	BEGIN
		DROP  Procedure  spCodingRequestExistsForSourceSystem
	END

GO

CREATE Procedure dbo.spCodingRequestExistsForSourceSystem

	(
		@SourceSystemId INT,
		@Exists BIT OUTPUT
	)

AS

BEGIN

	SELECT @Exists = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
	FROM CodingRequests
	WHERE SourceSystemId = @SourceSystemId
	
END
GO
 