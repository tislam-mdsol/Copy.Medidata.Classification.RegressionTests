IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCommunicationTally')
	DROP PROCEDURE spCommunicationTally
GO

--EXEC spCommunicationTally 62

CREATE PROCEDURE dbo.spCommunicationTally
(
	@segmentId INT,
	@startDate DATETIME = NULL, -- include all
	@endDate DATETIME = NULL -- include all
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @minDate DATETIME, @maxDate DATETIME

	SELECT TOP 1 @minDate = Created FROM OutTransmissionLogs ORDER BY OutTransmissionLogId ASC
	SELECT TOP 1 @maxDate = Created FROM OutTransmissionLogs ORDER BY OutTransmissionLogId DESC

	;WITH allTransmissions AS
	(
		SELECT 
			ISNULL(OT.HttpStatusCode, 0) AS HttpStatusCode,
			CASE WHEN OT.ResponseText IS NOT NULL AND SUBSTRING(OT.ResponseText, 1, 1) = '<' THEN 1 ELSE 0 END
			AS RwsResponse,
			OT.ResponseText
		FROM TransmissionQueueItems TQI
			JOIN OutTransmissionLogs OTL
				ON TQI.TransmissionQueueItemID = OTL.TransmissionQueueItemId
				AND OTL.Created BETWEEN ISNULL(@startDate, @minDate) AND ISNULL(@endDate, @maxDate)
			JOIN OutTransmissions OT
				ON OT.OutTransmissionID = OTL.OutTransmissionID
		WHERE TQI.SegmentID = @SegmentId
			-- only coding decisions
			AND TQI.ObjectTypeID IN (2255, 2251)
	)
	,resolvedResponses AS
	(
		SELECT
			HttpStatusCode,
				CAST(REPLACE(CAST(ResponseText AS NVARCHAR(MAX)), 'encoding="utf-8"', 'encoding="utf-16"') AS XML).query('.')
			 AS XC
		FROM allTransmissions
		WHERE RwsResponse = 1
	)
	,processedResponses AS
	(
		SELECT 
			HttpStatusCode,
			ISNULL(CL.DT.value('@ReasonCode','VARCHAR(20)'), '') AS ReasonCode
		FROM resolvedResponses
			CROSS APPLY XC.nodes('Response') CL(DT)
	)
	,talliedRespones AS
	(
		SELECT TOP 100
			HttpStatusCode, ReasonCode, COUNT(*) AS CC
		FROM processedResponses
		GROUP BY HttpStatusCode, ReasonCode
	)
	,talliedNoResponses AS
	(
		SELECT TOP 100
			 HttpStatusCode, COUNT(*) AS CC
		FROM allTransmissions
		WHERE RwsResponse = 0
		GROUP BY HttpStatusCode
	)
	,totalTallies AS
	(
		SELECT HttpStatusCode, ReasonCode, CC
		FROM talliedRespones
		UNION ALL
		SELECT HttpStatusCode, 'NoResponseReceived' AS ReasonCode, CC
		FROM talliedNoResponses
	)

	SELECT *
	FROM totalTallies
	ORDER BY HttpStatusCode


END
GO  
