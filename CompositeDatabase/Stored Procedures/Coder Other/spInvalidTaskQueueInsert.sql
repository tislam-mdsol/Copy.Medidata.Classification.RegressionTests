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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spInvalidTaskQueueInsert')
	DROP PROCEDURE spInvalidTaskQueueInsert
GO
CREATE PROCEDURE dbo.spInvalidTaskQueueInsert
(
	@TaskId INT,
	@Succeeded BIT,
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@InvalidTaskQueueId INT OUTPUT
)
AS
BEGIN

	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  

	INSERT INTO InvalidTaskQueue (  
		TaskId,
		Succeeded,

		Created,
		Updated
	) VALUES (  
		@TaskId,
		@Succeeded,

		@Created,
		@Updated
	)  
	
	SET @InvalidTaskQueueId = SCOPE_IDENTITY()  	

END
GO  
  