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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementLoadStuckTasks')
	DROP Procedure spCodingElementLoadStuckTasks
GO

CREATE PROCEDURE [dbo].spCodingElementLoadStuckTasks
(
	@MaxFailureCount INT,
	@ResetIntervalInMinutes INT
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @LeastDate DATETIME = DATEADD(minute, 0-@ResetIntervalInMinutes, GETUTCDATE())
	
	SELECT SegmentId, COUNT(*) AS TotalTasks 
	FROM CodingElements CE
	WHERE FailureCount < @MaxFailureCount
		  AND IsStillInService = 1
		  AND Updated < @LeastDate
	GROUP BY SegmentId

END	