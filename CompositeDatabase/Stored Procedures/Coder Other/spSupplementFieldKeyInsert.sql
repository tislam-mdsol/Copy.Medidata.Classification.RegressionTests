/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSupplementFieldKeyInsert')
	DROP PROCEDURE spSupplementFieldKeyInsert
GO
CREATE PROCEDURE dbo.spSupplementFieldKeyInsert
(
	@KeyField NVARCHAR(450),
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@SupplementFieldKeyID INT OUTPUT
)
AS	

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO SupplementFieldKeys (  
		KeyField
	) VALUES (  
		@KeyField
	)  
	
	SET @SupplementFieldKeyID = SCOPE_IDENTITY()  	
END
GO  