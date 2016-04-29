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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTimeElapsedResolve')
	BEGIN
		DROP Procedure spTimeElapsedResolve
	END
GO	

CREATE procedure [dbo].spTimeElapsedResolve
(
	@TimeElapsed INT,
	@SegmentId INT, -- this might be configurable in the future
	@MaxAllowedSecondsElapsed INT OUTPUT,
	@MinAllowedSecondsElapsed INT OUTPUT
)
AS
BEGIN

	DECLARE @MaxINT INT, 
		@HalfDaySeconds INT, 
		@DaySeconds INT, 
		@TwoDaySeconds INT, 
		@FiveDaySeconds INT

	SELECT @MaxINT = 2147483647,
		@HalfDaySeconds = 43200,
		@DaySeconds = 86400,
		@TwoDaySeconds = 172800,
		@FiveDaySeconds = 432000

	
	SELECT @MaxAllowedSecondsElapsed = @MaxINT,
		@MinAllowedSecondsElapsed = 0
		
	IF (@TimeElapsed = 1)
	BEGIN
		SET @MaxAllowedSecondsElapsed = @HalfDaySeconds - 1
	END
	ELSE IF (@TimeElapsed = 2)
	BEGIN
		SELECT @MaxAllowedSecondsElapsed = @DaySeconds - 1,
			@MinAllowedSecondsElapsed = @HalfDaySeconds
	END
	ELSE IF (@TimeElapsed = 3)
	BEGIN
		SELECT @MaxAllowedSecondsElapsed = @TwoDaySeconds - 1,
			@MinAllowedSecondsElapsed = @DaySeconds
	END
	ELSE IF (@TimeElapsed = 4) 
	BEGIN
		SELECT @MaxAllowedSecondsElapsed = @FiveDaySeconds- 1,
			@MinAllowedSecondsElapsed = @TwoDaySeconds
	END
	ELSE IF (@TimeElapsed = 5) 
	BEGIN
		SET @MinAllowedSecondsElapsed = @FiveDaySeconds
	END	

END 
 