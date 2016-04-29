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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternInsert')
	DROP PROCEDURE spSegmentedGroupCodingPatternInsert
GO

CREATE PROCEDURE dbo.spSegmentedGroupCodingPatternInsert 
(
	@SegmentedGroupCodingPatternID BIGINT OUTPUT,
	@CodingElementGroupID BIGINT,
	@CodingPatternID BIGINT,
	@MatchPercent DECIMAL,

	@SynonymStatus TINYINT,
	@Active BIT,
	@IsExactMatch BIT,

	@SynonymManagementID INT,
    @UserId INT,
	@CacheVersion BIGINT,
	
	@Created DATETIME OUTPUT,  
	@Updated DATETIME OUTPUT,
	@SegmentID INT
)  
AS  
BEGIN

	DECLARE @UtcDate DATETIME  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, 
		@Updated = @UtcDate  

	INSERT INTO dbo.SegmentedGroupCodingPatterns (  
		CodingElementGroupID,
		CodingPatternID,
		SynonymStatus,
		MatchPercent,
		
		SynonymManagementID,
		UserId,
		CacheVersion,

		Active,
		IsExactMatch,
		SegmentID,

		Created,  
		Updated  
	 ) 
	 VALUES (  
		@CodingElementGroupID,
		@CodingPatternID,
		@SynonymStatus,
		@MatchPercent,

		@SynonymManagementID,
		@UserId,
		@CacheVersion,

		@Active,
		@IsExactMatch,
		@SegmentID,

		@UtcDate,  
		@UtcDate  
	 )
	 
	 SET @SegmentedGroupCodingPatternID = SCOPE_IDENTITY()
	 
END

GO