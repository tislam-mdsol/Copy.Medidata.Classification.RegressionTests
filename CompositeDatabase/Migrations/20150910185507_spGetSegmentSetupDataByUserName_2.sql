
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spGetSegmentSetupDataByUserName')
DROP PROCEDURE dbo.spGetSegmentSetupDataByUserName
GO

CREATE PROCEDURE [dbo].spGetSegmentSetupDataByUserName
( 
  @UserName		NVARCHAR(255),
  @IsProductionStudy	BIT
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

	DECLARE @UsersAndSegments TABLE(
		UserName	NVARCHAR(255), 
		SegmentName NVARCHAR(255),
		ProjectName NVARCHAR(255))

	
	INSERT INTO @UsersAndSegments(UserName, SegmentName, ProjectName)
	VALUES 
	(	'coderadmin',	'Mediflex'		,	'Mediflexs'		),
	(	'coder1'	,	'Mediflex'		,	'Mediflexs'		),
	(	'coder2'	,	'Mediflex1'		,	'Mediflexs1'	),
	(	'coder3'	,	'Mediflex2'		,	'Mediflexs2'	),
	(	'coder4'	,	'Mediflex3'		,	'Mediflexs3'	),
	(	'coder5'	,	'Mediflex4'		,	'Mediflexs4'	),
	(	'coder6'	,	'Mediflex5'		,	'Mediflexs5'	),
	(	'coder7'	,	'Mediflex6'		,	'Mediflexs6'	),
	(	'coder8'	,	'Mediflex7'		,	'Mediflexs7'	),
	(	'coder9'	,	'Mediflex8'		,	'Mediflexs8'	),
	(	'coder10'	,	'Mediflex9'		,	'Mediflexs9'	),
	(	'coder11'	,	'Mediflex10'	,	'Mediflexs10'	),
	(	'coder12'	,	'Mediflex11'	,	'Mediflexs11'	),
	(	'coder13'	,	'Mediflex12'	,	'Mediflexs12'	),
	(	'coder14'	,	'Mediflex13'	,	'Mediflexs13'	),
	(	'coder15'	,	'Mediflex14'	,	'Mediflexs14'	),
	(	'coder16'	,	'Mediflex15'	,	'Mediflexs15'	),
	(	'coder17'	,	'Mediflex16'	,	'Mediflexs16'	),
	(	'coder18'	,	'Mediflex17'	,	'Mediflexs17'	),
	(	'coder19'	,	'Mediflex18'	,	'Mediflexs18'	),
	(	'coder20'	,	'Mediflex19'	,	'Mediflexs19'	)


	DECLARE @SegmentId						INT 
	DECLARE	@SegmentName					NVARCHAR(255) 
	DECLARE	@ProjectName					NVARCHAR(255) 
	DECLARE	@SourceSystemStudyName			NVARCHAR(255) 
	DECLARE	@SourceSystemStudyDisplayName	NVARCHAR(255) 
	DECLARE	@StudyOid						NVARCHAR(255) 

	SELECT @SegmentName = SegmentName, @ProjectName = ProjectName
	FROM @UsersAndSegments
	WHERE UserName = @UserName

	SELECT @SegmentId = SegmentId 
	FROM Segments
	WHERE SegmentName = @SegmentName

	IF @SegmentId IS NULL
    BEGIN
        PRINT N'Cant find segment: ' + @SegmentName
    END

	IF @IsProductionStudy = 1
	BEGIN
		SELECT @StudyOid = ExternalObjectId, @SourceSystemStudyName = ExternalObjectName, @SourceSystemStudyDisplayName = ExternalObjectName + ' - ' + ExternalObjectOId
		FROM TrackableObjects
		WHERE Segmentid = @SegmentId
		AND ExternalObjectOId = @ProjectName
	END
	ELSE
	BEGIN
		SELECT @StudyOid = ExternalObjectId,  @SourceSystemStudyName = ExternalObjectName, @SourceSystemStudyDisplayName = ExternalObjectName + ' - ' + ExternalObjectOId
		FROM TrackableObjects
		WHERE Segmentid = @SegmentId
		AND ExternalObjectOId = @ProjectName + 'Dev'
	END

	SELECT 
	@SegmentName As SegmentName,
	@ProjectName As ProjectName,
	@SourceSystemStudyName AS SourceSystemStudyName,
	@SourceSystemStudyDisplayName AS SourceSystemStudyDisplayName,
	@StudyOid AS StudyOid

END
