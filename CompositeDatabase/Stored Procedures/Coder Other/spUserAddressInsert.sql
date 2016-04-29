/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Donghan Wang dwang@mdsol.com
// ------------------------------------------------------------------------------------------------------*/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserAddressInsert')
	DROP PROCEDURE spUserAddressInsert
GO
CREATE PROCEDURE dbo.spUserAddressInsert
(
        @UserAddressID INT OUTPUT,
        @UserID INT,
        @IsPrimaryAddress BIT,
        @Email NVARCHAR(255),
        @Telephone NVARCHAR(32),
        @Facsimile NVARCHAR(32),
        @Pager NVARCHAR(32),
        @MobileNumber NVARCHAR(32),
        @TimeZone INT,
        @NetworkMask VARCHAR(255),
        @AddressLine1 VARCHAR(255),
        @AddressLine2 VARCHAR(255),
        @AddressLine3 VARCHAR(255),
        @City VARCHAR(255),
        @State VARCHAR(255),
        @PostalCode VARCHAR(255),
        @Country VARCHAR(255),
        @URL VARCHAR(255),
        @Active BIT,
        @InstitutionName VARCHAR(255),
        @LocationName VARCHAR(255),
        @SegmentId INT
)
AS
BEGIN
INSERT INTO UserAddresses (  
        UserID,
        IsPrimaryAddress,
        Email,
        Telephone,
        Facsimile,
        Pager,
        MobileNumber,
        TimeZone,
        NetworkMask,
        AddressLine1,
        AddressLine2,
        AddressLine3,
        City,
        State,
        PostalCode,
        Country,
        URL,
        Active,
        InstitutionName,
        LocationName,
        SegmentId
	) VALUES (  
        @UserID,
        @IsPrimaryAddress,
        @Email,
        @Telephone,
        @Facsimile,
        @Pager,
        @MobileNumber,
        @TimeZone,
        @NetworkMask,
        @AddressLine1,
        @AddressLine2,
        @AddressLine3,
        @City,
        @State,
        @PostalCode,
        @Country,
        @URL,
        @Active,
        @InstitutionName,
        @LocationName,
        @SegmentId
	)  
	SET @UserAddressID = SCOPE_IDENTITY()  	
END
GO      
