 


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND 
			name = 'spMetricsRunner')
	BEGIN
		DROP Procedure dbo.spMetricsRunner
	END
GO	

CREATE procedure dbo.spMetricsRunner
(
	@pastDays INT = 7,
	@timeSlotIntervalSeconds	INT = 86400, -- Default 1 day
	@EndTime DATETIME = NULL
) 
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF @EndTime IS NULL
	BEGIN
		SET @EndTime = GETUTCDATE()
	END

	-- AV NOTE - Limit Past Look if in Prod
	DECLARE @prodDayLimit INT = 14
	DECLARE @Metrics TABLE(Metric NVARCHAR(MAX), [Count] BIGINT)
	DECLARE @AllMetrics TABLE(Metric NVARCHAR(MAX), [Count] BIGINT, EndTime DATETIME)
	DECLARE @timeSlot TABLE(Id INT IDENTITY(1,1) PRIMARY KEY, MinTime DATETIME, MaxTime DATETIME)
	DECLARE @startDateTime DATETIME = DATEADD(day, -@pastDays, @EndTime)
	DECLARE @tmIdx DATETIME = @startDateTime
	DECLARE @nxTmIdx DATETIME

	IF EXISTS (SELECT NULL FROM CoderAppConfiguration
		WHERE IsProduction = 1)
	BEGIN
		IF (@pastDays > @prodDayLimit)
			SET @pastDays = @prodDayLimit
	END

	WHILE (@tmIdx < @EndTime)
	BEGIN
		SET @nxTmIdx = DATEADD(SECOND, @timeSlotIntervalSeconds, @tmIdx)
		INSERT INTO @timeSlot(MinTime, MaxTime) VALUES(@tmIdx, @nxTmIdx)

		SET @tmIdx = @nxTmIdx
	END
	
	DECLARE @TargetTimeSlotId INT, @Start DATETIME, @END DATETIME
	DECLARE curTimeSlot CURSOR FOR  
	SELECT ID from @timeSlot   
	    
	OPEN curTimeSlot  
	FETCH curTimeSlot INTO @TargetTimeSlotId 
	WHILE (@@FETCH_STATUS = 0) 
	BEGIN
		
		SELECT @Start = MinTime, @END = MaxTime
		FROM @timeSlot
		WHERE Id = @TargetTimeSlotId
		
		INSERT INTO @Metrics(Metric, [Count])
		EXEC dbo.spMetrics -1, -1, @Start, @END
			
		INSERT INTO @AllMetrics(Metric, [Count], EndTime)
		SELECT Metric, [Count],@END
		FROM @Metrics
			
		DELETE @Metrics
		
		FETCH curTimeSlot INTO @TargetTimeSlotId 
	END  
	CLOSE curTimeSlot  
	DEALLOCATE curTimeSlot
	
	SELECT *
	FROM @AllMetrics
END
GO  