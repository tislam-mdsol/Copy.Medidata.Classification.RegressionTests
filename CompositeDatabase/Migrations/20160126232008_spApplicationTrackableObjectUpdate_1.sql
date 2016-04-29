﻿/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationTrackableObjectUpdate')
	DROP PROCEDURE spApplicationTrackableObjectUpdate
GO

CREATE PROCEDURE dbo.spApplicationTrackableObjectUpdate
(
	@ApplicationTrackableObjectID BIGINT,
	@ApplicationID INT,
	@TrackableObjectID BIGINT,
	@Status NVARCHAR(256),
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE ApplicationTrackableObject
	SET
		ApplicationID = @ApplicationID,  
		TrackableObjectID = @TrackableObjectID,  
		Status = @Status,
		Updated = @Updated
	 WHERE ApplicationTrackableObjectID = @ApplicationTrackableObjectID

END

GO