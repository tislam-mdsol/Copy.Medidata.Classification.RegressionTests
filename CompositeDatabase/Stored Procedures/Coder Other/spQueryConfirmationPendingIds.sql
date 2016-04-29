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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spQueryConfirmationPendingIds')
	DROP PROCEDURE spQueryConfirmationPendingIds
GO

CREATE PROCEDURE [dbo].spQueryConfirmationPendingIds
(
	@ResetIntervalInMinutes INT,
	@MaxFailureCount INT,
	@SegmentId INT
)
AS
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @LeastDate DATETIME = DATEADD(minute, 0-@ResetIntervalInMinutes, GETUTCDATE())

    ;With XCTE
    AS
    (
		SELECT TOP 1000 QueryConfirmationId
		FROM QueryConfirmations
		WHERE Succeeded = 0
			AND SegmentId = @SegmentId
			AND FailureCount < @MaxFailureCount
			AND (Updated < @LeastDate OR Created >= Updated)
    )

	--randomly chooses 1 item that matches the predicate	
	SELECT Top 1 QueryConfirmationId
	FROM XCTE
	ORDER BY newid()

END	

