/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spObjectSegmentGetByObject')
	DROP PROCEDURE spObjectSegmentGetByObject
GO
CREATE PROCEDURE dbo.spObjectSegmentGetByObject
(
	@ObjectID INT,
	@ObjectTypeID INT,
	@SegmentId INT
)
AS

	SELECT * 
	FROM ObjectSegments 
	WHERE ObjectTypeID = @ObjectTypeID
		AND ObjectID = @ObjectID
		AND SegmentId = @SegmentId
		AND Deleted = 0
	
GO   