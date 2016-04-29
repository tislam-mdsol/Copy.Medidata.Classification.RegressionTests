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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationTypeInsert')
	BEGIN
		DROP  Procedure  spApplicationTypeInsert
	END

GO

CREATE Procedure dbo.spApplicationTypeInsert
	(
		@IMedidataId NVARCHAR(50),
		@Name NVARCHAR(256),
		@IsCoderAppType BIT,
		@Active BIT,
		@Deleted BIT,
		@IsAlwaysBypassTransmit BIT,
		@Created DATETIME OUTPUT,
		@Updated DATETIME OUTPUT,
		@ApplicationTypeID INT OUTPUT
	)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO ApplicationType (  
		IMedidataId,
		Name,
		IsCoderAppType,
		Active,
		Deleted,
		IsAlwaysBypassTransmit,
		Created,
		Updated
	) VALUES (  
		@IMedidataId,
		@Name,
		@IsCoderAppType,
		@Active,
		@Deleted,
		@IsAlwaysBypassTransmit,
		@Created,
		@Updated
	)  
	
	SET @ApplicationTypeID = SCOPE_IDENTITY()  	
	
END
GO
