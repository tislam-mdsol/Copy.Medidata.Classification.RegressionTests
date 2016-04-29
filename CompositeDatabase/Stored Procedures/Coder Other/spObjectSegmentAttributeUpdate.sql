  /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/ 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spObjectSegmentAttributeUpdate')
	DROP PROCEDURE dbo.spObjectSegmentAttributeUpdate
GO

CREATE PROCEDURE dbo.spObjectSegmentAttributeUpdate (
	@ObjectSegmentID int, 
	@Tag varchar(50), 
	@Value nvarchar(200),
	@ObjectSegmentAttributeID bigint,
	@Updated datetime output  
)
AS

BEGIN
	DECLARE @UtcDate DATETIME
	SET @UtcDate = GetUtcDate()  
	SELECT @Updated = @UtcDate  

	UPDATE dbo.ObjectSegmentAttributes 
	SET ObjectSegmentID = @ObjectSegmentID,
		Tag = @Tag,
		Value = @Value,
		Updated = @Updated
	WHERE @ObjectSegmentAttributeID = ObjectSegmentAttributeID

END
GO