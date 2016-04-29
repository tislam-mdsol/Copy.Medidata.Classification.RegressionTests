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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTimeElapsedResolveDateTime')
	BEGIN
		DROP Procedure spTimeElapsedResolveDateTime
	END
GO	

-- get the datetime linked to passed
CREATE procedure [dbo].spTimeElapsedResolveDateTime
(
	@TimeElapsed INT,
	@Today DATETIME,
	@SegmentId INT, -- this might be configurable in the future
	@MaxAllowedDatetimeElapsed DATETIME OUTPUT,
	@MinAllowedDatetimeElapsed DATETIME OUTPUT
)
AS
BEGIN

	DECLARE @MaxAllowedSecondsElapsed INT, 
		@MinAllowedSecondsElapsed INT

	EXECUTE spTimeElapsedResolve @TimeElapsed, @SegmentId, 
		@MaxAllowedSecondsElapsed OUTPUT, @MinAllowedSecondsElapsed OUTPUT
		
	-- given the time allowed, generate the datetimes
	
	SELECT @MaxAllowedDatetimeElapsed = DATEADD(second, -@MaxAllowedSecondsElapsed, @Today),
		@MinAllowedDatetimeElapsed = DATEADD(second, -@MinAllowedSecondsElapsed, @Today)

END 


  