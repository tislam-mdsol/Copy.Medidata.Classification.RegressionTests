IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spTaskByProperty')
	DROP PROCEDURE dbo.spTaskByProperty
GO

CREATE PROCEDURE [dbo].[spTaskByProperty]

	@SegmentName NVARCHAR(255),
	@StudyName NVARCHAR(2000),
	@DictionaryOID VARCHAR(50),
	@DictionaryVersionOID VARCHAR(50),
	@DictionaryLocale CHAR(3),
	@SourceSubject NVARCHAR(100),
	@VerbatimTerm NVARCHAR(500),
	@SourceForm NVARCHAR(450),
	@SourceField NVARCHAR(450)

AS
BEGIN

	DECLARE @SegmentID INT

	SELECT @SegmentID = SegmentId
	FROM Segments
	WHERE SegmentName = @SegmentName

	IF (@SegmentID IS NULL)
		PRINT 'Unable to find segment'

	DECLARE @StudyDictionaryVersionId INT

	SELECT @StudyDictionaryVersionId = StudyDictionaryVersionID
	FROM StudyDictionaryVersion
	WHERE StudyId					= (SELECT TrackableObjectId FROM TrackableObjects
										WHERE ExternalObjectName = @StudyName)
		AND SegmentID				= @SegmentID
		AND DictionaryLocale		= @DictionaryLocale
		AND DictionaryVersionId = (SELECT DictionaryVersionId 
								FROM DictionaryVersionRef
								WHERE DictionaryRefID = (SELECT DictionaryRefID
													FROM DictionaryRef
													WHERE OID = @DictionaryOID)
									AND OID = @DictionaryVersionOID
									)

	IF (@StudyDictionaryVersionId IS NULL)
		PRINT 'Unable to find StudyDictionaryVersion'

	SELECT *
	FROM CodingElements
	WHERE StudyDictionaryVersionId = @StudyDictionaryVersionId
		AND SegmentId		= @SegmentID
		AND SourceSubject	= @SourceSubject
		AND VerbatimTerm	= @VerbatimTerm
		AND SourceForm		= @SourceForm
		AND SourceField		= @SourceField
 
END
GO
