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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationAdminInsert')
	BEGIN
		DROP  Procedure  spApplicationAdminInsert
	END

GO

CREATE Procedure dbo.spApplicationAdminInsert

	(
		@ApplicationID INT,
		@IsCoderApp BIT,
		@IsCronEnabled BIT,
		@Active BIT,
		@Deleted BIT,
		@Created DATETIME OUTPUT,
		@Updated DATETIME OUTPUT,
		@ApplicationAdminID INT OUTPUT
	)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO ApplicationAdmin (  
		ApplicationID,
		IsCoderApp,
		IsCronEnabled,
		Active,
		Deleted,
		Created,
		Updated
	) VALUES (  
		@ApplicationID,
		@IsCoderApp,
		@IsCronEnabled,
		@Active,
		@Deleted,
		@Created,
		@Updated
	)  
	
	SET @ApplicationAdminID = SCOPE_IDENTITY()  	
	
END
GO
