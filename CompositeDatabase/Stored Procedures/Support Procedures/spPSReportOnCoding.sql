IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spPSReportOnCoding')
	DROP PROCEDURE dbo.spPSReportOnCoding
GO

CREATE PROCEDURE [dbo].[spPSReportOnCoding]
(
	@BeginUTCDate DATETIME,
	@EndUTCDate DATETIME
)
AS
 BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @mainData TABLE(
		StudyDictionaryVersionId INT, 
		YY VARCHAR(4), 
		MM VARCHAR(2), 
		NotCoded INT, 
		ManuallyCoded INT, 
		AutoCoded INT)

	INSERT INTO  @mainData (StudyDictionaryVersionId, YY, MM, NotCoded, ManuallyCoded, AutoCoded) 
	SELECT CE.StudyDictionaryVersionId, DATEPART(YY, CE.Created), DATEPART(mm, CE.Created),
		SUM(CASE WHEN CA.IsAutoCoded = -1 THEN 1 ELSE 0 END),
		SUM(CASE WHEN CA.IsAutoCoded = 0 THEN 1 ELSE 0 END),
		SUM(CASE WHEN CA.IsAutoCoded = 1 THEN 1 ELSE 0 END)
	FROM CodingElements CE
		CROSS APPLY
		(
			SELECT ISNULL(MAX(
				CASE WHEN CA.IsAutoCoded = 1 THEN 1 ELSE 0 END), -1) AS IsAutoCoded
			FROM
			(
				SELECT TOP 1 ISNULL(CA.IsAutoCoded, 0) AS IsAutoCoded
				FROM CodingAssignment CA
				WHERE CA.CodingElementID = CE.CodingElementId
				ORDER BY CA.CodingAssignmentID ASC
			) AS CA
		) AS CA
	WHERE CE.Created BETWEEN @BeginUTCDate AND @EndUTCDate
	GROUP BY CE.StudyDictionaryVersionId, DATEPART(YY, CE.Created), DATEPART(mm, CE.Created)

	-- 1) summary summary
    SELECT  YY, MM, SUM(NotCoded), SUM(ManuallyCoded), SUM(AutoCoded)
    FROM    @mainData Coding
		JOIN StudyDictionaryVersion SDV ON SDV.StudyDictionaryVersionID = Coding.StudyDictionaryVersionId
        JOIN TrackableObjects T ON T.TrackableObjectId = SDV.StudyID AND T.IsTestStudy = 0
	GROUP BY YY, MM
	ORDER BY YY, MM

	-- 2) dictionary summary
    SELECT  DR.MedicalDictionaryType, SDV.DictionaryLocale,  YY, MM, SUM(NotCoded), SUM(ManuallyCoded), SUM(AutoCoded)
    FROM    @mainData Coding
		JOIN StudyDictionaryVersion SDV ON SDV.StudyDictionaryVersionID = Coding.StudyDictionaryVersionId
        JOIN TrackableObjects T ON T.TrackableObjectId = SDV.StudyID AND T.IsTestStudy = 0
		JOIN DictionaryRef DR ON DR.DictionaryRefID = SDV.MedicalDictionaryID
    GROUP BY YY, MM, DR.MedicalDictionaryType, SDV.DictionaryLocale
	ORDER BY DR.MedicalDictionaryType, YY, MM

	-- 3) detailed summary
    SELECT  S.SegmentName,
            T.ExternalObjectName AS Study ,
            ~T.IsTestStudy AS IsProdStudy ,
            DR.MedicalDictionaryType,
			SDV.DictionaryLocale,
            Coding.*
    FROM    @mainData Coding
            JOIN StudyDictionaryVersion SDV ON SDV.StudyDictionaryVersionID = Coding.StudyDictionaryVersionId
            JOIN TrackableObjects T ON T.TrackableObjectId = SDV.StudyID
            JOIN DictionaryVersionRef DV ON DV.DictionaryVersionRefID = SDV.DictionaryVersionId
            JOIN DictionaryRef DR ON DR.DictionaryRefID = DV.DictionaryRefID
            JOIN Segments S ON S.SegmentId = T.SegmentId
    ORDER BY SegmentName , Study

 END
GO