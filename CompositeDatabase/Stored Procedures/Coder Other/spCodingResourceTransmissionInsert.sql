 
/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingResourceTransmissionInsert')
	BEGIN
		DROP  Procedure  spCodingResourceTransmissionInsert
	END

GO

CREATE Procedure dbo.spCodingResourceTransmissionInsert
	(
		@Content NVARCHAR(max),
		@SourceSystemID INT,
		@Created DATETIME OUTPUT,
		@Updated DATETIME OUTPUT,
		@CodingResourceTransmissionID BIGINT OUTPUT
	)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO CodingResourceTransmission (
	    Content,
		SourceSystemID,
		Created,
		Updated
	) VALUES (  
	    @Content,
		@SourceSystemID,
		@Created,
		@Updated
	)
	
	SET @CodingResourceTransmissionID = SCOPE_IDENTITY()  	
	
END
GO
