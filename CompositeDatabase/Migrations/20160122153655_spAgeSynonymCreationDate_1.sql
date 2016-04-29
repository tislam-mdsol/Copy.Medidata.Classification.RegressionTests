IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spAgeSynonymCreationDate')
DROP PROCEDURE spAgeSynonymCreationDate
GO

CREATE PROCEDURE spAgeSynonymCreationDate
(
    @SegmentName  NVARCHAR(255),
    @VerbatimText NVARCHAR(255),
	@HoursToAge INT,
	@AgeCreatedOnly BIT
)
AS

BEGIN
	--production check
	IF NOT EXISTS (
		SELECT NULL 
		FROM CoderAppConfiguration
		WHERE Active = 1 AND IsProduction = 0)
	BEGIN
	  PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
	  RETURN
	END


	DECLARE @createdHoursToAge INT
	DECLARE @updatedHoursToAge INT
	Set @createdHoursToAge = @HoursToAge
	Set @updatedHoursToAge = @HoursToAge
   
	IF @AgeCreatedOnly = 1
	BEGIN
	  Set @updatedHoursToAge = 0
	END

  	UPDATE SynonymStatus   
	  SET SynonymStatus.Created = DATEADD(hour,  - @createdHoursToAge, SynonymStatus.Created) 
	   ,SynonymStatus.Updated = DATEADD(hour,  - @updatedHoursToAge, SynonymStatus.Updated) 
		
	  FROM [coder_v1].[dbo].segmentedGroupCodingPatterns as SynonymStatus

	  JOIN [coder_v1].[dbo].[CodingElementGroups] as ElementGroups
	  ON SynonymStatus.CodingElementGroupID = ElementGroups.CodingElementGroupID

	  JOIN [coder_v1].[dbo].[GroupVerbatimEng] as Verbatims
	  ON ElementGroups.GroupVerbatimID = Verbatims.GroupVerbatimID

	  JOIN  [coder_v1].[dbo].segments as Segments
	  ON SynonymStatus.SegmentID = Segments.SegmentID

	  Where Verbatims.VerbatimText = @VerbatimText
	  and
	  Segments.SegmentName = @SegmentName

END
