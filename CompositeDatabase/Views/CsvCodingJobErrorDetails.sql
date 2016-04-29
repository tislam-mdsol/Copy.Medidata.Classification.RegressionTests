IF EXISTS 
    (SELECT NULL FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'CsvCodingJobErrorDetails')
    DROP VIEW CsvCodingJobErrorDetails
GO
CREATE VIEW [dbo].[CsvCodingJobErrorDetails]
AS
    ( SELECT    E.* ,
                R.SourceSystemId ,
                COALESCE(CSV.FileName, '') AS [FileName] ,
                COALESCE(CSV.UserID, '') AS [UserId]
      FROM      dbo.CodingJobErrors (NOLOCK) E
	            JOIN dbo.CodingRequestCsvData CSV (NOLOCK) ON CSV.CodingRequestId = E.CodingRequestId
                JOIN dbo.CodingRequests R (NOLOCK) ON E.CodingRequestId = R.CodingRequestId
    )
GO

