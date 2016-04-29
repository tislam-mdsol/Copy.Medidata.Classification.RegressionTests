
if exists (select * from sysobjects where name = 'spCoder_CMP_RetireSynonymIDs')
	drop procedure spCoder_CMP_RetireSynonymIDs
go

/*********************************************************************************************
-- Author:			Darshan Mehta
-- Created:			30 Dec 2015
-- Updated:			Dan Dapper, 4 Jan 2016
-- MCC				MCC-204887
-- Description:		Purpose: Retiring Provisional Synonyms Using Listed SegmentedGroupCodingPatternId

-- Paramenters:
	@SegmentName NVARCHAR(450) - Segment name,
	@MedicalDictionaryVersionLocaleKey NVARCHAR(MAX),
	@ListName	NVARCHAR(MAX),
	@WRNumber INT - Work Request Number
	@CommaDelimitedSegmentedGroupCodingPatternId NVARCHAR(MAX) - Comma Delimited Segmented Group Coding Pattern Ids

begin transaction
exec spCoder_CMP_RetireSynonymIDs
 @SegmentName = 'AZ2',
 @MedicalDictionaryVersionLocaleKey = 'MedDRA-18_1-English',
 @ListName ='SL-MedDRA-MH-18.1_Sep''2015 ',
 @WRNumber = 12345,
 @CommaDelimitedSegmentedGroupCodingPatternId =  
'10397855,10397961,10397968'
rollback

**********************************************************************************************/

CREATE PROCEDURE spCoder_CMP_RetireSynonymIDs
(
	@SegmentName VARCHAR(250),
	@MedicalDictionaryVersionLocaleKey NVARCHAR(MAX),
	@ListName NVARCHAR(MAX),
	@WRNumber INT,
	@CommaDelimitedSegmentedGroupCodingPatternId NVARCHAR(MAX)
)
AS
BEGIN
	DECLARE  
	@segmentId INT,
	@SynonymMigrationMngmtID INT,
	@errorString NVARCHAR(MAX),
	@runDT DATETIME=GETUTCDATE()
	
	
	DECLARE @SynonymsToRetire TABLE (SegmentedGroupCodingPatternId varchar(20) PRIMARY KEY, SegmentID INT, SynonymMigrationMngmtID INT)

	-- DROP TABLE BK_CMP_RetiredCodingPatterIDs
	IF NOT EXISTS (SELECT * FROM SYSOBJECTS WHERE NAME = 'BK_CMP_RetiredCodingPatterIDs')
		CREATE TABLE BK_CMP_RetiredCodingPatterIDs (
			WRNumber INT,
			SegmentedGroupCodingPatternId INT,
			Updated DATETIME,
			SynonymStatus bit,
			RunDT DATETIME
		)
 
	SELECT @segmentId = SegmentId 
		FROM Segments
		WHERE SegmentName = @SegmentName
	
	IF @segmentId IS NULL
	BEGIN
		SELECT 'Cannot find Segment'
		RETURN 0
	END
 

	SELECT @SynonymMigrationMngmtID = SynonymMigrationMngmtID 
		FROM SynonymMigrationMngmt
		WHERE SegmentId = @SegmentId
			and MedicalDictionaryVersionLocaleKey = @MedicalDictionaryVersionLocaleKey
			and ListName = @ListName
			and Deleted = 0

	IF @SynonymMigrationMngmtID IS NULL
	BEGIN
		SELECT 'Cannot find list'
		RETURN 0
	END

	
	INSERT INTO @SynonymsToRetire (
		SegmentedGroupCodingPatternId,
		SegmentId,
		SynonymMigrationMngmtID
	)
	SELECT
		replace(replace(item,char(10),''),char(13),'') as SegmentedGroupCodingPatternId, -1, -1
	FROM 
		dbo.fnParseDelimitedString(@CommaDelimitedSegmentedGroupCodingPatternId,',')
	

	UPDATE @SynonymsToRetire
		SET SegmentId = SGCP.SegmentId
	FROM @SynonymsToRetire T
	JOIN SegmentedGroupCodingPatterns SGCP ON SGCP.SegmentId = @SegmentId and SGCP.SegmentedGroupCodingPatternId  = T.SegmentedGroupCodingPatternId

	
	IF EXISTS (SELECT NULL FROM @SynonymsToRetire WHERE SegmentId <> @SegmentID)
	BEGIN
		SET @errorString = N'ERROR: SegmentedGroupCodingPatternIds are not in segment or do not exist!'
		SELECT * FROM @SynonymsToRetire WHERE SegmentId <> @SegmentID
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
		
	UPDATE @SynonymsToRetire
		SET SynonymMigrationMngmtID = SGCP.SynonymManagementId
	FROM @SynonymsToRetire T
	JOIN SegmentedGroupCodingPatterns SGCP ON SGCP.SegmentId = @SegmentId and SGCP.SegmentedGroupCodingPatternId  = T.SegmentedGroupCodingPatternId
 
	
	IF EXISTS (SELECT NULL FROM @SynonymsToRetire WHERE SynonymMigrationMngmtID <> @SynonymMigrationMngmtID)

	BEGIN
		SET @errorString = N'ERROR: SegmentedGroupCodingPatternIds are not in list or do not exist!'
		SELECT * FROM @SynonymsToRetire WHERE SegmentedGroupCodingPatternId <> @SynonymMigrationMngmtID
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	------------------------------------
	

	UPDATE SGCP SET	
		SynonymStatus = 0,
		Updated = @runDT,
		CacheVersion = CacheVersion + 10
	OUTPUT 
		@WRNUMBER,
		INSERTED.SegmentedGroupCodingPatternID,
		DELETED.Updated,
		DELETED.SynonymStatus,
		@RunDT
	INTO BK_CMP_RetiredCodingPatterIDs
		
	FROM @SynonymsToRetire S
	JOIN SegmentedGroupCodingPatterns SGCP ON SGCP.SegmentedGroupCodingPatternID = S.SegmentedGroupCodingPatternID
	WHERE SGCP.SynonymStatus = 1

	--SELECT SGCP.* 
	--FROM @SynonymsToRetire S
	--JOIN SegmentedGroupCodingPatterns SGCP 
	--ON SGCP.SegmentedGroupCodingPatternID = S.SegmentedGroupCodingPatternID
	--ORDER BY SGCP.SegmentedGroupCodingPatternID

	SELECT * FROM BK_CMP_RetiredCodingPatterIDs
	WHERE RunDT = @RunDT
	
	PRINT 'Retiring Synonyms succeeded!'	 
END