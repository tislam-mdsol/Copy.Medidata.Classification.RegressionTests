IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[spPsOutQueueHealthBySegment]')
                    AND type IN ( N'P' , N'PC' ) ) 
    DROP PROCEDURE [dbo].[spPsOutQueueHealthBySegment]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[spPsOutQueueHealthBySegment]
AS 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @transmissionTypes TABLE(Id INT PRIMARY KEY, TypeName NVARCHAR(100))
INSERT INTO @transmissionTypes (Id, TypeName) 
VALUES(2251, 'PartialCodingDecisionMessage')
INSERT INTO @transmissionTypes (Id, TypeName) 
VALUES(2252, 'OpenQueryMessage')
INSERT INTO @transmissionTypes (Id, TypeName) 
VALUES(2253, 'CancelQueryMessage')
INSERT INTO @transmissionTypes (Id, TypeName) 
VALUES(2254, 'CodingRejectionMessage')
INSERT INTO @transmissionTypes (Id, TypeName) 
VALUES(2255, 'FullCodingDecisionMessage')

;WITH    health
          AS ( SELECT   s.SegmentName
                       ,s.SegmentId
                       ,COUNT(tq.TransmissionQueueItemID) 'Outqueue Item Count'
                       ,SUM(ISNULL(tq.FailureCount , 0)) 'Failure Count'
                       ,MIN(ISNULL(tq.Created , GETDATE())) 'Earliest Created Term'
                       ,DATEDIFF(HOUR ,
                                 MIN(ISNULL(tq.Created , GETDATE())) ,
                                 GETDATE()) 'Oldest Age In Hours'
                       ,AVG(DATEDIFF(HOUR , ISNULL(tq.Created , GETDATE()) ,
                                     GETDATE())) 'Average Age In Hours'
                       ,ISNULL(ot.TypeName , '') 'Message Type'
               FROM     Segments s
                        LEFT JOIN dbo.TransmissionQueueItems tq ON tq.SegmentID = s.SegmentId
                        LEFT JOIN dbo.OutTransmissions outTrans ON tq.OutTransmissionID = outTrans.OutTransmissionID
                        LEFT JOIN @transmissionTypes ot ON tq.ObjectTypeID = ot.Id
               WHERE    1 = 1
                        AND ( tq.FailureCount = 0
                              OR tq.ServiceWillContinueSending = 1
                            )
                        AND tq.SuccessCount = 0
                        AND IsForUnloadService = 0
                        AND outTrans.OutTransmissionID IS NULL
               GROUP BY s.SegmentId
                       ,s.SegmentName
                       ,ISNULL(ot.TypeName , '')
             )
    SELECT  s.SegmentName
           ,s.SegmentId
           ,ISNULL(h.[Outqueue Item Count] , 0) 'Outqueue Item Count'
           ,ISNULL(h.[Failure Count] , 0) 'Failure Count'
           ,h.[Earliest Created Term]
           ,ISNULL(h.[Oldest Age In Hours] , 0) 'Oldest Age In Hours'
           ,ISNULL(h.[Average Age In Hours] , 0) 'Average Age In Hours'
           ,ISNULL(h.[Message Type] , '') 'Message Type'
    FROM    dbo.Segments s
            LEFT JOIN health h ON s.SegmentId = h.SegmentId
    ORDER BY 6 DESC
           ,3 DESC
           ,8
GO