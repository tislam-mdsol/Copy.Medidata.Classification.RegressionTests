
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingRequestCsvDataInsert')
	DROP PROCEDURE dbo.[spCodingRequestCsvDataInsert]
GO
  CREATE PROCEDURE [dbo].[spCodingRequestCsvDataInsert]
    (
      @CodingRequestId INT ,
      @FileName NVARCHAR(250) ,
      @UserId NVARCHAR(50)
    )
AS 
    BEGIN
        INSERT  INTO dbo.CodingRequestCsvData
                ( CodingRequestId ,
                  FileName ,
                  UserID 
                )
        VALUES  ( @CodingRequestId ,
                  @FileName ,
                  @UserId
	          )
    END