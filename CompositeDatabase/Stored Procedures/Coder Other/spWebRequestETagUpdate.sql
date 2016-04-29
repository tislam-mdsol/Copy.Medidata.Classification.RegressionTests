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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWebRequestETagUpdate')
	DROP PROCEDURE spWebRequestETagUpdate
GO

CREATE PROCEDURE dbo.spWebRequestETagUpdate 
(
	@WebRequestETagID BIGINT,
	@Url VARCHAR(256),
	@ETag VARCHAR(128),
	@Created DATETIME,  
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE WebRequestETag
	SET
		Url = @Url,  
		ETag = @ETag,  
		Updated = @Updated
	 WHERE WebRequestETagID = @WebRequestETagID

END

GO
