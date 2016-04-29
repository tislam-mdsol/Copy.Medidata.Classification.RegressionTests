IF EXISTS 
    (SELECT NULL FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'CodingRequestStatus')
    DROP VIEW CodingRequestStatus
GO
    CREATE VIEW CodingRequestStatus
AS
   SELECT  CR.CodingRequestId ,
            CR.SourceSystemId ,
            CR.FileOID ,
            CR.Created ,
            CR.SegmentId ,
            CR.ReferenceNumber ,
            COALESCE(CSV.FileName, '') AS [FileName] ,
            COALESCE(CSV.UserID, '') AS [UserId] ,
            CR.RequestState ,
            ( SELECT    COUNT(1)
              FROM      dbo.CodingElements CE
              WHERE     CE.CodingRequestId = CR.CodingRequestId
            ) SucceededCount ,
            ( SELECT    COUNT(1)
              FROM      dbo.CodingJobErrors ERR
              WHERE     ERR.CodingRequestId = CR.CodingRequestID
            ) FailureCount
    FROM    dbo.CodingRequestCsvData CSV
            JOIN dbo.CodingRequests CR ON CR.CodingRequestId = CSV.CodingRequestId
GO