/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Matt Cochran mcochran@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingRequestCsvInsert')
	DROP PROCEDURE spCodingRequestCsvInsert
GO
CREATE PROCEDURE [dbo].[spCodingRequestCsvInsert]
    (
      @RequestState TINYINT ,
      @SourceSystemId INT ,
      @CreationDateTime DATETIME ,
      @ReferenceNumber CHAR(36) ,
      @FileOID NVARCHAR(500) ,
      @XmlContent NTEXT ,
      @BatchOID NVARCHAR(500) ,
      @Created DATETIME OUTPUT ,
      @Updated DATETIME OUTPUT ,
      @CodingRequestId BIGINT OUTPUT ,
      @SegmentId INT ,
      @FileName NVARCHAR(250) ,
      @UserId NVARCHAR(50)
    )
AS 
    BEGIN
        DECLARE @UtcDate DATETIME
        SET @UtcDate = GETUTCDATE()
        SELECT  @Created = @UtcDate ,
                @Updated = @UtcDate

        INSERT  INTO CodingRequests
                ( RequestState ,
                  SourceSystemId ,
                  SegmentId ,
                  CreationDateTime ,
                  ReferenceNumber ,
                  FileOID ,
                  XmlContent ,
                  BatchOID ,
                  Created ,
                  Updated
                )
        VALUES  ( @RequestState ,
                  @SourceSystemId ,
                  @SegmentId ,
                  @CreationDateTime ,
                  @ReferenceNumber ,
                  @FileOID ,
                  @XmlContent ,
                  @BatchOID ,
                  @UtcDate ,
                  @UtcDate
                )

        SET @CodingRequestId = SCOPE_IDENTITY()
	
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

GO


 