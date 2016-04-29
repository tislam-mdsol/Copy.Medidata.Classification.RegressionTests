/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Bonnie Pan bpan@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoderQueryHistoryUpdate')
	DROP PROCEDURE spCoderQueryHistoryUpdate
GO
CREATE PROCEDURE dbo.spCoderQueryHistoryUpdate
(
	@QueryHistoryId INT,
	@QueryRepeatKey NVARCHAR(50),
	@QueryStatus TINYINT,
	@PriorQueryStatus TINYINT,
	@Recipient NVARCHAR (450),
	@QueryText NVARCHAR(4000), 
	@QueryResponse NVARCHAR(4000),
	@UserRef NVARCHAR(100),
	@DateTimeStamp DATETIME,
	@QueryId INT
)
AS	
BEGIN

	
	UPDATE CoderQueryHistory
	SET
		QueryRepeatKey = @QueryRepeatKey,
		QueryStatus = @QueryStatus,
		PriorQueryStatus = @PriorQueryStatus,
		Recipient = @Recipient,
		QueryText = @QueryText,
		QueryResponse = @QueryResponse,
		UserRef = @UserRef,
		DateTimeStamp =@DateTimeStamp,
		QueryId = @QueryId
	 WHERE QueryHistoryId = @QueryHistoryId
	 	
END
GO  