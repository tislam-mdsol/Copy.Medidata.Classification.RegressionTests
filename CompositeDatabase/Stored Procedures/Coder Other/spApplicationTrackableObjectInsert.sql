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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationTrackableObjectInsert')
	BEGIN
		DROP  Procedure  spApplicationTrackableObjectInsert
	END

GO

CREATE Procedure dbo.spApplicationTrackableObjectInsert

	(
		@ApplicationID INT,
		@TrackableObjectID BIGINT,
		@Status NVARCHAR(256),			
		@Active BIT,
		@Deleted BIT,
		@Created DATETIME OUTPUT,
		@Updated DATETIME OUTPUT,		
		@ApplicationTrackableObjectID BIGINT OUTPUT
	)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO ApplicationTrackableObject (  
		ApplicationID,
		TrackableObjectID,
		Status,		
		Active,
		Deleted,
		Created,
		Updated
	) VALUES (  
		@ApplicationID,
		@TrackableObjectID,
		@Status,		
		@Active,
		@Deleted,
		@Created,
		@Updated
	)  
	
	SET @ApplicationTrackableObjectID = SCOPE_IDENTITY()  	
	
END
GO
