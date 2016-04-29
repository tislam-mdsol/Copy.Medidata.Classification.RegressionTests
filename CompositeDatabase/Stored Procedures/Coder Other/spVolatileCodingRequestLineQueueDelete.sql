/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Connor Ross cross@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spVolatileCodingRequestLineQueueDelete')
	DROP PROCEDURE [spVolatileCodingRequestLineQueueDelete]
GO
CREATE PROCEDURE [dbo].[spVolatileCodingRequestLineQueueDelete]
    (
	  @CodingRequestId INT,
      @LineNumber INT
    )
AS 
    BEGIN

        DELETE FROM VolatileCodingRequestLineQueue
		WHERE LineNumber = @LineNumber AND CodingRequestId = @CodingRequestId

    END
GO


 