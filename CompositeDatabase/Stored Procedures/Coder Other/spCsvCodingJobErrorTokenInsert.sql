IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCsvCodingJobErrorTokenInsert')
	DROP PROCEDURE [spCsvCodingJobErrorTokenInsert]
GO
CREATE PROCEDURE [dbo].[spCsvCodingJobErrorTokenInsert]
    (
      @CodingJobErrorId INT ,
	  @TokenString VARCHAR(MAX) 
    )
AS 
    BEGIN
    
	    INSERT INTO CsvCodingJobErrorToken
                ( CodingJobErrorId ,
                  TokenString 
                )
        VALUES  ( @CodingJobErrorId ,
                  @TokenString
                )
    END
GO


 