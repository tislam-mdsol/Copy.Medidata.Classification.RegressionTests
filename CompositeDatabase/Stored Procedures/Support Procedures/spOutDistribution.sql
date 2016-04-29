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

-- Produce a time distribution of Out Service statistics against a particular API (source system)

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spOutDistribution')
	DROP PROCEDURE spOutDistribution
GO
CREATE PROCEDURE dbo.spOutDistribution
(
	@apiId NVARCHAR(200),
	@timeSlotIntervalSeconds INT = 86400,
	@pastDays INT = 7
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	-- AV NOTE - Limit Past Look if in Prod
	DECLARE @prodDayLimit INT = 14
	
	IF EXISTS (SELECT NULL FROM CoderAppConfiguration
		WHERE IsProduction = 1)
	BEGIN
		IF (@pastDays > @prodDayLimit)
			SET @pastDays = @prodDayLimit
	END
	
	DECLARE @sourceSystemID INT

	SELECT @sourceSystemID = SourceSystemId
	FROM SourceSystems
	WHERE OID = @apiId

	IF (@sourceSystemID IS NULL)
	BEGIN
		PRINT 'Source System not found - please provide a correct APiId'
		RETURN
	END

	DECLARE @timeSlot TABLE(Id INT IDENTITY(1,1) PRIMARY KEY, MinTime DATETIME, MaxTime DATETIME)
	DECLARE @timeNow DATETIME = GETUTCDATE()
	DECLARE @startDateTime DATETIME = DATEADD(day, -@pastDays, @timeNow)
	DECLARE @tmIdx DATETIME = @startDateTime
	DECLARE @nxTmIdx DATETIME

	WHILE (@tmIdx < @timeNow)
	BEGIN
		SET @nxTmIdx = DATEADD(SECOND, @timeSlotIntervalSeconds, @tmIdx)
		INSERT INTO @timeSlot(MinTime, MaxTime) VALUES(@tmIdx, @nxTmIdx)
		
		SET @tmIdx = @nxTmIdx
	END

	;WITH xCTE
	AS
	(
		SELECT 
			SUM(CASE WHEN OT.HttpStatusCode = 200 THEN 0 ELSE 1 END) AS Errors, 
			SUM(CASE WHEN OT.HttpStatusCode = 200 THEN 1 ELSE 0 END) AS Successes,
			ISNULL(OT.HttpStatusCode, -1) AS HttpCode,
			TS.Id 
		FROM OutTransmissions OT
			JOIN @timeSlot TS
				ON OT.Created BETWEEN TS.MinTime AND TS.MaxTime -- multiple hits?
		WHERE OT.SourceSystemID = @sourceSystemID
			AND OT.Created >= @startDateTime
		GROUP BY ISNULL(OT.HttpStatusCode, -1), TS.Id
	)

	SELECT TS.Id, TS.MinTime, TS.MinTime, x.Errors, x.Successes, x.HttpCode
	FROM xCTE x
		JOIN @timeSlot TS
			ON x.Id = TS.Id
	ORDER BY TS.Id ASC

END
GO  