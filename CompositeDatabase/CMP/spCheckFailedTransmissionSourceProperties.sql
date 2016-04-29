IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCheckFailedTransmissionSourceProperties')
	DROP PROCEDURE spCheckFailedTransmissionSourceProperties
GO

-- spCheckFailedTransmissionSourceProperties 10, 'Janssen', 0

CREATE PROCEDURE dbo.spCheckFailedTransmissionSourceProperties
(
	@lastDayPeriod INT,
	@segmentName VARCHAR(250),
	@includeSuccesses BIT
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @updatedFloor DATETIME = DATEADD(day, -ISNULL(@lastDayPeriod,10), GETUTCDATE()),
		@segmentId INT

	SELECT @segmentId = SegmentId 
	FROM Segments
	WHERE SegmentName = @segmentName

	IF (@segmentId IS NULL)
	BEGIN
		SELECT 'Cannot find Segment'
		RETURN 0
	END

	DECLARE @messageTypeTable TABLE(Id INT PRIMARY KEY, Name NVARCHAR(250))

	INSERT INTO @messageTypeTable(Id, Name)
	VALUES 
		(2251, 'PartialCodingDecisionMessage'),
		--(2252, 'OpenQueryMessage'),
		--(2253, 'CancelQueryMessage'),
		--(2254, 'CodingRejectionMessage'),
		(2255, 'FullCodingDecisionMessage')

	;WITH xCTE
	AS
	(
		SELECT 
			CE.SourceField, 
			CE.SourceForm, 
			CE.SourceSubject, 
			TQI.ObjectTypeId, 
			SDV.StudyID,
			SUM(TQI.FailureCount) AS FailureCount
		FROM TransmissionQueueItems	TQI
			JOIN CodingAssignment CA
				ON TQI.ObjectID = CA.CodingAssignmentID
				AND TQI.ObjectTypeID IN (2251, 2255)
			JOIN CodingElements CE
				ON CE.CodingElementId = CA.CodingElementID
			JOIN StudyDictionaryVersion SDV
				ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
		WHERE TQI.SegmentID = @segmentId
			AND TQI.Updated < @updatedFloor
			AND TQI.FailureCount > 0
			AND TQI.SuccessCount IN (0, ISNULL(@includeSuccesses, 0))
		GROUP BY CE.SourceField, CE.SourceForm, CE.SourceSubject, SDV.StudyID, TQI.ObjectTypeId
	)

	SELECT x.SourceField, x.SourceForm, x.SourceSubject, TOS.ExternalObjectName, t.Name, x.FailureCount
	FROM xCTE x
		JOIN @messageTypeTable t
			ON x.ObjectTypeID = t.Id
		JOIN TrackableObjects TOS
			ON TOS.TrackableObjectID = x.StudyID
	ORDER BY FailureCount DESC

END
