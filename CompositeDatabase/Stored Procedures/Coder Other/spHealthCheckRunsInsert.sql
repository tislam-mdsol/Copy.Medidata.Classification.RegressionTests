/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Donghan Wang dwang@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spHealthCheckRunsInsert')
	DROP PROCEDURE spHealthCheckRunsInsert
GO
create procedure dbo.spHealthCheckRunsInsert
(
	@HealthCheckRunID BIGINT OUTPUT,
	@HealthCheckID BIGINT,
	@Created DATETIME OUTPUT,
	@TimeEnded DATETIME OUTPUT
)
AS	

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @TimeEnded = @UtcDate  
	
	INSERT INTO HealthCheckRuns (  
		HealthCheckID,
		Created,
		TimeEnded
	) VALUES (  
		@HealthCheckID,
		@Created,
		@TimeEnded
	)  
	
	SET @HealthCheckRunID = SCOPE_IDENTITY()
END
GO