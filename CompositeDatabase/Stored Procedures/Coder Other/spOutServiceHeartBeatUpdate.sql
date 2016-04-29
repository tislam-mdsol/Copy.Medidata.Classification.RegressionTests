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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spOutServiceHeartBeatUpdate')
	DROP PROCEDURE spOutServiceHeartBeatUpdate
GO

CREATE PROCEDURE dbo.spOutServiceHeartBeatUpdate 
(
	@OutServiceHeartBeatID INT,
	@SourceTransmissionsReceived BIGINT,
	@Created DATETIME,  
	@Updated DATETIME OUTPUT
	
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE OutServiceHeartBeats
	SET
		SourceTransmissionsReceived = @SourceTransmissionsReceived,
		Updated = @Updated
	 WHERE OutServiceHeartBeatID = @OutServiceHeartBeatID

END

GO  