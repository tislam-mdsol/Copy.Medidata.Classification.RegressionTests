
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spGetRolesManagementSetupData')
DROP PROCEDURE dbo.spGetRolesManagementSetupData
GO

CREATE PROCEDURE [dbo].spGetRolesManagementSetupData
( 
  @UserName		NVARCHAR(255)
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
	(	'coderadmin',	'CVReg'	,	'CVRegs'	),
	(	'coder1'	,	'CVReg'	,	'CVRegs'	),
	(	'coder2'	,	'CVReg1'	,	'CVRegs1'	),
	(	'coder3'	,	'CVReg2'	,	'CVRegs2'	),
	(	'coder4'	,	'CVReg3'	,	'CVRegs3'	),
	(	'coder5'	,	'CVReg4'	,	'CVRegs4'	),
	(	'coder6'	,	'CVReg5'	,	'CVRegs5'	),
	(	'coder7'	,	'CVReg6'	,	'CVRegs6'	),
	(	'coder8'	,	'CVReg7'	,	'CVRegs7'	),
	(	'coder9'	,	'CVReg8'	,	'CVRegs8'	),
	(	'coder10'	,	'CVReg9'	,	'CVRegs9'	),
	(	'coder11'	,	'CVReg10'	,	'CVRegs10'	),
	(	'coder12'	,	'CVReg11'	,	'CVRegs11'	),
	(	'coder13'	,	'CVReg12'	,	'CVRegs12'	),
	(	'coder14'	,	'CVReg13'	,	'CVRegs13'	),
	(	'coder15'	,	'CVReg14'	,	'CVRegs14'	),
	(	'coder16'	,	'CVReg15'	,	'CVRegs15'	),
	(	'coder17'	,	'CVReg16'	,	'CVRegs16'	),
	(	'coder18'	,	'CVReg17'	,	'CVRegs17'	),
	(	'coder19'	,	'CVReg18'	,	'CVRegs18'	),
	(	'coder20'	,	'CVReg19'	,	'CVRegs19'	)


	DECLARE @SegmentId						INT 
	DECLARE	@SegmentName					NVARCHAR(255) 
	DECLARE	@ProjectName					NVARCHAR(255) 
	DECLARE	@StudyOid						NVARCHAR(255) 				

	SELECT 
			@SegmentName	= SegmentName, 
			@ProjectName	= ProjectName
	FROM	@UsersAndSegments
	WHERE	UserName		= @UserName

	SELECT 
			@SegmentId		= SegmentId 
	FROM	Segments
	WHERE	SegmentName		= @SegmentName

	IF @SegmentId IS NULL
    BEGIN
        PRINT N'Cant find segment: ' + @SegmentName
    END

	SELECT 
			@StudyOid						= ExternalObjectId
	FROM	TrackableObjects
	WHERE	Segmentid						= @SegmentId
	AND		ExternalObjectName				= @ProjectName

	SELECT 
		@SegmentName					As SegmentName,
		@ProjectName					As ProjectName,
		@StudyOid						AS StudyOid,
		@SegmentId						AS SegmentId

END
