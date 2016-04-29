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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWebRequestETagInsert')
	BEGIN
		DROP  Procedure  spWebRequestETagInsert
	END

GO

CREATE Procedure dbo.spWebRequestETagInsert
	(
		@Url VARCHAR(256),
		@ETag VARCHAR(128),
		@Created DATETIME OUTPUT,
		@Updated DATETIME OUTPUT,
		@WebRequestETagID BIGINT OUTPUT
	)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
  
	INSERT INTO WebRequestETag (  
		Url,
		ETag,
		Created,
		Updated
	) VALUES (  
		@Url,
		@ETag,
		@Created,
		@Updated
	)  
	
	SET @WebRequestETagID = SCOPE_IDENTITY()  	
	
END
GO
 