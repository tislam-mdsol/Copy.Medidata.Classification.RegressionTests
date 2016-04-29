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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spHealthCheckLoadExtended')
	DROP PROCEDURE spHealthCheckLoadExtended
GO

CREATE PROCEDURE dbo.spHealthCheckLoadExtended
AS
BEGIN

	SELECT HC.*, Y.LastRunID AS HealthCheckRunID, Y.LastRunDate AS TestRun, X.ErrorCount
	FROM HealthChecksR HC
		CROSS APPLY
		(
			SELECT LastRunID = MAX(HealthCheckRunID),
				LastRunDate = MAX(Created)
			FROM HealthCheckRuns
			WHERE HealthCheckID = HC.HealthCheckID
		) AS Y
		CROSS APPLY 
		(
			SELECT ErrorCount = ISNULL(SUM(ErrorCount), 0)
			FROM HealthCheckStatistics
			WHERE HealthCheckRunID = Y.LastRunID
		) AS X
	WHERE IsValid = 1
		

END 
