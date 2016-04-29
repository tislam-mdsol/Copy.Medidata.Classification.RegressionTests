IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spGetStudyDataByProject')
DROP PROCEDURE spGetStudyDataByProject
GO


CREATE PROCEDURE [dbo].[spGetStudyDataByProject]
( 
  @SegmentName       NVARCHAR(255),
  @ProjectName       NVARCHAR(255)
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

    DECLARE	   @SegmentId                      INT
    DECLARE    @SourceSystemStudyName          NVARCHAR(255) 
    DECLARE    @SourceSystemStudyDisplayName   NVARCHAR(255) 
    DECLARE    @StudyOid                       NVARCHAR(255) 
    DECLARE    @ProtocolNumber                 NVARCHAR(255)

    SELECT 
            @SegmentId        = SegmentId 
    FROM    Segments
    WHERE    SegmentName        = @SegmentName

    IF @SegmentId IS NULL
    BEGIN
        PRINT N'Cant find segment: ' + @SegmentName
    END

    BEGIN
        SELECT 
                @StudyOid                     = ExternalObjectId, 
                @SourceSystemStudyName        = ExternalObjectName, 
                @SourceSystemStudyDisplayName = ExternalObjectName + ' - ' + ExternalObjectOId,
                @ProtocolNumber               = ExternalObjectOId
        FROM    TrackableObjects
        WHERE   Segmentid                     = @SegmentId
        AND     ExternalObjectName            = @ProjectName
    END

    SELECT
        @SourceSystemStudyName             AS SourceSystemStudyName,
        @SourceSystemStudyDisplayName      AS SourceSystemStudyDisplayName,
        @StudyOid                          AS StudyOid,
        @SegmentId                         AS SegmentId,
        @ProtocolNumber                    AS ProtocolNumber

END
GO


