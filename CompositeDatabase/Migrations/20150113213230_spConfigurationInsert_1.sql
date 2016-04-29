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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spConfigurationInsert')
	DROP PROCEDURE spConfigurationInsert
GO
CREATE PROCEDURE dbo.spConfigurationInsert
(
	@ConfigValue VARCHAR(2000),
	@Tag VARCHAR(64),
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@CacheVersion BIGINT,
	@ID INT OUTPUT,
	@SegmentID INT
)
AS
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
	INSERT INTO Configuration (  
		Tag,
		ConfigValue,
		SegmentID,
		CacheVersion,

		Created,
		Updated
	) VALUES ( 
		@Tag,
		@ConfigValue,
		@SegmentID,
		@CacheVersion,
		
		@Created,
		@Updated
	)  
	
	SET @ID = SCOPE_IDENTITY()  	

GO  
 