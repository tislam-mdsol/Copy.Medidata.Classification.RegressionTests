/**
** Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami avardhami@mdsol.com
**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spQueryConfirmationInsert')
	DROP PROCEDURE dbo.spQueryConfirmationInsert
GO
  
CREATE PROCEDURE dbo.spQueryConfirmationInsert (  
	@QueryConfirmationId BIGINT OUTPUT,

	@QueryHistoryId BIGINT,
	@SystemActionId TINYINT,
	@FailureCount INT,
	@Succeeded BIT,
 
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@SegmentID INT
)  
AS
BEGIN  

	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
  
	INSERT INTO dbo.QueryConfirmations (
		QueryHistoryId,
		SystemActionId,
		FailureCount,
		Succeeded,
  
		Created,  
		Updated,
		SegmentID
	) VALUES (
		@QueryHistoryId,
		@SystemActionId,
		@FailureCount,
		@Succeeded,

 		@UtcDate,  
		@UtcDate,
		@SegmentID
	)

	SET @QueryConfirmationId = SCOPE_IDENTITY()  

END  
GO
