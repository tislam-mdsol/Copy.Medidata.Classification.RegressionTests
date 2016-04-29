IF EXISTS ( SELECT  NULL
            FROM    SYSOBJECTS
            WHERE   type = 'P'
                    AND name = 'spPsSegmentStudyReport' ) 
    DROP PROCEDURE dbo.spPsSegmentStudyReport
GO

CREATE PROCEDURE spPsSegmentStudyReport
AS 
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT  seg.SegmentName
           ,t.ExternalObjectName StudyName
           ,seg.SegmentId
           ,t.ExternalObjectId StudyOid
    FROM    dbo.Segments seg
            JOIN dbo.TrackableObjects t ON t.SegmentId = seg.SegmentId
    ORDER BY seg.SegmentName
           ,t.ExternalObjectName
go