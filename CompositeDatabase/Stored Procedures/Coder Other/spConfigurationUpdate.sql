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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spConfigurationUpdate')
	DROP PROCEDURE spConfigurationUpdate
GO
CREATE PROCEDURE dbo.spConfigurationUpdate
(
	@ID INT,

	 -- state control
	 @CacheVersion BIGINT,
	 @NewCacheVersion BIGINT,
	 @WasUpdated BIT OUTPUT,	
	
	@ConfigValue VARCHAR(2000),
	@Updated DATETIME OUTPUT,
	@SegmentID INT
)
AS
	SELECT @Updated = GetUtcDate()  
	
	UPDATE Configuration
	SET
	    CacheVersion = @NewCacheVersion,
		ConfigValue = @ConfigValue,
		Updated = @Updated
	 WHERE ID = @ID	
		AND CacheVersion = @CacheVersion
		
	 -- check if we updated
	 IF (@@ROWCOUNT = 0)
		SET @WasUpdated = 0
	 ELSE
		SET @WasUpdated = 1

GO  
