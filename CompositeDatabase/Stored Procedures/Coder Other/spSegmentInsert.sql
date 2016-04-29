/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentInsert')
	BEGIN
		DROP  Procedure dbo.spSegmentInsert
	END

GO

CREATE Procedure dbo.spSegmentInsert
(
	@OID VARCHAR(50),
	@Deleted BIT,
	@Active BIT,
	@SegmentName NVARCHAR(510),
	@UserDeactivated BIT,
	@IMedidataId NVARCHAR(100),
	
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@SegmentID INT OUTPUT
)
AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO Segments (  
		OID,
		Deleted,
		Active,
		SegmentName,
		UserDeactivated,
		IMedidataId,
		
		Created,
		Updated
	) VALUES (  
		@OID,
		@Deleted,
		@Active,
		@SegmentName,
		@UserDeactivated,
		@IMedidataId,
		
		@Created,
		@Updated
	)  
	
	SET @SegmentID = SCOPE_IDENTITY()  	
	
END
GO
  