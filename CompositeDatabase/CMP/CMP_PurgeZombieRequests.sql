IF EXISTS ( SELECT  * 
            FROM    sysobjects
            WHERE   type = 'P'
                    AND name = 'CMP_PurgeZombieRequests' ) 
    DROP PROCEDURE CMP_PurgeZombieRequests
GO

CREATE PROCEDURE dbo.CMP_PurgeZombieRequests
    (
     @chunkSize INT = 200
    ,@RunMinutes INT = 180  -- stop condition
    ,@MaxCodingRequestId INT = 0 -- stop condition
    )
AS 
    BEGIN

        DECLARE @stopTime AS DATETIME = DATEADD(mi , @RunMinutes , GETDATE()) ;
    
        WHILE ( 1 = 1 ) 
            BEGIN

                DELETE TOP ( @chunkSize )
                FROM    CodingRequests
                WHERE   CodingRequestId NOT IN ( SELECT CodingRequestId
                                                 FROM   CodingElements )
                        AND CodingRequestId NOT IN (
                        SELECT  CodingRequestId
                        FROM    CodingRequestCsvData )
                        AND CodingRequestId < @MaxCodingRequestId
                            

                IF ( @@ROWCOUNT = 0 ) 
                    BREAK
        
                IF ( GETDATE() > @stopTime ) 
                    BREAK        

            END
    END

