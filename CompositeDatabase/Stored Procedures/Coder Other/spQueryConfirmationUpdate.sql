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

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spQueryConfirmationUpdate')
	DROP PROCEDURE dbo.spQueryConfirmationUpdate
GO
  
CREATE PROCEDURE dbo.spQueryConfirmationUpdate (  
	@QueryConfirmationId BIGINT,  

	@QueryHistoryId BIGINT,
	@SystemActionId TINYINT,
	@FailureCount INT,
	@Succeeded BIT,
	@SegmentID INT
)  
AS  
BEGIN

	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
 
	UPDATE dbo.QueryConfirmations SET  

		FailureCount = @FailureCount,
		Succeeded = @Succeeded,
		
		-- immutable properties
		--@SegmentID,
		--@QueryHistoryId,
		--@SystemActionId,

		Updated = @UtcDate
	WHERE QueryConfirmationId = @QueryConfirmationId
 
END  
GO