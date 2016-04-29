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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spHealthCheckStatitsticsInsert')
	DROP PROCEDURE spHealthCheckStatitsticsInsert
GO

CREATE PROCEDURE dbo.spHealthCheckStatitsticsInsert
(
	@HealthCheckStatisticsID BIGINT OUTPUT,
	@HealthCheckRunID BIGINT,
	@SegmentID BIGINT,
	@ErrorCount BIGINT
)
AS	
BEGIN
	INSERT INTO HealthCheckStatistics (  
		HealthCheckRunID,
		SegmentID,
		ErrorCount 
	) VALUES (  
		@HealthCheckRunID,
		@SegmentID,
		@ErrorCount 
	)  
	
	SET @HealthCheckStatisticsID = SCOPE_IDENTITY()
END
GO      
 
 