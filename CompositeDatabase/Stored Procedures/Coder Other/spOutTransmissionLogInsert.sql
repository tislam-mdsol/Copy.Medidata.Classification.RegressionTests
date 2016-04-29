/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spOutTransmissionLogInsert')
	BEGIN
		DROP  Procedure  spOutTransmissionLogInsert
	END

GO

CREATE Procedure dbo.spOutTransmissionLogInsert
(
	@ObjectId BIGINT,
	@OutTransmissionID BIGINT,
	@TransmissionQueueItemId BIGINT,
	@Succeeded BIT,
	@ResponseVerificationCode VARCHAR(100),
	
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@OutTransmissionLogID INT OUTPUT
)
AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO OutTransmissionLogs (  
		ObjectId,
		OutTransmissionID,
		TransmissionQueueItemId,
		Succeeded,
		ResponseVerificationCode,
		Created,
		Updated
	) VALUES (  
		@ObjectId,
		@OutTransmissionID,
		@TransmissionQueueItemId,
		@Succeeded,
		@ResponseVerificationCode,
		@Created,
		@Updated
	)  
	
	SET @OutTransmissionLogID = SCOPE_IDENTITY()  	
	
END
GO
  