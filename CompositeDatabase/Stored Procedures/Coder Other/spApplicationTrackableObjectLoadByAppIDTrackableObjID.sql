﻿ /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationTrackableObjectLoadByAppIDTrackableObjID')
	BEGIN
		DROP  Procedure  spApplicationTrackableObjectLoadByAppIDTrackableObjID
	END

GO

CREATE PROCEDURE dbo.spApplicationTrackableObjectLoadByAppIDTrackableObjID 
(
	@ApplicationID INT,
	@TrackableObjectID BIGINT
)  
AS  
  
BEGIN  

SELECT *
	FROM ApplicationTrackableObject
	WHERE
		Deleted = 0
		AND ApplicationID = @ApplicationID
		AND TrackableObjectID = @TrackableObjectID

END

GO
