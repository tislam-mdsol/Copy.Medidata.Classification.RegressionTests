IF EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spPSTasksPerVersion')
	DROP PROCEDURE dbo.spPSTasksPerVersion
GO

-- EXEC spPSTasksPerVersion 'HD_DDE_B2', '201312'

CREATE PROCEDURE [dbo].[spPSTasksPerVersion]
(
	@dictionaryOID VARCHAR(50),
	@versionOID VARCHAR(50)
)
AS
BEGIN

	DECLARE @dictionaryID INT
	DECLARE @versionID INT

	-- resolve OIDs into IDs
	SELECT @dictionaryID = DictionaryRefId
	FROM DictionaryRef
	WHERE OID = @dictionaryOID

	IF (@dictionaryID IS NULL)
	BEGIN
		PRINT 'Dictionary NOT FOUND'
		RETURN 0
	END

	SELECT @versionID = DictionaryVersionRefId
	FROM DictionaryVersionRef
	WHERE DictionaryRefId = @dictionaryID
		AND OID = @versionOID

	IF (@versionID IS NULL)
	BEGIN
		PRINT 'Version NOT FOUND'
		RETURN 0
	END

	;WITH 
		rawdata AS
		(
			SELECT sdv.*, CE.AssignedSegmentedGroupCodingPatternId, CE.CodingElementGroupID
			FROM CodingElements ce
				JOIN StudyDictionaryVersion sdv
					ON ce.StudyDictionaryVersionId = sdv.StudyDictionaryVersionID
				JOIN SynonymMigrationMngmt smm
					ON smm.SynonymMigrationMngmtID = sdv.SynonymManagementID
					and smm.dictionaryversionid = @versionID
		),
		groupedInternal AS 
		(
			SELECT COUNT(*) AS CC, StudyID, SegmentID, AssignedSegmentedGroupCodingPatternId, CodingElementGroupID
			FROM rawdata
			GROUP BY StudyID, SegmentID, AssignedSegmentedGroupCodingPatternId, CodingElementGroupID
		),
		groupedCoded AS
		(
			SELECT COUNT(CC) AS UniqueCodingDecisionsPerGroup, SUM(CC) AS TotalTasks, StudyID, SegmentID
			FROM groupedInternal
			WHERE AssignedSegmentedGroupCodingPatternId > 0
			GROUP BY StudyID, SegmentID
		),
		groupedNotCoded AS
		(
			SELECT 0 AS UniqueCodingDecisionsPerGroup, SUM(CC) AS TotalTasks, StudyID, SegmentID
			FROM groupedInternal
			WHERE ISNULL(AssignedSegmentedGroupCodingPatternId, 0) < 1
			GROUP BY StudyID, SegmentID
		)


	SELECT 'Coded' AS CodedStatus, g.*, t.ExternalObjectOID, s.SegmentName
	FROM groupedCoded g
		JOIN TrackableObjects t
			ON g.StudyID = t.TrackableObjectID
		JOIN segments s
			ON s.SegmentId = g.SegmentID
	UNION
	SELECT 'NOT Coded' AS CodedStatus, gnc.*, t.ExternalObjectOID, s.SegmentName
	FROM groupedNotCoded gnc
		JOIN TrackableObjects t
			ON gnc.StudyID = t.TrackableObjectID
		JOIN segments s
			ON s.SegmentId = gnc.SegmentID
	ORDER BY S.SegmentName, CodedStatus, t.ExternalObjectOID
 
END
