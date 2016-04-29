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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spQueryConfirmationPending')
	DROP PROCEDURE spQueryConfirmationPending
GO

CREATE PROCEDURE [dbo].spQueryConfirmationPending
(
	@MaxFailureCount INT,
	@ResetIntervalInMinutes INT
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @LeastDate DATETIME = DATEADD(minute, 0-@ResetIntervalInMinutes, GETUTCDATE())
	
	SELECT SegmentId, COUNT(*) AS Totals
	FROM QueryConfirmations
	WHERE FailureCount < @MaxFailureCount
		AND Succeeded = 0
		AND (Updated < @LeastDate OR Created >= Updated)

	GROUP BY SegmentId

END	